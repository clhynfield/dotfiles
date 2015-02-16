
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

PS1="%(!.%F$_Cr.%F$_Cb)[${_Cn}%n@%m:%1~${_Cb}]${_Cn}\
${_Cp}200C${_Cp}33D%(?.$_Cb.$_Cr)(%?)${_Cb}[${_Cn}%D{$STRFTIME}${_Cb}]${_Cn}
%! %(?.😃.😡)  %# "
