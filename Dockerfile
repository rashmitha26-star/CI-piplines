Multi-Stage Dockerfile — Explained
# ─── Stage 1: BUILD STAGE ───────────────────────────────
# Heavy image with all build tools — discarded after build
FROM node:20-alpine AS builder
 
WORKDIR /app
# WHY WORKDIR: Prevents files landing in / root.
# Gives a clean, predictable path inside the container.
 
COPY package.json package-lock.json ./
# WHY copy package files FIRST (before source code):
# Docker caches each layer. If package.json unchanged,
# "npm install" is SKIPPED — builds go from 5min to 30s.
 
RUN npm ci --only=production
# WHY "npm ci" not "npm install":
# ci = clean install, uses exact lockfile — reproducible builds.
 
COPY . .
RUN npm run build
 
# ─── Stage 2: PRODUCTION STAGE ──────────────────────────
# Minimal image — build tools, source, tests all excluded
FROM node:20-alpine AS production
 
# Security: Run as non-root user
# WHY: If container is compromised, attacker gets limited
# privileges — not root access to the host.
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
 
WORKDIR /app
 
# Copy ONLY built output from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
 
USER appuser
EXPOSE 3000
 
# Health check — Kubernetes uses this to determine pod health
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget --spider http://localhost:3000/health || exit 1
 
CMD ["node", "dist/server.js"]
