#! /bin/bash
set -x

# Refuse to run if EFS_MOUNT_POINT isn't set
: "${EFS_MOUNT_POINT:?EFS_MOUNT_POINT must be set}"

# All of these segments will be symlinked from the home directory to your EFS drive.
for segment in .claude .claude.json .codex .oh-my-zsh .zshenv .zprofile .zsh_history .zshrc; do
  # If you don't want to delete what's currently in the home directory, remove this.
  if [ -e "$HOME/$segment" ]; then
    rm -rf "$HOME/$segment"
  fi
                                                                                                                        # Don't fail if the symlink already exists.
  ln -s "$EFS_MOUNT_POINT/$segment" "$HOME" || true
done
