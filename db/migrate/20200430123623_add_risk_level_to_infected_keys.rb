class AddRiskLevelToInfectedKeys < ActiveRecord::Migration[6.0]
  def change
    add_column :infected_keys, :risk_level, :integer, default: 0, null: false # ENRiskLevel.invalid is 0
  end
end
