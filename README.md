# dotfiles
My dotfiles and setup for mac & linux. Use at your own risk.

# macOS
```
brew install fzf
brew install tmux
brew install zsh-autosuggestions
brew install neovim
brew install ripgrep
curl -LsSf https://astral.sh/uv/install.sh | sh
```

# linux (ubuntu)
```
sudo apt-get install fzf
sudo apt-get install tmux
sudo apt-get install zsh-autosuggestions
sudo apt-get install neovim
sudo apt-get install ripgrep
curl -LsSf https://astral.sh/uv/install.sh | sh
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
Install zsh pls (`sudo apt-get install zsh`). Then `sudo chsh -s $(which zsh)` and re-open shell, sourcing wont change it)

# Setting up a mac 🍏 laptop for the first time
<details>
  <summary>click here</summary>
  
- 🍺 Install brew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` (https://brew.sh/) (will ask for password and installs xcode tools)
- [Rectangle](https://github.com/rxhanson/Rectangle) for window snapping: `brew install --cask rectangle`
- Activate key repeat, do this in terminal: `defaults write -g ApplePressAndHoldEnabled -bool false` <[source](https://www.macworld.com/article/351347/how-to-activate-key-repetition-through-the-macos-terminal.html)> (then restart laptop)
- Get [ghostty](https://ghostty.org/) and/or [iterm2](https://iterm2.com/)
- Jiggler for work laptops (https://www.sticksoftware.com/software/Jiggler.html)
- maccy (for multi copy): `brew install maccy` <[source](https://github.com/p0deje/Maccy)>
- Hide macos dock (right click the `|` icon and hide)
- Increase key repeat rate and shorten delay until repeat:
  - <img width="712" height="169" alt="Screenshot 2026-03-06 at 4 08 00 PM" src="https://github.com/user-attachments/assets/38be652f-0b2c-41b4-b7a8-9c297fb9ab0d" />
- Increase trackpad speed:
  - <img width="712" height="300" alt="Screenshot 2026-03-06 at 4 12 09 PM" src="https://github.com/user-attachments/assets/449eccbe-b59b-4e79-b7a6-fb87bb23e041" />
- Enable 3 finger drag:
  - <img width="719" height="527" alt="Screenshot 2026-03-06 at 4 15 21 PM" src="https://github.com/user-attachments/assets/c9ddc2e1-06bd-48e8-81ae-0c66bebf6455" />

</details>
 
