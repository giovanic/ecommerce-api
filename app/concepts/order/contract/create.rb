module Order::Contract
  class Create < Reform::Form
    property :account_id
    property :tenant_id
    property :shipping_address
    property :payment_method
    property :order_items
    
    validates :account_id, presence: true
    validates :tenant_id, presence: true
    validates :shipping_address, presence: true
  end
end
