# go to https://www.nerdfonts.com/font-downloads and copy the url of the download
font_url=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
wget -P ~/.local/share/fonts $font_url \
&& cd ~/.local/share/fonts \
&& unzip *.zip \
&& rm *.zip \
&& fc-cache -fv
