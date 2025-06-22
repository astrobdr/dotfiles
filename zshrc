# ~/.dotfiles/zshrc  ────────────────────────────────────────────────
# Fuzzy Ctrl-R history (fzf) – Zsh version

if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [[ -f "$(brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi

export FZF_CTRL_R_OPTS='--tac --no-sort --exact --preview "echo {}" --preview-window=down:3'

# Vi command-line editing
set -o vi                 # enable Vi command-line editing
export KEYTIMEOUT=1       # faster Esc-to-Normal switch
