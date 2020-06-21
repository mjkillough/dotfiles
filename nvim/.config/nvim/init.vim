" Set working directory to file's path at start-up.
" Expect to usually start with `nvim directory`.
" cd %:h

set nobackup
set nowritebackup
set noswapfile

set hidden

set autoindent
set backspace=indent,eol,start
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set textwidth=80

set autoread

set incsearch

filetype plugin indent on

" Always show signcolumn/line-numbers.
set signcolumn=yes
highlight clear SignColumn
set number
highlight LineNr ctermfg=7

highligh clear VertSplit

call plug#begin('~/.config/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vhda/verilog_systemverilog.vim'
call plug#end()

set termguicolors
colorscheme dracula

noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>

set listchars=tab:>·,trail:~,extends:>,precedes:<,space:.
noremap <silent> <Leader>w :set list!<CR>

map <C-e> :CocList diagnostics<CR>

inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

map <C-b> :NERDTreeToggle<CR>

" From fzf.vim's README: uses ripgrep for the search rather than fzf.
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

noremap <Leader>f :RG<CR>
noremap <Leader>b :Buffers<CR>
noremap <Leader>n :noh<CR>
noremap <C-p> :Files<CR>

" C-_ is C-/
nmap <C-_> <Plug>Commentary
vmap <C-_> <Plug>Commentary

command! Settings e $MYVIMRC
command! ReloadSettings so $MYVIMRC

" Status Bar

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, ' E' . info['error'] . ' ')
  endif
  if get(info, 'warning', 0)
    call add(msgs, ' W' . info['warning'] . ' ')
  endif
  return join(msgs, '')
endfunction

function! CocStatus() abort
  let l:status = get(g:, 'coc_status', '')
  return strlen(l:status) > 0 ? l:status . ' ' : ''
endfunction

function! TagsStatus() abort
  let l:status = gutentags#statusline()
  return strlen(l:status) > 0 ? ' ' . l:status . ' ' : ''
endfunction

function! FolderName() abort
  let l:folder = expand('%:p:h:t')
  return strlen(l:folder) > 0 ? '  ' . l:folder . ' ' : ''
endfunction

set laststatus=2

set statusline=
set statusline+=%#WildMenu#
set statusline+=%{FolderName()}
set statusline+=%#Visual#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#ErrorMsg#
set statusline+=%{StatusDiagnostic()}
set statusline+=%#WildMenu#
set statusline+=%{CocStatus()}
set statusline+=%#Visual#
set statusline+=
set statusline+=%#WildMenu#
set statusline+=%{TagsStatus()}
set statusline+=%#Visual#
set statusline+=\ %y
set statusline+=\ %2p%%
set statusline+=\ %2l:%-2c
set statusline+=\

let g:gutentags_ctags_executable = 'uctags'
let g:gutentags_exclude_filetypes = []

" OpenBSD: cd /sys/arch/amd64 && make links && make tags
set tags+=arch/amd64/tags

autocmd BufNewFile,BufRead /tmp/neomutt* set noautoindent filetype=mail wm=0 tw=72 nonumber digraph nolist
autocmd BufNewFile,BufRead ~/tmp/neomutt* set noautoindent filetype=mail wm=0 tw=72 nonumber digraph nolist

function! ClangFormat()
  let l:formatdiff = 1
  py3file /usr/local/share/clang/clang-format.py
endfunction

" autocmd BufWritePre *.h,*.c,*.cc,*.cpp call ClangFormat()
" command! ClangFormat call ClangFormat()

autocmd Filetype systemverilog set tabstop=2 softtabstop=2 shiftwidth=2

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    keepp %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

