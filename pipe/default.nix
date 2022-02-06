# Q1. Is wrapProgram better or subtituteInPlace? If the latter, wouldn't it be hard to update the program
# Ans. Most Useful for different cases. for e.g. if I have to (un)comment a line, substitute would be
#	   better. Whereas if it's easier updating or you have that kin dof nix flake then the former
#	   would be better. It all depends on what fixes you problem the best and maintains easier.

# Q2. What is the wrapProgram --prefix option? (syntax)
# Ans. Look at the binary. It will just add all the programs as a path and then automatic referencing.
#	   for e.g. It looks at the program (mpv) and adds that to the path. Later in the program whenever
#	   the program calls mpv, nix just calls /nix/store/***-mpv-with-scripts-***/bin/mpv.

let pkgs = import <nixpkgs> {};
in
pkgs.buildPerlPackage rec {
	pname = "pipe-viewer";
	version = "0.0.9";
	src = pkgs.fetchFromGitHub {
		owner = "trizen";
		repo = "pipe-viewer";
		rev = "f66db94b2209383d51042487eb486ea44d127277";
	 	sha256 = "sha256-9dBxGtFVmjjZ3F4sjm3ukneTcAeWer+MAhIEFL7NAPw=";
	};

	buildInputs = with pkgs.perl532Packages; [ LWP LWPProtocolHttps DataDump JSON Gtk3 Glib GlibObjectIntrospection FileShareDir ModuleBuild TermReadLineGnu JSONXS UnicodeLineBreak ] ++ ( with pkgs; [ makeWrapper gtk3-x11 gobjectIntrospection ] );

	propagatedBuildInputs = with pkgs; [ wget ffmpeg mpv youtube-dl ];

	# Replace 'bin/pipe-viewer' with 'bin/gtk-pipe-viewer' in Makefile.PL for GTK support
	preConfigure = "sed -i -e \"s@'bin/pipe-viewer'@'bin/pipe-viewer','bin/gtk-pipe-viewer'@\" Makefile.PL";

	buildPhase = ''
		${pkgs.perl}/bin/perl Build.PL --gtk --install_base=$out --install_path="lib=$out/${pkgs.perl.libPrefix}"
		./Build build
	'';

	postInstall = ''
		# Act like /usr/bin contatins mpv and youtube-dl instead of in the Nix Store
		# And fix GI thing which is really annoying
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
