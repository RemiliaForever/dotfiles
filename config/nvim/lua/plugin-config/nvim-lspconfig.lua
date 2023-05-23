local nvim_lsp = require('lspconfig')
local nvim_lsp_util = require('lspconfig.util')

-- hover
local border = {
    {"┌", "FloatBorder"},
    {"─", "FloatBorder"},
    {"┐", "FloatBorder"},
    {"│", "FloatBorder"},
    {"┘", "FloatBorder"},
    {"─", "FloatBorder"},
    {"└", "FloatBorder"},
    {"│", "FloatBorder"},
}
vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, { border = border, focusable = false })
vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

-- sign
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- goto
local function open_vsplit()
    local util = vim.lsp.util
    local log = require("vim.lsp.log")
    local api = vim.api

    local handler = function(_, result, ctx)
        if result == nil or vim.tbl_isempty(result) then
            local _ = log.info() and log.info(ctx.method, "No location found")
            return nil
        end

        vim.cmd('vsplit')

        if vim.tbl_islist(result) then
            util.jump_to_location(result[1], 'utf8')

            if #result > 1 then
                util.set_qflist(util.locations_to_items(result))
                api.nvim_command("copen")
                api.nvim_command("wincmd p")
            end
        else
            util.jump_to_location(result, 'utf8')
        end
    end

    return handler
end

vim.lsp.handlers["textDocument/declaration"] = open_vsplit()
vim.lsp.handlers["textDocument/definition"] = open_vsplit()
vim.lsp.handlers["textDocument/implementation"] = open_vsplit()
vim.lsp.handlers["textDocument/typeDefinition"] = open_vsplit()

-- binding
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        --vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.hover()]])

        local opts = { buffer = ev.buf }

        vim.keymap.set('n', '[c', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', '[d', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '[o', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '[i', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '[t', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '[n', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '[a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '[r', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '[h', vim.lsp.buf.signature_help, opts)

        vim.keymap.set('n', '[s', ':LspRestart<CR>', opts)
        vim.keymap.set('n', '[wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '[wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '[wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)

        vim.keymap.set('n', '<C-j>', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<C-k>', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '[go', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[gl', vim.diagnostic.setloclist, opts)
    end
})

local lsps = {
    'clangd',
    'gopls',
    'tsserver',
    'jdtls',
    'kotlin_language_server',
    'vuels',
    'openscad_lsp',
}
for _, lsp in ipairs(lsps) do
    nvim_lsp[lsp].setup {}
end

nvim_lsp.rust_analyzer.setup {
    cmd = {'bash', '-c', 'CARGO_TARGET_DIR=/home/remilia/.cargo/rust-analyzer rust-analyzer'},
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                features = "all",
                buildScrips = {
                    enable = true
                }
            },
            procMacro = {
                enable = true
            }
        }
    }
}

nvim_lsp.pyright.setup {
    root_dir = nvim_lsp_util.find_git_ancestor,
}
