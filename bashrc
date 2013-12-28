. ~/.bash-git-prompt/gitprompt.sh
set -o vi
eval "$(rbenv init -)"
alias t2='tree -L 2 |less'
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
alias ls='ls --color'
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
export EDITOR=vim
alias vms='VBoxManage list runningvms'
power_down_vms() {
  VMS=$(VBoxManage list runningvms | awk '{ x=$1;gsub("\"", "", x);print x }')
  for i in $VMS 
  do 
    echo "Shutting down $i"
    VBoxManage controlvm $i poweroff 2> /dev/null
  done
}
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
export CLICOLOR=1
