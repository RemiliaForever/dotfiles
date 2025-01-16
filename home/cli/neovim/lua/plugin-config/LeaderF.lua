local util = require("util")

vim.g.Lf_WindowPosition = 'popup'
util.nmap("<F1>", ":Leaderf tag<CR>")
util.nmap("<F2>", ":Leaderf rg<CR>")
