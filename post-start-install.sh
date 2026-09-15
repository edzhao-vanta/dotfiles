#! /bin/bash
set -x

# Refuse to run if EFS_MOUNT_POINT isn't set
: "${EFS_MOUNT_POINT:?EFS_MOUNT_POINT must be set}"

# All of these segments will be symlinked from the home directory to your EFS drive.
for segment in .claude .claude.json .codex .oh-my-zsh .zsh_history; do
  efs_path="$EFS_MOUNT_POINT/$segment"
  home_path="$HOME/$segment"

  if [ -e "$efs_path" ]; then
    # EFS already has this segment — normal case: relink local to point at it.
    if [ -e "$home_path" ] || [ -L "$home_path" ]; then
      rm -rf "$home_path"
    fi
    ln -s "$efs_path" "$home_path" || true

  elif [ -e "$home_path" ] && [ ! -L "$home_path" ]; then
    # EFS is missing it, but we have a real local copy — seed EFS from it.
    echo "NOTICE: $efs_path missing, restoring from local copy at $home_path"
    if cp -a "$home_path" "$efs_path"; then
      rm -rf "$home_path"
      ln -s "$efs_path" "$home_path" || true
    else
      echo "ERROR: failed to copy $home_path to $efs_path — leaving local copy untouched, not linking"
    fi

  else
    # EFS is missing it, and there's no usable local copy to restore from
    # (either nothing exists locally, or it's just a dangling symlink).
    echo "WARNING: $efs_path missing and no local copy to restore from at $home_path — skipping"
  fi
done

