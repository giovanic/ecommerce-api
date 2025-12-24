class Product < ApplicationRecord
  belongs_to :tenant
  belongs_to :category, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: { scope: :tenant_id }, allow_nil: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :in_stock, -> { where("stock_quantity > ?", 0) }

  def in_stock?
    stock_quantity > 0
  end

  def reduce_stock(quantity)
    update(stock_quantity: stock_quantity - quantity)
  end
end
