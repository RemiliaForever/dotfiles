local awful = require("awful")
local textbox = require("widget/lib/textbox")

local function get_memory_usage()
    local ret = {}
    ret['meminfo'] = {}
    ret['arcstat'] = {}
    for l in io.lines('/proc/meminfo') do
        local k, v = l:match('^(%a+):%s+(%d+)')
        if k ~= nil then
            ret['meminfo'][k] = tonumber(v) * 1024
        end
    end
    for l in io.lines('/proc/spl/kstat/zfs/arcstats') do
        local k, v = l:match('^(%a+)%s+%d%s+(%d+)')
        if k ~= nil then
            ret['arcstat'][k] = tonumber(v)
        end
    end
    return ret
end
local function update_mem_widget()
    local mem = get_memory_usage()
    local free = mem.meminfo.MemAvailable
    local zfs = mem.arcstat.size
    local total = mem.meminfo.MemTotal
    local zfs_percent = math.floor(zfs / total * 100 + 0.5)
    local use_percent = 100 - math.floor(free / total * 100 + 0.5)
    mem_widget:set_markup(' MEM <span color="#90ee90">' .. use_percent .. '</span><span color="#66ccff">(' .. use_percent - zfs_percent .. ')</span>%')
end
mem_widget = textbox(' MEM ??')
update_mem_widget()
mem_clock = timer({ timeout = 5 })
mem_clock:connect_signal("timeout", update_mem_widget)
mem_clock:start()

return mem_widget
