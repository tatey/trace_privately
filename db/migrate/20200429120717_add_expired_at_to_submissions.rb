class AddExpiredAtToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :expired_at, :datetime
    add_index :submissions, :expired_at
  end
end
