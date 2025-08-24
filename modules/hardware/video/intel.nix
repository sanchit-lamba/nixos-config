# Intel GPU configuration
{pkgs, ...}: {
  services.xserver.videoDrivers = ["modesetting"];
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.intel-media-driver
      driversi686Linux.vaapiIntel
    ];
  };

  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };
}