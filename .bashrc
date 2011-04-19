BASHRC_VERSION=200906251556; export BASHRC_VERSION

{ # PATHS
PATH=\
~/bin:/usr/local/bin:/usr/xpg4/bin:/usr/bin:/bin:\
/usr/ucb:/usr/ccs/bin:/usr/contrib/bin:/usr/games:\
/usr/bin/X11:/usr/openwin/bin\
/opt/bin:\
/usr/local/sbin:/usr/sbin:/sbin
export PATH

MANPATH=\
/usr/share/man:/usr/local/man:/usr/man:\
/usr/xpg4/man:/usr/ucb/man:\
/usr/X11R6/man:/usr/openwin/man:\
/usr/lang/man
export MANPATH
} # PATHS

LC_TYPE=en_US.UTF-8; export LC_TYPE

if echo $- | grep i > /dev/null && [ -z "$CLHBASHRC" ]; then { # INTERACTIVE

{ # EARLY
#if [ -z "$HOST" ]; then HOST=`uname -n`; fi; HOST=${HOST%%.*}
#HOST=$HOSTNAME; HOST=${HOST%%.*}; export HOST

if [ -z "$BASH" -a -x /bin/bash ]; then # SWITCH TO BASH
  exec /bin/bash
  exec /bin/bash
fi

[ -r ${HOME}/.bashrc_local ] && . ${HOME}/.bashrc_local
[ -r /sw/bin/init.sh       ] && . /sw/bin/init.sh
} # EARLY

{ # SCREEN: start screen automatically if this is a remote login
if [ "${TERM: -8}" == "noscreen" ]
then
  TERM="${TERM/noscreen/}"
  SCREEN_DISABLED=1
fi

if [ ${SCREEN_DISABLED:-x} = "x" ]
then
    if { [ "$PS1" != "" \
         -a "${SCREEN_STARTED:-x}" == x ]; } \
       && { hash screen &>/dev/null || ln -s screen_`uname -s | tr [A-Z] [a-z]` ${HOME}/bin/screen &>/dev/null; }
    then
        echo -ne "\e]1;$HOSTNAME${WINDOW:+/${STY#*.}#$WINDOW}\a"
        [ -w "$HOME/.ssh/agentrc" ] && set | grep SSH_ > "$HOME/.ssh/agentrc"
        if grep "$BASHRC_VERSION" "$HOME"/.screenrc &>/dev/null
        then
            echo -n ""
        else
            [ -r "$HOME"/.screenrc ] && cp "$HOME"/.screenrc "$HOME"/.screenrc.$BASHRC_VERSION
            cat <<EOF_SCREENRC > "$HOME"/.screenrc
setenv SCREEN_RC_VERSION $BASHRC_VERSION
setenv SCREEN_STARTED 1

termcapinfo xterm 'hs:xt:tf:ax:af=\E[3%dm:ts=\E]2;:fs=\007:ds=\E]2;screen\007:ti@:te@:WS=\E[8;%d;%d;t'
term xterm
hardstatus on

defscrollback 10000

defutf8 on
caption always

escape \$SCREEN_ESCAPE

shell /bin/bash

logfile "\$HOME/log/screen/%Y%m%d-%n.log"
deflog on

startup_message off

autodetach on
EOF_SCREENRC
            [ -r "$HOME"/.screenrc.local ] && cp "$HOME"/.screenrc.local "$HOME"/.screenrc.local.$BASHRC_VERSION
            ( cat "$HOME"/.screenrc; cat <<"EOF_SCREENRC_LOCAL" ) > "$HOME"/.screenrc.local
height $SCREEN_HEIGHT
width $SCREEN_WIDTH
hardstatus string $SCREEN_HARDSTATUS
setenv DISPLAY :0.0
bind s width 132 42
EOF_SCREENRC_LOCAL
        fi
        if [ "${SSH_TTY:-x}" == "x" ]
        then
            export SCREEN_ESCAPE=$'\cxx'
            export SCREEN_SESSION="local"
            export SCREEN_HARDSTATUS="%n %h"
            export SCREEN_WIDTH=132
            export SCREEN_HEIGHT=42
            export SCREEN_RC=".screenrc.local"
        else
            export SCREEN_ESCAPE=$'\caa'
            export SCREEN_SESSION="ssh"
            export SCREEN_HARDSTATUS="%h"
            export SCREEN_WIDTH=132
            export SCREEN_HEIGHT=41
            export SCREEN_RC=".screenrc"
        fi
        [ -d "$HOME"/log/screen ] || mkdir -p "$HOME"/log/screen
        exec screen -A -x -R $SCREEN_SESSION -c "$HOME"/$SCREEN_RC
        # normally, execution of this rc script ends here...
        echo "Screen failed; continuing with normal bash startup"
    fi
fi
}


{ # CONTROL: Make sure those control characters work as expected
IGNOREEOF=0   # Control-D should let you exit the shell
stty erase  # Backspace is backspace
stty kill   # Control-U is kill (to beginning of line)
stty intr   # Control-C is interrupt
stty stop   # Control-Z is stop
} # CONTROL

{ # HISTORY: Never forget that command again!
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups
} # HISTORY

{ # VI: Emacs is a great operating system. Too bad it lacks a good editor
EDITOR=vi; export EDITOR
set -o vi
} # VI

{ # COLOR: Put a little color in your life
CLICOLOR=true                  ; export CLICOLOR
LSCOLORS=exfxcxdxbxegedabagacad; export LSCOLORS
LESS_TERMCAP_mb=$'\E[01;31m'   ; export LESS_TERMCAP_mb
LESS_TERMCAP_md=$'\E[01;31m'   ; export LESS_TERMCAP_md
LESS_TERMCAP_me=$'\E[0m'       ; export LESS_TERMCAP_me
LESS_TERMCAP_se=$'\E[0m'       ; export LESS_TERMCAP_se
LESS_TERMCAP_so=$'\E[01;44;33m'; export LESS_TERMCAP_so
LESS_TERMCAP_ue=$'\E[0m'       ; export LESS_TERMCAP_ue
LESS_TERMCAP_us=$'\E[01;32m'   ; export LESS_TERMCAP_us
if ls --color=tty &>/dev/null
then
    alias ls="ls --color=tty"
    DIRCOLORS=`type -p dircolors`
    if [ -x "$DIRCOLORS" -a -r "${HOME}/.dircolors" ]; then
        eval `"$DIRCOLORS" "${HOME}/.dircolors"`
    fi
fi
} # COLOR

{ # DATE: ISO dates sort well
if [[ ( ${OSTYPE#linux-gnu} != $OSTYPE ) || ( ${OSTYPE#darwin} != $OSTYPE ) ]]
then
    STRFTIME="%Y-%m-%dT%H:%M:%S%z"
else
    STRFTIME="%Y-%m-%dT%H:%M:%S%Z"
fi
export STRFTIME
alias isodate='date +"$STRFTIME"'
} # DATE

{ # COMMANDS:

if [ -x /usr/bin/less ]; then
    PAGER=less
    alias more="$PAGER"
else
    PAGER=more
fi; export PAGER

function mcd { mkdir -p $1 && cd $1; }

function awksum {
	sep="";
	if [ "$1" = "-F" ]; then
		sep="-F $2";
		if [ -n "$3" ]; then
			field="$3";
		else
			field='$1';
		fi
	elif [ -n "$1" ]; then
		field="$1";
	else
		field='$1';
	fi
	awk $sep '{sum = sum + '$field'} END {print sum}'
}

function rule {
    echo '12345678901234567890123456789012345678901234567890123456789012345678901234567890'
    echo '         1         2         3         4         5         6         7         8'
}

function count {
    perl -pe 'print STDERR ++$b."MB\r" if($c+=length)>$b*1048576'
}

function rcount {
    ruby -ne 'BEGIN{$l=0};END{print $l.to_s+"\n"};($l+=$_.length)%1024>0||print($l.to_s,"\n")'
}

function forget { # Fire and forget: minimizes window, executes command, restores window
    tfunk -i
    $@
    tfunk -I
} # function forget

# Set up aliases for all known hosts, so that you can type just the
# name of the host to ssh to it.  This in combination with keypair
# authentication allows for some really quick work:
# $ mcsmos01 grep failed /var/log/httpd/error_log | more
for FILE in "$HOME/.ssh/known_hosts" "$HOME/.ssh/known_hosts2"; do {
    if [ -r "$FILE" ]
    then
        for i in `< "$FILE" awk '{print $1}' | tr , ' '`; do
            if ! type -p $i > /dev/null; then
                alias "$i"="ssh $i"
            fi
        done
    fi
} done

function _ssh_completion {
    CUR="${COMP_WORDS[COMP_CWORD]}";
    COMPREPLY=( $(compgen -W "$(awk 'BEGIN { \
                                         i=0} \
                                     { \
                                         split($1, nodes, ","); \
                                         gsub("([[]|[]]:?[0-9]*)", "", nodes[1]); \
                                         hosts[i++]=nodes[1]
                                     } END { \
                                         for (j in hosts) {print hosts[j]}
                                     }' \
                                     ~/.ssh/known_hosts)" \
                          -- ${CUR})
    );
    return 0;
}

function _scp_completion {
    CUR="${COMP_WORDS[COMP_CWORD]}";
    COMPREPLY=( $(compgen -W "$(awk 'BEGIN { \
                                         i=0} \
                                     { \
                                         split($1, nodes, ","); \
                                         gsub("([[]|[]]:?[0-9]*)", "", nodes[1]); \
                                         hosts[i++]=nodes[1]
                                     } END { \
                                         for (j in hosts) {print hosts[j]}
                                     }' \
                                     ~/.ssh/known_hosts)" \
                          -S : \
                          -- ${CUR})
    );
    return 0;
}

complete -o default -F _ssh_completion ssh
complete -o default -o nospace -F _scp_completion scp

} # COMMANDS

{ # CONFIGS: Configuring other environments

# screen
if [ ! -f "$HOME/.screenrc" ]; then
    echo "term xterm"                                                 >  "$HOME/.screenrc"
    echo "multiuser on"                                               >> "$HOME/.screenrc"
    echo "startup_message off"                                        >> "$HOME/.screenrc"
    echo "defscrollback 10000"                                        >> "$HOME/.screenrc"
    echo "termcapinfo xterm 'hs:ts=\E]2;:fs=\007:ds=\E]2;screen\007'" >> "$HOME/.screenrc"
fi

} # CONFIGS

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
_U[0]=$_Cr
_R[0]=$_Cb

function tfunk { # TFUNK: Crazy terminal stuff
    # Supported functions:
    # move cursor: up, down, left, right
    # window ops: iconify, deiconify, bottom, top, zoom, unzoom
    # media copy: print screen, turn on/off printer controller mode
    # reset
    # from http://www.xfree86.org/current/ctlseqs.html

    local args="u. up. d. down. r. right. l. left. x: y: 
                i iconify I deiconify b bottom t top
                z zoom Z unzoom h: height: w: width:
                p print P noprint 
                R reset 
                v reverse
                c. color."

    local string=""

    local height=$LINES
    local width=$COLUMNS
    local x; local y

    unset OPTIND
    while getoptex "$args" "$@"
    do
        OPTARG=${OPTARG#=}
        case "$OPTOPT" in
            u | up )              string="$string$_Cp${OPTARG}A" ;;
            d | down )            string="$string$_Cp${OPTARG}B" ;;
            r | right )           string="$string$_Cp${OPTARG}C" ;;
            l | left )            string="$string$_Cp${OPTARG}D" ;;
            x )
                x="$OPTARG"
                if [ ! -z "$x" -a ! -z "$y" ]; then
                    string="$string${_Cp}3;${x};${y}t"
                fi ;;
            y )
                y="$OPTARG"
                if [ ! -z "$x" -a ! -z "$y" ]; then
                    string="$string${_Cp}3;${x};${y}t"
                fi ;;
            i | iconify )         string="$string${_Cp}2t" ;;
            I | deiconify )       string="$string${_Cp}1t" ;;
            b | bottom )          string="$string${_Cp}6t" ;;
            t | top )             string="$string${_Cp}5t" ;;
            z | zoom )            string="$string${_Cp}9;1t" ;;
            Z | unzoom )          string="$string${_Cp}9;0t" ;;
            p | print )           string="$string${_Cp}5i" ;;
            P | noprint )         string="$string${_Cp}4i" ;;
            v | reverse )         string="$string${_Cp}?5h" ;;
            c | color )         case "$OPTARG" in
                    black )       string="$string${_Ck}" ;;
                    red )         string="$string${_Cr}" ;;
                    green )       string="$string${_Cg}" ;;
                    yellow )      string="$string${_Cy}" ;;
                    blue )        string="$string${_Cb}" ;;
                    magenta )     string="$string${_Cm}" ;;
                    cyan )        string="$string${_Cc}" ;;
                    white )       string="$string${_Cw}" ;;
                    * )           string="$string${_Cn}" ;; esac ;;
            R | reset )           string="$string\ec" ;;
            h | height )
                height="$OPTARG"
                string="$string${_Cp}8;${height};${width}t" ;;
            w | width )
                width="$OPTARG"
                string="$string${_Cp}8;${height};${width}t" ;;
        esac
    done
    shift $(($OPTIND-1))

    # Default action is to reset the window and resize to 132x42
    if [ -z "$string" ]
    then
        echo -ne "\e[8;42;132t\e[8;42;132\ec"
    else
        echo -ne "$string"
    fi

} # function tfunk

