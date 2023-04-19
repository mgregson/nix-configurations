{ config, pkgs, ...}:

let
  darwinAliases = {
    "darwin-rebuild" = "darwin-rebuild --flake ~/.nixpkgs";
  };
in {

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
    ];
  };

  system = {
    stateVersion = 4;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  programs = {
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    zsh = {
      enable = true;
      enableBashCompletion = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      interactiveShellInit = ''
        eval "$(direnv hook zsh)"
      '';
      promptInit = "autoload -U promptinit && promptinit && prompt walters && setopt prompt_sp";
    };
  };

  environment = {
    pathsToLink = [
      "/share/nix-direnv"
    ];

    shellAliases = {
    } // (if pkgs.stdenv.isDarwin then darwinAliases else {});

    systemPackages = (with pkgs; [
      git
      direnv
      nix-direnv
      gnupg
      emacs
    ]);
  };

  services = {
    nix-daemon = {
      enable = true;
    };
  };
}
