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
set swapfile
set directory=~/.vim/swap
set nobackup
set writebackup
set backupdir=~/.vim/backup
set foldenable
set autoindent
set smartindent
set nocursorline
set showcmd
set mouse=a
set fillchars=vert:\ ,stl:\ ,stlnc:-
set list
set nospell
set fdm=syntax
set foldlevelstart=99
set previewheight=8
set splitbelow
set timeoutlen=3000
set ttimeoutlen=0
set lcs=trail:▓,tab:\|\-
colorscheme default
filetype on
filetype plugin on
filetype indent on

map q: <Nop>
vnoremap <c-c> "+y
vnoremap <c-x> "+c
nnoremap <c-p> "+p
nnoremap <c-h> :nohl<CR>

" hide cursorline when buffer unfocused
" augroup CursorLine
"     au!
"     au VimEnter * setlocal cursorline
"     au WinEnter * setlocal cursorline
"     au BufWinEnter * setlocal cursorline
"     au WinLeave * setlocal nocursorline
" augroup END
" relative number
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
" Buffer Explorer
nnoremap <F1> :BufExplorer<CR>
nnoremap <F2> :Leaderf tag<CR>
nnoremap <F3> :Leaderf 
nnoremap <F4> :!xdg-open %<CR><CR>
nmap <F5> :call ToggleRelativeNumber()<CR>
imap <F5> <c-o>:call ToggleRelativeNumber()<CR>
" 16hex
nnoremap <F6> :call ToggleHex()<CR>
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
nnoremap <c-g> :SignifyToggle<CR>

" highlight
hi Visual ctermbg=244
hi LineNr ctermfg=214
hi CursorLineNr cterm=bold ctermfg=yellow
hi Statement ctermfg=yellow
hi Folded ctermfg=cyan ctermbg=black
hi Error ctermfg=red ctermbg=gray cterm=bold
hi Todo ctermfg=yellow ctermbg=gray cterm=bold
hi Search ctermfg=black ctermbg=yellow
hi SpecialKey ctermfg=168
hi DiffText ctermbg=lightgray ctermfg=black cterm=italic
hi DiffAdd ctermbg=lightgreen ctermfg=black
hi DiffChange ctermbg=lightmagenta ctermfg=black
hi DiffDelete ctermbg=lightred ctermfg=black
hi SpellCap ctermbg=black
hi SpellBad ctermbg=lightred ctermfg=black
hi MatchParen ctermbg=none cterm=bold,italic
hi Pmenu ctermbg=white ctermfg=black
hi PmenuSel ctermbg=black ctermfg=white
let g:cpp_class_scope_highlight = 0
let g:cpp_experimental_template_highlight = 0
hi SignColumn ctermbg=darkgray
hi SignifySignAdd ctermfg=green ctermbg=gray cterm=bold
hi SignifySignChange ctermfg=yellow ctermbg=gray cterm=bold
hi SignifySignDelete ctermfg=red ctermbg=gray cterm=bold

" statusline
hi StatusLineGit ctermbg=21 cterm=reverse
hi StatusLineALE ctermbg=196 cterm=reverse
hi StatusLineTag ctermbg=226 cterm=reverse

function! ModeStatus() abort
    let l:mode = mode()
    if l:mode == 'n'
        hi ModeStatus ctermbg=232 cterm=reverse
        let l:mode = 'NORMAL'
    elseif l:mode == 'i'
        hi ModeStatus ctermbg=033 cterm=reverse
        let l:mode = 'INSERT'
    elseif l:mode == 'v' || l:mode == 'V' || l:mode == ''
        hi ModeStatus ctermbg=214 cterm=reverse
        let l:mode = 'VISUAL'
    elseif l:mode == 'R' || l:mode == 'Rv'
        hi ModeStatus ctermbg=124 cterm=reverse
        let l:mode = 'REPLAC'
    elseif l:mode == 's' || l:mode == 's' || l:mode == ''
        hi ModeStatus ctermbg=076 cterm=reverse
        let l:mode = 'SELECT'
    elseif l:mode == 'cv' || l:mode == 'ce'
        hi ModeStatus ctermbg=001 cterm=reverse
        let l:mode = 'EXMODE'
    else
        hi ModeStatus ctermbg=246 cterm=reverse
        let l:mode = 'UNKNOW'
    endif
    return '[' . l:mode . ']'
