local awful = require("awful")
local textbox = require("widget/lib/textbox")

local function update_cputemp()
    local pipe = io.popen('sensors')
    if not pipe then
        cputemp_widget:set_markup('CPU <span color="red">ERR</span>℃')
        return
    end
    local temp = 0
    for line in pipe:lines() do
        local newtemp = line:match('^Tdie:%s+%+([0-9]+)([0-9.]+)°C')
        if newtemp then
            newtemp = tonumber(newtemp)
            if temp == 0 then
                temp = newtemp
            end
        end
    end
    pipe:close()
    if temp > 60 then
        cputemp_widget:set_markup(' CPU <span color="yellow">'..temp..'</span>℃')
    elseif temp > 70 then
        cputemp_widget:set_markup(' CPU <span color="orange">'..temp..'</span>℃')
    else
        cputemp_widget:set_markup(' CPU <span color="green">'..temp..'</span>℃')
    end
end
cputemp_widget = textbox(' CPU ??℃')
update_cputemp()
cputemp_clock = timer({ timeout = 5 })
cputemp_clock:connect_signal("timeout", update_cputemp)
cputemp_clock:start()

return cputemp_widget
