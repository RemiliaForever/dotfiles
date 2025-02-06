local util = require("util")

local is_open = false
local current_mode = ""

local function toggle_modes(mode)
	return function()
		if is_open then
			vim.cmd("Trouble " .. current_mode .. " close")
		end
		if current_mode ~= mode then
			vim.cmd("Trouble " .. mode .. " open")
			current_mode = mode
			is_open = true
		else
			current_mode = ""
			is_open = false
		end
	end
end

util.nmap("<C-l>", toggle_modes("symbols"))
util.nmap("[r", toggle_modes("lsp"))

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
