### Post install

#### Install additional tools
```bash
$ sudo apt install git tig zsh tmux neovim
$ sudo apt remove vim # So neovim will be used instead
```

#### Install plugins
* [ohmyzsh](https://ohmyz.sh/)
* [fzf](https://github.com/junegunn/fzf)
* [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
* [vim-plug](https://github.com/junegunn/vim-plug) (*install for neo vim*)
* [material-shell](https://github.com/material-shell/material-shell)
* [powerlevel9k](https://github.com/Powerlevel9k/powerlevel9k) OR [powerlevel10k](https://github.com/romkatv/powerlevel10k)

#### Config
```bash
# tmux config
$ (cd ~ && curl -LO https://raw.githubusercontent.com/codentary/config/master/linux/home/.tmux.conf)
# nvim config
$ mkdir -p .config/nvim && (cd ~/.config/nvim && curl -LO https://github.com/codentary/config/blob/master/linux/home/.config/nvim/init.vim)
$ vim -c ':PlugInstall' # after configuring nvim, we can install configured the plugins 
# git config
$ bash -c "$(curl -fsSL https://raw.githubusercontent.com/codentary/config/master/linux/git/config.sh)"
```