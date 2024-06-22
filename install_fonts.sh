# go to https://www.nerdfonts.com/font-downloads and copy the url of the download
font_url=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.zip
zip_file=$(basename $font_url)
wget -P ~/.local/share/fonts $font_url \
&& cd ~/.local/share/fonts \
&& unzip $zip_file \
&& rm $zip_file \
&& fc-cache -fv
