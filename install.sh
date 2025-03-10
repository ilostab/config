#!/bin/bash

echo "🛠️ Setting up terminal environment"

# --- Idempotency Checks ---

# Check if Zsh is already the default shell
if [[ "$SHELL" == *zsh* ]]; then
  echo "😴 Zsh is already the default shell. Skipping."
else
  echo "⏳ Installing packages... This may take a while."
  echo "👑 You might be promted for sudo"
  # Update and install packages (silenced)
  sudo apt update > /dev/null 2>&1
  sudo apt install -y zsh 7zip wget curl zoxide tmux fontconfig build-essential > /dev/null 2>&1

  echo "👑 Moving to zsh terminal. You will be promted for sudo"
  # Change shell to zsh
  chsh $USER -s $(which zsh)

  echo "🎉 Zsh installed and set as default shell."
fi

# Check if Nerd Font is already installed
if fc-list | grep -q "JetBrainsMono Nerd Font"; then
  echo "😴 Nerd Font is already installed. Skipping."
else
  echo "🤓 Installing Nerd Font..."
  # Download and install Nerd Font (silenced)
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

# Download the config files from GitHub (silenced)
git clone -q https://github.com/ilostab/config.git

# Copy the config files to the home directory (using correct paths)
cp config/zshrc ~/.zshrc  # Corrected line
mkdir -p ~/.config/tmux
cp config/tmux.conf ~/.config/tmux/  # Corrected line
mkdir -p $HOME/.config/ohmyposh/
cp config/zen.toml $HOME/.config/ohmyposh/zen.toml  # Corrected line

# Remove the cloned repository
rm -rf config

echo "📂 Configuration files copied."

# --- Continue with installations ---

# Check if fzf is already installed
if command -v fzf > /dev/null 2>&1; then
  echo "😴 fzf is already installed. Skipping."
else
  echo "🔍 Installing fzf..."
  # Install fzf (silenced)
  git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  # Automate fzf installation prompts
  yes y | ~/.fzf/install > /dev/null 2>&1

  # Add fzf to PATH in ~/.zshrc
  echo "export PATH=\"\$PATH:\$HOME/.fzf/bin\"" >> ~/.zshrc

  echo "🔍 fzf installed."
fi

# Check if Homebrew is already installed
if command -v brew > /dev/null 2>&1; then
  echo "😴 Homebrew is already installed. Skipping."
else
  echo "🍺 Installing Homebrew..."
  # Install Oh My Posh (silenced, non-interactive)
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null 2>&1

  # Add Homebrew to PATH in ~/.zshrc
  echo >> ~/.zshrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  echo "🍺 Homebrew installed."
fi

# Check if oh-my-posh is already installed
if command -v oh-my-posh > /dev/null 2>&1; then
  echo "😴 oh-my-posh is already installed. Skipping."
else
  echo "🍺 Brewing Oh My Posh... (this is a difficult brew and takes time 🍺🍺🍺)"  # Changed line
  # Install oh-my-posh (silenced)
  brew install jandedobbeleer/oh-my-posh/oh-my-posh > /dev/null 2>&1

  # Add oh-my-posh to PATH in ~/.zshrc
  echo "export PATH=\"\$PATH:/usr/local/bin\"" >> ~/.zshrc

  echo "🍺 Oh My Posh brewed and ready."  # Changed line
fi

# Check if tmux plugin manager is already installed
if [[ -d ~/.tmux/plugins/tpm ]]; then
  echo "😴 tmux plugin manager is already installed. Skipping."
else
  echo "🔌 Installing tmux plugin manager..."
  # Install tmux plugin manager (silenced)
  git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  echo "🔌 tmux plugin manager installed."
fi


# --- Verification Tests ---

echo "✅ Verifying installations..."

# Test fzf
if fzf --version > /dev/null 2>&1; then
  echo "🎉 fzf is working correctly! Test with Ctrl+r"
else
  echo "❌ fzf installation failed!"
fi

# Test oh-my-posh
if oh-my-posh --version > /dev/null 2>&1; then
  echo "🚀 oh-my-posh is working correctly!"
else
  echo "⚠️ oh-my-posh installation failed!"
fi

# Test tmux
if tmux -V > /dev/null 2>&1; then
  echo "✅ tmux is working correctly!"
else
  echo "🚫 tmux installation failed!"
fi

# Instructions for installing tmux plugins
echo "🔌 To install tmux plugins, start tmux and press PREFIX + I."

# --- Reboot Prompt ---

read -p "Do you want to reboot now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo reboot
fi
