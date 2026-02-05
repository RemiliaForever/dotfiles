local nvim_lsp_util = require("lspconfig.util")

-- float
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = {
		{ "╭", "FloatBorder" },
		{ "─", "FloatBorder" },
		{ "╮", "FloatBorder" },
		{ "│", "FloatBorder" },
		{ "╯", "FloatBorder" },
		{ "─", "FloatBorder" },
		{ "╰", "FloatBorder" },
		{ "│", "FloatBorder" },
	}
	return orig_open_floating_preview(contents, syntax, opts, ...)
end

-- sign
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
		},
	},
	underline = true,
	update_in_insert = true,
	severity_sort = true,
})

-- highlight
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5c6370" })

-- jump
local function open_vsplit(f)
	local function handler()
		f({
			on_list = function(options)
				vim.fn.setqflist({}, " ", options)
				if #options.items == 1 then
					vim.cmd("vsplit")
					vim.cmd.cfirst()
				else
					vim.api.nvim_command("copen")
					vim.api.nvim_command("wincmd p")
				end
			end,
		})
	end
	return handler
end

-- binding
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }

		vim.lsp.inlay_hint.enable(true)

		vim.keymap.set("n", "[c", open_vsplit(vim.lsp.buf.declaration), opts)
		vim.keymap.set("n", "[d", open_vsplit(vim.lsp.buf.definition), opts)
		vim.keymap.set("n", "[o", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "[i", open_vsplit(vim.lsp.buf.implementation), opts)
		vim.keymap.set("n", "[t", open_vsplit(vim.lsp.buf.type_definition), opts)
		vim.keymap.set("n", "[n", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "[a", vim.lsp.buf.code_action, opts)
		-- vim.keymap.set("n", "[r", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "[h", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "[f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		vim.keymap.set("n", "[s", "<cmd>LspRestart<cr><cmd>Copilot enable<cr>", opts)
		vim.keymap.set("n", "[wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "[wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "[wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)

		vim.keymap.set("n", "<C-j>", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)
		vim.keymap.set("n", "<C-k>", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts)
		vim.keymap.set("n", "[go", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[gl", vim.diagnostic.setloclist, opts)

		vim.keymap.set("n", "[gf", "<cmd>TexlabForward<cr>", opts)
	end,
})

-- normal
local lsps = {
	"bashls",
	"basedpyright",
	"clangd",
	"cssls",
	"docker_compose_language_service",
	"dockerls",
	"gopls",
	"html",
	--"jdtls",
	"jsonls",
	"kotlin_lsp",
	"lua_ls",
	"neocmake",
	"nixd",
	"openscad_lsp",
	"rust_analyzer",
	"taplo",
	"texlab",
	"ts_ls",
	"vue_ls",
}

-- custom
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				ignoreError = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})
vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
			},
		})
	end,
	settings = {
		Lua = {
			hint = {
				enable = true,
				arrayIndex = "Enable",
				setType = true,
			},
		},
	},
})
vim.lsp.config("neocmake", {
	init_options = {
		lint = { enable = false },
	},
})
vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
				buildScritps = {
					enable = true,
				},
			},
			check = {
				command = "clippy",
			},
			procMacro = {
				enable = true,
			},
		},
	},
})
vim.lsp.config("texlab", {
	settings = {
		texlab = {
			forwardSearch = {
				executable = "zathura",
				args = { "--synctex-forward", "%l:1:%f", "%p" },
			},
		},
	},
})
vim.lsp.config("vue_ls", {
	filetypes = { "javascriptreact", "typescriptreact", "vue", "json" },
	init_options = {
		typescript = { tsdk = "/path/to/node_modules/typescript/lib" }, -- TODO
		vue = { hybridMode = false },
	},
	root_dir = nvim_lsp_util.root_pattern("tsconfig.json", ".git"),
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
	capabilities = capabilities,
})

for _, lsp in ipairs(lsps) do
	vim.lsp.enable(lsp)
end
