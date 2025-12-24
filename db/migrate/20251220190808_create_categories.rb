class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.references :tenant, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :categories, [:tenant_id, :slug], unique: true
  end
end
