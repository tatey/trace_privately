class InfectedKey < ApplicationRecord
  belongs_to :submission

  validates_associated :submission
  validates :data, presence: true, uniqueness: {scope: :submission_id}
end
