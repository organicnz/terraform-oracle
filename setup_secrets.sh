#!/bin/bash
# Helper script to set up local .env and prepare GitHub Secrets

set -euo pipefail

ENV_FILE=".env"

echo "🔐 Oracle Cloud Secret Setup Helper"
echo "===================================="

if [ -f "$ENV_FILE" ]; then
    read -p "⚠️  .env already exists. Overwrite? (y/n): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

# Load current OCI config as defaults if it exists
DEFAULT_TENANCY=""
DEFAULT_USER=""
DEFAULT_FINGERPRINT=""
DEFAULT_REGION="eu-frankfurt-1"

if [ -f ~/.oci/config ]; then
    echo "✓ Detected existing OCI config, using as defaults..."
    DEFAULT_TENANCY=$(grep "tenancy=" ~/.oci/config | cut -d'=' -f2)
    DEFAULT_USER=$(grep "user=" ~/.oci/config | cut -d'=' -f2)
    DEFAULT_FINGERPRINT=$(grep "fingerprint=" ~/.oci/config | cut -d'=' -f2)
    DEFAULT_REGION=$(grep "region=" ~/.oci/config | cut -d'=' -f2)
fi

read -p "Tenancy OCID [$DEFAULT_TENANCY]: " TENANCY
TENANCY=${TENANCY:-$DEFAULT_TENANCY}

read -p "User OCID [$DEFAULT_USER]: " USER_OCID
USER_OCID=${USER_OCID:-$DEFAULT_USER}

read -p "Fingerprint [$DEFAULT_FINGERPRINT]: " FINGERPRINT
FINGERPRINT=${FINGERPRINT:-$DEFAULT_FINGERPRINT}

read -p "Region [$DEFAULT_REGION]: " REGION
REGION=${REGION:-$DEFAULT_REGION}

read -p "SSH Public Key Path [~/.ssh/id_ed25519.pub]: " SSH_PATH
SSH_PATH=${SSH_PATH:-~/.ssh/id_ed25519.pub}

cat << EOF > "$ENV_FILE"
# OCI Credentials
export TF_VAR_tenancy_ocid="$TENANCY"
export TF_VAR_user_ocid="$USER_OCID"
export TF_VAR_fingerprint="$FINGERPRINT"
export TF_VAR_region="$REGION"
export TF_VAR_ssh_public_key_path="$SSH_PATH"

# GitHub Secrets helper (run 'cat .env' to see what to paste in GitHub)
# OCI_TENANCY_OCID="$TENANCY"
# OCI_USER_OCID="$USER_OCID"
# OCI_FINGERPRINT="$FINGERPRINT"
# OCI_REGION="$REGION"
EOF

chmod 600 "$ENV_FILE"

echo ""
echo "✅ $ENV_FILE created successfully!"
echo "🚀 To load these for local development, run: source $ENV_FILE"

# GitHub CLI Sync Feature
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    echo ""
    read -p "🔄 GitHub CLI detected. Sync secrets to GitHub now? (y/n): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📤 Uploading secrets to GitHub..."
        gh secret set OCI_TENANCY_OCID --body "$TENANCY"
        gh secret set OCI_USER_OCID --body "$USER_OCID"
        gh secret set OCI_FINGERPRINT --body "$FINGERPRINT"
        gh secret set OCI_REGION --body "$REGION"
        gh secret set OCI_CONFIG < ~/.oci/config
        gh secret set OCI_KEY < ~/.oci/oci_api_key.pem
        gh secret set SSH_PUBLIC_KEY < "$SSH_PATH"
        echo "✨ All secrets synced to GitHub!"
    fi
else
    echo ""
    echo "📋 TO SETUP GITHUB SECRETS MANUALLY:"
    echo "---------------------------"
    echo "1. Go to your repo > Settings > Secrets > Actions"
    echo "2. Add the following secrets:"
    echo "   - OCI_TENANCY_OCID (from .env)"
    echo "   - OCI_USER_OCID (from .env)"
    echo "   - OCI_FINGERPRINT (from .env)"
    echo "   - OCI_REGION (from .env)"
    echo "   - OCI_CONFIG (Copy content of ~/.oci/config)"
    echo "   - OCI_KEY (Copy content of your OCI .pem key)"
    echo "   - SSH_PUBLIC_KEY (Copy content of $SSH_PATH)"
fi
