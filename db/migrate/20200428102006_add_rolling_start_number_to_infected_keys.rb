class AddRollingStartNumberToInfectedKeys < ActiveRecord::Migration[6.0]
  def change
    add_column :infected_keys, :rolling_start_number, :integer
  end
end
