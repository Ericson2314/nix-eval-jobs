{ pkgs, lib, ... }: {
  # Used to find the project root
  projectRootFile = "flake.lock";

  programs.prettier.enable = true;
  programs.prettier.package = pkgs.writeShellScriptBin "prettier" ''
    export NODE_PATH=${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules
    exec ${lib.getExe pkgs.nodePackages.prettier} "$@"
  '';

  programs.clang-format.enable = true;

  settings.formatter = {
    nix = {
      command = "sh";
      options = [
        "-eucx"
        ''
          ${pkgs.lib.getExe pkgs.nixpkgs-fmt} "$@"
        ''
        "--"
      ];
      includes = [ "*.nix" ];
      excludes = [ ];
    };

    clang-format = { };

    prettier.includes = lib.mkForce [ "*.toml" ];

    python = {
      command = "sh";
      options = [
        "-eucx"
        ''
          ${pkgs.lib.getExe pkgs.python3.pkgs.black} "$@"
        ''
        "--" # this argument is ignored by bash
      ];
      includes = [ "*.py" ];
    };
  };
}
