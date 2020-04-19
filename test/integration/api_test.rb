require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  test "getting infected keys when the table is empty" do
    assert_equal 0, InfectedKey.count
    get "/api/infected", as: :json
    assert_response :ok
    assert_equal("OK", response.parsed_body["status"])
  end

  test "getting infected keys" do
    submission = Submission.create!
    one = submission.infected_keys.create!(data: "1")
    two = submission.infected_keys.create!(data: "2")

    get "/api/infected", as: :json
    assert_response :ok
    assert_equal("OK", response.parsed_body["status"])
    assert_equal(two.updated_at.to_s(:iso8601), response.parsed_body["date"])
    assert_equal([two.data, one.data], response.parsed_body["keys"])
  end

  test "getting infected keys since a given timestamp" do
    submission = Submission.create!
    one = submission.infected_keys.create!(data: "1", updated_at: Time.zone.local(2020, 4, 19, 10, 43))
    two = submission.infected_keys.create!(data: "2", updated_at: Time.zone.local(2020, 4, 19, 10, 41))

    get "/api/infected", params: {since: Time.zone.local(2020, 4, 19, 10, 42)}, as: :json
    assert_response :ok
    assert_equal("OK", response.parsed_body["status"])
    assert_equal(one.updated_at.to_s(:iso8601), response.parsed_body["date"])
    assert_equal([one.data], response.parsed_body["keys"])
  end

  test "submitting infected keys" do
    assert_difference -> { Submission.count } => 1, -> { InfectedKey.count } => 3 do
      post "/api/submit", params: {keys: ["A", "B", "C"]}, as: :json
    end
    assert_response :ok
    assert_equal("OK", response.parsed_body["status"])
    assert Submission.last.pending?
  end

  test "submitting a malformed infected key" do
    assert_raises ActiveRecord::RecordInvalid do
      post "/api/submit", params: {keys: ["", "2", "3"]}, as: :json
    end
  end
end
