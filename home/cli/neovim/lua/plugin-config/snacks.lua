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
		width = { min = 32, max = 0.8 },
	},
	picker = {
		enabled = true,
		win = {
			input = {
				keys = {
					["<Esc>"] = { "close", mode = { "n", "i" } },
				},
			},
		},
	},
	quickfile = { enabled = true },
	-- scope = { enabled = true },
	-- scroll = { enabled = true, animate = { } },
	statuscolumn = { enabled = false },
	words = { enabled = true },

	styles = {
		input = {
			relative = "cursor",
			width = 48,
			keys = {
				i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
			},
		},
		lazygit = {
			width = 0.9,
			height = 0.9,
			zindex = 10,
		},
	},
})

util.nmap("[g", snacks.lazygit.open)
util.nmap("<C-t>", snacks.terminal.open)
