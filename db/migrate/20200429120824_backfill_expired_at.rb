class BackfillExpiredAt < ActiveRecord::Migration[6.0]
  def up
    Submission.transaction do
      Submission.where(expired_at: nil).find_each do |submission|
        submission.update!(expired_at: submission.created_at.advance(days: 21))
      end
    end
  end

  def down
  end
end
