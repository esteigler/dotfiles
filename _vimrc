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

" ALE: linters for python (ruff), ruby (rubocop), php (php -l + phpcs), go
" (gofmt/govet/golangci-lint), javascript/typescript (eslint), shell
" (shellcheck), yaml (yamllint), json (python's json.tool) and markdown
" (markdownlint-cli). Each tool runs only if its executable is on $PATH; a
" missing tool is skipped silently. g:ale_linters_explicit means only these
" run, nothing else ALE happens to find installed.

" json.tool instead of jq/jsonlint: every host here already needs python,
" so this adds no new dependency. Its "<message>: line N column M" errors
" are parsed below; also usable as a formatter via :ALEFix json_pytool.
call ale#Set('json_pytool_executable', 'python3')
function! s:HandleJsonToolErrors(buffer, lines) abort
  let l:pattern = '^\(.\+\): line \(\d\+\) column \(\d\+\)'
  return ale#util#MapMatches(a:lines, l:pattern, {match -> {
        \ 'text': match[1],
        \ 'lnum': match[2] + 0,
        \ 'col': match[3] + 0,
        \}})
endfunction
call ale#linter#Define('json', {
      \ 'name': 'json_pytool',
      \ 'executable': {b -> ale#Var(b, 'json_pytool_executable')},
      \ 'output_stream': 'stderr',
      \ 'command': '%e -m json.tool',
      \ 'callback': function('s:HandleJsonToolErrors'),
      \})

let g:ale_linters_explicit = 1
let g:ale_linters = {
      \ 'python': ['ruff'],
      \ 'ruby': ['rubocop'],
      \ 'php': ['php', 'phpcs'],
      \ 'go': ['gofmt', 'govet', 'golangci-lint'],
      \ 'javascript': ['eslint'],
      \ 'javascriptreact': ['eslint'],
      \ 'typescript': ['eslint'],
      \ 'typescriptreact': ['eslint'],
      \ 'sh': ['shellcheck'],
      \ 'yaml': ['yamllint'],
      \ 'json': ['json_pytool'],
      \ 'markdown': ['markdownlint_cli'],
      \}

" Fixers limited to each ecosystem's own canonical, idempotent formatter so
" fix-on-save never does more than a human running that formatter by hand
" would. Everything else just gets the '*' whitespace cleanup below. Run
" other fixers (e.g. eslint) on demand with :ALEFix <name>.
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python': ['ruff', 'ruff_format'],
      \ 'ruby': ['rubocop'],
      \ 'go': ['gofmt', 'goimports'],
      \ 'sh': ['shfmt'],
      \}
let g:ale_fix_on_save = 1
let g:ale_virtualtext_cursor = 'current'

nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)
nnoremap <Leader>f :ALEFix<CR>

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
augroup END
