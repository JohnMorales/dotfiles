##############################################
# TERMINAL
#
##############################################
export TERM=xterm-256color
##############################################
# Vim
#
##############################################
set -o vi
export EDITOR=vim

####
# tmux history
# make sure history shows up in all tmux windows
####
export HISTSIZE=9000
export HISTCONTROL=ignoredups:erasedups #don't write duplicate entries.
shopt -s histappend # append to the history file, instead of the default which is to overwrite
# don't write history on every command
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" # add and reload the history file.
[ -d ~/.history ] || mkdir ~/.history
export HISTFILE=~/.history/$(date +'%Y-%m-%d').log

##############################################
# Path
#
##############################################
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:./bin:~/bin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
##############################################
# Android SDK
#
##############################################
export PATH="$PATH:~/Library/Android/sdk/platform-tools"


##############################################
# GO
#
##############################################

#Note that this must not be the same path as your Go installation.
export GOPATH=~/Development/go
export PATH=$PATH:$GOPATH/bin
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
alias lls='ls -lph --color'
alias ls='ls --color'
alias t2='tree -Fth -L 2 --du |less' #see tree with size up to 2 levels deep
alias rgrep="grep -r --exclude-dir=.git  --exclude=*.swp" #common grep excludes when searching a project.
alias cgrep="grep --color=always"
alias clear_dns="sudo killall -HUP mDNSResponder"
alias vi=vim
alias ssh='cat ~/.ssh/config.d/* >~/.ssh/config; ssh' # this 'trick' cobbles my ssh_config together, prior to being ssh being called.
alias be="bundle exec" # When running a command and forcing bundled gems
alias whatismyip="curl -s https://domains.google.com/checkip;echo"
alias tigbm="tig HEAD ^master --first-parent" # show only the commits until master, without commits in merges
alias tigb="tig HEAD ^master --first-parent --no-merges" # show only the commits until master, without merges
if [ -f ~/.aliases ]; then
  . ~/.aliases
fi


if [ -f ~/.smb_creds ]; then
  alias smbclient="smbclient -A ~/.smb_creds"
fi

###
# Python
##
if [ -f ~/.force_phython_virtual_envs ]; then
   . ~/.force_phython_virtual_envs
fi


##############################################
# Functions
#
##############################################
grep_history() {
  local term="$@"
  grep $term -r ~/.history/ | tail
}
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
recompile_ycm() {
  (cd ~/.vim/bundle/YouCompleteMe; ./install.sh)
}
tmux_light() {
  tmux source-file ~/Development/tmux-colors-solarized/tmuxcolors-light.conf
}
tmux_dark() {
  tmux source-file ~/Development/tmux-colors-solarized/tmuxcolors-dark.conf
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
semver_bump() {
  local file=$1
  local bumper=$2
  local awk_script=$(cat <<'SCRIPT'
{
    v=$2
    gsub("'", "", v);
    split(v, p, ".");
    major=p[1];
    minor=p[2];
    patch=p[3];
    print major "." minor "." patch
    bumper;
    print major "." minor "." patch
}
SCRIPT
)

  local versions=$(awk -f <(echo "${awk_script/bumper/$bumper}") <(grep version $file))
  local cur_ver=$(echo "$versions" | head -n1 )
  local new_version=$(echo "$versions" | tail -n1)
  sed -e "/version/s/${cur_ver}/${new_version}/" -i '' $file
  git diff $file
}
patch_bump() {
  semver_bump metadata.rb "patch++"
}
minor_bump() {
  semver_bump metadata.rb "minor++;patch=0;"
}
major_bump() {
  semver_bump metadata.rb "major++;minor=0;patch=0;"
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
 if [ -n "$1" ]; then
    ssh $1 "ps aux | grep VBoxHeadless | grep -v grep | grep -o 'comment [^ ]*' | awk '{print \$2}'"
    echo "Defined vms:"
    ssh $1 "find /home/vm -type d  2>/dev/null | grep Logs | awk 'FS=\"/\" { print \$5 }' "
  else
    if [ -f ~/.vm_host_domain ]; then
        local host_domain=$(cat ~/.vm_host_domain)
        for i in gum mint beast fudge candy; do
          echo "$i.$host_domain"
          echo "-------------------------"
          show_vms_on_host ${i}.$host_domain
        done
      fi
  fi
}

true_color()
{
 printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
}

# mimic linux service name start|stop|restart
service() {
  local service_name=$1
  local action=${2:-restart}
  local launch_agent_config="$(find ~/Library/LaunchAgents /System/Library/LaunchAgents/ /System/Library/LaunchDaemons/ -iregex ".*$service_name.*")"
  if [ $(echo "$launch_agent_config" | wc -l) -gt 1 ]; then
    printf "Found more than 1 configuration, please be more specific:\n$launch_agent_config\n"
    return 1
  fi
  if [ -z $launch_agent_config ]; then
    echo "No service found for $service_name"
    return 1;
  fi
  echo -n "$action on $launch_agent_config..."
  case $action in
    restart)
        launchctl unload "$launch_agent_config"
        return_code=$?
        if [ $return_code -eq 0 ]; then
          launchctl load "$launch_agent_config"
          return_code=$?
        fi;
        ;;
    stop)
        launchctl unload "$launch_agent_config"
        return_code=$?
        ;;
    start)
        launchctl load "$launch_agent_config"
        return_code=$?
        ;;
  esac
  if [ $return_code -eq 0 ]; then
    echo "OK"
  else
    echo "Failed"
  fi;
}

