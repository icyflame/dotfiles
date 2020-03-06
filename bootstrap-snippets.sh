function echo_eval {
    CMD="$1"
    echo "$CMD"

    DEBUG="$2"
    if [[ "$DEBUG" == "$RUN_STR" ]]; then
        eval "$CMD"
    fi
}

RUN_STR="--go"
GLOBAL_DEBUG="$1"
DOTFILES_LOC="$HOME/dotfiles"

if [[ "$GLOBAL_DEBUG" == "$RUN_STR" ]]; then
    echo "Non Dry Run";
else
    echo "Dry Run";
    echo "Run with --go suffix to actually execute these commands"
fi

echo "Symlinking all the snippets files:"
SNIPPETS_LOC="$HOME/.vim/custom-snippets"
echo_eval "mkdir -p \"$SNIPPETS_LOC\"" "$GLOBAL_DEBUG"

for file in `ls $DOTFILES_LOC/**/*.snippets`; do
    file_name=`basename $file`
	dst_file="$SNIPPETS_LOC/$file_name"
    echo_eval "rm -f \"$dst_file\"" "$GLOBAL_DEBUG"
	echo_eval "ln -s \"$file\" \"$dst_file\"" "$GLOBAL_DEBUG"
done
