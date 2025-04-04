#!/bin/bash

echo "🛠️ Setting up terminal environment 🛠️"
echo "-----------------------------------"
echo "This will setup:"
echo "🛠️ zsh with config in zshrc"
echo "🛠️ oh-my-posh with config in ten.toml"
echo "🛠️ Tmux with config in tmux.conf"
echo "🛠️ Homebrew"
echo "🛠️ JetBrainsMono Nerd Font"
echo "🛠️ fzf"
echo "-----------------------------------"

echo "⏳ Installing core packages... This may take a while."
echo "👑 You might be promted for sudo (reason: apt update/install)"
sudo apt update > /dev/null 2>&1
sudo apt install -y zsh 7zip wget curl zoxide tmux fontconfig build-essential git > /dev/null 2>&1

# --- Idempotency Checks ---

# Check if Zsh is already the default shell
if [[ "$SHELL" == *zsh* ]]; then
  echo "😴 Zsh is already the default shell. Skipping."
else
  echo "👑 Moving to zsh terminal. You will be promted for sudo (reason: zsh)"
  chsh $USER -s $(which zsh)
  echo "🎉 Zsh installed and set as default shell."
fi

# Check if Nerd Font is already installed
if fc-list | grep -q "JetBrainsMono Nerd Font"; then
  echo "😴 Nerd Font is already installed. Skipping."
else
  echo "🤓 Installing Nerd Font..."
  mkdir -p font && cd font
  wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
  7z x JetBrainsMono.zip > /dev/null 2>&1
  sudo cp *.ttf /usr/share/fonts/truetype/ > /dev/null 2>&1
  sudo rm *ttf
  sudo rm JetBrainsMono.zip
  sudo fc-cache -f -v > /dev/null 2>&1
  cd ..
  echo "🤓 Nerd Font installed."
fi

# --- Download and copy configuration files ---

echo "📥 Downloading and configuring files..."

git clone -q https://github.com/ilostab/config.git

cp config/zshrc ~/.zshrc
mkdir -p ~/.config/tmux
cp config/tmux.conf ~/.config/tmux/
mkdir -p $HOME/.config/ohmyposh/
cp config/zen.toml $HOME/.config/ohmyposh/zen.toml

rm -rf config

echo "📂 Configuration files copied."

# --- Continue with installations ---

# Check if fzf is already installed
if command -v fzf > /dev/null 2>&1; then
  echo "😴 fzf is already installed. Skipping."
else
  echo "🔍 Installing fzf..."
  git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.fzf > /dev/null 2>&1
  yes y | ~/.fzf/install > .fzf.error 2>&1
  if [[ -s .fzf.error ]]; then
    echo "❌ fzf installation encountered errors."
  else
    echo "export PATH=\"\$PATH:\$HOME/.fzf/bin\"" >> ~/.zshrc
    export PATH="$PATH:$HOME/.fzf/bin"
    echo "🔍 fzf installed."
  fi
fi

# Check if Homebrew is already installed
if command -v brew > /dev/null 2>&1; then
  echo "😴 Homebrew is already installed. Skipping."
else
  echo "🍺 Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > .homebrew.error 2>&1
  if [[ -s .homebrew.error ]]; then
    echo "❌ Homebrew installation encountered errors."
  else
    if command -v brew > /dev/null 2>&1; then
      echo >> ~/.zshrc
      echo 'eval "$($(which brew) shellenv)"' >> ~/.zshrc
      eval "$($(which brew) shellenv)"
      echo "🍺 Homebrew installed."
    else
      echo "❌ Homebrew install failed!"
    fi
  fi
fi

# Check if oh-my-posh is already installed
if command -v oh-my-posh > /dev/null 2>&1; then
  echo "😴 oh-my-posh is already installed. Skipping."
else
  echo "🍺 Brewing Oh My Posh... (this is a difficult brew and takes time 🍺🍺🍺)"
  brew install jandedobbeleer/oh-my-posh/oh-my-posh > .oh-my-posh.error 2>&1
  if [[ -s .oh-my-posh.error ]]; then
    echo "⚠️ oh-my-posh installation encountered errors."
  else
    echo "export PATH=\"\$PATH:/usr/local/bin\"" >> ~/.zshrc
    echo "🍺 Oh My Posh brewed and ready."
  fi
fi

# Check if tmux plugin manager is already installed
if [[ -d ~/.tmux/plugins/tpm ]]; then
  echo "😴 tmux plugin manager is already installed. Skipping."
else
  echo "🔌 Installing tmux plugin manager..."
  git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm > .tmux-tpm.error 2>&1
  if [[ -s .tmux-tpm.error ]]; then
    echo "🚫 tmux plugin manager installation encountered errors."
  else
    echo "🔌 tmux plugin manager installed."
  fi
fi

# --- Verification Tests ---

echo "✅ Verifying installations..."

# Test fzf
if fzf --version > /dev/null 2>&1; then
  echo "🎉 fzf is working correctly! Test with Ctrl+r"
else
  echo "❌ fzf verification failed!"
fi

# Test oh-my-posh
if oh-my-posh --version > /dev/null 2>&1; then
  echo "🚀 oh-my-posh is working correctly!"
else
  echo "⚠️ oh-my-posh verification failed!"
fi

# Test tmux
if tmux -V > /dev/null 2>&1; then
  echo "✅ tmux is working correctly!"
else
  echo "🚫 tmux verification failed!"
fi

# --- Reboot Prompt ---

echo "✅ Terminal Environment installed ✅"
echo "------------NEXT STEPS ---------------"
echo "🛠️ reboot system"
echo "🛠️ zsh will install on next startup"
echo "🛠️ install tmux plugins by starting tmux and press PREFIX + I."
echo "-----------------------------------"

# --- Error Display ---

echo "-------------------Error Logs-------------------"

if [[ -s .fzf.error ]]; then
  echo "❌ fzf error log:"
  cat .fzf.error
  rm -f .fzf.error
fi

if [[ -s .homebrew.error ]]; then
  echo "❌ Homebrew error log:"
  cat .homebrew.error
  rm -f .homebrew.error
fi

if [[ -s .oh-my-posh.error ]]; then
  echo "⚠️ oh-my-posh error log:"
  cat .oh-my-posh.error
  rm -f .oh-my-posh.error
fi

if [[ -s .tmux-tpm.error ]]; then
  echo "🚫 tmux plugin manager error log:"
  cat .tmux-tpm.error
  rm -f .tmux-tpm.error
fi

echo "------------------------------------------------"
