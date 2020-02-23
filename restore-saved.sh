#!/bin/bash

if [[ `uname` != "Linux" ]]; then
	echo "This automated saving is not supported on your operating system"
	exit 2
fi

if ! [ -f saved.tar.gz.gpg ]; then
	echo "saved.tar.gz.gpg needs to be in this directory"
	exit 2
fi

cd "$(dirname $0)"
trap "rm -rf $MYTMPDIR" EXIT
MYTMPDIR=$(mktemp -d -p $PWD) || exit 1

echo "Extracting saved.tar.gz.gpg"
gpg --decrypt saved.tar.gz.gpg | tar -xzC $MYTMPDIR

if [ -d $MYTMPDIR/ssh ];then
    echo 'Restoring ~/.ssh/'
    [ -d ~/.ssh ] || mkdir ~/.ssh
    cp -a $MYTMPDIR/ssh/* ~/.ssh
fi
echo 'Restoring ~/.cert/'
[ -d $MYTMPDIR/cert ] && cp -a $MYTMPDIR/cert/* ~/.cert
echo "Restoring gnome keyrings"
[ -d $MYTMPDIR/keyrings ] && cp -a $MYTMPDIR/keyrings/* ~/.local/share/keyrings
echo "Restoring password store"
[ -d $MYTMPDIR/password-store ] && cp -a $MYTMPDIR/password-store/* ~/.password-store

if [ -d $MYTMPDIR/gpg ]; then
    echo 'Restoring gpg keys and trust'
    gpg --import $MYTMPDIR/gpg/public.asc $MYTMPDIR/gpg/secret.asc
    gpg --import-ownertrust $MYTMPDIR/gpg/trustdb
fi

echo 'Restoring wifi network credentials (Requires sudo)'
## correct MAC address?
sudo sh -c "
    [ -d $MYTMPDIR/wifi ] &&
        cp -a --no-preserve=ownership $MYTMPDIR/wifi/* /etc/NetworkManager/system-connections/
    echo Restoring root\'s .ssh/
    [ -d $MYTMPDIR/root_ssh ] &&
        cp -a --no-preserve=ownership $MYTMPDIR/root_ssh/* /root/.ssh
"
# remove tmp dir
rm -rf $MYTMPDIR