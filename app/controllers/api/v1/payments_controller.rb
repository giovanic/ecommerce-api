module Api
  module V1
    class PaymentsController < Api::V1::BaseController
      def create_stripe_intent
        order = Order.find(params[:order_id])
        
        result = StripeService.new(order).create_payment_intent
        
        if result[:success]
          render json: { client_secret: result[:client_secret] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Order not found' }, status: :not_found
      end

      def create_mercado_pago_preference
        order = Order.find(params[:order_id])
        
        result = MercadoPagoService.new(order).create_preference
        
        if result[:success]
          render json: { preference_id: result[:preference_id], init_point: result[:init_point] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Order not found' }, status: :not_found
      end

      def webhook_stripe
        payload = request.body.read
        sig_header = request.env['HTTP_STRIPE_SIGNATURE']
        
        result = StripeService.handle_webhook(payload, sig_header)
        
        if result[:success]
          head :ok
        else
          head :bad_request
        end
      end

      def webhook_mercado_pago
        result = MercadoPagoService.handle_webhook(params)
        
        if result[:success]
          head :ok
        else
          head :bad_request
        end
      end
    end
  end
end
