class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants, id: :uuid do |t|
      t.string :name, null: false
      t.string :subdomain, null: false
      t.json :settings, default: {}
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :tenants, :subdomain, unique: true
  end
end
