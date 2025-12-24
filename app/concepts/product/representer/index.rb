module Product::Representer
  class Index < Representable::Decorator
    include Representable::JSON::Collection

    items class: Product, decorator: Product::Representer::Show
  end
end
