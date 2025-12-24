module Product::Operation
  class Delete < Trailblazer::Operation
    step :model!
    step :destroy!

    def model!(ctx, params:, **)
      ctx[:model] = Product.find_by(id: params[:id])
      ctx[:model].present?
    end

    def destroy!(ctx, model:, **)
      model.destroy
    end
  end
end
