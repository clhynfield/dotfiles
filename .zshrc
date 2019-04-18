PATH=\
~/bin:/usr/local/bin:/usr/xpg4/bin:/usr/bin:/bin:\
/usr/ucb:/usr/ccs/bin:/usr/contrib/bin:/usr/games:\
/usr/bin/X11:/usr/openwin/bin\
/opt/bin:\
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

# start screen automatically unless TERM ends in "noscreen"

if [ "${TERM%noscreen}" != "$TERM" ]
then
  TERM="${TERM%noscreen}"
else
    if [ -z "$TMUX" ] && [ -z "$CLH_SCREEN_STARTED" ]
        if [ -z "$SSH_TTY" ]; then
            export CLH_SCREEN_ESCAPE=$'\cxx'
            export CLH_SCREEN_SESSION="local"
            export CLH_SCREEN_RC=".screenrc.local"
        else
            export CLH_SCREEN_ESCAPE=$'\caa'
            export CLH_SCREEN_SESSION="ssh"
            export CLH_SCREEN_RC=".screenrc"
        fi
        if (($+commands[tmux])); then
            SCREEN_CMD=tmux
        elif (($+commands[screen])) \
            || ln -s "screen_${OSTYPE%%[-.0123456789]*}" "$HOME/bin/screen" &>/dev/null; then
            SCREEN_CMD="screen -A -x -R $CLH_SCREEN_SESSION -c $HOME/$CLH_SCREEN_RC"
        [ -w "$HOME/.ssh/agentrc" ] && set | grep SSH_ > "$HOME/.ssh/agentrc"
        [ -d "$HOME/log/screen" ] || mkdir -p "$HOME/log/screen"
        export CLH_SCREEN_STARTED=yes
        exec tmux -u
        # normally, execution of this rc script ends here...
        echo "Screen failed; continuing with normal $SHELL startup"
    fi
fi

if [[ -r "$HOME/.profile_local" ]]; then source "$HOME/.profile_local"; fi

if (($+commands[antibody])); then source <(antibody init); fi

alias alias=true
antibody bundle <<EOBUNDLES
frodenas/cf-zsh-autocomplete-plugin
frodenas/bosh-zsh-autocomplete-plugin
mafredri/zsh-async
sindresorhus/pure
zsh-users/zsh-completions src
zsh-users/zsh-syntax-highlighting
EOBUNDLES
unalias alias

autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C "$HOME/bin/vault" vault

STRFTIME='%Y-%m-%dT%H:%M:%S%z'

: ${HISTFILE:=$HOME/.zsh_history}
HISTSIZE=10000
SAVEHIST=1000
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

SCREEN_TITLE="${WINDOW:+\033k%m:%1~\033\\\\}"
WINDOW_TITLE='\033]2;%m:%1~\007'
precmd () print -n -P "$WINDOW_TITLE$SCREEN_TITLE"

if hash direnv 2>&1 >/dev/null; then
    eval "$(direnv hook zsh)"
fi

if (($+commands[rbenv])); then eval "$(rbenv init -)"; fi
if (($+commands[pyenv])); then eval "$(pyenv init -)"; fi
if (($+commands[pyenv-virtualenv-init])); then eval "$(pyenv virtualenv-init -)"; fi
if (($+commands[cfenv])); then eval "$(cfenv init -)"; fi
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
if [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
    export NVM_DIR="$HOME/.nvm"
    source "/usr/local/opt/nvm/nvm.sh"
fi

: ${VISUAL:=vim}
export VISUAL

CLH_SHELLRC_LOADED=yes
