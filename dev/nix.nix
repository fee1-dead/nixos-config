{ ... }:
{
  nix.settings = {
	  auto-optimise-store = true;
	  experimental-features = [ "nix-command" "flakes "];
  };
  nixpkgs.config.allowUnfree = true;
}