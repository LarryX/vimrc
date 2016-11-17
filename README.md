# vimrc
a powerful vim config file, the key map refer to spacemacs

still being imaturing...

## Description

* `vimrc-server`: Simple vimrc for server without any plugin
* `vimrc-dev`: vimrc for develop

## Install | Upgrade

1. Prerequisites

    * vim compiled with python support. Check it with vim --version | grep +python
    * Install the required dependencies:
    ```bash
    # ubuntu
    sudo apt-get install exuberant-ctags git ack-grep
    sudo apt-get install silversearcher-ag
    sudo pip install pep8 flake8 pyflakes isort yapf

    # mac
    brew install ctags
    brew install the_silver_searcher
    sudo pip install pep8 flake8 pyflakes isort yapf
    ```
    * backup your old .vimrc file and .vim folder, create an empty .vim folder

2. Clone this repo, and create a soft symbolic links `~/.vimrc` target the vimrc file which you want to use

    eg:

    ```bash
    git clone https://github.com/ovsoil/vimrc.git ~/repo/vimrc
    ln -s repo/vimrc/vimrc-dev ~/.vimrc
    ```
3. Open vim and it will continue the installation by itself. Wait for it to finish... and done! You now have your new shiny powerful vim :)


## screenshot:
## Features
    
a powerful vim config file, some of the keymap refer to spacemacs

### 1.  Include the Hot Plugins

* vim-plug: easy to install plugins and runtime files
* syntastic: external syntax checkers and displays any resulting errors
* nerdtree: explore your file system and to open files and directories
* vim-airline: provides statuslines and prompts
* ...

### 2. Little but *usefull* features

* toggle help window by one key(default <F1>);
* nerdtree keymap similar to neotree in emacs;
* easy way to *search/replace/highlight/grep* current word & selected text
* return to last edit position when opening files
* ...


## Tips

### general

### search and replace

### copy and paste

### navigate

### git

### auto completion

### snipmate
