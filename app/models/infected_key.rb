class InfectedKey < ApplicationRecord
  belongs_to :submission

  validates :data, presence: true
end
