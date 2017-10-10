#!/bin/bash

files=( "vimrc" "tmux.conf" "eslintrc.json" "dircolors" "bashrc")
backup_folder=$(pwd)'/backup'

# If script is executed without parameters we only print help info
print_help () {
  echo
  echo This script will install dotfiles into $HOME
  echo Installation will backup your existing dotfiles to $backup_folder
  echo Every time install is run it will begin by trying to uninstall.
  echo This will guarantee the integrity of the original backups.
  echo
  echo '$ ./setup.sh [--install | --uninstall]'
  echo
  echo '--install      Begins by running uninstall and then it makes backups'
  echo '               of all affected files in '$HOME' and stores them in a'
  echo '               separate folder. Then symlinks are created pointing'
  echo '               to corresponding files in this folder'
  echo
  echo '--uninstall    Removes the symlinks and restores the original files'
  echo
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
    vim +PluginInstall +qall
  fi
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

