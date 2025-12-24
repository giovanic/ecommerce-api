class OrderConfirmationJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)
    
    # Enviar email de confirmação
    OrderMailer.confirmation_email(order).deliver_now
    
    # Atualizar status do pedido
    order.update(status: :processing) if order.paid?
    
    # Log da confirmação
    Rails.logger.info "Order confirmation sent for Order ##{order.order_number}"
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Order not found: #{e.message}"
  rescue => e
    Rails.logger.error "Error sending order confirmation: #{e.message}"
    raise e
  end
end
