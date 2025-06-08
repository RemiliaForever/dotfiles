local util = require("util")

local is_open = false
local current_mode = ""

local function open_tab(mode)
	return function()
		if is_open then
			vim.cmd("Trouble " .. current_mode .. " close")
		end
		vim.cmd("Trouble " .. mode .. " open")
		current_mode = mode
		is_open = true
	end
end

local function toggle_tab(mode)
	return function()
		if is_open then
			vim.cmd("Trouble " .. current_mode .. " close")
			current_mode = ""
			is_open = false
		else
			vim.cmd("Trouble " .. mode .. " open")
			current_mode = mode
			is_open = true
		end
	end
end

util.nmap("<C-l>", toggle_tab("symbols"))
util.nmap("[r", open_tab("lsp"))
util.nmap("[s", open_tab("symbols"))

require("trouble").setup({
	open_no_results = true,
	focus = true,
	win = {
		type = "split",
		relative = "editor",
		position = "right",
		size = { width = 40, height = 8 },
	},
})
