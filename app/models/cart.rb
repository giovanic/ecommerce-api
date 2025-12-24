class Cart < ApplicationRecord
  belongs_to :account, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_product(product, quantity = 1)
    current_item = cart_items.find_by(product_id: product.id)
    
    if current_item
      current_item.increment(:quantity, quantity)
      current_item.save
    else
      cart_items.create(product: product, quantity: quantity, price: product.price)
    end
  end

  def remove_product(product)
    cart_items.find_by(product_id: product.id)&.destroy
  end

  def total_price
    cart_items.sum { |item| item.quantity * item.price }
  end

  def total_items
    cart_items.sum(:quantity)
  end
end
