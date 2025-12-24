module Product::Operation
  class Create < Trailblazer::Operation
    step :model!
    step :contract_build!
    step :contract_validate!
    step :contract_persist!

    def model!(ctx, **)
      ctx[:model] = Product.new
    end

    def contract_build!(ctx, model:, **)
      ctx[:contract] = Product::Contract::Create.new(model)
    end

    def contract_validate!(ctx, params:, **)
      ctx[:contract].validate(params)
    end

    def contract_persist!(ctx, **)
      ctx[:contract].save
    end
  end
end
