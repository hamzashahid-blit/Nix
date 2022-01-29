{ config, pkgs, ... }: (

let
	#pipe-viewer = import ./pipe-viewer/default.nix;
	ql2nix = import ./ql2nix/default.nix;
	comma = import ./comma-nix;
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "hamza";
  home.homeDirectory = "/home/hamza";

  #nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
	"font-bh-lucidatypewriter"
  ];

  # Very nice Direnv Integration
  services.lorri.enable = true;

  # services.xserver.xautolock.enable = true;

  home.packages = with pkgs; [

	# Important Hidden Programs
	pkg-config
	openssl

	# Emacs
	mononoki   # Nice monospace font
	libvterm   # Best terminal emulation in emacs

	((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [
		epkgs.vterm # Emacs Package for libvterm
	]))

	ispell      # Spelling for flyspell
	html-tidy   # Check for html errors and tidiness (flycheck)
    #ccl        # Lisp Compiler, best for GUIs
    #sbcl       # Lisp Compiler, best for Performance
    #lispPackages.cl_plus_ssl
    #lispPackages.stumpwm
	direnv      # Change Environment Vars according to Directory. *best-thing-ever*


	# Needed for XMonad config; All Basic things
	picom                    # Compositor
	termite                  # Slow but quick setup Terminal Emulator
	haskellPackages.xmobar   # Simple ASCII bar for XMonad
	rofi                     # Very Configurable Run Launcher
	dmenu                    # Very Lightweight run launcher
	hsetroot                 # Wallpaper setter. Less resource intensive than even FEH
    #xkill				     # Kill X Process with Mouse
	xscreensaver             # Screen saver
	xcape                    # Change Capslock to Escape and Control
	scrot                    # Screen Shott-er
	lxappearance             # Change Appereance of WMs

	# Other Programs
	mpv          # Best and Fastest Media Player
	youtube-dl   # Youtube with MPV
	pcmanfm      # Lightweight File Manager
	zathura      # Suckless PDF Reader
	sxiv         # Suckless X Image Viewer
	nyxt         # Most Configurable Browser ever. Made in Common Lisp

    # Other small programs
	neofetch		# Show system Info
	ripgrep			# Kind of important, Don't remove. Search for text through files
	htop			# Resource Monitor
	xorg.xsetroot
	xorg.xkill
	xterm
	xclip			# Clipboard access through terminal
	unclutter		# Hide cursor when typing or for inactivity
	unzip
	zip
	keychain		# Auto-start SSH-Agent and allow password-less SSHs


	# Other big programs
	libreoffice   # Best Office Suite alternative to MS Office
	gimp          # GNU Image Manipulation Program
	#docker                          # Run Containers
	#wineWowPackages.stable          # WINE = Wine Is Not an Emulator; Run Windows programs
	#texlive.combined.scheme-basic   # LaTeX (almost) all in one package

	# Programming; Commented out for Direnv
	#ghc      # Glasgow Haskell Compiler
	#gnuapl   # GNU APL Compiler
	#j        # J Array Programming Language
	#opam     # OCaml Package Manager, Makes life easier

	# Programming Extras
	freefont_ttf # Font dependeny for some applications
	#graphviz    # Make graphs with programming and a terminal

	# Extra Programs
	## What is going on with pipe-viewer? I have a result file in this directory... just use that for now
	#pipe-viewer       # custom version of below package
	#gtk-pipe-viewer   # Watch youtube anonymously with youtube or (fallback) invidious
	gomuks          # Matrix cli client
	nmap            # Networking OPSEC(?) Tool
	libqalculate    # Perform complex calculations of All subjects including Algebra
	qalculate-gtk   # GTK version of above libqalculate
	keepassxc		# Best Password Manager
	#gnome.geary    # Gnome Email client # Doesn't work! every email client complains about some .service thing
	qbittorrent     # QT Torrent Application
	rtorrent        # Terminal based Torrent Application
	tty-clock       # TTY Clock
	peaclock        # Terminal Clock, Timer, Stopwatch w/ colors and settings

	# Games
	nethack		   # Complicated FOSS Terminal Rougelike game made in 1987
	superTuxKart   # FOSS Mario Kart Look-alike. Not a clone! ;)

	# Remote Desktop
	tigervnc
	x2goclient
	x2goserver
	xorg.xauth
	xorg.xinit

  ] ++ [
   	# External Applications
   	#ql2nix
	#comma
  ];


  programs = {
    git = {
      enable = true;
      userName = "hamzashahid.blit";
      userEmail = "hamzashahid@tutanota.com";
    };

    # ssh = {
    #   startAgent = true;
    # };

    # emacs = {
    #   enable = true;
    # };

    bat.enable = true;
  };

  #home.file.".emacs.d".source = ./.emacs.d;
  #home.file.".xmonad".source = ./.xmonad;

  home.stateVersion = "21.05";
})

#home-manager-path
