# 🚀 Quick Start Guide - CI Pipeline

## What Just Happened?

Your pipeline has been **separated into CI and CD**. Right now, you have a **working CI pipeline** that:
- ✅ Builds your Java application
- ✅ Runs tests automatically
- ✅ Scans for security vulnerabilities
- ✅ Publishes Docker images to GitHub Container Registry

---

## 🎯 What You Need to Do Now

### 1. Test the CI Pipeline

**Option A: Push to a branch**
```bash
# Make a small change
echo "# CI Pipeline Test" >> README.md

# Commit and push
git add README.md
git commit -m "test: trigger CI pipeline"
git push origin main
```

**Option B: Create a Pull Request**
```bash
# Create a new branch
git checkout -b test-ci-pipeline

# Make a change
echo "Testing CI" >> README.md

# Push and create PR
git add README.md
git commit -m "test: CI pipeline"
git push origin test-ci-pipeline

# Then create PR on GitHub
```

### 2. Watch the Pipeline Run

1. Go to your repository on GitHub
2. Click the **"Actions"** tab
3. You'll see **"CI Pipeline - Build, Test & Publish"** running
4. Click on it to see the progress

### 3. Check the Results

After the pipeline completes, you'll see:
- ✅ **Build and Test** - Green checkmark if passed
- ✅ **Docker Build and Scan** - Image published
- ✅ **CI Summary** - Overall status
- 📦 **Artifacts** - JAR file and security report

---

## 📦 Where Is Your Docker Image?

Your image is published to **GitHub Container Registry (GHCR)**:

```
ghcr.io/YOUR-USERNAME/ci-piplines:COMMIT-SHA
```

### View Your Images:
1. Go to your GitHub profile
2. Click **"Packages"** tab
3. You'll see your published images

### Pull Your Image:
```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR-USERNAME --password-stdin

# Pull the image
docker pull ghcr.io/YOUR-USERNAME/ci-piplines:latest
```

---

## 🔍 Understanding the Pipeline

### Job 1: Build and Test (5-7 minutes)
```
📥 Checkout code
☕ Setup Java 17
🧪 Run unit tests
📊 Generate coverage report
🔨 Build JAR with Maven
📦 Upload artifact
```

### Job 2: Docker Build and Scan (3-5 minutes)
```
📦 Download JAR
🐳 Setup Docker Buildx
🏗️ Build Docker image
🔍 Run Trivy security scan
🚀 Push to GHCR
```

### Job 3: CI Summary
```
📊 Generate summary report
💬 Comment on PR (if applicable)
```

---

## 🛠️ Customizing the Pipeline

### Change Java Version
Edit `.github/workflows/ci-pipeline.yml`:
```yaml
env:
  JAVA_VERSION: '17'  # Change to '11', '17', '21', etc.
```

### Change Security Scan Severity
```yaml
- name: 🔍 Run Trivy Vulnerability Scanner
  with:
    severity: 'CRITICAL,HIGH'  # Add 'MEDIUM' or 'LOW'
```

### Change Image Registry
```yaml
env:
  REGISTRY: ghcr.io  # Change to docker.io, quay.io, etc.
```

### Add More Tests
The pipeline runs `mvn test`. To add integration tests:
```yaml
- name: 🧪 Run Integration Tests
  run: mvn verify -B
```

---

## 🚨 Troubleshooting

### Pipeline Fails at "Run Unit Tests"
**Problem:** Tests are failing  
**Solution:** 
```bash
# Run tests locally
mvn test

# Fix failing tests
# Then commit and push
```

### Pipeline Fails at "Trivy Security Scan"
**Problem:** Critical vulnerabilities found  
**Solution:**
1. Download the `trivy-security-report` artifact
2. Review vulnerabilities
3. Update dependencies in `pom.xml`
4. Update base image in `Dockerfile`

### Pipeline Fails at "Push Docker Image"
**Problem:** Permission denied  
**Solution:**
1. Go to repository **Settings**
2. Click **Actions** → **General**
3. Scroll to **Workflow permissions**
4. Select **"Read and write permissions"**
5. Click **Save**

### Can't See Published Images
**Problem:** Package visibility  
**Solution:**
1. Go to your **Packages** on GitHub
2. Click on the package
3. Click **"Package settings"**
4. Change visibility to **Public** (if desired)

---

## 📊 Monitoring Your Pipeline

### GitHub Actions Dashboard
- **Actions** tab shows all workflow runs
- Green ✅ = Success
- Red ❌ = Failed
- Yellow 🟡 = In progress

### Pull Request Comments
The pipeline automatically comments on PRs with:
- Build status
- Test results
- Image tags
- Security scan status

### Email Notifications
GitHub sends emails when:
- Pipeline fails
- Pipeline succeeds (after failure)

---

## 🎓 What's Next?

### Phase 1: ✅ CI Pipeline (DONE)
You now have automated:
- Building
- Testing
- Security scanning
- Image publishing

### Phase 2: 🔜 CD Pipeline (Coming)
Next, we'll create:
- Deployment automation
- Environment management
- Blue-green deployments
- Rollback capabilities

### When You're Ready for CD:
Just let me know, and we'll create:
1. `cd-pipeline.yml` - Deployment workflow
2. GitOps repository setup
3. ArgoCD configuration
4. Blue-green deployment strategy

---

## 💡 Pro Tips

### 1. Use Branch Protection
Require CI to pass before merging:
1. Go to **Settings** → **Branches**
2. Add rule for `main` branch
3. Check **"Require status checks to pass"**
4. Select **"Build and Test"** and **"Docker Build and Scan"**

### 2. Review Security Reports
Always check the Trivy report:
- Download from **Artifacts**
- Open `trivy-report.html` in browser
- Review and fix vulnerabilities

### 3. Use Semantic Versioning
Update version in `pom.xml`:
```xml
<version>1.0.0</version>  <!-- Follow semver: MAJOR.MINOR.PATCH -->
```

### 4. Cache Dependencies
The pipeline already caches Maven dependencies:
```yaml
cache: 'maven'  # Speeds up builds by 2-3x
```

---

## 📞 Need Help?

### Common Questions:

**Q: How long does CI take?**  
A: Usually 8-12 minutes total

**Q: Can I skip security scan?**  
A: Not recommended, but you can set `exit-code: '0'` in Trivy step

**Q: Can I run CI locally?**  
A: Yes! Use [act](https://github.com/nektos/act) to run GitHub Actions locally

**Q: What if I want to deploy manually?**  
A: Pull the image from GHCR and deploy however you want!

---

## ✅ Checklist

Before moving to CD, make sure:
- [ ] CI pipeline runs successfully
- [ ] Tests are passing
- [ ] Security scan passes (or issues are addressed)
- [ ] Docker image is published to GHCR
- [ ] You can pull the image locally
- [ ] Team understands the new workflow

---

## 🎉 You're All Set!

Your CI pipeline is now:
- ✅ **Automated** - Runs on every push
- ✅ **Secure** - Scans for vulnerabilities
- ✅ **Fast** - Completes in ~10 minutes
- ✅ **Reliable** - Consistent builds every time

**Ready for CD?** Let me know when you want to set up the deployment pipeline! 🚀
