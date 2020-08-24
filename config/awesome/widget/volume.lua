local awful = require("awful")
local naughty = require("naughty")
local textbox = require("widget/lib/textbox")

local volume_widget = textbox('(volume)')
function volume_widget:volumectl (mode)
    local widget = volume_widget
    if mode == "update" then
        local f = io.popen("pulsemixer --get-volume")
        local volume = f:read("*n")
        f:close()
        if volume == nil then
            widget:set_markup("<span color='red'>ERR</span>")
            do return end
        end
        volume = string.format("% 3d", volume)

        f = io.popen("pulsemixer --get-mute")
        local muted = f:read("*n")
        f:close()
        if muted == 0 then
            if notify_is_mute then
                volume = ' 🔉' .. volume .. '<span color="green">M</span>'
            else
                volume = ' 🔉' .. volume .. '%'
            end
        else
            volume = ' 🔇' .. volume .. '<span color="red">M</span>'
        end
        widget:set_markup(volume .. " ")
    elseif mode == "up" then
        local f = io.popen("pulsemixer --change-volume +5")
        f:read("*all")
        f:close()
        volume_widget:volumectl("update")
    elseif mode == "down" then
        local f = io.popen("pulsemixer --change-volume -5")
        f:read("*all")
        f:close()
        volume_widget:volumectl("update")
    else
        local f = io.popen("pulsemixer --toggle-mute")
        f:read("*all")
        f:close()
        volume_widget:volumectl("update")
    end
end
volume_clock = timer({ timeout = 10 })
volume_clock:connect_signal("timeout", function () volumectl("update", volume_widget) end)
volume_clock:start()

volume_widget:buttons(awful.util.table.join(
    awful.button({ }, 4, function () volume_widget:volumectl("up") end),
    awful.button({ }, 5, function () volume_widget:volumectl("down") end),
    awful.button({ }, 3, function () awful.util.spawn("termite -e pulsemixer") end),
    awful.button({ }, 2, function ()
        notify_is_mute = not notify_is_mute
        volume_widget:volumectl("update")
    end),
    awful.button({ }, 1, function () volume_widget:volumectl("mute") end)
))
volume_widget:volumectl("update")

notify_is_mute = false
function naughty.config.notify_callback(args)
    if not notify_is_mute then
        awful.spawn{ "paplay", "/usr/share/sounds/freedesktop/stereo/complete.oga"}
    end
    return args
end

return volume_widget
