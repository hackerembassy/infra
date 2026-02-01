{ config, pkgs, ...}:

{             
  security.sudo = {  
      enable = true;
      wheelNeedsPassword = false;  
  };

  users.users.dipierro = {  
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" ];  
      packages = with pkgs; [  
      ];
  };

  users.users.tv = {  
      shell = pkgs.zsh;
      isNormalUser = true;
      packages = with pkgs; [  
      ];
  };

}
