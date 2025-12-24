module Product::Operation
  class List < Trailblazer::Operation
    step :model!

    def model!(ctx, params:, **)
      products = Product.includes(:category, :tenant)
      
      products = products.where(tenant_id: params[:tenant_id]) if params[:tenant_id]
      products = products.where(category_id: params[:category_id]) if params[:category_id]
      products = products.active if params[:active]
      products = products.in_stock if params[:in_stock]
      
      ctx[:model] = products.page(params[:page] || 1).per(params[:per_page] || 20)
      true
    end
  end
end
