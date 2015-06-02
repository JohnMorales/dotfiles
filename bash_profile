[[ -r ~/.bashrc ]] && . ~/.bashrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/google-cloud-sdk/path.bash.inc ]; then
  . '/Users/johnmorales/google-cloud-sdk/path.bash.inc'
fi

# The next line enables bash completion for gcloud.
if [ -f ~/google-cloud-sdk/completion.bash.inc ]; then
  . '/Users/johnmorales/google-cloud-sdk/completion.bash.inc'
fi
