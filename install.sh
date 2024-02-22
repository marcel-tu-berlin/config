#!/bin/bash

sudo apt-get update
sudo apt-get install -y software-properties-common build-essential zsh

# Install tmux
sudo apt-get install tmux -y
mkdir ~/.config/tmux
if [[ -f ~/.config/tmux/tmux.conf ]]; then
  mv ~/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf.bak
fi
cp tmux.conf ~/.config/tmux/
tmux source ~/.config/tmux/tmux.conf

# Install JetBrainsMono NerdFont
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
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install node

# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
rm nvim-linux64.tar.gz
source ~/.bashrc

# Install NvChad
if [[ -d ~/.config/nvim ]]; then
    rm -rf ~/.config/nvim.bak
    mv ~/.config/nvim ~/.config/nvim.bak
    rm -rf ~/.config/nvim
    rm -rf ~/.local/share/nvim
fi
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

