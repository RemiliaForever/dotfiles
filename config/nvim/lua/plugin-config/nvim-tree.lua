local util = require('util')

util.nmap('<C-n>', ':NvimTreeToggle<CR>')
util.nmap(']r', ':NvimTreeRefresh<CR>')
util.nmap(']n', ':NvimTreeFindFile<CR>')

local function on_attach(bufnr)
    local api = require('nvim-tree.api')

    api.config.mappings.default_on_attach(bufnr)

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))

end

require('nvim-tree').setup {
    disable_netrw           = false,
    hijack_cursor           = false,
    hijack_netrw            = true,
    open_on_tab             = false,
    update_cwd              = false,
    respect_buf_cwd         = true,
    diagnostics = {
        enable = false,
    },
    update_focused_file = {
        enable      = false,
        update_cwd  = false,
        ignore_list = {}
    },
    system_open = {
        cmd  = nil,
        args = {}
    },
    filters = {
        dotfiles = false,
        custom = {}
    },
    git = {
        enable = true,
        ignore = false,
        timeout = 500,
    },
    actions = {
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = true,
            restrict_above_cwd = false,
        },
        open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
                enable = true,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "terminal", "help" },
                },
            },
        }
    },
    view = {
        width = 34,
        hide_root_folder = false,
        side = 'left',
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        cursorline = true,
    },
    renderer = {
        highlight_git = true,
        highlight_opened_files = 'icon',
        root_folder_modifier = ':~',
        add_trailing = true,
        group_empty = true,
        icons = {
            show =  {
                git = true,
                folder = true,
                file = true,
                folder_arrow = false,
            },
            padding = ' ',
            glyphs = {
                default = '',
                symlink = '',
            }
        },
        indent_markers = {
            enable = true
        }
    },
    trash = {
        cmd = "trash",
        require_confirm = true
    },
    on_attach = on_attach,
}
