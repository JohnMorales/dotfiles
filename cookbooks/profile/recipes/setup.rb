# chef recipe to configure profile
current_user = ENV["SUDO_USER"]
include_recipe "profile::link_dotfiles"

# update homebrew
if node["os"] == "darwin"
  execute "update homebrew" do
    command "brew update"
  end
end
include_recipe "profile::packages"
#
# install generic system packages
directory File.expand_path("~/.ssh/config.d") do
  action :create
  owner current_user
  group current_user
  recursive true
end

# configure vim.
using_vim = false
if using_vim 
  include_recipe "profile::vim_setup"
else
  include_recipe "profile::nvim_setup"
end
include_recipe "profile::github_projects"
include_recipe "profile::powerline"

#  vim: set ts=2 sw=2 tw=0 et ft=chef.ruby :
