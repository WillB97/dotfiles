# vim:ft=zsh
export PATH=$HOME/.bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Compilation flags
export ARCHFLAGS="-arch x86_64"

plugins=(
  ssh-agent	# ssh key auto-load
  colored-man-pages
  extract	# extract archive files
  dircycle	# directory stack manipulation
  git
  pip
  # pass # autocompletion
  # virtualenvwrapper # auto-enter virtual environments
  # my custom plugins
  custom-aliases
  os-config
)

# set prompt to use unicode
export PROMPT_UNICODE=1

# set autoloaded keys
zstyle :omz:plugins:ssh-agent identities MusicBot Pi3

# os-specific plugins
if [[ `uname 2> /dev/null` == "Darwin" ]]; then # mac
	plugins+=() # mac plugins
elif [[ `uname -r 2> /dev/null` =~ "Microsoft" ]]; then # wsl
	plugins+=() # wsl plugins
elif ! [[ `uname -a 2> /dev/null` =~ "Android|Microsoft|Darwin" ]] &&
	[[ `uname 2> /dev/null` == "Linux" ]]; then # Linux
	plugins+=( docker systemd fd ) # linux plugins
fi

source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# keep user's .bin at start of path
export PATH=$HOME/.bin:${PATH//$HOME\/.bin:/}

alias sshp="ssh -i ~/.ssh/MusicBot -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -J proxjump -l root"
alias scpp="scp -i ~/.ssh/MusicBot -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ProxyJump=proxjump"


export DEFAULT_USER='will'

[ -d ~/esp/esp-idf ] && export IDF_PATH=~/esp/esp-idf
if [ -d ~/work/Projects/pico/sdk ]; then
  export PICO_SDK_PATH=~/work/Projects/pico/sdk/pico-sdk
  export PICO_EXTRAS_PATH=~/work/Projects/pico/sdk/pico-extras
fi

cdpath=(. $HOME/work/Projects/)
