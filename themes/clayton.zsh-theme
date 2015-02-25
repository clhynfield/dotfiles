
local _Cp=$'\e['
local _Ck="${_Cp}30m"
local _Cr="${_Cp}31m"
local _Cg="${_Cp}32m"
local _Cy="${_Cp}33m"
local _Cb="${_Cp}34m"
local _Cm="${_Cp}35m"
local _Cc="${_Cp}36m"
local _Cw="${_Cp}37m"
local _Cn="${_Cp}39m"

local return_status="%(?.. ${_Cp}$#?D%{$fg[red]%}↵%?%{$reset_color%})"

PROMPT="%(!.%F$_Cr.%F$_Cb)[${_Cn}%n@%m:%1~%(!.%F$_Cr.%F$_Cb)]${_Cn}\
${_Cp}200C${_Cp}27D${return_status}${_Cb}[${_Cn}%D{$STRFTIME}${_Cb}]${_Cn}
%! %# "

RPROMPT='$(git_prompt_status) $(git_prompt_short_sha) $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[green]%}➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}✭"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"
