" vim: fdm=marker foldenable sw=4 ts=4 sts=4
" "zo" to open folds, "zc" to close, "zn" to disable.

" {{{ Plugins and Settings
" Pathogen is used to handle plugins.
" https://github.com/tpope/vim-pathogen

" {{{ PATHOGEN SETUP
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete
if isdirectory(expand("~/.vim/autoload"))
	execute pathogen#infect()
	execute pathogen#helptags()
	" hide gitignore'd files
	let g:netrw_list_hide=netrw_gitignore#Hide()
	" hide dotfiles by default (this is the string toggled by netrw-gh)
	let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
    " don't hide the mode if airline is not being used
    set noshowmode
endif
" }}}

" {{{ Plugins
" vim-airline
let g:airline_powerline_fonts = 1
set ttimeoutlen=10
" Fix URxvt unicode issues
" let g:airline_symbols = {'space': ' ', 'paste': 'PASTE', 'maxlinenr': ' ¶'}
" let g:airline_symbols.notexists = 'Ɇ'
" let g:airline_symbols.linenr = 'Ξ'
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.spell = 'SPELL'
" let g:airline_symbols.modified = '+'
" let g:airline_symbols.keymap = 'Keymap:'
" let g:airline_symbols.crypt = '☯'
" let g:airline_symbols.branch = ''
" let g:airline_symbols.whitespace = '↹'

" vim-surround: s is a text-object for delimiters; ss linewise; ys to add surround
" vim-commentary: gc is an operator to toggle comments; gcc linewise
" vim-repeat: make vim-commentary and vim-surround work with .
" }}}

" {{{ netrw: Configuration
let g:netrw_banner=0        " disable banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_winsize = 25
let g:netrw_bufsettings = "noma nomod nu nobl nowrap ro rnu"
" }}}
" }}}

" {{{ Basic Settings
" Modelines
set modelines=2
set modeline

" For clever completion with the :find command
set path+=**

" Always use bash syntax for sh filetype
let g:is_bash=1

" General pleasantries
set confirm
inoremap <S-Tab> <c-n> " Shift-tab for completion
if has('mouse') " avoid errors when git uses a basic vim
    set mouse=a        " enable mouse support
endif
set ruler              " show the cursor position all the time
set showcmd            " display incomplete command
set laststatus=2       " Always display the status line
set autoread           " Reload files changed outside vim
syntax enable

" Line numbers
set number
set relativenumber

" Search
set ignorecase smartcase hlsearch incsearch
nnoremap <silent> <leader>, :noh<cr> " Stop highlight after searching

" Splits
set splitbelow " I have tall terminals

" Buffers
set history=10000 " keep the max command and search history
set hidden " stop vim forcing you to save a buffer before opening a file
set undofile " save the undo tree
set undodir="~/.vim/undo/" " keep all the undo trees in a directory

" Spelling
set spelllang=en_gb
" set dictionary+=/usr/share/dict/words

" Typing behavior
set backspace=indent,eol,start " backspace across newlines and indent in insert
set showmatch " breifly jump to matching bracket on insertion
set wildmode=full " make a completion list pop up
set wildmenu
set complete-=i " don't complete with words from included files
set complete+=d,kspell " complete with defined names and macros from included or from spelling

" Formatting
set nowrap
set tabstop=4 shiftwidth=4 softtabstop=4
if has('folding') " avoid errors when git uses a basic vim
    set foldlevelstart=2
endif
set list listchars=tab:» ,trail:·,nbsp:·,extends:#

" Session saving
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,localoptions

" Word splitting
set iskeyword+=-
" }}}

