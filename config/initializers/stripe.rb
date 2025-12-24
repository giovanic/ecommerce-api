# Configuração do Stripe para pagamentos
Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(:stripe, :publishable_key),
  secret_key: Rails.application.credentials.dig(:stripe, :secret_key),
  webhook_secret: Rails.application.credentials.dig(:stripe, :webhook_secret)
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
Stripe.api_version = '2023-10-16'
