"By HE Chong

" General{{{
 set nocompatible               " be iMproved
 set shell=/bin/sh 				" avoid complications in shell commands


" detect OS type
let s:os=substitute(system('uname'),'\n','','')

 filetype off                   " required by vundle
 filetype plugin indent on
 filetype plugin on
 filetype indent on

" Basic mapping{{{
let mapleader=','
let localmapleader='m'

" browse mapping
nnoremap H 0
vnoremap H 0
nnoremap L $
vnoremap L $

" Add line mapping
nnoremap o o<esc>
nnoremap O O<esc>
nnoremap <CR> i<CR><esc>

" Toggle on/off copymode
nnoremap <Leader>cm :call ToggleCopyMode() <CR>

" Command mode shortcuts
" use <C-k> to truncate the commandline content to the end of the line.
cnoremap <C-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>
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
" mouse
if has("mouse")
	set mouse=nc
endif

"clipboard
if has('clipboard')
	set clipboard+=unnamed,unnamedplus
endif

" ruler, statusline, tabline {{{
set ruler
set statusline=%f\ -\ Filetype:\ %y\ -\ %c%V-%l/%L
set rulerformat=%35(%f\ %c%V-%l/%L\ %p%%%)
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
" }}}

" number/relative number
if (version == 7.4)+(version==704)
	set number
	augroup buffer_switch
		autocmd!
		autocmd BufEnter * setlocal relativenumber
		autocmd BufLeave * setlocal norelativenumber
	augroup END
elseif (version == 7.3)+(version==703)
	augroup buffer_switch
		autocmd!
		autocmd BufEnter * setlocal relativenumber
		autocmd BufLeave * setlocal number
	augroup END
else
	set number
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

" Autosaving{{{
"
" only write if needed and update the start time after the save
set updatetime=1000 	" very frequent update time ensure that CursorHold event triggers.
function! UpdateFile() 	" auto-update routine
	if (&mod==1)
		if (@%=="") 
			echom "Just for the heads up. You haven't name name file yet!"
		else
			if ((localtime() - b:start_time) >= 60)
				update
				let b:start_time=localtime()
			endif
		endif
	endif
endfunction

augroup AutoSave
	autocmd!
	au BufRead,BufNewFile * let b:start_time=localtime()
	au CursorHold * call UpdateFile()
	au BufWritePre * let b:start_time=localtime()
augroup END

" }}}

" Highlight boundary{{{
function! BoundaryAlert()
	let l:halfRange=500
	if col([line('.'),'$'])>&tw*1.0
		setlocal cc=+1
		hi ColorColumn ctermbg=black ctermfg=white guibg=black guifg=white
	elseif col([line('.'),'$'])>&tw*0.9
		setlocal cc=+1
		hi ColorColumn ctermbg=darkred ctermfg=255-darkred guibg=darkred guifg=white
	else
		setlocal cc=
		hi ColorColumn ctermbg=lightred ctermfg=black guibg=lightred guifg=black
	endif	
	if line('w$')-line('w0')<l:halfRange*2 	" check only when range is not
											" rediculously large
		if max(map(range(line('w0'),line('w$')),"col([v:val,'$'])"))>&tw
			setlocal cc=+1
		else
			setlocal cc=
		endif
	endif
endfunction

set cc=+1

augroup BoundaryBehavior
	autocmd!
	au CursorMoved,CursorMovedI,BufEnter * call BoundaryAlert()
	au BufLeave * setlocal cc=
augroup END
" }}}

" Default autowrapping behavior(disable auto-wrap) {{{
set formatoptions=roq
" }}}

" Highlight cursor location
hi CursorLine term=underline ctermbg=253 guibg=Grey40
hi CursorColumn term=reverse ctermbg=7 guibg=Grey90

nnoremap <leader>hl :call HLToggle()<CR>

function! HLToggle()
	if !exists("b:HLMarker")
		let b:HLMarker=0
	endif
	if b:HLMarker==0
		let b:HLMarker=1
		setlocal cursorcolumn
		setlocal cursorline
	elseif b:HLMarker==1
		let b:HLMarker=0
		setlocal nocursorcolumn
		setlocal nocursorline
	endif
endfunction

"
" }}}

" Vundle, plugin manager{{{
 set rtp+=~/.vim/bundle/vundle/ " load vundle
 call vundle#rc()


 " let Vundle manage Vundle
 " required!
 Bundle 'gmarik/vundle'

 " Bundle for other add-ons
 Bundle 'gerw/vim-latex-suite'
 Bundle 'scrooloose/nerdtree'
 Bundle 'godlygeek/tabular'
if version>=703 || (version>7.3 && version<10.0)
	Bundle 'Rip-Rip/clang_complete'
	Bundle 'davidhalter/jedi-vim'
endif
 Bundle 'ervandew/supertab'
 Bundle 'plasticboy/vim-markdown'
" Bundle 'vitorgalvao/autoswap_mac'
 Bundle 'shinokada/dragvisuals.vim'
 Bundle 'ron89/vim-copymode'
 Bundle 'vim-scripts/gnuplot.vim'

" }}}
 
" configure for convenient vim plugins{{{
 
" variable initialization {{{
" dragvisuals -- drag visual block
let g:DVB_TrimWS = 1
" }}}

" function initialization {{{
function! LoadPluginScript()
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
	autocmd VimEnter * call LoadPluginScript()
augroup END
" }}}

" }}}

" Filetype specific(including plugin configure){{{
" Makefile editing{{{
nnoremap <leader>em :split ./makefile<CR>
" }}}

" Vimrc editing{{{ 
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Vim folding{{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
	autocmd Filetype vim setlocal formatoptions=croqn 	" wrapping disbled for code
augroup END
" }}}
" }}}

" C++ specific{{{ 
augroup filetype_cpp
	autocmd!
	autocmd filetype cpp,c setlocal foldmethod=syntax
	autocmd filetype cpp,c let g:clang_auto_select=1
	if s:os == 'Darwin' || s:os == 'Mac'
		autocmd filetype cpp,c let g:clang_library_path="/Library/Developer/CommandLineTools/usr/lib/"
	elseif s:os == 'Linux'
		autocmd filetype cpp,c let g:clang_library_path="/usr/lib"
	endif
	autocmd filetype cpp,c let g:clang_close_auto=1
	autocmd filetype cpp,c let g:clang_complete_copen=1
	autocmd filetype cpp,c let g:clang_hl_errors=1
	autocmd filetype cpp,c let g:clang_close_preview=1
	autocmd Filetype cpp,c setlocal tw=80 
	autocmd Filetype cpp,c setlocal formatoptions=tcroqnj 
augroup END
" }}}

" python specific {{{
" Autowrapping behavior for py {{{
" }}}
augroup filetype_python
	autocmd!
	autocmd filetype python setlocal tabstop=4
	autocmd filetype python setlocal sw=4
	autocmd filetype python setlocal softtabstop=0
	autocmd filetype python setlocal foldmethod=indent
	autocmd filetype python setlocal formatoptions=croqnj
	autocmd filetype python setlocal noexpandtab
augroup END
augroup END
" }}}

" Latex{{{

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

"journal file definition{{{
augroup filetype_journal_definition
	autocmd!
	autocmd BufRead,BufNewFile *.journal 	set filetype=journal
	autocmd Filetype journal setlocal foldmethod=indent
	autocmd Filetype journal setlocal syntax=tex
	autocmd Filetype journal setlocal textwidth=80
	autocmd Filetype journal setlocal spell
	autocmd Filetype journal setlocal formatoptions=tcroq2j
augroup END	
"}}}

" }}}
