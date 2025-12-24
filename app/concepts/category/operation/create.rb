module Category::Operation
  class Create < Trailblazer::Operation
    step :model!
    step :save!

    def model!(ctx, params:, **)
      ctx[:model] = Category.new(
        name: params[:name],
        description: params[:description],
        tenant_id: params[:tenant_id]
      )
    end

    def save!(ctx, model:, **)
      model.save
    end
  end
end