endfunction
hi ModeStatusEnd ctermbg=NONE cterm=NONE
set statusline=%#ModeStatus#
set statusline+=%{ModeStatus()}
set statusline+=%*
set statusline+=%f\ %h%w%m%r

set statusline+=%#StatusLineGit#
set statusline+=%{FugitiveStatusline()}

augroup StatusLineRefresher
    autocmd!
    autocmd User GutentagsUpdating redrawstatus
    autocmd User GutentagsUpdated redrawstatus
    autocmd User ALELintPre let g:LinterProgress = '[Lint...]' | redrawstatus
    autocmd User ALELintPost let g:LinterProgress = '' | redrawstatus
    autocmd User ALEFixPre let g:FixerProgress = '[Fix...]' | redrawstatus
    autocmd User ALEFixPost let g:FixerProgress = '' | redrawstatus
augroup END
set statusline+=%#StatusLineTag#
set statusline+=%{gutentags#statusline('[',']')}

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '' : printf(
    \   '[❗️%d ❌%d]',
    \   all_non_errors,
    \   all_errors
    \)
endfunction
let g:LinterProgress = ''
let g:FixerProgress = ''
set statusline+=%#StatusLineALE#
set statusline+=%{LinterProgress}
set statusline+=%{FixerProgress}
set statusline+=%{LinterStatus()}
set statusline+=%*

set statusline+=%=%(%l,%c%V\ %=\ %P%)

set laststatus=2

" nerdtree
let g:NERDTreeWinSize = 30
let g:NERDTree_title = '[NERD Tree]'
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['^build$', '^__pycache__$', '^\.git$', '^node_modules$', '\.aux$', '\.fls$', '\.fdb_latexmk$', '\.toc$', '\.xdv$', '\.log$', '\.out$']
nnoremap <c-n> :NERDTreeToggle<CR>
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "🔧",
    \ "Staged"    : "➕",
    \ "Untracked" : "🔸",
    \ "Renamed"   : "🌀",
    \ "Unmerged"  : "🔱",
    \ "Deleted"   : "❌",
    \ "Dirty"     : "❗️",
    \ "Clean"     : "⭕️",
    \ 'Ignored'   : "◽️",
    \ "Unknown"   : "❓"
    \ }
augroup NerdTreeAutoRefresh
    autocmd!
    au BufWritePost * if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1 | NERDTreeFocus | execute 'normal R' | wincmd p | endif
augroup END

" Tagbar
let g:tagbar_width = 30
nnoremap <c-l> :TagbarToggle<CR>
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
    \ ]
    \}

" gutentags
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']
let g:gutentags_ctags_tagfile = '.tags'
let s:vim_tags = expand('~/.vim/tags')
let g:gutentags_cache_dir = s:vim_tags
let g:gutentags_file_list_command = 'rg --files'

" leaderf
let g:Lf_WindowHeight = 0.3


