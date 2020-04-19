class RemoveTimestampsFromInfectedKeys < ActiveRecord::Migration[6.0]
  def change
    remove_column :infected_keys, :created_at
    remove_column :infected_keys, :updated_at
  end
end
