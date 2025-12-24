module Api
  module V1
    class ProductsController < Api::V1::BaseController
      before_action :set_product, only: [:show, :update, :destroy]

      def index
        result = Product::Operation::List.call(params: params.permit(:tenant_id, :category_id, :active, :in_stock, :page, :per_page))
        
        if result.success?
          render json: {
            products: result[:model].map { |product| Product::Representer::Show.new(product).to_hash },
            meta: {
              current_page: result[:model].current_page,
              total_pages: result[:model].total_pages,
              total_count: result[:model].total_count
            }
          }, status: :ok
        else
          render json: { error: 'Failed to fetch products' }, status: :unprocessable_entity
        end
      end

      def show
        render json: Product::Representer::Show.new(@product).to_hash, status: :ok
      end

      def create
        result = Product::Operation::Create.call(params: product_params)
        
        if result.success?
          render json: Product::Representer::Show.new(result[:model]).to_hash, status: :created
        else
          render json: { errors: result[:contract].errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        result = Product::Operation::Update.call(params: product_params.merge(id: params[:id]))
        
        if result.success?
          render json: Product::Representer::Show.new(result[:model]).to_hash, status: :ok
        else
          render json: { errors: result[:contract].errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        result = Product::Operation::Delete.call(params: { id: params[:id] })
        
        if result.success?
          head :no_content
        else
          render json: { error: 'Failed to delete product' }, status: :unprocessable_entity
        end
      end

      private

      def set_product
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found' }, status: :not_found
      end

      def product_params
        params.require(:product).permit(:name, :description, :price, :sku, :stock_quantity, :category_id, :tenant_id, :active, images: [])
      end
    end
  end
end
