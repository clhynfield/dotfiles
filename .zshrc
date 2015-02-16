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


LC_TYPE=en_US.UTF-8; export LC_TYPE

[ $- = ${-#*i} ] && return # We're non-interactive, so no need to go on.

[ ! -z "$CLH_SHELLRC_LOADED" ] && return # Already sourced this file, no need to do it again.

# start screen automatically unless TERM ends in "noscreen"

if [ "${TERM%noscreen}" != "$TERM" ]
then
  TERM="${TERM%noscreen}"
else
    if [ -z "$TMUX" ] && [ -z "${CLH_SCREEN_STARTED}" ]
        if [ -z "$SSH_TTY" ]; then
            export CLH_SCREEN_ESCAPE=$'\cxx'
            export CLH_SCREEN_SESSION="local"
            export CLH_SCREEN_RC=".screenrc.local"
        else
            export CLH_SCREEN_ESCAPE=$'\caa'
            export CLH_SCREEN_SESSION="ssh"
            export CLH_SCREEN_RC=".screenrc"
        fi
        if hash tmux 2>/dev/null; then
            SCREEN_CMD=tmux
        elif hash screen &>/dev/null || ln -s screen_${OSTYPE%%[-.0123456789]*} ${HOME}/bin/screen &>/dev/null; then
            SCREEN_CMD="screen -A -x -R $CLH_SCREEN_SESSION -c $HOME/$CLH_SCREEN_RC"
        [ -w "$HOME/.ssh/agentrc" ] && set | grep SSH_ > "$HOME/.ssh/agentrc"
        [ -d "$HOME"/log/screen ] || mkdir -p "$HOME"/log/screen
        export CLH_SCREEN_STARTED=yes
        #exec screen -A -x -R $CLH_SCREEN_SESSION -c "$HOME"/$CLH_SCREEN_RC
        exec tmux -u
        # normally, execution of this rc script ends here...
        echo "Screen failed; continuing with normal $SHELL startup"
    fi
fi

zstyle ':completion:*' completer _expand _complete _ignored

autoload -Uz compinit
compinit

STRFTIME='%Y-%m-%dT%H:%M:%S%z'

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory notify
setopt extended_history

bindkey -v

setopt prompt_percent
setopt prompt_subst
setopt vi
setopt interactive_comments
setopt extended_glob


_Cp=$'\e['
_Ck="${_Cp}30m"
_Cr="${_Cp}31m"
_Cg="${_Cp}32m"
_Cy="${_Cp}33m"
_Cb="${_Cp}34m"
_Cm="${_Cp}35m"
_Cc="${_Cp}36m"
_Cw="${_Cp}37m"
_Cn="${_Cp}39m"

#PS1="\
#\${_U[\$UID]:-$_Cb}[$_Cn\
#%n@%m:\W\
#\${_U[\$UID]:-$_Cb}]$_Cn\
#${_Cp}200C${_Cp}28D${_Cp}\${#?}D\
#\${_R[\$?]:-$_Cr}($_Cn\
#\$?\
#\${_R[\$?]:-$_Cr})$_Cn\
#$_Cb[$_Cn\
#\D{$STRFTIME}\
#$_Cb]$_Cn\
#\n\! \\$ \
#"

PS1="%(!.%F$_Cr.%F$_Cb)[${_Cn}%n@%m:%1~${_Cb}]${_Cn}\
${_Cp}200C${_Cp}33D%(?.$_Cb.$_Cr)(%?)${_Cb}[${_Cn}%D{$STRFTIME}${_Cb}]${_Cn}
%! %(?.😃.😡)  %# "

SCREEN_TITLE="${WINDOW:+\033k%m:%1~\033\\\\}"
WINDOW_TITLE='\033]2;%m:%1~\007'
precmd () print -n -P "$WINDOW_TITLE$SCREEN_TITLE"


[ -r ${HOME}/.profile_local ] && . ${HOME}/.profile_local

[ -d "$HOME/.zsh/completions" ] && fpath=("$HOME/.zsh/completions" $fpath)
[ -d /usr/local/share/zsh-completions ] && fpath=(/usr/local/share/zsh-completions $fpath)

CLH_SHELLRC_LOADED=yes
