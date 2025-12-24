class CartSerializer
  def self.as_json(cart)
    {
      id: cart.id,
      items: cart.cart_items.includes(:product).map do |item|
        {
          id: item.id,
          product: {
            id: item.product.id,
            name: item.product.name,
            price: item.product.price.to_f,
            images: item.product.images,
            stock_quantity: item.product.stock_quantity
          },
          quantity: item.quantity,
          price: item.price.to_f,
          subtotal: item.subtotal.to_f
        }
      end,
      total_items: cart.total_items,
      total_price: cart.total_price.to_f,
      created_at: cart.created_at,
      updated_at: cart.updated_at
    }
  end
end
