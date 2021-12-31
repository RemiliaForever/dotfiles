" ==============================================================================
"   Name:        One Half Dark
"   Author:      Son A. Pham <sp@sonpham.me>
"   Url:         https://github.com/sonph/onehalf
"   License:     The MIT License (MIT)
"
"   A dark vim color scheme based on Atom's One. See github.com/sonph/onehalf
"   for installation instructions, a light color scheme, versions for other
"   editors/terminals, and a matching theme for vim-airline.
" ==============================================================================

set background=dark
set termguicolors
highlight clear
syntax reset

let g:colors_name="onehalfdark"
let colors_name="onehalfdark"

let s:trans       = "none"

"let s:black       = "#282c34"
"let s:red         = "#e06c75"
"let s:green       = "#98c379"
"let s:yellow      = "#e5c07b"
"let s:blue        = "#61afef"
"let s:purple      = "#c678dd"
"let s:cyan        = "#56b6c2"
"let s:white       = "#dcdfe4"
let s:black       = "#181c24"
let s:red         = "#f07c85"
let s:green       = "#a8d389"
let s:yellow      = "#f5d08b"
let s:blue        = "#71bfff"
let s:purple      = "#d688ed"
let s:cyan        = "#66c6d2"
let s:white       = "#eceff4"

let s:fg          = s:white
let s:bg          = s:black

"let s:comment_fg  = "#5c6370"
let s:comment_fg  = "#a2a9b6"
let s:gutter_bg   = "#282c34"
let s:gutter_fg   = "#919baa"
let s:non_text    = "#373C45"

let s:cursor_line = "#313640"
let s:color_col   = "#313640"

"let s:selection   = "#474e5d"
let s:selection   = "#5c6370"
let s:vertsplit   = "#313640"


function! s:h(group, fg, bg, attr)
    if a:fg != ""
        exec "hi " . a:group . " guifg=" . a:fg
    endif
    if a:bg != ""
        exec "hi " . a:group . " guibg=" . a:bg
    endif
    if a:attr != ""
        exec "hi " . a:group . " gui=" . a:attr
    endif
endfun


" User interface colors
call  s:h("Normal",        s:fg,          s:trans,        s:trans)
call  s:h("Cursor",        s:bg,          s:blue,         s:trans)
call  s:h("CursorColumn",  s:trans,       s:cursor_line,  s:trans)
call  s:h("CursorLine",    s:trans,       s:cursor_line,  s:trans)
call  s:h("LineNr",        s:gutter_fg,   s:trans,        s:trans)
call  s:h("CursorLineNr",  s:fg,          s:trans,        s:trans)
call  s:h("DiffAdd",       s:bg,            s:green,        s:trans)
call  s:h("DiffChange",    s:bg,            s:yellow,       s:trans)
call  s:h("DiffDelete",    s:fg,            s:red,          s:trans)
call  s:h("DiffText",      s:fg,            s:blue,         s:trans)
call  s:h("IncSearch",     s:bg,          s:yellow,       s:trans)
call  s:h("Search",        s:bg,          s:yellow,       s:trans)
call  s:h("ErrorMsg",      s:fg,          s:trans,        s:trans)
call  s:h("ModeMsg",       s:fg,          s:trans,        s:trans)
call  s:h("MoreMsg",       s:fg,          s:trans,        s:trans)
call  s:h("WarningMsg",    s:red,         s:trans,        s:trans)
call  s:h("Question",      s:purple,      s:trans,        s:trans)
call  s:h("Pmenu",         s:fg,          s:bg,           s:trans)
call  s:h("PmenuSel",      s:fg,          s:blue,         s:trans)
call  s:h("PmenuSbar",     s:trans,       s:selection,    s:trans)
call  s:h("PmenuThumb",    s:trans,       s:fg,           s:trans)
call  s:h("SpellBad",      s:red,         s:trans,        s:trans)
call  s:h("SpellCap",      s:yellow,      s:trans,        s:trans)
call  s:h("SpellLocal",    s:yellow,      s:trans,        s:trans)
call  s:h("SpellRare",     s:yellow,      s:trans,        s:trans)
call  s:h("StatusLine",    s:white,       s:cursor_line,  s:trans)
call  s:h("StatusLineNC",  s:blue,        s:cursor_line,  s:trans)
call  s:h("TabLine",       s:comment_fg,  s:cursor_line,  s:trans)
call  s:h("TabLineFill",   s:comment_fg,  s:cursor_line,  s:trans)
call  s:h("TabLineSel",    s:fg,          s:bg,           s:trans)
call  s:h("Visual",        s:trans,       s:selection,    s:trans)
call  s:h("VisualNOS",     s:trans,       s:selection,    s:trans)
call  s:h("ColorColumn",   s:trans,       s:color_col,    s:trans)
call  s:h("Conceal",       s:fg,          s:trans,        s:trans)
call  s:h("Directory",     s:blue,        s:trans,        s:trans)
call  s:h("VertSplit",     s:white,       s:cursor_line,  s:trans)
call  s:h("Folded",        s:fg,          s:gutter_bg,    s:trans)
call  s:h("FoldColumn",    s:fg,          s:gutter_bg,    s:trans)
call  s:h("SignColumn",    s:fg,          s:trans,        s:trans)
call  s:h("MatchParen",    s:blue,        s:trans,        "underline")
call  s:h("SpecialKey",    s:fg,          s:trans,        s:trans)
call  s:h("Title",         s:green,       s:trans,        s:trans)
call  s:h("WildMenu",      s:fg,          s:trans,        s:trans)

