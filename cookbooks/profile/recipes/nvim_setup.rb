current_user = ENV["SUDO_USER"]
dotfiles_dir = File.expand_path("..", __FILE__)
directory File.expand_path("~/.config/nvim") do
  action :create
  owner current_user
  group current_user
end
%w{ swap backup undo }.each do |dir|
  directory File.expand_path("~/.config/nvim/#{dir}") do
    action :create
    owner current_user
    group current_user
  end
end
link File.expand_path("~/.config/nvim/init.vm") do
  to File.join(dotfiles_dir, "nvimrc")
  owner current_user
  group current_user
end
vim_plugin_dir = File.expand_path "~/.config/nvim/autoload/"
execute "clone vim-plug" do # ~FC040
  command "curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && nvim +PluginInstall +qall 2&> /dev/null </dev/null"
  not_if "[ -d #{vim_plugin_dir}/plug.vim ]"
  user current_user
end

