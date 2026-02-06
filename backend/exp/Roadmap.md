# 🗺️ Go API Development Roadmap: From Zero to Production

This guide is for those who want to build things the right way. We go slow, we stay correct, and we remain opinionated. This is the path we took to build this API.

---

## 🏗️ Chapter 1: The Foundation (System Setup)
**Goal:** Create a rock-solid environment using Go's built-in strengths.

### Step 0: The Go Philosophy
Go is built for simplicity. We use the standard tools as much as possible.
- **Check Go:** Run `go version`.
- **The Modern Way:** Forget `GOPATH`. We use **Go Modules**.
  ```bash
  go mod init github.com/jatinfoujdar/go-api
  ```
- **Structure:** We use the `cmd/` and `internal/` pattern.
  - `cmd/api/main.go`: The only place where the application starts.
  - `internal/`: Where the magic happens. Code here cannot be imported by external packages—private by design.

---

## 🔌 Chapter 2: The Data Layer (Connecting to MongoDB)
**Goal:** Don't just connect; connect *safely*.

### Step 1: Environment Variables
We use `.env` files to store secrets like `MONGO_URI`.
- **Tool:** `github.com/joho/godotenv`
- **Why:** Hardcoding strings is a rookie mistake. Environment variables make your code portable.

### Step 2: Connection & The "Ping"
In `internal/config/databaseConnection.go`, we don't just "connect"—we verify.
- **Context with Timeout:** We give the DB 10 seconds to respond.
- **The Ping:** We immediately ping the server. If it fails, the app `panics`. 
- **The "Why":** A backend without a database is a body without a heart. It's better to fail early than to run in a broken state.

---

## � Chapter 3: Designing the Blueprint (Models)
**Goal:** Translate between Go's logic and MongoDB's storage.

### Step 1: The User Struct
In `internal/models/userModel.go`, we define exactly what a user looks like.
- **BSON vs. JSON:** Use `bson` tags for how it's stored, and `json` tags for how the API sends it.
- **IDs:** Use `primitive.ObjectID`. It's the native MongoDB identifier.
- **Validation:** Use `validate` tags (from `go-playground/validator`) to enforce rules (like email format) at the struct level.

---

## 🧪 Chapter 4: Plaintext Auth (Understanding the Flow)
**Goal:** Get the "plumbing" working before adding complexity.

### Step 1: The Signup Logic
Initially, we focus on getting data from a POST request into the database.
- **Binding:** Use `c.ShouldBindJSON` to catch errors early.
- **The "Simple" Way:** For a fleeting moment, we save the password exactly as it came in.
- **Warning:** This is *strictly* a learning step to ensure your database queries and routes are working.

---

## 🔐 Chapter 5: The Secret Scramble (Password Hashing)
**Goal:** Never store a user's password. Ever.

### Step 1: Enter Bcrypt
We replace the "simple" password storage with a hash.
- **Tool:** `golang.org/x/crypto/bcrypt`
- **The Process:** 
  1. Take the password.
  2. Generate a hash with a "Cost" (we use 14).
  3. Store only the hash.
- **Verification:** During login, we compare the submitted password against the hash. We never "decrypt"; we only "compare."

---

## 🔑 Chapter 6: The Digital Handshake (JWT)
**Goal:** Issue a secure "Identity Card" to the user.

### Step 1: Token Generation
In `internal/handler/authHelper.go`, we generate tokens.
- **Access Token:** Short-lived (24h) for making requests.
- **Refresh Token:** Long-lived (7 days) for getting new access tokens.
- **Why:** If an access token is stolen, the window of damage is small.

---

## 🛡️ Chapter 7: The Guard (Middleware)
**Goal:** Automatic protection for your API.

### Step 1: The Interceptor
Before any "Protected" route is hit, the code in `internal/middleware/authMiddleware.go` runs.
- **The Check:** It extracts the `token` from the header.
- **The Choice:** If the token is valid, it proceeds (`c.Next()`). If not, it stops immediately (`c.Abort()`).
- **Context:** We pass the user's details (UID, Email) down to the controller so we know "who" is performing the action.

---

## 🚀 Chapter 8: Mastering the API (Advanced Features)
**Goal:** Make it production-ready.

### Step 1: Aggregation Power
When listing users, we use MongoDB's **Aggregation Pipelines**.
- **Pagination:** Don't send 10,000 users. Send 10.
- **Projection:** Exclude the `password` field from the result, even if it's hashed.
- **The Why:** Speed and security. A "leaky" API is a vulnerable one.

---
*Status: 100% Comprehensive*
