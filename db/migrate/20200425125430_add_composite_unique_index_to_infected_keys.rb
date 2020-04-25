class AddCompositeUniqueIndexToInfectedKeys < ActiveRecord::Migration[6.0]
  def change
    add_index :infected_keys, [:data, :submission_id], unique: true
  end
end
