#!/bin/bash

files=( "vimrc" "tmux.conf" "eslintrc.json" "dircolors" "bashrc" "gitconfig" )
backup_folder=$(pwd)'/backup'

# If script is executed without parameters we only print help info
print_help () {
  echo "$(<help.txt)"
}

# Print error message and exits if script is executed from wrong path
invalid_path () {
  echo INVALID PATH
  echo You must run the script from the root directory of the repository, ie.
  echo ~$ cd '~/dotfiles'
  echo '~/dotfiles$' ./setup.sh
  exit 1
}

# Validates the path from which the script is executed
verify_runtime_path () {
  local valid_path='./'${0##*/}
  local actual_path=$0
  if [ $actual_path != $valid_path ]
  then
    invalid_path
  fi
}

install_vundle () {
  local dir=$HOME/.vim/bundle/Vundle.vim
  if [ ! -d "$dir" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git $dir
  fi
  vim +PluginInstall +qall
}

install_tpm () {
  local dir=$HOME/.tmux/plugins/tpm
  if [ ! -d "$dir" ]; then
    echo install tpm
    git clone https://github.com/tmux-plugins/tpm $dir
  fi
  ~/.tmux/plugins/tpm/bin/install_plugins
}

# Performs backup and creates symlinks
install () {
  for file in $@; do
    dotfile=$HOME'/.'$file
    targetfile=$(pwd)'/'$file
    if [ -e $dotfile ]
    then
      echo 'Backing up '$dotfile
      mkdir -p backup && cp -P -n $dotfile $_ && rm $dotfile
    fi
    echo 'Creating symlink to '$targetfile
    ln -s $targetfile $dotfile
  done

  install_vundle
  install_tpm
}

# Removes symlinks and restores backup
uninstall () {
  for file in $@; do
    dotfile=$HOME'/.'$file
    bakfile=$backup_folder'/.'$file
    if [ -e $bakfile ]
    then
      if [ -L $dotfile ]
      then
        echo 'Removing symlink '$dotfile
        unlink $dotfile
      fi
      echo 'Restoring backup to '$dotfile
      cp -P -n $bakfile $dotfile && rm $bakfile
    else
      echo 'Could not find any backup for '$dotfile
    fi
  done
}

if [ $1 ]
then
  verify_runtime_path
  if [ $1 = '--install' ]
  then
    uninstall "${files[@]}"
    install "${files[@]}"
  elif [ $1 = '--uninstall' ]
  then
    uninstall "${files[@]}"
  fi
else
  print_help
fi

