module Product::Contract
  class Create < Reform::Form
    property :name
    property :description
    property :price
    property :sku
    property :stock_quantity
    property :category_id
    property :tenant_id
    property :images
    property :active

    validates :name, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :tenant_id, presence: true
    validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  end
end
