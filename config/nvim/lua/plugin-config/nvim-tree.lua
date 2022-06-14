local util = require('util')

util.nmap('<C-n>', ':NvimTreeToggle<CR>')
util.nmap(']r', ':NvimTreeRefresh<CR>')
util.nmap(']n', ':NvimTreeFindFile<CR>')

local tree_cb = require('nvim-tree.config').nvim_tree_callback

require('nvim-tree').setup {
    disable_netrw           = false,
    hijack_cursor           = false,
    hijack_netrw            = true,
    open_on_setup           = false,
    open_on_tab             = false,
    update_cwd              = false,
    create_in_closed_folder = true,
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
        ignore = true,
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
        height = 30,
        hide_root_folder = false,
        side = 'left',
        auto_resize = false,
        mappings = {
            custom_only = false,
            list = {
                { key = 's', cb = tree_cb('vsplit') }
            }
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes"
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
    }
}
