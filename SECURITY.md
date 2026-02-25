# Security Policy

## Security Best Practices

### 1. Credential Management

- **Never commit** `terraform.tfvars` or any file containing credentials
- Use environment variables for sensitive data:
  ```bash
  export TF_VAR_ovh_application_key="your_key"
  export TF_VAR_ovh_application_secret="your_secret"
  export TF_VAR_ovh_consumer_key="your_consumer_key"
  ```
- Rotate API credentials regularly
- Use separate credentials for different environments

### 2. State File Security

- Store state files remotely with encryption
- Enable state locking to prevent concurrent modifications
- Restrict access to state files (contains sensitive data)
- Never commit state files to version control

### 3. SSH Key Management

- Use strong SSH keys (RSA 4096-bit or Ed25519)
- Rotate SSH keys periodically
- Limit SSH access by IP address using `allowed_ssh_ips`
- Disable password authentication on VPS

### 4. Network Security

- Configure `allowed_ssh_ips` to restrict SSH access
- Use VPN or bastion host for production access
- Enable firewall rules on the VPS
- Monitor access logs regularly

### 5. Backup Security

- Enable automated backups for production
- Test backup restoration regularly
- Encrypt backup data
- Store backups in different regions

### 6. Monitoring and Auditing

- Enable monitoring for all environments
- Set up alerts for suspicious activity
- Review Terraform plan output before applying
- Maintain audit logs of infrastructure changes

## Security Scanning

Run security checks before deployment:

```bash
# Format and validate
make fmt
make validate

# Security scan
make security

# Lint check
make lint

# All checks
make check
```

## Reporting Security Issues

If you discover a security vulnerability:

1. **Do not** open a public issue
2. Contact the infrastructure team directly
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be addressed before disclosure

## Compliance

This infrastructure configuration follows:

- GDPR compliance requirements
- Industry security best practices
- OVHcloud security guidelines
- Terraform security recommendations

## Security Checklist

Before deploying to production:

- [ ] API credentials are stored securely
- [ ] Remote state backend is configured with encryption
- [ ] SSH keys are properly managed
- [ ] IP allowlist is configured for SSH access
- [ ] Backups are enabled and tested
- [ ] Monitoring and alerting are configured
- [ ] Security scanning has been performed
- [ ] All variables are validated
- [ ] Tags include compliance information
- [ ] Documentation is up to date

## Updates and Patches

- Review provider updates monthly
- Apply security patches promptly
- Test updates in staging before production
- Maintain changelog of security-related changes

## Additional Resources

- [OVHcloud Security](https://www.ovhcloud.com/en/security/)
- [Terraform Security Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
