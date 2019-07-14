# git <3

# gst : Status of the repository
alias gst="git status"

# gb
alias gb="git branch"

# gbl
alias gbl="git branch --color | cat"

# gc
alias gc="git commit"

# ga
alias ga="git add"

# gd
alias gd="git diff"

# gr
alias gr="git remote"

# gm
alias gm="git merge"

# gp
alias gp="git push"

# gco
alias gco="git checkout"

# gru
alias gru="git remote update"

# gpoa : Push all branches to origin
alias gpoa="git push origin --all"

# gpot : Push all tags to origin
alias gpot="git push origin --tags"

# gpia : Push all branches to the fork
alias gpia="git push icyflame --all"

# gru : Remote the status of all remote repositories
alias gru="git remote update"

# glod : Decorated one line log (Shows the short SHA of each commit)
alias glod="git log --oneline --decorate"

# pl : Pretty git log for humans. (Name on Date : Commit subject)
alias pl="git log --pretty=format:'(%h) %an on %ai: %s' --date=short"

# gpo/u/h : git push aliases
alias gpo="git push origin"
alias gpu="git push upstream"
alias gph="git push heroku"
alias gpi="git push icyflame"

alias hpr="hub pull-request"

# returns the current branch that you are on
function git-current-branch {
    echo `git branch | ag '\*' | awk '{ print $2 }'`
}

# push to origin/current-branch if it is not master
# This command does NOT provide a --force option. You should run `gpo master` by
# hand if that is what you want to do.
function gpoc {
    current_branch=`git-current-branch`
    if [[ "$current_branch" =~ ".*master.*" ]]; then
        echo "Current branch $current_branch is master! can not push directly to master!"
        return 255
    fi

    echo "Pushing to $current_branch"

    git push origin $current_branch;
}

# delete all merged branches if the current branch _is_ master
# this command provides a `--dry-run` and `--force` option
function gbDm {
    forced="$1"
    dry_run="$1"
    current_branch=`git-current-branch`

    if [[ "$current_branch" =~ ".*master.*" || "$forced" = "--force" ]]; then
        git branch --merged | grep -v master | while read p; do
        if [[ "$dry_run" == "--dry-run" ]]; then
            echo "$p"
        else
            git branch -d "$p";
        fi
        done;
    else
        echo "Not on branch master; can't delete merged branches; run with --force if you want to do that"
    fi
}

alias gbDmd="gbDm --dry-run"

# gfm = git find merge commit => Prints the merge commit in which the given
# commit was merged into master
function gfm {
    git log --oneline master...$@ \
        --ancestry-path --merges | tail -n1
}
