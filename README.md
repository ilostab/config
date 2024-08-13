# config
Based on Dreams of Autonomy 

# Setup 
```
sudo apt update
sudo apt install zsh
chsh $USER -s $(which zsh)
```
- Download .zshrc from this repo
- Set the Font to be `JetBrainsMono Nerd Font`
```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
7z x JetBrainsMono.zip
sudo cp *.ttf /usr/share/fonts/truetype/
sudo fc-cache -f -v
```

fzf
`
sudo apt install fzf`

ohmyposh
- config file in `.config/ohmyposh/zen.toml`
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```
