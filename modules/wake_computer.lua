local os = require("os")
local config = require("config")
local sendMessage = require("modules.send_message")

local function wakeComputer()
    local interface = "br-lan"
    local command = "etherwake -i " .. interface .. " " .. config.computer_mac
    os.execute(command)
    sendMessage("Запрос на запуск отправлен")
end
return wakeComputer