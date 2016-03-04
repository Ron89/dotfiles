"By HE Chong

" General{{{
 set nocompatible               " be iMproved
 set shell=/bin/sh 				" avoid complications in shell commands
" set encoding=iso-8859-1        " show accented letter

" detect OS type
let s:os=substitute(system('uname'),'\n','','')

" filetype off                   " required by vundle
 filetype plugin indent on
 filetype plugin on
 filetype indent on

" Basic mapping{{{
let mapleader=','
let maplocalleader='m'

" browse mapping
nnoremap H 0
vnoremap H 0
nnoremap L $
vnoremap L $

" Add line mapping
nnoremap o o<esc>
nnoremap O O<esc>
" nnoremap <CR> i<CR><esc>

" jump between splits
if exists(":tnoremap")
     tnoremap <A-h> <C-\><C-n><C-w>h
     tnoremap <A-j> <C-\><C-n><C-w>j
     tnoremap <A-k> <C-\><C-n><C-w>k
     tnoremap <A-l> <C-\><C-n><C-w>l
endif
 nnoremap <A-h> :wincmd h<CR>
 nnoremap <A-j> :wincmd j<CR>
 nnoremap <A-k> :wincmd k<CR>
 nnoremap <A-l> :wincmd l<CR>

" Toggle on/off copymode
nnoremap <Leader>cm :call ToggleCopyMode() <CR>

" Command mode shortcuts
" use <C-k> to truncate the commandline content to the end of the line.
cnoremap <C-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>

" mapping tabs to corresponding spaces
 set expandtab
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
 inoremap $$ $$<++><esc>F$i

" In coding, when typing enter in {}, insert 2 line breakers and put cursor in
" the empty line.
function! EnterBetweenBraces()
 	let l:string=getline('.')[col('.')-1:col('.')]
 	let l:append=getline('.')[col('.'):]
 	if l:string=='{}'
 		call setline('.',getline('.')[:col('.')-1])
 		call append('.',[repeat('	',indent('.')/&tabstop+1),repeat('	',indent('.')/&tabstop).l:append])
 		call cursor(line('.')+1,indent('.')/&tabstop+&tabstop)
 	else
 		call setline('.',getline('.')[:col('.')-1])
 		call append('.',repeat('	',indent('.')/&tabstop).l:append)
 		call cursor(line('.')+1,indent('.')/&tabstop+&tabstop)
 	endif
endfunction

" }}}

" Omnicomplete{{{
 set complete+=.,w,b,u,U,i,d,k
" }}}

" Editing environment{{{
" mouse
if has("mouse")
	set mouse=n
endif

" clipboard
if has('clipboard')
	set clipboard=unnamed,unnamedplus
endif

" " color personalization
"  highlight Visual ctermbg=144 ctermfg=235
" " highlight Visual cterm=reverse
"  highlight MatchParen ctermbg=115 
"  highlight PreProc ctermfg=4
" " highlight Comment ctermfg=4
"  highlight User1 ctermbg=16 ctermfg=130 cterm=bold
"  highlight User2 ctermbg=130 ctermfg=16 cterm=bold

" ruler, statusline, tabline {{{
"function! InsertStatuslineColor(mode)
"  if a:mode == 'i'
"    hi statusline ctermbg=Blue guibg=Blue
"  elseif a:mode == 'r'
"    hi statusline ctermbg=magenta guibg=magenta
"  else
"    hi statusline ctermbg=red guibg=red
"  endif
"endfunction

"augroup statusLineColor
"  au InsertEnter * call InsertStatuslineColor(v:insertmode)
"  au InsertChange * call InsertStatuslineColor(v:insertmode)
"  au InsertLeave * hi statusline ctermbg=green guibg=green
"augroup END

 set ruler
