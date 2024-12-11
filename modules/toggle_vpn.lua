local io = require("io")
local os = require("os")
local ltn12 = require("ltn12")
local sendMessage = require("modules.send_message")
local sendMessageAfterEstabilishConnection = require("modules.send_message_after_estabilish_connection")
local restartNetwork = require("modules.restart_network")

local function toggleVpnRoute()
    local file_path = "/etc/hotplug.d/iface/30-vpnroute"
    local file = io.open(file_path, "r")
    
    if not file then
        sendMessage("Error: Could not open the VPN route file.")
    end

    local lines = {}
    local is_commented = false
    for line in file:lines() do
        if line:match("^%s*#%s*ip route add table vpn default dev tun0") then
            table.insert(lines, "ip route add table vpn default dev tun0")
            is_commented = true
        elseif line:match("^%s*ip route add table vpn default dev tun0") then
            table.insert(lines, "# ip route add table vpn default dev tun0")
            is_commented = false
        else
            table.insert(lines, line)
        end
    end
    file:close()

    file = io.open(file_path, "w")
    for _, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()
    restartNetwork()
    os.execute("service sing-box restart")
    if is_commented then
        sendMessageAfterEstabilishConnection("VPN включен")
    else
        sendMessageAfterEstabilishConnection("VPN выключен")
    end
end
return toggleVpnRoute