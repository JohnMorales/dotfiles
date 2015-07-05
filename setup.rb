# chef recipe to configure profile
#
current_user = ENV["SUDO_USER"]
dotfiles_dir = File.expand_path("..", __FILE__)
development_dir = File.expand_path("~/Development")
# link in all profile files
%w{
  vimrc
  nvimrc
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
#
# install generic system packages
generic_packages = %w{
  tree
  tig
  tmux
  wget
  pv
  bash-completion
  jq
  cmake
}
platform_specific = {
        'mac' => %w{
          grep
          pstree
          the_silver_searcher
          reattach-to-user-namespace
          coreutils },
        'linux' => %w{
          python
          python-dev
          powerline
    }
}

(generic_packages + platform_specific[node[:os]]).each do |pkg|
  package pkg do
    action :install
  end
end

# configure vim.
directory File.expand_path("~/.vim") do
  action :create
  owner current_user
  group current_user
end
%w{ swap backup undo }.each do |dir|
  directory File.expand_path("~/.vim/#{dir}") do
    action :create
    owner current_user
    group current_user
  end
end
vim_plugin_dir = File.expand_path "~/.vim/bundle"
execute "clone vundle" do
  command "git clone https://github.com/gmarik/Vundle.vim.git #{vim_plugin_dir}/Vundle.vim && vim +PluginInstall +qall 2&> /dev/null"
  not_if "[ -d #{vim_plugin_dir}/Vundle.vim ]"
  user current_user
end

execute "update ycm" do
  command "git pull"
  cwd "#{vim_plugin_dir}/YouCompleteMe"
  user current_user
  group current_user
  only_if "(git remote update && [ $(git rev-parse @) != $(git rev-parse @{u}) ]) || [ $(find . -name 'ycm_core*' -not -name '*.cpp' | wc -l) -eq 0 ]"
end
execute "update ycm submodules" do
  command "git submodule update --init --recursive"
  cwd "#{vim_plugin_dir}/YouCompleteMe"
  user current_user
  group current_user
  action :nothing
  subscribes :run, "execute[update ycm]"
end
execute "compile ycm" do
  command "./install.sh"
  cwd "#{vim_plugin_dir}/YouCompleteMe"
  user current_user
  group current_user
  environment({ "YCM_CORES" => "1" })
  action :nothing
  subscribes :run, "execute[update ycm]"
  subscribes :run, "execute[update ycm submodules]"
end

## Github projects.
{
 'magicmonty/bash-git-prompt' => "~/.bash-git-prompt",
 'JohnMorales/base16-shell' => "#{development_dir}/base-16/shell",
 'seebi/dircolors-solarized' => "#{development_dir}/dircolors-solarized",
 'seebi/tmux-colors-solarized' => "#{development_dir}/tmux-colors-solarized"
}.each do |project, dest|
  execute "clone #{project}" do
    command "git clone https://github.com/#{project}.git #{dest}"
    user current_user
    group current_user
    not_if "[ -d #{dest} ]"
  end
end

## NodeJS/IOJS
execute "install nvm" do
  command "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.1/install.sh | bash"
  user current_user
  group current_user
  not_if "[ -d ~/.nvm ]"
end
execute "install iojs" do
  command ". ~/.nvm/nvm.sh;nvm install iojs;nvm alias default iojs"
  user current_user
  group current_user
end
#
## NodeJS packages
%w{
   bower
   jscs
   jshint
   eslint
   js-yaml
   gulp
}.each do |pkg|
  execute "install #{pkg}" do
    command ". ~/.nvm/nvm.sh; npm install -g #{pkg}"
    user current_user
    group current_user
    not_if ". ~/.nvm/nvm.sh; npm list -g #{pkg}"
  end
end

