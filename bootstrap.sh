# Run:
# cd
# git clone https://github.com/icyflame/dotfiles.git

### Define global vars and bring in dependencies

declare -r dotfiles_loc="$HOME/dotfiles"

# include the yesno function

source $dotfiles_loc/yesno.sh

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

### Optional package installation begin

#### Common gems

# TODO: Check if user wants rails, sudo is required

sudo su
gem install rails --verbose
gem install devise --verbose
gem install zeus --verbose

# install and configure zsh
# https://gist.github.com/tsabat/1498393

#### Zsh : change the shell?

# TODO: Ask if user wants zsh

sudo apt-get install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

echo "zsh has been installed. You have to change the shell and then restart the machine."
echo "Run the following commands:"
echo "chsh -s `which zsh` # will change the default shell"
echo "sudo shutdown -r 0 # will reboot your machine"

#### The solarized color scheme

# TODO: Ask if user wants to change color scheme, useless on digital ocean droplets

echo "Changing the color scheme"
cd

# Setting up the solarized-dark color scheme.
# https://gist.github.com/gmodarelli/5942850

git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
cd gnome-terminal-colors-solarized
./set_dark.sh

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
		cp --remove-destination $file /usr/local/bin/
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
