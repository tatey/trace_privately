class Submission < ApplicationRecord
  has_many :infected_keys, dependent: :destroy

  enum result: [:pending, :positive, :negative]

  scope :recent, -> { order(updated_at: :desc) }
  scope :changed_since, -> (since) { where("updated_at >= ?", since) }
end
