# Development tools
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Editors
    vscode
    neovim
    code-cursor
    
    # Version control (git is in common.nix)
    gh
    lazygit
    
    # Containers
    docker
    podman
    podman-compose
    
    # Development utilities
    kdiff3

    # Runtimes
    nodejs_24.out
    python3

    # Nix Specific
    alejandra
  ];
}
