# 🚀 CI Pipeline Setup Checklist

## ✅ What's Been Fixed

- [x] Dockerfile syntax error (missing `#`)
- [x] Dockerfile changed from Node.js to Java Spring Boot
- [x] Registry changed from GHCR to Docker Hub
- [x] Image tags fixed (using branch name instead of full SHA)
- [x] Docker login updated for Docker Hub

---

## 🔑 Required: Add Docker Hub Secrets

**You MUST do this before the pipeline will work!**

### Step 1: Create Docker Hub Access Token

1. Go to https://hub.docker.com/
2. Login with username: `rashmithakl`
3. Click your profile → **Account Settings**
4. Click **Security** → **New Access Token**
5. Name: `github-actions`
6. Permissions: **Read, Write, Delete**
7. Click **Generate**
8. **Copy the token** (you'll only see it once!)

### Step 2: Add Secrets to GitHub

1. Go to your GitHub repository: https://github.com/rashmitha26-star/CI-piplines
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

**Add these two secrets:**

**Secret 1:**
```
Name: DOCKERHUB_USERNAME
Value: rashmithakl
```

**Secret 2:**
```
Name: DOCKERHUB_TOKEN
Value: [paste your Docker Hub access token here]
```

---

## 📦 Where Your Images Will Be Pushed

```
docker.io/rashmithakl/ci-piplines:main
docker.io/rashmithakl/ci-piplines:20260521-143022
docker.io/rashmithakl/ci-piplines:72af927
```

**View them at:**
https://hub.docker.com/r/rashmithakl/ci-piplines

---

## 🚀 After Adding Secrets

```bash
# Commit and push
git add .
git commit -m "fix: configure Docker Hub registry"
git push origin main
```

The pipeline will:
1. ✅ Build and test Java application
2. ✅ Create Docker image
3. ✅ Scan for vulnerabilities
4. ✅ Push to Docker Hub (rashmithakl/ci-piplines)

---

## 🔍 Current Configuration

### Registry:
```yaml
REGISTRY: docker.io
IMAGE_NAME: rashmithakl/ci-piplines
```

### Authentication:
```yaml
username: ${{ secrets.DOCKERHUB_USERNAME }}  # rashmithakl
password: ${{ secrets.DOCKERHUB_TOKEN }}     # Your token
```

### Image Tags:
- `main` - Latest from main branch
- `20260521-143022` - Timestamp
- `72af927` - Short commit SHA

---

## ⚠️ Common Issues

### Issue: "Error: Username and password required"
**Solution:** Add DOCKERHUB_USERNAME and DOCKERHUB_TOKEN secrets

### Issue: "denied: requested access to the resource is denied"
**Solution:** 
- Make sure Docker Hub username is correct: `rashmithakl`
- Make sure the token has Write permissions
- Create the repository on Docker Hub first (or make it public)

### Issue: "repository does not exist"
**Solution:** 
- Go to https://hub.docker.com/
- Create a new repository named `ci-piplines`
- Make it public or private (your choice)

---

## 📊 Pipeline Flow

```
Push Code
    ↓
Build & Test (Maven)
    ↓
Build Docker Image
    ↓
Scan with Trivy
    ↓
Push to Docker Hub ✅
    ↓
docker.io/rashmithakl/ci-piplines:main
```

---

## 🎯 Next Steps

1. **Add Docker Hub secrets** (see above)
2. **Push code** to trigger pipeline
3. **Watch it run** in GitHub Actions
4. **Check Docker Hub** for your image

---

## 💡 Alternative: Use GitHub Container Registry (GHCR)

If you prefer to use GHCR instead of Docker Hub (no secrets needed):

```yaml
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}
```

And change login to:
```yaml
- name: 🔐 Log in to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

**Pros of GHCR:**
- ✅ No secrets needed (uses GITHUB_TOKEN)
- ✅ Integrated with GitHub
- ✅ Free unlimited storage for public repos

**Pros of Docker Hub:**
- ✅ More popular/visible
- ✅ Better for public images
- ✅ Familiar to most developers

---

## ✅ Checklist

- [ ] Docker Hub access token created
- [ ] DOCKERHUB_USERNAME secret added to GitHub
- [ ] DOCKERHUB_TOKEN secret added to GitHub
- [ ] Code committed and pushed
- [ ] Pipeline running successfully
- [ ] Image visible on Docker Hub

---

**Need help?** Check the GitHub Actions logs for detailed error messages.
