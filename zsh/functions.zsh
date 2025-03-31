# function for long running commands
# run as `long git push origin --all`
function long {
    eval $@;
    # echo "This command was executed"
    notify-send -t 2000 --urgency=low -i "terminal" "$@ done!"
}

# function for searching the history for the string
# that is passed as a parameter
function hist {
    history | ag $@
}

function calc {
    perl -e 'print '"$@"';'
    echo;
}

function compile {
    gcc -g $@ -lm && ./a.out
}

function gmp_compile {
    g++ $@ -lgmpxx -lgmp && ./a.out
}

function verifyApk {
    jarsigner -verify -verbose -certs $@ | less
}

function verifyApkSHAFingerPrint {
    keytool -list -printcert -jarfile $@ | less
}

function cutVideo {
    ffmpeg -i $1 -ss $2 -t $3 -c copy $4;
}

function getAudio {
    youtube-dl --extract-audio --prefer-ffmpeg --audio-format mp3 $@;
}

# usage: ssh-setup user@IP
# tasks: will create .ssh and .ssh/authorized_keys with appropriate permissions
# tasks: and then copy over this computer's pub key to remote IP
# https://github.com/TwP/dotfiles/blob/e8294e2330f3375516acf07e9cbf5fc0a72c4fb7/bash/aliases.bash#L142-L145
function ssh-setup {
    ssh $1 'mkdir -p -m 700 .ssh; touch .ssh/authorized_keys; chmod 600 .ssh/authorized_keys';
    cat ~/.ssh/id_rsa.pub | ssh $1 'cat - >> ~/.ssh/authorized_keys'
}

function markdown_to_pdf {
    FILE_NAME=$(echo $1 | cut -d . -f 1);
    markdown $1 > "$FILE_NAME.html";
    wkhtmltopdf "$FILE_NAME.html" "$FILE_NAME.pdf"
    rm "$FILE_NAME.html"
}

function open_latest {
    DIR_NAME=${1:-"."}
    $EDITOR $DIR_NAME/`ls -t $DIR_NAME | head -n1`
}

function open_oldest {
    DIR_NAME=${1:-"."}
    $EDITOR $DIR_NAME/`ls -t $DIR_NAME | tail -n1`
}

function get_ip {
    local host="http://ip.siddharthkannan.in"
    if [[ -x `which curl` ]]; then
        curl -q $host
    else
        if [[ -x `which wget` ]]; then
            wget -q -O- $host
        else
            echo "curl and wget not found"
        fi
    fi
}

function copy_commit {
    COMMIT=$@
    git log -1 $COMMIT | head -n5 | clipcopy;
}

function last_screenshot {
    PICTURE=`ls -t ~/Pictures/Screenshot*.png | head -n1`
    echo "Moving $PICTURE to $1"
    mv $PICTURE $1
    xdg-open "$1"
}

function random_ep {
    BASE_PATH="."

    COMMAND="find $BASE_PATH -type f | ag \"\.(avi|mkv|mp4|flv)\$\" | shuf | head -n1"

    FILE=`eval $COMMAND`
    echo $FILE
    echo $FILE >> ~/random_ep.log

    vlc $FILE
}

function no_proxy_act {
    export HTTP_PROXY="";
    export HTTPS_PROXY="";
    export http_proxy="";
    export https_proxy="";
    export ftp_proxy="";
    export FTP_PROXY="";
    export ALL_PROXY="";
    export all_proxy="";
    export socks_proxy="";
    export SOCKS_PROXY="";
}

function what_cmd {
    cat `which $1`
}

function awk_cmd {
	if [[ -x $(which gawk) ]];
	then
		echo "gawk"
	else
		echo "awk"
	fi
}

function sum_all {
    $(awk_cmd) '{ sum += $1 } END { print sum }' -
}

function avg_all {
    $(awk_cmd) '{ sum += $1 } END { print sum/NR }' -
}

function pretty_print_inplace {
    jq . "$1" > "$1.e" && rm "$1" && mv "$1.e" "$1"
}

alias ppi="pretty_print_inplace"

function colorize_go_tests {
    sed ''/PASS/s//$(printf "\033[32mPASS\033[0m")/'' | sed ''/FAIL/s//$(printf "\033[31mFAIL\033[0m")/''
}

# go_test ./handler NewPromote
# -> go test -v ./handler -run NewPromote
# -> will run all tests matching the second argument (regex) inside the first
# argument (package)
function go_test {
    PACKAGE="$1";
    TEST_REGEX="$2";

    if [[ "$PACKAGE" == "" ]]; then
        go test -v ./...
    elif [[ "$TEST_REGEX" == "" ]]; then
        go test -v $PACKAGE
    else
        go test -v $PACKAGE -run $TEST_REGEX
    fi
}

