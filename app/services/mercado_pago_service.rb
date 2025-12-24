class MercadoPagoService
  def initialize(order)
    @order = order
    @sdk = Mercadopago::SDK.new(Rails.application.credentials.dig(:mercado_pago, :access_token))
  end

  def create_preference
    begin
      preference_data = {
        items: @order.order_items.map do |item|
          {
            title: item.product.name,
            quantity: item.quantity,
            unit_price: item.price.to_f
          }
        end,
        payer: {
          email: @order.account.email
        },
        external_reference: @order.order_number,
        notification_url: "#{ENV['APP_URL']}/api/v1/payments/webhook_mercado_pago",
        back_urls: {
          success: "#{ENV['FRONTEND_URL']}/orders/#{@order.id}/success",
          failure: "#{ENV['FRONTEND_URL']}/orders/#{@order.id}/failure",
          pending: "#{ENV['FRONTEND_URL']}/orders/#{@order.id}/pending"
        },
        auto_return: 'approved'
      }

      preference_response = @sdk.preference.create(preference_data)
      preference = preference_response[:response]

      {
        success: true,
        preference_id: preference['id'],
        init_point: preference['init_point']
      }
    rescue => e
      { success: false, error: e.message }
    end
  end

  def self.handle_webhook(params)
    begin
      case params[:type]
      when 'payment'
        handle_payment_notification(params[:data][:id])
      end

      { success: true }
    rescue => e
      { success: false, error: e.message }
    end
  end

  private

  def self.handle_payment_notification(payment_id)
    sdk = Mercadopago::SDK.new(Rails.application.credentials.dig(:mercado_pago, :access_token))
    payment_response = sdk.payment.get(payment_id)
    payment = payment_response[:response]

    order = Order.find_by(order_number: payment['external_reference'])
    return unless order

    case payment['status']
    when 'approved'
      order.update(payment_status: :paid, status: :processing)
      OrderConfirmationJob.perform_later(order.id)
    when 'rejected'
      order.update(payment_status: :unpaid)
    end
  end
end
