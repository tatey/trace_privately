require 'test_helper'

class Api::AccessGrantsControllerTest < ActionDispatch::IntegrationTest
  def default_options
    {as: :json}
  end

  test "requesting access" do
    post "/api/auth", default_options
    assert_response :ok
    assert_equal "OK", response.parsed_body["status"]
    assert_equal AccessGrant.last.token, response.parsed_body["token"]
    assert_equal AccessGrant.last.expired_at.to_s(:iso8601), response.parsed_body["expires_at"]
  end
end
