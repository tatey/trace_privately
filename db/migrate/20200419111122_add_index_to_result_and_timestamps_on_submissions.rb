class AddIndexToResultAndTimestampsOnSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_index :submissions, :result
    add_index :submissions, :created_at
    add_index :submissions, :updated_at
  end
end
