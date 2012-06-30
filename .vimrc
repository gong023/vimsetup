"----------------------------------------------------
"----------------------------------------------------
"----------------------------------------------------
"bundle setting
"----------------------------------------------------
"----------------------------------------------------
"----------------------------------------------------
set nocompatible
filetype plugin indent off
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle'))
endif
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
NeoBundle 'git://github.com/Shougo/neocomplcache.git'
NeoBundle 'git://github.com/Shougo/unite.vim.git'
"NeoBundle 'git://github.com/Shougo/vimshell.git'
NeoBundle 'git://github.com/Shougo/vimproc.git'
NeoBundle 'git://github.com/Shougo/vimfiler.git'
NeoBundle 'git://github.com/thinca/vim-quickrun.git'
NeoBundle 'jelera/vim-javascript-syntax'
"NeoBundle 'pangloss/vim-javascript'
NeoBundle 'vim-scripts/sudo.vim'
NeoBundle 'YankRing.vim'
NeoBundle 'yuroyoro/vim-autoclose'
NeoBundle 'surround.vim'
NeoBundle 'git://github.com/scrooloose/nerdtree.git'
NeoBundle 'git://github.com/Sixeight/unite-grep.git'
NeoBundle 'git://github.com/sgur/unite-qf.git'

filetype plugin indent on
"----------------------------------------------------
"----------------------------------------------------
"----------------------------------------------------
"basic setting
"----------------------------------------------------
"----------------------------------------------------
"----------------------------------------------------
sy on
set t_Co=256
colorscheme molokai

set encoding=utf-8
set fileencoding=utf-8
"set fileencodings=euc-jp,iso-2022-jp,sjis,utf-8
"set encoding=euc-jp
"set fileencodings=euc-jp,iso-2022-jp,sjis,utf-8

set ts=4 sts=4 sw=4 noet
set shiftwidth=4
set softtabstop=4
set tabstop=4
au BufNewFile,BufRead *.js  set nowrap tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.css set nowrap tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.tpl set nowrap tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.inc set nowrap tabstop=2 shiftwidth=2 softtabstop=2
"set autoindent
"set tabstop=4
"set softtabstop=4
"set shiftwidth=4
set expandtab
set ruler
set hlsearch
set incsearch
set smartindent
set ignorecase

set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<
set backspace=indent,eol,start
"----------------------------------------------------
"highlight space
"----------------------------------------------------
function! SOLSpaceHilight()
    syntax match SOLSpace "^\s\+" display containedin=ALL
    highlight SOLSpace term=underline ctermbg=black
endf
function! JISX0208SpaceHilight()
    syntax match JISX0208Space "　" display containedin=ALL
    highlight JISX0208Space term=underline ctermbg=LightCyan
endf
if has("syntax")
    syntax on
        augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call SOLSpaceHilight()
        autocmd BufNew,BufRead * call JISX0208SpaceHilight()
    augroup END
endif
"----------------------------------------------------
"find encoding automatically
"----------------------------------------------------
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
    unlet s:enc_euc
    unlet s:enc_jis
endif
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif
set fileformats=unix,dos,mac
if exists('&ambiwidth')
    set ambiwidth=double
endif

"----------------------------------------------------
"----------------------------------------------------
"----------------------------------------------------
"plugin setting
"----------------------------------------------------
"----------------------------------------------------
"----------------------------------------------------

"----------------------------------------------------
"quick run
"----------------------------------------------------
silent! nmap <unique>\r<Plug>(quickrun)
"----------------------------------------------------

"----------------------------------------------------
"yanktmp
"----------------------------------------------------
map <silent> sy :call YanktmpYank()<CR> 
map <silent> sp :call YanktmpPaste_p()<CR> 
map <silent> sP :call YanktmpPaste_P()<CR> 
if has("win32")
    let g:yanktemp_file = $TEMP./'vimyanktemp'
endif

