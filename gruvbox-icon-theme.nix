{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchgit ? pkgs.fetchgit }:
stdenv.mkDerivation rec {
	name = "gruvbox-icon";
	src = fetchgit {
		url = "https://www.opencode.net/adhe/gruvboxplasma.git";
		rev = "990c7c0a212ba8f845cfd28d8259ebdb35fc7d0a";
		sha256 = "sha256-Vyb46IrLXU0wD3H+K4yCW0nPtunHRrzYIVS4zmTOyiE=";
	};
	dontBuild = true;
	installPhase = ''
		mkdir -p $out/share
		cp -r icons $out/share
	'';
}
