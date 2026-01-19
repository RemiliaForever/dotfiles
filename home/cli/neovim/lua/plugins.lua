require("lazy").setup({
	-- simple tools
	{ "chaoren/vim-wordmotion", event = "VeryLazy" },
	{ "lambdalisue/suda.vim", event = "VeryLazy" },
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
		config = function()
			require("plugin-config/_nvim-treesitter")
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<F1>", "<cmd>FzfLua global<cr>" },
			{ "<F2>", "<cmd>FzfLua live_grep_native<cr>" },
		},
		opts = {},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			require("plugin-config/_flash")
		end,
	},
	{
		"yetone/avante.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- option
			"hrsh7th/nvim-cmp",
			"ibhagwan/fzf-lua",
			"folke/snacks.nvim",
			"nvim-tree/nvim-web-devicons",
			-- provider
			"zbirenbaum/copilot.lua",
		},
		event = "VeryLazy",
		version = false,
		build = "make",
		config = function()
			require("plugin-config/_avante")
		end,
	},
	-- ui components
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"folke/snacks.nvim",
		},
		-- event = "VeryLazy",
		config = function()
			require("plugin-config/_nvim-tree")
		end,
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		config = function()
			require("plugin-config/_trouble")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		config = function()
			require("plugin-config/_lualine")
		end,
	},
	---- render enhance
	{ "sphamba/smear-cursor.nvim", event = "VeryLazy", opts = {} },
	{
		"folke/snacks.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		config = function()
			require("plugin-config/_snacks")
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		keys = { { "<F6>", ":ColorizerToggle<CR>" } },
		opts = { "*" },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "Avante" },
		config = function()
			require("plugin-config/_render-markdown")
		end,
	},
	-- completion, format
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		config = function()
			require("plugin-config/_conform")
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
			require("plugin-config/_nvim-cmp")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		config = function()
			require("plugin-config/_nvim-lspconfig")
		end,
	},
})
