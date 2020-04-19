class InfectedKey < ApplicationRecord
  validates :data, presence: true

  scope :recent, -> { order(updated_at: :desc) }
  scope :since, -> (at) { where("updated_at >= ?", at) }
end
