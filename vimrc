" An example for a vimrc file.
"
" Maintainer:    Bram Moolenaar <Bram@vim.org>
" Last change:    2015 Mar 24
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"          for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"        for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
    set nobackup        " do not keep a backup file, use versions instead
else
    set backup        " keep a backup file (restore to previous version)
    set undofile        " keep an undo file (undo changes after closing)
endif
set history=50        " keep 50 lines of command line history
set ruler        " show the cursor position all the time
set showcmd        " display incomplete commands
set incsearch        " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufReadPost *
                    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

else

    set autoindent        " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If unset (default), this may break plugins (but it's backward
    " compatible).
    set langnoremap
endif

" 个人设置
set helplang=cn
set encoding=utf-8
set number
set ignorecase
set autoread
set nocompatible
set confirm
set scrolloff=3
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set undodir=~/.vim/history
set nobackup
set noswapfile
set nowritebackup
filetype on
filetype plugin on
filetype indent on
set foldenable
set autoindent
set smartindent
set cursorline
set showcmd
set mouse=a
set fillchars=vert:\ ,stl:\ ,stlnc:-
set list
set fdm=syntax
set foldlevelstart=99
set previewheight=8
set lcs=trail:▓,tab:\|\-
colorscheme default

map q: <Nop>
vnoremap <c-c> "+y
vnoremap <c-x> "+c
nnoremap <c-p> "+p
nnoremap <c-a> ggvG$
nnoremap <c-h> :nohl<CR>

" relative number
nmap <F1> :call ToggleRelativeNumber()<CR>
imap <F1> <c-o>:call ToggleRelativeNumber()<CR>
set relativenumber
let s:current_relative_number_mode = 1
function ToggleRelativeNumber()
    if s:current_relative_number_mode == 1
        let s:current_relative_number_mode = 0
        set norelativenumber
    else
        let s:current_relative_number_mode = 1
        set relativenumber
    endif
endfunction
" hide cursorline when buffer unfocused
augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
" Buffer Explorer
nnoremap <F2> :BufExplorer<CR>

" 16hex
nnoremap <F4> :call ToggleHex()<CR>
let s:current_hex_mode = 0
function ToggleHex()
    if s:current_hex_mode == 1
        let s:current_hex_mode = 0
        %!xxd -r
    else
        let s:current_hex_mode = 1
        %!xxd
    endif
endfunction

nnoremap <F5> :!xdg-open %<CR><CR>
" frontend
autocmd FileType html set filetype=html.javascript
au BufNewFile,BufRead *.vue set filetype=html.javascript
autocmd FileType html.javascript,javascript map <buffer> <F3> :!./node_modules/.bin/eslint --fix %<CR>:SyntasticCheck<CR>
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = './node_modules/.bin/eslint'
" python
autocmd FileType python map <buffer> <F3> :!autopep8 -i --max-line-length 120 %<CR>:SyntasticCheck<CR>
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--max-line-length=120'
" rust
au BufNewFile,BufRead *.toml set filetype=toml
autocmd FileType rust map <buffer> <F3> :RustFmt <CR>
let g:rustfmt_autosave = 1
let g:ycm_rust_src_path = '/usr/lib/rustlib/src/rust/src'
let g:syntastic_rust_rustc_exe = 'cargo check'
let g:syntastic_rust_rustc_fname = ''
let g:syntastic_rust_rustc_args = '--'
let g:syntastic_rust_checkers = ['rustc']
" java
let g:syntastic_java_checkers = []
" format
let mapleader = ","
autocmd FileType qrc set filetype=qrc.xml
autocmd FileType h,c,cpp,cl,glsl map <buffer> <F3> :!clang-format -i -style="{BasedOnStyle: LLVM, UseTab: Never, ColumnLimit: 120, IndentWidth: 4, BreakBeforeBraces: Linux, AlignConsecutiveAssignments: true, BreakConstructorInitializersBeforeComma: true}" %<CR><CR>


