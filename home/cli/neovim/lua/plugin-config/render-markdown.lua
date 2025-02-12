require("render-markdown").setup({
	file_types = { "markdown", "Avante" },
	render_modes = { "n", "no", "c", "t", "i" },
	sign = {
		enabled = false,
	},
	code = {
		width = "block",
	},
})

vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#313640" })
vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#313640" })
vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#313640" })
vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#313640" })
vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#313640" })
vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#313640" })
vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#98c389" })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#e5c07b" })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#61afef" })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#c678dd" })
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#56b6c2" })
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#dcdfe4" })
