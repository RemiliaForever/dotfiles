local util = require("util")

vim.opt.helplang = "cn"
vim.opt.encoding = "utf-8"
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
vim.opt.mouse = "a"
vim.opt.fillchars = "vert:│,stl: ,stlnc: "
vim.opt.list = true
vim.opt.spell = false
vim.opt.fdm = "expr"
vim.opt.foldlevelstart = 99
vim.opt.previewheight = 8
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.diffopt:append("vertical")
vim.opt.fencs = "ucs-bom,utf-8,gbk,latin1"
vim.opt.lcs = "trail:▒,tab:┆┄"
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
vim.cmd("syntax enable")

util.map("q:", "<nop>")
util.nmap("<C-h>", "<cmd>nohl<cr>")

vim.g.clipboard = "osc52"
util.vmap("<C-c>", '"+y')
util.vmap("<C-x>", '"+c')
util.nmap("<C-p>", '"+p')

-- util.nmap("[j", "<cmd>cn<CR>")
-- util.nmap("[k", "<cmd>cp<CR>")
-- util.nmap("[x", "<cmd>cclose<CR>")
util.nmap("[q", "<cmd>close<cr>")
-- util.nmap("]q", "<cmd>pclose<cr>")

-- filetype
vim.filetype.add({ extension = { wgsl = "wgsl" } })

-- highlight
vim.cmd.colorscheme("onehalfdark")

-- relative number
vim.opt.relativenumber = true
util.nmap("<F3>", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end)

-- -- hex
local current_hex_mode = false
util.nmap("<F4>", function()
	if current_hex_mode then
		vim.cmd("%!xxd -r")
	else
		vim.cmd("%!xxd")
	end
	current_hex_mode = not current_hex_mode
end)

-- xdg-open
util.nmap("<F5>", "<cmd>!xdg-open %<cr><cr>")

-- fctix5
vim.cmd([[
augroup FcitxSupport
    autocmd!
    autocmd InsertLeave * call system('fcitx5-remote -c')
augroup END
]])
