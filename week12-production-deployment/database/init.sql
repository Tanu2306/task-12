-- database/init.sql
-- ─────────────────────────────────────────────────────────────────────────────
-- Initial schema + seed data for the ShopLocal e-commerce demo.
-- Runs automatically when the PostgreSQL container starts for the first time.
-- ─────────────────────────────────────────────────────────────────────────────

-- ── Extensions ───────────────────────────────────────────────────────────────
-- (none required – using BIGSERIAL for PK generation)

-- ── Users table ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id            BIGSERIAL    PRIMARY KEY,
    username      VARCHAR(100) NOT NULL UNIQUE,
    email         VARCHAR(200) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at    TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- ── Products table ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS products (
    id             BIGSERIAL      PRIMARY KEY,
    name           VARCHAR(200)   NOT NULL,
    description    TEXT,
    price          NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    category       VARCHAR(100),
    stock_quantity INTEGER        NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at     TIMESTAMP      NOT NULL DEFAULT NOW()
);

-- ── Orders table ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
    id             BIGSERIAL       PRIMARY KEY,
    customer_name  VARCHAR(200)    NOT NULL,
    customer_email VARCHAR(200)    NOT NULL,
    status         VARCHAR(20)     NOT NULL DEFAULT 'PENDING'
                       CHECK (status IN ('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED')),
    total_amount   NUMERIC(12, 2)  NOT NULL CHECK (total_amount >= 0),
    created_at     TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ── Order items table ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
    id         BIGSERIAL      PRIMARY KEY,
    order_id   BIGINT         NOT NULL REFERENCES orders(id)   ON DELETE CASCADE,
    product_id BIGINT         NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity   INTEGER        NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0)
);

-- ── Indexes ───────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_products_category    ON products(category);
CREATE INDEX IF NOT EXISTS idx_orders_customer_email ON orders(customer_email);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id  ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

-- ── Seed: demo user ───────────────────────────────────────────────────────────
INSERT INTO users (username, email, password_hash) VALUES
    ('demo_user', 'demo@shoplocal.dev', '$2a$10$demoHashNotRealDoNotUse000000000000000000000000000')
ON CONFLICT DO NOTHING;

-- ── Seed: products ────────────────────────────────────────────────────────────
INSERT INTO products (name, description, price, category, stock_quantity) VALUES
    ('Mechanical Keyboard',
     'Tactile switches, RGB backlighting, TKL layout. Great for long coding sessions.',
     129.99, 'Electronics', 15),

    ('Noise-Cancelling Headphones',
     'Studio-quality sound, 30-hour battery, foldable design.',
     249.99, 'Electronics', 8),

    ('Ergonomic Mouse',
     'Vertical grip reduces wrist strain. 6 programmable buttons, wireless.',
     59.99, 'Electronics', 22),

    ('Laptop Stand',
     'Aluminium, adjustable 0-20°, compatible with 11-17 inch laptops.',
     39.99, 'Accessories', 50),

    ('USB-C Hub (7-in-1)',
     '4K HDMI, 100W PD, 2x USB-A, SD/microSD reader. Plug-and-play.',
     44.99, 'Accessories', 30),

    ('Desk Plant (Succulent)',
     'Low-maintenance, air-purifying. Ships in a decorative pot.',
     14.99, 'Home', 0),

    ('Monitor Light Bar',
     'Anti-glare LED bar clips onto any monitor. USB powered, touch dimmer.',
     34.99, 'Electronics', 45),

    ('Cable Management Kit',
     'Velcro straps, adhesive clips, cable box. Tidy desk guaranteed.',
     19.99, 'Accessories', 100)

ON CONFLICT DO NOTHING;
