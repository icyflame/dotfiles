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
gcc $@ && ./a.out
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

function getAllSubtitles {
for i in $@; do
	findsub "$i"
done;
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

function mfarkdown_to_pdf {
value=4
if [ $value -eq 4 ]
then
	echo "YAY!"
fi
}

function markdown_to_pdf {
FILE_NAME=$(echo $1 | cut -d . -f 1);
markdown $1 > "$FILE_NAME.html";
wkhtmltopdf "$FILE_NAME.html" "$FILE_NAME.pdf"
rm "$FILE_NAME.html"
}
