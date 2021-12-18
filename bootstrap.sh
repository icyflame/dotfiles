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

# include the yesno function

source $dotfiles_loc/helpers/yesno.sh

### Install all the basic packages that are always required

echo "Installing core packages."

# install git

$INSTALLER install --yes git-core

# install vim

$INSTALLER install --yes vim

# install nvm and node.js

wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
source ~/.bashrc
nvm install stable

# install ruby

$INSTALLER install --yes ruby-full

# install ag : the silver searcher
# a better grep
$INSTALLER install --yes silversearcher-ag

# install nmap: port scanning util
$INSTALLER install -y nmap

# Installing Vundle

# Installing the Vundle: Vim Bundle, the vim Package Manager
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install and configure zsh
# https://gist.github.com/tsabat/1498393

$INSTALLER install -y zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

# setup the OH-MY-ZSH Plugins

git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

### Optional package installation begin

if [[ $machine != $DIGITAL_OCEAN ]]; then

	#### Common gems

	# TODO: Check if user wants rails, sudo is required

	sudo gem install rails --verbose
	sudo gem install devise --verbose
	sudo gem install zeus --verbose

	#### The solarized color scheme

	# TODO: Ask if user wants to change color scheme, useless on digital ocean droplets

	echo "Changing the color scheme"
	cd

	# Setting up the solarized-dark color scheme.
	# https://gist.github.com/gmodarelli/5942850

	git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
	cd gnome-terminal-colors-solarized
	./set_dark.sh

fi

### Dotfile setup in the $HOME directory

echo "Symlinking all the dotfiles"

cd

declare -r olddir="dotfiles_old"

echo $olddir

mkdir -p ~/$olddir

for file in `ls $dotfiles_loc/**/*.symlink`; do
	# echo $file
	filename=$(basename "$file")
	extension="${filename##*.}"
	dotfile="${filename%.*}"
	# echo $dotfile
	# echo "--remove-destination ~/.$dotfile $olddir/$dotfile.old"
	cp -u -v --remove-destination ~/.$dotfile ~/$olddir/$dotfile.old
	rm ~/.$dotfile
	# echo "ln -s $file ~/.$dotfile"
	ln -s $file ~/.$dotfile
done

if yesno --timeout 5 --default yes "Copy all the shell scripts from bin to /usr/local/bin (requires sudo) ? "; then
	for file in `ls $dotfiles_loc/**/*.sh`; do
		sudo cp --remove-destination $file /usr/local/bin/
	done
else
	echo "Okay! Didn't copy, Done for now."
fi

## install the compiled component of YouCompleteMe
# Not really required on throwaway DigitalOcean droplets. (Takes a whole lot of time on DO)
# And if there is less RAM, ends up not compiling.

if [[ $machine == $DIGITAL_OCEAN ]]; then
	sed -ie "s/Plugin 'Valloric\/YouCompleteMe'/ /g" $dotfiles_loc/vim/vimrc.symlink
else
	if yesno --timeout 5 --default no "Do you *really* need the compiled component of YCM? "; then
		sudo $INSTALLER install --yes build-essential cmake
		sudo $INSTALLER install --yes python-dev python3-dev
		cd ~/.vim/bundle/YouCompleteMe
		git submodule update --init --recursive
		./install.py --clang-completer
	else
		sed -ie "s/Plugin 'Valloric\/YouCompleteMe'/ /g" $dotfiles_loc/vim/vimrc.symlink
	fi
fi

## This requires the user to press ZZ at the end of the process
## for exiting properly
if [[ $machine != $DIGITAL_OCEAN ]]; then
	vim +PluginInstall
fi

### Done!

if [[ $machine == $DIGITAL_OCEAN ]]; then
	chsh -s `which zsh`
	sudo shutdown -r 0
else
	if yesno --timeout 5 --default yes "Change the default shell to zsh and reboot this machine (requires sudo) ? "; then
		chsh -s `which zsh`
		sudo shutdown -r 0
	fi
fi
