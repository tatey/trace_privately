require 'test_helper'

class Admin::SubmissionsControllerTest < ActionDispatch::IntegrationTest
  test "index" do
    get admin_submissions_path
    assert_response :ok
  end
end
