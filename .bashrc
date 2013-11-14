set -o vi
export PATH="/usr/local/bin:/usr/local/heroku/bin:$PATH"
alias rb=rbenv
if [![ -f ~/.bash-git-prompt/gitprompt.sh ]]; then 
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
; fi
. ~/.bash-git-prompt/gitprompt.sh
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
