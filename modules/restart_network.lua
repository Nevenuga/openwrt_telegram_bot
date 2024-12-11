local io = require("io")
local os = require("os")
local ltn12 = require("ltn12")
local sendMessage = require("modules.send_message")
local sendMessageAfterEstabilishConnection = require("modules.send_message_after_estabilish_connection")

local function restartNetwork()
    sendMessage("Сеть перезапускается...")
    os.execute("service penis restart")
    sendMessageAfterEstabilishConnection("Сеть успешно перезапущена")
end
return restartNetwork