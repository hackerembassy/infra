{ config, pkgs, ...}:

{             
  security.sudo = {  
      enable = true;
      wheelNeedsPassword = false;  
  };
  
  users.users.cab = {  
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" ];  
      packages = with pkgs; [  
      ];
  };

  users.users.keimoger = {  
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" ];  
      packages = with pkgs; [  
      ];
  };
}
