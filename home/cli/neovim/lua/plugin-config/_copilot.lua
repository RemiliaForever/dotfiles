local copilot = require("copilot")

-- Copilot
copilot.setup({
	panel = { enabled = false },
	suggestion = {
		enabled = true,
		auto_trigger = true,
		keymap = {
			accept = "<C-e>",
			next = "<C-j>",
			prev = "<C-k>",
		},
	},
	filetypes = {
		["markdown"] = true,
		["yaml"] = true,
	},
})
vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#56b6c2", italic = true })
