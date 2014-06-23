##############################################
# Vim
#
##############################################

set -o vi
export EDITOR=vim


##############################################
# Path
#
##############################################
PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

##############################################
# Ruby
#
##############################################
if [ "$(type -t rbenv)" == "file" ]; then
  eval "$(rbenv init -)"
fi


##############################################
# Aliases
#
##############################################
alias vms='VBoxManage list runningvms'
alias ls='ls -lph --color'
alias t2='tree -Fth -L 2 --du |less'
alias rgrep="grep -r --exclude-dir=.git  --exclude=*.swp"
alias clear_dns="sudo killall -HUP mDNSResponder"
alias vi=vim
alias aws_ssh="ssh -i ~/.ssh/JM-MacbookPro.pem" # forcing using aws key when sshing into ec2 machines



##############################################
# Functions
#
##############################################
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
git_pending() {
  show_diff=$1
  directories=$(find . -type d -depth 1 | grep -v '^\./\.')
  for i in $directories;
  do
    #echo "checking $i"
    if [ ! -d "$i/.git" ]; then
      continue
    fi
    (cd $i
    STATUS=$(git status)
    if [[ "$STATUS" =~ "Your branch is ahead of" ]]; then
      echo "$i pending push"
      if [[ "$show_diff" != "" ]]
      then
        git status && git diff
      fi
    fi
    )
  done
}
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
  tmux set-environment -g ITERM_PROFILE SolarizedLight
}
dark() {
  export ITERM_PROFILE=SolarizedDark
  tmux source-file ~/Development/tmux-colors-solarized/tmuxcolors-dark.conf
  tmux set-environment -g ITERM_PROFILE SolarizedDark
}
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
build_bump() {
  ver=$(grep version metadata.rb|awk -F"[.']" '{print $4}')
  new_version=$((ver+1))
  echo "Updating metadata to $new_version"
  sed -e "/version/s/${ver}/${new_version}/" -i '' metadata.rb
}
minor_bump() {
  ver=$(grep version metadata.rb|awk -F"[.']" '{print $3}')
  new_version=$((ver+1))
  echo "Updating metadata to $new_version"
  sed -e "/version/s/\.${ver}\./\.${new_version}\./" -i ''  metadata.rb
}

#DIR Colors
export CLICOLOR=1
if [[ "SolarizedLight" == $ITERM_PROFILE ]]; then
  eval $(dircolors ~/.dir_colors_light)
else
  eval $(dircolors ~/.dir_colors_dark)
fi
if [ "$TMUX" ] && [ "$(tmux showenv -g ITERM_PROFILE)" ]; then
  eval $(tmux showenv -g ITERM_PROFILE)
fi
if [ -t 1 ]; then
  if [ "$ITERM_PROFILE" == "SolarizedLight" ]; then
    echo "setting background to light";
    light
  fi;
  if [ "$ITERM_PROFILE" == "SolarizedDark" ]; then
    echo "setting background to dark";
    dark
  fi;
fi;

##############################################
# Externals
#
##############################################

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

if [ -f ~/.dockerrc ]; then
  . ~/.dockerrc
fi

if [ -f ~/.cdpath ]; then
  . ~/.cdpath
fi;

##############################################
# Git prompt
#
##############################################

#Customizing git prompt
ResetColor="[0m\]"
Yellow="[0;33m\]"
BoldGreen="[1;32m\]"
Green="[0;32m\]"
GIT_PROMPT_START="${BoldGreen}\h ${Yellow}\w${ResetColor}"
[ -f ~/.bash-git-prompt/gitprompt.sh ] && . ~/.bash-git-prompt/gitprompt.sh || echo "Missing git prompt, please run makesetup"

##############################################
# AWS settings
#
##############################################
export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.5.2/libexec"
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.6.13.0/libexec"
export JAVA_HOME="$(/usr/libexec/java_home)"
if [ -f ~/.awskey ]; then
  . ~/.awskey
fi;