" Syntax colors
call  s:h("Whitespace",      s:non_text,    s:trans,      s:trans)
call  s:h("NonText",         s:non_text,    s:trans,      s:trans)
call  s:h("Comment",         s:comment_fg,  s:trans,      "italic")
call  s:h("Constant",        s:cyan,        s:trans,      s:trans)
call  s:h("String",          s:green,       s:trans,      s:trans)
call  s:h("Character",       s:green,       s:trans,      s:trans)
call  s:h("Number",          s:yellow,      s:trans,      s:trans)
call  s:h("Boolean",         s:yellow,      s:trans,      s:trans)
call  s:h("Float",           s:yellow,      s:trans,      s:trans)
call  s:h("Identifier",      s:red,         s:trans,      s:trans)
call  s:h("Function",        s:blue,        s:trans,      s:trans)
call  s:h("Statement",       s:purple,      s:trans,      s:trans)
call  s:h("Conditional",     s:purple,      s:trans,      s:trans)
call  s:h("Repeat",          s:purple,      s:trans,      s:trans)
call  s:h("Label",           s:purple,      s:trans,      s:trans)
call  s:h("Operator",        s:fg,          s:trans,      s:trans)
call  s:h("Keyword",         s:red,         s:trans,      s:trans)
call  s:h("Exception",       s:purple,      s:trans,      s:trans)
call  s:h("PreProc",         s:yellow,      s:trans,      s:trans)
call  s:h("Include",         s:purple,      s:trans,      s:trans)
call  s:h("Define",          s:purple,      s:trans,      s:trans)
call  s:h("Macro",           s:purple,      s:trans,      s:trans)
call  s:h("PreCondit",       s:yellow,      s:trans,      s:trans)
call  s:h("Type",            s:yellow,      s:trans,      s:trans)
call  s:h("StorageClass",    s:yellow,      s:trans,      s:trans)
call  s:h("Structure",       s:yellow,      s:trans,      s:trans)
call  s:h("Typedef",         s:yellow,      s:trans,      s:trans)
call  s:h("Special",         s:blue,        s:trans,      s:trans)
call  s:h("SpecialChar",     s:fg,          s:trans,      s:trans)
call  s:h("Tag",             s:fg,          s:trans,      s:trans)
call  s:h("Delimiter",       s:fg,          s:trans,      s:trans)
call  s:h("SpecialComment",  s:fg,          s:trans,      s:trans)
call  s:h("Debug",           s:fg,          s:trans,      s:trans)
call  s:h("Underlined",      s:fg,          s:trans,      s:trans)
call  s:h("Ignore",          s:fg,          s:trans,      s:trans)
call  s:h("Error",           s:red,         s:gutter_bg,  s:trans)
call  s:h("Todo",            s:purple,      s:trans,      s:trans)