" set statusline=%1*%f%r%m\ %2*\ Filetype:\ %y\ %0*%<%=%2*\ C:%v\ L:%l/%L%0*
" hi statusline ctermbg=green guibg=green cterm=bold
" set rulerformat=%35(%f\ %c%V-%l/%L\ %p%%%)
 set laststatus=2
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
syntax enable
" let g:lexical#dictionary = ['/usr/share/dict/american-english','/usr/share/dict/british','/usr/share/dict/british-english']
" highlight SpellBad ctermbg=9 ctermfg=16

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
"set updatetime=1000 	" very frequent update time ensure that CursorHold event triggers.
"function! UpdateFile() 	" auto-update routine
"	if (&mod==1)
"		if (@%=="") 
"			echom 'Just for the heads up. You haven't name name file yet!'
"		else
"			if ((localtime() - b:start_time) >= 60)
"				update
"				let b:start_time=localtime()
"			endif
"		endif
"	endif
"endfunction
"
"augroup AutoSave
"	autocmd!
"	au BufRead,BufNewFile * let b:start_time=localtime()
"	au CursorHold * call UpdateFile()
"	au BufWritePre * let b:start_time=localtime()
"augroup END

"function !RetainChangeConfirm()
"	if (&mod==1)
"		let l:choice=confirm("Buffer change not saved, and about to leave.", 
"					\"&Save\nSave with &trailed name(.tmp)\n&Leave it be")
"		if l:choice==1
"			write
"		elseif l:choice==2
"			write expand("%:p:h")."/".expand("%:t")."tmp"
"		endif
"	endif
"endfunction
"
"augroup DeleteBufPrompt
"	autocmd!
"	au BufDelete,BufFilePre * call RetainChangeConfirm()
"augroup END

" }}}

" Highlight boundary{{{
highlight ColorColumn ctermbg=246
function! BoundaryAlert()
	let l:halfRange=500
	if col([line('.'),'$'])>&tw*0.9
		setlocal cc=+1
	else
		setlocal cc=
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

"" Customized Syntax Highlighting {{{
" syntax region DoubleQuote start="``" end="''"
" highlight link DoubleQuote String
"" }}}

" Default autowrapping behavior(disable auto-wrap) {{{
set formatoptions=roq
" }}}

" Highlight cursor location {{{
hi CursorLine term=underline ctermbg=253 guibg=Grey80 ctermfg=235 guifg=Grey5
hi CursorColumn term=reverse ctermbg=7 guibg=Grey90 ctermfg=235 guifg=Grey5

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
" }}}

" Folding {{{
 highlight Folded ctermbg=243 ctermfg=16
 highlight Folded ctermbg=251 ctermfg=16
" }}}

" Thesaurus {{{
 set thesaurus+=~/.vim/thesaurus/mthesaur.txt
" }}}
" }}}

" Vundle, plugin manager{{{
" set rtp+=~/.vim/bundle/Vundle.vim " load vundle
" call vundle#begin()
 call plug#begin('~/.vim/plugged')

" set runtimepath^=~/.vim/bundle/neobundle.vim/
" call neobundle#begin(expand('~/.vim/bundle/'))
"
 " Let NeoBundle manage NeoBundle
" required:
"  NeoBundleFetch 'Shougo/neobundle.vim'

 " let Vundle manage Vundle
" required!
" Plugin 'VundleVim/Vundle.vim'

 " Plug for other add-ons
 Plug 'gerw/vim-latex-suite'
 Plug 'scrooloose/nerdtree'
 Plug 'Shougo/unite.vim'
 Plug 'tpope/vim-surround'
 Plug 'nathanaelkane/vim-indent-guides'
" Auto-complete tool set
" Plug 'Shougo/deoplete.nvim'
" Plug 'Shougo/neco-syntax'
" Plug 'Shougo/neco-vim'
" Plug 'Shougo/neosnippet-snippets'
" General tools
 Plug 'Shougo/unite-session'
 Plug 'godlygeek/tabular'
 Plug 'dhruvasagar/vim-table-mode'
" Plug 'reedes/vim-pencil'
 Plug 'mbbill/undotree'
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
if version>=703 || (version>7.3 && version<10.0)
"	Plug 'Rip-Rip/clang_complete'
	Plug 'justmao945/vim-clang'
	Plug 'davidhalter/jedi-vim'
"	Plug 'Valloric/YouCompleteMe'
" syntax checking
	Plug 'scrooloose/syntastic'
	Plug 'chazy/cscope_maps'
