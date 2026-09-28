import { Link } from 'react-router-dom'

const FEATURES = [
  { icon: '⚡', title: 'Lightning Fast',   desc: 'Served via Nginx, built with Vite – sub-second loads.' },
  { icon: '🐳', title: 'Containerised',    desc: 'Docker Compose for local dev; Kubernetes for scale.' },
  { icon: '🔒', title: 'Secure CI/CD',     desc: 'GitHub Actions + Trivy image scanning on every push.' },
  { icon: '📈', title: 'Auto-scaling HPA', desc: 'Kubernetes HPA scales the backend at 70% CPU.' },
]

export default function Home() {
  return (
    <>
      {/* ── Hero ────────────────────────────────────────────────────────── */}
      <section className="hero">
        <div className="container">
          <div className="hero__content">
            <span className="hero__eyebrow">Week 12 – Production DevOps</span>
            <h1 className="hero__title">
              Shop smarter with <span>ShopLocal</span>
            </h1>
            <p className="hero__subtitle">
              A full-stack e-commerce demo showcasing React, Spring Boot,
              PostgreSQL, Docker, Kubernetes, Helm, Prometheus &amp; Grafana —
              all running locally on Minikube.
            </p>
            <div className="hero__cta">
              <Link to="/products" className="btn btn-primary" id="hero-shop-btn">
                🛍️ Browse Products
              </Link>
              <Link to="/cart" className="btn btn-ghost" id="hero-cart-btn">
                View Cart
              </Link>
            </div>
            <div className="hero__badge">
              <span className="hero__badge-dot" />
              Live stack: React · Spring Boot · PostgreSQL · Kubernetes
            </div>
          </div>
        </div>
      </section>

      {/* ── Feature Cards ───────────────────────────────────────────────── */}
      <section className="products-section">
        <div className="container">
          <div className="section-header">
            <h2>Why this stack?</h2>
            <p>Every component chosen for real-world DevOps relevance.</p>
          </div>
          <div className="products-grid">
            {FEATURES.map((f) => (
              <div className="card product-card" key={f.title}>
                <div className="product-card__emoji">{f.icon}</div>
                <h3 className="product-card__name">{f.title}</h3>
                <p className="product-card__desc">{f.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>
    </>
  )
}
