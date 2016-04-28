# Run:
# cd
# git clone https://github.com/icyflame/dotfiles.git

### Check the command line arguments and infer the type of machine

# Types:
# 1 - Ubuntu - Full setup
# 2 - Ubuntu Digital Ocean

declare -r UBUNTU=1
declare -r DIGITAL_OCEAN=2
declare -r CUSTOM=3

if [[ "$1" == "ubuntu" ]]; then
	machine=$UBUNTU
else
	if [[ "$1" == "digitalocean" ]]; then
		machine=$DIGITAL_OCEAN
	else
		machine=$CUSTOM
	fi
fi

### Define global vars and bring in dependencies

declare -r dotfiles_loc="$HOME/dotfiles"

# include the yesno function

source $dotfiles_loc/helpers/yesno.sh

### Install all the basic packages that are always required

echo "Installing core packages."

# install git

sudo apt-get install -y git-core
sudo apt-get install -y gitg

# install vim

sudo apt-get install -y vim

# install ruby

sudo apt-get install -y nodejs
sudo apt-get install -y ruby-full

# Installing Vundle

# Installing the Vundle: Vim Bundle, the vim Package Manager
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install and configure zsh
# https://gist.github.com/tsabat/1498393

sudo apt-get install zsh
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
if yesno "Copy all the shell scripts from bin to /usr/local/bin (requires sudo) ? "; then

	for file in `ls $dotfiles_loc/**/*.sh`; do
		sudo cp --remove-destination $file /usr/local/bin/
	done
else
	echo "Okay! Didn't copy, Done for now."
fi

vim +PluginInstall

### Done!

# TODO: If zsh was installed, then tell them this:

echo "zsh has been installed. You have to change the shell and then restart the machine."
echo "Run the following commands:"
echo "chsh -s `which zsh` # will change the default shell"
echo "sudo shutdown -r 0 # will reboot your machine"

if yesno "Change the default shell to zsh and reboot this machine (requires sudo) ? "; then
	chsh -s `which zsh`
	sudo shutdown -r 0
fi
