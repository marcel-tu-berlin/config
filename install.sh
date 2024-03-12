#!/bin/bash

echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y software-properties-common build-essential zsh git xclip acpi lm-sensors curl sed sysstat

# Install tmux
echo "Installing tmux..."
sudo apt-get install tmux -y
mkdir ~/.config/tmux
if [[ -f ~/.config/tmux/tmux.conf ]]; then
  mv ~/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf.bak
fi

# Install tmux plugin manager
echo "Installing tmux plugin manager..."
if [[ -d ~/.tmux/plugins/tpm ]]; then
  rm -rf ~/.tmux/plugins/tpm
fi
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install tmux configuration
echo "Installing tmux configuration..."
cp tmux.conf ~/.config/tmux/
tmux source ~/.config/tmux/tmux.conf

# Install JetBrainsMono NerdFont
echo "Installing JetBrainsMono NerdFont..."
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
if [[ ! -d ~/.local/share/fonts ]]; then
    mkdir -p ~/.local/share/fonts
fi
if [[ -d ~/.local/share/fonts/JetBrainsMono ]]; then
    rm -rf ~/.local/share/fonts/JetBrainsMono
fi
mv JetBrainsMono ~/.local/share/fonts/
rm -rf JetBrainsMono*

# Install node latest
echo "Installing node latest..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install node

# Install Neovim
echo "Installing Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim
rm nvim-linux64.tar.gz
source ~/.bashrc

# Install NvChad
echo "Installing NvChad..."
if [[ -d ~/.config/nvim ]]; then
    rm -rf ~/.config/nvim.bak
    mv ~/.config/nvim ~/.config/nvim.bak
    rm -rf ~/.config/nvim
    rm -rf ~/.local/share/nvim
fi
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

# Note: Noting can come below zsh install.sh because it quits the shell
# Install oh-my-zsh
echo "Installing oh-my-zsh..."
if [[ -d ~/.oh-my-zsh ]]; then
  rm -rf ~/.oh-my-zsh
fi
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
