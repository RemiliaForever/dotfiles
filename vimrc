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
set lcs=trail:▓,tab:\|\-
colorscheme default

vnoremap <c-c> "+y
vnoremap <c-x> "+c
nnoremap <c-p> "+p
nnoremap <c-a> ggvG$
nnoremap <c-h> :nohl<CR>

"autocmd InsertLeave * silent! !fcitx-remote -c
" format
autocmd FileType python map <buffer> <F3> :call Pyflakes()<CR>
autocmd FileType go map <buffer> <F3> :!gofmt -w %<CR><CR>
autocmd FileType h,c,cpp,cl,glsl map <buffer> <F3> :!clang-format -i -style="{BasedOnStyle: LLVM, UseTab: Never, ColumnLimit: 120, IndentWidth: 4, BreakBeforeBraces: Linux, AlignConsecutiveAssignments: true}" %<CR><CR>

" highlight
hi LineNr ctermfg=yellow
hi CursorLineNr cterm=bold ctermfg=yellow
hi Statement ctermfg=yellow
hi DiffText ctermfg=white cterm=reverse
hi DiffAdd ctermfg=white
hi Error ctermfg=white
hi ErrorMsg ctermfg=white
hi Pmenu ctermbg=white ctermfg=black
hi PmenuSel ctermbg=black ctermfg=white
let g:cpp_class_scope_highlight = 0
let g:cpp_experimental_template_highlight = 0

" NERDTree
let g:NERDTreeWinSize = 25
let g:NERDTree_title = '[NERD Tree]'
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['^cscope', '^__pycache__$', '^\.git$', '\.aux$', '\.bcf$', '\.toc$']
nnoremap <c-n> :NERDTreeToggle<CR>

" Tagbar
let g:tagbar_title = "[Tagbar]"
let g:tagbar_width = 25
nnoremap <c-l> :TagbarToggle<CR>

" Buffer Explorer
nnoremap <F2> :BufExplorer<CR>

" YCM
hi YcmErrorSection ctermfg=8 ctermbg=1
let g:ycm_global_ycm_extra_conf ='~/.vim/ycm/ycm_extra_conf.py'
set completeopt=longest,menu    "让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
autocmd InsertLeave * if pumvisible() == 0|pclose|endif    "离开插入模式后关闭预览窗口
inoremap <expr> <space>       pumvisible() ? "\<C-y>" : "\<space>"
"按空格键即选中当前项
"let g:ycm_cache_omnifunc=0    " 禁止缓存匹配项,每次都重新生成匹配项
"let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_min_num_of_chars_for_completion = 0
let g:ycm_python_binary_path = '/usr/bin/python'
let mapleader = ","
"nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR> 
"nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
"nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>

" cscope
if filereadable("cscope.out")
    set cst
    set csto=0
    set nocsverb
    set cspc=3
    cs add cscope.out
    nmap <C-j> :cn<CR>
    nmap <C-k> :cp<CR>
    nmap <C-_>a :cs find a <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
endif

" Bundle
call vundle#rc()
Bundle 'Valloric/YouCompleteMe'

Bundle 'scrooloose/nerdtree'
Bundle 'Tagbar'
Bundle 'cscope.vim'
Bundle 'pyflakes'
Bundle 'bufexplorer.zip'

Bundle 'ShaderHighLight'
Bundle 'beyondmarc/opengl.vim'
Bundle 'octol/vim-cpp-enhanced-highlight'

