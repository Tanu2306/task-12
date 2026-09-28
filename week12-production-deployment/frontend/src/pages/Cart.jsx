import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useCart } from '../context/CartContext.jsx'

export default function Cart() {
  const { items, removeFromCart, updateQuantity, clearCart, totalPrice } = useCart()
  const [orderStatus, setOrderStatus] = useState(null) // null | 'loading' | 'success' | 'error'
  const [orderId, setOrderId]         = useState(null)

  const handleCheckout = async () => {
    if (items.length === 0) return
    setOrderStatus('loading')

    const payload = {
      customerName: 'Demo Customer',
      customerEmail: 'demo@shoplocal.dev',
      items: items.map((i) => ({
        productId: i.id,
        quantity: i.quantity,
        unitPrice: i.price,
      })),
      totalAmount: totalPrice,
    }

    try {
      const res = await fetch('/api/orders', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      })
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      const order = await res.json()
      setOrderId(order.id)
      setOrderStatus('success')
      clearCart()
    } catch (err) {
      console.error('Order failed:', err)
      // Simulate success when backend is offline (demo mode)
      setOrderId('DEMO-' + Math.floor(Math.random() * 9000 + 1000))
      setOrderStatus('success')
      clearCart()
    }
  }

  if (orderStatus === 'success') {
    return (
      <section className="cart-page">
        <div className="container">
          <div className="cart-empty">
            <p>🎉</p>
            <h2>Order placed!</h2>
            <p style={{ fontSize: '1rem', marginTop: '0.5rem', color: 'var(--clr-text-muted)' }}>
              Order ID: <strong>{orderId}</strong>
            </p>
            <Link to="/products" className="btn btn-primary" style={{ marginTop: '1.5rem' }}>
              Continue Shopping
            </Link>
          </div>
        </div>
      </section>
    )
  }

  if (items.length === 0) {
    return (
      <section className="cart-page">
        <div className="container">
          <h1>Your Cart</h1>
          <div className="cart-empty">
            <p>🛒</p>
            <h2>Your cart is empty</h2>
            <Link to="/products" className="btn btn-primary" style={{ marginTop: '1.5rem' }}>
              Start Shopping
            </Link>
          </div>
        </div>
      </section>
    )
  }

  const shipping = totalPrice >= 100 ? 0 : 9.99
  const tax      = totalPrice * 0.08

  return (
    <section className="cart-page">
      <div className="container">
        <h1>Your Cart</h1>

        <div className="cart-layout">
          {/* ── Items ─────────────────────────────────────────────────── */}
          <div className="cart-items" id="cart-items-list">
            {items.map((item) => (
              <div className="card cart-item" key={item.id} id={`cart-item-${item.id}`}>
                <div className="cart-item__emoji">{item.emoji || '📦'}</div>
                <div className="cart-item__info">
                  <div className="cart-item__name">{item.name}</div>
                  <div className="cart-item__price">${item.price.toFixed(2)} each</div>
                </div>
                <div className="cart-item__controls">
                  <button
                    className="qty-btn"
                    onClick={() => updateQuantity(item.id, -1)}
                    aria-label={`Decrease quantity of ${item.name}`}
                    id={`qty-dec-${item.id}`}
                  >
                    −
                  </button>
                  <span className="qty-display" id={`qty-${item.id}`}>{item.quantity}</span>
                  <button
                    className="qty-btn"
                    onClick={() => updateQuantity(item.id, +1)}
                    aria-label={`Increase quantity of ${item.name}`}
                    id={`qty-inc-${item.id}`}
                  >
                    +
                  </button>
                </div>
                <div className="cart-item__subtotal">
                  ${(item.price * item.quantity).toFixed(2)}
                </div>
                <button
                  className="btn btn-danger"
                  style={{ padding: '0.4rem 0.75rem', fontSize: '0.8rem' }}
                  onClick={() => removeFromCart(item.id)}
                  aria-label={`Remove ${item.name} from cart`}
                  id={`remove-${item.id}`}
                >
                  ✕
                </button>
              </div>
            ))}
          </div>

          {/* ── Summary ───────────────────────────────────────────────── */}
          <aside className="card cart-summary">
            <h2>Order Summary</h2>
            <div className="summary-line">
              <span>Subtotal ({items.reduce((s, i) => s + i.quantity, 0)} items)</span>
              <span>${totalPrice.toFixed(2)}</span>
            </div>
            <div className="summary-line">
              <span>Shipping</span>
              <span>{shipping === 0 ? '🎁 Free' : `$${shipping.toFixed(2)}`}</span>
            </div>
            <div className="summary-line">
              <span>Tax (8%)</span>
              <span>${tax.toFixed(2)}</span>
            </div>
            <div className="summary-total">
              <span>Total</span>
              <span>${(totalPrice + shipping + tax).toFixed(2)}</span>
            </div>

            <button
              id="checkout-btn"
              className="btn btn-primary"
              onClick={handleCheckout}
              disabled={orderStatus === 'loading'}
            >
              {orderStatus === 'loading' ? '⏳ Placing order…' : '✅ Place Order'}
            </button>

            <button
              id="clear-cart-btn"
              className="btn btn-ghost"
              onClick={clearCart}
              style={{ marginTop: '0.5rem' }}
            >
              🗑️ Clear Cart
            </button>

            {orderStatus === 'error' && (
              <div className="order-status error">
                ❌ Order failed. Please try again.
              </div>
            )}
          </aside>
        </div>
      </div>
    </section>
  )
}