# got
#
# Go Test Runner utility
function got {
    if [[ "$1" == "-h" ]];
    then
        cat <<EOF

Go Test Runner Utility

$ got
-> runs for all packages and prints a summary of what happened

$ got ./handler
-> runs for this package and prints a summary

$ got ./handler NewPromote
-> runs for this package and prints a summary

$ got ./handler -v
-> runs and doesn't change the output of `go test`

$ got ./handler NewPromote -v
-> runs and doesn't change the output of `go test`
EOF
return 0;
    fi

    if [[ "$2" == "-v" ]]; then
        go_test "$1" ""
    elif [[ "$3" == "-v" ]]; then
        go_test "$1" "$2"
    else
        TEST_OUTPUT=`go_test "$1" "$2" | rg "^--- [A-Z]"`

		echo "$TEST_OUTPUT" | rg --quiet "FAIL" &&
			FAIL=$(echo -n "$TEST_OUTPUT" | rg -F FAIL) ||
				FAIL=""

		echo "$TEST_OUTPUT" | rg --quiet "PASS" &&
			PASS=$(echo -n "$TEST_OUTPUT" | rg -F PASS) || PASS=""

		echo "$TEST_OUTPUT" | rg --quiet "SKIP" &&
			SKIP=$(echo -n "$TEST_OUTPUT" | rg -F SKIP) || SKIP=""

		FAIL_COUNT=$(echo -n "$FAIL" | wc -l)
		SKIP_COUNT=$(echo -n "$SKIP" | wc -l)
		PASS_COUNT=$(echo -n "$PASS" | wc -l)

        if [[ $FAIL_COUNT -gt 0 ]]; then
            echo "$FAIL" | colorize_go_tests
            echo
        fi

		echo "$PASS_COUNT PASS; $FAIL_COUNT FAIL; $SKIP_COUNT SKIP"
		echo
    fi
}

function tmp_file {
    FILE_NAME="/tmp/tmp-$RANDOM"
    $EDITOR $FILE_NAME
    echo "$FILE_NAME"
}

function drop_top {
    DROP_LINES="$@"
    if [[ -z "$DROP_LINES" ]] {
        DROP_LINES=1
    }

    awk '{ if (NR > '"$DROP_LINES"') print $0 }'
}

function replace_all {
    PATTERN="$1"
    REPLACEMENT="$2"

	# GNU sed on Linux machines is invoked using the sed command
	command -v sed >/dev/null 2>&1 &&
		sed --version | head -1 | grep -q GNU &&
		cmd='rg -l "'$PATTERN'" | xargs sed -i -e "s/'$PATTERN'/'$REPLACEMENT'/g"'

	if [[ -z "$cmd" ]];
	then
		# GNU sed on Mac OS machines is invoked using gsed
		# Default sed on Mac OS machines is BSD sed which has slightly different options
		command -v gsed >/dev/null 2>&1 &&
			cmd='rg -l "'$PATTERN'" | xargs gsed -i -e "s/'$PATTERN'/'$REPLACEMENT'/g"' ||
				cmd='rg -l "'$PATTERN'" | xargs sed -i "" -e "s/'$PATTERN'/'$REPLACEMENT'/g"'
	fi

    echo $cmd >&2
    eval $cmd
}

# hdate: print human-readable date
function hdate {
    date +%Y-%m-%d-%H-%M-%S
}

# dir_size: print the size of all sub directories of `pwd`
function dir_size {
    CMD="du -h --max-depth=1 2>/dev/null | sort -h"
    eval "$CMD"
}

# json_to_csv: convert json to csv
function json_to_csv {
    jq -r '(map(keys) | add | unique) as $headers | (map(. as $row | $headers | map($row[.]))) as $values | $headers, $values[] | @csv'
}

# current_ms: prints the number of milliseconds since the epoch using Node
function current_ms {
    node -p -e 'new Date() - 0'
}

# time_cmd_base: print the time taken to run a command
function time_cmd_base {
    start_ms=`current_ms`
    eval "$@"
    end_ms=`current_ms`
    node -p -e "$end_ms-$start_ms + \" ms\""
}

alias time_cmd="time_cmd_base"

# time_cmd_null: like time_cmd, but send all output to /dev/null
function time_cmd_null {
    time_cmd "$@ 2>&1 > /dev/null"
}

function extensions {
	ls | $(awk_cmd) '{ split($0, a, "."); printf("%s\n", a[length(a)]); }' | sort | uniq -c
}

function extensions {
	ls -1 | awk -F'.' '{ print $NF }' | sort | uniq -c | sort -rh
}

function extensions_nested {
	find ${1:-.} -type f | awk -F'.' '{ print $NF }' | sort | uniq -c | sort -rh
}

function mg {
    source="$PWD" make -C "$ZDOTDIR" $@
}

