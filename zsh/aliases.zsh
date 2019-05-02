alias less="less -Ri"

# serve port_number : Create a Simple HTTP Server
# Using Python. Port defaults to 8000.
alias serve_simple="python -m SimpleHTTPServer $1"
alias serve_php="php -S localhost:8000"
alias serve_django="python manage.py runserver"

# copy output of a command to the clipboard
# solve stats | clip
# then use Ctrl+V to paste
alias clip="xclip -selection clipboard"

# utility : thefuck
alias fuck='$(thefuck $(fc -ln -1))'

# utility : show cron log, from syslog
alias cronlog='less /var/log/syslog | grep -i cron'

# todo.txt cli
alias t="bash todo.sh"

# OpenSubtitlesDownload.py
# https://github.com/emericg/OpenSubtitlesDownload
# alias findsub="python /usr/local/bin/OpenSubtitlesDownload.py"
alias findsub="subliminal download -l en $1"

# indenting PHP using vim
alias indent_all_php="find . -name '*.php' -printf \"echo -e \"G=gg\n:wq\n\" | vim %p\n\" | sh"

# find all todo tags in a folder
alias todo='ag "todo" .'

# getvideo : getvideo URL 
# URL : Video URL | Playlist URL | video on playlist URL
alias getvideo="youtube-dl -citk --max-quality FORMAT "

# terminal-wallet : NPM module
alias wd="wallet debit"
alias ws="wallet stats"

# heroku
alias hl="heroku logs --tail"

# prettify
alias prettify="js -s '' $1"

# ssh_direct
alias ssh_direct="ssh -o 'ProxyCommand none'"

# ssh_default
alias ssh_default="ssh -o 'ProxyCommand none' -p 22"

# ls_except
alias ls_except="ls -tr | head -n $((`ls -tr | wc -l`-1))"

# jqcl
alias jqcl="jq -C . | less"

# c = clear
alias c="clear"

# watch ...: make watch work with aliases
alias watch="watch "
