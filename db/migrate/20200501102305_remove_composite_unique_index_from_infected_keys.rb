class RemoveCompositeUniqueIndexFromInfectedKeys < ActiveRecord::Migration[6.0]
  def change
    remove_index :infected_keys, [:data, :submission_id]
  end
end
