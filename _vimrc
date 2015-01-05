"" General
set number	" Show line numbers
set linebreak	" Break lines at word (requires Wrap lines)
"set showbreak=+++	" Wrap-broken line prefix
set textwidth=80	" Line wrap (number of cols)
set showmatch	" Highlight matching brace
set visualbell	" Use visual bell (no beeping)
 
set hlsearch	" Highlight all search results
set smartcase	" Enable smart-case search
set ignorecase	" Always case-insensitive
set incsearch	" Searches for strings incrementally
" Clear search when hitting enter in normal mode
nnoremap <CR> :nohlsearch<CR>/<BS><CR>

set autoindent	" Auto-indent new lines
set expandtab	" Use spaces instead of tabs
set shiftwidth=4	" Number of auto-indent spaces
set smartindent	" Enable smart-indent
set smarttab	" Enable smart-tabs
set softtabstop=4	" Number of spaces per Tab
 
"" Advanced
set ruler	" Show row and column ruler information
 
set undolevels=1000	" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour

filetype on
set nocompatible
 
syntax on

filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype
set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
set wildignore+=*.o,*.obj,.git,*.pyc

if exists("&colorcolumn")
    set colorcolumn=79
endif

set showmatch               " Briefly jump to a paren once it's balanced
set autoindent              " always set autoindenting on
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well

command W w
command Wq wq
command Q q
command Wqa wqa

" set bg=dark
" colorscheme torte
colorscheme molokai

" ===========================================================
" FileType specific changes
" ============================================================
" Mako/HTML
autocmd BufNewFile,BufRead *.mako,*.mak setlocal ft=html
autocmd FileType html,xhtml,xml,css setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Ruby
autocmd FileType ruby,eruby,yaml set autoindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType cucumber set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
au BufRead,BufNewFile *.ru set ft=ruby
au BufRead,BufNewFile Gemfile set ft=Ruby
au BufRead,BufNewFile Gemfile set ft=ruby
au BufRead,BufNewFile Capfile set ft=ruby
au BufRead,BufNewFile Vagrantfile set ft=ruby

au BufRead,BufNewfile *.go set tabstop=4

" Python
au FileType python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4
"au FileType python setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
"au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

autocmd FileType c,cpp,java,php,python,ruby,eruby,yaml autocmd BufWritePre <buffer> :%s/\s\+$//e

execute pathogen#infect()
