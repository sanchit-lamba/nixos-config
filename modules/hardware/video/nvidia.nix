# NVIDIA GPU configuration
{pkgs, ...}: {
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      
      # Fine-grained power management. Turns off GPU when not in use.
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      open = false;

      # Enable the Nvidia settings menu,
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = pkgs.linuxKernel.packages.linux_latest.nvidia_x11;
    };
  };

  environment.systemPackages = with pkgs; [
    nvidia-system-monitor-qt
  ];
}