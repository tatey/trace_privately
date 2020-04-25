class Submission < ApplicationRecord
  has_many :infected_keys, dependent: :destroy

  enum result: [:pending, :positive, :negative]

  before_create :generate_random_identifier

  scope :by_recently_created_first, -> { order(created_at: :desc) }
  scope :by_recently_changed_first, -> { order(updated_at: :desc) }
  scope :changed_since, -> (since) { where("updated_at >= ?", since) }

  def number
    "#%010d" % id
  end

  private

  def generate_random_identifier
    self.identifier = SecureRandom.uuid
  end
end
