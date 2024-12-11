local io = require("io")
local os = require("os")
local ltn12 = require("ltn12")
local sendMessage = require("modules.send_message")

local function getMemoryUsage()
    local handle = io.popen("free -k")
    local result = handle:read("*a")
    handle:close()

    local total_mem, used_mem, free_mem, shared, buff_cache, available = result:match("Mem:%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
    local cached = buff_cache

    total_mem = math.floor(total_mem / 1024)
    used_mem = math.floor(used_mem / 1024)
    cached = math.floor(cached / 1024)

    handle = io.popen("df -h")
    result = handle:read("*a")
    handle:close()

    local overlay_size, overlay_used = result:match("overlayfs:/overlay%s+(%S+)%s+(%S+)%s+%S+%s+%S+%s+/")

    overlay_size = overlay_size or "N/A"
    overlay_used = overlay_used or "N/A"

    sendMessage(string.format("Оперативная память:\nВсего используется: %dM/%dM\nКешировано: %dM\n\nХранилище:\nВсего занято: %s/%s ",used_mem, total_mem, cached, overlay_used, overlay_size))
end
return getMemoryUsage