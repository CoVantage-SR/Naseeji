# NASEEJI B2B Marketplace — Enterprise API Testing Guide

**Base URL**: `http://localhost:5000/api/v1`  
**Interactive Swagger UI**: [http://localhost:5000/swagger](http://localhost:5000/swagger)  
**Root Health Check**: [http://localhost:5000/health](http://localhost:5000/health)  

---

## 🔑 Pre-Seeded Test Credentials (`npm run seed`)

- **Factory Account**:
  - `email`: `factory@naseeji.com`
  - `password`: `Password@123`
- **Supplier Account**:
  - `email`: `supplier@naseeji.com`
  - `password`: `Password@123`
- **Admin Account**:
  - `email`: `admin@naseeji.com`
  - `password`: `Password@123`

---

## 🚀 Complete API Endpoint Testing List

### 1. Register Factory
- **Endpoint**: `POST /api/v1/auth/register/factory`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "email": "new.factory@naseeji.com",
  "phone": "+201099887766",
  "password": "Password@123",
  "companyName": "Cairo Textile Factory Ltd",
  "factoryType": "apparel",
  "governorate": "Cairo",
  "city": "Cairo",
  "address": "Industrial Zone 5, Cairo",
  "commercialRegistration": "CR-99887766",
  "taxNumber": "TAX-11223344"
}
```

---

### 2. Register Supplier
- **Endpoint**: `POST /api/v1/auth/register/supplier`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "email": "new.supplier@naseeji.com",
  "phone": "+201188776655",
  "password": "Password@123",
  "companyName": "Alexandria Cotton Mills",
  "supplierCategory": "fabric_manufacturer",
  "governorate": "Alexandria",
  "address": "Textile Hub 3, Alexandria",
  "commercialRegistration": "CR-55443322",
  "taxNumber": "TAX-66778899"
}
```

---

### 3. Login User (Email / Phone)
- **Endpoint**: `POST /api/v1/auth/login`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "target": "factory@naseeji.com",
  "password": "Password@123",
  "deviceId": "dev-device-001",
  "deviceName": "Chrome Browser",
  "deviceType": "browser",
  "osVersion": "Windows 11",
  "appVersion": "1.0.0"
}
```
- **Response Data**: Returns `accessToken` (15m TTL), `refreshToken` (30d TTL), and `user` object.

---

### 4. Google OAuth 2.0 Login / Registration
- **Endpoint**: `POST /api/v1/auth/google`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "idToken": "SAMPLE_GOOGLE_ID_TOKEN",
  "accountType": "factory",
  "deviceId": "dev-device-001",
  "deviceName": "Android Mobile Phone",
  "deviceType": "android"
}
```

---

### 5. Send WhatsApp OTP
- **Endpoint**: `POST /api/v1/auth/send-otp`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "phone": "+201000000001",
  "type": "phone_verification"
}
```
- **Response**: Generates a 6-digit OTP code stored in Redis (5-minute TTL). In non-production mode, returns `debugOtp`.

---

### 6. Verify WhatsApp OTP
- **Endpoint**: `POST /api/v1/auth/verify-otp`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "phone": "+201000000001",
  "type": "phone_verification",
  "otpCode": "123456"
}
```

---

### 7. Refresh Access Token (Token Rotation)
- **Endpoint**: `POST /api/v1/auth/refresh` or `POST /api/v1/auth/refresh-token`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "refreshToken": "YOUR_VALID_REFRESH_TOKEN"
}
```

---

### 8. Get User Profile & Wallet Details
- **Endpoint**: `GET /api/v1/auth/profile` or `GET /api/v1/auth/me`
- **Headers**:
  - `Authorization: Bearer <YOUR_ACCESS_TOKEN>`

---

### 9. Update Factory / Supplier Profile
- **Endpoint**: `PATCH /api/v1/auth/profile`
- **Headers**:
  - `Authorization: Bearer <YOUR_ACCESS_TOKEN>`
  - `Content-Type: application/json`
- **Body**:
```json
{
  "companyName": "Updated Factory Name",
  "governorate": "Giza",
  "city": "6th of October"
}
```

---

### 10. List Active Devices & Sessions
- **Endpoint**: `GET /api/v1/auth/devices`
- **Headers**:
  - `Authorization: Bearer <YOUR_ACCESS_TOKEN>`

---

### 11. Revoke Specific Device
- **Endpoint**: `DELETE /api/v1/auth/device/:id`
- **Headers**:
  - `Authorization: Bearer <YOUR_ACCESS_TOKEN>`

---

### 12. Logout Current Session
- **Endpoint**: `POST /api/v1/auth/logout`
- **Headers**:
  - `Authorization: Bearer <YOUR_ACCESS_TOKEN>`
  - `Content-Type: application/json`
- **Body**:
```json
{
  "refreshToken": "YOUR_CURRENT_REFRESH_TOKEN"
}
```

---

### 13. Logout All Sessions & Devices
- **Endpoint**: `POST /api/v1/auth/logout-all`
- **Headers**:
  - `Authorization: Bearer <YOUR_ACCESS_TOKEN>`
