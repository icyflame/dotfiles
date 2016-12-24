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
