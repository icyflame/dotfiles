# Setup all the dotfiles in the $HOME directory

function echo_eval {
    CMD="$1"
    echo "$CMD"

    DEBUG="$2"
    if [[ "$DEBUG" == "$RUN_STR" ]]; then
        eval "$CMD"
    fi
}

RUN_STR="--go"
HELP_STR="--help"

GLOBAL_DEBUG="$1"

if [[ "$GLOBAL_DEBUG" == "$RUN_STR" ]]; then
    echo "TRUE RUN: will run all the commands that follow"
else
    echo "DRY RUN: will not run any command"
fi

DOTFILES_LOC="$HOME/dotfiles"

DATE=`date +%Y-%m-%d-%H-%M-%S`
OLD_DOTFILES_LOC="$HOME/dotfiles_old/$DATE"

echo "Symlinking all the dotfiles:"
echo_eval "mkdir -p \"$OLD_DOTFILES_LOC\"" "$GLOBAL_DEBUG"

for file in `ls $DOTFILES_LOC/**/*.symlink`; do
	filename=`basename "$file"`
	extension="${filename##*.}"
	dotfile="${filename%.*}"

	echo_eval "cp -v $HOME/.$dotfile $OLD_DOTFILES_LOC/$dotfile.old" "$GLOBAL_DEBUG"
	echo_eval "rm -f  $HOME/.$dotfile" "$GLOBAL_DEBUG"
	echo_eval "ln -s $file $HOME/.$dotfile" "$GLOBAL_DEBUG"
done

echo "Symlinking all the snippets files:"
SNIPPETS_LOC="$HOME/.vim/custom-snippets"
echo_eval "mkdir -p \"$SNIPPETS_LOC\"" "$GLOBAL_DEBUG"

for file in `ls $DOTFILES_LOC/**/*.snippets`; do
    file_name=`basename $file`
	dst_file="$SNIPPETS_LOC/$file_name"
    echo_eval "rm -f \"$dst_file\"" "$GLOBAL_DEBUG"
	echo_eval "ln -s \"$file\" \"$dst_file\"" "$GLOBAL_DEBUG"
done

if [[ -f "$HOME/.emacs.d/init.el" ]]; then
    echo_eval "mkdir -p $HOME/.emacs.d" "$GLOBAL_DEBUG"
    echo_eval "cp -v $HOME/.emacs.d/init.el $HOME/.emacs.d/init.el.old" "$GLOBAL_DEBUG"
fi

echo_eval "rm -f $HOME/.emacs.d/init.el" "$GLOBAL_DEBUG"
echo_eval "ln emacs/init.el $HOME/.emacs.d/init.el" "$GLOBAL_DEBUG"
