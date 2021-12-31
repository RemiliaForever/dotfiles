local util = require('util')

vim.g.ale_disable_lsp = 1
vim.g.ale_echo_delay = 20
vim.g.ale_lint_delay = 300
vim.g.ale_sign_warning = '>>'
vim.g.ale_virtualtext_cursor = 1
vim.g.ale_linters = {
    c = {},
    cpp = {},
    go = {},
    java = {},
    javascript = {},
    markdown = {'proselint'},
    python = {'flake8'},
    rust = {},
    tex = {'chktex'},
    typescript = {},
    vue = {},
}
vim.g.ale_lint_on_text_changed = 'always'
vim.g.ale_lint_on_insert_leave = 1
vim.g.ale_fixers = {
    c = {'clang-format'},
    cpp = {'clang-format'},
    go = {'gofmt'},
    java = {'google_java_format'},
    javascript = {'eslint'},
    markdown = {'prettier'},
    python = {'yapf'},
    rust = {'rustfmt'},
    typescript = {'eslint', 'tslint'},
    vue = {'eslint'},
    yaml = {'prettier'},
}
vim.g.ale_c_clangformat_options = '-style="{BasedOnStyle: LLVM, UseTab: Never, ColumnLimit: 120, IndentWidth: 4, BreakBeforeBraces: Linux, AlignConsecutiveAssignments: true, BreakConstructorInitializersBeforeComma: true}"'
vim.g.ale_rust_rustfmt_options = '--edition 2018'
-- vim.g.ale_python_flake8_options = '--max-line-length 120'
vim.g.ale_java_google_java_format_options = '--aosp'
vim.g.ale_fix_on_save = 1

util.nmap('<C-j>', ':ALENext<CR>')
util.nmap('<C-k>', ':ALEPrevious<CR>')
