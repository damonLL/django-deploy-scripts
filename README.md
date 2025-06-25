# Django Application Deployment Scripts

Generic deployment scripts for Django applications on Ubuntu/Debian servers.

## Quick Start

### One-Line Installation

Deploy any Django application with a single command:

```bash
# Replace with your specific configuration
curl -fsSL https://raw.githubusercontent.com/damonLL/django-deploy-scripts/main/install.sh | \
  sudo DEPLOY_REPO_URL=https://github.com/yourusername/yourapp.git \
       DEPLOY_APP_NAME=yourapp \
       DEPLOY_PATH=/srv/yourapp \
       bash
```

### Bootstrap Script

For more control, download and run the bootstrap script:

```bash
# Download the bootstrap script
curl -fsSL https://raw.githubusercontent.com/damonLL/django-deploy-scripts/main/bootstrap.sh -o bootstrap.sh
chmod +x bootstrap.sh

# Run with your configuration
sudo DEPLOY_REPO_URL=https://github.com/yourusername/yourapp.git \
     DEPLOY_APP_NAME=yourapp \
     DEPLOY_PATH=/srv/yourapp \
     ./bootstrap.sh production
```

## Configuration

The deployment scripts are controlled by environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `DEPLOY_REPO_URL` | Git repository URL | `https://github.com/user/repo.git` |
| `DEPLOY_APP_NAME` | Application name | `webapp` |
| `DEPLOY_PATH` | Installation directory | `/srv/webapp` |
| `DEPLOY_BOOTSTRAP_URL` | Bootstrap script URL | Auto-detected |

## What It Does

1. **Installs Dependencies**: Git, curl, and other required packages
2. **Downloads Your App**: Clones your Django repository
3. **Runs Deployment**: Executes your app's deployment scripts
4. **Sets Up Services**: Configures systemd services, nginx, databases
5. **Starts Application**: Gets everything running and accessible

## Requirements

### Your Django Repository Must Have:

- `deploy/deploy.sh` - Main deployment script
- `deploy/config.sh` - Configuration settings
- Environment file examples (`.env.production.example`, etc.)
- Systemd service templates in `deploy/systemd/`
- Nginx configuration in `deploy/nginx/`

### Server Requirements:

- Ubuntu 20.04+ or Debian 11+
- Root access (sudo)
- Internet connectivity

## Supported Environments

- `production` - Full production deployment
- `staging` - Staging environment
- `testing` - Testing environment

## Example Deployment Flow

```bash
# 1. Minimal setup - just specify your repo
curl -fsSL https://raw.githubusercontent.com/damonLL/django-deploy-scripts/main/install.sh | \
  sudo DEPLOY_REPO_URL=https://github.com/mycompany/myapp.git bash

# 2. Custom configuration
sudo DEPLOY_REPO_URL=https://github.com/mycompany/myapp.git \
     DEPLOY_APP_NAME=myapp \
     DEPLOY_PATH=/opt/myapp \
     ./bootstrap.sh production

# 3. Your app will be available at the configured domain
```

## Security Notes

- These scripts are designed to be generic and reusable
- No sensitive information is hard-coded
- All configuration is passed via environment variables
- Scripts can be safely shared and reused

## Troubleshooting

1. **404 Error**: Make sure your repository is public or provide authentication
2. **Permission Denied**: Run with `sudo`
3. **Missing Environment File**: Create `.env.production` in your app directory
4. **Service Startup Issues**: Check logs with `journalctl -f -u your-app-name`

## Contributing

This is a generic deployment tool. To adapt it for your specific needs:

1. Fork this repository
2. Modify the scripts as needed
3. Update the configuration variables
4. Test with your Django application

## License

MIT License - feel free to use and modify for your projects. 