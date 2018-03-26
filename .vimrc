"By HE Chong

set runtimepath^=~/.vim
let &packpath = &runtimepath

" General {{{
" detect OS type
let s:os=substitute(system('uname'),'\n','','')

" mapping {{{
let mapleader=","
let maplocalleader="\\"
" }}}

" command mode {{{
" use <C-k> to truncate the commandline content to the end of the line.
cnoremap <C-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>
" }}}
"
" Tab{{{
set sw=4
set tabstop=4
set expandtab
" }}}
 
" terminal for NeoVim {{{
if has('nvim')
 nnoremap <silent> <leader>st :sp<CR>:terminal<CR>
 tnoremap <esc> <c-\><c-n>
endif
" }}}

" Mode switch{{{
inoremap jk <esc>
"inoremap <esc> <nop>
" }}}

" Number{{{
if (version == 7.4)+(version>=704)
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
" }}}
"
" Folding{{{
" set folding {{{
function! NeatFoldText()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

set foldtext=NeatFoldText()
" }}}
" }}}
"
" bracket editing {{{
function! EnterBetweenBraces()
     let l:string=getline('.')[col('.')-1:col('.')]
     let l:append=getline('.')[col('.'):]
     if l:string=='{}'
         call setline('.',getline('.')[:col('.')-1])
         call append('.',[repeat('    ',indent('.')/&tabstop+1),repeat('    ',indent('.')/&tabstop).l:append])
         call cursor(line('.')+1,indent('.')/&tabstop+&tabstop)
     else
         call setline('.',getline('.')[:col('.')-1])
         call append('.',repeat('    ',indent('.')/&tabstop).l:append)
         call cursor(line('.')+1,indent('.')/&tabstop+&tabstop)
     endif
endfunction
" }}}
"
" Editing Environment {{{
" mouse
if has("mouse")
    set mouse=n
endif

" clipboard
if has('clipboard')
    set clipboard=unnamed,unnamedplus
endif

" conceallevel
if has("conceallevel")
    set conceallevel=2
endif

" number/relative number
if (version == 7.4)+(version>=704)
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
" }}}
" }}}
"
" Plugin manager{{{
call plug#begin('~/.vim/plugged')
" editor customization {{{
Plug 'mbbill/undotree'
" }}}
" Build Automation {{{
Plug 'igankevich/mesonic'
" }}}
" encryption {{{
Plug 'jamessan/vim-gnupg'
" }}}
" visual {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'osyo-manga/vim-over'
" }}}
" File-System Search {{{
Plug 'mileszs/ack.vim', {'on':'Ack'}   
" }}}
" snippets {{{
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" }}}
" general text manipulation {{{
Plug 'tpope/vim-surround'
Plug 'shinokada/dragvisuals.vim'
Plug 'godlygeek/tabular', { 'on': ['Tabularize'] }
Plug 'dhruvasagar/vim-table-mode', {'on': 'TableModeToggle'}
" }}}
" Commenting {{{
Plug 'tomtom/tcomment_vim'
" }}}
" general reference {{{
Plug 'ron89/thesaurus_query.vim'
" }}}
" git related {{{
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" }}}
" auto-complete framework {{{
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" C/C++
Plug 'zchee/deoplete-clang'
" Python
Plug 'zchee/deoplete-jedi'
" }}}
" filetype plugins {{{
" orgmode {{{
" }}}
" Syntax Checking {{{
Plug 'w0rp/ale'
" }}}
" }}}
call plug#end()
" }}}
"
" Plugin variable Setup {{{
" Plugin based visual {{{
set background=dark
colors gruvbox
let g:airline_theme='gruvbox'
nnoremap <C-s> :OverCommandLine<CR>
" }}}
" Ultisnips{{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipJumpForwardTrigger="<c-h>"
let g:UltiSnipJumpBackwardTrigger="<c-l>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir="~/.vim/my-snippets"
let g:UltiSnipsSnippetDirectories= ['UltiSnips', 'my-snippets']
" }}}
" Ack/silver_search {{{
 let g:ackprg = 'ag --nogroup --nocolor --column'
