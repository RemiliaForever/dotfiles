local lualine = require("lualine")

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		disabled_filetypes = {},
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			"filename",
			{ "diagnostics", update_in_insert = true },
		},
		lualine_c = { "lsp_progress" },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
