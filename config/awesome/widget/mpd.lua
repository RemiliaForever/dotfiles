local timer = require("gears.timer")
local awful = require("awful")

local mpc = require("widget/lib/mpc")
local textbox = require("widget/lib/textbox")
local utf8str = require("widget/lib/utf8str")

local mpd_widget = textbox()
local state, title, artist, file = "stop", "", "", ""
local elapse, duration = 0, 0

local width, roll = 30, 0

local function update_widget()
    local text = ' <span color="#66ccff">'
    info = tostring(artist or "N/A") .. " - " .. tostring(title or file)
    text = text .. info
    text = text .. '</span> <span color="#66ffcc">' .. elapsed .. "/" .. duration
    if state == "pause" then
        text = text .. " (P)"
    end
    if state == "stop" then
        text = text .. " (S)"
    end
    mpd_widget:set_markup(text .. "</span>")
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
    mpd_widget:set_text("")
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
        roll = roll + 1
        elapsed = to_minute(result.elapsed)
        pcall(update_widget)
    end)
end)
clock:start()

function mpd_widget:send(s)
    connection:send(s)
end

mpd_widget:buttons(awful.util.table.join(
    awful.button({ }, 3, function () awful.util.spawn_with_shell("termite -e 'ncmpcpp'") end),
    awful.button({ }, 1, function () mpd_widget:send("pause") end)
))

return mpd_widget
