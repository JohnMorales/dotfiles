current_user = ENV["SUDO_USER"]
dotfiles_dir = ENV["PWD"]
package "vim" do
  action :remove
end
execute "tap neovim" do
  command "brew tap neovim/neovim"
end
package "neovim" do
  action :install
end
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

file File.expand_path("~/.nvimrc") do
  action :delete
end

link File.expand_path("~/.config/nvim/init.vim") do
  to File.join(dotfiles_dir, "nvimrc")
  owner current_user
  group current_user
end

vim_plugin_dir = File.expand_path "~/.config/nvim/autoload/"

execute "clone vim-plug" do # ~FC040
  command "curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && nvim +PlugInstall +UpdateRemotePlugins +qall </dev/null"
  not_if "[ -f #{vim_plugin_dir}/plug.vim ]"
  timeout 60
  user current_user
end

