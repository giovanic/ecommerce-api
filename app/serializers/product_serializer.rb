class ProductSerializer
  def self.as_json(product)
    {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price.to_f,
      sku: product.sku,
      stock_quantity: product.stock_quantity,
      images: product.images || [],
      active: product.active,
      category: product.category ? {
        id: product.category.id,
        name: product.category.name,
        slug: product.category.slug
      } : nil,
      tenant: {
        id: product.tenant.id,
        name: product.tenant.name
      },
      created_at: product.created_at,
      updated_at: product.updated_at
    }
  end

  def self.collection_as_json(products)
    products.map { |product| as_json(product) }
  end
end
