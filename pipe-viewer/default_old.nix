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

	buildInputs = with pkgs.perl532Packages; [ LWP LWPProtocolHttps DataDump JSON Gtk3 FileShareDir ModuleBuild TermReadLineGnu JSONXS UnicodeLineBreak ] ++ ( with pkgs; [ makeWrapper ] );

	propagatedBuildInputs = with pkgs; [ wget ffmpeg mpv youtube-dl ];

	buildPhase = ''
		${pkgs.perl}/bin/perl Build.PL --gtk
	'';

	# postPatch =  ''
	# 	substituteInPlace bin/pipe-viewer \
	# 		--replace "which_command('youtube-dl')" \
	# 				  "q{${pkgs.youtube-dl}/bin/youtube-dl}"

	# 	substituteInPlace bin/pipe-viewer \
	# 		--replace "which_command('ffmpeg')" \
	# 				  "q{${pkgs.ffmpeg}/bin/ffmpeg}"

	# 	substituteInPlace bin/pipe-viewer \
	# 		--replace "which_command('wget')" \
	# 				  "q{${pkgs.wget}/bin/wget}"

	# 	substituteInPlace bin/pipe-viewer \
	# 		--replace "=> q{mpv}" \
	# 				  "=> q{${pkgs.mpv}/bin/mpv}"

	# 	substituteInPlace bin/pipe-viewer \
	# 		--replace "=> q{ffmpeg}" \
	# 				  "=> q{${pkgs.ffmpeg}/bin/ffmpeg}"

	# 	substituteInPlace bin/pipe-viewer \
	# 		--replace "=> q{wget}" \
	# 				  "=> q{${pkgs.wget}/bin/wget}"
	# '';

	installPhase = ''
		./Build installdeps
		./Build install
	'';

	postInstall = ''
		wrapProgram $out/bin/pipe-viewer --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.mpv pkgs.youtube-dl ] }"
    '';

	# Q1. Is wrapProgram better or subtituteInPlace? If the latter, wouldn't it be hard to update the program
	# Q2. What is the wrapProgram --prefix option? (syntax)
}
