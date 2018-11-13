local awful = require("awful")
local textbox = require("widget/lib/textbox")

local function update_netstat()
    local function format_width(num)
        speed = num / 1024
        if speed > 99 then
            return string.format('%4dKb', math.floor(speed))
        else
            return string.format('%4.1fKb', speed)
        end
    end

    local interval = net_widget_clock.timeout
    local netif, text
    for line in io.lines('/proc/net/route') do
        netif = line:match('^(%w+)%s+00000000%s')
        if netif then
            break
        end
    end

    if netif then
        local down, up
        for line in io.lines('/proc/net/dev') do
            -- Match wmaster0 as well as rt0 (multiple leading spaces)
            local name, recv, send = string.match(line, "^%s*(%w+):%s+(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)")
            if name == netif then
                if netdata[name] == nil then
                    -- Default values on the first run
                    netdata[name] = {}
                    down, up = 0, 0
                else
                    down = (recv - netdata[name][1]) / interval
                    up   = (send - netdata[name][2]) / interval
                end
                netdata[name][1] = recv
                netdata[name][2] = send
                break
            end
        end
        text = ' 🔻<span color="#c2ba62">'.. format_width(down) ..'</span> 🔺<span color="#5798d9">'.. format_width(up) ..'</span>'
    else
        netdata = {} -- clear as the interface may have been reset
        text = '(No network)'
    end
    net_widget:set_markup(text .. " ")
end
netdata = {}
net_widget = textbox('(net)')
net_widget_clock = timer({ timeout = 1 })
net_widget_clock:connect_signal("timeout", update_netstat)
net_widget_clock:start()
update_netstat()

return net_widget
