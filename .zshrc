STRFTIME='%Y-%m-%dT%H:%M:%S%z'

setopt extended_history
setopt prompt_percent
setopt prompt_subst

HISTFILE=$HOME/.zsh_history
HISTSIZE=2000
SAVEHIST=1000

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
${_Cp}200C${_Cp}31D%(?.$_Cb.$_Cr)(%?)${_Cb}[${_Cn}%D{$STRFTIME}${_Cb}]${_Cn}
%! %# "

if [[ $ZSH_NAME != 'zsh' ]]; then
    alias blcli='blcli -r AMKT-WIDE-APPSERVICES_PACKAGER'
    
    setopt vi
    
    if blcred cred -test; then
        blcli_setoption serviceProfileName Prod
        blcli_setoption roleName AMKT-WIDE-APPSERVICES_PACKAGER
        blcli_connect && echo "blcli now connected" || echo "blcli connection failed"
        alias bl=blcli_execute
        alias blstore=blcli_storeenv
    else
        echo "BL credential test failed, try restarting NSH"
    fi
fi
