# AMD GPU configuration for this system
{pkgs, ...}: {
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
  };
  
  environment.systemPackages = with pkgs; [
    rocmPackages.amdsmi
  ];
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [    
      libvdpau-va-gl
      libva-vdpau-driver
    ];
    extraPackages32 = with pkgs; [
    ];
  };
}
