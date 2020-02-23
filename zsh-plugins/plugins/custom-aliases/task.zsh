# vim:ft=zsh
# taskwarrior aliases
alias t='task'
alias ta='task add'
alias tm='task modify'
alias td='task done'
alias trm='task delete'
alias tn='task next'

if [[ `type entr 2> /dev/null` ]]; then
    alias tw='ls ~/.task/*.data | entr -c task next'
    alias twt='ls ~/.task/*.data | entr -c task +TODAY next'
else
    alias tw='watch "task next"'
    alias twt='watch "task +TODAY next"'
fi
