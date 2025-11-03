vim9script
# vim configuration file

call plug#begin()
  # utilities
  Plug 'tpope/vim-commentary'

  # syntax highlighting
  Plug 'rhysd/vim-llvm'
  Plug 'bfrg/vim-cpp-modern'
  Plug 'vim-python/python-syntax'
  Plug 'tomlion/vim-solidity'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'dart-lang/dart-vim-plugin'
  Plug 'thosakwe/vim-flutter'

  # lsp
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'mattn/vim-lsp-settings'
call plug#end()

syntax enable
set t_Co=256
set background=light

set completeopt=menu,menuone,noinsert,noselect
set autoread
set number
set relativenumber
set ignorecase
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set laststatus=2
set autoindent
set backspace=indent,eol,start
set incsearch
set linebreak
set noswapfile
set updatetime=300
set signcolumn=yes
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set scrolloff=8

# key mappings
# map leader
g:mapleader = " "
g:maplocalleader = " "

# fast save
nmap <leader>w <cmd>w!<cr>

# fast close
nmap <leader>q <cmd>q<cr>

# fern
nmap <leader>e <cmd>NERDTree<cr>

# Tagbar
nmap <leader>t <cmd>TagbarToggle<cr>

# disable highlight
map <silent> <leader><cr> :noh<cr>

# move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

# faster navigation
nnoremap <leader>j <C-F>
nnoremap <leader>k <C-B>

# copy to system clipboard
vnoremap <Leader>y  "+y
nnoremap <Leader>y  "+y

# paste from system clipboard
vnoremap <leader>p "+p
nnoremap <leader>p "+p

# resize window using <ctrl> arrow keys
nnoremap <C-Up> :resize +2<cr>
nnoremap <C-Down> :resize -2<cr>"
nnoremap <C-Left> :vertical resize -2<cr>
nnoremap <C-Right> :vertical resize +2<cr>

# move selected lines
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

# terminal
tnoremap <esc> <C-W><C-C>
nnoremap <silent> <leader>tt <cmd>belowright terminal<cr>
nnoremap <silent> <leader>tv <cmd>belowright vertical terminal<cr>

# # fast buffer switch
# use fzf for fast switch
# nnoremap <Leader>b :ls<CR>:b<Space>

augroup NoTrailingWhitespaces | autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

# vim-commentary
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

# lsp
augroup LspInstall | autocmd!
    # call OnLspBufferEnabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call OnLspBufferEnabled()
augroup END

def OnLspBufferEnabled()
    b:vcm_tab_complete = "omni"
    g:lsp_diagnostics_highlights_enabled = 0
    g:lsp_diagnostics_virtual_text_enabled = 0
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    # autocmd! BufWritePre *.cpp,*.h call execute('LspDocumentFormatSync')
    SetLspMappings()
enddef

def SetLspMappings()
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> gl <plug>(lsp-document-diagnostics)
    nmap <buffer> gf <plug>(lsp-document-format)
    nmap <buffer> ga <plug>(lsp-code-action)
    nmap <buffer> gR <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
enddef

augroup LspClangd | autocmd!
  autocmd User lsp_setup call lsp#register_server({
        \ name: 'clangd',
        \ cmd: (server_info) => ['clangd', '-background-index', '-header-insertion=never'],
        \ allowlist: [ 'c', 'cpp', 'objc', 'objcpp' ],
        \ })
augroup END

# asyncomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

# python-syntax
g:python_highlight_all = 1

# diff helper
def ToggleDiff(): void
  if &diff
    diffoff
  else
    diffthis
  endif
enddef

command! -nargs=0 ToggleDiff call ToggleDiff()
nnoremap <leader>d :ToggleDiff<cr>

# diff-colorscheme
if &diff
  highlight DiffAdd    cterm=none ctermfg=0 ctermbg=LightGreen  gui=none guifg=bg guibg=LightGreen
  highlight DiffDelete cterm=none ctermfg=0 ctermbg=LightRed    gui=none guifg=bg guibg=LightRed
  highlight DiffChange cterm=none ctermfg=0 ctermbg=LightYellow gui=none guifg=bg guibg=LightYellow
  highlight DiffText   cterm=none ctermfg=0 ctermbg=LightBlue   gui=none guifg=bg guibg=LightBlue
endif


