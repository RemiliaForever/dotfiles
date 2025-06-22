local util = require("util")
local snacks = require("snacks")

snacks.setup({
	bigfile = { enabled = true },
	dashboard = { enabled = true },
	-- explorer = { enabled = true }, -- TODO
	indent = { enabled = true },
	input = { enabled = true },
	notifier = {
		enabled = true,
		timeout = 5000,
	},
	picker = { enabled = true },
	quickfile = { enabled = true },
	-- scope = { enabled = true },
	-- scroll = { enabled = true, animate = { } },
	statuscolumn = { enabled = true },
	words = { enabled = true },

	styles = {
		lazygit = {
			width = 0,
			height = 0,
			zindex = 10,
		},
	},
})

util.nmap("[g", snacks.lazygit.open)
