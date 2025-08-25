# Shell configuration - bash with useful defaults
{pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      
      # NixOS specific aliases
      nrs = "sudo nixos-rebuild switch --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
      nrc = "sudo nixos-rebuild switch --flake . --show-trace";
      nfu = "nix flake update";
      
      # Git aliases
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
    };
  };

  # Set bash as default shell
  users.defaultUserShell = pkgs.bash;
}