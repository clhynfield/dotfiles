# Clayton Hynfield's dotfiles

placeholder

```shell
workspace_path="$HOME/workspace"
mkdir -p "$workspace_path"
git clone --recursive https://github.com/clhynfield/dotfiles.git "$workspace_path"
ln -sf "$workspace_path/dotfiles/.bashrc"
ln -sf "$workspace_path/dotfiles/.zshrc"
ln -sf "$workspace_path/dotfiles/.tmux.conf"
ln -sf "$workspace_path/dotfiles/.tmux"
ln -sf "$workspace_path/dotfiles/.vim"
"~/.tmux/plugins/tpm/bin/install_plugins"
vim -c PlugInstall -c quitall
```

## Appearance

https://github.com/blinksh/themes/blob/master/themes/Tomorrow%20Night.js
