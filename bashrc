#Customizing git prompt
ResetColor="\[\033[0m\]"            # Text reset
IntenseBlack="\[\033[0;90m\]" # Grey
Yellow="\[\033[0;33m\]"
IntenseBlack="\[\033[0;90m\]"
BoldGreen="\[\033[1;32m\]"
GIT_PROMPT_START="${BoldGreen}\h ${Yellow}\w${ResetColor}"

[ -f ~/.bash-git-prompt/gitprompt.sh ] && . ~/.bash-git-prompt/gitprompt.sh || echo "Missing git prompt, please run makesetup"
set -o vi
eval "$(rbenv init -)"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
export EDITOR=vim

# Vagrant aliases.
alias vms='VBoxManage list runningvms'
power_down_vms() {
  VMS=$(VBoxManage list runningvms |grep -v boot2docker | awk '{ x=$1;gsub("\"", "", x);print x }')
  for i in $VMS 
  do 
    echo "Shutting down $i"
    VBoxManage controlvm $i poweroff 2> /dev/null
  done
}
power_down_vm() {
  VM=$1
  echo "Shutting down $VM"
  VBoxManage controlvm $VM poweroff 2> /dev/null
}
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

#DIR Colors 
export CLICOLOR=1
alias ls='ls -lph --color'
if [[ "SolarizedLight" == $ITERM_PROFILE ]]; then
  eval $(dircolors ~/.dir_colors_light)
else
  eval $(dircolors ~/.dir_colors_dark)
fi
alias t2='tree -Fth -L 2 --du |less'
#Git helper
git_dirty() {
  show_diff=$1
  directories=$(find . -type d -depth 1 | grep -v '^\./\.')
  for i in $directories; 
  do 
    #echo "checking $i"
    if [ ! -d "$i/.git" ]; then  
      continue 
    fi 
    cd $i
    STATUS=$(git status)
    if [[ ! "$STATUS" =~ "working directory clean" ]]; then 
      echo "$i dirty"  
      if [[ "$show_diff" != "" ]]
      then
        git status && git diff
      fi
    fi 
    cd ..
  done
}
create_local_gemset() {
  echo './.gems' > .rbenv-gemsets
}
light() {
  export ITERM_PROFILE=SolarizedLight
  tmux source-file ~/Development/tmux-colors-solarized/tmuxcolors-light.conf
}
dark() {
  export ITERM_PROFILE=SolarizedDark
  tmux source-file ~/Development/tmux-colors-solarized/tmuxcolors-dark2.conf
}
alias rgrep="grep -r --exclude-dir=.git  --exclude=*.swp"
export DOCKER_HOST=localhost
if [ -t 1 ]; then
  if [ "$COLORFGBG" == "11;15" ]; then
    echo "setting background to light";
    light
  fi;
  if [ "$COLORFGBG" == "12;8" ]; then 
    echo "setting background to dark";
    dark
  fi;
fi;
