"By HE Chong

" General{{{
 set nocompatible               " be iMproved

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
" }}}

" Omnicomplete{{{
set complete+=.,w,b,u,U,i,d,k
" }}}

" Editing environment{{{
" ruler, statusline, tabline
set ruler
set statusline=%f\ -\ Filetype:\ %y\ -\ %4l/%4L
set rulerformat=%35(%f\ %c-%l/%L%V\ %p%%%)
set backspace=indent,eol,start

" tabline
function! MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	" define max length of tablabel based on the number of tabs
	let numtabs = tabpagenr('$')
	" account for space padding between tabs, and the close button
	let maxlen = ( &columns - ( numtabs * 2 ) - 4 ) / numtabs

	let tablabel = bufname(buflist[winnr - 1])
	while strlen( tablabel ) < 4
		let tablabel = tablabel . " "
	endwhile
	" modify filename
	let tablabel = fnamemodify( tablabel, ':~:.' )
	let tablabel = strpart( tablabel, 0, maxlen )
	return tablabel
endfunction

function! MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		" select the highlighting
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif

		" set the tab page number (for mouse clicks)
		let s .= '%' . (i + 1) . 'T'

		" the label is made by MyTabLabel()
		let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
	endfor

	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	" right-align the label to close the current tab page
	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999XX'
	endif

	return s
endfunction

set tabline=%!MyTabLine()

" number/relative number
if version >= 7.4
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

" Tab Jumping{{{
nnoremap tn :tabn<CR>
nnoremap tp :tabp<CR>
" }}}

" Indent{{{
set autoindent
set smartindent

set sw=4
set tabstop=4
" }}}

" }}}

" Vundle, plugin manager{{{
 set rtp+=~/.vim/bundle/vundle/ " load vundle
 call vundle#rc()

 filetype off                   " required by vundle

 " let Vundle manage Vundle
 " required!
 Bundle 'gmarik/vundle'

 " Bundle for other add-ons
 Bundle 'gerw/vim-latex-suite'
 Bundle 'scrooloose/nerdtree'
 Bundle 'godlygeek/tabular'
 Bundle 'Rip-Rip/clang_complete'
 Bundle 'davidhalter/jedi-vim'
 Bundle 'ervandew/supertab'
 Bundle 'hallison/vim-markdown'
" Bundle 'vitorgalvao/autoswap_mac'
 Bundle 'shinokada/dragvisuals.vim'

 filetype plugin indent on
" }}}
 
" configure for convenient vim plugins{{{
 
 filetype plugin on
 filetype indent on

" variable initialization {{{
" dragvisuals -- drag visual block
let g:DVB_TrimWS = 1
" }}}

" function initialization {{{
function! g:LoadPluginScript()
	" Tabular{{{
	if exists(":Tabularize")
		vnoremap <Leader>t& :Tabularize/&<CR>
		nnoremap <Leader>t& :Tabularize/&<CR>
		vnoremap <Leader>t, :Tabularize/,<CR>
		nnoremap <Leader>t, :Tabularize/,<CR>
		vnoremap <Leader>t= :Tabularize/=<CR>
		nnoremap <Leader>t= :Tabularize/=<CR>
		vnoremap <Leader>t: :Tabularize/:\zs<CR>
		nnoremap <Leader>t: :Tabularize/:\zs<CR>
		" map CucumberTable to keys.
		inoremap <silent> <Bar>   <Bar><Esc>:call g:CucumberTable()<CR>a
	endif
	" }}}
	" dragvisuals -- drag visual block{{{
	if exists("*DVB_Drag()")	
		vmap <expr> <LEFT> 	DVB_Drag('left')
		vmap <expr> <RIGHT>	DVB_Drag('right')
		vmap <expr> <DOWN> 	DVB_Drag('down')
		vmap <expr> <UP> 	DVB_Drag('up')
	endif
	if exists("*DVB_Duplicate()")	
		vmap <expr> D 		DVB_Duplicate()
	endif
	" }}}
endfunction

" CucumberTable automatically align table separators of
" a cucumber table('|'). the function of this function
" requires a working Tabular plugin.
"
" Idea and code of CucumberTable function are from tpope. 
" 	https://gist.github.com/tpope/287147
function! g:CucumberTable()
	let p = '^\s*|\s.*\s|\s*$'
	if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
		let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
		let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
		Tabularize/|/l1
		normal! 0
		call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
	endif
endfunction

augroup plugin_initialize
	autocmd!
	autocmd VimEnter * call g:LoadPluginScript()
augroup END
" }}}

" }}}

" Filetype specific(including plugin configure){{{

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
	autocmd filetype cpp,c setlocal foldmethod=syntax
	autocmd filetype cpp,c let g:clang_auto_select=1
	if has("mac")
		autocmd filetype cpp,c let g:clang_library_path="/Library/Developer/CommandLineTools/usr/lib/"
	else 
		autocmd filetype cpp,c let g:clang_library_path="/usr/lib"
	endif
	autocmd filetype cpp,c let g:clang_close_auto=1
	autocmd filetype cpp,c let g:clang_complete_copen=1
	autocmd filetype cpp,c let g:clang_hl_errors=1
	autocmd filetype cpp,c let g:clang_close_preview=1
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
	autocmd Filetype tex inoremap <buffer> ``'' ``''<++><esc>F`a
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
