# Integração Backend ↔ Frontend

## 🔗 Configuração de CORS

O backend já está configurado para aceitar requisições do frontend. Verifique em `config/initializers/cors.rb`:

```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch('FRONTEND_URL', 'http://localhost:5173')
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
```

## 🔐 Autenticação

### Registro
```typescript
// POST /auth/register
const response = await axios.post('/auth/register', {
  email: 'user@example.com',
  password: 'password123',
  password_confirmation: 'password123'
});
```

### Login
```typescript
// POST /auth/login
const response = await axios.post('/auth/login', {
  email: 'user@example.com',
  password: 'password123'
});

// Salvar token
localStorage.setItem('authToken', response.data.token);
```

### Requisições Autenticadas
```typescript
// Configurar axios com token
axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
```

## 📦 Endpoints Principais

### Produtos

#### Listar Produtos
```typescript
// GET /api/v1/products
interface ProductsResponse {
  products: Product[];
  meta: {
    current_page: number;
    total_pages: number;
    total_count: number;
  };
}

// Com filtros
const params = {
  tenant_id: 1,
  category_id: 2,
  active: true,
  in_stock: true,
  page: 1,
  per_page: 20
};
```

#### Detalhes do Produto
```typescript
// GET /api/v1/products/:id
interface Product {
  id: number;
  name: string;
  description: string;
  price: number;
  sku: string;
  stock_quantity: number;
  images: string[];
  active: boolean;
  category: {
    id: number;
    name: string;
    slug: string;
  };
  tenant: {
    id: number;
    name: string;
  };
  created_at: string;
  updated_at: string;
}
```

### Carrinho

#### Ver Carrinho
```typescript
// GET /api/v1/cart
interface CartResponse {
  id: number;
  items: CartItem[];
  total_items: number;
  total_price: number;
}

interface CartItem {
  id: number;
  product: {
    id: number;
    name: string;
    price: number;
    images: string[];
    stock_quantity: number;
  };
  quantity: number;
  price: number;
  subtotal: number;
}
```

#### Adicionar ao Carrinho
```typescript
// POST /api/v1/cart/add_item
await axios.post('/api/v1/cart/add_item', {
  product_id: 1,
  quantity: 2
});
```

#### Atualizar Quantidade
```typescript
// PATCH /api/v1/cart/items/:product_id
await axios.patch(`/api/v1/cart/items/${productId}`, {
  quantity: 3
});
```

#### Remover Item
```typescript
// DELETE /api/v1/cart/items/:product_id
await axios.delete(`/api/v1/cart/items/${productId}`);
```

### Pedidos

#### Criar Pedido
```typescript
// POST /api/v1/orders
interface CreateOrderRequest {
  cart_id: number;
  tenant_id: number;
  shipping_address: string;
  payment_method: string;
}

const response = await axios.post('/api/v1/orders', {
  cart_id: cart.id,
  tenant_id: 1,
  shipping_address: 'Rua Exemplo, 123\nSão Paulo - SP\n01234-567',
  payment_method: 'credit_card'
});
```

#### Listar Pedidos
```typescript
// GET /api/v1/orders
interface OrdersResponse {
  orders: Order[];
  meta: {
    current_page: number;
    total_pages: number;
    total_count: number;
  };
}

interface Order {
  id: number;
  order_number: string;
  status: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled';
  payment_status: 'unpaid' | 'paid' | 'refunded';
  total_amount: number;
  shipping_address: string;
  payment_method: string;
  created_at: string;
  updated_at: string;
  items?: OrderItem[];
}
```

### Pagamentos

#### Stripe - Criar Payment Intent
```typescript
// POST /api/v1/payments/stripe/intent
const response = await axios.post('/api/v1/payments/stripe/intent', {
  order_id: order.id
});

const { client_secret } = response.data;

// Use com Stripe Elements
const stripe = await loadStripe(STRIPE_PUBLIC_KEY);
const { error } = await stripe.confirmCardPayment(client_secret, {
  payment_method: {
    card: cardElement,
    billing_details: {
      name: 'Customer Name'
    }
  }
});
```

#### Mercado Pago - Criar Preferência
```typescript
// POST /api/v1/payments/mercadopago/preference
const response = await axios.post('/api/v1/payments/mercadopago/preference', {
  order_id: order.id
});

const { preference_id, init_point } = response.data;

// Redirecionar para checkout do Mercado Pago
window.location.href = init_point;
```

