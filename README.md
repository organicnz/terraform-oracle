# Oracle Cloud Remnawave - Terraform Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?logo=terraform)](https://www.terraform.io/)
[![OCI](https://img.shields.io/badge/Oracle_Cloud-Always_Free-F80000?logo=oracle)](https://www.oracle.com/cloud/free/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Production-ready, modular Terraform for deploying Remnawave VPN nodes on Oracle Cloud Always Free tier.

## ⚡ Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/organicnz/terraform-oracle.git
cd terraform-oracle

# 2. Setup local variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your OCI details

# 3. Deploy to production
make prod
```

## 📁 Structure

```
├── modules/
│   ├── network/          # VCN, NSG, routing
│   └── compute/          # Instances, cloud-init
├── environments/
│   ├── production/       # Production config
│   └── staging/          # Staging/Testing config
├── examples/             # variable templates for different envs
├── .github/workflows/    # GitHub Actions CI/CD
├── Makefile              # Automation shortcuts
└── deploy.sh             # Deployment script
```

## 🎯 Features

- ✅ **Modular** - Reusable components for easy scaling
- ✅ **Multi-Environment** - Isolated Production/Staging/Dev setups
- ✅ **Always Free** - Optimized for $0/month ARM instances (4 OCPUs, 24GB RAM)
- ✅ **Secure** - Built-in NSG rules, automated validation, and secret protection
- ✅ **Open Source Ready** - Fully configured for GitHub Actions CI/CD

## 🚢 CI/CD Setup (GitHub Secrets)

To enable automated deployment via GitHub Actions, add the following secrets to your repository (**Settings > Secrets and variables > Actions**):

| Secret Name | Description |
|-------------|-------------|
| `OCI_TENANCY_OCID` | Your OCI Tenancy OCID |
| `OCI_USER_OCID` | Your OCI User OCID |
| `OCI_FINGERPRINT` | API Key Fingerprint |
| `OCI_REGION` | Your primary OCI region (e.g., `eu-frankfurt-1`) |
| `OCI_CONFIG` | Full content of your `~/.oci/config` |
| `OCI_KEY` | Full content of your OCI private API key (`.pem`) |
| `SSH_PUBLIC_KEY` | Full content of the SSH public key for the instance |

## 🚀 Usage

### Make Commands

```bash
make help              # Show all commands
make init              # Initialize Terraform
make plan              # Plan changes (default: production)
make apply             # Apply changes (default: production)
make destroy           # Destroy resources
make ssh               # SSH into the deployed instance
make check-free-tier   # Check current ARM resource usage
```

### Environment-Specific

```bash
# Deploy staging instead of production
ENV=staging make plan
ENV=staging make apply

# Or use shortcuts
make prod
make staging
```

## 🌍 Regions & Latency

| Region | Location | Latency to Russia | Status |
|--------|----------|-------------------|--------|
| `eu-stockholm-1` | Sweden | ~30-50ms | Recommended |
| `eu-frankfurt-1` | Germany | ~50-70ms | Reliable |
| `eu-amsterdam-1` | Netherlands | ~60-80ms | Solid |

*Note: Ensure your account is **subscribed** to the region before deploying.*

## 💰 Always Free Tier Limits

- **OCPUs:** 4 total (ARM Ampere)
- **RAM:** 24 GB total
- **Storage:** 200 GB total
- **Egress:** 10 TB/month

## 🔒 Security & Privacy

- **Secret Protection:** `.tfvars`, `.env`, and `.oci` folders are automatically ignored by Git.
- **Infrastructure:** Uses Network Security Groups (NSG) instead of wide-open Security Lists.
- **Scanning:** Includes `tfsec` security scanning in the CI/CD pipeline.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Run `make validate` to check for errors
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

**Maintained by**: [Organic](https://github.com/organicnz)  
**Last Updated**: 2026-02-24