" }}}
" deoplete configuration {{{
let g:deoplete#enable_at_startup = 1
" }}}
" auto-complete framework {{{
" C/C++
let g:deoplete#sources#clang#libclang_path='/usr/lib/libclang.so'
let deoplete#sources#clang#clang_header='/usr/lib/clang'
" Python
let g:deoplete#sources#jedi#show_docstring=1
" }}}
" thesaurus_query options {{{
" let g:thesaurus_query#display_list_all_time = 1
" let g:thesaurus_query#use_local_thesaurus_source_as_primary = 1
" let g:tq_enabled_backends=["openoffice_en","thesaurus_com","datamuse_com","jeck_ru","mthesaur_txt"]
" let g:tq_enabled_backends=["openoffice_en","thesaurus_com","mthesaur_txt"]
" let g:tq_python_version = 3
" let g:tq_openoffice_en_file="~/.vim/thesaurus/th_en_US_v2"
" let g:tq_online_backends_timeout = 0.80
" let g:tq_truncation_on_definition_num = 2
" let g:tq_language = ['de', 'ru', 'en']
" }}}
" }}}
"
" Plugin function call related setup {{{

function! LoadPluginScript()
    " Table Mode {{{
    if exists(":TableModeToggle")
        nnoremap <Leader>tm :TableModeToggle<CR>
        let g:table_mode_corner="+"
        let g:table_mode_corner_corner="|"
        let g:table_mode_header_fillchar="-"
    endif
    " }}}
    " dragvisuals -- drag visual block {{{
    if exists("*DVB_Drag()")
        vmap <expr> <LEFT>      DVB_Drag('left')
        vmap <expr> <RIGHT>     DVB_Drag('right')
        vmap <expr> <DOWN>      DVB_Drag('down')
        vmap <expr> <UP>        DVB_Drag('up')
    endif
    if exists("*DVB_Duplicate()")
        vmap <expr> D           DVB_Duplicate()
    endif
    " }}}
    " UndoTree {{{
    if exists("g:loaded_undotree")
        nnoremap <Leader>ut :UndoTreeToggle<CR>
    endif
    " }}}
endfunction

augroup plugin_initialize
    autocmd!
    autocmd VimEnter * call LoadPluginScript()
augroup END
" }}}
"
" Document Type Customization {{{
" Vimrc editing{{{
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Vim folding{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd Filetype vim setlocal formatoptions=croqn     " wrapping disbled for code
augroup END
" }}}
" }}}
" C editing{{{
augroup filetype_cpp
    autocmd!
    autocmd filetype cpp,c setlocal foldmethod=syntax
    autocmd filetype cpp,c setlocal foldcolumn=4
    autocmd Filetype cpp,c setlocal tw=80
    autocmd Filetype cpp,c setlocal formatoptions=tcroqnj
     autocmd Filetype cpp,c inoremap <buffer> <CR> <esc>:call EnterBetweenBraces()<CR>a
augroup END
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
" }}}
" python specific {{{
" Autowrapping behavior for py {{{
" }}}

" let g:python_host_prog = '/usr/bin/python2'
" let g:python3_host_prog = '/usr/bin/python'
" nvim-ipy configure {{{
 let g:nvim_ipy_perform_mappings = 0

" " unmap <c-s>
"  map <silent> <c-s> <Plug>(IPy-Run)
"  map <silent> <leader>p? <Plug>(IPy-WordObjInfo)
"  map <silent> <leader>ps <Plug>(IPy-Interrupt)
"  map <silent> <leader>pk <Plug>(IPy-Terminate)
" " }}}

augroup filetype_python
    autocmd!
    autocmd filetype python setlocal tabstop=4
    autocmd filetype python setlocal sw=4
    autocmd filetype python setlocal softtabstop=0
    autocmd filetype python setlocal foldmethod=indent
    autocmd filetype python setlocal foldcolumn=4
    autocmd filetype python setlocal formatoptions=croqnj
    autocmd filetype python setlocal expandtab
augroup END

" augroup IPy_vim_neo
"     autocmd!
"     autocmd filetype python map <buffer> <localleader>ip :IPython<CR>
"     autocmd filetype python map <buffer><silent> <C-s> <Plug>(IPy-Run)
"     autocmd filetype python map <buffer><silent> <localleader>h <Plug>(Ipy-WordObjInfo)
"     autocmd filetype python map <buffer><silent> <F5> <Plug>(IPy-Interrupt)
"     autocmd filetype python nnoremap <localleader>fm :setlocal foldmethod=marker<CR>
" augroup END

" }}}
" gnuplot {{{
augroup filetype_gnuplot
    autocmd!
    autocmd BufNewFile,BufReadPost *.gnuplot set filetype=gnuplot
    autocmd BufNewFile,BufReadPost *.plt set filetype=gnuplot
    autocmd BufNewFile,BufReadPost *.gnu set filetype=gnuplot
augroup END
" }}}
" }}}

