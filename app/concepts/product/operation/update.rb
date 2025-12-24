module Product::Operation
  class Update < Trailblazer::Operation
    step :model!
    step :contract_build!
    step :contract_validate!
    step :contract_persist!

    def model!(ctx, params:, **)
      ctx[:model] = Product.find_by(id: params[:id])
      ctx[:model].present?
    end

    def contract_build!(ctx, model:, **)
      ctx[:contract] = Product::Contract::Update.new(model)
    end

    def contract_validate!(ctx, params:, **)
      ctx[:contract].validate(params)
    end

    def contract_persist!(ctx, **)
      ctx[:contract].save
    end
  end
end
