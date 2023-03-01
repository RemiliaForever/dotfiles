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
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings.
    local opts = { noremap=true, silent=true }

    --vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.hover()]])

    buf_set_keymap('n', '[c', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '[o', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '[i', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '[t', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '[n', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '[a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '[r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '[h', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    buf_set_keymap('n', '[s', ':LspRestart<CR>', opts)
    buf_set_keymap('n', '[wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '[wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '[wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

    buf_set_keymap('n', '<C-j>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '[go', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[gl', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsps = {
    'clangd',
    'gopls',
    'tsserver',
    'jdtls',
    'kotlin_language_server',
    'vuels',
}
for _, lsp in ipairs(lsps) do
    nvim_lsp[lsp].setup {
        capabilities = capabilities,
        on_attach = on_attach,
    }
end

nvim_lsp.rust_analyzer.setup {
    cmd = {'bash', '-c', 'CARGO_TARGET_DIR=/home/remilia/.cargo/rust-analyzer rust-analyzer'},
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                features = "all",
            }
        }
    }
}

nvim_lsp.pyright.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    root_dir = nvim_lsp_util.find_git_ancestor,
}
