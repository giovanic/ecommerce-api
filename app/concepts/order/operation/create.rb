module Order::Operation
  class Create < Trailblazer::Operation
    step :model!
    step :validate_cart!
    step :create_order!
    step :create_order_items!
    step :update_stock!
    step :clear_cart!

    def model!(ctx, params:, **)
      ctx[:cart] = Cart.find_by(id: params[:cart_id])
      ctx[:cart].present? && ctx[:cart].cart_items.any?
    end

    def validate_cart!(ctx, cart:, **)
      cart.cart_items.all? { |item| item.product.in_stock? && item.product.stock_quantity >= item.quantity }
    end

    def create_order!(ctx, params:, cart:, **)
      ctx[:order] = Order.create!(
        account_id: params[:account_id],
        tenant_id: params[:tenant_id],
        total_amount: cart.total_price,
        shipping_address: params[:shipping_address],
        payment_method: params[:payment_method],
        status: :pending,
        payment_status: :unpaid
      )
    end

    def create_order_items!(ctx, order:, cart:, **)
      cart.cart_items.each do |cart_item|
        OrderItem.create!(
          order: order,
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.price
        )
      end
      true
    end

    def update_stock!(ctx, cart:, **)
      cart.cart_items.each do |cart_item|
        cart_item.product.reduce_stock(cart_item.quantity)
      end
      true
    end

    def clear_cart!(ctx, cart:, **)
      cart.cart_items.destroy_all
      true
    end
  end
end
