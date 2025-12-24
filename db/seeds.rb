# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Cleaning database..."
OrderItem.destroy_all
Order.destroy_all
CartItem.destroy_all
Cart.destroy_all
Product.destroy_all
Category.destroy_all
Tenant.destroy_all
# Account.destroy_all # Comentado para não remover contas do Rodauth

puts "Creating tenant..."
tenant = Tenant.create!(
  name: "Loja Principal",
  subdomain: "main",
  settings: { currency: "BRL", timezone: "America/Sao_Paulo" },
  active: true
)

puts "Creating categories..."
categories = [
  { name: "Eletrônicos", description: "Produtos eletrônicos e gadgets" },
  { name: "Roupas", description: "Roupas e acessórios de moda" },
  { name: "Livros", description: "Livros físicos e digitais" },
  { name: "Casa e Decoração", description: "Itens para casa e decoração" },
  { name: "Esportes", description: "Equipamentos e roupas esportivas" }
]

categories.each do |cat|
  Category.create!(
    name: cat[:name],
    description: cat[:description],
    tenant: tenant
  )
end

puts "Creating products..."
eletronicos = Category.find_by(name: "Eletrônicos")
roupas = Category.find_by(name: "Roupas")
livros = Category.find_by(name: "Livros")

products = [
  {
    name: "Smartphone Galaxy X",
    description: "Smartphone de última geração com câmera de 48MP",
    price: 2499.90,
    sku: "SMART-001",
    stock_quantity: 50,
    category: eletronicos,
    images: ["https://via.placeholder.com/400x400?text=Smartphone"]
  },
  {
    name: "Notebook Pro 15\"",
    description: "Notebook potente para trabalho e jogos",
    price: 4999.90,
    sku: "NOTE-001",
    stock_quantity: 30,
    category: eletronicos,
    images: ["https://via.placeholder.com/400x400?text=Notebook"]
  },
  {
    name: "Fone de Ouvido Bluetooth",
    description: "Fone de ouvido sem fio com cancelamento de ruído",
    price: 299.90,
    sku: "FONE-001",
    stock_quantity: 100,
    category: eletronicos,
    images: ["https://via.placeholder.com/400x400?text=Fone"]
  },
  {
    name: "Camiseta Básica",
    description: "Camiseta 100% algodão disponível em várias cores",
    price: 49.90,
    sku: "CAM-001",
    stock_quantity: 200,
    category: roupas,
    images: ["https://via.placeholder.com/400x400?text=Camiseta"]
  },
  {
    name: "Calça Jeans",
    description: "Calça jeans confortável e durável",
    price: 129.90,
    sku: "CALCA-001",
    stock_quantity: 150,
    category: roupas,
    images: ["https://via.placeholder.com/400x400?text=Calca"]
  },
  {
    name: "Livro: Clean Code",
    description: "Guia essencial para programadores",
    price: 89.90,
    sku: "LIVRO-001",
    stock_quantity: 75,
    category: livros,
    images: ["https://via.placeholder.com/400x400?text=Clean+Code"]
  },
  {
    name: "Livro: Design Patterns",
    description: "Padrões de projeto explicados",
    price: 79.90,
    sku: "LIVRO-002",
    stock_quantity: 60,
    category: livros,
    images: ["https://via.placeholder.com/400x400?text=Design+Patterns"]
  }
]

products.each do |product_data|
  Product.create!(
    name: product_data[:name],
    description: product_data[:description],
    price: product_data[:price],
    sku: product_data[:sku],
    stock_quantity: product_data[:stock_quantity],
    category: product_data[:category],
    tenant: tenant,
    images: product_data[:images],
    active: true
  )
end

puts "Creating test account and cart..."
# Criar uma conta de teste (se não existir)
account = Account.find_or_create_by(email: "test@example.com") do |acc|
  acc.status = 2 # Verified account
end

cart = Cart.create!(account: account)

# Adicionar alguns produtos ao carrinho
cart.add_product(Product.first, 2)
cart.add_product(Product.second, 1)

puts "Seeds completed successfully!"
puts "Created:"
puts "  - 1 Tenant"
puts "  - #{Category.count} Categories"
puts "  - #{Product.count} Products"
puts "  - 1 Test Account (test@example.com)"
puts "  - 1 Cart with #{cart.cart_items.count} items"
