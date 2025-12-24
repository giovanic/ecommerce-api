class OrderMailer < ApplicationMailer
  default from: 'noreply@ecommerce.com'

  def confirmation_email(order)
    @order = order
    @account = order.account
    @order_items = order.order_items.includes(:product)
    
    mail(
      to: @account.email,
      subject: "Confirmação do Pedido ##{@order.order_number}"
    )
  end

  def shipping_notification(order, tracking_code)
    @order = order
    @account = order.account
    @tracking_code = tracking_code
    
    mail(
      to: @account.email,
      subject: "Seu pedido ##{@order.order_number} foi enviado!"
    )
  end

  def delivery_notification(order)
    @order = order
    @account = order.account
    
    mail(
      to: @account.email,
      subject: "Seu pedido ##{@order.order_number} foi entregue!"
    )
  end

  def cancellation_notification(order)
    @order = order
    @account = order.account
    
    mail(
      to: @account.email,
      subject: "Pedido ##{@order.order_number} cancelado"
    )
  end
end
