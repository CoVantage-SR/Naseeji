# Stage 1: Build stage
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Stage 2: Production Runner stage
FROM node:20-alpine AS runner

WORKDIR /app

# Install curl for Docker healthcheck probe
RUN apk add --no-cache curl

ENV NODE_ENV=production
ENV PORT=5000

COPY package*.json ./
RUN npm ci --only=production

COPY --from=builder /app/dist ./dist

# Create logs directory with node user permissions
RUN mkdir -p logs && chown -R node:node /app

USER node

EXPOSE 5000

HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:5000/api/v1/live || exit 1

CMD ["node", "dist/server.js"]
