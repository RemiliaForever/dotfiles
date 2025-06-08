local nvim_lsp = require("lspconfig")
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
	update_in_insert = false,
	severity_sort = true,
})

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

		-- vim.keymap.set("n", "[lr", "<cmd>LspRestart", opts)
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
	"clangd",
	"cssls",
	"docker_compose_language_service",
	"dockerls",
	"gopls",
	"html",
	--"jdtls",
	"jsonls",
	--"kotlin_language_server",
	"neocmake",
	"nixd",
	"openscad_lsp",
	"pyright",
	"taplo",
	"ts_ls",
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, lsp in ipairs(lsps) do
	nvim_lsp[lsp].setup({
		capabilities = capabilities,
	})
end

-- custom
nvim_lsp.lua_ls.setup({
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
		Lua = {},
	},
})
nvim_lsp.rust_analyzer.setup({
	capabilities = capabilities,
	cmd = { "bash", "-c", "CARGO_TARGET_DIR=target/rust-analyzer rust-analyzer" },
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
				buildScrips = {
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
nvim_lsp.texlab.setup({
	capabilities = capabilities,
	settings = {
		texlab = {
			forwardSearch = {
				executable = "zathura",
				args = { "--synctex-forward", "%l:1:%f", "%p" },
			},
		},
	},
})
nvim_lsp.volar.setup({
	capabilities = capabilities,
	filetypes = { "javascriptreact", "typescriptreact", "vue", "json" },
	init_options = {
		typescript = { tsdk = "/path/to/node_modules/typescript/lib" }, -- TODO
		vue = { hybridMode = false },
	},
	root_dir = nvim_lsp_util.root_pattern("tsconfig.json", ".git"),
})
