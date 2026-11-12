#!/bin/bash

# Get the directory in which this script lives.
script_dir=$(dirname "$(readlink -f "$0")")

sudo chsh "$(id -un)" --shell "/usr/bin/zsh"

create_symlinks() {
    # Get a list of all files and directories in this directory that start
    # with a dot (excluding ".", "..", and ".git").
    files=$(find "$script_dir" -maxdepth 1 -name ".*" ! -name "." ! -name ".." ! -name ".git")

    # Create a symbolic link to each file/directory in the home directory.
    for file in $files; do
        name=$(basename "$file")
        echo "Creating symlink to $name in home directory."
        rm -rf ~/"$name"
        ln -s "$file" ~/"$name"
    done
}

create_symlinks

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-completions.git "${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions"
git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

if ! command -v herdr >/dev/null 2>&1; then
    curl -fsSL https://herdr.dev/install.sh | sh
fi
