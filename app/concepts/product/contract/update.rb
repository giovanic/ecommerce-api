module Product::Contract
  class Update < Reform::Form
    property :name
    property :description
    property :price
    property :sku
    property :stock_quantity
    property :category_id
    property :images
    property :active

    validates :price, numericality: { greater_than_or_equal_to: 0 }, if: -> { price.present? }
    validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }, if: -> { stock_quantity.present? }
  end
end
