class SetRollingStartNumberOnInfectedKeysToBeNotNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :infected_keys, :rolling_start_number, false
  end
end
