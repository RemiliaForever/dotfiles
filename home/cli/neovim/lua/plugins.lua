require("lazy").setup({
	{ "lambdalisue/suda.vim", cmd = "SudaWrite" },
	{ "chaoren/vim-wordmotion" },
	{ "tpope/vim-surround" },
	{
		"norcalli/nvim-colorizer.lua",
		opts = { "*" },
		keys = { { "<F6>", ":ColorizerToggle<CR>" } },
	},
	{
		"karb94/neoscroll.nvim",
		opts = { mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" }, duration_multiplier = 0.5 },
	},

	{
		"kyazdani42/nvim-tree.lua",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("plugin-config/nvim-tree")
		end,
	},
	{ "preservim/tagbar", keys = { { "<C-l>", ":TagbarToggle<CR>" } } },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
			"arkav/lualine-lsp-progress",
		},
		config = function()
			require("plugin-config/lualine")
		end,
	},
	{ "mhinz/vim-signify", keys = { { "<C-g>", ":SignifyToggle<CR>" } } },
	{ "tpope/vim-fugitive" },

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		build = ":TSUpdate",
		config = function()
			require("plugin-config/nvim-treesitter")
		end,
	},
	{
		"ludovicchabant/vim-gutentags",
		config = function()
			require("plugin-config/gutentags")
		end,
	},
	{
		"Yggdroot/LeaderF",
		build = ":LeaderfInstallCExtension",
		config = function()
			require("plugin-config/LeaderF")
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install; git reset --hard",
		ft = { "markdown" },
		cmd = "MarkdownPreview",
	},
	{
		"dense-analysis/ale",
		config = function()
			require("plugin-config/ale")
		end,
	},
	-- use { 'vim-latex/vim-latex', ft = { 'tex', 'latex', 'bib' }, config = function() require('plugin-config/vim-latex') end },
	{
		"lervag/vimtex",
		init = function()
			require("plugin-config/vimtex")
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
		config = function()
			require("plugin-config/nvim-cmp")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugin-config/nvim-lspconfig")
		end,
	},
})
