set nocompatible
let mapleader=','              " Use , as leader key. Set before plugins load

" Load Plugins {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:coc_global_extensions = [
\ 'coc-json',
\ 'coc-tsserver',
\ 'coc-html',
\ 'coc-css',
\ 'coc-eslint',
\ 'coc-prettier',
\ 'coc-snippets',
\ 'coc-simple-react-snippets'
\ ]

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-syntastic/syntastic'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'mxw/vim-jsx'
Plug 'OrangeT/vim-csharp'
Plug 'OmniSharp/omnisharp-vim'
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
set foldlevel=10               " Don't fold when buffers open
set visualbell                 " Silent error messages

set nobackup                   " Don't write permanent backups when overwriting files
set noswapfile                 " Don't create .swp-files

set wildmenu                   " Use wildmenu for completion in command mode
set wildignore+=*/node_modules/*,*/.git/* " Exclude folders from completions
set path+=**                   " Allow recursive search for completions

set tabstop=2 expandtab shiftwidth=2 smarttab         " Use 2 spaces for tabs
set hlsearch

set textwidth=0                " Never auto-insert hard line breaks

set hidden                     " Allow leaving unsaved buffers
" }}}

" Plugins {{{
" Vim Airline {{{
let g:airline_symbols_ascii = 1                       " Use plain chars in Airline UI
let g:airline_powerline_fonts=0
"let g:airline#extensions#tabline#enabled = 1          " Use top as tabs for buffers
"let g:airline#extensions#tabline#fnamemod = ':t'      " Show only filename on tabs
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved' " Show folder if not unique filename
"let g:airline#extensions#tabline#buffer_idx_mode = 1  " Relative numbering
let g:airline#extensions#syntastic#enabled = 1
set noshowmode                                        " Airline already shows mode
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
" coc.nvim {{{
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
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <F2> <Plug>(coc-rename)
nmap <leader>rn <Plug>(coc-rename)
nmap <C-@> :CocAction<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" netrw
nnoremap <leader>e :silent ToggleNetrwExplorer<CR>

" CtrlP
nnoremap <C-b> :CtrlPBuffer<CR>
" }}}


" vim: set foldmethod=marker:
" vim: set foldlevel=0:

