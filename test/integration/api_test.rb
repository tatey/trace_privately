require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  def setup
    Submission.destroy_all
    assert Submission.count.zero?
  end

  test "getting infected keys when there are none" do
    get "/api/infected", as: :json
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_empty response.parsed_body["keys"]
    assert_empty response.parsed_body["deleted_keys"]
  end

  test "getting positively infected keys" do
    submission = Submission.positive.create!
    submission.infected_keys.create!(data: "A")
    submission.infected_keys.create!(data: "B")

    get "/api/infected", as: :json
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal submission.updated_at.to_s(:iso8601), response.parsed_body["date"]
    submission.infected_keys.each do |key|
      assert_includes response.parsed_body["keys"], key.data
    end
    assert_empty response.parsed_body["deleted_keys"]
  end

  test "getting positively infected keys since a given timestamp" do
    submission1 = Submission.positive.create!(updated_at: Time.zone.local(2020, 4, 19, 20, 41))
    submission1.infected_keys.create!(data: "A")
    submission1.infected_keys.create!(data: "B")

    submission2 = Submission.positive.create!(updated_at: Time.zone.local(2020, 4, 19, 20, 39))
    submission2.infected_keys.create!(data: "C")
    submission2.infected_keys.create!(data: "D")

    get "/api/infected", params: {since: Time.zone.local(2020, 4, 19, 20, 40)}, as: :json
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal submission1.updated_at.to_s(:iso8601), response.parsed_body["date"]
    submission1.infected_keys.each do |key|
      assert_includes response.parsed_body["keys"], key.data
    end
    assert_empty response.parsed_body["deleted_keys"]
  end

  test "getting negatively infected keys" do
    submission = Submission.negative.create!
    submission.infected_keys.create!(data: "A")
    submission.infected_keys.create!(data: "B")

    get "/api/infected", as: :json
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal submission.updated_at.to_s(:iso8601), response.parsed_body["date"]
    assert_empty response.parsed_body["keys"]
    submission.infected_keys.each do |key|
      assert_includes response.parsed_body["deleted_keys"], key.data
    end
    submission.infected_keys.each do |key|
      assert_includes response.parsed_body["deleted_keys"], key.data
    end
  end

  test "getting negatively infected keys since a given timestamp" do
    submission1 = Submission.negative.create!(updated_at: Time.zone.local(2020, 4, 19, 20, 41))
    submission1.infected_keys.create!(data: "A")
    submission1.infected_keys.create!(data: "B")

    submission2 = Submission.negative.create!(updated_at: Time.zone.local(2020, 4, 19, 20, 39))
    submission2.infected_keys.create!(data: "C")
    submission2.infected_keys.create!(data: "D")

    get "/api/infected", params: {since: Time.zone.local(2020, 4, 19, 20, 40)}, as: :json
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_empty response.parsed_body["keys"]
    assert_equal submission1.updated_at.to_s(:iso8601), response.parsed_body["date"]
    submission1.infected_keys.each do |key|
      assert_includes response.parsed_body["deleted_keys"], key.data
    end
  end

  test "getting infected keys is limited to a maximum of 30 days ago" do
    submission1 = Submission.positive.create!(updated_at: 32.days.ago)
    submission1.infected_keys.create!(data: "A")
    submission1.infected_keys.create!(data: "B")

    submission2 = Submission.positive.create!(updated_at: 29.days.ago)
    submission2.infected_keys.create!(data: "C")
    submission2.infected_keys.create!(data: "D")

    get "/api/infected", params: {since: 31.days.ago}, as: :json
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal submission2.updated_at.to_s(:iso8601), response.parsed_body["date"]
    submission2.infected_keys.each do |key|
      assert_includes response.parsed_body["keys"], key.data
    end
    assert_empty response.parsed_body["deleted_keys"]
  end

  test "submitting infected keys" do
    assert_difference -> { Submission.count } => 1, -> { InfectedKey.count } => 3 do
      post "/api/submit", params: {keys: ["A", "B", "C"]}, as: :json
    end
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal Submission.last.identifier, response.parsed_body["identifier"]
    assert Submission.last.pending?
  end

  test "submitting a duplicate infected key" do
    assert_raises ActiveRecord::RecordInvalid do
      post "/api/submit", params: {keys: ["A", "A", "B"]}, as: :json
    end
  end

  test "submitting a malformed infected key" do
    assert_raises ActiveRecord::RecordInvalid do
      post "/api/submit", params: {keys: ["", "B", "C"]}, as: :json
    end
  end
end
