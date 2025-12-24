module Api
  module V1
    class BaseController < ApplicationController
      include Rodauth::Rails::Auth
      include Api::ErrorHandler

      before_action :authenticate_rodauth, except: [:index, :show]

      private

      def current_account
        rodauth.rails_account
      end
    end
  end
end