PATH=\
~/bin:/usr/local/bin:/opt/bin:/usr/bin:/bin:\
~/go/bin:/opt/go/bin:\
/usr/local/sbin:/usr/sbin:/sbin
export PATH

MANPATH=\
/usr/share/man:\
/usr/local/man:\
/usr/local/share/man:\
/usr/man:\
/usr/xpg4/man:\
/usr/ucb/man:\
/usr/X11R6/man:\
/usr/openwin/man:\
/usr/lang/man
export MANPATH

: ${LC_TYPE:=en_US.UTF-8}
export LC_TYPE

[ $- = ${-#*i} ] && return # We're non-interactive, so no need to go on.

[ ! -z "$CLH_SHELLRC_LOADED" ] && return # Already sourced this file, no need to do it again.

if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
elif [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
elif [[ "${OSTYPE#linux}" != "$OSTYPE" ]]; then
    echo 'Consider installing Homebrew: https://docs.brew.sh/Homebrew-on-Linux'
fi

if [[ -r "$HOME/.profile_local" ]]; then source "$HOME/.profile_local"; fi

if (($+commands[antibody])); then
    source <(antibody init)

    alias alias=true
    antibody bundle <<-EOBUNDLES
	frodenas/cf-zsh-autocomplete-plugin
	frodenas/bosh-zsh-autocomplete-plugin
	mafredri/zsh-async
	clhynfield/pure
	zsh-users/zsh-completions src
	zsh-users/zsh-syntax-highlighting
	littleq0903/gcloud-zsh-completion kind:fpath path:src
	EOBUNDLES
    unalias alias
else
    echo 'Consider installing Antibody: https://getantibody.github.io'
fi

STRFTIME='%Y-%m-%dT%H:%M:%S%z'

: ${HISTFILE:=$HOME/.zsh_history}
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory notify
setopt extended_history

bindkey -v
bindkey -M vicmd '^[' undefined-key

setopt prompt_percent
setopt prompt_subst
setopt vi
setopt interactive_comments
setopt extended_glob

setopt transient_rprompt

export LSCOLORS='Exfxcxdxbxegedabagacad'
export CLICOLOR='true'

zstyle :prompt:pure:prompt:success color green
zstyle :prompt:pure:user color 237
zstyle :prompt:pure:host color 237
zstyle :prompt:pure:git:branch color 237

if (($+commands[direnv])); then
    eval "$(direnv hook zsh)"
else
    echo 'Consider installing direnv: https://direnv.net'
fi

if (($+commands[rbenv])); then
    alias rbenv='unalias rbenv; eval "$(rbenv init -)"; rbenv'
fi
if (($+commands[pyenv])); then
    alias pyenv='unalias pyenv; eval "$(pyenv init -)"; pyenv'
fi
if (($+commands[cfenv])); then eval "$(cfenv init -)"; fi
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    export SDKMAN_DIR="$HOME/.sdkman"
    alias sdkman='unalias sdkman; source "$HOME/.sdkman/bin/sdkman-init.sh"; sdkman'
fi
if [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
    export NVM_DIR="$HOME/.nvm"
    alias nvm='unalias nvm; source "/usr/local/opt/nvm/nvm.sh"; nvm'
fi

autoload -Uz compinit
if [[ -n ~/.zcompdump*(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C "$HOME/bin/vault" vault

: ${VISUAL:=vim}
export VISUAL

CLH_SHELLRC_LOADED=yes
