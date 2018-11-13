local awful = require("awful")
local textbox = require("widget/lib/textbox")

local function get_memory_usage()
    local ret = {}
    for l in io.lines('/proc/meminfo') do
        local k, v = l:match("([^:]+):%s+(%d+)")
        ret[k] = tonumber(v)
    end
    return ret
end
local function update_mem_widget()
    local meminfo = get_memory_usage()
    local free = meminfo.MemAvailable
    local total = meminfo.MemTotal
    local percent = 100 - math.floor(free / total * 100 + 0.5)
    mem_widget:set_markup(' MEM <span color="#90ee90">'.. string.format("%2d", percent) ..'%</span>')
end
mem_widget = textbox(' MEM ??')
update_mem_widget()
mem_clock = timer({ timeout = 5 })
mem_clock:connect_signal("timeout", update_mem_widget)
mem_clock:start()

return mem_widget