endif
if exists(":tnoremap")
"   Plug 'jalvesaq/vimcmdline'
    Plug 'benekastah/neomake'
    Plug 'bfredl/nvim-ipy'
endif
 Plug 'ervandew/supertab'
 Plug 'plasticboy/vim-markdown'
" Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
" Plug 'vitorgalvao/autoswap_mac'
 Plug 'shinokada/dragvisuals.vim'
 Plug 'ron89/vim-copymode'
 Plug 'vim-scripts/gnuplot.vim'
" window manager
 Plug 'vim-scripts/taglist.vim'
 Plug 'majutsushi/tagbar'
 Plug 'vim-scripts/winmanager'
" thesaurus plugin
" Plug 'beloglazov/vim-online-thesaurus'
" Plug 'ron89/thesaurus_query.vim'
" Plug 'reedes/vim-lexical'
" Utilities
 Plug 'itchyny/calendar.vim'
" VOoM and organizer
 Plug 'vim-voom/VOoM'
" Plug 'hsitz/vimOrganizer'
" vim wiki
" Plug 'vimwiki/vimwiki'
" org-mode
 Plug 'tpope/vim-speeddating'
 Plug 'vim-scripts/SyntaxRange'
 Plug 'jceb/vim-orgmode'
 Plug 'vim-scripts/utl.vim'
" Color scheme
 Plug 'reedes/vim-colors-pencil'
 Plug 'altercation/vim-colors-solarized'
" call neobundle#end()
 call plug#end()
" call vundle#end()

" }}}
 
" configure for convenient vim plugins{{{
 
" variable initialization {{{
" dragvisuals -- drag visual block
let g:DVB_TrimWS = 1

" deoplete.nvim auto-complete module {{{
 if exists(":DeopleteEnable")
     let g:deoplete#enable_at_startup = 1
 endif
" }}}

" powerline initiation
" set rtp+=/usr/lib/python2.7/site-packages/powerline/bindings/vim
" set t_Co=256
"
" let g:ycm_global_ycm_extra_conf='~/.config/YouCompleteMe/.ycm_extra_conf.py'

" vim-latex configuration
 let g:Tex_ViewRule_pdf='okular'
 let g:Tex_ViewRule_dvi='xdvi -s 5 -keep -hush -editor "vim --servername vimlatex --remote +\%l \%f"'
 let g:Tex_ViewRule_pdf='zathura -x "vim --servername vimlatex --remote +\%{line} \%{input}"'
 let g:Tex_CompileRule_dvi='latex -interaction=nonstopmode -src-specials $*'
 let g:Tex_CompileRule_pdf='pdflatex -synctex=1 -interaction=nonstopmode -src-specials $*'

" online thesaurus
" nnoremap <leader>cs :OnlineThesaurusCurrentWord<CR><C-w>k

" Color scheme
" colors mayansmoke
" let g:pencil_higher_contrast_ui = 0
" let g:pencil_neutral_code_bg = 1
 let base16colorspace=256
" colors mayansmoke 
" set background=dark
 set background=light
 let g:pencil_terminal_italics = 1
" let g:airline_theme = 'pencil'
 let g:airline_theme = 'solarized'
" colors pencil
 colors solarized

" airline config
 let g:airline_powerline_fonts = 1

" thesaurus_query options
" let g:thesaurus_query#display_list_all_time = 1
 source ~/.vim/thesaurus_query.vim/plugin/thesaurus_query.vim

" Indent guide
" let g:indent_guides_auto_colors = 0
" hi IndentGuidesOdd  ctermbg=lightgrey
" hi IndentGuidesEven ctermbg=grey

" syntastics {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_python_exec = 'python2'
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_flake8_exec = 'flake8-python2'
let g:syntastic_python_pylint_exec = 'pylint2'
let g:syntastic_quiet_messages = { "level": "warnings" }
let g:syntastic_python_pylint_quiet_messages = { "level" : ["warnings"] }

"}}}

