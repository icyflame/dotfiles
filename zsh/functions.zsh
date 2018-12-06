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
    echo $(($@));
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
    if [[ -x `which curl` ]]; then
        curl icanhazip.com
    else
        if [[ -x `which wget` ]]; then
            wget -q -O- icanhazip.com
        else
            echo "curl and wget not found"
        fi
    fi
}

function copy_commit {
    COMMIT=$@
    git log -1 $COMMIT | head -n5 | clipcopy;
}

function next_screenshot {
    PICTURE=`ls -t ~/Pictures/Screenshot*.png | head -n1`
    echo "Moving $PICTURE to public/img/$1"
    mv $PICTURE public/img/$1
    xdg-open "public/img/$1"
}

function last_screenshot {
    PICTURE=`ls -t ~/Pictures/Screenshot*.png | head -n1`
    echo "Moving $PICTURE to public/img/$1"
    mv $PICTURE $1
    xdg-open "$1"
}

function random_ep {
    COMMAND="find -iname \"*.avi\" -o -iname \"*.mkv\" -o -iname \"*.mp4\" -o -iname \"*.flv\" | shuf | head -n1";
    FILE="`eval $COMMAND`";
    echo $FILE;
    echo $FILE >> ~/random_ep.log;
    vlc $FILE;
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