function path_split {
    echo $PATH | awk '{ split($0, a, ":"); for (b in a) { print a[b] } }';
}

function next_version {
    perl -e '
my $o = `git tag --sort=-version:refname`;
my @a = split("\n", $o);
my $v = $a[0];
my @comp = split(/\./, $v);
print join(".", (0, $comp[1] + 1, 0))
'
}

function create_next_tag {
    git stash && \
        git checkout master && \
        git remote update && \
        git merge origin/master

    current=$(git tag --sort=-version:refname | head -1)
    top_commit=$(git log --pretty=format:'(%h) %an on %ai: %s' --date=short | head -1)
    tag=$(next_version)

    cat <<EOF

---

Current version: $current
Top commit: $top_commit

New version: $tag

Should the new version be created? (y/N)
EOF

    read decision

    if [[ "$decision" != "y" ]];
    then
        echo "BYE"
        return 0
    fi

    echo "OKAY"
    git tag $tag
    git push origin $tag
    echo "BYE"
}

# last-cmd: Prints the last command that was run using the zsh shell
# This will not work for other shells.
function last-cmd {
	if [[ -z "$HISTFILE" ]];
	then
		echo "ERROR: HISTFILE environment variable is not defined."
		return 1
	fi

    tail -2 $HISTFILE | \
        head -1 | \
        $(awk_cmd) -F';' '{ b = index($0, ";"); print substr($0, b+1) }'
}

# copy: Get the command run right before this function; run it again and copy
# the output to the clipboard
#
# parameters: accepts 1 parameter
#   first parameter values:
#       empty (default) => copy the last command's stdout ONLY
#       non-empty => copy the last command's stdout and stderr
function copy {
    local last_cmd=$(last-cmd)
    local copy_err=$1
    echo "Rerun: $last_cmd"

    local out="${TMPDIR:-/tmp/}$RANDOM"
    local last_cmd_file="${TMPDIR:-/tmp/}$RANDOM"

    rm -f $out
    rm -f $last_cmd_file

    echo "\$ $last_cmd" > $last_cmd_file

    if [[ -z "$copy_err" ]];
    then
        eval $last_cmd 1>$out 2>/dev/null
    else
        eval $last_cmd 1>$out 2>&1
    fi

    cat $last_cmd_file $out | pbcopy
}

# yron: Get the gron output for the given YAML file
function yron {
    INPUT=$1
    cat $INPUT | yq e - -j | gron
}

# top-fzf: Look at the top output for a single process
#
# Works only with Mac's top command. Linux' top command takes the parameter "-p", figure out how to
# detect the system and adapt to it.
function top-fzf {
	top -p $(ps-fzf)
}

# ps-fzf
#
# Select a process using the fuzzy search tool fzf
function ps-fzf {
	ps aux | fzf --header-lines 1 | col2
}

# exchange_rate
#
# Print the exchange rate between the source and destination currencies
#
# Command: exchange_rate INR USD
# Output: 1 INR = 0.0129441 USD
function exchange_rate {
	local SRC=$1
	local DEST=$2
	if [[ -z $SRC || -z $DEST ]];
	then
		echo "ERROR: Usage example: exchange_rate INR USD" >&2
		return 42
	fi

	curl \
		-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:100.0) Gecko/20100101 Firefox/100.0' \
		-H 'Referer: https://www.xe.com/' \
		"https://www.xe.com/currencyconverter/convert/?Amount=100&From=$SRC&To=$DEST" -s | \
		rg --only-matching "[\d.]+ $SRC = [\d.]+ $DEST" | \
		rg --invert-match "= 0 $DEST$"
}

function exchange_rate_number {
	local output=$(exchange_rate $1 $2)
	echo $output | $(awk_cmd) -F'=' '{ print $2 }' | $(awk_cmd) '{ print $1 }'
}

function time_simple {
	local start=$(date +%s);
	date >&2;
	eval $@;
	local end=$(date +%s);
	date >&2;
	echo "$(($end-$start)) seconds" >&2;
}

function separate-extensions {
	local go="$1"
	if [[ -z "$go" ]];
	then
		echo "Usage: separate-extensions [--go]"
	fi

	if [[ "$go" != "--go" ]];
	then
		echo "INFO: Dry-run mode."
	fi

	ls -1 | awk -F\. '{ print $(NF) }' | sort -u | while read extension;
	do
		if [[ -d "$extension" ]];
		then
			echo "WARNING: Files with the extension \"$extension\" will not be moved because the directory \"$extension\" exists already."
		else
			local cmd="mkdir -p \"$extension\" && fdfind -e \"$extension\" | xargs -I{} mv {} \"$extension/\""
			echo $cmd
			if [[ "$go" == "--go" ]];
			then
				eval $cmd;
			fi
		fi
	done
}
