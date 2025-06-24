{ ... }:
{
  nix.settings = {
	  auto-optimise-store = true;
	  experimental-features = [ "repl-flake" "nix-command" "flakes "];
  };
  nixpkgs.config.allowUnfree = true;
}
