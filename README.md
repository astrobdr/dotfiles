# dotfiles
this is a really simple dotfiles setup for zsh, tmux, and fzf. It just has a few features that make terminal a happy place for me.

1. `ctrl-r` history search
2. tmux mouse mode enabled
3. tmux pane navigation with `ctrl-hjkl` or `alt-hjkl`
4. tmux copy mode with `v` and `y`
5. zsh autosuggestions

thats more or less it. follow the instructions below to install and setup.

# macOS
```
brew install fzf tmux
brew install zsh-autosuggestions
```

# linux
```
sudo apt-get install fzf tmux
sudo apt-get install zsh-autosuggestions
```

# setup
Just source the files from `~/.zshrc` and `~/.tmux.conf`

in `~/.zshrc` 
```
source ~/dotfiles/zshrc
```
in `~/.tmux.conf`
```
source-file ~/dotfiles/tmux.conf
```

# For iTerm2
- need to enable mouse reporting in iTerm2 settings
- Preferences ▸ Profiles ▸ Terminal ▸ Enable mouse reporting

# Bash not supported
Install zsh pls.
