# ~/.dotfiles/zshrc  ────────────────────────────────────────────────

setopt histignorealldups sharehistory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Fuzzy Ctrl-R history (fzf) – Zsh version
export FZF_CTRL_R_OPTS="--sort --prompt 'History>'"
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [[ -f "$(brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi

# Vi command-line editing
# set -o vi                 # enable Vi command-line editing
bindkey -v
export KEYTIMEOUT=1       # faster Esc-to-Normal switch

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
  for cmd in git tmux fzf uv nvidia-smi; do
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
