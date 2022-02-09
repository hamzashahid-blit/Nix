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
    function git_pass {
      eval `keychain --eval --agents ssh id_github`
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
    ";

    shellAliases = {
    	cl = "clear";
    	ll = "ls -l";
    	la = "ls -la";
    	update = "home-manager switch";
    	e = "e_client";
    	gpass = "git_pass";
    };

    history = {
    	size = 10000;
    	path = "${config.xdg.dataHome}/zsh/history";
    };
  };

}
