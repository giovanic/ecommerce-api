module Api
  module V1
    class CartController < Api::V1::BaseController
      before_action :set_cart

      def show
        render json: {
          cart: @cart.as_json(include: { cart_items: { include: :product } }),
          total_items: @cart.total_items,
          total_price: @cart.total_price
        }, status: :ok
      end

      def add_item
        result = Cart::Operation::AddItem.call(
          params: {
            account_id: current_account&.id,
            session_id: session_id,
            product_id: params[:product_id],
            quantity: params[:quantity]
          }
        )

        if result.success?
          render json: {
            cart: result[:cart].as_json(include: { cart_items: { include: :product } }),
            total_items: result[:cart].total_items,
            total_price: result[:cart].total_price
          }, status: :ok
        else
          render json: { error: 'Failed to add item to cart' }, status: :unprocessable_entity
        end
      end

      def remove_item
        product = Product.find(params[:product_id])
        @cart.remove_product(product)

        render json: {
          cart: @cart.as_json(include: { cart_items: { include: :product } }),
          total_items: @cart.total_items,
          total_price: @cart.total_price
        }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found' }, status: :not_found
      end

      def update_item
        cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
        
        if cart_item && cart_item.update(quantity: params[:quantity])
          render json: {
            cart: @cart.as_json(include: { cart_items: { include: :product } }),
            total_items: @cart.total_items,
            total_price: @cart.total_price
          }, status: :ok
        else
          render json: { error: 'Failed to update cart item' }, status: :unprocessable_entity
        end
      end

      def clear
        @cart.cart_items.destroy_all
        head :no_content
      end

      private

      def set_cart
        @cart = if current_account
          Cart.find_or_create_by(account_id: current_account.id)
        else
          Cart.find_or_create_by(session_id: session_id)
        end
      end

      def current_account
        # Implementar lógica de autenticação do Rodauth
        nil # Placeholder
      end

      def session_id
        session[:cart_session_id] ||= SecureRandom.uuid
      end
    end
  end
end
