class CreateAccessGrants < ActiveRecord::Migration[6.0]
  def change
    create_table :access_grants do |t|
      t.string :token, null: false
      t.datetime :expired_at, null: false

      t.timestamps
    end

    add_index :access_grants, :token, unique: true
    add_index :access_grants, :expired_at
  end
end
