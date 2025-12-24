class InventorySyncJob < ApplicationJob
  queue_as :default

  def perform
    # Sincronizar estoque com sistemas externos ou verificar produtos com estoque baixo
    low_stock_products = Product.where('stock_quantity < ?', 10)
    
    low_stock_products.each do |product|
      Rails.logger.warn "Low stock alert for Product ##{product.id} - #{product.name}: #{product.stock_quantity} units remaining"
      
      # Aqui você pode adicionar lógica para:
      # - Enviar notificações para administradores
      # - Integrar com sistema de fornecedores
      # - Atualizar status do produto
    end

    # Verificar produtos sem estoque
    out_of_stock_products = Product.where(stock_quantity: 0, active: true)
    out_of_stock_products.update_all(active: false)
    
    Rails.logger.info "Inventory sync completed. #{low_stock_products.count} products with low stock, #{out_of_stock_products.count} products deactivated."
  rescue => e
    Rails.logger.error "Error syncing inventory: #{e.message}"
    raise e
  end
end