" cmdline configuration {{{
" let cmdline_vsplit = 1        " Split the window vertically
" let g:cmdline_esc_term = 1      " Remap <Esc> to :stopinsert in Neovim terminal
" let g:cmdline_in_buffer = 0     " Start the interpreter in a Neovim buffer
" let g:cmdline_term_height = 25  " Initial height of interpreter window or pane
" let g:cmdline_term_width = 80   " Initial width of interpreter window or pane
" let g:cmdline_tmp_dir = '/tmp'  " Temporary directory to save files
" let g:cmdline_outhl = 1         " Syntax highlight the output

" if &t_Co == 256
"     let cmdline_color_input = 247
"     let cmdline_color_normal = 39
"     let cmdline_color_number = 51
"     let cmdline_color_integer = 51
"     let cmdline_color_float = 51
"     let cmdline_color_complex = 51
"     let cmdline_color_negnum = 183
"     let cmdline_color_negfloat = 183
"     let cmdline_color_date = 43
"     let cmdline_color_true = 78
"     let cmdline_color_false = 203
"     let cmdline_color_inf = 39
"     let cmdline_color_constant = 75
"     let cmdline_color_string = 79
"     let cmdline_color_stderr = 33
"     let cmdline_color_error = 15
"     let cmdline_color_warn = 1
"     let cmdline_color_index = 186
" endif
let cmdline_follow_colorscheme = 1
" }}}

" " vim-lexical
" let g:lexical#spell = 1
" let g:lexical#thesaurus = ['~/.vim/thesaurus/mthesaur.txt',]
" let g:lexical#dictionary = ['/usr/share/dict/american-english','/usr/share/dict/british','/usr/share/dict/british-english']
" " let g:lexical#spellfile = ['~/.vim/spell/en.utf-8.add',]

" pencil mode {{{
 let g:pencil#wrapModeDefault = 'hard'
" }}}

" org-mode {{{
 let g:org_indent = 0
 let g:org_todo_keywords = [['TODO', 'WAITING', '|', 'DONE'],
   \   ['|', 'CANCELED']]
 let g:org_todo_keyword_faces = [['WAITING', 'cyan'], ['CANCELED',
   \   [':foreground red', ':background black', ':weight bold',
   \   ':slant italic', ':decoration underline']]]
"}}}

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
	endif

	if exists(":TableModeToggle")
		nnoremap <Leader>tm :TableModeToggle<CR>
		let g:table_mode_corner="|"
		let g:table_mode_corner_corner="+"
		let g:table_mode_header_fillchar="="
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
	
	" Taglist{{{
	if exists(":TlistToggle")
		nnoremap <Leader>tl :TlistToggle<CR>
		let g:Tlist_WinWidth = 40
		let g:tlist_cpp_settings = 'c++;d:macro;c:classes;m:class members;'. 
					\'f:functions;v:variables;l:local variables'
		let g:tlist_python_settings = 'python;i:imports;c:classes;'. 
					\'m:class members;f:functions;v:variables'
		let g:tlist_tex_settings = 'tex;c:chapters;s:sections;'. 
					\'u:subsections;b:subsubsections'
		let g:Tlist_GainFocus_On_ToggleOpen = 1
		if exists(":WMToggle")
			let g:winManagerWindowLayout = 'FileExplorer|TagList'
"			let g:winManagerWindowLayout = 'NERDTree|TagList'
			nnoremap <Leader>wm :WMToggle<CR>
		endif
	endif
    "}}}
    
    "Tagbar{{{
    if exists(":TagbarToggle")
        nnoremap <F8> :TagbarToggle<CR>
    endif
	"}}}
	
	" Winmanager {{{
	if exists(":WMToggle")
		nnoremap <Leader>wm :WMToggle<CR>
		let g:winManagerWidth=40
	endif
	" }}}

    " syntastic {{{
"    if exists(":lnext")
        nnoremap <LocalLeader>ne :lnext<CR>
        nnoremap <LocalLeader>pe :lprevious<CR>
        nnoremap <LocalLeader>fe :lfirst<CR>
        nnoremap <LocalLeader>le :llast<CR>
"    endif
    " }}}

