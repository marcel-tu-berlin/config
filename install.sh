#!/bin/bash

sudo apt-get update
sudo apt-get install -y software-properties-common build-essential
# Install tmux
sudo apt-get install tmux -y
cp .tmux.conf ~/
tmux kill-server

# Install JetBrainsMono NerdFont
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
if [[ ! -d ~/.local/share/fonts ]]; then
    mkdir -p ~/.local/share/fonts
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

