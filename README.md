# dotfiles
this is a really simple dotfiles setup for zsh, tmux, and fzf. It just has a few features that make terminal a happy place for me.

# macOS
```
brew install fzf
brew install tmux
brew install zsh-autosuggestions
brew install neovim
```

# linux (ubuntu)
```
sudo apt-get install fzf
sudo apt-get install tmux
sudo apt-get install zsh-autosuggestions
sudo apt-get install neovim
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
Install zsh pls. (`sudo chsh -s $(which zsh)` and re-open shell, sourcing wont change it)