"" Nvim
call  s:h("DiagnosticVirtualTextHint",     s:comment_fg,  s:trans,       'italic')
call  s:h("DiagnosticVirtualTextInfo",     s:blue,        s:trans,       'italic')
call  s:h("DiagnosticVirtualTextWarning",  s:yellow,      s:trans,       'italic')
call  s:h("DiagnosticVirtualTextError",    s:red,         s:trans,       'italic')
call  s:h("DiagnosticUnderlineHint",       '',            s:gutter_bg,  '')
call  s:h("DiagnosticUnderlineInfo",       '',            s:blue,        '')
call  s:h("DiagnosticUnderlineWarning",    '',            s:yellow,      '')
call  s:h("DiagnosticUnderlineError",      '',            s:red,         '')


"" Plugins {
    "" GitGutter
    "call s:h("GitGutterAdd", s:green, s:gutter_bg, "")
    "call s:h("GitGutterDelete", s:red, s:gutter_bg, "")
    "call s:h("GitGutterChange", s:yellow, s:gutter_bg, "")
    "call s:h("GitGutterChangeDelete", s:red, s:gutter_bg, "")
    "" Fugitive
    "call s:h("diffAdded", s:green, "", "")
    "call s:h("diffRemoved", s:red, "", "")
    "" }
    "
    "
    "" Git {
        "call s:h("gitcommitComment", s:comment_fg, "", "")
        "call s:h("gitcommitUnmerged", s:red, "", "")
        "call s:h("gitcommitOnBranch", s:fg, "", "")
        "call s:h("gitcommitBranch", s:purple, "", "")
        "call s:h("gitcommitDiscardedType", s:red, "", "")
        "call s:h("gitcommitSelectedType", s:green, "", "")
        "call s:h("gitcommitHeader", s:fg, "", "")
        "call s:h("gitcommitUntrackedFile", s:cyan, "", "")
        "call s:h("gitcommitDiscardedFile", s:red, "", "")
        "call s:h("gitcommitSelectedFile", s:green, "", "")
        "call s:h("gitcommitUnmergedFile", s:yellow, "", "")
        "call s:h("gitcommitFile", s:fg, "", "")
        "hi link gitcommitNoBranch gitcommitBranch
        "hi link gitcommitUntracked gitcommitComment
        "hi link gitcommitDiscarded gitcommitComment
        "hi link gitcommitSelected gitcommitComment
        "hi link gitcommitDiscardedArrow gitcommitDiscardedFile
        "hi link gitcommitSelectedArrow gitcommitSelectedFile
        "hi link gitcommitUnmergedArrow gitcommitUnmergedFile
        "" }
        "
        "" Fix colors in neovim terminal buffers {
            "  if has('nvim')
            "    let g:terminal_color_0 = s:black.gui
            "    let g:terminal_color_1 = s:red.gui
            "    let g:terminal_color_2 = s:green.gui
            "    let g:terminal_color_3 = s:yellow.gui
            "    let g:terminal_color_4 = s:blue.gui
            "    let g:terminal_color_5 = s:purple.gui
            "    let g:terminal_color_6 = s:cyan.gui
            "    let g:terminal_color_7 = s:white.gui
            "    let g:terminal_color_8 = s:black.gui
            "    let g:terminal_color_9 = s:red.gui
            "    let g:terminal_color_10 = s:green.gui
            "    let g:terminal_color_11 = s:yellow.gui
            "    let g:terminal_color_12 = s:blue.gui
            "    let g:terminal_color_13 = s:purple.gui
            "    let g:terminal_color_14 = s:cyan.gui
            "    let g:terminal_color_15 = s:white.gui
            "    let g:terminal_color_background = s:bg.gui
            "    let g:terminal_color_foreground = s:fg.gui
            "  endif
            "" }
