cd

declare -r olddir="dotfiles_old"

echo $olddir

mkdir -p ~/$olddir

for file in `ls ~/dotfiles/**/*.symlink`; do
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

for file in `ls ~/dotfiles/**/*.sh`; do
	cp --remove-destination $file /usr/local/bin/
done
