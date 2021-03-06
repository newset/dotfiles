register-plugins() {
  zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh"
  zplug "plugins/safe-paste", from:oh-my-zsh
  zplug "plugins/extract", from:oh-my-zsh
  zplug "plugins/colored-man-pages", from:oh-my-zsh
  zplug "zsh-users/zsh-syntax-highlighting"
  zplug "zsh-users/zaw"
  zplug "zsh-users/zsh-completions"
}

if [[ ! $TERM =~ screen && -z $TMUX ]]; then
  MODULES=(
    "tpm:tmux-plugins/tpm"
    "zplug:zplug/zplug"
  )

  for module in $MODULES; do
    ddir="$HOME/.modules/$(printf "$module" | cut -d ':' -f 1)"
    ppath="$(printf "$module" | cut -d ':' -f 2)"

    if [[ ! -d $ddir ]]; then
      (mkdir -p "$ddir" &&
        git clone --depth 1 https://github.com/$ppath.git "$ddir" && printf '.')
    fi
  done

  source ~/.modules/zplug/init.zsh

  register-plugins

  zplug check || zplug install

  if command -v tmux>/dev/null; then
    exec tmux
  fi
fi

source ~/.modules/zplug/init.zsh
register-plugins
zplug load

RPROMPT="%f%k%(?.. %F{red}✘ %?) %f%k"
PROMPT="$FG[022]$BG[148] ⌂ $FG[255]$BG[236] %1~ %k%f "
export GO15VENDOREXPERIMENT=1

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

compinit

# Editor
if command -v nvim > /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi


# Less
export LESSSECURE=1

fpath=(~/.antigen/repos/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-completions.git/src $fpath)

bindkey '^R' zaw-history
bindkey '^O' zaw-git-files-legacy

autoload -U zmv

# Readline
export WORDCHARS='*?[]~&;!$%^<>'
export LANG="en_US.UTF-8"

export NVM_DIR="$HOME/.nvm"

for i in ~/.zsh/*.sh; do source $i; done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="./bin:$PATH"

if command -v gpg-agent > /dev/null; then
  if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
  else
    eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
  fi
fi

# The next line updates PATH for the Google Cloud SDK.
source '/Users/sheerun/Source/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/sheerun/Source/google-cloud-sdk/completion.zsh.inc'

export PATH="$PATH:./node_modules/.bin" # Add RVM to PATH for scripting
export PATH="$HOME/.rbenv/bin:$PATH"
