class CreateInfectedKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :infected_keys do |t|
      t.text :data, null: false
      t.timestamps index: true
    end
  end
end
