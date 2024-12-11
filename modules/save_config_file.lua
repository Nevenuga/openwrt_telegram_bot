local config = require("config")
local https = require("ssl.https")
local json = require("cjson")
local io = require("io")
local os = require("os")
local ltn12 = require("ltn12")
local sendMessage = require("modules.send_message")

local function saveConfigFile(file_id)
    local url = "https://api.telegram.org/bot" .. config.bot_token .. "/getFile?file_id=" .. file_id
    local response_body = {}

    local res, code = https.request{
        url = url,
        sink = ltn12.sink.table(response_body)
    }

    if code ~= 200 then
        print("Error: failed to get file information.")
    end

    local response_str = table.concat(response_body)
    local file_info = json.decode(response_str)
    
    if not file_info.ok then
        sendMessage("Ошибка: " .. (file_info.description or "Не удалось получить файл"))
    end

    local file_path = file_info.result.file_path
    local file_url = "https://api.telegram.org/file/bot" .. config.bot_token .. "/" .. file_path

    
    local file_data = {}
    res, code = https.request{
        url = file_url,
        sink = ltn12.sink.table(file_data)
    }

    if code ~= 200 then
        sendMessage("Не удалось скачать файл")
    end

    
    local config_file = "/etc/sing-box/config.json"
    local file = io.open(config_file, "w")

    if not file then
        sendMessage("Не удалось открыть файл для записи")
    end

    file:write(table.concat(file_data))
    file:close()
    os.execute("service sing-box restart")
    sendMessage("Вы установили новый файл конфигурации.")
end
return saveConfigFile