{
  description = "A simple Go package";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, flake-utils, devshell }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        /* pkgs = nixpkgs.legacyPackages.${system}; */
        pkgs = import nixpkgs { 
          inherit system; 
          overlays = [ devshell.overlay ];
        };

        my-matterbridge = pkgs.buildGoModule rec {
          pname = "matterbridge";
          version = "1.25.1";

          src = ./.;
          /* src = pkgs.fetchFromGitHub {
            owner = "ahmr88";
            repo = pname;
            rev = "master";
            sha256 = "sha256-mfNYYvd8GHTy98qqA+65ARuA8zP3v3gpAYtDigiPFa4=";
          }; */

          tags = [
            "nomsteams"
            "nozulip"
            "whatsappmulti"
          ];

          vendorSha256 = null;

          meta = with pkgs.lib; {
            description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
            homepage = "https://github.com/42wim/matterbridge";
            license = with licenses; [ asl20 ];
            maintainers = with maintainers; [ ryantm ];
            platforms = platforms.unix;
          };
        };
      in
      {
        packages.my-matterbridge = my-matterbridge;

        defaultPackage = my-matterbridge;

        devShell = pkgs.devshell.mkShell {
          packages = [
            my-matterbridge
          ];
        };
      });
}
