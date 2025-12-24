module Api
  module V1
    class CategoriesController < Api::V1::BaseController
      before_action :set_category, only: [:show, :update, :destroy]

      def index
        categories = Category.includes(:tenant)
        categories = categories.where(tenant_id: params[:tenant_id]) if params[:tenant_id]
        
        render json: categories, status: :ok
      end

      def show
        render json: @category, status: :ok
      end

      def create
        result = Category::Operation::Create.call(params: category_params)
        
        if result.success?
          render json: result[:model], status: :created
        else
          render json: { errors: result[:model].errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @category.update(category_params)
          render json: @category, status: :ok
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @category.destroy
        head :no_content
      end

      private

      def set_category
        @category = Category.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Category not found' }, status: :not_found
      end

      def category_params
        params.require(:category).permit(:name, :description, :tenant_id)
      end
    end
  end
end
