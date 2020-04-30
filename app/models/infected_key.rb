class InfectedKey < ApplicationRecord
  belongs_to :submission

  validates_associated :submission
  validates :data, presence: true, uniqueness: {scope: :submission_id}
  validates :rolling_start_number, numericality: {only_integer: true}
  validates :risk_level, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100, only_integer: true}
end
