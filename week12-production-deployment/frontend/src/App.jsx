import { Routes, Route } from 'react-router-dom'
import Navbar from './components/Navbar.jsx'
import Home from './pages/Home.jsx'
import Products from './pages/Products.jsx'
import Cart from './pages/Cart.jsx'

export default function App() {
  return (
    <>
      <Navbar />
      <main>
        <Routes>
          <Route path="/"         element={<Home />} />
          <Route path="/products" element={<Products />} />
          <Route path="/cart"     element={<Cart />} />
        </Routes>
      </main>
      <footer>
        <div className="container">
          <p>© 2024 ShopLocal &mdash; Student DevOps Demo | React + Spring Boot + Docker + Kubernetes</p>
        </div>
      </footer>
    </>
  )
}
