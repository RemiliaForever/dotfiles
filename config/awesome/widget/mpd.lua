local mpc = require("widget/lib/mpc")
local textbox = require("widget/lib/textbox")
local timer = require("gears.timer")

local mpd_widget = textbox()
local state, title, artist, file = "stop", "", "", ""
local function update_widget()
    local text = " Current MPD status: "
    text = text .. tostring(artist or "") .. " - " .. tostring(title or "")
    if state == "pause" then
        text = text .. " (paused)"
    end
    if state == "stop" then
        text = text .. " (stopped)"
    end
    mpd_widget.text = text
end


local connection
local function error_handler(err)
    mpd_widget:set_text("Error: " .. tostring(err))
    -- Try a reconnect soon-ish
    timer.start_new(10, function()
        connection:send("ping")
    end)
end
connection = mpc.new(nil, nil, nil, error_handler,
"status", function(_, result)
    state = result.state
end,
"currentsong", function(_, result)
    title, artist, file = result.title, result.artist, result.file
    pcall(update_widget)
end)

return mpd_widget
