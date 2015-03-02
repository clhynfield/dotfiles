# [clayton@Halifirien:dotfiles]                       [2015-03-02T10:37:42-0500]
# 10380 % nonesuch                                         d33f6cf git:(master*)
# [clayton@Halifirien:dotfiles]                       [2015-03-02T10:37:48-0500]
# 10381 ↵127 %                                             d33f6cf git:(master*)

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

local ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}(%{$fg[green]%}"
local ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
local ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✹"
local ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
local ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[green]%}➜"
local ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═"
local ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}✭"
local ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[yellow]%}"
local ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

local return_status="%(?..%{$fg[red]%}↵%?%{$reset_color%} )"

PROMPT="%(!.%F$_Cr.%F$_Cb)[${_Cn}%n@%m:%1~%(!.%F$_Cr.%F$_Cb)]${_Cn}\
${_Cp}200C${_Cp}26D${_Cb}[${_Cn}%D{$STRFTIME}${_Cb}]${_Cn}
%! ${return_status}%# "

RPROMPT='$(git_prompt_status) $(git_prompt_short_sha) $(git_prompt_info)'
