#! /usr/bin/zsh

rm ~/.config/nvim/lua/custom/*
cp plugins.lua chadrc.lua ~/.config/nvim/lua/custom

# powerlevel10k
echo "Installing powerlevel10k..."
if [[ -d	 ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
  rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k
fi
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
source ~/.zshrc
