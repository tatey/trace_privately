require "test_helper"

class SubmissionTest < ActiveSupport::TestCase
  test "expires 21 days from when the submission is made" do
    epoch = Time.zone.local(2020, 04, 26)
    travel_to(epoch) do
      submission = Submission.create!
      assert_equal epoch.advance(days: 21), submission.expired_at
    end
  end

  test "filtering current and expired submissions" do
    Submission.destroy_all
    assert Submission.count.zero?

    epoch = Time.zone.local(2020, 04, 26)
    current = Submission.create!
    current.update!(expired_at: epoch + 1.second)
    expired = Submission.create!
    expired.update!(expired_at: epoch - 1.second)

    travel_to(epoch) do
      assert_equal [current], Submission.current
      assert_equal [expired], Submission.expired
    end
  end

  test "validates maximum number of infected keys" do
    submission = Submission.create!
    21.times do |n|
      submission.infected_keys.create!(data: n, rolling_start_number: n)
    end
    submission.infected_keys.build(data: 22, rolling_start_number: 22)
    assert_not submission.valid?
    assert_not submission.errors[:infected_keys].empty?
  end

  test "number" do
    assert_equal "#0000000001", Submission.new(id: 1).number
    assert_equal "#9999999999", Submission.new(id: 9999999999).number
  end
end
