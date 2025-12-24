class ShippingCalculatorService
  SHIPPING_RATES = {
    standard: { base: 15.00, per_kg: 5.00, days: 7 },
    express: { base: 30.00, per_kg: 10.00, days: 3 },
    overnight: { base: 50.00, per_kg: 15.00, days: 1 }
  }.freeze

  def initialize(order_items, destination_zipcode)
    @order_items = order_items
    @destination_zipcode = destination_zipcode
  end

  def calculate
    total_weight = calculate_total_weight
    
    {
      standard: calculate_shipping_cost(:standard, total_weight),
      express: calculate_shipping_cost(:express, total_weight),
      overnight: calculate_shipping_cost(:overnight, total_weight)
    }
  end

  def calculate_for_type(shipping_type)
    total_weight = calculate_total_weight
    calculate_shipping_cost(shipping_type.to_sym, total_weight)
  end

  private

  def calculate_total_weight
    # Assumindo que cada produto tem um peso padrão de 0.5kg
    # Em produção, você deveria ter um campo weight no modelo Product
    @order_items.sum { |item| item.quantity * 0.5 }
  end

  def calculate_shipping_cost(type, weight)
    rate = SHIPPING_RATES[type]
    return nil unless rate

    cost = rate[:base] + (weight * rate[:per_kg])
    
    {
      type: type,
      cost: cost.round(2),
      estimated_days: rate[:days],
      weight: weight
    }
  end

  # Método alternativo usando API dos Correios (exemplo)
  def self.calculate_with_correios_api(origin_zipcode, destination_zipcode, weight, dimensions)
    # Implementar integração com API dos Correios
    # https://www.correios.com.br/para-sua-empresa/comercio-eletronico/e-commerce-solucoes
    {
      success: true,
      options: [
        { service: 'PAC', cost: 25.50, days: 10 },
        { service: 'SEDEX', cost: 45.00, days: 3 }
      ]
    }
  rescue => e
    { success: false, error: e.message }
  end
end
