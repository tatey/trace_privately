class Submission < ApplicationRecord
  has_many :infected_keys, dependent: :destroy

  enum result: [:pending, :positive, :negative]

  scope :recent, -> { order(updated_at: :desc) }
  scope :since, -> (at) { where("updated_at >= ?", at) }
end
