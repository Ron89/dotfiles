"By HE Chong

"Vundle{{{
 set nocompatible               " be iMproved
 filetype off                   " required!

 set rtp+=~/.vim/bundle/vundle/
 call vundle#rc()

 " let Vundle manage Vundle
 " required!
 Bundle 'gmarik/vundle'

 " Bundle for other add-ons
 Bundle 'gerw/vim-latex-suite'
 Bundle 'scrooloose/nerdtree'
 Bundle 'godlygeek/tabular'
 Bundle 'Rip-Rip/clang_complete'
 Bundle 'ervandew/supertab'

 filetype plugin indent on
 "}}}
 
"TexSuite{{{
 filetype plugin on

 " IMPORTANT: grep will sometimes skip displaying the file name if you
 " search in a singe file. This will confuse Latex-Suite. Set your grep
 " program to always generate a file-name.
 set grepprg=grep\ -nH\ $*

 " OPTIONAL: This enables automatic indentation as you type.
 filetype indent on

 " OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
 " 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
 " The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
 " TIP: if you write your \label's as \label{fig:something}, then if you
 " type in \ref{fig: and press <C-n> you will automatically cycle through
 " all the figure labels. Very useful!
set iskeyword+=:

augroup filetype_Tex
	autocmd!
	autocmd Filetype tex setlocal dictionary+="~/.vim/bundle/vim-latex-suite/ftplugin/latex-suite/dictionaries/dictionary"
	autocmd Filetype tex setlocal dictionary+="/usr/share/dict/words"
	autocmd Filetype tex setlocal dictionary+="./reference.bib"
	autocmd Filetype tex :execute "nnoremap <leader>vr :vs ./reference.bib<CR>"
	autocmd Filetype tex setlocal spell
augroup END
"}}}	

" General{{{
let mapleader=','
let localmapleader='m'

" Editing environment
set ruler
set statusline=%f\ -\ Filetype:\ %y\ -\ %4l/%4L
set rulerformat=%25(%f\ %c-%l/%L%V\ %p%%%)

" Tab Jumping
nnoremap tn :tabn<CR>
nnoremap tp :tabp<CR>

" }}}

" MacVim{{{

" }}}

" Omnicomplete{{{
set complete+=.,w,b,u,U,i,d,k
" }}}

" Makefile editing{{{
nnoremap <leader>em :split ./makefile<CR>
"}}}

" Vimrc editing{{{
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Vim folding
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END
"}}}

" Mode switch{{{
inoremap jk <esc>
"inoremap <esc> <nop>
"}}}

" Basic mapping{{{
nnoremap H 0
vnoremap H 0
nnoremap L $
vnoremap L $
nnoremap o o<esc>
nnoremap O O<esc>
"}}}

"bracket editing{{{
inoremap () ()<++><esc>F)i
inoremap [] []<++><esc>F]i
inoremap {} {}<++><esc>F}i
inoremap <> <><++><esc>F>i
inoremap '' ''<++><esc>F'i
inoremap "" ""<++><esc>F"i
onoremap p i(
"}}}

"tabularize{{{
if exists(":Tabularize")
	nnoremap<Leader>t& :Tabularize /&<CR>
"	inoremap<Leader>t& :Tabularize /&<CR>
	nnoremap<Leader>t| :Tabularize /  |<CR>
"	inoremap<Leader>t| :Tabularize /  |<CR>
endif
"}}}
"
"Indent{{{
set autoindent
set smartindent

set sw=4
set tabstop=4
"}}}

"Visual effect{{{
set relativenumber
"set spell
syntax on
"}}}

" C++ specific{{{
augroup filetype_cpp
	autocmd!
	autocmd Filetype cpp,c setlocal foldmethod=syntax
	autocmd Filetype cpp,c let g:clang_auto_select=1
	autocmd Filetype cpp,c let g:clang_library_path="/Library/Developer/CommandLineTools/usr/lib/"
augroup END
" }}}
