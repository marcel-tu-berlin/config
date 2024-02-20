#!/bin/bash

# Install JetBrainsMono NerdFont
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
mv JetBrainsMono ~/.local/share/fonts/

# Install node latest
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install node

# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc

# Install NvChad
if [[ -d ~/.config/nvim ]]; then
  mv ~/.config/nvim ~/.config/nvim.bak
  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim 
fi
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

rm ~/.config/nvim/lua/custom/*
cp plugins.lua chadrc.lua ~/.config/nvim/lua/custom



