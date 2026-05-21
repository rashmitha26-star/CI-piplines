# CI/CD Pipeline Separation Guide

## Overview

This repository now has **separated CI and CD pipelines** for better control and flexibility.

---

## 📦 CI Pipeline (Continuous Integration)

**File:** `.github/workflows/ci-pipeline.yml`

### What It Does:
1. **Build & Test**
   - Checks out code
   - Sets up Java 17
   - Runs unit tests with Maven
   - Generates test coverage reports
   - Builds JAR artifact

2. **Docker Build & Security Scan**
   - Downloads JAR from previous job
   - Builds Docker image
   - Runs Trivy security scan
   - Fails if CRITICAL/HIGH vulnerabilities found
   - Pushes image to GitHub Container Registry (GHCR)

3. **CI Summary**
   - Generates summary report
   - Comments on Pull Requests
   - Shows build status and artifacts

4. **Failure Notifications**
   - Creates GitHub issue if pipeline fails

### Triggers:
- Push to `main` or `develop` branches
- Pull requests to `main`

### Outputs:
- ✅ Tested and built JAR artifact
- ✅ Docker image pushed to `ghcr.io`
- ✅ Security scan results
- ✅ Image tags and digest for deployment

---

## 🚀 CD Pipeline (Continuous Deployment)

**Status:** To be implemented later

### What It Will Do:
1. **Triggered by CI completion** (or manually)
2. **Update GitOps repository** with new image tags
3. **Deploy to environments** (dev, staging, production)
4. **Blue-Green deployment** strategy
5. **Rollback capabilities**

### Planned Structure:
```yaml
# .github/workflows/cd-pipeline.yml (to be created)
- Deploy to Dev
- Deploy to Staging (manual approval)
- Deploy to Production (manual approval)
- Blue-Green traffic switching
- Rollback on failure
```

---

## 🔄 Current Workflow

### For Developers:

1. **Push code to branch**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   git push origin feature-branch
   ```

2. **CI Pipeline runs automatically**
   - Builds and tests your code
   - Creates Docker image
   - Scans for vulnerabilities
   - Pushes to container registry

3. **Check CI results**
   - View in GitHub Actions tab
   - Check PR comments for status
   - Review security scan reports

4. **CD Pipeline (later)**
   - Will be triggered after CI passes
   - Deploy to environments
   - Manual approval for production

---

## 📋 What You Need to Configure

### 1. GitHub Container Registry (GHCR)
Already configured! Uses `GITHUB_TOKEN` automatically.

### 2. Repository Secrets (for CD later)
You'll need to add these when setting up CD:
- `GITOPS_PAT` - Personal Access Token for GitOps repo
- `KUBE_CONFIG` - Kubernetes config (if direct deployment)
- `ARGOCD_TOKEN` - ArgoCD token (if using ArgoCD)

---

## 🎯 Benefits of Separation

### CI Pipeline (Current):
✅ Fast feedback on code quality  
✅ Automated testing and security scanning  
✅ Consistent build process  
✅ Image ready for deployment  

### CD Pipeline (Coming):
✅ Controlled deployments  
✅ Environment-specific configurations  
✅ Manual approval gates  
✅ Rollback capabilities  
✅ Blue-green deployments  

---

## 📊 Image Tagging Strategy

The CI pipeline creates multiple tags for each image:

```
ghcr.io/your-org/your-repo:abc1234          # Short SHA
ghcr.io/your-org/your-repo:main             # Branch name
ghcr.io/your-org/your-repo:1.0.0            # Semantic version
ghcr.io/your-org/your-repo:20240521-143022  # Timestamp
```

This allows flexible deployment strategies in CD pipeline.

---

## 🔍 Monitoring CI Pipeline

### View Results:
1. Go to **Actions** tab in GitHub
2. Click on latest workflow run
3. Review each job:
   - Build and Test
   - Docker Build and Scan
   - CI Summary

### Artifacts Available:
- `application-jar` - Built JAR file (5 days retention)
- `trivy-security-report` - HTML security report

### Security Tab:
- View vulnerability alerts
- Check Trivy SARIF results

---

## 🚦 Next Steps

### Phase 1: CI ✅ (DONE)
- [x] Build and test automation
- [x] Docker image creation
- [x] Security scanning
- [x] Push to registry

### Phase 2: CD 🔜 (COMING NEXT)
- [ ] Create CD pipeline workflow
- [ ] Set up GitOps repository
- [ ] Configure ArgoCD
- [ ] Implement blue-green deployment
- [ ] Add manual approval gates
- [ ] Set up rollback mechanism

---

## 📝 Notes

- **CI runs on every push** - Fast feedback loop
- **CD will be triggered manually or after CI** - Controlled deployments
- **Security first** - Pipeline fails if vulnerabilities found
- **Artifacts retained for 5 days** - Balance between storage and debugging

---

## 🆘 Troubleshooting

### CI Pipeline Fails at Build Stage
- Check Java version compatibility
- Review Maven dependencies
- Check test failures

### CI Pipeline Fails at Security Scan
- Review Trivy report artifact
- Check for CRITICAL/HIGH vulnerabilities
- Update dependencies or base image

### Docker Push Fails
- Verify GITHUB_TOKEN permissions
- Check package write permissions
- Ensure GHCR is enabled

---

## 📚 References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Trivy Security Scanner](https://github.com/aquasecurity/trivy)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
