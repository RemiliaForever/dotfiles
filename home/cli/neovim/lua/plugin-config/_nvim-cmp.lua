local cmp = require("cmp")
local luasnip = require("luasnip")
local copilot = require("copilot")
local copilot_cmp = require("copilot_cmp")

vim.opt.completeopt = "menu,menuone,noselect"

local kind_icons = {
	Text = " ",
	Method = "󰆧 ",
	Function = "󰊕 ",
	Constructor = " ",
	Field = "󰇽 ",
	Variable = "󰂡 ",
	Class = "󰠱 ",
	Interface = " ",
	Module = " ",
	Property = "󰜢 ",
	Unit = " ",
	Value = "󰎠 ",
	Enum = " ",
	Keyword = "󰌋 ",
	Snippet = " ",
	Color = "󰏘 ",
	File = "󰈙 ",
	Reference = " ",
	Folder = "󰉋 ",
	EnumMember = " ",
	Constant = "󰏿 ",
	Struct = " ",
	Event = " ",
	Operator = "󰆕 ",
	TypeParameter = "󰅲 ",
}

copilot.setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})
copilot_cmp.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
		["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
		["<C-b>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
	},
	sources = cmp.config.sources({
		{ name = "copilot" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "luasnip" },
	}),
	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = string.format("%s [%s]", kind_icons[vim_item.kind], entry.source.name)
			return vim_item
		end,
	},
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})
