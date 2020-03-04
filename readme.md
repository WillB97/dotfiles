# Dotfiles

A collection of my config files

### `gen-saved.sh`
Collects up private config files into a gpg encrypted archive.

Includes:
- user's .ssh/
- user's .cert/
- user's gnome keyrings
- user's .password-store/
- user's gpg
- wifi network creds
- root .ssh/

### `restore-saved.sh`
Restores encrypted archive to original locations

### `setup-links.sh`
symlink the config files from this repo to their places on the system

### `vim-setup.sh`
Downloads plugins into .vim folder

### Eduroam settings for network manager
    SSID: eduroam
    Security: WPA2-Enterprise
    Authentication: TTLS
    Anonymous identity: @<domain>
    Domain: <domain>
    No CA certificate is required
    Inner Authenication: MSCHAPv2 (no EAP)
    Username: <username>@<domain>
    Password: <password>