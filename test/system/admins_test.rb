require "application_system_test_case"

class AdminsTest < ApplicationSystemTestCase
  test "visiting the index" do
    submission_number = submissions(:pending).number

    visit admin_submissions_url
    assert_text "Pending"

    click_on submission_number
    assert_text "Test result is pending"

    select "negative", from: "Confirm result is"
    click_on "Update Submission"
    assert_text "#{submission_number} has been updated"
    assert_text "Test result is negative"

    click_on "Submissions"
    assert_no_text "Pending"
  end
end