" ----------------------
" indent-guides.vim
" ----------------------
" indent-guides有効
"let g:indent_guides_enable_on_vim_startup=1
"let g:indent_guides_auto_colors = 0
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#121212 ctermbg=233
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#262626 ctermbg=235
"let g:indent_guides_color_change_percent=30
"let g:indent_guides_guide_size=1

"----------------------------------------------------
"neocomplcache
"----------------------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

 " Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Select with <TAB>
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

let g:neocomplcache_snippets_dir = "~/.vim/snippets"
" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
     \ 'default' : '',
     \ 'vimshell' : $HOME.'/.vimshell_hist',
     \ 'scheme' : $HOME.'/.gosh_completions'
\ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" for snippets
imap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-n>"
smap <C-k> <Plug>(neocomplcache_snippets_expand)
" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1
" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

"----------------------------------------------------
"unite.vim
"----------------------------------------------------
" 入力モードで開始
let g:unite_enable_start_insert=1
nnoremap ff :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
inoremap <silent> <C-f> <ESC>:<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap fm :<C-u>Unite buffer file_mru<CR>
inoremap <silent> <C-b> <ESC>:<C-u>Unite buffer file_mru<CR>
" unite.vim上でのキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " 単語単位からパス単位で削除するように変更
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " ESCキーを2回押すと終了する
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction
"nnoremap <silent> ug :Unite grep:%:-iHRn<CR>
nnoremap <silent> ,ug :Unite grep:./:-iHRnr<CR>
"----------------------------------------------------
"NERDTree.vim
"----------------------------------------------------
"
"nnoremap <silent><F2>:NERDTreeToggle<CR>
"let NERDTreeWinPos="top"
let NERDTreeSplitVertical=0
let NERDTreeWinSize=30
"----------------------------------------------------
"vimfiler.vim
"----------------------------------------------------
let g:vimfiler_as_default_explorer = 0
let g:vimfiler_safe_mode_by_default = 0
nnoremap <silent> <C-x> :VimFiler -buffer-name=explorer -split -winwidth=45 -toggle -no-quit<Cr>
autocmd! FileType vimfiler call g:my_vimfiler_settings()
function! g:my_vimfiler_settings()
  nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
"  nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
"  nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
endfunction

let my_action = { 'is_selectable' : 1 }
function! my_action.func(candidates)
  wincmd p
  exec 'split '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_split', my_action)

let my_action = { 'is_selectable' : 1 }                     
function! my_action.func(candidates)
  wincmd p
  exec 'vsplit '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_vsplit', my_action)

"----------------------------------------------------
"----------------------------------------------------
"----------------------------------------------------
"my command
"----------------------------------------------------
"----------------------------------------------------
"----------------------------------------------------
"ab _echo echo 'hello';
"ab _err error_log();
"ab setapp $this->af->setApp('', $);
"ab getapp $this->af->get('');
"ab switch switch($) { case: }
"ab _trace print_a(debug_backtrace());
"ab thiss $this->
"
"nmap ,ee :e ++enc=euc-jp<CR>
"nmap ,uu :e ++enc=utf-8<CR>
"
"nmap aw 5w
"nmap ae 5e
"nmap ab 5b
"nmap ah 10h
"nmap al 10l
"nmap aj 7j
"nmap ak 7k
"nmap <C-e> <End>
"nmap <C-a> <Home>
"nmap <Esc><Esc> :nohlsearch<CR><Esc>
"vnoremap <C-e> <End>
"vnoremap <C-a> <Home>
"inoremap <C-e> <End>
"inoremap <C-a> <Home>
"
"imap nn <Esc>
"nmap ; : 
"" カレントディレクトリの移動
"command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>',  '<bang>')
"function! s:ChangeCurrentDir(directory,  bang)
"    if a:directory == ''
"        lcd %:p:h
"    else
"        execute 'lcd' . a:directory
"    endif
"
"    if a:bang == ''
"        pwd
"    endif
"endfunction
"nnoremap <silent> <Space>cd :<C-u>CD<CR>
