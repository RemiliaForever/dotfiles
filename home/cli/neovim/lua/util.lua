local util = {}

function map(mode, key, func)
    vim.api.nvim_set_keymap(mode, key, func, { noremap = true })
end

function util.map(key, func)
    map('', key, func)
end
function util.nmap(key, func)
    map('n', key, func)
end
function util.vmap(key, func)
    map('v', key, func)
end
function util.imap(key, func)
    map('i', key, func)
end


return util
