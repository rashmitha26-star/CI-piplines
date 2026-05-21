# 🏗️ CI/CD Architecture

## Overview

This document explains the architecture of our separated CI/CD pipeline.

---

## 🎯 Current Architecture (CI Only)

```
┌─────────────────────────────────────────────────────────────────┐
│                         DEVELOPER                                │
│                                                                   │
│  ┌──────────┐      ┌──────────┐      ┌──────────┐              │
│  │  Write   │ ───▶ │  Commit  │ ───▶ │   Push   │              │
│  │   Code   │      │   Code   │      │ to GitHub│              │
│  └──────────┘      └──────────┘      └──────────┘              │
└────────────────────────────────┬──────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GITHUB ACTIONS (CI)                           │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  JOB 1: BUILD AND TEST                                     │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │  │
│  │  │ Checkout │→ │Setup Java│→ │Run Tests │→ │Build JAR │  │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │  │
│  │                                                  │          │  │
│  │                                                  ▼          │  │
│  │                                          ┌──────────────┐  │  │
│  │                                          │Upload Artifact│  │  │
│  │                                          └──────────────┘  │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                  │                                │
│                                  ▼                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  JOB 2: DOCKER BUILD & SCAN                                │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │  │
│  │  │Download  │→ │  Build   │→ │  Trivy   │→ │Push Image│  │  │
│  │  │   JAR    │  │  Docker  │  │   Scan   │  │ to GHCR  │  │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                  │                                │
│                                  ▼                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  JOB 3: CI SUMMARY                                         │  │
│  │  ┌──────────┐  ┌──────────┐                               │  │
│  │  │ Generate │→ │ Comment  │                               │  │
│  │  │ Summary  │  │  on PR   │                               │  │
│  │  └──────────┘  └──────────┘                               │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────┬──────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│              GITHUB CONTAINER REGISTRY (GHCR)                    │
│                                                                   │
│  📦 ghcr.io/username/ci-piplines:abc1234                         │
│  📦 ghcr.io/username/ci-piplines:main                            │
│  📦 ghcr.io/username/ci-piplines:20240521-143022                 │
│                                                                   │
│  ✅ Tested    ✅ Scanned    ✅ Ready to Deploy                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔮 Future Architecture (CI + CD)

```
┌─────────────────────────────────────────────────────────────────┐
│                         DEVELOPER                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                      │
│  │  Write   │→ │  Commit  │→ │   Push   │                      │
│  │   Code   │  │   Code   │  │ to GitHub│                      │
│  └──────────┘  └──────────┘  └──────────┘                      │
└────────────────────────────────┬──────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    CI PIPELINE (Current)                         │
│  Build → Test → Docker Build → Security Scan → Push to GHCR     │
└────────────────────────────────┬──────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│              GITHUB CONTAINER REGISTRY (GHCR)                    │
│  📦 Docker Image Ready                                           │
└────────────────────────────────┬──────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    CD PIPELINE (Future)                          │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  STAGE 1: DEPLOY TO DEV                                    │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                │  │
│  │  │  Update  │→ │  ArgoCD  │→ │  Verify  │                │  │
│  │  │  GitOps  │  │   Sync   │  │  Deploy  │                │  │
│  │  └──────────┘  └──────────┘  └──────────┘                │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                  │                                │
│                                  ▼                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  STAGE 2: DEPLOY TO STAGING (Manual Approval)             │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                │  │
│  │  │  Approve │→ │  Deploy  │→ │Run Smoke │                │  │
│  │  │  Deploy  │  │ to Green │  │  Tests   │                │  │
│  │  └──────────┘  └──────────┘  └──────────┘                │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                  │                                │
│                                  ▼                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  STAGE 3: DEPLOY TO PRODUCTION (Manual Approval)          │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │  │
│  │  │  Approve │→ │  Deploy  │→ │  Switch  │→ │ Monitor  │  │  │
│  │  │  Deploy  │  │ to Green │  │ Traffic  │  │  Health  │  │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────┬──────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GITOPS REPOSITORY                             │
│  (rashmitha26-star/argocd-CD-kubernetes)                         │
│                                                                   │
│  📁 helm/charts/values.yaml                                      │
│     - Blue environment config                                    │
│     - Green environment config                                   │
│     - Active slot indicator                                      │
└────────────────────────────────┬──────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                         ARGOCD                                   │
│  Watches GitOps repo → Syncs to Kubernetes                       │
└────────────────────────────────┬──────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    KUBERNETES CLUSTER                            │
│                                                                   │
│  ┌──────────────────┐          ┌──────────────────┐            │
│  │  BLUE ENVIRONMENT│          │ GREEN ENVIRONMENT│            │
│  │                  │          │                  │            │
│  │  🟦 v1.0.0       │          │  🟩 v1.1.0       │            │
│  │  (Active)        │          │  (Standby)       │            │
│  └──────────────────┘          └──────────────────┘            │
│           ▲                                                      │
│           │                                                      │
│  ┌────────┴────────┐                                            │
│  │  Load Balancer  │ ◀─── Traffic routing                       │
│  └─────────────────┘                                            │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Blue-Green Deployment Flow

