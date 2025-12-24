# Configuração do Mercado Pago
require 'mercadopago'

Rails.configuration.mercado_pago = {
  access_token: Rails.application.credentials.dig(:mercado_pago, :access_token),
  public_key: Rails.application.credentials.dig(:mercado_pago, :public_key)
}

# Inicializar SDK do Mercado Pago
$mp = Mercadopago::SDK.new(Rails.configuration.mercado_pago[:access_token]) if Rails.configuration.mercado_pago[:access_token]
