#! /bin/bash

# Install script for the dotfiles repository.
# This script creates symlinks for all files in the repository in the home directory.
create_symlinks() {
    # Get the directory of the script
    script_dir=$(dirname "$(readlink -f "$0")")

    # Get dotfiles
    files=$(find -maxdepth 1 -type f -name ".*")

    # Create symlinks
    for file in $files; do
        name=$(basename $file)
        echo "Creating symlink for $name in home directory"
        rm -rf ~/$name
        ln -s $script_dir/$file ~/$name
    done

    if [ ! -d ~/.config/nvim ]; then
        mkdir -p ~/.config
        ln -s $script_dir/nvim/.config/nvim ~/.config/
    fi

    if [ ! -f ~/.config/starship.toml ]; then
        ln -s $script_dir/starship.toml ~/.config/starship.toml
    fi
}

lazygit_install() {

    # Install lazygit
    if [ ! -f /usr/local/bin/lazygit ]; then
        echo "lazygit installing ..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
    fi
}

starship_install() {
    echo "inside starship install"

    # Check for starship 
    if [ ! -f ~/.local/bin/starship ]; then
        echo "Starship installing...."
        mkdir -p ~/.local/bin
        sudo curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y
    fi

    # Check for nerdfont
    if [ ! -d ~/.local/share/fonts ]; then
        mkdir -p ~/.local/share/fonts
        ln -s $script_dir/firacode/*.ttf ~/.local/share/fonts
    fi

}

create_symlinks
starship_install
lazygit_install
