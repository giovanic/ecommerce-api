class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts, id: :uuid do |t|
      t.references :account, null: true, foreign_key: true
      t.string :session_id

      t.timestamps
    end
    add_index :carts, :session_id, unique: true, where: "session_id IS NOT NULL"
  end
end
