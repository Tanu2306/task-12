import { useState, useEffect } from 'react'
import ProductCard from '../components/ProductCard.jsx'
import { MOCK_PRODUCTS } from './mockData.js'

const API_URL = '/api/products'

export default function Products() {
  const [products, setProducts]   = useState([])
  const [loading, setLoading]     = useState(true)
  const [error, setError]         = useState(null)
  const [usingMock, setUsingMock] = useState(false)

  useEffect(() => {
    let cancelled = false

    const fetchProducts = async () => {
      try {
        const res = await fetch(API_URL)
        if (!res.ok) throw new Error(`HTTP ${res.status}`)
        const data = await res.json()
        if (!cancelled) {
          setProducts(data)
          setUsingMock(false)
        }
      } catch (err) {
        if (!cancelled) {
          console.warn('Backend unavailable, falling back to mock data.', err.message)
          setProducts(MOCK_PRODUCTS)
          setUsingMock(true)
          setError(null) // graceful degradation – no error shown to user
        }
      } finally {
        if (!cancelled) setLoading(false)
      }
    }

    fetchProducts()
    return () => { cancelled = true }
  }, [])

  return (
    <section className="products-section">
      <div className="container">
        <div className="section-header">
          <h1>Our Products</h1>
          <p>
            {usingMock
              ? '⚠️ Showing demo data – backend offline. Deploy with Docker Compose to connect the live API.'
              : 'Fresh from the live Spring Boot API.'}
          </p>
        </div>

        {error && <div className="error-banner">⚠ {error}</div>}

        {loading ? (
          <div className="loading-grid" aria-label="Loading products">
            {[...Array(6)].map((_, i) => (
              <div className="skeleton" key={i} />
            ))}
          </div>
        ) : (
          <div className="products-grid" id="products-grid">
            {products.map((p) => (
              <ProductCard key={p.id} product={p} />
            ))}
          </div>
        )}
      </div>
    </section>
  )
}
