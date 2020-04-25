class AddIdentifierToSubmissions < ActiveRecord::Migration[6.0]
  def up
    add_column :submissions, :identifier, :string, limit: 36
    add_index :submissions, :identifier, unique: true
  end

  def down
    remove_index :submissions, :identifier
    remove_column :submissions, :identifier
  end
end
