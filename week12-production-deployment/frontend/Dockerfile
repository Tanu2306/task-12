# ── Stage 1: Build ──────────────────────────────────────────────────────────
FROM node:18-alpine AS builder
WORKDIR /app

# Copy dependency manifests first (layer-cache optimisation)
COPY package.json package-lock.json* ./
RUN npm ci --silent

# Copy source and build
COPY . .
RUN npm run build

# ── Stage 2: Serve ──────────────────────────────────────────────────────────
FROM nginx:alpine AS production

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom nginx config
COPY nginx.conf /etc/nginx/conf.d/app.conf

# Copy built static files
COPY --from=builder /app/dist /usr/share/nginx/html

# Non-root: nginx master runs as root (required for port 80) but workers can
# be restricted; for full non-root move to port 8080 – acceptable for student scope.
EXPOSE 80

# Health-check so Docker Compose / K8s knows when nginx is ready
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost/index.html || exit 1

CMD ["nginx", "-g", "daemon off;"]
