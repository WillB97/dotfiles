# vim:ft=zsh
# os-wsl
# if ! [[ `uname -r 2> /dev/null` =~ "Microsoft" ]]; then exit 0; fi

if [ "${ZSH_THEME:=agnoster}" == "agnoster" ]: then # default to agnoster
    eval $(whence -f prompt_dir | sed 's/%~/%2~/')
    eval $(whence -f prompt_dir | sed 's/%~/%25<...<%2~%<</')
    VIRTUAL_ENV_DISABLE_PROMPT=12
fi

# list out os specific aliases
function os_help() {
    echo "No extra aliases in WSL"
}