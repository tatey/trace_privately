class Submission < ApplicationRecord
  has_many :infected_keys, dependent: :destroy

  enum result: [:pending, :positive, :negative]
end
