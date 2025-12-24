module Cart::Operation
  class AddItem < Trailblazer::Operation
    step :find_or_create_cart!
    step :find_product!
    step :add_item!

    def find_or_create_cart!(ctx, params:, **)
      ctx[:cart] = if params[:account_id]
        Cart.find_or_create_by(account_id: params[:account_id])
      else
        Cart.find_or_create_by(session_id: params[:session_id])
      end
    end

    def find_product!(ctx, params:, **)
      ctx[:product] = Product.find_by(id: params[:product_id])
      ctx[:product].present?
    end

    def add_item!(ctx, cart:, product:, params:, **)
      cart.add_product(product, params[:quantity] || 1)
    end
  end
end
