import { Link, NavLink } from 'react-router-dom'
import { useCart } from '../context/CartContext.jsx'

export default function Navbar() {
  const { totalItems } = useCart()

  return (
    <nav className="navbar">
      <div className="container navbar__inner">
        <Link to="/" className="navbar__logo">🛍️ ShopLocal</Link>

        <div className="navbar__links">
          <NavLink
            to="/"
            end
            className={({ isActive }) => 'navbar__link' + (isActive ? ' active' : '')}
          >
            Home
          </NavLink>
          <NavLink
            to="/products"
            className={({ isActive }) => 'navbar__link' + (isActive ? ' active' : '')}
          >
            Products
          </NavLink>
          <Link to="/cart" className="navbar__cart" id="nav-cart-btn">
            🛒 Cart
            {totalItems > 0 && (
              <span className="badge" id="cart-badge">{totalItems}</span>
            )}
          </Link>
        </div>
      </div>
    </nav>
  )
}
