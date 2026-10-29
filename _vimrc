" ~/.vimrc — shared by macOS, Linux and FreeBSD hosts.
" Plugins are native packages in ~/.vim/pack/plugins/start (git submodules).

" Vim's recommended baseline: nocompatible, filetype plugin indent on, syntax on,
" incsearch, scrolloff=5, ttimeoutlen=100, showcmd, wildmenu, mouse, and
" restoring the last cursor position. See :help defaults.vim.
unlet! skip_defaults_vim
if filereadable(expand('$VIMRUNTIME/defaults.vim'))
  source $VIMRUNTIME/defaults.vim
else
  set nocompatible
  filetype plugin indent on
  syntax on
endif

" % jumps between if/else/end, tags, etc. (ftplugins provide b:match_words).
packadd! matchit

" Mouse reporting inside tmux, including beyond column 223.
if exists('$TMUX') && has('mouse_sgr')
  set ttymouse=sgr
endif

let mapleader = ','

"" Display
set number
set linebreak            " wrap long lines at word boundaries
set textwidth=80
set colorcolumn=+1       " mark the column after 'textwidth'
set showmatch
set matchpairs+=<:>
set visualbell
set title
colorscheme molokai

"" Search
set hlsearch
set ignorecase
set smartcase
" <CR> clears search highlighting (kept as plain <CR> in quickfix and cmdwin below).
nnoremap <silent> <CR> :nohlsearch<CR>

"" Indentation
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set smarttab
set shiftround

"" Command-line completion
set wildignore+=*.o,*.obj,.git,*.pyc

"" Undo, swap and backup files outside the working tree
let s:state = expand('~/.local/state/vim')
for s:dir in ['undo', 'swap', 'backup']
  if !isdirectory(s:state . '/' . s:dir)
    call mkdir(s:state . '/' . s:dir, 'p', 0700)
  endif
endfor
let &undodir = s:state . '/undo//'
let &directory = s:state . '/swap//'
let &backupdir = s:state . '/backup//'
set undofile

"" Typos
command! -bang -nargs=* -complete=file W w<bang> <args>
command! -bang -nargs=* -complete=file Wq wq<bang> <args>
command! -bang Wqa wqa<bang>
command! -bang Q q<bang>

"" Plugins
let g:vim_markdown_folding_disabled = 1

"" Strip trailing whitespace on save for these filetypes
let s:strip_filetypes = ['c', 'cpp', 'java', 'php', 'python', 'ruby', 'eruby', 'yaml']
function! s:StripTrailingWhitespace() abort
  let l:view = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

augroup vimrc
  autocmd!
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>

  " Not detected by the runtime (Gemfile, *.ru, Vagrantfile, Rakefile are).
  autocmd BufRead,BufNewFile *.mako setfiletype html
  autocmd BufRead,BufNewFile Capfile setfiletype ruby

  autocmd FileType html,xhtml,xml,css,ruby,eruby,yaml,cucumber
        \ setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
  autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
  " ftplugin/go.vim already sets noexpandtab shiftwidth=0 softtabstop=0.
  autocmd FileType go setlocal tabstop=4

  autocmd BufWritePre *
        \ if index(s:strip_filetypes, &filetype) >= 0 | call s:StripTrailingWhitespace() | endif
augroup END
