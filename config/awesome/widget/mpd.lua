local timer = require("gears.timer")
local awful = require("awful")
local wibox = require("wibox")

local mpc = require("widget/lib/mpc")
local textbox = require("widget/lib/textbox")

local title_text = textbox()
local time_text = textbox()
local mpd_widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    wibox.container.margin(wibox.widget {
        layout = wibox.container.scroll.horizontal,
        max_size = 180,
        speed = 30,
        title_text
    },5,5,0,0),
    time_text
}
local state, title, artist, file = "stop", "", "", ""
local elapse, duration = 0, 0

local function update_widget()
    local text = '<span color="#66ccff">'

    local info = tostring(artist or "N/A") .. " - " .. tostring(title or file)
    text = text .. awful.util.escape(info) .. '</span>'
    title_text:set_markup(text)

    if state == "pause" then
        text = '<span color="#ffcc66">'
    elseif state == "stop" then
        text = '<span color="#ff66cc">'
    else
        text = '<span color="#66ffcc">'
    end
    text = text .. elapsed .. "/" .. duration .. "</span>"
    time_text:set_markup(text)
end

local function to_minute(sec)
    sec = math.floor(sec)
    m = math.floor(sec / 60)
    s = sec % 60
    if s < 10 then
        s = "0" .. s
    end
    return m .. ":" .. s
end

local connection
local function error_handler(err)
    title_text:set_text("")
    time_text:set_markup('<span color="#66ffcc">-:--/-:--</span>')
end
connection = mpc.new(nil, nil, nil, error_handler,
"status", function(_, result)
    state = result.state
end,
"currentsong", function(_, result)
    title, artist, file = result.title, result.artist, result.file
    duration = to_minute(result.time)
    pcall(update_widget)
end)
clock = timer({ timeout = 1 })
clock:connect_signal("timeout", function()
    connection:send("status", function(_, result)
        elapsed = to_minute(result.elapsed)
        pcall(update_widget)
    end)
end)
clock:start()

function mpd_widget:send(s)
    connection:send(s)
end

mpd_widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () mpd_widget:send("pause") end),
    awful.button({ }, 3, function () awful.util.spawn_with_shell("termite -e 'ncmpcpp'") end),
    awful.button({ }, 5, function () mpd_widget:send("next") end),
    awful.button({ }, 4, function () mpd_widget:send("previous") end)
))

return mpd_widget
