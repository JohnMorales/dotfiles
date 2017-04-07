[[ -r ~/.bashrc ]] && . ~/.bashrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/google-cloud-sdk/path.bash.inc ]; then
  . ~/google-cloud-sdk/path.bash.inc
fi

# The next line enables bash completion for gcloud.
if [ -f ~/google-cloud-sdk/completion.bash.inc ]; then
  . ~/google-cloud-sdk/completion.bash.inc
fi

# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH
