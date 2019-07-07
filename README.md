# Clayton Hynfield's dotfiles

placeholder

```
workspace="~/workspace"
mkdir -p "$workspace" && cd "$workspace"
git clone --recursive https://github.com/clhynfield/dotfiles.git
cd
ln -sf "$workspace/.bashrc"
ln -sf "$workspace/.zshrc"
ln -sf "$workspace/.tmux.conf"
ln -sf "$workspace/.tmux"
ln -sf "$workspace/.vim"
"~/.tmux/plugins/tpm/bin/install_plugins"
vim -c PlugInstall -c quitall
```

## Appearance

https://github.com/blinksh/themes/blob/master/themes/Tomorrow%20Night.js
