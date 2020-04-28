class BackfillRollingStartNumbers < ActiveRecord::Migration[6.0]
  def up
    InfectedKey.where(rolling_start_number: nil).update_all(rolling_start_number: 0)
  end

  def down
  end
end
