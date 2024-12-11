local config = require("config")
local https = require("ssl.https")
local json = require("cjson")
local ltn12 = require("ltn12")

local function getUpdates(offset)
    local url = "https://api.telegram.org/bot" .. config.bot_token .. "/getUpdates?offset=" .. (offset or "")
    local response_body = {}

    local res, code, response_headers, status = https.request{
        url = url,
        sink = ltn12.sink.table(response_body)
    }

    if not res or code ~= 200 then
        print("Error: failed to get updates. HTTP code: " .. (code or "N/A"))
        return nil, code
    end

    local response_str = table.concat(response_body)

    if response_str == "" then
        print("Error: empty response from Telegram API.")
        return nil, code
    end

    local success, updates = pcall(function() return json.decode(response_str) end)
    if not success then
        print("Error decoding JSON: " .. response_str)
        return nil, code
    end

    return updates, code
end

return getUpdates