current_user = ENV["SUDO_USER"]
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
execute "clone vundle" do # ~FC040
  command "git clone https://github.com/VundleVim/Vundle.vim #{vim_plugin_dir}/Vundle.vim && vim +PluginInstall +qall 2&> /dev/null </dev/null"
  not_if "[ -d #{vim_plugin_dir}/Vundle.vim ]"
  user current_user
end

git "YouCompleteMe" do
  repository "https://github.com/Valloric/YouCompleteMe.git"
  destination "#{vim_plugin_dir}/YouCompleteMe"
  user current_user
  group current_user
  enable_submodules true
  notifies :run, "execute[compile ycm]", :immediately
end
execute "compile ycm" do
  command "./install.sh"
  cwd "#{vim_plugin_dir}/YouCompleteMe"
  user current_user
  group current_user
  environment({ "YCM_CORES" => "1" })
  action :nothing
end


