# config
Based on Dreams of Autonomy 

# Setup 
```
sudo apt update
sudo apt install zsh
chsh $USER -s $(which zsh)
```
- reboot system for change shell to take effect
- Download .zshrc from this repo
- Set the Font to be `JetBrainsMono Nerd Font`
```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
7z x JetBrainsMono.zip
sudo cp *.ttf /usr/share/fonts/truetype/
sudo fc-cache -f -v
```

fzf
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
- installs in user directory. cp or mv to /urs/bin

zoxide
`sudo apt install zoxide`

ohmyposh
- config file in `.config/ohmyposh/zen.toml`
- - installs in user directory. cp or mv to /urs/bin
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```
tmux
- `sudo apt install tmux`
- create .config/tmux/tmux.conf and copy tmux.conf from this repo
- `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- Install plugins: tmux --> PREFIX + I