show_cookbook_git_status() {
  for i in ~/Development/chef/cookbooks/*; do
  [ -d $i ] && (cd $i; if [ -d .git ] && [ "$(git status -s 2>/dev/null| wc -l )" -ne 0 ]; then
    echo i;
    git status -s ;
    fi
    ) 
  done;
}
# Get the version of the cookbook on the chef server
chef_compare_server_version() {
  local cookbook=$(basename $(pwd))
  server_version=$(knife cookbook list | grep $cookbook | awk '{ print $2 }')
  local_version=$(grep version metadata.rb | awk '{ print $2 }')
  echo "local version $local_version, server version $server_version"
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
  if [ -f config.ru ]; then
    local site=$(readlink -f .)
  else
    local site=~/sites/$site_name
  fi
  read -n1 -p "Create site at $site? " response
  echo ""
  if [ "$response" == "y" ]; then
    echo "Creating $site_name"
    mkdir -p $site
    local public_dir=${site}/public
    [ -d $public_dir ] && rm $public_dir
    ln -s $(readlink -f .) $public_dir
    [ -L ~/.pow/$site_name ] || ln -s $site ~/.pow/$site_name
    echo "site located at http://${site_name}.dev/"
  else
   echo "Not creating site."
  fi


}

pow_show_sites()
{
 for i in `/bin/ls ~/.pow`;
    do printf "%-50s" http://${i}.dev/;
    dir=~/.pow/$i/
    if [ -d $dir/public ]; then
      dir=$dir/public
    fi;
    readlink -f $dir;
  done
}

pow_make_index()
{
  for p in `/bin/ls`; do printf '<a href="%s">%s</a></br>' $p $p >> index.html; done
}

pow_rm_site()
{
  local site_name=${1:-$(basename ${PWD%%/app})}
  if [ -z "$site_name" ]; then
    echo "Must provide site_name"
    return
  fi
  local site=~/sites/$site_name
  echo "Checking if we can remove ${site}"
  local public_dir=${site}/public
  [ -L ~/.pow/$site_name ] && rm ~/.pow/$site_name
  [ -d $site ] && rm -r $site
}

show_yaml_key() {
 local key_name=$1
 local file_name=$2
 sed -n "/^$key_name:/, /^[[:alpha:]]/ p" $file_name | head -n -1
}

update_profile() {
  if [ "$TMUX" ] && [ "$(tmux showenv ITERM_PROFILE)" ]; then
    eval $(tmux showenv ITERM_PROFILE)
  fi
}
# Ideally, this would not be needed if you open a proper iterm session,
# i.e. use command-o instead of command-i (command-i will use the same profile value as the original profile, even though you've switched)
# unfornuately the update-environment setting in tmux is for new sessions not attaching to existing sessions.
# Currently I have to manually call this every time I switch to a new profile
set_tmux_profile() {
  if [ "$TMUX" ]; then
    tmux setenv -g ITERM_PROFILE $ITERM_PROFILE
  fi
}
show_tmux_panes() {
  for session in $(tmux list-sessions -F '#{session_name}'); do
    tmux list-windows -t "$session" -F '#{window_index} "#{window_name}"' | while read win_index window; do
      tmux list-panes -t "$session:$win_index" -F"#{pane_index} #{pane_tty} #{pane_pid}" | while read pane tty pid; do
        printf "%-30s %30s\n" "Pane Addr: $session:$win_index:$pane (Window $window, Pane: $pane)" $tty
        pstree $pid
        printf "\n\n"
      done
    done
  done

}
show_function_keys() {
  printf "%-5s%5s\n" "key" "value"; infocmp -1  | awk -F= '/kf/ { key=$1; sub("kf", "", key); printf("%-5d %s\n", key, $2) }'  | sort -n
}

unset_aws() {
  eval $(set | grep ^RDS | awk -F'=' '{ printf("unset %s\n", $1); }')
}

## Samba functions
[ -f ~/.smb_mount.sh ] && . ~/.smb_mount.sh


##############################################
# Colors
#
##############################################
export CLICOLOR=1 #Enable colors on a mac
if [ -d ~/.dircolors ]; then
  eval $(dircolors ~/.dircolors/dircolors.ansi-dark)
fi
if [ -n "$PS1" ]; then
  if ! [ -f ~/Development/base-16/shell/profile_helper.sh ]; then
    echo "Missing profile_helper.sh"
  else
    eval "$(~/Development/base-16/shell/profile_helper.sh)"
  fi
fi

##############################################
# Externals
#
##############################################

if which brew &>/dev/null &&[ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  #echo "bashcompletions2 installed"
  . $(brew --prefix)/share/bash-completion/bash_completion
elif which brew &>/dev/null && [ -f $(brew --prefix)/etc/bash_completion ]; then
  echo "Using slow bash-completion v1, switch to bash-completion 2"
  . $(brew --prefix)/etc/bash_completion
elif [ -z "$BASH_COMPLETION" ] && [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif [ -z "$BASH_COMPLETION" ]; then
  echo "Missing bash completion, brew install bash-completion or /etc/bash_completion"
fi

#http://git-scm.com/book/en/Git-Basics-Tips-and-Tricks
[ -f ~/.git-completion.bash ] || curl -L -s https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash  > ~/.git-completion.bash
if ! type __git_heads 2>/dev/null | head -n1 | grep function >/dev/null && ! [[ -f ~/.git-completion.bash && $(. ~/.git-completion.bash) -eq 0 ]]; then
  echo "Missing git completion."
fi


# git + hub == github (https://github.com/github/hub)
eval "$(hub alias -s)"


update_docker_host_addr() {
 local docker_host=$(ping -c1 docker.local | awk '{ getline; sub(/:/,"", $4); print $4;exit }')
 sed -i'' -e "s/DOCKER_HOST_ADDR=.*/DOCKER_HOST_ADDR=$docker_host/" ~/.dockerrc
}
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
# removing the newline.
#GIT_PROMPT_END_USER=" ${White}${Time12a}${ResetColor}$ "
if [[ "$HOSTNAME" =~ home\.moralesva\.com$ ]]; then
  GIT_PROMPT_END=" \n\u@${White}\h${ResetColor}:\$ "
else
  GIT_PROMPT_END=" \n\u@${White}\H${ResetColor}:\$ "
fi

[ -f ~/.bash-git-prompt/gitprompt.sh ] && . ~/.bash-git-prompt/gitprompt.sh || echo "Missing git prompt, please run makesetup"

# airline prompt
[ -f ~/.shell_prompt.sh ] && . ~/.shell_prompt.sh

##############################################
# AWS settings
#
##############################################
export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.5.2/libexec"
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.6.13.0/libexec"
complete -C aws_completer aws

if [ -f ~/.aws_scripts ]; then
  . ~/.aws_scripts
  aws_set_profile
fi

##############################################
# JAVA settings
#
##############################################
if [ -f /usr/libexec/java_home ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi;

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### nvm
NVM_DIR=${NVM_DIR:=~/.nvm}
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


## Add binstubs
export PATH=./bin:$PATH

# ARM (Vex) development
export PATH=$PATH:~/vex/yagarto/yagarto-4.7.2/bin:~/vex/yagarto/yagarto-4.7.2/tools
