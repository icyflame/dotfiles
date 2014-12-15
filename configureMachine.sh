# Run:
# cd
# git clone https://github.com/icyflame/dotfiles.git

echo "Installing core packages."
cd
bash ~/dotfiles/packageInstall.sh
echo "Changing the color scheme and installing Vundle."
cd
bash ~/dotfiles/runFromHome.sh
echo "Symlinking all the dotfiles"
cd
bash ~/dotfiles/install.sh

echo "For setting up Vim Plugins: "
echo "Open Vim and run ':PluginInstall'"
