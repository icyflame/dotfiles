cd

declare -r olddir="dotfiles_old"

echo $olddir

mkdir -p ~/$olddir

declare -r dotfiles_loc="$HOME/dotfiles"

# include the yesno function

source $dotfiles_loc/yesno.sh

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
