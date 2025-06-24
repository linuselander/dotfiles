# ~/.bashrc: executed by bash(1) for non-login shells.

case $- in *i*) ;; *) return ;; esac

# History and shell behavior
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Detect chroot
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(< /etc/debian_chroot)
fi

# Colored `ls` and related aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" \
  "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\''")"'

# Load additional aliases
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Start tmux if interactive terminal and not already in one
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -n "$PS1" ] && [[ $TERM != dumb ]]; then
  tmux new-session -A -s default
fi

# Environment variables
export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust/usr/lib/ssl/certs"

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Angular completion (cached)
if command -v ng &> /dev/null; then
  [[ ! -f ~/.cache/ng-completion.sh ]] && mkdir -p ~/.cache && ng completion script > ~/.cache/ng-completion.sh
  source ~/.cache/ng-completion.sh
fi

# Auto-use .nvmrc on cd
find_up_nvmrc() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    [ -f "$dir/.nvmrc" ] && echo "$dir/.nvmrc" && return
    dir=$(dirname "$dir")
  done
}

export ACTIVE_NVMRC=""
maybe_use_nvmrc() {
  local nvmrc_path desired_version
  nvmrc_path=$(find_up_nvmrc)
  if [ -n "$nvmrc_path" ]; then
    if [ "$nvmrc_path" != "$ACTIVE_NVMRC" ]; then
      desired_version=$(< "$nvmrc_path")
      nvm use "$desired_version" &>/dev/null
      export ACTIVE_NVMRC="$nvmrc_path"
      export USING_DEFAULT_NVMRC=0
    fi
  elif [ "$ACTIVE_NVMRC" != "default" ]; then
    nvm use default &>/dev/null
    export ACTIVE_NVMRC="default"
    export USING_DEFAULT_NVMRC=1
  fi
}

PROMPT_COMMAND="maybe_use_nvmrc; $PROMPT_COMMAND"

# Enable starship prompt
eval "$(starship init bash)"
