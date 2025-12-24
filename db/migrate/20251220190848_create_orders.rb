class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true, type: :uuid
      t.string :order_number, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.integer :status, default: 0, null: false
      t.integer :payment_status, default: 0, null: false
      t.text :shipping_address, null: false
      t.string :payment_method
      t.json :payment_details, default: {}

      t.timestamps
    end
    add_index :orders, :order_number, unique: true
    add_index :orders, [:account_id, :created_at]
    add_index :orders, :status
  end
end
