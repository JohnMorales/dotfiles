# link in all profile files
current_user = ENV["SUDO_USER"]
dotfiles_dir = ENV["PWD"]
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

