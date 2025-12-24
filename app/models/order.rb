class Order < ApplicationRecord
  belongs_to :account
  belongs_to :tenant
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum :status, {
    pending: 0,
    processing: 1,
    shipped: 2,
    delivered: 3,
    cancelled: 4
  }

  enum :payment_status, {
    unpaid: 0,
    paid: 1,
    refunded: 2
  }

  validates :order_number, presence: true, uniqueness: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :payment_status, presence: true

  before_validation :generate_order_number, on: :create

  scope :recent, -> { order(created_at: :desc) }

  def calculate_total
    order_items.sum { |item| item.quantity * item.price }
  end

  private

  def generate_order_number
    self.order_number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end
