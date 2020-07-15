# git <3

# g
alias g="git"

# gdls: List all the file which have changed between the current branch and the
# branch provided as the first parameter (or master, by default)
function gdls() {
    CMD="git --no-pager diff --name-only ${1:-master} ${2:-}"
    echo "$CMD"
    eval "$CMD"
}

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

function gpic {
    gpc "icyflame"
}

# Delete all merged branches if the current branch _is_ master
# this command provides a `--dry-run` and `--force` option
function gbDm {
    forced="$1"
    dry_run="$1"
    current_branch=`git-current-branch`

    if [[ "$current_branch" =~ ".*master.*" || "$forced" = "--force" ]]; then
        git branch --merged | grep -v "master" | grep -v "$current_branch" | while read p; do
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
