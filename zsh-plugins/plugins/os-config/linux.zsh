# vim:ft=zsh
# os-linux
if [[ `uname 2> /dev/null` != "Linux" ]] || [[ `uname -a 2> /dev/null` =~ "Android|Microsoft|Darwin" ]]; then # Termux & wsl report Linux
    echo "This doesn't seem to be linux"; else

: "${ZSH_THEME:=pureness}" # default to pureness

function battery(){
upower -d |grep -E 'Device|energy:|energy-rate|time to empty|time to full|energy-full:|voltage:|%'
}

function open() {
for i; do
    setsid nohup xdg-open $i > /dev/null 2> /dev/null
done
}
function open-set() {
mime_var="$(xdg-mime query filetype $2)"
xdg-mime default $1 "$mime_var"
}
function gopen () {
TYPE_OVERRIDES=( application/x-shellscript text/plain application/octet-stream )
PROG_OVERRIDES=()
IFS='|'
for x in "$TYPE_OVERRIDES"; do
    PROG_OVERRIDES+=( $(xdg-mime query default "$x") )
done
for i; do
    if [ file --mime "$i" =~ "binary" ]; then
    open "$1"
    else
    TYPE=" $(xdg-mime query filetype $i)"
    if [ "$TYPE" =~ "${TYPE_OVERRIDES[@]}" ]; then
        $EDITOR "$i"
    else
        DEFAULT_PROG="$(xdg-mime query default $TYPE)"
        if [ "$DEFAULT_PROG" == "" ] || [[ $DEFAULT_PROG =~ "${PROG_OVERRIDES[@]}" ]]; then
        $EDITOR "$i"
        else
        open "$i"
        fi
    fi
    fi
done
}

function yt-vlc() {
	# i3-msg -q exec "youtube-dl -o - $1 |vlc - --play-and-exit"
	i3-msg -q exec "~/.bin/yt-vlc-worker $1"
}

alias kb="xinput | grep -E 'OBINLB|AnnePro2.*Keyboard'|sed 's/^.*id=\([0-9]*\).*$/\1/'|xargs -I% sh -c \"setxkbmap -device % us\""

# list out os specific aliases
function os_help () {
    echo "battery\tview battery stats"
    echo "open\topen files in appropriate programs"
    echo "open-set <program> <file>\tset program to open filetype with"
    echo "gopen\tlike open with overrides to load certain types with \$EDITOR"
    echo "kb\tset anne pro 2 to us layout"
}
fi
