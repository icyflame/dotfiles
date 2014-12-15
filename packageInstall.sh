# install git

sudo apt-get install git-core
sudo apt-get install gitg

# install vim

sudo apt-get install vim

# install and configure zsh
# https://gist.github.com/tsabat/1498393

sudo apt-get install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

echo "zsh has been installed. You have to change the shell and then restart the machine."
echo "Run the following commands:"
echo "chsh -s `which zsh`"
echo "sudo shutdown -r 0"
