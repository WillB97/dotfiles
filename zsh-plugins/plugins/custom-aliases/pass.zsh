# vim:ft=zsh
# alias pw="pass -c "
# pw() { pass show -c "$1" 2>/dev/null || pass find "$@" }
pw() {
	pass show -c "$1" 2>/dev/null && return
	local PREFIX="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
	local terms="*$(printf '%s*|*' "$@")"
	PASS_FILT="$(find $PREFIX -ipath "${terms%|*}" |awk -v DIR="$PREFIX" '/.gpg/{sub(DIR "/","");sub(".gpg","");print $0}')"

	if [[ "$(echo $PASS_FILT | wc -l)" -eq 1 ]]; then
		if [[ "$(echo $PASS_FILT |wc -m)" -eq 1 ]]; then
			echo "Not found"
		else
			read -k1 -s "PASS_TEST?$PASS_FILT [Y/n]";
			[[ $PASS_TEST =~ ^[yY]$ ]]||[[ $PASS_TEST == $'\n' ]] && pass show -c "$PASS_FILT"
			unset PASS_TEST
		fi
	else
		pass find "$@"
	fi
}
compdef _pass pw=pass-show

alias pg="pass generate -c "
alias pe="pass edit "
export PASSWORD_STORE_GENERATED_LENGTH=12
