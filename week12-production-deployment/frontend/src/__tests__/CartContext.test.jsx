import { describe, it, expect, beforeEach } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import { CartProvider, useCart } from '../context/CartContext.jsx'

// ── Helper to render a component inside all required providers ──────────────
function renderWithProviders(ui) {
  return render(
    <BrowserRouter>
      <CartProvider>{ui}</CartProvider>
    </BrowserRouter>,
  )
}

// ── Simple consumer component to expose cart state in the DOM ───────────────
function CartConsumer() {
  const { items, addToCart, totalItems, totalPrice } = useCart()
  const product = { id: 99, name: 'Test Widget', price: 10.0, stockQuantity: 5 }
  return (
    <div>
      <span data-testid="total-items">{totalItems}</span>
      <span data-testid="total-price">{totalPrice.toFixed(2)}</span>
      <span data-testid="item-count">{items.length}</span>
      <button data-testid="add-btn" onClick={() => addToCart(product)}>
        Add
      </button>
    </div>
  )
}

// ─────────────────────────────────────────────────────────────────────────────
describe('CartContext', () => {
  beforeEach(() => {
    // Nothing to reset – CartProvider holds state internally
  })

  it('starts with an empty cart', () => {
    renderWithProviders(<CartConsumer />)
    expect(screen.getByTestId('total-items').textContent).toBe('0')
    expect(screen.getByTestId('total-price').textContent).toBe('0.00')
  })

  it('adds a product to the cart and increments totals', () => {
    renderWithProviders(<CartConsumer />)
    fireEvent.click(screen.getByTestId('add-btn'))
    expect(screen.getByTestId('total-items').textContent).toBe('1')
    expect(screen.getByTestId('total-price').textContent).toBe('10.00')
  })

  it('accumulates quantity when the same product is added twice', () => {
    renderWithProviders(<CartConsumer />)
    fireEvent.click(screen.getByTestId('add-btn'))
    fireEvent.click(screen.getByTestId('add-btn'))
    expect(screen.getByTestId('total-items').textContent).toBe('2')
    expect(screen.getByTestId('item-count').textContent).toBe('1') // still 1 line-item
    expect(screen.getByTestId('total-price').textContent).toBe('20.00')
  })
})
