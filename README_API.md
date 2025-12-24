# E-commerce Backend API

API REST para plataforma de e-commerce construída com Ruby on Rails, utilizando Trailblazer para organização de lógica de negócios e Rodauth para autenticação.

## 🚀 Tecnologias

- **Ruby** 3.3.4
- **Rails** 8.0.4
- **PostgreSQL** - Banco de dados
- **Redis** - Cache e fila de jobs
- **Trailblazer** - Arquitetura de operações
- **Rodauth** - Autenticação
- **Stripe & Mercado Pago** - Processamento de pagamentos
- **Cloudinary** - Upload de imagens
- **Meilisearch** - Busca avançada
- **Docker** - Containerização

## 📦 Estrutura do Projeto

```
app/
├── concepts/          # Trailblazer concepts (operações, contratos, representers)
│   ├── product/
│   ├── order/
│   ├── cart/
│   └── category/
├── controllers/       # Controllers da API
│   └── api/v1/
├── models/           # Models ActiveRecord
├── services/         # Serviços de integração
├── jobs/            # Background jobs
└── mailers/         # Email templates
```

## 🛠️ Configuração

### 1. Clonar o repositório

```bash
git clone <repository-url>
cd ecommerce-backend
```

### 2. Configurar variáveis de ambiente

```bash
cp .env.example .env
# Edite o arquivo .env com suas credenciais
```

### 3. Instalar dependências

```bash
bundle install
```

### 4. Configurar banco de dados

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 5. Configurar credenciais Rails

```bash
EDITOR="code --wait" rails credentials:edit
```

Use o template em `config/credentials.example.yml` como referência.

### 6. Iniciar o servidor

```bash
rails server
# ou com Docker
docker-compose up
```

A API estará disponível em `http://localhost:3000`

## 📋 Endpoints da API

### Autenticação

```
POST   /auth/register              - Registrar nova conta
POST   /auth/login                 - Login
DELETE /auth/logout                - Logout
GET    /auth/verify-email          - Verificar email
POST   /auth/reset-password        - Reset de senha
```

### Produtos

```
GET    /api/v1/products            - Listar produtos
GET    /api/v1/products/:id        - Detalhes do produto
POST   /api/v1/products            - Criar produto
PATCH  /api/v1/products/:id        - Atualizar produto
DELETE /api/v1/products/:id        - Deletar produto
```

### Categorias

```
GET    /api/v1/categories          - Listar categorias
GET    /api/v1/categories/:id      - Detalhes da categoria
POST   /api/v1/categories          - Criar categoria
PATCH  /api/v1/categories/:id      - Atualizar categoria
DELETE /api/v1/categories/:id      - Deletar categoria
```

### Carrinho

```
GET    /api/v1/cart                - Ver carrinho
POST   /api/v1/cart/add_item       - Adicionar item
DELETE /api/v1/cart/items/:id      - Remover item
PATCH  /api/v1/cart/items/:id      - Atualizar quantidade
DELETE /api/v1/cart/clear          - Limpar carrinho
```

### Pedidos

```
GET    /api/v1/orders              - Listar pedidos
GET    /api/v1/orders/:id          - Detalhes do pedido
POST   /api/v1/orders              - Criar pedido
PATCH  /api/v1/orders/:id/update_status - Atualizar status
```

### Pagamentos

```
POST   /api/v1/payments/stripe/intent           - Criar payment intent (Stripe)
POST   /api/v1/payments/mercadopago/preference  - Criar preferência (Mercado Pago)
POST   /api/v1/webhooks/stripe                  - Webhook Stripe
POST   /api/v1/webhooks/mercadopago             - Webhook Mercado Pago
```

## 🧪 Testes

```bash
# Rodar todos os testes
bundle exec rspec

# Rodar testes específicos
bundle exec rspec spec/models
bundle exec rspec spec/requests
```

## 🐳 Docker

### Desenvolvimento

```bash
docker-compose up
```

### Produção

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

## 📊 Models

### Tenant
Multi-tenancy para suportar múltiplas lojas.

### Product
Produtos disponíveis para venda.

**Campos principais:**
- name, description, price, sku
- stock_quantity, images, active
- Relações: belongs_to :tenant, :category

### Order
Pedidos realizados pelos clientes.

**Status:**
- pending, processing, shipped, delivered, cancelled

**Payment Status:**
- unpaid, paid, refunded

### Cart
Carrinho de compras (sessão ou usuário).

### Category
Categorização de produtos.

## 🔧 Services

### StripeService
Processamento de pagamentos com Stripe.

### MercadoPagoService
Processamento de pagamentos com Mercado Pago.

### ImageUploadService
Upload e gerenciamento de imagens via Cloudinary.

### ShippingCalculatorService
Cálculo de frete e prazos de entrega.

## 📧 Jobs

### OrderConfirmationJob
Envio de email de confirmação de pedido.

### InventorySyncJob
Sincronização de estoque e alertas de produtos com baixo estoque.

## 🔐 Autenticação

A API usa Rodauth para autenticação JWT-based. Inclua o token no header:

```
Authorization: Bearer <token>
```

## 🌍 Variáveis de Ambiente

Consulte `.env.example` para lista completa de variáveis necessárias.

**Principais:**
- `DATABASE_URL` - URL do PostgreSQL
- `REDIS_URL` - URL do Redis
- `STRIPE_SECRET_KEY` - Chave secreta Stripe
- `MERCADO_PAGO_ACCESS_TOKEN` - Token Mercado Pago
- `CLOUDINARY_*` - Credenciais Cloudinary

## 📝 Logs

Logs são salvos em:
- Development: `log/development.log`
- Production: STDOUT (Docker)

## 🚀 Deploy

### Kamal (recomendado)

```bash
kamal setup
kamal deploy
```

### Heroku

```bash
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed
```

## 📄 Licença

MIT

## 👥 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📞 Suporte

Para suporte, envie um email para suporte@ecommerce.com ou abra uma issue no GitHub.
