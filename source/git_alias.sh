# GIT ALIASES & FUNCTIONS

alias ga="git add"
alias gaa="git add -A"
alias gb="git branch"
alias gcm="git commit -m"
alias gco="git checkout"
alias gd="git diff"
alias glog="git log --oneline --graph --decorate"
alias gp="git push"
alias gpr="git pull --rebase"
alias gs="git status"

gf() {
  git add -A
  git commit -m update
  git push
}
