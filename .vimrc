set nocompatible
let mapleader=','              " Use , as leader key. Set before plugins load

" Load Plugins {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim'
Plug 'puremourning/vimspector'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
call plug#end()
"}}}

" Colors {{{
syntax on
colorscheme blue
set background=dark
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
"}}}
" UI {{{
set cursorline                 " Highlight current line
set relativenumber             " Line numbers originate from cursor position
set number                     " Current line shows actual line number
set wrap                       " Wrap text when wider than window
set linebreak                  " Wrap text according to 'breakat' instead of anywhere
set breakindent                " Indent wrapped text to match indentation of current line
set showbreak=+++              " Prefix wrapped text
" }}}
" Behavior {{{
set backspace=indent,eol,start " Expected backspace behavior
set foldmethod=syntax          " Base folding on current file syntax
set foldlevel=10               " Don't fold when buffers open
set visualbell                 " Silent error messages

set nobackup                   " Don't write permanent backups when overwriting files
set noswapfile                 " Don't create .swp-files

set wildmenu                   " Use wildmenu for completion in command mode
set wildignore+=*/node_modules/*,*/.git/* " Exclude folders from completions
set path+=**                   " Allow recursive search for completions

set tabstop=2 expandtab shiftwidth=2 smarttab         " Use 2 spaces for tabs
autocmd FileType cs set tabstop=4 shiftwidth=4
set hlsearch

set textwidth=0                " Never auto-insert hard line breaks

set hidden                     " Allow leaving unsaved buffers
" }}}
" Plugins {{{
" Vim Airline {{{
let g:airline_symbols_ascii = 1                       " Use plain chars in Airline UI
let g:airline_powerline_fonts=0
let g:airline#extensions#syntastic#enabled = 1
set noshowmode                                        " Airline already shows mode
"}}}
" omnisharp-vim{{{
let g:OmniSharp_server_use_net6 = 1
" }}}
" vimspector {{{
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
" }}}
" coc.nvim {{{
let g:coc_global_extensions = [
\ 'coc-tsserver', 
\ 'coc-snippets', 
\ 'coc-eslint', 
\ 'coc-prettier', 
\ 'coc-json',
\ 'coc-html',
\ 'coc-css',
\]
set updatetime=300
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
" }}}
" Netrw {{{
let g:netrw_banner = 0      " hide banner
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()

function! s:open_netrw()
  " Grab the current file name
  let file_name = expand("%:t")
  " Open a 20-column left-side netrw explorer in the directory for the current
  " file
  20Lexplore %:h
  let t:netrw_buffer_number = bufnr("%")
  " find the file in the explorer
  call search(file_name)
endfunction

function! s:toggle_netrw()
  if exists("t:netrw_buffer_number")
    let netrw_window_number = bufwinnr(t:netrw_buffer_number)
    if netrw_window_number != -1
      let current_working_buffer = winnr()
      " move to the netrw window
      exec netrw_window_number . "wincmd w"
      " close it
      close
      if current_working_buffer != netrw_window_number
        " go back to the file
        exec "silent! " . current_working_buffer . "wincmd w"
      endif
      unlet t:netrw_buffer_number
    else
      " was the explorer was closed manually?
      call s:open_netrw()
    endif
  else
    call s:open_netrw()
  endif
endfunction
command! ToggleNetrwExplorer call s:toggle_netrw()
" }}}
"}}}
" Mappings {{{
" Coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap <C-@> :CocAction<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" netrw
nnoremap <leader>e :silent ToggleNetrwExplorer<CR>

" fzf
nmap <C-p> :GFiles<CR>
" }}}

" vim: set foldmethod=marker:
" vim: set foldlevel=0:
