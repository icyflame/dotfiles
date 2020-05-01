gs () {
    $Q=${1:-""}
    git show $(git-fzf log -q "$Q")
}
