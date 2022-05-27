{ config, pkgs, ... }: (

let
  #pipe-viewer = import ./pipe-viewer/default.nix;
  # ql2nix = import ./ql2nix/default.nix;
  comma = (import ./comma) {};
  
  tex = (pkgs.texlive.combine {
  	inherit (pkgs.texlive) scheme-basic
  	dvisvgm dvipng # for preview and export as html
  	wrapfig chemfig pgf
	xstring siunitx circuitikz amsmath 
    metafont # mf command line util for fonts (latex package ifsym)    
	ulem hyperref capt-of;

  	#(setq org-latex-compiler "lualatex")
  	#(setq org-preview-latex-default-process 'dvisvgm)
  });
in 
{
  imports = (import ./programs) ++ [];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "hamza";
  home.homeDirectory = "/home/hamza";

  xdg.enable = true;

  nixpkgs = {
	config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
	  "font-bh-lucidatypewriter"
	  "discord"
	  "zoom"
	];
	
    overlays = [
      (self: super: {
        # nixpkgs-unstable = import sources.nixpkgs-unstable { overlays = [ ]; };
        # nur = import sources.nur { pkgs = self; };

        youtube-dl = super.yt-dlp.override { withAlias = true; };
      })
    ];
  };

  # Enable NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  #nixpkgs.config.allowUnfree = true;

  services = {
    lorri.enable = true; # Very nice Direnv Integration
    kdeconnect.enable = true; # KDE Connect (Pair Computer with Phone)
	gromit-mpx.enable = true;
	dunst.enable = true;
    # xserver.xautolock.enable = true;

    emacs.defaultEditor = true;
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";

  # So we don't have to type: fonts.fonts = with pkgs; [...]
  # this will find installed packages and generate font-cache; 
  # https://github.com/nix-community/home-manager/issues/520
  # Scroll to bottom to find this fix
  fonts.fontconfig.enable = true;

  # Some applications are disabled because I created seperate modules for them
  # Others are just ones that I don't want anymore.
  home = {
    packages = with pkgs; [
	  # Fonts
	  mononoki   # Nice monospace font
      nerdfonts  # For Powerlevel10k (combines many icon sets)
	  siji
  
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
  
      (lispPackages.cffi.overrideAttrs (old: {
	    patches = [ (fetchpatch {
	      url = "https://github.com/cffi/cffi/commit/93da14314a33c907721f5279137cae0995364d43.patch";
	      sha256 = "sha256-hTbk+qFegnLMU0+7YB5MCDu+HQ5jvHLl7AofN39LKkA=";
        }) ];
	  }))
  
	  # For XMonad config; All Basic things
	  picom                    # Compositor
	  termite                  # Slow but quick setup Terminal Emulator
	  alacritty				   # The Fastest Terminal; GPU Accelerated 
	  haskellPackages.xmobar   # Simple ASCII bar for XMonad
	  polybar				   # A fast and easy-to-use tool for creating status bars.	
	  #rofi                     # Very Configurable Run Launcher
	  dmenu                    # Very Lightweight run launcher
	  hsetroot                 # Wallpaper setter. Less resource intensive than even FEH
	  xscreensaver             # Screen saver
	  xcape                    # Change Capslock to Escape and Control
	  scrot                    # Screen Shott-er
	  lxappearance             # Change Appereance of WMs
  
	  # Other Programs
	  mpv          # Best and Fastest Media Player
	  youtube-dl   # Youtube with MPV
	  # yt-dlp	   # Better the youtube-dl
	  imagemagick  # Do anything with images (Look at G'MIC too)
	  ffmpeg       # Very fast video & audio converter
	  xvidcap	   # ???
	  pcmanfm      # Lightweight File Manager
	  zathura      # Suckless PDF Reader
	  sxiv         # Suckless X Image Viewer
	  lf		   # Terminal filemanager heavily inspired from ranger in Go
	  kate		   # KDE Text Editor (very nice)
	  qutebrowser  # A Very nice Privacy Respecting Fast Browser
	  bleachbit	   # A FOSS disk-space cleaner, privacy manager, and computer system optimizer
	  czkawka	   # A Simple, fast and free app to remove unnecessary files from your computer. (Rust)
	  pavucontrol  # Control Pulseaudio, Input/Output and other settings.
	  discord	   # Element is better.
	  zoom-us	   # Eh... Corona ;(
  
	  # NOT WORKING WITH ERROR: "Warning: Javascript error: Invalid Number of Arguments 2" 
	  #nyxt        # Most Configurable Browser ever. Made in Common Lisp
  
  
      # Other small programs
	  neofetch		# Show system Info
	  ripgrep		# Kind of important, Don't remove. Search for text through files
	  htop			# A simple TUI Resource Monitor
	  exa			# A better "ls"
	  libnotify	    # Send Notifications to a Notification Daemon like "dunst"
	  xorg.xsetroot
	  xorg.xkill
	  xorg.xprop
	  xterm
	  xclip			# Clipboard access through terminal
	  unclutter		# Hide cursor when typing or for inactivity
	  xdotool		# Send Fake Key/Mouse Input (doubles as an auto-clicker)
	  unzip
	  zip
	  wmctrl
	  keychain		# Auto-start SSH-Agent and allow password-less SSHs
  
	  # Other big programs
	  libreoffice   # Best Office Suite alternative to MS Office
	  gimp          # GNU Image Manipulation Program
	  inkscape		# FOSS GTK Vector Art Program
	  kolourpaint   # FOSS MS Paint, lightweight GIMP
	  #librewolf		# A Fork of Firefox focused on Privacy, Security, and Freedom
	  #docker                          # Run Containers
	  #wineWowPackages.stable          # WINE = Wine Is Not an Emulator; Run Windows programs 
  
	  # Programming; Commented out for Direnv
	  #ghc      # Glasgow Haskell Compiler
	  #gnuapl   # GNU APL Compiler
	  #j        # J Array Programming Language
	  #opam     # OCaml Package Manager, Makes life easier
	  #jdk8		# Un-commented cz of TLauncher/Minecraft
  
	  # Programming Extras
	  freefont_ttf    # Font dependeny for some applications
	  #graphviz       # Make graphs with programming and a terminal
	  man-pages       # Enable extra dev man-pages
	  man-pages-posix # `` Posix version
	  ghostscript	  # PostScript interpreter
  
	  # Extra Programs
	  ## What is going on with pipe-viewer? I have a result file in this directory... just use that for now
	  #pipe-viewer       # custom version of below package
	  gtk-pipe-viewer   # Watch youtube anonymously with youtube or (fallback) invidious
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
   	  # ql2nix
	  # pkgs.comma
	  # jameel-noori-nastaleeq # Urdu Font # handled by auto-import at start of block
	  comma
      tex # LaTeX (almost) all in one package
    ];

	sessionVariables = {
      DISPLAY = ":0";
	  EDITOR = "emacsclient -c -a \"\"";
	};
  };


  programs = {
    bat.enable = true;

    git = {
      enable = true;
      userName = "hamzashahid-blit";
      userEmail = "hamzashahid.blit.git@protonmail.com";
    };

	fzf = {
	  enable = true;
	  enableZshIntegration = true;
	  # export FZF_DEFAULT_OPTS="--height 75% --reverse -m --border"
	  defaultOptions = [ "--height 40%" "--reverse" "-m" "--border" "--info=inline"];
	  historyWidgetOptions = [ "--sort" "--exact" ];
      fileWidgetOptions = [ "--preview 'head {file}'" ];
	};

	rofi = {
		enable = true;
		terminal = "${pkgs.alacritty}/bin/alacritty";
		theme = "gruvbox-dark-soft";
	};

    obs-studio = {
      enable = true;
      plugins = [];
    };
  };

  #home.file.".emacs.d".source = ./.emacs.d;
  #home.file.".xmonad".source = ./.xmonad;

  home.stateVersion = "22.05";
})
