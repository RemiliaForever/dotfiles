local base = require("wibox.widget.textbox")

local function textbox(...)
    local box = base(...)
    box.font = 'Noto Sans Mono 11'
    box.align = 'center'
    return box
end

return textbox
