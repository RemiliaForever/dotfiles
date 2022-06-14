local util = require('util')

vim.opt.helplang = 'cn'
vim.opt.encoding = 'utf-8'
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.autoread = true
vim.opt.compatible = false
vim.opt.confirm = true
vim.opt.scrolloff = 3
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.foldenable = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cursorline = false
vim.opt.showcmd = true
vim.opt.mouse = 'a'
vim.opt.fillchars = 'vert:│,stl: ,stlnc: '
vim.opt.list = true
vim.opt.spell = false
vim.opt.fdm = 'syntax'
vim.opt.foldlevelstart = 99
vim.opt.previewheight = 8
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.diffopt:append('vertical')
vim.opt.fencs = 'ucs-bom,utf-8,gbk,latin1'
vim.opt.lcs = 'trail:▒,tab:|-'
vim.cmd([[filetype on]])
vim.cmd([[filetype plugin on]])
vim.cmd([[filetype indent on]])

util.map('q:', '<Nop>')
util.vmap('<C-c>', '"+y')
util.vmap('<C-x>', '"+c')
util.nmap('<C-p>', '"+p')
util.nmap('<C-h>', ':nohl<CR>')


util.nmap('[j', ':cn<CR>')
util.nmap('[k', ':cp<CR>')
util.nmap('[x', ':cclose<CR>')
util.nmap('[q', ':close<CR>')
util.nmap(']q', ':pclose<CR>')

-- highlight
vim.cmd([[colorscheme onehalfdark]])

-- relative number
vim.opt.relativenumber = true
vim.g.current_relative_number_mode = 1
vim.cmd([[
function ToggleRelativeNumber()
    if g:current_relative_number_mode == 1
        set norelativenumber
        let g:current_relative_number_mode = 0
    else
        set relativenumber
        let g:current_relative_number_mode = 1
    end
endfunction
]])
util.nmap('<F3>', ':call ToggleRelativeNumber()<CR>')

-- -- hex
-- vim.g.current_hex_mode = 0
-- vim.api.nvim_command([[
-- function ToggleHex()
--     if g:current_hex_mode == 1
--         let g:current_hex_mode = 0
--         %!xxd -r
--     else
--         let g:current_hex_mode = 1
--         %!xxd
--     endif
-- endfunction
-- ]])
-- util.nmap('<F4>', ':call ToggleHex()<CR>')

-- xdg-open
util.nmap('<F5>', ':!xdg-open %<CR><CR>')

-- fctix5
vim.cmd([[
augroup FcitxSupport
    autocmd!
    autocmd InsertLeave * call system('fcitx5-remote -c')
augroup END
]])
