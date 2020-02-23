
PROMPT_DIR_MAX_LEVELS=2
PROMPT_DIR_MAX_LENGTH=25
PROMPT_ENDING="❯"
PROMPT_VI_ENDING="❮"

pureness_response() {
  PROMPT="$(<&$1)" # output the contents of the file descriptor from $1 into the prompt
  zle reset-prompt # refresh the displayed prompt

  zle -F $1 # remove the handler for the file descriptor
  exec {1}<&- # Close the fd
}

prompt_pureness_precmd() {
  local prompt_pureness_preprompt_start=""
  local prompt_pureness_preprompt_end=""
  typeset -g _ZSH_PURENESS_ASYNC_FD _ZSH_PURENESS_CHILD_PID

  # jobs
  prompt_pureness_preprompt_start+='%1(j.%F{blue}%j%f .)'

  # virtualenv
  # Disallow python virtualenv from updating the prompt, set it to 12 if
  # untouched by the user to indicate that Pure modified it. 
  export VIRTUAL_ENV_DISABLE_PROMPT=${VIRTUAL_ENV_DISABLE_PROMPT:-12}
  if [[ -n "$VIRTUAL_ENV" ]]; then
    prompt_pureness_preprompt_start+="%F{cyan}(${VIRTUAL_ENV##*/})%f "
  fi

  # username
  if [[ -n "$SSH_CONNECTION" ]]; then
    prompt_pureness_preprompt_start+='%(!.%F{yellow}%n%f.%n)@%m '
  else
    prompt_pureness_preprompt_start+='%(!.%F{yellow}%n%f .)'
  fi

  # directory
  if [[ -w $PWD ]]; then # change colour if writeable
    prompt_pureness_preprompt_start+="%F{blue}%$PROMPT_DIR_MAX_LENGTH<...<%$PROMPT_DIR_MAX_LEVELS~%<<%f "
  else
    prompt_pureness_preprompt_start+="%F{red}%$PROMPT_DIR_MAX_LENGTH<...<%$PROMPT_DIR_MAX_LEVELS~%<<%f "
  fi

  # prompt char colour depends on previous return code
  prompt_pureness_preprompt_end+='%(?.%F{green}.%F{red})${PROMPT_ENDING}%f '

  PROMPT="$prompt_pureness_preprompt_start$prompt_pureness_preprompt_end"

  # If we've got a pending request, cancel it
  if [[ -n "$_ZSH_PURENESS_ASYNC_FD" ]] && { true <&$_ZSH_PURENESS_ASYNC_FD } 2>/dev/null; then
    # Close the file descriptor and remove the handler
    exec {_ZSH_PURENESS_ASYNC_FD}<&-
    zle -F $_ZSH_PURENESS_ASYNC_FD
    kill -TERM $_ZSH_PURENESS_CHILD_PID 2>/dev/null
  fi

  exec {_ZSH_PURENESS_ASYNC_FD}< <( # run the function asynchronously, outputting to fd
    echo $sysparams[pid] # Tell parent process our pid

    # check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null && {
      prompt_branch="$(git symbolic-ref --short HEAD)" 2>/dev/null || prompt_branch="$(git rev-parse --short HEAD)"
      prompt_git_status=""
      [[ $(git ls-files --others --exclude-standard --directory |wc -l) -ne 0 ]] && prompt_git_col="%F{green}" || prompt_git_col="%F{yellow}" # test if repo has untracked files
      command git diff --no-ext-diff --quiet --exit-code || prompt_git_status+="*" # test if repo has unstaged files
      command git diff --no-ext-diff --cached --quiet --exit-code || prompt_git_status+="+" # test for staged files
      prompt_pureness_git="%F{cyan}git%f:$prompt_git_col$prompt_branch%F{yellow}$prompt_git_status%f "

      echo -n "$prompt_pureness_preprompt_start$prompt_pureness_git$prompt_pureness_preprompt_end"
    } || echo -n "$prompt_pureness_preprompt_start$prompt_pureness_preprompt_end"
  )

  read _ZSH_PURENESS_CHILD_PID <&$_ZSH_PURENESS_ASYNC_FD # Read the pid from the child process
  zle -F $_ZSH_PURENESS_ASYNC_FD pureness_response # install a handler for the file descriptor


}

# vi-mode normal mode indicator
function zle-keymap-select zle-line-init () {
  # detect if we're using bindkey -v
  if bindkey -lL | awk '/-A/{if($3=="viins"){exit 0}else{exit 1}}'; then
    # beam cursor for viins mode
    if [[ ${KEYMAP} == vicmd ]]; then
      PROMPT="${PROMPT/PROMPT_ENDING/PROMPT_VI_ENDING}"
      echo -ne '\e[1 q' # block cursor
    else
      PROMPT="${PROMPT/PROMPT_VI_ENDING/PROMPT_ENDING}"
      echo -ne '\e[5 q' # beam cursor
    fi
    zle reset-prompt
  fi
}

prompt_pureness_setup() {
  # prevent percentage showing up
  # if output doesn't end with a newline
  export PROMPT_EOL_MARK=''
  if [[ -n "$PROMPT_UNICODE" ]] && [[ "$PROMPT_UNICODE" -eq "0" ]]; then
    PROMPT_ENDING=">"
    PROMPT_VI_ENDING="<"
  fi

  autoload -Uz add-zsh-hook
  add-zsh-hook precmd prompt_pureness_precmd

  # vi-mode indicator
  zle -N zle-keymap-select
  zle -N zle-line-init
}

prompt_pureness_setup "$@"