# CI Pipeline Project

A Java Spring Boot application with **CI (Continuous Integration)** pipeline.

## 🚀 Quick Start

```bash
# Push code to trigger CI
git add .
git commit -m "your changes"
git push origin main

# CI will automatically:
# 1. Build and test
# 2. Create Docker image
# 3. Scan for vulnerabilities
# 4. Push to GitHub Container Registry
```

## 🏗️ Architecture

```
Developer Push → CI Pipeline → Docker Image in GHCR → ArgoCD (separate repo)
                     ↓
              (Tests, Build, Scan)
```

**Note:** CD (deployment) is handled by ArgoCD in a separate repository

## 📁 Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── ci-pipeline.yml           # ✅ CI Pipeline (Active)
│       └── blue-green-deploy.yml     # 📦 Old monolithic pipeline (Reference)
├── src/                              # Java Spring Boot application
├── Dockerfile                        # Docker image definition
├── pom.xml                          # Maven configuration
├── QUICK-START.md                   # 👈 Start here!
├── CI-CD-SEPARATION.md              # Detailed guide
└── PIPELINE-COMPARISON.md           # Before vs After
```

## 🔄 CI Pipeline

**File:** `.github/workflows/ci-pipeline.yml`

### What It Does:
1. ✅ **Build & Test** - Compiles Java code and runs unit tests
2. ✅ **Docker Build** - Creates Docker image with the application
3. ✅ **Security Scan** - Scans for vulnerabilities with Trivy
4. ✅ **Publish** - Pushes image to GitHub Container Registry

### Triggers:
- Push to `main` or `develop` branches
- Pull requests to `main`

### Duration: ~10 minutes

## 🐳 Docker Image

Images are published to GitHub Container Registry:

```bash
ghcr.io/YOUR-USERNAME/ci-piplines:COMMIT-SHA
```

### Available Tags:
- `latest` - Latest build from main branch
- `COMMIT-SHA` - Specific commit
- `main` - Latest from main branch
- `YYYYMMDD-HHmmss` - Timestamp

## 🛠️ Local Development

### Prerequisites:
- Java 17
- Maven 3.6+
- Docker (optional)

### Build Locally:
```bash
# Run tests
mvn test

# Build JAR
mvn clean package

# Run application
java -jar target/*.jar
```

### Build Docker Image:
```bash
# Build
docker build -t my-app .

# Run
docker run -p 8080:8080 my-app
```

## 📚 Documentation

- **[QUICK-START.md](QUICK-START.md)** - Get started in 5 minutes
- **[CI-CD-SEPARATION.md](CI-CD-SEPARATION.md)** - Why we separated CI and CD
- **[PIPELINE-COMPARISON.md](PIPELINE-COMPARISON.md)** - Before vs After comparison

## 🔐 Security

- **Trivy Scanning** - Automated vulnerability detection
- **SARIF Reports** - Integrated with GitHub Security
- **Fail on Critical** - Pipeline fails if critical vulnerabilities found

## 🎯 Next Steps

### For Developers:
1. Read [QUICK-START.md](QUICK-START.md)
2. Push code and watch CI pipeline run
3. Review test results and security reports

### For DevOps:
1. Review [CI-CD-SEPARATION.md](CI-CD-SEPARATION.md)
2. Plan CD pipeline implementation
3. Set up GitOps repository (when ready)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Push and create a Pull Request
4. CI pipeline will run automatically
5. Review results and merge when green ✅

## 📊 Pipeline Status

![CI Pipeline](https://github.com/YOUR-USERNAME/ci-piplines/actions/workflows/ci-pipeline.yml/badge.svg)

## 📝 License

[Your License Here]

## 🆘 Support

Having issues? Check:
1. [QUICK-START.md](QUICK-START.md) - Troubleshooting section
2. GitHub Actions logs
3. Security scan reports

---

**Ready to deploy?** When you're ready for the CD pipeline, we'll set up:
- GitOps repository
- ArgoCD integration
- Blue-green deployments
- Automated rollbacks
