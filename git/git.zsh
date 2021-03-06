# git <3

# g
alias g="git"

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

function git_pattern_do {
    local action="$1";
    local pattern="$2";
    local porcelain_pattern="";
    case $action in
        "add")
            porcelain_pattern='^\sM'
            ;;
        "reset")
            porcelain_pattern='^M\s'
            ;;
    esac

    if [[ -z "$action" || -z "$pattern" || -z "$porcelain_pattern" ]];
    then
        echo "FAILED: action, pattern, porcelain_pattern should be non-empty"
        return 41
    fi

    CMD="git status --porcelain --untracked=no | gawk '/$porcelain_pattern/ { print \$2 }' | grep $pattern | xargs git $action";
    echo $CMD
    eval $CMD
}

function git_add_pattern {
    git_pattern_do "add" "$1"
}
alias gap="git_add_pattern"

function git_reset_pattern {
    git_pattern_do "reset" "$1"
}
alias grp="git_reset_pattern"
