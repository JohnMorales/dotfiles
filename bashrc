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
PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:./bin:$PATH"
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
alias vms='VBoxManage list runningvms' # See virtualbox running machines.
alias ls='ls -lph --color'
alias t2='tree -Fth -L 2 --du |less' #see tree with size up to 2 levels deep
alias rgrep="grep -r --exclude-dir=.git  --exclude=*.swp" #common grep excludes when searching a project.
alias clear_dns="sudo killall -HUP mDNSResponder"
alias vi=vim
alias aws_ssh="ssh -i ~/.ssh/JM-MacbookPro.pem" # forcing using aws key when sshing into ec2 machines
alias be="bundle exec" # When running a command and forcing bundled gems

### 
# Python
##
if [ -f ~/.force_phython_virtual_envs ]; then
  . ~/.force_phython_virtual_envs
fi;


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
patch_bump() {
  ver=$(grep version metadata.rb|awk -F"[.']" '{print $4}')
  new_version=$((ver+1))
  sed -e "/version/s/${ver}\(['\"]\)/${new_version}\1/" -i '' metadata.rb
  git diff metadata.rb
}
minor_bump() {
  ver=$(grep version metadata.rb|awk -F"[.']" '{print $3}')
  new_version=$((ver+1))
  sed -e "/version/s/\.${ver}\./\.${new_version}\./" -i ''  metadata.rb
  git diff metadata.rb
}

# open vim in the gem directory
gem_edit() {
  gem=$1
  gem_dir=$(bundle show $gem)
  exit_status=$?
  if [ $exit_status -ne 0 ]; then
    gem_dir=$(dirname $(dirname $(gem which $gem)))
  fi;
  #echo "dir: " $gem_dir
  (cd $gem_dir; vim)
}
show_vms_on_host()
{
 echo "Running vms:"
 ssh $1 "ps aux | grep VBoxHeadless | grep -v grep | grep -o 'comment [^ ]*' | awk '{print \$2}'"
 echo "Defined vms:"
 ssh $1 "find /home/vm -type d  2>/dev/null | grep Logs | awk 'FS=\"/\" { print \$5 }' "
}

# mimic linux service name start|stop|restart
service() {
  service_name=$1
  action=${2:-restart}
  launch_agent_config=$(/bin/ls ~/Library/LaunchAgents/ | grep $service_name)
  if [ $(echo "$launch_agent_config" | wc -l) -gt 1 ]; then
    echo "Found more than 1 configuration, please be more specific"
    return 1
  fi
  echo -n "$action on $launch_agent_config..."
  case $action in
    restart)
        launchctl unload ~/Library/LaunchAgents/$launch_agent_config
        return_code=$?
        if [ $return_code -eq 0 ]; then
          launchctl load ~/Library/LaunchAgents/$launch_agent_config
          return_code=$?
        fi;
        ;;
    stop)
        launchctl unload ~/Library/LaunchAgents/$launch_agent_config
        return_code=$?
        ;;
    start)
        launchctl load ~/Library/LaunchAgents/$launch_agent_config
        return_code=$?
        ;;
  esac
  if [ $return_code -eq 0 ]; then
    echo "OK"
  else
    echo "Failed"
  fi;
}

## quickly create a site to view html content
pow_make_site()
{
  # if no site_name is provided use the current directory (remove /app to assume bower sites)
  site_name=${1:-$(basename ${PWD%%/app})}
  if [ -z "$site_name" ]; then
    echo "Must provide site_name"
    return
  fi
  echo "Creating $site_name"
  tmp_site=/tmp/$site_name
  mkdir -p $tmp_site
  public_dir=${tmp_site}/public
  [ -d $public_dir ] && rm $public_dir
  ln -s $(readlink -f .) $public_dir
  [ -L ~/.pow/$site_name ] || ln -s $tmp_site ~/.pow/$site_name
  echo "site located at http://${site_name}.dev/"
}

##############################################
# Colors
#
##############################################
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

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
else
  echo "Missing bash completion, brew install bash-completion"
fi

#http://git-scm.com/book/en/Git-Basics-Tips-and-Tricks
if ! type __git_heads 2>/dev/null | head -n1 | grep function >/dev/null && ! [[ -f ~/.git-completion.bash && $(. ~/.git-completion.bash) -eq 0 ]]; then
  echo "Missing git completion."
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

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

