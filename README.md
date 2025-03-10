# ⚙️ config 🚀

Based on dreams of autonomy 🌟

## 🛠️ Setup

### 🐚 Zsh Installation

```
sudo apt update
sudo apt install zsh
chsh $USER -s $(which zsh)
```
- ⚠️ Reboot your system for the shell change to take effect.
- 📥 Download the .zshrc file from this repository.

### ✒️ Font Setup: JetBrainsMono Nerd Font

```
mkdir font && cd font
sudo apt install 7zip wget curl
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
7z x JetBrainsMono.zip
sudo cp *.ttf /usr/share/fonts/truetype/
sudo rm *ttf
sudo rm JetBrainsMono.zip
sudo fc-cache -f -v
```

### 🔍 fzf (Fuzzy Finder)
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
- 💡 Tip: You can move or copy the fzf binary to /usr/bin for system-wide access or add it to path in .zshrc

zoxide
`sudo apt install zoxide`

### ✨ oh-my-posh (Custom Terminal Prompt)

- 📝 Configuration file: .config/ohmyposh/zen.toml
- 📦 Installation (using Homebrew on Linux):
- 💡 Tip: You can move or copy the oh-my-posh binary to /usr/bin for system-wide access or add it to path in .zshrc. 
    
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```
### 🖥️ tmux (Terminal Multiplexer)
- `sudo apt install tmux`
- create .config/tmux/tmux.conf and copy tmux.conf from this repo
- `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- 🚀 Install plugins: Inside tmux, press PREFIX + I (where PREFIX is usually Ctrl+b, here Ctrl+a).