```
INITIAL STATE:
┌─────────────┐     ┌─────────────┐
│    BLUE     │     │    GREEN    │
│   v1.0.0    │ ◀── │   (empty)   │
│  (Active)   │     │             │
└─────────────┘     └─────────────┘
      ▲
      │
  All Traffic


STEP 1: Deploy to Green
┌─────────────┐     ┌─────────────┐
│    BLUE     │     │    GREEN    │
│   v1.0.0    │     │   v1.1.0    │ ◀── Deploy new version
│  (Active)   │     │  (Testing)  │
└─────────────┘     └─────────────┘
      ▲
      │
  All Traffic


STEP 2: Test Green
┌─────────────┐     ┌─────────────┐
│    BLUE     │     │    GREEN    │
│   v1.0.0    │     │   v1.1.0    │
│  (Active)   │     │  (Testing)  │ ◀── Run smoke tests
└─────────────┘     └─────────────┘
      ▲
      │
  All Traffic


STEP 3: Switch Traffic
┌─────────────┐     ┌─────────────┐
│    BLUE     │     │    GREEN    │
│   v1.0.0    │     │   v1.1.0    │
│  (Standby)  │     │  (Active)   │
└─────────────┘     └─────────────┘
                          ▲
                          │
                      All Traffic


STEP 4: Next Deployment (to Blue)
┌─────────────┐     ┌─────────────┐
│    BLUE     │     │    GREEN    │
│   v1.2.0    │ ◀── │   v1.1.0    │
│  (Testing)  │     │  (Active)   │
└─────────────┘     └─────────────┘
                          ▲
                          │
                      All Traffic
```

---

## 📊 Data Flow

### CI Pipeline (Current)

```
Source Code
    │
    ├─▶ Maven Build
    │       │
    │       ├─▶ Compile
    │       ├─▶ Run Tests
    │       └─▶ Package JAR
    │
    └─▶ Docker Build
            │
            ├─▶ Copy JAR
            ├─▶ Build Image
            ├─▶ Trivy Scan
            └─▶ Push to GHCR
                    │
                    └─▶ Image Ready for Deployment
```

### CD Pipeline (Future)

```
Docker Image (from GHCR)
    │
    ├─▶ Update GitOps Repo
    │       │
    │       └─▶ Update values.yaml
    │               │
    │               └─▶ Set image tag
    │                   Set environment (blue/green)
    │
    └─▶ ArgoCD Detects Change
            │
            ├─▶ Pull Image from GHCR
            ├─▶ Apply Kubernetes Manifests
            └─▶ Deploy to Cluster
                    │
                    ├─▶ Create Pods
                    ├─▶ Create Services
                    └─▶ Update Load Balancer
```

---

## 🔐 Security Layers

```
┌─────────────────────────────────────────────────────────────┐
│  LAYER 1: CODE SECURITY                                      │
│  - Unit tests                                                │
│  - Code quality checks                                       │
│  - Dependency scanning                                       │
└────────────────────────────┬────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 2: IMAGE SECURITY                                     │
│  - Trivy vulnerability scan                                  │
│  - Base image verification                                   │
│  - SARIF reports to GitHub Security                          │
└────────────────────────────┬────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 3: REGISTRY SECURITY                                  │
│  - GHCR authentication                                       │
│  - Image signing (future)                                    │
│  - Access control                                            │
└────────────────────────────┬────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 4: DEPLOYMENT SECURITY (Future)                       │
│  - GitOps approval workflow                                  │
│  - Kubernetes RBAC                                           │
│  - Network policies                                          │
│  - Pod security policies                                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Separation Benefits

### Why Separate CI and CD?

```
MONOLITHIC PIPELINE:
┌─────────────────────────────────────────────────────────────┐
│  Build → Test → Docker → Scan → Deploy                      │
│                                                               │
│  ❌ All-or-nothing                                           │
│  ❌ Can't test without deploying                             │
│  ❌ Hard to debug                                            │
│  ❌ Slow feedback                                            │
└─────────────────────────────────────────────────────────────┘


SEPARATED PIPELINES:
┌─────────────────────────────────────────────────────────────┐
│  CI: Build → Test → Docker → Scan                           │
│  ✅ Fast feedback (10 min)                                   │
│  ✅ Independent testing                                      │
│  ✅ Easy to debug                                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  CD: Deploy → Verify → Switch Traffic                       │
│  ✅ Controlled deployment                                    │
│  ✅ Manual approval gates                                    │
│  ✅ Easy rollback                                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 📈 Scalability

### Current (CI Only)
- ✅ Handles multiple branches
- ✅ Parallel PR builds
- ✅ Artifact caching

### Future (CI + CD)
- ✅ Multiple environments (dev, staging, prod)
- ✅ Parallel deployments
- ✅ Canary deployments
- ✅ A/B testing support

---

## 🔧 Technology Stack

### CI Pipeline:
- **GitHub Actions** - Workflow orchestration
- **Maven** - Build tool
- **Docker Buildx** - Multi-platform builds
- **Trivy** - Security scanning
- **GHCR** - Container registry

### CD Pipeline (Future):
- **ArgoCD** - GitOps deployment
- **Kubernetes** - Container orchestration
- **Helm** - Package manager
- **Prometheus** - Monitoring (optional)
- **Grafana** - Dashboards (optional)

---

## 📝 Summary

**Current State:**
- ✅ Automated CI pipeline
- ✅ Docker images in GHCR
- ✅ Security scanning
- ✅ Fast feedback loop

**Next Phase:**
- 🔜 CD pipeline
- 🔜 GitOps workflow
- 🔜 Blue-green deployments
- 🔜 Production-ready automation
