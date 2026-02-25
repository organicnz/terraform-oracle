#!/bin/bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ENVIRONMENT="${1:-production}"
TFVARS_FILE="environments/${ENVIRONMENT}/terraform.tfvars"

echo -e "${RED}🗑️  Destroying Remnawave Node - ${ENVIRONMENT}${NC}"
echo ""

if [ ! -f "$TFVARS_FILE" ]; then
    echo -e "${RED}❌ Environment '${ENVIRONMENT}' not found${NC}"
    exit 1
fi

# Confirm destruction
echo -e "${RED}⚠️  WARNING: This will destroy all resources in ${ENVIRONMENT}${NC}"
read -p "Type 'destroy' to confirm: " -r
echo ""

if [[ ! $REPLY == "destroy" ]]; then
    echo -e "${GREEN}✅ Destruction cancelled${NC}"
    exit 0
fi

# Destroy
echo -e "${YELLOW}🔨 Destroying resources...${NC}"
terraform destroy -var-file="$TFVARS_FILE" -auto-approve

echo -e "${GREEN}✨ Resources destroyed${NC}"