{ # GETOPTX: Functions to parse long options in bash
  # from http://nlp.cs.jhu.edu/~edrabek/utils/

function getoptex {
  [ $# -gt 0 ] || return 1
  local optlist="${1#;}"
  (( ${OPTIND:-0} )) || OPTIND=1
  [ $OPTIND -lt $# ] || return 1
  shift $OPTIND
  if [ "$1" != "-" -a "$1" != "${1#-}" ]
  then OPTIND=$(($OPTIND+1)); if [ "$1" != "--" ]
  then
    local o
    o="-${1#-$OPTOFS}"
    for opt in ${optlist#;}
    do
      OPTOPT="${opt%[;.:]}"
      unset OPTARG
      local opttype="${opt##*[^;:.]}"
      [ -z "$opttype" ] && opttype=";"
      if [ ${#OPTOPT} -gt 1 ]
      then # long-named option
        case $o in
          "--$OPTOPT")
            if [ "$opttype" != ":" ]; then return 0; fi
            OPTARG="$2"
            if [ -z "$OPTARG" ];
            then # error: must have an agrument
              (( ${OPTERR:-0} )) && echo "$0: error: $OPTOPT must have an argument" >&2
              OPTARG="$OPTOPT";
              OPTOPT="?"
              return 1;
            fi
            OPTIND=$(($OPTIND+1)) # skip option's argument
            return 0
          ;;
          "--$OPTOPT="*)
            if [ "$opttype" = ";" ];
            then  # error: must not have arguments
              let OPTERR && echo "$0: error: $OPTOPT must not have arguments" >&2
              OPTARG="$OPTOPT"
              OPTOPT="?"
              return 1
            fi
            OPTARG=${o#"--$OPTOPT="}
            return 0
          ;;
        esac
      else # short-named option
        case "$o" in
          "-$OPTOPT")
            unset OPTOFS
            [ "$opttype" != ":" ] && return 0
            OPTARG="$2"
            if [ -z "$OPTARG" ]
            then
              echo "$0: error: -$OPTOPT must have an argument" >&2
              OPTARG="$OPTOPT"
              OPTOPT="?"
              return 1
            fi
            OPTIND=$(($OPTIND+1)) # skip option's argument
            return 0
          ;;
          "-$OPTOPT"*)
            if [ $opttype = ";" ]
            then # an option with no argument is in a chain of options
              OPTOFS="$OPTOFS?" # move to the next option in the chain
              OPTIND=$((OPTIND-1)) # the chain still has other options
              return 0
            else
              unset OPTOFS
              OPTARG="${o#-$OPTOPT}"
              return 0
            fi
          ;;
        esac
      fi
    done
    echo "$0: error: invalid option: $o"
  fi; fi
  OPTOPT="?"
  unset OPTARG
  return 1
} # function getoptex

function optlistex {
  local l="$1"
  local m # mask
  local r # to store result
  while [ ${#m} -lt $[${#l}-1] ]; do m="$m?"; done # create a "???..." mask
  while [ -n "$l" ]
  do
    r="${r:+"$r "}${l%$m}" # append the first character of $l to $r
    l="${l#?}" # cut the first charecter from $l
    m="${m#?}"  # cut one "?" sign from m
    if [ -n "${l%%[^:.;]*}" ]
    then # a special character (";", ".", or ":") was found
      r="$r${l%$m}" # append it to $r
      l="${l#?}" # cut the special character from l
      m="${m#?}"  # cut one more "?" sign
    fi
  done
  echo $r
} # function optlistex

function getopt {
  local optlist=`optlistex "$1"`
  shift
  getoptex "$optlist" "$@"
  return $?
} # function getopt

} # GETOPTX

{ # PROMPT:

SCREEN_TITLE="${WINDOW:+\ek$SCREEN_ESCAPE ${HOSTNAME}:\$PWD\e\\\\}"
WINDOW_TITLE='\e]2;$HOSTNAME${WINDOW:+/${STY#*.}#$WINDOW}\a'
PROMPT_COMMAND="echo -ne \"$WINDOW_TITLE$SCREEN_TITLE\""
export PROMPT_COMMAND

# [username@host:/current/dir]               (0)[2005-10-13T09:18:09-0400]
# $
PS1="\
\[\${_U[\$UID]:-$_Cb}\][\[$_Cn\]\
\u@${HOSTNAME}:\W\
\[\${_U[\$UID]:-$_Cb}\]]\[$_Cn\]\
\[${_Cp}200C${_Cp}28D${_Cp}\${#?}D\]\
\[\${_R[\$?]:-$_Cr}\](\[$_Cn\]\
\$?\
\[\${_R[\$?]:-$_Cr}\])\[$_Cn\]\
\[$_Cb\][\[$_Cn\]\
\D{$STRFTIME}\
\[$_Cb\]]\[$_Cn\]\
\n\! \\$ \
"

PS2="> "

} # PROMPT

{ # LATE
[ -r ${HOME}/.profile_local ] && . ${HOME}/.profile_local
} # LATE

} fi # INTERACTIVE

CLHBASHRC=yes
