local config = require("config")
local https = require("ssl.https")
local json = require("cjson")
local ltn12 = require("ltn12")

local function sendMessage(text)
    local url = "https://api.telegram.org/bot" .. config.bot_token .. "/sendMessage"
    local data = {
        chat_id = config.user_id,
        text = text
    }
    local response_body = {}

    local res, code, response_headers, status = https.request{
        url = url,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
        },
        source = ltn12.source.string(json.encode(data)),
        sink = ltn12.sink.table(response_body)
    }

    return code
end
return sendMessage