" ale
let g:ale_echo_delay = 20
let g:ale_lint_delay = 300
let g:ale_sign_warning = '>>'
let g:ale_linters = {
\   'tex': ['chktex'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'typescript': ['eslint'],
\   'cpp': ['clangcheck'],
\   'rust': ['rls'],
\   'python': ['flake8'],
\   }
let g:ale_c_build_dir = './build'
let g:ale_rust_cargo_check_all_targets = 1
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_default_feature_behavior = 'all'
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_insert_leave = 1
let g:ale_fixers = {
\   'rust': ['rustfmt'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'typescript': ['eslint', 'tslint'],
\   'python': ['yapf'],
\   }
let g:ale_c_clangformat_options = '-style="{BasedOnStyle: LLVM, UseTab: Never, ColumnLimit: 120, IndentWidth: 4, BreakBeforeBraces: Linux, AlignConsecutiveAssignments: true, BreakConstructorInitializersBeforeComma: true}"'
let g:ale_python_flake8_options = '--max-line-length 120'
let g:ale_fix_on_save = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

augroup FileTypeChecking
    autocmd!
    au filetype vue set filetype=vue.typescript
    au filetype vue syntax sync fromstart
    au BufNewFile,BufRead *.vert,*.tesc,*.tese,*.glsl,*.geom,*.frag,*.comp set filetype=glsl
    au BufNewFile,BufRead *.qrc set filetype=xml
augroup END

" polyglot
let g:vue_disable_pre_processors = 1
let g:polyglot_disabled = ['latex']
" YouCompleteMe
let g:ycm_rust_src_path = '~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
let g:ycm_global_ycm_extra_conf ='~/.vim/ycm_extra_conf.py'
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_enable_diagnostic_signs = 0
set completeopt=longest,menu    "让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
" let g:ycm_cache_omnifunc=0    " 禁止缓存匹配项,每次都重新生成匹配项
" let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_semantic_triggers = {
   \   'css': [ 're!^\s{4}', 're!:\s+' ],
   \   'scss': [ 're!^\s{4}', 're!:\s+' ],
   \   'html': [ '<', ' ' ],
   \   'vue': [ '<', ' ' ],
   \ }
let g:ycm_key_invoke_completion = '<C-l>'
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_confirm_extra_conf = 0
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_python_binary_path = '/usr/bin/python'
let g:ycm_goto_buffer_command = 'split-or-existing-window'
nnoremap [d :rightbelow vertical YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap [l :rightbelow vertical YcmCompleter GoTo<CR>
nnoremap [t :rightbelow vertical YcmCompleter GetType<CR>
nnoremap [p :rightbelow vertical YcmCompleter GetParent<CR>
nnoremap [o :rightbelow vertical YcmCompleter GetDoc<CR>
nnoremap [c :rightbelow vertical YcmCompleter GoToDeclaration<CR>
nnoremap [f :rightbelow vertical YcmCompleter GoToDefinition<CR>
nnoremap [i :rightbelow vertical YcmCompleter GoToInclude<CR>
nnoremap [q :close<CR>
nnoremap ]q :pclose<CR>

" fcitx
augroup FcitxSupport
    autocmd!
    autocmd InsertLeave * call system('fcitx-remote -c')
augroup END

" signify
let g:signify_vcs_list = ['git']

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
augroup TexBiberMapper
    autocmd!
    autocmd FileType tex nmap <Leader>lb :<C-U>exec '!biber '.Tex_GetMainFileName(':p:t:r')<CR>
augroup END

" markdown preview
let g:mkdp_path_to_chrome = 'firefox --new-window'
" colorizer
let g:colorizer_hex_alpha_first = 0
" echodoc
set noshowmode
let g:echodoc#enable_at_startup = 1
let g:echodoc#enable_force_overwrite = 1

call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'lilydjwg/colorizer', {'on': 'ColorHighlight'}
Plug 'iamcco/mathjax-support-for-mkdp', {'for': ['markdown']}
Plug 'iamcco/markdown-preview.vim', {'for': ['markdown']}
Plug 'jszakmeister/vim-togglecursor'

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}
Plug 'jlanzarotta/bufexplorer', {'on': 'BufExplorer'}
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}

Plug 'mhinz/vim-signify', {'on': 'SignifyToggle'}
Plug 'tpope/vim-fugitive'
Plug 'w0rp/ale'
Plug 'vim-latex/vim-latex', {'for': ['tex', 'latex', 'bib']}
Plug 'Valloric/YouCompleteMe', {'do': './install.py --system-boost --system-libclang --clang-completer --rust-completer --ts-completer'}
Plug 'Shougo/echodoc.vim'
Plug 'alvan/vim-closetag', {'for': ['html', 'xml', 'vue']}

Plug 'ludovicchabant/vim-gutentags'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

Plug 'cpiger/NeoDebug', {'on': 'NeoDebug'}
call plug#end()

