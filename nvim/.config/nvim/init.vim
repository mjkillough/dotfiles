" Set working directory to file's path at start-up.
" Expect to usually start with `nvim directory`.
" cd %:h

set nobackup
set nowritebackup

set hidden

set autoindent
set backspace=indent,eol,start
set smarttab

set autoread

" Always show signcolumn/line-numbers.
set signcolumn=yes
highlight clear SignColumn
set number
highlight LineNr ctermfg=7

highligh clear VertSplit

call plug#begin('~/.config/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf'
Plug 'tpope/vim-commentary'
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

set termguicolors
colorscheme dracula

noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>

map <Home> <Esc>^
imap <Home> <Esc>^i
map <End> <Esc>$
imap <End> <Esc>A

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

map <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-h': 'split',
  \ 'ctrl-x': 'vsplit' }

" C-_ is C-/
nmap <C-_> <Plug>Commentary
vmap <C-_> <Plug>Commentary

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
set statusline+=\ %y
set statusline+=\ %2p%%
set statusline+=\ %2l:%-2c
set statusline+=\ 

