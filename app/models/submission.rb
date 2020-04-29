class Submission < ApplicationRecord
  has_many :infected_keys, dependent: :destroy

  enum result: [:pending, :positive, :negative]

  before_create :expires_21_days_from_now
  before_create :generate_random_identifier

  scope :by_recently_created_first, -> { order(created_at: :desc) }
  scope :by_recently_changed_first, -> { order(updated_at: :desc) }
  scope :changed_since, -> (since) { where("updated_at >= ?", since) }
  scope :current, -> { where("expired_at >= ?", Time.current) }
  scope :expired, -> { where("expired_at < ?", Time.current) }

  def number
    "#%010d" % id
  end

  private

  def expires_21_days_from_now
    self.expired_at = 21.days.from_now
  end

  def generate_random_identifier
    self.identifier = SecureRandom.uuid
  end
end
