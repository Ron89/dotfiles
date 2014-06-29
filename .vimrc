"By HE Chong

" Vundle{{{
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
 Bundle 'hallison/vim-markdown'
" Bundle 'vitorgalvao/autoswap_mac'
 Bundle 'shinokada/dragvisuals.vim'

 filetype plugin indent on
 " }}}

" General{{{
" Basic mapping{{{
let mapleader=','
let localmapleader='m'
nnoremap H 0
vnoremap H 0
nnoremap L $
vnoremap L $
nnoremap o o<esc>
nnoremap O O<esc>
nnoremap <CR> i<CR><esc>
" }}}

" Mode switch{{{
inoremap jk <esc>
"inoremap <esc> <nop>
" }}}

" bracket editing{{{
inoremap () ()<++><esc>F)i
inoremap [] []<++><esc>F]i
inoremap {} {}<++><esc>F}i
inoremap <> <><++><esc>F>i
inoremap '' ''<++><esc>F'i
inoremap "" ""<++><esc>F"i
onoremap p i(
" }}}

" Omnicomplete{{{
set complete+=.,w,b,u,U,i,d,k
" }}}

" Editing environment{{{
set ruler
set statusline=%f\ -\ Filetype:\ %y\ -\ %4l/%4L
set rulerformat=%25(%f\ %c-%l/%L%V\ %p%%%)
set backspace=indent,eol,start
" }}}

" Tab Jumping{{{
nnoremap tn :tabn<CR>
nnoremap tp :tabp<CR>
" }}}

" Visual effect{{{
if version > 740
	set number
	augroup buffer_switch
		autocmd BufEnter * setlocal relativenumber
		autocmd BufLeave * setlocal norelativenumber
	augroup END
else
	augroup buffer_switch
		autocmd BufEnter * setlocal relativenumber
		autocmd BufLeave * setlocal number
	augroup END
endif

"set spell
syntax on
" }}}

" Indent{{{
set autoindent
set smartindent

set sw=4
set tabstop=4
" }}}

" }}}

" vim plugins{{{
 
 filetype plugin on
 filetype indent on

" tabularize{{{
if exists(":Tabularize")
	nnoremap<Leader>t& :Tabularize /&<CR>
"	inoremap<Leader>t& :Tabularize /&<CR>
	nnoremap<Leader>t| :Tabularize /  |<CR>
"	inoremap<Leader>t| :Tabularize /  |<CR>
endif
" }}}

" dragvisual -- drag visual block{{{{
if exists("*DVB_Drag()")
	vmap <expr> <LEFT> 	DVB_Drag('left')
	vmap <expr> <RIGHT>	DVB_Drag('right')
	vmap <expr> <DOWN> 	DVB_Drag('down')
	vmap <expr> <UP> 	DVB_Drag('up')
	vmap <expr> D 		DVB_Duplicate()
	let g:DVB_TrimWS = 1
endif
" }}}

" }}}

" Filetype specific{{{

" Makefile editing{{{
nnoremap <leader>em :split ./makefile<CR>
" }}}

" Vimrc editing{{{
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Vim folding{{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
" }}}

" C++ specific{{{
augroup filetype_cpp
	autocmd!
	autocmd Filetype cpp,c setlocal foldmethod=syntax
	autocmd Filetype cpp,c let g:clang_auto_select=1
	autocmd Filetype cpp,c let g:clang_library_path="/Library/Developer/CommandLineTools/usr/lib/"
	autocmd Filetype cpp,c let g:clang_close_auto=1
	autocmd Filetype cpp,c let g:clang_complete_copen=1
	autocmd Filetype cpp,c let g:clang_hl_errors=1
	autocmd Filetype cpp,c let g:clang_close_preview=1
augroup END
" }}}

" TexSuite{{{

 " IMPORTANT: grep will sometimes skip displaying the file name if you
 " search in a singe file. This will confuse Latex-Suite. Set your grep
 " program to always generate a file-name.
 set grepprg=grep\ -nH\ $*

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
"	autocmd Filetype tex setlocal dictionary+="./reference.bib"
	autocmd Filetype tex :execute "nnoremap <buffer> <leader>vr :vs ~/refLibrary.bib<CR>"
	autocmd Filetype tex setlocal spell
	autocmd Filetype tex setlocal tw=80
augroup END
" }}}	

" Markdown specific{{{
augroup filetype_markdown
	autocmd!
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown
	autocmd Filetype markdown inoremap <buffer> ``<Space> ``<++><esc>F`i
	autocmd Filetype markdown inoremap <buffer> ``` ```<CR>```<++><esc>k$a
augroup END
" }}}

" }}}
