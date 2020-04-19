class CreateSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :submissions do |t|
      t.integer :result, default: 0, null: false
      t.timestamps
    end
  end
end
