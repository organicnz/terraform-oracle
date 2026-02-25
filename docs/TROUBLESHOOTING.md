# Troubleshooting Guide

## Common Issues and Solutions

### 1. Authentication Errors

#### Error: "Invalid credentials"
```
Error: Error calling POST https://api.ovh.com/1.0/auth/credential
```

**Solution:**
- Verify your API credentials in `terraform.tfvars`
- Check that credentials are for the correct endpoint (ovh-us)
- Regenerate credentials at https://us.ovhcloud.com/auth/api/createToken
- Ensure credentials have required permissions

#### Error: "Consumer key expired"
```
Error: This credential is not valid
```

**Solution:**
```bash
# Regenerate consumer key
# Visit: https://us.ovhcloud.com/auth/api/createToken
# Update terraform.tfvars with new consumer_key
```

### 2. SSH Key Issues

#### Error: "Invalid SSH key format"
```
Error: Invalid public key format
```

**Solution:**
```bash
# Verify SSH key format
ssh-keygen -l -f ~/.ssh/id_rsa.pub

# Ensure key starts with ssh-rsa, ssh-ed25519, etc.
# Remove any extra whitespace or newlines

# Correct format:
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... user@host
```

#### Error: "No SSH key configured"
```
ERROR: No SSH key configured
```

**Solution:**
```hcl
# In terraform.tfvars, add either:

# Option 1: Upload new key
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E... user@host"

# Option 2: Use existing key
ssh_key_ids = ["existing-key-id"]
```

### 3. Instance Creation Failures

#### Error: "Flavor not available"
```
Error: Flavor d2-8 not available in region WAW1
```

**Solution:**
```bash
# Check available flavors
curl -X GET "https://api.ovh.com/1.0/cloud/project/{projectId}/flavor?region=WAW1"

# Update flavor_name in terraform.tfvars
flavor_name = "available-flavor-name"
```

#### Error: "Quota exceeded"
```
Error: Quota exceeded for instances
```

**Solution:**
- Check your OVHcloud quota limits
- Contact OVHcloud support to increase quota
- Delete unused instances

#### Error: "Timeout waiting for instance"
```
Error: timeout while waiting for state to become 'ACTIVE'
```

**Solution:**
```bash
# Increase timeout in vps.tf
timeouts {
  create = "45m"  # Increase from 30m
}

# Or check OVHcloud status page for outages
```

### 4. State File Issues

#### Error: "State lock timeout"
```
Error: Error acquiring the state lock
```

**Solution:**
```bash
# Force unlock (use with caution)
terraform force-unlock <lock-id>

# Or wait for lock to expire
# Check if another terraform process is running
```

#### Error: "State file corrupted"
```
Error: Failed to load state
```

**Solution:**
```bash
# Restore from backup
cp terraform.tfstate.backup terraform.tfstate

# Or pull from remote backend
terraform state pull > terraform.tfstate
```

### 5. Network Issues

#### Error: "Cannot connect to VPS"
```
ssh: connect to host X.X.X.X port 22: Connection refused
```

**Solution:**
```bash
# Wait for instance to fully boot (60 seconds)
sleep 60

# Check instance status
terraform output vps_status

# Verify IP address
terraform output vps_ip

# Check if IP is in allowed_ssh_ips
# Update terraform.tfvars if needed
```

#### Error: "Permission denied (publickey)"
```
Permission denied (publickey)
```

**Solution:**
```bash
# Verify SSH key is loaded
ssh-add -l

# Add key if needed
ssh-add ~/.ssh/id_rsa

# Use correct username
ssh ubuntu@<vps-ip>  # Not root

# Check key was added to instance
terraform output ssh_key_ids
```

### 6. Backup Issues

#### Error: "Backup creation failed"
```
Error: Error creating backup
```

**Solution:**
```bash
# Check if instance is running
terraform output vps_status

# Verify backup is enabled
terraform output backup_enabled

# Check cron expression is valid
# In terraform.tfvars:
backup_cron = "0 2 * * *"  # Valid cron format
```

### 7. Validation Errors

#### Error: "Invalid variable value"
```
Error: Invalid value for variable
```

**Solution:**
```bash
# Check variable constraints in variables.tf
# Common issues:

# Environment must be: production, staging, or development
environment = "production"

# VPS name must be lowercase with hyphens only
vps_name = "vps-warsaw-1"  # Not "VPS_Warsaw_1"

# Region must be valid
region = "WAW1"  # Check available regions

# IP addresses must be valid CIDR
allowed_ssh_ips = ["203.0.113.0/24"]  # Not "203.0.113.0"
```

### 8. Provider Issues

#### Error: "Provider version conflict"
```
Error: Failed to query available provider packages
```

**Solution:**
```bash
# Update provider versions
terraform init -upgrade

# Or lock to specific version in versions.tf
terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "= 0.50.0"  # Lock to specific version
    }
  }
}
```

### 9. Cost Issues

#### Error: "Payment method required"
```
Error: No valid payment method
```

**Solution:**
- Add payment method in OVHcloud console
- Verify payment method is active
- Check account balance

### 10. Terraform Command Failures

#### Error: "Command not found: terraform"
```
bash: terraform: command not found
```

**Solution:**
```bash
# Install Terraform
# macOS
brew install terraform

# Verify installation
terraform version
```

## Debugging Tips

### Enable Debug Logging
```bash
# Set debug level
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform-debug.log

# Run terraform command
terraform apply

# Review log
cat terraform-debug.log
```

### Validate Configuration
```bash
# Run all checks
make check

# Or individually
terraform fmt -check
terraform validate
tflint
tfsec .
```

### Check Resource State
```bash
# List all resources
terraform state list

# Show specific resource
terraform state show ovh_cloud_project_instance.vps

# Refresh state
terraform refresh
```

### Test API Connectivity
```bash
# Test OVHcloud API
curl -X GET "https://api.ovh.com/1.0/auth/time"

# Should return current timestamp
```

## Getting Help

### Before Asking for Help

1. Check this troubleshooting guide
2. Review error messages carefully
3. Check Terraform and provider versions
4. Verify configuration syntax
5. Run validation and security checks

### Information to Provide

When asking for help, include:
- Terraform version: `terraform version`
- Provider version: Check `.terraform.lock.hcl`
- Error message (full output)
- Relevant configuration (sanitized)
- Steps to reproduce
- What you've already tried

### Resources

- [OVHcloud Support](https://help.ovhcloud.com/)
- [Terraform Documentation](https://www.terraform.io/docs/)
- [OVH Provider Docs](https://registry.terraform.io/providers/ovh/ovh/latest/docs)
- [OVHcloud API Console](https://api.ovh.com/console/)

## Emergency Procedures

### Instance Not Responding
```bash
# 1. Check status
terraform output vps_status

# 2. Try to reboot via API
# (requires manual API call or OVHcloud console)

# 3. Restore from backup
# (see ARCHITECTURE.md for DR procedures)
```

### Accidental Deletion
```bash
# 1. Don't panic
# 2. Check if backup exists
# 3. Recreate infrastructure
terraform apply

# 4. Restore from backup
# (manual process via OVHcloud console)
```

### State File Lost
```bash
# 1. Check for backup
ls -la terraform.tfstate*

# 2. Restore from remote backend
terraform state pull > terraform.tfstate

# 3. Import existing resources
terraform import ovh_cloud_project_instance.vps <instance-id>
```
