# Architecture Documentation

## Overview

This Terraform stack deploys a production-ready VPS infrastructure on OVHcloud with comprehensive security, monitoring, and backup capabilities.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     OVHcloud Platform                        │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │              Cloud Project                          │    │
│  │                                                     │    │
│  │  ┌──────────────────────────────────────────┐     │    │
│  │  │         VPS Instance (d2-8)              │     │    │
│  │  │                                          │     │    │
│  │  │  • 4 vCores                             │     │    │
│  │  │  • 8 GB RAM                             │     │    │
│  │  │  • 75 GB SSD NVMe                       │     │    │
│  │  │  • Ubuntu 25.04                         │     │    │
│  │  │  • Public IPv4/IPv6                     │     │    │
│  │  │                                          │     │    │
│  │  │  Region: Warsaw (WAW1)                  │     │    │
│  │  └──────────────────────────────────────────┘     │    │
│  │                                                     │    │
│  │  ┌──────────────────────────────────────────┐     │    │
│  │  │         SSH Key Management               │     │    │
│  │  │  • Terraform-managed keys                │     │    │
│  │  │  • Existing key support                  │     │    │
│  │  └──────────────────────────────────────────┘     │    │
│  │                                                     │    │
│  │  ┌──────────────────────────────────────────┐     │    │
│  │  │         Automated Backups                │     │    │
│  │  │  • Scheduled snapshots                   │     │    │
│  │  │  • Configurable retention                │     │    │
│  │  └──────────────────────────────────────────┘     │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ Terraform API
                           │
                    ┌──────▼──────┐
                    │  Terraform  │
                    │   Control   │
                    │   Plane     │
                    └─────────────┘
```

## Components

### 1. Cloud Project
- Container for all OVHcloud resources
- Isolated billing and access control
- Environment-specific naming

### 2. VPS Instance
- **Flavor**: d2-8 (4 vCores, 8GB RAM, 75GB SSD)
- **Region**: Warsaw, Poland (WAW1)
- **OS**: Ubuntu 25.04
- **Network**: Public IPv4 and IPv6
- **Bandwidth**: 400 Mbps unlimited

### 3. SSH Key Management
- Automated key upload via Terraform
- Support for existing OVHcloud keys
- Validation and security checks

### 4. Backup System
- Automated daily backups
- Configurable schedule (cron)
- Environment-based retention
- Optional (cost: $0.50/month)

### 5. Monitoring
- Instance health checks
- Status monitoring
- Metadata export
- Auto-recovery configuration

## Data Flow

### Deployment Flow
```
1. User runs terraform apply
2. Terraform authenticates with OVHcloud API
3. Cloud project is created/verified
4. SSH keys are uploaded/validated
5. VPS instance is provisioned
6. Network configuration is applied
7. Backup schedule is configured (if enabled)
8. Monitoring is initialized
9. Outputs are displayed
```

### Backup Flow
```
1. Cron schedule triggers backup
2. OVHcloud creates snapshot
3. Snapshot is stored in object storage
4. Old snapshots are rotated per retention policy
5. Backup status is logged
```

## Security Architecture

### Network Security
- Public IP with optional IP allowlist
- SSH key-based authentication only
- Configurable firewall rules
- IPv6 support

### Access Control
- API key-based authentication
- Separate credentials per environment
- Least privilege principle
- Credential rotation support

### Data Security
- Encrypted state storage
- Sensitive variable protection
- Backup encryption
- Secure key management

## High Availability

### Instance Recovery
- Auto-recovery configuration
- Health check monitoring
- Automated restart on failure

### Backup Strategy
- Daily automated backups
- Point-in-time recovery
- Cross-region backup storage
- Tested restoration procedures

## Scalability

### Vertical Scaling
- Change `flavor_name` variable
- Terraform will recreate instance
- Backup and restore data

### Horizontal Scaling
- Deploy multiple instances
- Use load balancer (future)
- Shared storage (future)

## Cost Structure

| Component | Monthly Cost |
|-----------|-------------|
| VPS-1 (d2-8) | $4.90 |
| Automated Backup | $0.50 (optional) |
| **Total** | **$4.90 - $5.40** |

## Disaster Recovery

### Recovery Time Objective (RTO)
- Instance recreation: ~5-10 minutes
- Backup restoration: ~15-30 minutes
- Total RTO: ~30-40 minutes

### Recovery Point Objective (RPO)
- With daily backups: 24 hours
- With manual snapshots: Variable

### DR Procedures
1. Verify backup availability
2. Run `terraform apply` to recreate infrastructure
3. Restore from latest backup
4. Verify application functionality
5. Update DNS if needed

## Monitoring and Alerting

### Metrics Collected
- Instance status
- CPU utilization
- Memory usage
- Disk usage
- Network traffic

### Alert Conditions
- Instance down
- High resource usage
- Backup failures
- Security events

## Compliance

### Standards
- GDPR compliance
- Data residency (EU - Poland)
- Encryption at rest
- Access logging

### Audit Trail
- Terraform state changes
- API access logs
- Backup logs
- Security events

## Future Enhancements

### Planned Features
- Multi-region deployment
- Load balancer integration
- DNS management
- Kubernetes support
- Advanced monitoring (Prometheus/Grafana)
- Automated testing
- CI/CD integration

### Scalability Roadmap
1. Add load balancer support
2. Implement auto-scaling
3. Add database clustering
4. Implement CDN integration
5. Add disaster recovery automation
