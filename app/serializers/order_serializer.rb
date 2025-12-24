class OrderSerializer
  def self.as_json(order, include_items: true)
    result = {
      id: order.id,
      order_number: order.order_number,
      status: order.status,
      payment_status: order.payment_status,
      total_amount: order.total_amount.to_f,
      shipping_address: order.shipping_address,
      payment_method: order.payment_method,
      created_at: order.created_at,
      updated_at: order.updated_at
    }

    if include_items && order.order_items.loaded?
      result[:items] = order.order_items.map do |item|
        {
          id: item.id,
          product: {
            id: item.product.id,
            name: item.product.name,
            images: item.product.images
          },
          quantity: item.quantity,
          price: item.price.to_f,
          subtotal: item.subtotal.to_f
        }
      end
    end

    result
  end

  def self.collection_as_json(orders)
    orders.map { |order| as_json(order, include_items: false) }
  end
end
