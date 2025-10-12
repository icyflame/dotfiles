# Setup all the dotfiles in the $HOME directory
#
# This script is safe to rerun several times as it simply over-writes the existing configuration
# files with the config files that are provided by this repository.

### Helper ###

function echo_eval {
    CMD="$1"
    echo "$CMD"

    DEBUG="$2"
    if [[ "$DEBUG" == "$RUN_STR" ]]; then
        eval "$CMD"
    fi
}

### Frontmatter ###

RUN_STR="--go"
HELP_STR="--help"

if [[ "$1" == "$HELP_STR" ]];
then
    cat <<EOF
Help text for bootstrap-dotfiles.sh script

Options:
    1. --go => Non-dry-run; create the symlinks which will be created otherwise
    2. --help => Print this help text
EOF
    exit 42
fi

GLOBAL_DEBUG="$1"

if [[ "$GLOBAL_DEBUG" == "$RUN_STR" ]]; then
    echo "TRUE RUN: will run all the commands that follow"
else
    echo "DRY RUN: will not run any command"
fi

### Copy {file}.symlink to ~/.{file} ###

DOTFILES_LOC="$(pwd)"

DATE=`date +%Y-%m-%d-%H-%M-%S`
OLD_DOTFILES_LOC="${DOTFILES_LOC}_old"

echo "Symlinking all the dotfiles:"
echo_eval "mkdir -p \"$OLD_DOTFILES_LOC\"" "$GLOBAL_DEBUG"

for file in `ls $DOTFILES_LOC/**/*.symlink`; do
	filename=`basename "$file"`
	extension="${filename##*.}"
	dotfile="${filename%.*}"

	echo_eval "cp -v $HOME/.$dotfile $OLD_DOTFILES_LOC/$dotfile.old" "$GLOBAL_DEBUG"
	echo_eval "ln -sf $file $HOME/.$dotfile" "$GLOBAL_DEBUG"
done

### Alacritty Setup ###

DEST_FILE="$HOME/.config/alacritty/alacritty.toml"
echo_eval "mkdir -p $HOME/.config/alacritty" "$GLOBAL_DEBUG"
if [[ -e "$DEST_FILE" ]];
then
    echo_eval "cp -v $DEST_FILE $OLD_DOTFILES_LOC/alacritty.toml.old" "$GLOBAL_DEBUG"
fi
# Note this should NOT be a symbolic link. It must be a hard link.
echo_eval "ln -f alacritty.toml $DEST_FILE" "$GLOBAL_DEBUG"

### Foot (Terminal) Setup ###

DEST_FILE="$HOME/.config/foot/foot.ini"
echo_eval "mkdir -p $HOME/.config/foot" "$GLOBAL_DEBUG"
if [[ -e "$DEST_FILE" ]];
then
    echo_eval "cp -v $DEST_FILE $OLD_DOTFILES_LOC/foot.ini.old" "$GLOBAL_DEBUG"
fi
# Note this should NOT be a symbolic link. It must be a hard link.
echo_eval "ln -f foot.ini $DEST_FILE" "$GLOBAL_DEBUG"

### Sway window manager ###

DEST_FILE="$HOME/.config/sway/config"
echo_eval "mkdir -p $HOME/.config/sway" "$GLOBAL_DEBUG"
if [[ -e "$DEST_FILE" ]];
then
    echo_eval "cp -v $DEST_FILE $OLD_DOTFILES_LOC/swayconfig.old" "$GLOBAL_DEBUG"
fi
# Note this should NOT be a symbolic link. It must be a hard link.
echo_eval "ln -f swayconfig $DEST_FILE" "$GLOBAL_DEBUG"

DEST_FILE="$HOME/.config/i3status/config"
echo_eval "mkdir -p $HOME/.config/i3status" "$GLOBAL_DEBUG"
if [[ -e "$DEST_FILE" ]];
then
    echo_eval "cp -v $DEST_FILE $OLD_DOTFILES_LOC/i3statusconfig.old" "$GLOBAL_DEBUG"
fi
# Note this should NOT be a symbolic link. It must be a hard link.
echo_eval "cp -v i3status.config $DEST_FILE" "$GLOBAL_DEBUG"

# setopt EXTENDED_GLOB
for rcfile in `find $DOTFILES_LOC/.zprezto/runcoms -type f -not -name "README.md"`; do
  base=$(basename $rcfile)
  dest=$DOTFILES_LOC/.${base:t}
  echo_eval "ln -sf $rcfile $dest" "$GLOBAL_DEBUG"
done
