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
  git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.fzf > .fzf.output 2>&1
  yes y | ~/.fzf/install >> .fzf.output 2>&1
  # The fzf installer already adds this to .zshrc, but we add it
  # to the current script's session just in case.
  export PATH="$PATH:$HOME/.fzf/bin"
  echo "🔍 fzf installed."
fi

# ===================================================================
# --- START MODIFIED HOMEBREW BLOCK ---
# ===================================================================

# Check if Homebrew is already installed
if command -v brew > /dev/null 2>&1; then
  echo "😴 Homebrew is already installed. Skipping."
  # Ensure shellenv is active for this script session, even if brew was pre-installed
  eval "$($(which brew) shellenv)"
else
  echo "🍺 Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > .homebrew.output 2>&1
  
  # Check for the executable file directly, NOT using 'command -v'
  BREW_EXECUTABLE="/home/linuxbrew/.linuxbrew/bin/brew"
  
  if [[ -x "$BREW_EXECUTABLE" ]]; then
    echo "🍺 Homebrew executable found. Configuring shell..."
    
    # Add brew to .zshrc for FUTURE shells
    echo >> ~/.zshrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    
    # Add brew to the CURRENT script's environment
    eval "$($BREW_EXECUTABLE shellenv)"
    
    echo "🍺 Homebrew installed and configured."
  else
    echo "❌ Homebrew install failed! Check .homebrew.output."
  fi
fi

# ===================================================================
# --- END MODIFIED HOMEBREW BLOCK ---
# ===================================================================


# ===================================================================
# --- START MODIFIED OH-MY-POSH BLOCK ---
# ===================================================================

# Check if oh-my-posh is already installed
if command -v oh-my-posh > /dev/null 2>&1; then
  echo "😴 oh-my-posh is already installed. Skipping."
else
  # Now that the Homebrew block is fixed, 'command -v brew'
  # should succeed because 'eval' added it to our script's PATH.
  if command -v brew > /dev/null 2>&1; then
    echo "🍺 Brewing Oh My Posh... (this is a difficult brew and takes time 🍺🍺🍺)"
    brew install jandedobbeleer/oh-my-posh/oh-my-posh > .oh-my-posh.output 2>&1
    echo "🍺 Oh My Posh brewed and ready."
  else
    # This will run if the Homebrew installation failed again for some reason
    echo "❌ Cannot install oh-my-posh because Homebrew is still not found."
  fi
fi

# ===================================================================
# --- END MODIFIED OH-MY-POSH BLOCK ---
# ===================================================================


# Check if tmux plugin manager is already installed
if [[ -d ~/.tmux/plugins/tpm ]]; then
  echo "😴 tmux plugin manager is already installed. Skipping."
else
  echo "🔌 Installing tmux plugin manager..."
  git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm > .tmux-tpm.output 2>&1
  echo "🔌 tmux plugin manager installed."
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

# --- Output Display ---

echo "-------------------Installation Output Logs-------------------"

if [[ -f .fzf.output ]]; then
  echo "🔍 fzf output log:"
  cat .fzf.output
  rm -f .fzf.output
fi

if [[ -f .homebrew.output ]]; then
  echo "🍺 Homebrew output log:"
  cat .homebrew.output
  rm -f .homebrew.output
fi

if [[ -f .oh-my-posh.output ]]; then
  echo "🎨 oh-my-posh output log:"
  cat .oh-my-posh.output
  rm -f .oh-my-posh.output
fi

if [[ -f .tmux-tpm.output ]]; then
  echo "🔌 tmux plugin manager output log:"
  cat .tmux-tpm.output
  rm -f .tmux-tpm.output
fi

echo "-------------------------------------------------------------"
