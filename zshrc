# ~/.dotfiles/zshrc  ────────────────────────────────────────────────




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

# autosuggestions (for zsh brew macos)
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh
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
