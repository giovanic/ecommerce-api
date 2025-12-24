module Product::Representer
  class Show < Representable::Decorator
    include Representable::JSON

    property :id
    property :name
    property :description
    property :price
    property :sku
    property :stock_quantity
    property :images
    property :active
    property :created_at
    property :updated_at
    
    nested :category do
      property :id
      property :name
      property :slug
    end

    nested :tenant do
      property :id
      property :name
    end
  end
end
