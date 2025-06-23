local util = require("util")
local snacks = require("snacks")

util.nmap("<C-n>", ":NvimTreeToggle<CR>")
util.nmap("]r", ":NvimTreeRefresh<CR>")
util.nmap("]n", ":NvimTreeFindFile<CR>")

local function on_attach(bufnr)
	local api = require("nvim-tree.api")

	api.config.mappings.default_on_attach(bufnr)

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
	vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))

	vim.keymap.set("n", "O", api.tree.expand_all, opts("Expand All"))
	vim.keymap.set("n", "Z", api.tree.collapse_all, opts("Collapse All"))
	vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))

	vim.keymap.set("n", "<C-t>", function()
		local node = api.tree.get_node_under_cursor()
		if not node then
			return
		end

		local dir_path
		if node.type == "directory" then
			dir_path = node.absolute_path
		else
			dir_path = node.parent.absolute_path
		end
		snacks.terminal.open(nil, { cwd = dir_path })
	end, opts("Open: Vertical Split"))
end

require("nvim-tree").setup({
	on_attach = on_attach,
	hijack_cursor = true,
	disable_netrw = true,
	respect_buf_cwd = true,
	view = {
		width = 34,
		side = "left",
		signcolumn = "yes",
	},
	renderer = {
		add_trailing = true,
		group_empty = true,
		highlight_git = "name",
		highlight_diagnostics = "name",
		indent_markers = { enable = true },
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = false,
				git = true,
			},
			git_placement = "right_align",
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "",
					staged = "",
					unmerged = "",
					renamed = "",
					untracked = "",
					deleted = "",
					ignored = "",
				},
			},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = false,
	},
	actions = {
		change_dir = {
			enable = true,
			global = true,
			restrict_above_cwd = false,
		},
	},
})
