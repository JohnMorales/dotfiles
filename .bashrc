PATH=$PATH:$HOME/bin:$HOME/.rvm/bin # Add RVM to PATH for scripting
set -o vi
[[ -r ~/.rvm/scripts/rvm ]] && . ~/.rvm/scripts/rvm
[[ -r /usr/local/etc/bash_completion.d/git-prompt.sh ]] && . /usr/local/etc/bash_completion.d/git-prompt.sh
function prompt
{
local WHITE="\[\033[1;37m\]"
local GREEN="\[\033[0;32m\]"
local CYAN="\[\033[0;36m\]"
local GRAY="\[\033[0;37m\]"
local BLUE="\[\033[0;34m\]"
export PS1="
${GREEN}\u${CYAN}@${BLUE}\h ${CYAN}\w"' $(__git_ps1 "(%s)") '"${GRAY}"
}
prompt