" highlight
hi LineNr ctermfg=yellow
hi CursorLineNr cterm=bold ctermfg=yellow
hi Statement ctermfg=yellow
hi DiffText ctermfg=white cterm=reverse
hi DiffAdd ctermfg=black
hi DiffChange ctermfg=black
hi Error ctermfg=white
hi ErrorMsg ctermfg=white
hi SpellBad ctermbg=224 ctermfg=black
hi Pmenu ctermbg=white ctermfg=black
hi PmenuSel ctermbg=black ctermfg=white
hi Folded ctermfg=6 ctermbg=0
let g:cpp_class_scope_highlight = 0
let g:cpp_experimental_template_highlight = 0

" NERDTree
let g:NERDTreeWinSize = 30
let g:NERDTree_title = '[NERD Tree]'
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['^__pycache__$', '^\.git$', '^node_modules$']
nnoremap <c-n> :NERDTreeToggle<CR>

" Tagbar
let g:tagbar_width = 30
let g:tagbar_type_rust= {
    \ 'ctagstype' : 'Rust',
    \ 'kinds'     : [
    \ 'f:function definitions',
    \ 'T:type definitions',
    \ 'g:enumeration names',
    \ 's:structure names',
    \ 'm:module names',
    \ 'c:static constants',
    \ 't:traits',
    \ 'i:trait implementations',
    \ 'd:macro definitions',
    \ ],
    \ 'sort:'   : 0
    \}
nnoremap <c-l> :TagbarToggle<CR>

" YCM
hi YcmErrorSection ctermfg=8 ctermbg=1
let g:ycm_global_ycm_extra_conf ='~/.vim/ycm/ycm_extra_conf.py'
set completeopt=longest,menu    "让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
"按空格键即选中当前项
"let g:ycm_cache_omnifunc=0    " 禁止缓存匹配项,每次都重新生成匹配项
"let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_python_binary_path = '/usr/bin/python'
nnoremap [d :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap [l :YcmCompleter GoTo<CR>
nnoremap [t :YcmCompleter GetType<CR>
nnoremap [p :YcmCompleter GetParent<CR>
nnoremap [o :YcmCompleter GetDoc<CR>
nnoremap [q :pclose<CR>

" fcitx
autocmd InsertLeave * call system('fcitx-remote -c')

" latex
let g:Tex_CompileRule_pdf = 'xelatex -interaction=nonstopmode -halt-on-error -synctex=1 $*'
let g:Tex_GotoError = 0
let g:Tex_IgnoredWarnings =
\"Underfull\n".
\"Overfull\n".
\"specifier changed to\n".
\"You have requested\n".
\"Missing number, treated as zero.\n".
\"There were undefined references\n".
\"Citation %.%# undefined\n".
\"Latex Font Warning: %s\n".
\"Package microtype Warning: %s\n".
\"Package pgfplots Warning: %s\n"
let g:Tex_IgnoreLevel = 10
let g:Tex_ViewRule_pdf = 'zathura'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_UsePython = 0
autocmd FileType tex nmap <Leader>lb :<C-U>exec '!biber '.Tex_GetMainFileName(':p:t:r')<CR>
let g:syntastic_quiet_messages = { "regex": [
        \ '\mpossible unwanted space at "{"',
        \ 'bottomrule from booktabs',
        \ 'You should put a space in front of parenthesis',
        \ ] }

" Bundle
call vundle#rc()
Bundle 'Valloric/YouCompleteMe'
Bundle 'rust-lang/rust.vim'
Bundle 'gerw/vim-latex-suite'
Bundle 'scrooloose/syntastic'

Bundle 'scrooloose/nerdtree'
Bundle 'bufexplorer.zip'
Bundle 'Tagbar'

Bundle 'cespare/vim-toml'
Bundle 'ShaderHighLight'
Bundle 'beyondmarc/opengl.vim'
Bundle 'octol/vim-cpp-enhanced-highlight'
Bundle 'othree/html5.vim'
