Rails.application.routes.draw do
  # Rodauth routes
  mount RodauthApp => "/auth"

  namespace :api do
    namespace :v1 do
      # Products
      resources :products, only: [:index, :show, :create, :update, :destroy]
      
      # Categories
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      
      # Orders
      resources :orders, only: [:index, :show, :create] do
        member do
          patch :update_status
        end
      end
      
      # Cart
      resource :cart, only: [:show] do
        post :add_item
        delete :remove_item, path: 'items/:product_id'
        patch :update_item, path: 'items/:product_id'
        delete :clear
      end
      
      # Payments
      post 'payments/stripe/intent', to: 'payments#create_stripe_intent'
      post 'payments/mercadopago/preference', to: 'payments#create_mercado_pago_preference'
      
      # Webhooks
      post 'webhooks/stripe', to: 'payments#webhook_stripe'
      post 'webhooks/mercadopago', to: 'payments#webhook_mercado_pago'
    end
  end

  # Health check
  get 'health', to: 'health#show'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end