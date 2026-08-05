# Naseeji

Naseeji is a professional B2B marketplace connecting textile suppliers with garment factories.

---

## 🚀 Enterprise CI/CD Architecture & GitHub Automation

This project follows **Enterprise CI/CD Architecture Standards** (decoupled modular pipelines with quality isolation and reusable components).

```text
.github/
└── workflows/
    ├── reusable/
    │   └── flutter_setup.yml    # Reusable workflow (Java, Flutter, Caching, Pub Get)
    ├── analyze.yml              # Fast static code analysis
    ├── tests.yml                # Unit, Widget & Golden UI Tests (with artifact uploads)
    ├── deploy_web.yml           # GitHub Pages Web deployment (Test-isolated)
    ├── build_android.yml        # Android APK build & artifact upload
    └── release_android.yml      # Release workflow for APK & AAB assets
```

---

### 🏛 Why the Deployment Pipeline Was Failing & How the New Architecture Solves It

#### The Problem:
Previously, running `flutter test` directly inside the deployment workflow (`deploy_web.yml`) caused Web deployments to fail. 
* **Golden Tests & Widget Tests** perform sub-pixel rendering checks.
* GitHub Actions Linux runners use headless Skia/Impeller rendering with standard Linux font engines (FreeType), which produce microscopic anti-aliasing or font rendering differences compared to local development environments (macOS/Windows).
* Coupling deployment to Golden UI tests meant harmless sub-pixel rendering discrepancies completely blocked production web deployments.

#### The Enterprise Solution:
* **Separation of Concerns & Quality Isolation**:
  * **`deploy_web.yml`**: Responsible *strictly* for verifying compilation integrity via `flutter analyze` and building/deploying `build/web` to GitHub Pages. It never fails due to Golden UI test differences.
  * **`tests.yml`**: Dedicated test runner for Unit, Widget, and Golden UI Tests. If Golden tests fail on Linux runners, it captures and uploads the failure diff images (`test/**/*_test.png`, `build/test_failures`) as GitHub Artifacts for team inspection without blocking web deployment.
  * **`reusable/flutter_setup.yml`**: Centralizes Flutter SDK setup, Java 17 configuration, Pub package caching (`~/.pub-cache`), and dependency installation across all pipelines.

---

### ⚙️ Enabling GitHub Pages (One-Time Setup)

1. Open your repository on GitHub: `https://github.com/<owner>/<repo>`
2. Go to **Settings** > **Pages**.
3. Under **Build and deployment**:
   * **Source**: Select **GitHub Actions**.
4. Save settings.

---

### 📋 CI/CD Workflows Summary

| Workflow | Trigger | Primary Action | Artifacts / Output |
| :--- | :--- | :--- | :--- |
| `analyze.yml` | `push`, `pull_request` | `flutter analyze` | Console Report |
| `tests.yml` | `push`, `pull_request` | `flutter test --coverage` | `golden-test-failures` (if failed) |
| `deploy_web.yml` | `push` (`main`, `development`) | `flutter build web --release` | Live GitHub Pages Site |
| `build_android.yml` | `push`, `pull_request` | `flutter build apk --release` | `app-release-apk` |
| `release_android.yml` | `release` (published) | `flutter build apk & appbundle` | Attached to GitHub Release |

---

### ⚡ Triggering Workflows & Manual Execution

All workflows support manual execution via `workflow_dispatch` under the **Actions** tab in GitHub.
Automatic execution triggers on pushing or opening Pull Requests against `main` or `development`.
