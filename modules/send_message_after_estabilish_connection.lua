local config = require("config")
local sendMessage = require("modules.send_message")
local https = require("ssl.https")
local json = require("cjson")
local ltn12 = require("ltn12")

local function sendMessageAfterEstabilishConnection(message)
    local function isInternetAvailable()
        local handle = io.popen("ping -c 1 8.8.8.8")
        local result = handle:read("*a")
        handle:close()
        return result:find("1 packets received") ~= nil
    end

    for i = 1, 100 do
        if isInternetAvailable() then
            sendMessage(message)
            break
        else
            print("No connection, retry in 5 seconds...")
            os.execute("sleep 5")
        end
    end
end
return sendMessageAfterEstabilishConnection