# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Git tab completion
if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
fi

# Git prompt
GIT_PS1=''
if [ -f ~/.git-contrib/git-prompt.sh ]; then
    source ~/.git-contrib/git-prompt.sh
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM="auto verbose"
    # GIT_PS1='$(__git_ps1 " (%s)")'
    GIT_PS1='$(__git_ps1 " (%s)" \
        | sed -E "s/\|u=//" \
        | sed -E "s/\|u\+([0-9]+)-([0-9]+)/ ↑\1↓\2/" \
        | sed -E "s/\|u\+([0-9]+)/ ↑\1/" \
        | sed -E "s/\|u-([0-9]+)/ ↓\1/")'
fi

# Show Node version only if nvm is active
node_prompt() {
  if command -v node &>/dev/null; then
    local node_path
    node_path=$(command -v node)
    if [[ "$node_path" == "$HOME/.nvm/"* ]]; then
      local version
      version=$(node -v 2>/dev/null)
      echo " [$version]"
    fi
  fi
}



# Color prompt logic — single block!
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(node_prompt)'"$GIT_PS1"'\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(node_prompt)'"$GIT_PS1"'\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Start tmux automatically if not already in one
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux new-session -A -s default
fi

# Environment variables for SSL and NVM
export SSL_CERT_DIR=/home/linus/.aspnet/dev-certs/trust/usr/lib/ssl/certs

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load Angular CLI autocompletion.
if command -v ng &> /dev/null; then
    # echo "ng is available, setting up autocompletion"
    source <(ng completion script)
fi  









# Function to find the nearest .nvmrc in parent directories
find_up_nvmrc() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/.nvmrc" ]; then
      echo "$dir/.nvmrc"
      return
    fi
    dir=$(dirname "$dir")
  done
}

# Track the last directory that had an active .nvmrc
export ACTIVE_NVMRC=""

load_nvm_if_needed() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

maybe_use_nvmrc() {
  local nvmrc_path=$(find_up_nvmrc)

  if [ -n "$nvmrc_path" ]; then
    if [ "$nvmrc_path" != "$ACTIVE_NVMRC" ]; then
      load_nvm_if_needed
      local desired_version=$(< "$nvmrc_path")
      # echo "Using Node version $desired_version from $(dirname "$nvmrc_path")"
      nvm use "$desired_version" > /dev/null
      export ACTIVE_NVMRC="$nvmrc_path"
    fi
  else
    if [ -n "$ACTIVE_NVMRC" ]; then
      # Leaving a project: deactivate nvm and remove from PATH
      # echo "Leaving .nvmrc project — reverting to system Node"
      nvm deactivate > /dev/null

      # Remove nvm from PATH completely to reveal system node
      export PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "$HOME/.nvm" | paste -sd ':' -)
      unset NVM_DIR
      unset ACTIVE_NVMRC
    fi
  fi
  if command -v ng &> /dev/null; then
    # echo "ng is available, setting up autocompletion"
    source <(ng completion script)
  fi  
}

# Override cd to trigger version switching logic
cd() {
  builtin cd "$@" && maybe_use_nvmrc
}

# Run once on shell startup
maybe_use_nvmrc
