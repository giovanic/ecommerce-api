class StripeService
  def initialize(order)
    @order = order
  end

  def create_payment_intent
    begin
      intent = Stripe::PaymentIntent.create(
        amount: (@order.total_amount * 100).to_i, # Stripe usa centavos
        currency: 'brl',
        metadata: {
          order_id: @order.id,
          order_number: @order.order_number
        },
        automatic_payment_methods: {
          enabled: true
        }
      )

      { success: true, client_secret: intent.client_secret }
    rescue Stripe::StripeError => e
      { success: false, error: e.message }
    end
  end

  def self.handle_webhook(payload, sig_header)
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.dig(:stripe, :webhook_secret)
      )

      case event.type
      when 'payment_intent.succeeded'
        handle_payment_success(event.data.object)
      when 'payment_intent.payment_failed'
        handle_payment_failure(event.data.object)
      end

      { success: true }
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      { success: false, error: e.message }
    end
  end

  private

  def self.handle_payment_success(payment_intent)
    order = Order.find_by(id: payment_intent.metadata.order_id)
    return unless order

    order.update(
      payment_status: :paid,
      status: :processing,
      payment_details: payment_intent.to_hash
    )

    OrderConfirmationJob.perform_later(order.id)
  end

  def self.handle_payment_failure(payment_intent)
    order = Order.find_by(id: payment_intent.metadata.order_id)
    return unless order

    order.update(
      payment_status: :unpaid,
      payment_details: payment_intent.to_hash
    )
  end
end
