" vim:fdm=marker

" vim-plug Setting {{{
"" github.com/junegunn/vim-plug
"" To install use :PlugInstall
set nocompatible

call plug#begin()

Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-surround'
Plug 'kana/vim-submode'

"" lsp
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'junegunn/fzf'
Plug 'ncm2/ncm2'

"" LaTeX
Plug 'lervag/vimtex'

"" Colours
Plug 'iCyMind/NeoSolarized'
Plug 'joshdick/onedark.vim'

call plug#end()            " required


"" Automatic reloading of .vimrc
aug reload_vimrc
    au!
    au bufwritepost $MYVIMRC :source $MYVIMRC
aug END

"" }}}

" Look and Feel {{{

" Color scheme
syntax enable
let g:solarized_termcolors=256
set background=dark

if !exists("g:gui_oni")
    colorscheme NeoSolarized
endif

" Curser and Number setting
set number  " show line numbers
set cursorline
set colorcolumn=80

" }}}

" Tests {{{

" Reduce time out deylay
set timeoutlen=1000 ttimeoutlen=0

" }}}

" General Settings {{{

" Bind exiting the terminal
tnoremap <c-[> <c-\><c-n> 


" Abbreviations {{{

:iabbrev @@ jakob@schmutz.co.uk

" }}}

"" Rebind <Leader> key
nnoremap <Space> <NOP>
let mapleader = "\<Space>"

" Make tabs appear as 4 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4

"" Quickly open .vimrc
nnoremap <leader>v :e $MYVIMRC<cr>

"" File commands
noremap <Leader>q :q<CR>  " Quit current window
noremap <Leader>Q :wqa!<CR>   " Quit all windows
noremap <leader>w :w<cr>

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
nnoremap <leader>, :nohl<cr>

" }}}

" Plugin Settings {{{

" Language Server {{{

" required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_autoStart = 1

let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'go': ['go-langserver'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" }}}

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

"" }}}

" Goyo {{{

"" Toggle Goyo
nnoremap <leader>g :Goyo<cr>

" }}}

"" }}}

" Python Settings {{{

" Point neovim at python3 env
let g:python3_host_prog = '/usr/local/bin/python3'



" some settings to make python easier to work with
aug pythonSetting
	au!
	au filetype python setlocal tabstop=4
	au filetype python setlocal softtabstop=4
	au filetype python setlocal shiftwidth=4
	au filetype python setlocal textwidth=79
	au filetype python setlocal expandtab
	au filetype python setlocal autoindent
	au filetype python setlocal fileformat=unix
	au filetype python setlocal colorcolumn=80
aug END

" Run python script
aug runscript
	au!
	au FileType python nnoremap <silent><leader>fs :w!<cr>:!python3 %<cr>
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
	au filetype r setlocal tabstop=2
	au filetype r setlocal softtabstop=2
	au filetype r setlocal shiftwidth=2
	au filetype r setlocal textwidth=79
	au filetype r setlocal expandtab
	au filetype r setlocal autoindent
	au filetype r setlocal fileformat=unix
	au filetype r setlocal colorcolumn=80
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
    au BufRead,BufNewFile *.tex setlocal spell
aug END

" Compile with latexmk cont feature
" Make sure latexmkrc has
" $pdf_update_method = 2;
" $pdf_previewer = 'mupdf';
aug auto_compile_Tex
	au!
	au Filetype tex noremap <F6> :NeomakeSh latexmk -cd -pdf %<cr>
	au FileType tex noremap <F5> :NeomakeSh mupdf %:r.pdf<cr>
aug END

" Navigating with guides
aug nav_bindings
	au!
	au Filetype tex
		\inoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
		\vnoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
		\map <Space><Tab> <Esc>/<++><Enter>"_c4l
		\inoremap ;gui <++>
aug END
" }}}

" Java Settings {{{

" Compile code
aug compiling
    au!
    au FileType java nnoremap <F6> :w!<cr>:!javac %<cr>
aug END


" }}}