" Autocommands
augroup MyCmds
	" clear auto-commands from group to avoid multiple definitions
	autocmd! 

	" Tweak the color of the fold display column
	au ColorScheme * hi FoldColumn cterm=bold ctermbg=233 ctermfg=146

	" automatically rebalance windows on vim resize
	autocmd VimResized * :wincmd =

	" When editing a file, always jump to the last known cursor position.
	" Don't do it for commit messages, when the position is invalid, or when
	" inside an event handler (happens when dropping a file on gvim).
	autocmd BufReadPost *
		\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
		\ endif

	" Spaces Only
	au FileType swift,mustache,markdown,vim,html,htmldjango,css,sass,scss,javascript,coffee,ruby,eruby,systemverilog setl expandtab list
	au FileType python setl expandtab list softtabstop=2 shiftwidth=2 tabstop=2

	" Tabs Only
	au FileType c,h,cpp,hpp,sh,make setl foldmethod=syntax noexpandtab nolist
	au FileType gitconfig,apache,sql setl noexpandtab nolist

	" Folding
	au FileType html,htmldjango,css,sass,javascript,coffee,python,ruby,eruby setl foldmethod=indent foldenable
	au FileType json setl foldmethod=indent foldenable shiftwidth=4 softtabstop=4 tabstop=4 expandtab

	" Tabstop/Shiftwidth
	au FileType mustache,ruby,eruby,javascript,coffee,sass,scss setl softtabstop=2 shiftwidth=2 tabstop=2
	au FileType rst setl softtabstop=3 shiftwidth=3 tabstop=3
	au FileType systemverilog setl softtabstop=2 shiftwidth=2 tabstop=2 expandtab

	" Other
	au FileType python let b:python_highlight_all=1
	au FileType diary setl wrap linebreak nolist
	au FileType markdown setl linebreak spell
	au FileType markdown call MarkDownEquations()
	au FileType gitcommit setl textwidth=100 spell " Automatically wrap at 100 characters and spell check git commit messages
	au BufRead,BufNewFile *.md setl filetype=markdown
    au VimEnter * call SetupFileBrowser()
augroup END

" Key Mappings {{{
set pastetoggle=<F2>
function! SetupFileBrowser() " this needs to be called after plugins have loaded
    if exists(":Lexplore")
        nnoremap <F3> :Lexplore<CR> " toggle netrw browser to left
    else
        nnoremap <F3> :Vexplore<CR> " toggle netrw browser to left
    endif
endfunction
nnoremap <F4> :retab<CR>:%s/\s\+$//e<CR><C-o>         " fix whitespace
nnoremap <F5> :syn sync fromstart<CR>                 " fix syntax highlighting
nnoremap <F6> "=strftime("%-l:%M%p")<CR>P             " Insert timestamp
inoremap <F6> <C-r>=strftime("%-l:%M%p")<CR>          " Insert timestamp
nnoremap <F7> "=                                      " do maths
nnoremap <C-s> yyp!!bash<CR>                          " Run shell command and append output
vnoremap <C-s> yp!!bash<CR>                           " Run shell command and append output
vnoremap ,case :s/\v\C(([a-z]+)([A-Z]))/\2_\l\3/g<CR> " camelCase => camel_case
vnoremap ,camel :s/(_).\/\U&/g<CR>                    " camel_case => camelCase
nnoremap ,<TAB> :set et! list!<CR>                    " Swap tab/space mode

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Navigate properly when lines are wrapped
nnoremap j gj
nnoremap k gk

" Movement between buffers
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprev<CR>

if has('clipboard') " Sane copy and pasting (with +clipboard, avoiding C-v visual block)
	inoremap <C-v> <C-o>"+P<C-o>=']
	vnoremap <C-v> "+P=']
	vnoremap <C-c> "+y
else " for vim with -clipboard
	vnoremap <silent> <C-c> :'<,'>:w !xclip -i -sel c<CR>
endif

" Generate ctags function
command! MakeTags !ctags -R .
" }}}

" Typing MathJax is effort
function! MarkDownEquations()
    inoremap <tab>eq \\(\\)<C-o>T(
    inoremap <tab>fr {\over}<C-o>T{
    inoremap <tab>` <C-o>f}<space>
endfunction
