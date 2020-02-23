# vim:ft=zsh
# os-mac
# if [[ `uname 2> /dev/null` != "Darwin" ]]; then exit 1; fi

export PATH=$HOME/esp/xtensa-esp32-elf/bin:/usr/local/share/python:$PATH
: "${ZSH_THEME:=pureness}" # default to pureness
export ZSH_DISABLE_COMPFIX=true
alias cpass="PASSWORD_STORE_DIR=~/.cslib_pass pass"
alias cpw="PASSWORD_STORE_DIR=~/.cslib_pass pass -c "
alias -g Q="|head -n1|qrencode -t utf8|awk 'NR==1{print \"\x1B[?1049h\"} {print} END{print \"\n\npress any key to continue\"}' - ; read -k1 -s ; echo -e '\e[?1049l'"

# Open the current directory in a Finder window
alias ofd='open_command $PWD' # open dir in finder

function pwdf() { # pwd finder dir
    osascript 2>/dev/null <<EOF
    tell application "Finder"
        return POSIX path of (target of window 1 as alias)
    end tell
EOF
}

function pfs() { # print finder selecton
    osascript 2>/dev/null <<EOF
    set output to ""
    tell application "Finder" to set the_selection to selection
    set item_count to count the_selection
    repeat with item_index from 1 to count the_selection
        if item_index is less than item_count then set the_delimiter to "\n"
        if item_index is item_count then set the_delimiter to ""
        set output to output & ((item item_index of the_selection as alias)'s POSIX path) & the_delimiter
    end repeat
EOF
}

function cdf() { # cd to finder dir
    cd "$(pwdf)"
}

function quick-look() { # Quick-look file
    (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}
alias ql='quick-look'

# Show/hide hidden files in the Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Remove .DS_Store files recursively in a directory, default .
function rmdsstore() {
    find "${@:-.}" -type f -name .DS_Store -delete
}
# list out os specific aliases
function os_help () {
    echo -e "ofd\topen dir in finder"
    echo -e "pwdf\tpwd finder directory"
    echo -e "pfs\tprint finder selection"
    echo -e "cdf\tcd to finder directory"
    echo -e "ql <file>\tquick-look file"
    echo -e "showfiles\tshow hidden files in finder"
    echo -e "hidefiles\thide hidden files in finder"
    echo -e "rmdsstore [dir]\trecursively remove .DS_Store files"
}
alias osx_help="os_help"