"" vim-lexical {{{
" augroup lexical
"  autocmd!
"  autocmd FileType markdown,mkd call lexical#init()
"  autocmd FileType textile call lexical#init()
"  autocmd FileType tex call lexical#init()
"  autocmd FileType text call lexical#init()
"  " { 'spell': 0 }
"  autocmd Filetype journal call lexical#init()
" augroup END
" }}}

" indent_guides {{{
if exists("g:loaded_indent_guides")
    call indent_guides#enable()
endif
"}}}

"{{{
 nnoremap <Leader>ut :UndotreeToggle<CR>
"}}}

endfunction

" called after plugins are initiated.
augroup plugin_initialize
	autocmd!
	autocmd VimEnter * call LoadPluginScript()
augroup END


" " pencil {{{
" augroup pencil_Init_Per_FileType
"   autocmd!
"   autocmd FileType markdown,mkd call pencil#init({'wrap': 'soft'})
"   autocmd FileType text         call pencil#init({'wrap': 'hard'})
"   autocmd FileType tex          call pencil#init({'wrap': 'hard'})
" augroup END
"}}}

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
"	autocmd filetype cpp,c let g:clang_auto_select=1
"	if s:os == 'Darwin' || s:os == 'Mac'
"		autocmd filetype cpp,c let g:clang_library_path="/Library/Developer/CommandLineTools/usr/lib/"
"	elseif s:os == 'Linux'
"		autocmd filetype cpp,c let g:clang_library_path="/usr/lib"
"	endif
"	autocmd filetype cpp,c let g:clang_close_auto=1
"	autocmd filetype cpp,c let g:clang_complete_copen=1
"	autocmd filetype cpp,c let g:clang_hl_errors=1
"	autocmd filetype cpp,c let g:clang_close_preview=1
	autocmd Filetype cpp,c setlocal tw=80 
	autocmd Filetype cpp,c setlocal formatoptions=tcroqnj 
 	autocmd Filetype cpp,c inoremap <buffer> <CR> <esc>:call EnterBetweenBraces()<CR>a
augroup END
" }}}

" python specific {{{
" Autowrapping behavior for py {{{
" }}}

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'

" nvim-ipy configure {{{
" let g:nvim_ipy_perform_mappings = 0
" }}}

augroup filetype_python
	autocmd!
	autocmd filetype python setlocal tabstop=4
	autocmd filetype python setlocal sw=4
	autocmd filetype python setlocal softtabstop=0
	autocmd filetype python setlocal foldmethod=indent
	autocmd filetype python setlocal formatoptions=croqnj
	autocmd filetype python setlocal expandtab
augroup END

augroup IPy_vim_neo
    autocmd!
    autocmd filetype python map <buffer> <localleader>ip :IPython<CR>
    autocmd filetype python map <buffer><silent> <C-s> <Plug>(IPy-Run)
    autocmd filetype python map <buffer><silent> <localleader>h <Plug>(Ipy-WordObjInfo)
    autocmd filetype python map <buffer><silent> <F5> <Plug>(IPy-Interrupt)
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
"	autocmd Filetype tex setlocal dictionary+="~/.vim/bundle/vim-latex-suite/ftplugin/latex-suite/dictionaries/dictionary"
"	autocmd Filetype tex setlocal dictionary+="/usr/share/dict/words"
    autocmd Filetype tex setlocal dictionary+=/usr/share/dict/american-english
"   autocmd Filetype tex setlocal dictionary+="/usr/share/dict/british-english"
    autocmd Filetype tex setlocal thesaurus+=~/.vim/thesaurus/mthesaur.txt

	autocmd Filetype tex inoremap <buffer> ``'' ``''<++><esc>F`a
	autocmd Filetype tex setlocal spell
	autocmd Filetype tex setlocal tw=80
	autocmd Filetype tex setlocal formatoptions=tcroq2j
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

" Org-mode {{{
  let g:org_agenda_files=['~/org/index.org']
augroup filetype_org
	autocmd!
    autocmd Filetype org setlocal dictionary+=/usr/share/dict/american-english
    autocmd Filetype org setlocal spell
    autocmd Filetype tex setlocal thesaurus+=~/.vim/thesaurus/mthesaur.txt
augroup END
" }}}

" }}}
