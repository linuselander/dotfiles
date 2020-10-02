set nocompatible
let mapleader=','              " Use , as leader key. Set before plugins load

" Load Plugins {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
" Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-syntastic/syntastic'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'OrangeT/vim-csharp'
Plug 'OmniSharp/omnisharp-vim'
"Plug 'linuselander/vim-signore'
Plug 'sgur/vim-editorconfig'
call plug#end()
"}}}

" Colors {{{
syntax on
colorscheme gruvbox
set background=dark
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
"}}}

" UI {{{
"let &colorcolumn=join(range(80,255),",")  "Add bg at column 80 and above
"highlight link EndOfBuffer ColorColumn
let &t_SI.="\e[5 q"            " Set cursor to vertical line in insert mode
let &t_SR.="\e[4 q"            " Set cursor to horizontal line in replace mode
let &t_EI.="\e[1 q"            " Set cursor to block line in normal mode
set colorcolumn=80
set cursorline                 " Highlight current line
set relativenumber             " Line numbers originate from cursor position
set number                     " Current line shows actual line number
set foldcolumn=1               " Show column for fold markers
set wrap                       " Wrap text when wider than window
set linebreak                  " Wrap text according to 'breakat' instead of anywhere
set breakindent                " Indent wrapped text to match indentation of current line
set showbreak=+++              " Prefix wrapped text
" }}}

" Behavior {{{
set backspace=indent,eol,start " Expected backspace behavior
set foldmethod=syntax          " Base folding on current file syntax
set visualbell                 " Silent error messages

set nobackup                   " Don't write permanent backups when overwriting files
set noswapfile                 " Don't create .swp-files

set wildmenu                   " Use wildmenu for completion in command mode
set wildignore+=*/node_modules/*,*/.git/* " Exclude folders from completions
set path+=**                   " Allow recursive search for completions

set tabstop=2 expandtab shiftwidth=2 smarttab         " Use 2 spaces for tabs
set hlsearch

set textwidth=0                " Never auto-insert hard line breaks
" }}}

" Plugins {{{
" Vim Airline {{{
let g:airline_symbols_ascii = 1                       " Use plain chars in Airline UI
let g:airline_powerline_fonts=0
let g:airline#extensions#tabline#enabled = 1          " Use top as tabs for buffers
let g:airline#extensions#tabline#fnamemod = ':t'      " Show only filename on tabs
let g:airline#extensions#tabline#formatter = 'unique_tail_improved' " Show folder if not unique filename
let g:airline#extensions#tabline#buffer_idx_mode = 1  " Relative numbering
let g:airline#extensions#syntastic#enabled = 1
set noshowmode                                        " Airline already shows mode
"}}}
" Tmuxline {{{
  let g:tmuxline_powerline_separators = 0
"}}}
" Syntastic {{{
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"}}}
" CtrlP {{{
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'git -C %s ls-files --cached --exclude-standard --others'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }
" }}}
" Signore {{{
let g:signore#auto = 1
let g:signore#use_ctrlp_format = 0
" }}}
" Vim Csharp {{{
" }}}
" OmniSharp Vim {{{
let g:OmniSharp_server_path = '/mnt/c/OmniSharp/omnisharp.http-win-x64/OmniSharp.exe'
let g:OmniSharp_translate_cygwin_wsl = 1

"set updatetime=500
"
"sign define OmniSharpCodeActions text=¤
"
"augroup OSCountCodeActions
"  autocmd!
"  autocmd FileType cs set signcolumn=yes
"  autocmd CursorHold *.cs call OSCountCodeActions()
"augroup END
"
"function! OSCountCodeActions() abort
"  if OmniSharp#CountCodeActions({-> execute('sign unplace 99')})
"    let l = getpos('.')[1]
"    let f = expand('%:p')
"    execute ':sign place 99 line='.l.' name=OmniSharpCodeActions file='.f
"  endif
"endfunction

" }}}
"}}}

" Mappings {{{
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab
" }}}


" vim: set foldmethod=marker:

