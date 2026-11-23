export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="devcontainers"
plugins=(git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)
# zsh-completions isn't an oh-my-zsh plugin; it only needs to be on fpath before oh-my-zsh runs compinit.
fpath+=$ZSH/custom/plugins/zsh-completions/src
zstyle ':omz:update' mode disabled
source $ZSH/oh-my-zsh.sh

[ -f /etc/profile.d/ona-secrets.sh ] && . /etc/profile.d/ona-secrets.sh

# Rex terminals start in $HOME, unlike Ona's SSH sessions, which start in the repo.
if [[ -n $REX_SESSION && $PWD == $HOME ]]; then
  cd /workspaces/obsidian
fi

# Remove every linked worktree and every local branch except main, after one confirmation.
clean-worktrees() {
  # Git won't check out main in two worktrees, so this also ensures we're in the main worktree.
  if [[ "$(git branch --show-current 2>/dev/null)" != "main" ]]; then
    echo "Error: You must be on the 'main' branch to run this." >&2
    return 1
  fi

  local -a worktrees branches
  worktrees=(${(f)"$(git worktree list --porcelain | awk '/^worktree / {print substr($0, 10)}' | tail -n +2)"})
  branches=(${(f)"$(git for-each-ref --format='%(refname:short)' refs/heads | grep -vx main)"})

  if (( ${#worktrees} == 0 && ${#branches} == 0 )); then
    echo "Already clean: no linked worktrees and no branches besides main."
    return 0
  fi

  local worktree branch status_note unpushed_count
  echo "Worktrees to remove:"
  for worktree in $worktrees; do
    if [[ ! -d $worktree ]]; then
      status_note="[directory missing]"
    elif [[ -n "$(git -C "$worktree" status --porcelain 2>/dev/null)" ]]; then
      status_note="[uncommitted changes]"
    else
      status_note=""
    fi
    echo "  $worktree  ($(git -C "$worktree" branch --show-current 2>/dev/null))  $status_note"
  done
  (( ${#worktrees} == 0 )) && echo "  (none)"

  echo "Branches to delete:"
  for branch in $branches; do
    unpushed_count=$(git rev-list --count "refs/heads/$branch" --not --remotes)
    if (( unpushed_count > 0 )); then
      echo "  $branch  [$unpushed_count commits not on any remote]"
    else
      echo "  $branch"
    fi
  done
  (( ${#branches} == 0 )) && echo "  (none)"

  if ! read -q "?Proceed? [y/N] "; then
    echo "\nCancelled."
    return 1
  fi
  echo

  for worktree in $worktrees; do
    # Double --force also removes locked worktrees.
    git worktree remove --force --force "$worktree"
  done
  git worktree prune

  for branch in $branches; do
    git branch -D "$branch"
  done

  git worktree list
}