## 🎨 Exemplos de Uso no React

### Hook Personalizado para Produtos
```typescript
// hooks/useProducts.ts
import { useState, useEffect } from 'react';
import { api } from '@/lib/api';

export function useProducts(filters = {}) {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function fetchProducts() {
      try {
        setLoading(true);
        const response = await api.get('/api/v1/products', { params: filters });
        setProducts(response.data.products);
      } catch (err) {
        setError(err);
      } finally {
        setLoading(false);
      }
    }

    fetchProducts();
  }, [JSON.stringify(filters)]);

  return { products, loading, error };
}
```

### Store Zustand para Carrinho
```typescript
// stores/cartStore.ts
import create from 'zustand';
import { api } from '@/lib/api';

interface CartStore {
  cart: Cart | null;
  loading: boolean;
  fetchCart: () => Promise<void>;
  addItem: (productId: number, quantity: number) => Promise<void>;
  removeItem: (productId: number) => Promise<void>;
  updateQuantity: (productId: number, quantity: number) => Promise<void>;
  clearCart: () => Promise<void>;
}

export const useCartStore = create<CartStore>((set) => ({
  cart: null,
  loading: false,
  
  fetchCart: async () => {
    set({ loading: true });
    try {
      const response = await api.get('/api/v1/cart');
      set({ cart: response.data, loading: false });
    } catch (error) {
      set({ loading: false });
    }
  },
  
  addItem: async (productId, quantity) => {
    try {
      await api.post('/api/v1/cart/add_item', { product_id: productId, quantity });
      await useCartStore.getState().fetchCart();
    } catch (error) {
      console.error('Error adding item:', error);
    }
  },
  
  removeItem: async (productId) => {
    try {
      await api.delete(`/api/v1/cart/items/${productId}`);
      await useCartStore.getState().fetchCart();
    } catch (error) {
      console.error('Error removing item:', error);
    }
  },
  
  updateQuantity: async (productId, quantity) => {
    try {
      await api.patch(`/api/v1/cart/items/${productId}`, { quantity });
      await useCartStore.getState().fetchCart();
    } catch (error) {
      console.error('Error updating quantity:', error);
    }
  },
  
  clearCart: async () => {
    try {
      await api.delete('/api/v1/cart/clear');
      set({ cart: null });
    } catch (error) {
      console.error('Error clearing cart:', error);
    }
  }
}));
```

### Configuração do Axios
```typescript
// lib/api.ts
import axios from 'axios';

export const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Interceptor para adicionar token
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('authToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Interceptor para tratar erros
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('authToken');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);
```

## 🔄 Tratamento de Erros

O backend retorna erros no seguinte formato:

```typescript
interface ErrorResponse {
  error: string;
  message: string;
  details?: string[];
}
```

Exemplo de tratamento:
```typescript
try {
  await api.post('/api/v1/orders', orderData);
} catch (error) {
  if (axios.isAxiosError(error)) {
    const errorData = error.response?.data;
    toast.error(errorData.message || 'Erro ao criar pedido');
    
    if (errorData.details) {
      errorData.details.forEach(detail => {
        console.error(detail);
      });
    }
  }
}
```

## 📱 WebSockets (Future Feature)

Para atualizações em tempo real de estoque e status de pedidos, considere implementar Action Cable no backend e conectar no frontend.

## 🧪 Testes de Integração

```typescript
// __tests__/api/products.test.ts
import { api } from '@/lib/api';

describe('Products API', () => {
  it('should fetch products list', async () => {
    const response = await api.get('/api/v1/products');
    expect(response.status).toBe(200);
    expect(response.data).toHaveProperty('products');
    expect(Array.isArray(response.data.products)).toBe(true);
  });
});
```

## 📝 Variáveis de Ambiente Frontend

```env
# .env.development
VITE_API_URL=http://localhost:3000
VITE_STRIPE_PUBLIC_KEY=pk_test_xxxxxxxxxxxxx
VITE_MERCADO_PAGO_PUBLIC_KEY=TEST-xxxxxxxxxxxxx
```

```env
# .env.production
VITE_API_URL=https://api.yourdomain.com
VITE_STRIPE_PUBLIC_KEY=pk_live_xxxxxxxxxxxxx
VITE_MERCADO_PAGO_PUBLIC_KEY=APP-xxxxxxxxxxxxx
```
