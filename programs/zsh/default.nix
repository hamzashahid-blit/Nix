{config, pkgs, lib, ...}:
{
  home.packages = [ pkgs.zsh-powerlevel10k ];

  programs.zsh = {
	enable = true;

	plugins = [
	  {
	    name = "zsh-powerlevel10k";
	    src = pkgs.zsh-powerlevel10k;
	    file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
	  }
	  {
	    name = "powerlevel10k-config";
	    src = pkgs.lib.cleanSource ./p10k-config;
	    file = "p10k.zsh";
	  }
    ];

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
	# completionInit = "autoload -U compinit && compinit"

    defaultKeymap = "viins";
    initExtra = "
    # Enable colors and change prompt:
    # autoload -U colors && colors
    # PS1=\"%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b\"

    # Basic auto/tab complete:
    # autoload -U compinit
    zstyle ':completion:*' menu select
    zmodload zsh/complist
    # compinit
    _comp_options+=(globdots)		# Include hidden files.

    # vi mode
    bindkey -v
    export KEYTIMEOUT=1
	# Make Emacs the default editor for programs like git
	export VISUAL=e

    # Use vim keys in tab complete menu:
    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'l' vi-forward-char
    bindkey -M menuselect 'j' vi-down-line-or-history
    bindkey -v '^?' backward-delete-char

    bindkey '^ ' autosuggest-accept

    # If can't find from history, find from auto-tab
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    # ZSH_AUTOSUGGEST_STRATEGY=completion

    # Keychain
    function github_pass {
      eval `keychain --eval --agents ssh id_github`
    }

	function gitlab_pass {
	  eval `keychain --eval --agents ssh id_gitlab`
	}

    ### FZF ### START

    #if [ -n \"\${commands[fzf-share]}\" ]; then
    #	source '$(fzf-share)/key-bindings.zsh'
    #	source '$(fzf-share)/completion.zsh'
    #fi

    # Use fd (https://github.com/sharkdp/fd) instead of the default find
    # command for listing path candidates.
    # - The first argument to the function ($1) is the base path to start traversal
    # - See the source code (completion.{bash,zsh}) for the details.
    _fzf_compgen_path() {
      fd --hidden --follow --exclude \".git\" . \"$1\"
    }
    
    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude \".git\" . \"$1\"
    }
    
    # (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
    # - The first argument to the function is the name of the command.
    # - You should make sure to pass the rest of the arguments to fzf.
    _fzf_comprun() {
      local command=$1
      shift
      
      case \"$command\" in
      	  cd)           fzf \"$@\" --preview 'tree -C {} | head -200' ;;
      	  export|unset) fzf \"$@\" --preview \"eval 'echo \$'{}\" ;;
      	  ssh)          fzf \"$@\" --preview 'dig {}' ;;
      	  *)            fzf \"$@\" ;;
      esac
    }

    ### FZF ### END

    # Edit line in vim with ctrl-e:
    autoload edit-command-line; zle -N edit-command-line
    bindkey '^e' edit-command-line

    ### Custom Functions
    e_client () {
    	emacsclient -c -a \"\" $1 &
    }

	### VTERM ### START
	# Directory tracking etc. NOTE: I had to put extra backslashes for it work
	vterm_printf(){
		if [ -n \"$TMUX\" ] && ([ \"\${TERM%%-*}\" = \"tmux\" ] || [ \"\${TERM%%-*}\" = \"screen\" ] ); then
			# Tell tmux to pass the escape sequences through
			printf \"\\ePtmux;\\e\\e]%s\\007\\e\\\\\" \"$1\"
		elif [ \"\${TERM%%-*}\" = \"screen\" ]; then
			# GNU screen (screen, screen-256color, screen-256color-bce)
			printf \"\\eP\\e]%s\\007\\e\\\\\" \"$1\"
		else
			printf \"\\e]%s\\e\\\\\" \"$1\"
		fi
	}

	# Clear Scrollback
	if [[ \"$INSIDE_EMACS\" = 'vterm' ]]; then
		alias clear='vterm_printf \"51;Evterm-clear-scrollback\";tput clear'
	fi

	# Prompt Tracking & Dir Tracking
	vterm_prompt_end() {
		vterm_printf \"51;A$(whoami)@$(hostname):$(pwd)\";
	}
	setopt PROMPT_SUBST
	PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
	
	# Evaluate commands like: (message 'Hello World!')
	vterm_cmd() {
		local vterm_elisp
		vterm_elisp=\"\"
		while [ $# -gt 0 ]; do
			vterm_elisp=\"$vterm_elisp\"\"$(printf '\"%s\" ' \"$(printf \"%s\" \"$1\" | sed -e 's|\\\\|\\\\\\\\|g' -e 's|\"|\\\"|g')\")\"
			shift
		done
		vterm_printf \"51;E$vterm_elisp\"
	}

	find_file() {
		vterm_cmd find-file \"$(realpath \"\${@:-.}\")\"
	}

	say() {
		vterm_cmd message \"%s\" \"$*\"
	}

	vterm_set_directory() {
		vterm_cmd update-pwd \"$PWD/\"
	}

	autoload -U add-zsh-hook
	add-zsh-hook -Uz chpwd (){ vterm_set_directory }

	# Always find the VTerm Library
	if [[ \"$INSIDE_EMACS\" = 'vterm' ]] \\
		&& [[ -n \${EMACS_VTERM_PATH} ]] \\
		&& [[ -f \${EMACS_VTERM_PATH}/etc/emacs-vterm-bash.sh ]]; then
		source \${EMACS_VTERM_PATH}/etc/emacs-vterm-bash.sh
	fi
	### VTERM ### END

	# For Lorri w/ Nix (Amazingggggg)
	eval \"$(direnv hook zsh)\"
    ";

    shellAliases = {
    	cl = "clear";
        ls   = "exa";
    	ll = "ls -l";
    	la = "ls -la";
    	update = "home-manager switch";
    	sys-update = "sudo nixos-rebuild switch";
    	e = "e_client";
		ff = "find_file";
    	gpass = "github_pass";
    	glpass = "gitlab_pass";
		y = "mpv --ytdl-raw-options=format-sort='res:1080'";
		y7 = "mpv --ytdl-raw-options=format-sort='res:720'";
		y4 = "mpv --ytdl-raw-options=format-sort='res:480'";
    };

    history = {
    	size = 10000;
    	path = "${config.xdg.dataHome}/zsh/history";
    };
  };

}
