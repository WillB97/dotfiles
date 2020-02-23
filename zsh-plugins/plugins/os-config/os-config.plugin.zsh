# vim:ft=zsh
# os-config

OS_CONFIG_DIR="${0:h}"
if [[ `uname 2> /dev/null` == "Darwin" ]]; then # mac
    [ -f "$OS_CONFIG_DIR/mac.zsh" ] && source "$OS_CONFIG_DIR/mac.zsh"
elif [[ `uname -r 2> /dev/null` =~ "Microsoft" ]]; then # wsl
    [ -f "$OS_CONFIG_DIR/wsl.zsh" ] && source "$OS_CONFIG_DIR/wsl.zsh"
elif ! [[ `uname -a 2> /dev/null` =~ "Android|Microsoft|Darwin" ]] && [[ `uname 2> /dev/null` == "Linux" ]]; then # Linux
    [ -f "$OS_CONFIG_DIR/linux.zsh" ] && source "$OS_CONFIG_DIR/linux.zsh"
fi
unset OS_CONFIG_DIR