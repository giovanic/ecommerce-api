module Api
  module V1
    class OrdersController < Api::V1::BaseController
      before_action :set_order, only: [:show, :update_status]

      def index
        orders = Order.includes(:order_items, :products)
                     .where(account_id: current_account.id)
                     .recent
                     .page(params[:page] || 1)
                     .per(params[:per_page] || 20)

        render json: {
          orders: orders.as_json(include: { order_items: { include: :product } }),
          meta: {
            current_page: orders.current_page,
            total_pages: orders.total_pages,
            total_count: orders.total_count
          }
        }, status: :ok
      end

      def show
        render json: @order.as_json(include: { order_items: { include: :product } }), status: :ok
      end

      def create
        result = Order::Operation::Create.call(params: order_params.merge(account_id: current_account.id))
        
        if result.success?
          OrderConfirmationJob.perform_later(result[:order].id)
          render json: result[:order].as_json(include: { order_items: { include: :product } }), status: :created
        else
          render json: { error: 'Failed to create order' }, status: :unprocessable_entity
        end
      end

      def update_status
        if @order.update(status: params[:status])
          render json: @order, status: :ok
        else
          render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_order
        @order = Order.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Order not found' }, status: :not_found
      end

      def order_params
        params.require(:order).permit(:cart_id, :tenant_id, :shipping_address, :payment_method)
      end

      def current_account
        # Implementar lógica de autenticação do Rodauth
        Account.first # Placeholder
      end
    end
  end
end
