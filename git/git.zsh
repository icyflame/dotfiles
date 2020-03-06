# git <3

# gst : Status of the repository
alias gst="git status"

# gb
alias gb="git branch"

# gbl
alias gbl="git branch --color | cat"

# gc
alias gc="git commit"
alias gca="git commit --amend"

# ga
alias ga="git add"

# gd
alias gd="git diff"

# gdls: List all the file which have changed between the current branch and the
# branch provided as the first parameter (or master, by default)
function gdls() {
    git --no-pager diff --name-only ${1:-master}
}

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

# gcshallow: clone a repository, but only the top commit of a single branch
# this is much faster when you just want to build a repository and don't want
# to download the commit history
function gcshallow {
    local branch="$2"
    local remote="$1"
    if [[ -z "$branch" || -z "$remote" ]]; then
        echo "ERROR: gcshallow remote-url branch-name"
        return 42
    fi
    git clone --single-branch --depth=1 --branch="$branch" "$remote"
}

# returns the current branch that you are on
function git-current-branch {
    git rev-parse --abbrev-ref HEAD
}

# push to $1/current-branch
# will not push if current-branch =~ master
function gpc {
    remote="$1"
    forced="$2"
    current_branch=`git-current-branch`
    if [[ "$current_branch" =~ ".*master.*" ]]; then
        echo "Current branch $current_branch is master! can not push directly to master!"
        return 255
    fi

    echo "Pushing to $remote/$current_branch"

    if [[ "$forced" = "--force" ]]; then
        git push "$remote" --force $current_branch;
    else
        git push "$remote" $current_branch;
    fi
}

function gpoc {
    gpc "origin"
}

function gpofc {
    gpc "origin" "--force"
}

function gpic {
    gpc "icyflame"
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

function gup {
    BRANCH="$1"
    STRATEGY="$2"
    current_branch=`git-current-branch`
    if [[ "$current_branch" =~ ".*master.*" ]]; then
        echo "Current branch is master!"
        return 255
    fi
    git remote update
    git checkout "$BRANCH"
    git merge
    git checkout -
    if [[ "$STRATEGY" == "rebase" ]]; then
        git rebase "$BRANCH"
    else
        git merge "$BRANCH"
    fi
}

function fix_conflicts {
    FILES=$(git ls-files -u | col4 | sort -u | paste -s -d' ' -)
    if [[ -z "$FILES" ]];
    then
        echo "No unmerged files"
        return 0
    fi
    $EDITOR $FILES
}
