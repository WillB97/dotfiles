# vim:ft=zsh
# common aliases
alias zshrc='${=EDITOR} ~/.zshrc && . ~/.zshrc' # Quick access to the ~/.zshrc file, w/ reload
alias duf='du -sh'
#alias fd='find . -type d -name' # Find a directory with the given name
#alias ff='find . -type f -name' # Find a file with the given name

# global aliases
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g Q="|head -n1|qrencode -t utf8|awk 'NR==1{print \"\x1B[?1049h\"} {print} END{print \"\n\npress any key to continue\"}' - ; read -k1 -s ; echo -e '\e[?1049l'"
alias -g W='| wc -l'

# generate various character lists
alias alpha="echo {A..Z} {a..z} | tr -d ' '"
alias alphanum="echo {A..Z} {a..z} {0..9} | tr -d ' '"
alias ascii="echo {\!..~} | tr -d ' '"

# auto-select between listing a directory or viewing the file
unalias l
function l() { # list directories or cat files
    if [ -d "$1" ]; then
        ls -lh "$@"
    else
        if [[ `type bat 2> /dev/null` ]]; then
            bat "$@"
        else
            cat "$@"
        fi
    fi
}

# test if subdirectories are git repos
function repo_check {
	if [[ -z $1 ]]; then
		for file in */; do test -d "$file/.git" || echo "$file is not a git repo"; done
	else
		for file in $1/*/; do test -d "$file/.git" || echo "${${file%%/}##*/} is not a git repo"; done
	fi
}

CUSTOM_ALIAS_DIR="${0:h}"
: ${DISABLE_ALIAS:=()}
for alias_file in $CUSTOM_ALIAS_DIR/*.zsh; do
    [[ $0 == $alias_file ]] && continue
    local alias_name="${alias_file:t:r}" # test for disabled aliases
    [[ ${DISABLE_ALIAS[(ie)$alias_name]} -le ${#DISABLE_ALIAS} ]] || source "$alias_file"
done
unset CUSTOM_ALIAS_DIR
