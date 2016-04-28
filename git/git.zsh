
# git <3

# gst : Status of the repository
alias gst="git status"

# gb
alias gb="git branch"

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
alias pl="git log --pretty=format:'%an on %cd: %s' --date=short" 

# gpo/u/h : git push aliases
alias gpo="git push origin"
alias gpu="git push upstream"
alias gph="git push heroku"
alias gpi="git push icyflame"
