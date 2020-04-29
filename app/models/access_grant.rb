class AccessGrant < ApplicationRecord
  has_secure_token

  before_create :expires_7_days_from_now

  scope :current, -> { where("expired_at >= ?", Time.current) }
  scope :expired, -> { where("expired_at < ?", Time.current) }

  private

  def expires_7_days_from_now
    self.expired_at = 7.days.from_now
  end
end
