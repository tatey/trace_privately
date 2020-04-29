require 'test_helper'

class AccessGrantTest < ActiveSupport::TestCase
  test "expires 7 days from when access is granted" do
    epoch = Time.zone.local(2020, 04, 26)
    travel_to(epoch) do
      access_grant = AccessGrant.create!
      assert_equal epoch.advance(days: 7), access_grant.expired_at
    end
  end

  test "filtering current and expired submissions" do
    AccessGrant.destroy_all
    assert AccessGrant.count.zero?

    epoch = Time.zone.local(2020, 04, 26)
    current = AccessGrant.create!
    current.update!(expired_at: epoch + 1.second)
    expired = AccessGrant.create!
    expired.update!(expired_at: epoch - 1.second)

    travel_to(epoch) do
      assert_equal [current], AccessGrant.current
      assert_equal [expired], AccessGrant.expired
    end
  end
end
