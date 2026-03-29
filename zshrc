# ~/.dotfiles/zshrc  ────────────────────────────────────────────────

# path to this dotfiles file
export DOTFILES=${${(%):-%x:A}:h}

alias gs='git-spice'

# for ghostty
export TERM=xterm-256color

export GIT_EDITOR=nvim
setopt histignorealldups sharehistory
HISTSIZE=75000
SAVEHIST=75000
HISTFILE=~/.zsh_history

# Fuzzy Ctrl-R history (fzf) – Zsh version
export FZF_CTRL_R_OPTS="--sort --prompt 'History>'"
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [[ -f "$(brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
elif [[ -f ~/.fzf/shell/key-bindings.zsh ]]; then
  source ~/.fzf.zsh
  source ~/.fzf/shell/key-bindings.zsh
else
  echo "🔴 fzf not found"
fi

# Vi command-line editing
# set -o vi                 # enable Vi command-line editing
bindkey -v
export KEYTIMEOUT=3       # faster Esc-to-Normal switch

# make sure the Backspace (DEL) key works in BOTH vi modes
bindkey -M viins '^?' backward-delete-char   # Insert mode
bindkey -M vicmd '^?' backward-delete-char   # (rarely needed, but harmless)

# zsh-autosuggestions (macOS brew / Linux apt / manual clone)
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  # macOS (Homebrew)
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  # Ubuntu/Debian (apt)
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f ~/.zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  # Manual install
  source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh
else
  echo "⚠️  zsh-autosuggestions not found. Please install it (brew, apt, or manual clone)."
fi


# ──────────────────────────────────────────────────────────────────────
# PROMPT CONFIGURATION
# ──────────────────────────────────────────────────────────────────────

# git info in prompt
autoload -Uz vcs_info
precmd() { vcs_info }
# Configure git branch display
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git
# Enable command substitution and parameter expansion in prompts
setopt PROMPT_SUBST
# Define colors
autoload -U colors && colors
# Colorful prompt with git branch info
PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%} %{$fg[blue]%}%~%{$reset_color%}%{$fg[yellow]%}${vcs_info_msg_0_}%{$reset_color%} %{$fg[magenta]%}❯%{$reset_color%} '

# ──────────────────────────────────────────────────────────────────────
# SHORTCUT COMMANDS
# ──────────────────────────────────────────────────────────────────────
git_diff_since_base() {
  git diff "$(git merge-base HEAD origin/main)" "$@"
}
# Show commits since branching from origin/main
git_log_since_base() {
  git log "$(git merge-base HEAD origin/main)"..HEAD "$@"
}
# Show summary (stats) since branching
git_stat_since_base() {
  git diff --stat "$(git merge-base HEAD origin/main)" "$@"
}
# Show just the files changed
git_files_since_base() {
  git diff --name-only "$(git merge-base HEAD origin/main)" "$@"
}

# --- escape timeout in vim needs to be faster ---
set -sg escape-time 10

# ──────────────────────────────────────────────────────────────────────
# HEALTH CHECK
# ──────────────────────────────────────────────────────────────────────
dotfiles_health_check() {
  echo "─────── HEALTH CHECK ───────"
  # Check for command-line tools
  local cmd loc
  for cmd in git tmux fzf uv nvidia-smi nvim vim ; do
    if loc=$(command -v "$cmd" 2>/dev/null); then
      echo "✅ ${cmd}: ${loc}"
    else
      echo "❌ ${cmd}: not found"
    fi
  done
  
  # Check for zsh-autosuggestions script
  local script_path path
  local potential_paths=(
    "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "$HOME/.zsh-autosuggestions/zsh-autosuggestions.zsh"
  )
  for path in "${potential_paths[@]}"; do
    if [[ -f "$path" ]]; then
      script_path=$path
      break
    fi
  done
  
  if [[ -n "$script_path" ]]; then
    echo "✅ zsh-autosuggestions: ${script_path}"
  else
    echo "❌ zsh-autosuggestions: not found"
  fi
}


# ──────────────────────────────────────────────────────────────────────
# PYTHON PROGRAMS
# ──────────────────────────────────────────────────────────────────────
uv_gpustat() {
  uv run --with 'gpustat' gpustat -i
}
uv_make_folder_context() {
  uv run "$DOTFILES/python_scripts/llm_context.py" "$@"
}


# ──────────────────────────────────────────────────────────────────────
# fun commands (nvim), worktrees, tmux, git, claude/codex, etc
# ──────────────────────────────────────────────────────────────────────
sz() {source ~/.zshrc; echo "✅sourced zshrc!"}
vpipe() { nvim -R -c 'setlocal buftype=nofile bufhidden=wipe noswapfile' -; }
vdiff() { nvim -R -c 'setlocal buftype=nofile bufhidden=wipe noswapfile ft=diff nowrap' -; }
wtprune() {
  local paths
  paths=(${(f)"$(git worktree list --porcelain 2>/dev/null \
    | awk '/^worktree /{print $2}' \
    | tail -n +2 \
    | fzf -m --prompt='Select worktrees to remove (TAB to mark, ENTER to confirm)> ')"} )

  (( ${#paths[@]} == 0 )) && return 0

  for wt in "${paths[@]}"; do
    print -r -- "Removing: $wt"
    git worktree remove --force -- "$wt"
  done
}
wtmux() {
  # wtmux [-f] <name> [-- <command>] — create worktree + tmux session
  local usage="Usage: wtmux [-f] <name> [-- <command>]

Create a git worktree + tmux session (two panes) in one command.
  Given wtmux shatz/foo:
    Branch:        shatz/foo
    Tmux session:  wt_shatz_foo
    Directory:     ../wt_shatz_foo (sibling to your current repo)

By default, creates a new branch off origin/main. If the branch
already exists locally, it reuses it.

Options:
  -f            Fetch the branch from remote instead of creating a new one
  -- <command>  Run a command in the top pane after setup
  At most one slash allowed in name."
  local fetch=0
  if [[ "$1" == "-f" ]]; then
    fetch=1
    shift
  fi
  local name=$1
  [[ -n "$name" ]] || { echo "$usage"; return 2 }
  shift
  local topcmd=()
  if [[ "$1" == "--" ]]; then
    shift
    topcmd=("$@")
  fi
  local slashes=${name//[^\/]}
  if (( ${#slashes} > 1 )); then
    echo "Error: name must contain at most one slash"
    return 2
  fi
  local branch=$name
  local flat=${name//\//_}
  local session=wt_${flat}
  local dir=../wt_${flat}

  if (( fetch )); then
    if git fetch origin "$branch" 2>/dev/null; then
      echo "✅ Fetched origin/$branch"
    else
      echo "❌ Branch '$branch' not found on remote"
      return 1
    fi
    git worktree add "$dir" "origin/$branch"
  elif git show-ref --verify --quiet refs/heads/$branch; then
    git worktree add "$dir" "$branch"
  else
    git fetch origin main &>/dev/null || true
    git worktree add -b "$branch" "$dir" origin/main
    git -C "$dir" branch --unset-upstream
  fi

  if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$dir"
    tmux split-window -v -t "$session:0" -c "$dir"
  fi

  # Run command in top pane if specified
  if (( ${#topcmd[@]} )); then
    tmux send-keys -t "$session:0.0" "$(printf '%q ' "${topcmd[@]}")" Enter
  fi

  echo "Attach: tmux attach -t $session"
}
# ──────────────────────────────────────────────────────────────────────
# PORT / LOCAL SERVER COMMANDS
# ──────────────────────────────────────────────────────────────────────
# Show listening TCP ports: `ports` for all, `ports 8080` for a specific one
ports() {
  local lsof_args=(-iTCP -sTCP:LISTEN -nP)
  [[ -n "$1" ]] && lsof_args=(-iTCP:"$1" -sTCP:LISTEN -nP)
  echo "PORT\tPID\tCOMMAND\tURL"
  lsof "${lsof_args[@]}" 2>/dev/null \
    | awk 'NR>1 {
        split($9, a, ":");
        port = a[length(a)];
        addr = substr($9, 1, length($9)-length(port)-1);
        pid = $2;
        cmd = $1;
        key = port SUBSEP pid;
        if (!(key in seen)) {
          seen[key];
          host = (addr == "*" || addr == "") ? "localhost" : addr;
          printf "%s\t%s\t%s\thttp://%s:%s\n", port, pid, cmd, host, port
        }
      }' \
    | sort -n \
    | column -t -s $'\t'
}

# Kill whatever is on a port: killport 8080
killport() {
  [[ -z "$1" ]] && { echo "Usage: killport <port>"; return 1 }
  local pids=(${(f)"$(lsof -ti TCP:"$1" -sTCP:LISTEN 2>/dev/null)"})
  if (( ${#pids[@]} == 0 )); then
    echo "Nothing listening on port $1"
    return 0
  fi
  echo "Killing PIDs: ${pids[*]} (port $1)"
  kill "${pids[@]}"
}

wtmux_rm() {
  # Interactive teardown of worktree + tmux session + branch.
  # Collects from both tmux sessions and worktrees so it works even if
  # one was already manually killed.
  local items=()

  # Collect tmux sessions starting with wt_
  local tmux_items=(${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep '^wt_')"})
  items+=("${tmux_items[@]}")

  # Collect worktree directory basenames starting with wt_ (skip main worktree)
  local wt_items=(${(f)"$(git worktree list --porcelain 2>/dev/null \
    | awk '/^worktree /{sub(/^worktree /, ""); gsub(/.*\//, ""); print}' \
    | tail -n +2 \
    | grep '^wt_')"})
  items+=("${wt_items[@]}")

  # Deduplicate and remove empty strings
  items=(${(u)items:#})

  (( ${#items[@]} == 0 )) && { echo "No wt_ sessions or worktrees found"; return 0 }

  local selected
  selected=(${(f)"$(printf '%s\n' "${items[@]}" \
    | fzf -m --prompt='Select to tear down (TAB to mark, ENTER to confirm)> ')"})

  (( ${#selected[@]} == 0 )) && return 0

  for name in "${selected[@]}"; do
    # Derive branch: wt_shatz_foo -> shatz/foo (first _ back to /)
    local flat=${name#wt_}
    local branch=${flat/_/\/}
    local dir=../${name}

    tmux kill-session -t "=$name" 2>/dev/null && echo "Killed tmux: $name"
    git worktree remove --force "$dir" 2>/dev/null && echo "Removed worktree: $dir"

    # Delete branch only if not checked out elsewhere
    if git show-ref --verify --quiet refs/heads/$branch &&
       ! git worktree list --porcelain | grep -q "^branch refs/heads/$branch$"; then
      git branch -D "$branch" && echo "Deleted branch: $branch"
    fi
  done
}
