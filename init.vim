" vim:fdm=marker

" vim-plug Setting {{{
" github.com/junegunn/vim-plug
" To install use :PlugInstall

" Should auto install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set nocompatible
call plug#begin()

Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-sleuth'

Plug 'kana/vim-submode'
Plug 'wellle/targets.vim'

Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'


" LaTeX
Plug 'lervag/vimtex'

" JSON
Plug 'elzr/vim-json'

" Colours
Plug 'iCyMind/NeoSolarized'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'

" lsp
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

call plug#end()            " required


" Automatic reloading of .vimrc
aug reload_vimrc
    au!
    au bufwritepost $MYVIMRC :source $MYVIMRC
aug END

" }}}

" Look and Feel {{{

" Color scheme
syntax enable
set background=dark
colorscheme onedark

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Curser and Number setting
set number
set relativenumber
set cursorline
set colorcolumn=80
highlight ColorColumn guibg=red

" }}}

" Tests {{{

" Allow applying macros to visual selection
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
	echo "@".getcmdline()
	execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Look for tags file up and up and up ...
set tags=./TAGS,TAGS;

" }}}

" General Settings {{{

" Switch buffers without having to write
set hidden

" Bind exiting the terminal
tnoremap <c-[> <c-\><c-n> 

" Reduce time out deylay
set timeoutlen=1000 ttimeoutlen=0

" Abbreviations {{{

:iabbrev @@ jakob@schmutz.co.uk

" }}}

" Rebind <Leader> key
nnoremap <Space> <NOP>
nnoremap . <NOP>
nnoremap ; <NOP>
let mapleader = ";"
let maplocalleader = "\\"
nnoremap . ;
nnoremap <Space> .

" j,k move by visual lines, gj gk move by actual lines
nnoremap j gj
nnoremap k gk
nnoremap gj j 
nnoremap gk k

" Make tabs appear as 4 spaces, sleuth does the rest
set tabstop=4

" Quickly open .vimrc
nnoremap <leader>cfv :e $MYVIMRC<cr>

" Super easy split management {{{
" Fuction to check if a split exits in a given direction and open one if not
function! SelectorOpenNewSplit(key, cmd)
    let current_window = winnr()
    execute 'wincmd' a:key
    if current_window == winnr()
        execute a:cmd
        execute 'wincmd' a:key
    endif
endfunction

" Call the fuction bound to control movent keys
if !exists("g:gui_oni")
    nnoremap <silent> <c-w>k :call SelectorOpenNewSplit('k', 'leftabove split')<cr>
    nnoremap <silent> <c-w>j :call SelectorOpenNewSplit('j', 'leftabove split')<cr>
    nnoremap <silent> <c-w>h :call SelectorOpenNewSplit('h', 'leftabove vsplit')<cr>
    nnoremap <silent> <c-w>l :call SelectorOpenNewSplit('l', 'leftabove vsplit')<cr>
endif

" grow/shrink
call submode#enter_with('grow/shrink', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('grow/shrink', 'n', '', '<C-w>-', '<C-w>-')
call submode#map('grow/shrink', 'n', '', '-', '<C-w>-')
call submode#map('grow/shrink', 'n', '', '+', '<C-w>+')

" left/right
call submode#enter_with('left/right', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('left/right', 'n', '', '<C-w>>', '<C-w>>')
call submode#map('left/right', 'n', '', '<', '<C-w><')
call submode#map('left/right', 'n', '', '>', '<C-w>>')

"}}}

" Search Settings
set hlsearch
set incsearch
set ignorecase
set smartcase
nnoremap <silent> <leader>, :nohl<cr>

" permenant undo in all buffers
set undofile

" Highlight word under cursor
nnoremap + *N
" Change word under cursor
nnoremap c* *Ncgn
nnoremap c# #NcgN

" }}}

" lsp {{{

let g:LanguageClient_serverCommands = {
    \ 'python': ['~/.config/lsp/pyls/env/bin/python', '-m', 'pyls', '-v']
    \ }

autocmd FileType * call LanguageClientMaps()

function! LanguageClientMaps()
	if has_key(g:LanguageClient_serverCommands, &filetype)
		nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
		nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
		nnoremap <buffer> <silent> <leader>fr :call LanguageClient#textDocument_references()<cr>
		nnoremap <buffer> <silent> <leader>rn :w<CR>:call LanguageClient#textDocument_rename()<CR>:w<CR>
		nnoremap <buffer> <silent> <leader>rc :w<CR>:call LanguageClient#textDocument_rename({'newName': Abolish.camelcase(expand('<cword>'))})<CR>:w<CR>
		nnoremap <buffer> <silent> <leader>rs :w<CR>:call LanguageClient#textDocument_rename({'newName': Abolish.snakecase(expand('<cword>'))})<CR>:w<CR>
		nnoremap <buffer> <silent> <leader>ru :w<CR>:call LanguageClient#textDocument_rename({'newName': Abolish.uppercase(expand('<cword>'))})<CR>:w<CR>
	endif
endfunction

" }}}

" Plugin Settings {{{

" VimTex {{{
let g:vimtex_view_method = 'mupdf'
"let g:vimtex_compiler_latexmk = {
"	\ 'backend' : 'jobs',
"	\ 'background' : 0,
"	\ 'build_dir' : '',
"	\ 'callback' : 1,
"	\ 'continuous' : 1,
"	\ 'executable' : 'latexmk',
"	\ 'options' : [
"	\   '-pdf',
"	\   '-verbose',
"	\   '-file-line-error',
"	\   '-synctex=1',
"	\   '-interaction=nonstopmode',
"	\ ],
"	\}
"let g:vimtex_view_automatic = 1

" }}}

" ncm2 {{{

autocmd BufEnter  *  call ncm2#enable_for_buffer()

" Affects the visual representation of what happens after you hit <C-x><C-o>
" https://neovim.io/doc/user/insert.html#i_CTRL-X_CTRL-O
" https://neovim.io/doc/user/options.html#'completeopt'
"
" This will show the popup menu even if there's only one match (menuone),
" prevent automatic selection (noselect) and prevent automatic text injection
" into the current line (noinsert).
set completeopt=noinsert,menuone,noselect

" }}}


" }}}

" Language Settting {{{

" Python Settings {{{

" Point neovim at python3 env
let g:python3_host_prog = '/usr/local/bin/python3'


" Turns off this. The tabstop was super annoying
""if !exists("g:python_recommended_style") || g:python_recommended_style != 0
""    " As suggested by PEP8.
""    setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
""endif
let g:python_recommended_style = 0

" some settings to make python easier to work with
aug pythonSetting
	au!
	au filetype python setlocal fileformat=unix
	au filetype python setlocal colorcolumn=80
aug END


" }}}

" Go Settings {{{

aug detect_go_files
    au!
    au BufRead,BufNewFile *.go, set filetype=go
aug END

" }}}

" R Settings {{{

" some settings to make R easier to work with
aug RSetting
	au!
	au filetype r setlocal fileformat=unix
	au filetype r setlocal colorcolumn=80
aug END

" }}}

" {{{ C/C++ Settings

aug CSetting
	au!
aug END

" }}}

" Haskell Settings {{{

aug detect_haskell_files
    au!
    au BufRead,BufNewFile *.hs, set filetype=haskell
aug END

" some settings to make Haskell easier to work with
aug hsSetting
	au!
	au filetype haskell setlocal fileformat=unix
	au filetype haskell setlocal colorcolumn=80
aug END

" }}}

" Markdown Settings {{{

aug spell_checkMd
    au!
    au filetype markdown setlocal spell
aug END

" }}}

" Octave Setttings {{{

" .m files are "octave" files
aug detect_octave_files
    au!
    au BufRead,BufNewFile *.m, set filetype=octave
aug END

" F5 will execute the octave script
aug execute_script
    au!
    au filetype octave map <buffer> <f5> gg0pkg load all<esc>Gopause<esc>:w<cr>:!octave -qf %<cr>ddggdd:w<cr>
aug END


" }}}

" LeTeX Settings {{{

" Set filetype
au BufNewFile,BufRead *.tex set filetype=tex

" Spell check in .tex files
aug spell_checkTeX
    au!
    au Filetype tex setlocal spell
aug END

aug auto_compile_Tex
	au!
	au Filetype tex noremap <F6> :NeomakeSh latexmk -cd -pdf %<cr>
	au FileType tex noremap <F5> :NeomakeSh mupdf %:r.pdf<cr>
aug END

" }}}

" Groff Settings {{{

" Set filetype
au BufNewFile,BufRead *.mom set filetype=groff
au BufNewFile,BufRead *.ms set filetype=groff

" Spell check and formatting in groff files
aug spell_checkTeX
    au!
    au Filetype groff setlocal spell
    au Filetype groff setlocal tw=79
aug END

aug createPDF
	au!
	au Filetype groff noremap <buffer> <leader>fa :call CompileGroffFile()<cr>
aug END

function! CompileGroffFile()
	let ext = expand("%:e")
	if ext == "ms"
		execute "up!"
		execute "!groff -ms" expand("%") "\| ps2pdf -" expand("%:r") . ".pdf"
	elseif ext == "mom"
		execute "up!"
		execute "!groff -mom" expand("%") "\| ps2pdf -" expand("%:r") . ".pdf"
	endif
endfunction

" }}}

" Java Settings {{{

" Compile code
aug compiling
    au!
    au FileType java nnoremap <buffer> <F6> :w!<cr>:!javac %<cr>
aug END


" }}}

" crontab {{{

autocmd filetype crontab setlocal nobackup nowritebackup

" }}}

" }}}
