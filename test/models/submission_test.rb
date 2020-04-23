require "test_helper"

class SubmissionTest < ActiveSupport::TestCase
  test "number" do
    assert_equal "#0000000001", Submission.new(id: 1).number
    assert_equal "#9999999999", Submission.new(id: 9999999999).number
  end
end
