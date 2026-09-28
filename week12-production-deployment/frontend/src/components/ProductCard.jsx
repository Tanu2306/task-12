import { useCart } from '../context/CartContext.jsx'

/**
 * ProductCard – displays a single product with Add-to-Cart button.
 * Emoji field is used purely for visual flair (no image dependency).
 */
export default function ProductCard({ product }) {
  const { addToCart } = useCart()

  return (
    <article className="card product-card" id={`product-card-${product.id}`}>
      <div className="product-card__emoji">{product.emoji || '📦'}</div>
      <div className="product-card__category">{product.category}</div>
      <h3 className="product-card__name">{product.name}</h3>
      <p className="product-card__desc">{product.description}</p>
      <div className="product-card__footer">
        <div>
          <div className="product-card__price">${product.price.toFixed(2)}</div>
          <div className="product-card__stock">
            {product.stockQuantity > 0
              ? `${product.stockQuantity} in stock`
              : '⚠ Out of stock'}
          </div>
        </div>
        <button
          id={`add-to-cart-${product.id}`}
          className="btn btn-primary"
          onClick={() => addToCart(product)}
          disabled={product.stockQuantity === 0}
          aria-label={`Add ${product.name} to cart`}
        >
          Add to Cart
        </button>
      </div>
    </article>
  )
}
