require 'test_helper'

class Api::InfectedKeysControllerTest < ActionDispatch::IntegrationTest
  def default_options
    {headers: {"Authorization" => "Bearer #{access_grants(:current).token}"}, as: :json}
  end

  def setup
    Submission.destroy_all
    assert Submission.count.zero?
  end

  test "getting infected keys when there are none" do
    get "/api/infected", default_options
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_empty response.parsed_body["keys"]
    assert_empty response.parsed_body["deleted_keys"]
  end

  test "getting positively infected keys" do
    submission = Submission.positive.create!
    submission.infected_keys.create!(data: "A", rolling_start_number: 1)
    submission.infected_keys.create!(data: "B", rolling_start_number: 2)

    get "/api/infected", default_options
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal submission.updated_at.to_s(:iso8601), response.parsed_body["date"]
    submission.infected_keys.each do |key|
      assert_includes response.parsed_body["keys"], {"d" => key.data, "r" => key.rolling_start_number, "l" => key.risk_level}
    end
    assert_empty response.parsed_body["deleted_keys"]
  end

  test "getting positively infected keys since a given timestamp" do
    submission1 = Submission.positive.create!(updated_at: Time.zone.local(2020, 4, 19, 20, 41))
    submission1.infected_keys.create!(data: "A", rolling_start_number: 1)
    submission1.infected_keys.create!(data: "B", rolling_start_number: 2)

    submission2 = Submission.positive.create!(updated_at: Time.zone.local(2020, 4, 19, 20, 39))
    submission2.infected_keys.create!(data: "C", rolling_start_number: 1)
    submission2.infected_keys.create!(data: "D", rolling_start_number: 2)

    get "/api/infected", default_options.merge(params: {since: Time.zone.local(2020, 4, 19, 20, 40).to_s(:iso8601)})
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal submission1.updated_at.to_s(:iso8601), response.parsed_body["date"]
    submission1.infected_keys.each do |key|
      assert_includes response.parsed_body["keys"], {"d" => key.data, "r" => key.rolling_start_number, "l" => key.risk_level}
    end
    submission2.infected_keys.each do |key|
      assert_not_includes response.parsed_body["keys"], {"d" => key.data, "r" => key.rolling_start_number, "l" => key.risk_level}
    end
    assert_empty response.parsed_body["deleted_keys"]
  end

  test "getting negatively infected keys" do
    submission = Submission.negative.create!
    submission.infected_keys.create!(data: "A", rolling_start_number: 1)
    submission.infected_keys.create!(data: "B", rolling_start_number: 2)

    get "/api/infected", default_options
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal submission.updated_at.to_s(:iso8601), response.parsed_body["date"]
    assert_empty response.parsed_body["keys"]
    submission.infected_keys.each do |key|
      assert_includes response.parsed_body["deleted_keys"], {"d" => key.data, "r" => key.rolling_start_number, "l" => key.risk_level}
    end
  end

  test "getting negatively infected keys since a given timestamp" do
    submission1 = Submission.negative.create!(updated_at: Time.zone.local(2020, 4, 19, 20, 41))
    submission1.infected_keys.create!(data: "A", rolling_start_number: 1)
    submission1.infected_keys.create!(data: "B", rolling_start_number: 2)

    submission2 = Submission.negative.create!(updated_at: Time.zone.local(2020, 4, 19, 20, 39))
    submission2.infected_keys.create!(data: "C", rolling_start_number: 1)
    submission2.infected_keys.create!(data: "D", rolling_start_number: 2)

    get "/api/infected", default_options.merge(params: {since: Time.zone.local(2020, 4, 19, 20, 40).to_s(:iso8601)})
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_empty response.parsed_body["keys"]
    assert_equal submission1.updated_at.to_s(:iso8601), response.parsed_body["date"]
    submission1.infected_keys.each do |key|
      assert_includes response.parsed_body["deleted_keys"], {"d" => key.data, "r" => key.rolling_start_number, "l" => key.risk_level}
    end
    submission2.infected_keys.each do |key|
      assert_not_includes response.parsed_body["deleted_keys"], {"d" => key.data, "r" => key.rolling_start_number, "l" => key.risk_level}
    end
  end

  test "getting infected keys is limited to a maximum of 21 days ago" do
    submission1 = Submission.positive.create!(expired_at: 2.days.ago)
    submission1.infected_keys.create!(data: "A", rolling_start_number: 1)
    submission1.infected_keys.create!(data: "B", rolling_start_number: 2)

    submission2 = Submission.positive.create!(expired_at: 2.days.from_now)
    submission2.infected_keys.create!(data: "C", rolling_start_number: 1)
    submission2.infected_keys.create!(data: "D", rolling_start_number: 2)

    get "/api/infected", default_options.merge(params: {since: Time.current.to_s(:iso8601)})
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal submission2.updated_at.to_s(:iso8601), response.parsed_body["date"]
    submission2.infected_keys.each do |key|
      assert_includes response.parsed_body["keys"], {"d" => key.data, "r" => key.rolling_start_number, "l" => key.risk_level }
    end
    assert_empty response.parsed_body["deleted_keys"]
  end

  test "submitting infected keys" do
    assert_difference -> { Submission.count } => 1, -> { InfectedKey.count } => 3 do
      post "/api/submit", default_options.merge(params: {keys: [{d: "A", r: 1, l: 1,}, {d: "B", r: 2, l: 1}, {d: "C", r: 3, l: 1}]})
    end
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal Submission.last.identifier, response.parsed_body["identifier"]
    assert Submission.last.pending?
  end

  test "submitting a duplicate infected key" do
    assert_raises ActiveRecord::RecordInvalid do
      post "/api/submit", default_options.merge(params: {keys: [{d: "A", r: 1, l: 1}, {d: "A", r: 1, l: 1}, {d: "B", r: 2, l: 2}]})
    end
  end

  test "submitting a blank infected key" do
    assert_raises ActiveRecord::RecordInvalid do
      post "/api/submit", default_options.merge(params: {keys: [{d: "", r: "", l: ""}, {d: "B", r: 2, l: 2}, {d: "C", r: 3, l: 3}]})
    end
  end
end
