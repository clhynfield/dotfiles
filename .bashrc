#pragma mark - BEGIN

cd

#pragma mark - PATHS

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


LC_TYPE=en_US.UTF-8; export LC_TYPE

[ $- = ${-#*i} ] && return # We're non-interactive, so no need to go on.
    
[ ! -z "$CLH_SHELLRC_LOADED" ] && return # Already sourced this file, no need to do it again.


#pragma mark - EARLY

if [ -z "$BASH" -a -x /bin/bash ]; then # SWITCH TO BASH
  exec /bin/bash
  exec /bin/bash
fi

[ -r ${HOME}/.bashrc_local ] && . ${HOME}/.bashrc_local
[ -r /sw/bin/init.sh       ] && . /sw/bin/init.sh


#pragma mark - SCREEN
# start screen automatically unless TERM ends in "noscreen"

if [ "${TERM%noscreen}" != "$TERM" ]
then
  TERM="${TERM%noscreen}"
else
    if  [ -z "${CLH_SCREEN_STARTED}" ] && hash screen &>/dev/null || ln -s screen_${OSTYPE%%[-.0123456789]*} ${HOME}/bin/screen &>/dev/null; then
        [ -w "$HOME/.ssh/agentrc" ] && set | grep SSH_ > "$HOME/.ssh/agentrc"
        if [ -z "$SSH_TTY" ]
        then
            export CLH_SCREEN_ESCAPE=$'\cxx'
            export CLH_SCREEN_SESSION="local"
            export CLH_SCREEN_RC=".screenrc.local"
        else
            export CLH_SCREEN_ESCAPE=$'\caa'
            export CLH_SCREEN_SESSION="ssh"
            export CLH_SCREEN_RC=".screenrc"
        fi
        [ -d "$HOME"/log/screen ] || mkdir -p "$HOME"/log/screen
        export CLH_SCREEN_STARTED=yes
        exec screen -U -A -x -R $CLH_SCREEN_SESSION -c "$HOME"/$CLH_SCREEN_RC
        # normally, execution of this rc script ends here...
        echo "Screen failed; continuing with normal bash startup"
    fi
fi


#pragma mark - CONTROL
# Make sure those control characters work as expected

IGNOREEOF=0   # Control-D should let you exit the shell
stty erase  # Backspace is backspace
stty kill   # Control-U is kill (to beginning of line)
stty intr   # Control-C is interrupt
stty stop   # Control-Z is stop


#pragma mark - HISTORY
# Never forget that command again!

HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups


#pragma mark - VI
# Emacs is a great operating system. Too bad it lacks a good editor

EDITOR=vi; export EDITOR
set -o vi


#pragma mark - COLOR
# Put a little color in your life

CLICOLOR='YES'                     ; export CLICOLOR
LSCOLORS='exfxcxdxbxegedabagacad'  ; export LSCOLORS

if [ ! -f $HOME/.ls_colors ]; then
    if ls --color=tty &>/dev/null
    then
        alias ls='ls --color=tty'
    fi
fi


#pragma mark - DATE
# ISO dates sort well

if [[ ( ${OSTYPE#linux-gnu} != $OSTYPE ) || ( ${OSTYPE#darwin} != $OSTYPE ) ]]
then
    STRFTIME="%Y-%m-%dT%H:%M:%S%z"
else
    STRFTIME="%Y-%m-%dT%H:%M:%S%Z"
fi
export STRFTIME
alias isodate='date +"$STRFTIME"'


#pragma mark - COMMANDS:

if [ -x /usr/bin/less ]; then
    PAGER=less
    alias more="$PAGER"
else
    PAGER=more
fi; export PAGER

mcd() { mkdir -p $1 && cd $1; }

awksum() {
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

rule() {
    echo '12345678901234567890123456789012345678901234567890123456789012345678901234567890'
    echo '         1         2         3         4         5         6         7         8'
}

function count {
    perl -pe 'print STDERR ++$b."MB\r" if($c+=length)>$b*1048576'
}

function rcount {
    ruby -ne 'BEGIN{$l=0};END{print $l.to_s+"\n"};($l+=$_.length)%1024>0||print($l.to_s,"\n")'
}

# Fire and forget: minimizes window, executes command, restores window
function forget {
    tfunk -i
    $@
    tfunk -I
} # function forget

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


#pragma mark - TITLES AND PROMPTS

_Cp=$'\033['
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

function tfunk {
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
            R | reset )           string="$string\033c" ;;
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
        echo -ne "\033[8;42;132t\033[8;42;132\033c"
    else
        echo -ne "$string"
    fi

} # function tfunk

#pragma mark - GETOPTX
# Functions to parse long options in bash
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


#pragma mark - PROMPT

#SCREEN_TITLE="${WINDOW:+\033k$CLH_SCREEN_ESCAPE ${HOSTNAME%.*}:\$PWD\033\\\\}"
SCREEN_TITLE="${WINDOW:+\033k\$PWD\033\\\\}"
WINDOW_TITLE='\033]2;${HOSTNAME%.*}${WINDOW:+/${STY#*.}#$WINDOW}\007'
PROMPT_COMMAND="echo -ne \"$WINDOW_TITLE$SCREEN_TITLE\""
export PROMPT_COMMAND

# [username@host:/current/dir]               (0)[2005-10-13T09:18:09-0400]
# $
PS1="\
\[\${_U[\$UID]:-$_Cb}\][\[$_Cn\]\
\u@${HOSTNAME%.*}:\W\
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


#pragma mark - LATE

[ -r ${HOME}/.profile_local ] && . ${HOME}/.profile_local

#pragma mark - FINISH

CLH_SHELLRC_LOADED=yes
