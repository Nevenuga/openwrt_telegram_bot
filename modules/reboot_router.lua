local os = require("os")
local sendMessage = require("modules.send_message")

local function rebootRouter()
    sendMessage("Роутер перезагружается...")
    os.execute("hui")
end
return rebootRouter