#!/bin/bash

# Bootstrap Script

set -e

# Configuration (can be overridden via environment variables)
REPO_URL="${DEPLOY_REPO_URL:-https://github.com/user/repo.git}"
APP_NAME="${DEPLOY_APP_NAME:-webapp}"
INSTALL_PATH="${DEPLOY_PATH:-/srv/webapp}"
TEMP_CLONE_DIR="/tmp/app-bootstrap-$$"
TARGET_ENV="${1:-production}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Clean up on exit
cleanup() {
    if [[ -d "$TEMP_CLONE_DIR" ]]; then
        log "Cleaning up temporary files..."
        rm -rf "$TEMP_CLONE_DIR"
    fi
}
trap cleanup EXIT

# Install required dependencies
install_dependencies() {
    log "Installing required dependencies..."
    
    # Update package list
    apt-get update
    
    # Install essential packages
    apt-get install -y \
        git \
        curl \
        wget \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release
    
    success "Dependencies installed"
}

# Download the deployment scripts
download_deployment_scripts() {
    log "Downloading application deployment scripts..."
    
    # Clone the repository to temporary location
    git clone "$REPO_URL" "$TEMP_CLONE_DIR"
    
    success "Deployment scripts downloaded"
}

# Run the full deployment
run_deployment() {
    log "Running application deployment..."
    
    cd "$TEMP_CLONE_DIR"
    
    # Make the deploy script executable
    chmod +x deploy/deploy.sh
    
    # Set deployment configuration
    export SF_APP_NAME="$APP_NAME"
    export SF_APP_DIR="$INSTALL_PATH"
    
    # Run the deployment
    ./deploy/deploy.sh deploy "$TARGET_ENV"
    
    success "Deployment completed!"
}

# Show final status
show_final_status() {
    echo ""
    echo "=================================="
    echo "🎉 Application Bootstrap Complete!"
    echo "=================================="
    echo ""
    echo "Your application installation is ready!"
    echo ""
    echo "Next steps:"
    echo "1. Configure your environment file if needed:"
    echo "   sudo nano $INSTALL_PATH/.env.$TARGET_ENV"
    echo ""
    echo "2. Check service status:"
    echo "   sudo $INSTALL_PATH/deploy/deploy.sh status"
    echo ""
    echo "3. View logs:"
    echo "   sudo $INSTALL_PATH/deploy/deploy.sh logs all"
    echo ""
    echo "4. Your site should be available at:"
    echo "   https://your-domain.com"
    echo ""
    echo "=================================="
}

# Main execution
main() {
    echo "Application Bootstrap"
    echo "============================"
    echo ""
    echo "This script will:"
    echo "1. Install required dependencies"
    echo "2. Download application deployment scripts"
    echo "3. Run complete deployment to $TARGET_ENV environment"
    echo ""
    echo "Configuration:"
    echo "  Repository: $REPO_URL"
    echo "  Install Path: $INSTALL_PATH"
    echo "  App Name: $APP_NAME"
    echo ""
    
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Bootstrap cancelled"
        exit 0
    fi
    
    log "Starting application bootstrap for $TARGET_ENV environment..."
    
    check_root
    install_dependencies
    download_deployment_scripts
    run_deployment
    show_final_status
}

# Handle command line arguments
case "${1:-help}" in
    production|staging|testing)
        main
        ;;
    help|*)
        echo "Application Bootstrap Script"
        echo ""
        echo "Usage: $0 {production|staging|testing}"
        echo ""
        echo "This script downloads and runs a complete application deployment"
        echo "on a blank server. It handles all dependencies and setup automatically."
        echo ""
        echo "Environment Variables:"
        echo "  DEPLOY_REPO_URL  - Git repository URL (default: https://github.com/user/repo.git)"
        echo "  DEPLOY_APP_NAME  - Application name (default: webapp)"
        echo "  DEPLOY_PATH      - Installation path (default: /srv/webapp)"
        echo ""
        echo "Examples:"
        echo "  sudo $0 production"
        echo "  sudo DEPLOY_REPO_URL=https://github.com/myuser/myapp.git $0 production"
        echo "  sudo DEPLOY_APP_NAME=myapp DEPLOY_PATH=/opt/myapp $0 staging"
        echo ""
        echo "What this script does:"
        echo "1. Installs required system dependencies (git, curl, etc.)"
        echo "2. Downloads the application repository and deployment scripts"
        echo "3. Runs the complete deployment process"
        echo "4. Sets up all services, containers, and configurations"
        ;;
esac 