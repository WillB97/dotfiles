#!/bin/bash

if [[ `uname` != "Linux" ]]; then
	echo "This automated saving is not supported on your operating system"
	exit 2
fi

cd "$(dirname $0)"
trap "rm -rf $MYTMPDIR" EXIT
MYTMPDIR=$(mktemp -d -p $PWD) || exit 1

echo 'Saving ~/.ssh/'
[ -d ~/.ssh ] && cp -a ~/.ssh $MYTMPDIR/ssh
echo 'Saving ~/.cert/'
[ -d ~/.cert ] && cp -a ~/.cert $MYTMPDIR/cert
echo "Saving gnome keyrings"
[ -d ~/.local/share/keyrings ] && cp -a ~/.local/share/keyrings $MYTMPDIR/keyrings
echo "Saving password store"
[ -d ~/.password-store ] && cp -a ~/.password-store $MYTMPDIR/password-store

echo 'Save gpg keys and trust'
mkdir $MYTMPDIR/gpg/
gpg --export -a > $MYTMPDIR/gpg/public.asc
gpg --export -a > $MYTMPDIR/gpg/secret.asc
gpg --export-ownertrust > $MYTMPDIR/gpg/trustdb

echo 'Saving wifi network credentials (Requires sudo)'
sudo sh -c "
    [ -d /etc/NetworkManager/system-connections ] &&
        cp -a /etc/NetworkManager/system-connections $MYTMPDIR/wifi &&
        chown -R \$SUDO_USER:\$SUDO_USER $MYTMPDIR/wifi
    echo Saving root\'s .ssh/
    [ -d /root/.ssh ] &&
        cp -a /root/.ssh $MYTMPDIR/root_ssh &&
        chown -R \$SUDO_USER:\$SUDO_USER $MYTMPDIR/root_ssh
"
# compress and encrypt
tar -czC $MYTMPDIR . | gpg --symmetric --cipher-algo AES256 > saved.tar.gz.gpg
# remove tmp dir
rm -rf $MYTMPDIR