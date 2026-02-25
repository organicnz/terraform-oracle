# Quick Start Guide - Oracle Cloud Remnawave Node

## 🚀 Deploy in 5 Minutes

### Step 1: Verify Prerequisites

```bash
# Check Terraform
terraform version  # Should be >= 1.5

# Check OCI CLI
oci --version

# Verify OCI config
cat ~/.oci/config

# Check SSH key exists
ls -la ~/.ssh/id_rsa_gitlab.pub
```

### Step 2: Deploy

```bash
cd /Users/organic/dev/work/terraform/terraform-oracle

# Deploy to Stockholm (closest to Russia)
./deploy.sh production
```

### Step 3: Connect

```bash
# Get SSH command from output
ssh -i ~/.ssh/id_rsa_gitlab ubuntu@<IP_FROM_OUTPUT>
```

### Step 4: Install Remnawave

```bash
# On the instance
sudo bash <(curl -Ls https://raw.githubusercontent.com/organicnz/egames-remnawave-supabase/main/install_remnawave.sh)

# Choose: Option 3 - Add Node to Panel
```

## 📊 What Gets Created

- ✅ VCN (10.0.0.0/16)
- ✅ Public subnet (10.0.1.0/24)
- ✅ Internet gateway
- ✅ Network Security Group (ports 22, 80, 443, 2222)
- ✅ ARM instance (1 OCPU, 6 GB RAM, 50 GB storage)
- ✅ Ubuntu 24.04 ARM
- ✅ Public IP address

## 💰 Cost

**$0/month** - Within Oracle Always Free tier

## 🌍 Regions

- **Production**: Stockholm (eu-stockholm-1) - Closest to Russia
- **Staging**: Frankfurt (eu-frankfurt-1) - Existing region

## 🔧 Customize

Edit `environments/production/terraform.tfvars`:

```hcl
# Change instance size
instance_ocpus         = 2
instance_memory_in_gbs = 12

# Restrict SSH access
allowed_ssh_cidrs = ["YOUR_IP/32"]
```

Then redeploy:

```bash
./deploy.sh production
```

## 🗑️ Cleanup

```bash
./destroy.sh production
```

## 📝 Get Info

```bash
# All outputs
terraform output

# Specific info
terraform output instance_public_ip
terraform output ssh_command
```

## ❓ Troubleshooting

**"Out of capacity"**: Try different region or wait and retry

**"Authentication failed"**: Check `~/.oci/config` and API key

**"SSH refused"**: Wait 2-3 minutes after deployment

## 📚 Full Documentation

See [README.md](README.md) for complete documentation.
