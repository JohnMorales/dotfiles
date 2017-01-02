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
  hub
  diffmerge
}
execute "install homebrew versions" do
  command "brew tap homebrew/versions"
  not_if "[ -d /usr/local/Library/Taps/homebrew/homebrew-versions ]"
end

execute "remove bash-completion" do
  command "brew unlink bash-completion"
  only_if "brew info bash-completion | grep -i poured >/dev/null"
end

legacy_packages = %w{
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
          reattach-to-user-namespace
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


