# Naseeji

Naseeji is a professional B2B marketplace connecting textile suppliers with garment factories.

---

## 🚀 CI/CD Architecture & GitHub Pages Deployment

This repository uses an enterprise-grade **GitHub Actions workflow** (`.github/workflows/deploy_web.yml`) to automatically test, build, and deploy the Flutter Web application to **GitHub Pages**.

---

### 🛠 How CI/CD Works

Every time code is pushed to `main` or `development`, GitHub Actions triggers a multi-job pipeline:

```
[ Push to main / development ]
             │
             ▼
   ┌───────────────────┐
   │  1. Checkout Repo │
   └─────────┬─────────┘
             │
             ▼
   ┌───────────────────┐
   │ 2. Install Flutter│ (Channel: Stable with SDK Cache)
   └─────────┬─────────┘
             │
             ▼
   ┌───────────────────┐
   │ 3. Pub Cache      │ (Restores ~/.pub-cache using pubspec.lock hash)
   └─────────┬─────────┘
             │
             ▼
   ┌───────────────────┐
   │ 4. Pub Get        │
   └─────────┬─────────┘
             │
             ▼
   ┌───────────────────┐
   │ 5. Analyze Code   │ ──(Fails?)──► [ STOP Pipeline ]
   └─────────┬─────────┘
             │
             ▼
   ┌───────────────────┐
   │ 6. Run Tests      │ ──(Fails?)──► [ STOP Pipeline ]
   └─────────┬─────────┘
             │
             ▼
   ┌───────────────────┐
   │ 7. Build Web      │ (CanvasKit renderer & Icon Tree-shaking)
   └─────────┬─────────┘
             │
             ▼
   ┌───────────────────┐
   │ 8. Upload Artifact│
   └─────────┬─────────┘
             │
             ▼
   ┌───────────────────┐
   │ 9. Deploy Pages   │ (Target Environment: github-pages)
   └───────────────────┘
```

#### Key Pipeline Features & Safeguards:
* **Quality Gate Enforcement**: Any failure in `flutter analyze` or `flutter test` immediately halts the workflow and blocks deployment.
* **Smart Caching**: Caches both the Flutter SDK binaries and pub dependencies to optimize build time.
* **Concurrency Control**: Automatically cancels pending or duplicate runs on the same branch when a new commit is pushed (`cancel-in-progress: true`).
* **Timeout Protection**: Strict timeouts (`25m` for build/test, `10m` for deployment) prevent stuck runners.
* **Least-Privilege Security**: Permissions are strictly scoped to `contents: read`, `pages: write`, and `id-token: write`.

---

### ⚙️ How to Enable GitHub Pages (One-Time Setup)

To allow GitHub Actions to deploy to GitHub Pages:

1. Open your repository on GitHub: `https://github.com/<owner>/<repo>`
2. Go to **Settings** > **Pages** (under Code and automation).
3. Under **Build and deployment**:
   * **Source**: Select **GitHub Actions**.
4. Save your changes.

---

### 📦 How to Deploy

Deployment occurs automatically via the CI/CD pipeline whenever code is merged or pushed to:
* `main` (Production deployment)
* `development` (Staging/Dev deployment)

---

### ⚡ How to Trigger Deployment

#### Automatic Trigger:
Push your changes or merge a Pull Request into `main` or `development`:
```bash
git checkout main
git pull origin main
# (Make your changes)
git add .
git commit -m "feat: updated web app features"
git push origin main
```

#### Manual Trigger (Workflow Dispatch):
1. Go to the **Actions** tab in your GitHub repository.
2. Select **Build & Deploy Flutter Web to GitHub Pages** from the left sidebar.
3. Click the **Run workflow** dropdown button.
4. Select the target branch (`main` or `development`) and click **Run workflow**.

---

### 🔄 How to Rollback

If a bad deployment occurs in production:

#### Option 1: Revert Commit & Push (Recommended)
Revert the bad commit on `main` and push. CI/CD will automatically test, build, and deploy the healthy version:
```bash
git checkout main
git pull origin main
git revert HEAD # or git revert <commit-hash>
git push origin main
```

#### Option 2: Re-deploy a Previous Successful Workflow Run
1. Navigate to **Actions** > **Build & Deploy Flutter Web to GitHub Pages**.
2. Click on a **previous successful workflow run** from the list.
3. Click the **Re-run all jobs** button at the top right.
4. GitHub Pages will re-deploy the artifact generated from that exact historical commit.
