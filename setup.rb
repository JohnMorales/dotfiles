# chef recipe to configure profile
#
current_user = ENV["SUDO_USER"]
dotfiles_dir = File.expand_path("..", __FILE__)
development_dir = File.expand_path("~/Development")
# link in all profile files
%w{
  vimrc
  bashrc
  gemrc
  gitconfig
  gitignore
  tmux.conf
  bash_profile
  tigrc
  my.cnf
  pryrc
  editrc
  inputrc
  rspec
  jshintrc
  smb_mount.sh
}.each do |file|
  link File.expand_path("~/.#{file}") do
    to File.join(dotfiles_dir, file)
    owner current_user
    group current_user
  end
end
link File.expand_path("~/.config/nvim/init.vm") do
  to File.join(dotfiles_dir, "nvimrc")
  owner current_user
  group current_user
end
# update homebrew
execute "update homebrew" do
  command "brew update"
end
#
# install generic system packages
generic_packages = %w{
  chromedriver
  tree
  tig
  tmux
  wget
  pv
  bash-completion
  jq
  cmake
}
execute "install homebrew versions" do
  command "brew tap homebrew/versions"
  not_if "[ -d /usr/local/Library/Taps/homebrew/homebrew-versions]"
end

execute "remove bash-completion" do
  command "brew unlink bash-completion"
  only_if "brew info bash-completion | grep -i poured >/dev/null"
end

legacy_packages = %w{
          reattach-to-user-namespace
}
legacy_packages.each do |pkg|
  execute "remove #{pkg}" do
    command "brew uninstall #{pkg}"
    not_if "brew info #{pkg}|grep 'Not installed'>/dev/null"
  end
end

mac_tools = %w{
          homebrew/dupes/grep
          pstree
          the_silver_searcher
          awsebcli
          awscli
          bash-completion2
          coreutils }
platform_specific = {
        'mac' => mac_tools,
	'darwin' => mac_tools,
        'linux' => %w{
          python
          python-dev
          powerline
    }
}

(generic_packages + platform_specific[node['os']]).each do |pkg|
  package pkg do
    action :install
  end
end

directory File.expand_path("~/.ssh/config.d") do
  action :create
  owner current_user
  group current_user
  recursive true
end

# configure vim.
using_vim = false
if using_vim 
  require "./vim_setup.rb"
else
  require "./nvim_setup.rb"
end
## Github projects.
{
 'magicmonty/bash-git-prompt' => File.expand_path("~/.bash-git-prompt"),
 'JohnMorales/base16-shell' => "#{development_dir}/base-16/shell",
 'seebi/dircolors-solarized' => "#{development_dir}/dircolors-solarized",
 'seebi/tmux-colors-solarized' => "#{development_dir}/tmux-colors-solarized",
}.each do |project, dest|
  parent_directory = File.dirname(dest)
  directory parent_directory do
    action :create
    recursive true
    not_if "[ -d #{parent_directory} ]"
  end
  git dest do
    repository "https://github.com/#{project}.git"
    user current_user
    group current_user
    not_if "[ -d #{dest} ]"
  end
end
execute "install_powerline" do
  command "./install.sh"
  cwd "#{development_dir}/powerline-fonts"
  user current_user
  group current_user
  action :nothing
end
git "#{development_dir}/powerline-fonts" do
  repository "https://github.com/powerline/fonts.git"
  user current_user
  group current_user
  not_if "[ -d #{development_dir}/powerline-fonts ]"
  notifies :run, "execute[install_powerline]", :immediately
end

## NodeJS/IOJS
# execute "install nvm" do
#   command "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.1/install.sh | bash"
#   user current_user
#   group current_user
#   not_if "[ -d ~/.nvm ]"
# end
# execute "install iojs" do
#   command ". ~/.nvm/nvm.sh;nvm install iojs;nvm alias default iojs"
#   user current_user
#   group current_user
# end
# #
# ## NodeJS packages
# %w{
#    bower
#    jscs
#    jshint
#    eslint
#    js-yaml
#    gulp
# }.each do |pkg|
#   execute "install #{pkg}" do
#     command ". ~/.nvm/nvm.sh; npm install -g #{pkg}"
#     user current_user
#     group current_user
#     not_if ". ~/.nvm/nvm.sh; npm list -g #{pkg}"
#   end
# end
#
#  vim: set ts=2 sw=2 tw=0 et ft=chef.ruby :
