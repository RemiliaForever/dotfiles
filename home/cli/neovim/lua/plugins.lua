require("lazy").setup({
	-- simple tools
	{ "chaoren/vim-wordmotion", event = "VeryLazy" },
	{ "lambdalisue/suda.vim", event = "VeryLazy" },
	{ "tpope/vim-fugitive", event = "VeryLazy" },
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		config = function()
			require("mini.comment").setup({}) -- gc
			require("mini.move").setup({}) -- alt + hjkl
			require("mini.operators").setup({}) -- g + =xmrs
			require("mini.pairs").setup({})
			require("mini.surround").setup({}) -- s + adrfh
			-- require("mini.tabline").setup({})
		end,
	},
	-- powerful tools
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
		config = function()
			require("plugin-config/nvim-treesitter")
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<F1>", "<cmd>FzfLua files<cr>" },
			{ "<F2>", "<cmd>FzfLua live_grep_native<cr>" },
		},
		opts = {},
	},
	{
		"yetone/avante.nvim",
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		event = "VeryLazy",
		version = false,
		build = "make",
		config = function()
			require("plugin-config.avante")
		end,
	},
	-- ui components
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			require("plugin-config/nvim-tree")
		end,
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		config = function()
			require("plugin-config/trouble")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"arkav/lualine-lsp-progress",
		},
		event = "VeryLazy",
		config = function()
			require("plugin-config/lualine")
		end,
	},
	{ "mhinz/vim-signify", keys = { { "<C-g>", ":SignifyToggle<CR>" } } },
	-- render enhance
	{ "sphamba/smear-cursor.nvim", opts = {} },
	{
		"norcalli/nvim-colorizer.lua",
		keys = { { "<F6>", ":ColorizerToggle<CR>" } },
		opts = { "*" },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "Avante" },
		config = function()
			require("plugin-config.render-markdown")
		end,
	},
	-- completion, format
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		config = function()
			require("plugin-config/conform")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		event = "VeryLazy",
		config = function()
			require("plugin-config/nvim-cmp")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("plugin-config/nvim-lspconfig")
		end,
	},
})
