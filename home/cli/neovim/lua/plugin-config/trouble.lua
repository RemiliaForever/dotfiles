local util = require("util")

local modes = { "symbols", "lsp", "diagnostics" }
local current_mode = 1
local is_open = false

local function toggle_open()
	local cmode = modes[current_mode]
	if is_open then
		vim.cmd("Trouble " .. cmode .. " close")
	else
		vim.cmd("Trouble " .. cmode .. " open")
	end
	is_open = not is_open
end

local function toggle_mode()
	if is_open then
		toggle_open()
		current_mode = current_mode % #modes + 1
		toggle_open()
	else
		current_mode = current_mode % #modes + 1
	end
	vim.notify("Change Trouble mode to " .. modes[current_mode])
end

util.nmap("<C-l>", toggle_open)
util.nmap("[l", toggle_mode)

require("trouble").setup({
	open_no_results = true,
	win = {
		type = "split",
		relative = "editor",
		position = "right",
		size = { width = 34, height = 8 },
	},
})
