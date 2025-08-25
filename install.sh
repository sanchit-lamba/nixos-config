#!/usr/bin/env bash

# NixOS Configuration Installation Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Check if flake.nix exists
if [[ ! -f "flake.nix" ]]; then
    print_error "flake.nix not found. Please run this script from the configuration directory."
    exit 1
fi

print_status "Starting NixOS configuration deployment..."

# Update flake inputs
print_status "Updating flake inputs..."
nix flake update

# Check flake
print_status "Checking flake configuration..."
nix flake check

# Build configuration
print_status "Building NixOS configuration..."
sudo nixos-rebuild build --flake .#BlitzWing

# Ask for confirmation before switching
echo ""
print_warning "Ready to switch to new configuration."
read -p "Do you want to switch now? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Switching to new configuration..."
    sudo nixos-rebuild switch --flake .#BlitzWing
    print_success "Configuration switched successfully!"
    
    print_status "Current generation:"
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1
else
    print_status "Skipping switch. You can manually switch later with:"
    echo "  sudo nixos-rebuild switch --flake .#BlitzWing"
fi

print_success "Deployment complete!"