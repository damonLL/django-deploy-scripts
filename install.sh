#!/bin/bash

# One-Line Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/user/repo/main/deploy/install.sh | sudo bash

set -e

# Configuration (can be overridden via environment variables)
REPO_URL="${DEPLOY_REPO_URL:-https://github.com/user/repo.git}"
BOOTSTRAP_URL="${DEPLOY_BOOTSTRAP_URL:-https://raw.githubusercontent.com/user/repo/main/deploy/bootstrap.sh}"
TEMP_BOOTSTRAP="/tmp/app-install-$$"

echo "One-Line Installer"
echo "====================================="
echo ""
echo "Configuration:"
echo "  Repository: $REPO_URL"
echo "  Bootstrap URL: $BOOTSTRAP_URL"
echo ""
echo "Downloading and running bootstrap script..."

# Download the bootstrap script
curl -fsSL "$BOOTSTRAP_URL" > "$TEMP_BOOTSTRAP"
chmod +x "$TEMP_BOOTSTRAP"

# Run the bootstrap script
"$TEMP_BOOTSTRAP" production

# Clean up
rm -f "$TEMP_BOOTSTRAP"

echo ""
echo "Installation complete!"
echo "Visit https://your-domain.com to access your application" 