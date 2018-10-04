### Dotfile setup in the $HOME directory

declare -r dotfiles_loc="$HOME/dotfiles"
source $dotfiles_loc/helpers/yesno.sh

echo "Symlinking all the dotfiles"

cd

declare -r olddir="dotfiles_old_$(date +%s)"

echo $olddir

mkdir -p ~/$olddir

for file in `ls $dotfiles_loc/**/*.symlink`; do
	# echo $file
	filename=$(basename "$file")
	extension="${filename##*.}"
	dotfile="${filename%.*}"
	# echo $dotfile

    # Destination file is not removed, remove/rename the file manually if you
    # want that. Anyway, the old dotfiles are put in a folder that has a unique
    # name, so you probably don't need to worry about this.
	cp -v ~/.$dotfile ~/$olddir/$dotfile.old
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
