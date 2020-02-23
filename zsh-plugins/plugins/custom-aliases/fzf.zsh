# vim:ft=zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_COMPLETION_TRIGGER='`'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="
  --color fg:-1,bg:-1,hl:33,fg+:254,bg+:235,hl+:33
  --color info:136,prompt:136,pointer:230,marker:230,spinner:136
  --preview-window wrap:hidden
  --preview '[[ \$(file --mime {}) =~ binary ]] \
    && ([[ -d {} ]] \
      && (echo {} is a directory; ls {}) \
      ||(echo {} is a binary file; file -b {})) \
    || bat --style=numbers --color=always {}'
  --bind 'ctrl-p:toggle-preview'"
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
export FZF_CTRL_R_OPTS="--preview 'echo {}' 
  --preview-window down:3:hidden:wrap
  --bind 'ctrl-p:toggle-preview'"
export FZF_ALT_C_OPTS="--select-1 --exit-0 
  --preview 'ls {} | head -200'
  --preview-window hidden:wrap
  --bind 'ctrl-p:toggle-preview'"
