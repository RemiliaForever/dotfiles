local base = require("wibox.widget.textbox")

local function textbox(...)
    local box = base(...)
    box.font = 'Monaco 10'
    box.align = 'center'
    return box
end

return textbox
