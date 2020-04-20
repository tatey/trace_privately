class Submission < ApplicationRecord
  has_many :infected_keys, dependent: :destroy

  enum result: [:pending, :positive, :negative]

  scope :by_recently_created_first, -> { order(created_at: :desc) }
  scope :by_recently_changed_first, -> { order(updated_at: :desc) }
  scope :changed_since, -> (since) { where("updated_at >= ?", since) }
end
