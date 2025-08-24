# Development tools
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Editors
    vscode
    neovim
    code-cursor
    
    # Version control
    git
    gh
    lazygit
    
    # Containers
    docker
    podman
    podman-compose
    
    # Development utilities
    kdiff3
  ];
}
