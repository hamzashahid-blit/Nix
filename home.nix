{ config, pkgs, ... }: (

# let
# 	#pipe-viewer = import ./pipe-viewer/default.nix;
# 	ql2nix = import ./ql2nix/default.nix;
# 	comma = import ./comma-nix;
# in 
{
  imports = [
    ./modules/zsh.nix
	./modules/btrbk.nix
  ];

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
  services.emacs.defaultEditor = true;

  # KDE Connect (Pair Computer with Phone)
  services.kdeconnect.enable = true;

  # services.xserver.xautolock.enable = true;

  # So we don't have to type: fonts.fonts = with pkgs; [...]
  # this will find installed packages and generate font-cache; 
  # https://github.com/nix-community/home-manager/issues/520
  # Scroll to bottom to find this fix
  fonts.fontconfig.enable = true;

  # Enable even more extra development man-pages
  lib.documentation.dev.enable = true;

  # Some applications are disabled because I created seperate modules for them
  # Others are just ones that I don't want anymore.
  home.packages = with pkgs; [
	# Fonts
	mononoki   # Nice monospace font
        nerdfonts  # For Powerlevel10k (combines many icon sets)

	# Important Hidden Programs
	pkg-config
	openssl

	# Emacs
	#mononoki   # Nice monospace font
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
	ffmpeg       # Very fast video & audio converter
	pcmanfm      # Lightweight File Manager
	zathura      # Suckless PDF Reader
	sxiv         # Suckless X Image Viewer
	lf			 # Terminal filemanager heavily inspired from ranger in Go
	nyxt         # Most Configurable Browser ever. Made in Common Lisp
	#btrbk	     # Snapshot BTRFS; More flexible than Timeshift or Snapper
	kate		 # KDE Text Editor (very nice)

    # Other small programs
	neofetch		# Show system Info
	ripgrep			# Kind of important, Don't remove. Search for text through files
	htop			# Resource Monitor
	xorg.xsetroot
	xorg.xkill
	xorg.xprop
	xterm
	xclip			# Clipboard access through terminal
	unclutter		# Hide cursor when typing or for inactivity
	unzip
	zip
	wmctrl
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
	freefont_ttf    # Font dependeny for some applications
	#graphviz       # Make graphs with programming and a terminal
	man-pages       # Enable extra dev man-pages
	man-pages-posix # `` Posix version

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

	# Small Aestheticizing Programs
	#zsh-powerlevel10k

	# Nix Stuff
	nix-index
  ] ++ [
   	# External Applications
   	#ql2nix
	#comma
  ];


  programs = {
    git = {
      enable = true;
      userName = "hamzashahid-blit";
      userEmail = "hamzashahid.blit.git@protonmail.com";
    };

    # ssh = {
    #   startAgent = true;
    # };

    # emacs = {
    #   enable = true;
    # };

    bat.enable = true;

	fzf = {
	  enable = true;
	  enableZshIntegration = true;
	  # export FZF_DEFAULT_OPTS="--height 75% --reverse -m --border"
	  defaultOptions = [ "--height 40%" "--border" "--info=inline"];
	  historyWidgetOptions = [ "--sort" "--exact" ];
      fileWidgetOptions = [ "--preview 'head {file}'" ];
	};

  };

  #home.file.".emacs.d".source = ./.emacs.d;
  #home.file.".xmonad".source = ./.xmonad;

  home.stateVersion = "22.05";
})

#home-manager-path
