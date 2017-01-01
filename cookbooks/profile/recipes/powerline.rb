current_user = ENV["SUDO_USER"]
development_dir = File.expand_path("~/Development")
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


