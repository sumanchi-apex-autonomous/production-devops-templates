# ==============================================================================
# Hardened Multi-Stage Dockerfile for High-Reliability Services
# ==============================================================================

# Stage 1: Build & Dependencies
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

RUN apk add --no-cache libc6-compat

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build --if-present
RUN npm prune --production

# Stage 2: Minimal Hardened Production Runtime
FROM node:20-alpine AS production

LABEL maintainer="Apex Autonomous Technologies <support@apexautonomous.com>"
LABEL description="Hardened minimal production container image"

WORKDIR /usr/src/app

ENV NODE_ENV=production \
    PORT=8000

# Install minimal healthcheck tool
RUN apk add --no-cache curl \
    && rm -rf /var/cache/apk/*

# Create dedicated non-root user and group
RUN addgroup -g 1001 -S apexgroup \
    && adduser -u 1001 -S apexuser -G apexgroup

COPY --from=builder --chown=apexuser:apexgroup /usr/src/app/node_modules ./node_modules
COPY --from=builder --chown=apexuser:apexgroup /usr/src/app/package*.json ./
COPY --from=builder --chown=apexuser:apexgroup /usr/src/app/dist ./dist 2>/dev/null || true
COPY --from=builder --chown=apexuser:apexgroup /usr/src/app/src ./src 2>/dev/null || true

USER apexuser

EXPOSE 8000

HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

CMD ["node", "src/index.js"]
