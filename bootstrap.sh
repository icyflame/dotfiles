# Run:
# cd
# git clone https://github.com/icyflame/dotfiles.git

### Check the command line arguments and infer the type of machine

# Types:
# 1 - Ubuntu - Full setup
# 2 - Ubuntu Digital Ocean
# 3 - Custom setup

declare -r UBUNTU=1
declare -r DIGITAL_OCEAN=2
declare -r CUSTOM=3

INSTALLER="sudo apt-get"

MACHINE=$1
case $MACHINE in
    "ubuntu")
        machine=$UBUNTU
        ;;
    "digitalocean")
        machine=$DIGITAL_OCEAN
        ;;
    "custom")
        machine="$CUSTOM"
esac

### Define global vars and bring in dependencies
declare -r dotfiles_loc="$HOME/dotfiles"

### Install all the basic packages that are always required
echo "Installing core packages."

# Install zsh, git, rg, ag, nmap
$INSTALLER install --yes zsh git-core vim ripgrep silversearcher-ag nmap

# Install nvm (Node.js version manager)
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
source ~/.bashrc

# Install the stable version of Node.js using nvm
nvm install stable

# Tmux Plugin Manager setup
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Prezto, and all plugins
cd $dotfiles_loc && git submodule update
cd $dotfiles_loc/.zprezto && git submodule update

mkdir -p "$HOME/bin"
cp "$dotfiles_loc/bin/*" "$HOME/bin"

bash $dotfiles_loc/bootstrap-dotfiles.sh

### Done!

cat <<EOF
-----
Bootstrap Complete

To install Tmux plugins, do the following:

    Start tmux
    Run PREFIX + I (uppercase i)

To change the default shell, run the following command:

    chsh -s `which zsh`

After running the command, restart the computer so that the changes can take effect.
-----
EOF
