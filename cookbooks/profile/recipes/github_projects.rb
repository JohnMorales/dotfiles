current_user = ENV["SUDO_USER"]
development_dir = File.expand_path("~/Development")
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

