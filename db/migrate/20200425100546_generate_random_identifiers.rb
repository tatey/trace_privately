class GenerateRandomIdentifiers < ActiveRecord::Migration[6.0]
  def up
    Submission.where(identifier: nil).find_each do |submission|
      submission.update!(identifier: SecureRandom.uuid)
    end
  end
end
