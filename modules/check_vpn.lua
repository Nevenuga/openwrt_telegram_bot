local io = require("io")
local os = require("os")
local ltn12 = require("ltn12")
local sendMessage = require("modules.send_message")

local function checkVpn()
    local file_path = "/etc/hotplug.d/iface/30-vpnroute"
    local file = io.open(file_path, "r")
    
    if not file then
        sendMessage("Не удалось открыть файл конфигурации")
    end

    for line in file:lines() do
        if line:match("^%s*#%s*ip route add table vpn default dev tun0") then
            file:close()
            sendMessage("Сейчас VPN выключен")
            return
        elseif line:match("^%s*ip route add table vpn default dev tun0") then
            file:close()
            sendMessage("Сейчас VPN включен")
            return
        end
    end
end
return checkVpn