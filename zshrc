# ~/.dotfiles/zshrc  ────────────────────────────────────────────────
# Fuzzy Ctrl-R history (fzf) – Zsh version

if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [[ -f "$(brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi

export FZF_CTRL_R_OPTS='--tac --no-sort --exact --preview "echo {}" --preview-window=down:3'

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