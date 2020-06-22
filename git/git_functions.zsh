gs () {
    $Q=${1:-""}
    git show $(git-fzf log -q "$Q")
}

gbdeltemp() {
    git --no-pager branch | ag -v master | col1 | ag "^temp" | while read b; do git branch -D "$b"; done;
}

gco () {
    if [[ "$#" -eq 0 ]];
    then
        git checkout $(git branch --format '%(refname:short)' | fzf)
    else
        if [[ "$#" -ge 1 ]];
        then
            git checkout $@
        fi
    fi
}

