#!/bin/bash

dotfiles=( "vimrc" "tmux.conf" "tmuxline.conf" "eslintrc.json" "dircolors" "bashrc" "gitconfig" )
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

backup_file () {
  local file=$1
  if [ -e $file ]; then
    echo 'Backing up '$file
    mkdir -p backup && cp -P -n $file $_ && rm $file
  fi
}

restore_file () {
  local source=$1
  local target=$2
  if [ -e $source ]; then
    if [ -L $target ]; then
      echo 'Removing symlink '$target
      unlink $target
    fi
    echo 'Restoring backup to '$target
    cp -P -n $source $target && rm $source
  else
    echo 'Could not find any backup for '$target
  fi
}

create_symlink () {
  local target=$1
  local link=$2
  echo 'Creating symlink to '$target
  ln -s $target $link
}

# Performs backup and creates symlinks
install () {
  for file in $@; do
    dotfile=$HOME'/.'$file
    targetfile=$(pwd)'/'$file
    backup_file $dotfile
    create_symlink $targetfile $dotfile
  done

  install_vundle
  install_tpm
}

# Removes symlinks and restores backup
uninstall () {
  for file in $@; do
    dotfile=$HOME'/.'$file
    bakfile=$backup_folder'/.'$file
    restore_file $bakfile $dotfile
  done
}

if [ $1 ]
then
  verify_runtime_path
  if [ $1 = '--install' ]
  then
    uninstall "${dotfiles[@]}"
    install "${dotfiles[@]}"
  elif [ $1 = '--uninstall' ]
  then
    uninstall "${dotfiles[@]}"
  fi
else
  print_help
fi

