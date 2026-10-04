# Production AWS React Deployment with Terraform & GitHub Actions (OIDC)

A production-grade, highly secure, fully automated DevOps architecture for hosting a Single Page Application (React / Vite) on AWS using **Terraform (IaC)**, **CloudFront (CDN + OAC)**, **Private S3**, **Route 53 DNS (delegated from BigRock)**, **ACM (SSL/TLS)**, and **GitHub Actions CI/CD with AWS OIDC authentication**.

---

## 🏗️ Architecture Overview

```
                         +-----------------------------------+
                         |           User Browser            |
                         +-----------------+-----------------+
                                           |
                                           | HTTPS Request (example.com / www.example.com)
                                           v
                         +-----------------------------------+
                         |         BigRock Registrar         |
                         | (Delegates NS -> AWS Route 53)    |
                         +-----------------+-----------------+
                                           |
                                           v
                         +-----------------------------------+
                         |      AWS Route 53 Hosted Zone     |
                         |  (Apex & WWW Alias -> CloudFront) |
                         +-----------------+-----------------+
                                           |
                                           v
                         +-----------------------------------+
                         |     AWS CloudFront Distribution   |
                         |   - ACM SSL Certificate (us-east-1)|
                         |   - HTTPS Redirect (HTTP -> HTTPS)|
                         |   - SPA Error Handling (403/404)  |
                         |   - Caching Optimized             |
                         +-----------------+-----------------+
                                           |
                                           | Origin Access Control (SigV4)
                                           v
                         +-----------------------------------+
                         |       AWS S3 Private Bucket       |
                         |   - Public Access Blocked         |
                         |   - SSE-S3 AES-256 Encryption     |
                         |   - Bucket Policy for CloudFront  |
                         +-----------------------------------+
```

---

## 🚀 CI / CD Pipeline (GitHub Actions + AWS OIDC)

```
Developer Push to 'main'
         │
         ▼
GitHub Actions Runner
         │
         ├─► [1] npm ci & npm run build
         │
         ├─► [2] Request OIDC JWT Token from GitHub
         │
         ├─► [3] AWS STS: AssumeRoleWithWebIdentity (Temporary Credentials)
         │
         ├─► [4] aws s3 sync dist/ s3://<bucket-name> --delete
         │
         └─► [5] aws cloudfront create-invalidation --paths "/*"
```

---

## 📁 Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── frontend-deploy.yml    # CI/CD: Builds React, uploads to S3, invalidates CloudFront
│       └── terraform-infra.yml    # CI/CD: Terraform plan & apply on infrastructure changes
├── terraform/
│   ├── bootstrap/                 # State Backend setup (S3 State Bucket with Native S3 Locking)
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars.example
│   │   └── variables.tf
│   ├── environments/
│   │   └── prod/                  # Production Environment Composition
│   │       ├── backend.tf         # S3 backend with use_lockfile = true
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── providers.tf
│   │       ├── terraform.tfvars.example
│   │       └── variables.tf
│   └── modules/                   # Reusable Infrastructure Modules
│       ├── acm/                   # SSL Certificate + Route 53 DNS Validation
│       ├── cloudfront/            # CDN + OAC + SPA Routing + Caching
│       ├── oidc/                  # GitHub Actions IAM OIDC Role & Policy
│       ├── route53/               # Hosted Zone & CloudFront Alias Records
│       └── s3/                    # Private S3 Bucket + OAC Policy
├── .gitignore
└── README.md
```

---

## 🛠️ Step-by-Step Deployment Instructions

### Step 1: Bootstrap Terraform Remote State (One-Time Setup)
```bash
cd terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with a globally unique bucket name
terraform init
terraform plan
terraform apply
```
*Take note of the output backend configuration snippet.*

### Step 2: Configure Production Environment
```bash
cd ../environments/prod
cp terraform.tfvars.example terraform.tfvars
# Update backend.tf with your bootstrap S3 bucket name
# Edit terraform.tfvars with your actual BigRock domain and GitHub repository details
```

### Step 3: Deploy Core Infrastructure
```bash
terraform init
terraform plan
terraform apply
```

### Step 4: Update BigRock Nameservers
1. Log in to your [BigRock Control Panel](https://www.bigrock.in/).
2. Navigate to **Manage Orders** -> **List/Search Orders** -> Click your domain.
3. Click **Name Servers**.
4. Replace existing nameservers with the 4 nameservers output by `terraform apply` (e.g., `ns-xxx.awsdns-xx.com`, `ns-xxx.awsdns-xx.net`, etc.).
5. Save changes. *(DNS propagation typically takes 5–30 minutes).*

### Step 5: Configure GitHub Secrets & Variables
In your GitHub repository, go to **Settings** -> **Secrets and variables** -> **Actions** -> **Variables**:
- `AWS_ROLE_ARN`: Value from Terraform output `github_actions_role_arn`
- `AWS_REGION`: `ap-south-1` (or your chosen region)
- `S3_BUCKET_NAME`: Value from Terraform output `s3_bucket_name`
- `CLOUDFRONT_DISTRIBUTION_ID`: Value from Terraform output `cloudfront_distribution_id`

*(Note: No static AWS Access Keys or Secrets are required! OIDC handles authentication securely).*

### Step 6: Test Deployment
Push a commit to the `main` branch or manually trigger the **Deploy React Frontend to AWS S3 & CloudFront** workflow under GitHub Actions.

---

## 🧹 Teardown (Delete After Demo)

To avoid incurring any recurring costs after your demo:
```bash
# 1. Empty and destroy prod infrastructure
cd terraform/environments/prod
terraform destroy -auto-approve

# 2. Destroy bootstrap backend
cd ../../terraform/bootstrap
terraform destroy -auto-approve
```
