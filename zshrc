# Path to oh-my-zsh installation.
export ZSH="/home/alistairquinn/.oh-my-zsh"

# ZSH_THEME="miloshadzic"
ZSH_THEME="jbergantine"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# actually useful ones
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias lg="lazygit"
alias reload=". ~/.zshrc"
alias co='cd ~/.config/'
alias nv='cd ~/.config/nvim/'
alias v='nvim'
alias ga='git add .'
alias c='clear'
alias gp='git push origin main'
alias gs='git status'
alias gl='git log --oneline'
alias hard='git reset --hard head'
alias main='git switch main'
alias z='nvim ~/.zshrc'
alias kill='pkill node'
alias dev='npm run dev'
alias build='npm run build'
alias pull='git pull --ff-only'
alias ip='ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2'