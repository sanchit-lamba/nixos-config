#!/usr/bin/env bash

# Home Manager Configuration Script

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_status "Deploying Home Manager configuration for user: san (update this in the script)"

# Check if flake.nix exists
if [[ ! -f "flake.nix" ]]; then
    echo "Error: flake.nix not found. Please run this script from the configuration directory."
    exit 1
fi

# Build home manager configuration
print_status "Building Home Manager configuration..."
nix build .#homeConfigurations.san.activationPackage

# Switch to new configuration
print_status "Switching to new Home Manager configuration..."
home-manager switch --flake .#san

print_success "Home Manager configuration deployed successfully!"