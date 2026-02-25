#!/bin/bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT="${1:-production}"
TFVARS_FILE="environments/${ENVIRONMENT}/terraform.tfvars"

echo -e "${GREEN}🚀 Deploying Remnawave Node - ${ENVIRONMENT}${NC}"
echo ""

# Check if environment exists
if [ ! -f "$TFVARS_FILE" ]; then
    echo -e "${RED}❌ Environment '${ENVIRONMENT}' not found${NC}"
    echo "Available environments: production, staging"
    exit 1
fi

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"
command -v terraform >/dev/null 2>&1 || { echo -e "${RED}❌ Terraform not installed${NC}"; exit 1; }
command -v oci >/dev/null 2>&1 || { echo -e "${RED}❌ OCI CLI not installed${NC}"; exit 1; }

# Validate OCI credentials
if [ ! -f ~/.oci/config ]; then
    echo -e "${RED}❌ OCI config not found at ~/.oci/config${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites OK${NC}"
echo ""

# Initialize Terraform
echo -e "${YELLOW}📦 Initializing Terraform...${NC}"
terraform init -upgrade

# Validate configuration
echo -e "${YELLOW}✅ Validating configuration...${NC}"
terraform validate

# Format check
echo -e "${YELLOW}🎨 Checking formatting...${NC}"
terraform fmt -check || {
    echo -e "${YELLOW}⚠️  Formatting issues found, auto-fixing...${NC}"
    terraform fmt -recursive
}

# Plan deployment
echo -e "${YELLOW}📋 Planning deployment...${NC}"
terraform plan -var-file="$TFVARS_FILE" -out=tfplan

# Confirm deployment
echo ""
echo -e "${YELLOW}⚠️  Ready to deploy to ${ENVIRONMENT}${NC}"
read -p "Continue? (yes/no): " -r
echo ""

if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
    echo -e "${RED}❌ Deployment cancelled${NC}"
    rm -f tfplan
    exit 1
fi

# Apply
echo -e "${GREEN}🔨 Applying configuration...${NC}"
terraform apply tfplan

# Clean up plan file
rm -f tfplan

# Show outputs
echo ""
echo -e "${GREEN}✨ Deployment complete!${NC}"
echo ""
terraform output

# Save outputs to file
terraform output -json > "outputs-${ENVIRONMENT}.json"
echo -e "${GREEN}📄 Outputs saved to outputs-${ENVIRONMENT}.json${NC}"

# Show next steps
echo ""
echo -e "${GREEN}📝 Next steps:${NC}"
echo "1. SSH into instance:"
echo "   $(terraform output -raw ssh_command)"
echo ""
echo "2. Install Remnawave:"
echo "   $(terraform output -raw remnawave_install_command)"
echo ""
echo "3. Choose: Option 3 - Add Node to Panel"
echo ""
