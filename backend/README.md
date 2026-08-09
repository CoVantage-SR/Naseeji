# NASEEJI Backend — Phase 00 Infrastructure & Core Foundation

This is the backend foundation for NASEEJI — Enterprise B2B Textile Marketplace. It is built on Node.js, TypeScript, Express, MongoDB (Mongoose), Redis (ioredis), MinIO (S3 compatible storage), and Mailpit (SMTP mail testing service).

---

## 📋 1. Requirements

Before running the server, make sure you have the following installed:
* **Node.js**: `v20.x` or later (Long Term Support)
* **npm**: `v10.x` or later
* **Docker & Docker Compose** (for containerized infrastructure setup)
* **Windows PowerShell / Linux Bash**

---

## ⚙️ 2. Environment Variables & Configurations

The backend utilizes strict configuration validation powered by **Zod**. If any required environment variable is missing or malformed, the startup bootstrapper will throw a validation error and abort.

Copy `.env.example` to create a `.env` file:
```bash
cp .env.example .env
```

Key environment configurations are summarized below:

| Environment Variable | Description | Local Dev Value | Docker Container Value |
|----------------------|-------------|-----------------|------------------------|
| `NODE_ENV` | Environment Type | `development` | `development` / `production` |
| `PORT` | Server Port | `5000` | `5000` |
| `API_PREFIX` | Versioned API route prefix | `/api/v1` | `/api/v1` |
| `MONGODB_URI` | MongoDB Connection String | `mongodb://admin:admin123@127.0.0.1:27017/naseeji?authSource=admin` | `mongodb://admin:admin123@mongodb:27017/naseeji?authSource=admin` |
| `REDIS_URL` | Redis URL with credentials | `redis://:redis123@127.0.0.1:6379` | `redis://:redis123@redis:6379` |
| `MINIO_ENDPOINT` | MinIO Host Endpoint | `127.0.0.1` | `minio` |
| `MINIO_PORT` | MinIO API Port | `9000` | `9000` |
| `MINIO_ACCESS_KEY` | MinIO Access Key credential | `minioadmin` | `minioadmin` |
| `MINIO_SECRET_KEY` | MinIO Secret Key credential | `minioadmin123` | `minioadmin123` |
| `MINIO_BUCKET_NAME` | S3 Uploads Bucket | `naseeji-uploads` | `naseeji-uploads` |
| `SMTP_HOST` | SMTP Server Host (Mailpit) | `127.0.0.1` | `mailpit` |
| `SMTP_PORT` | SMTP Server Port | `1025` | `1025` |
| `JWT_SECRET` | Secret key for JWT Access Token | *[Secure Random]* | *[Secure Random]* |
| `JWT_REFRESH_SECRET` | Secret key for JWT Refresh Token | *[Secure Random]* | *[Secure Random]* |

*Note: Production values should never be committed to source control.*

---

## 🐳 3. Docker Startup (Recommended)

To run the complete environment with all database, caching, mailing, and storage services fully pre-wired:

1. Build and run containers in detached mode:
   ```powershell
   docker compose up -d --build
   ```
2. Verify all services are online and healthy:
   ```powershell
   docker compose ps
   ```

### Infrastructure Services Exposed Externally:
* **Backend Application API**: [http://localhost:5000](http://localhost:5000)
* **MongoDB Database Port**: `localhost:27017`
* **Redis Cache Port**: `localhost:6379`
* **MinIO Console (S3 storage UI)**: [http://localhost:9001](http://localhost:9001) (User: `minioadmin` / Pass: `minioadmin123`)
* **Mongo Express (Database GUI)**: [http://localhost:8081](http://localhost:8081) (User: `admin` / Pass: `admin123`)
* **Mailpit (Development Webmail UI)**: [http://localhost:8025](http://localhost:8025)

---

## 💻 4. Local Development Startup

If you want to run the Node.js process directly on Windows/Linux host machine while database services run in Docker:

1. Start all infrastructure services (excluding backend container):
   ```powershell
   docker compose up -d mongodb redis minio mailpit mongo-express
   ```
2. Install node dependencies:
   ```bash
   npm install
   ```
3. Run the development server (watches and restarts on changes):
   ```bash
   npm run dev
   ```
4. Build the application for production release:
   ```bash
   npm run build
   ```
5. Start the production build:
   ```bash
   npm start
   ```

---

## 🔌 5. Infrastructure Connections & Failover

The adapters for MongoDB, Redis, MinIO, and Mailpit contain built-in smart fallback options. If they cannot resolve the container hostnames (e.g. `mongodb`, `redis`, `minio`, `mailpit` - which are only resolvable within the Docker network), they will automatically print a warning and retry connecting to `127.0.0.1` locally, which allows seamless local environment development without modifying environment variables.

### connection Pooling & Limits (MongoDB):
MongoDB uses connection pooling configured via:
* `MONGODB_MIN_POOL_SIZE` (default `5`)
* `MONGODB_MAX_POOL_SIZE` (default `20`)
* Connect Timeout is capped at 5000ms.

---

## 🩺 6. Health & Readiness Probes

We implement distinct liveness and readiness endpoints conforming to enterprise orchestration standards:

1. **Liveness Probe**: `GET /api/v1/live` (or root `/health`)
   * Verifies if the backend process is up.
   * Returns: `HTTP 200 OK`
2. **Readiness Probe**: `GET /api/v1/ready` (or `GET /api/v1/health`)
   * Verifies if the backend can actually connect to the database, caching server, object storage, and mail server.
   * Returns: `HTTP 200` if all services are fully connected, or `HTTP 503` if any of them is degraded.

---

## 📖 7. OpenAPI Swagger Documentation

We serve the official api specifications at runtime:
* **Interactive UI Paths**:
  * [http://localhost:5000/swagger](http://localhost:5000/swagger)
  * [http://localhost:5000/api/docs](http://localhost:5000/api/docs)
* **Spec Source File**: `/src/docs/swagger.json`

---

## 🧪 8. Testing Suite

The testing engine runs Jest with full TypeScript and ES Module support.

* Run all tests (Unit + E2E):
  ```bash
  npm test
  ```
* Run with code coverage reporting:
  ```bash
  npm run test:coverage
  ```
* Run linter:
  ```bash
  npm run lint
  ```
* Format code with Prettier:
  ```bash
  npm run format
  ```

---

## 🌐 9. Development vs Docker Networking

* **Docker Network (`naseeji-network`)**: A private bridge network. Inside containers, services refer to each other using their Docker Compose service names (e.g. `mongodb:27017`, `redis:6379`, `minio:9000`, `mailpit:1025`).
* **Host Machine Access**: The host machine cannot resolve container names directly. Therefore, local Node.js processes access the services via port-forwarding to `127.0.0.1` (e.g. `127.0.0.1:27017`). The fallback connection behavior automates this bridge.

---

## 🛠️ 10. Troubleshooting

### Problem: Jest tests hanging or process failing to exit
* **Cause**: This happens if there are active sockets or unclosed connection handles remaining.
* **Fix**: Ensure that `afterAll` inside tests explicitly disconnects mongoose connection and quits redis client. DailyRotateFile logger transports should be disabled in `test` environment to avoid file stream timers.

### Problem: MongoDB fails to authenticate
* **Cause**: Missing database username/password or incorrect database authSource in connection string.
* **Fix**: Make sure `authSource=admin` parameter is appended to the connection URI when using username credentials.
