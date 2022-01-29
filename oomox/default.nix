let pkgs = import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation rec {
	pname = "oomox";
	version = "0.0.9";
	src = pkgs.fetchFromGitHub {
		owner = "trizen";
		repo = "pipe-viewer";
		rev = "f66db94b2209383d51042487eb486ea44d127277";
	 	sha256 = "sha256-9dBxGtFVmjjZ3F4sjm3ukneTcAeWer+MAhIEFL7NAPw=";
	};

	buildInputs = with pkgs.perl532Packages; [ LWP LWPProtocolHttps DataDump JSON Gtk3 Glib GlibObjectIntrospection FileShareDir ModuleBuild TermReadLineGnu JSONXS UnicodeLineBreak ] ++ ( with pkgs; [ makeWrapper gtk3-x11 gobjectIntrospection ] );

	propagatedBuildInputs = with pkgs; [ wget ffmpeg mpv youtube-dl ];

	preConfigure = "sed -i -e \"s@'bin/pipe-viewer'@'bin/pipe-viewer','bin/gtk-pipe-viewer'@\" Makefile.PL";

	buildPhase = ''
		${pkgs.perl}/bin/perl Build.PL --gtk --install_base=$out --install_path="lib=$out/${pkgs.perl.libPrefix}"
		./Build build
	'';

	postInstall = ''
		wrapProgram $out/bin/pipe-viewer --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.mpv pkgs.youtube-dl ] }"
		wrapProgram $out/bin/gtk-pipe-viewer --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.mpv pkgs.youtube-dl ] }" \
					--prefix GI_TYPELIB_PATH : "${pkgs.lib.makeSearchPath "lib/girepository-1.0" [
													pkgs.gtk3
													pkgs.pango.out
													pkgs.harfbuzz
													pkgs.gdk-pixbuf
													pkgs.atk
												]}"
    '';
}
