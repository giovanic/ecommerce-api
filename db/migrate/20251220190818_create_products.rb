class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :sku
      t.integer :stock_quantity, default: 0, null: false
      t.json :images, default: []
      t.boolean :active, default: true
      t.references :tenant, null: false, foreign_key: true, type: :uuid
      t.references :category, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :products, [:tenant_id, :sku], unique: true, where: "sku IS NOT NULL"
    add_index :products, :active
  end
end
