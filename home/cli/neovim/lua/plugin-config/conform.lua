local conform = require("conform")

conform.setup({
	notify_no_formatters = true,
	notify_on_error = true,

	default_format_opts = {
		lsp_format = "first",
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},

	formatters_by_ft = {
		c = { "clang-format" },
		cpp = { "clang-format" },
		cuda = { "clang-format" },
		go = { "gofmt" },
		--java = { "google_java_format" },
		javascript = { "prettier" },
		json = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		nix = { "nixfmt" },
		openscad = { "clang-format" },
		python = { "yapf", "isort" },
		rust = { "rustfmt" },
		toml = { "taplo" },
		typescript = { "prettier" },
		vue = { "prettier" },
		yaml = { "prettier" },
	},
	formatters = {
		injected = {
			options = {
				ignore_errors = true,
				lang_to_ext = {
					bash = "sh",
					c_sharp = "cs",
					elixir = "exs",
					javascript = "js",
					julia = "jl",
					latex = "tex",
					markdown = "md",
					python = "py",
					ruby = "rb",
					rust = "rs",
					teal = "tl",
					typescript = "ts",
				},
			},
		},
	},
})
