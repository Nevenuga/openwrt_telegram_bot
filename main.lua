local config = require("config")
local sendMessage = require("modules.send_message")
local getUpdates = require("modules.get_updates")
local saveConfigFile = require("modules.save_config_file")
local sendMessageAfterEstabilishConnection = require("modules.send_message_after_estabilish_connection")
local restartNetwork = require("modules.restart_network")
local rebootRouter = require("modules.reboot_router")
local getMemoryUsage = require("modules.get_memory_usage")
local toggleVpnRoute = require("modules.toggle_vpn")
local checkVpn = require("modules.check_vpn")
local addDomain = require("modules.add_domain")
local wakeComputer = require("modules.wake_computer")
local testTunnel = require("modules.test_tunnel")
local showHelp = require("modules.show_help")

local https = require("ssl.https")
local json = require("cjson")
local io = require("io")
local os = require("os")
local ltn12 = require("ltn12")

sendMessageAfterEstabilishConnection("Роутер перезагружен")
local offset = 0
local first_message = true
while true do
    local updates, code = getUpdates(offset)
    if updates and updates.ok then
        for _, update in ipairs(updates.result) do
            offset = update.update_id + 1
            if update.message and update.message.chat.id == config.user_id then
                local text = update.message.text and update.message.text:lower()
                if first_message then
                    first_message = false
                else
                    if text == "/reboot" then
                        rebootRouter()

                    elseif text == "/mem" then
                        getMemoryUsage()

                    elseif text == "/wake" then
                        wakeComputer()

                    elseif text == "/net" then
                        restartNetwork()

                    elseif text == "/tun" then
                        testTunnel()

                    elseif text == "/togglevpn" then
                        toggleVpnRoute()

                    elseif text == "/checkvpn" then
                        checkVpn()

                    elseif text and text:match("^/domain%s+") then
                        local domain = text:match("^/domain%s+(.+)")
                        if domain then
                            addDomain(domain)
                        else
                            sendMessage("Укажите домен для добавления. Пример использования: /adddomain <ссылка>")
                        end

                    elseif update.message.document then
                        
                        if update.message.document.file_name == "config.json" then
                            local result = saveConfigFile(update.message.document.file_id)
                            sendMessage(result)
                        else
                            sendMessage("Пожалуйста, загрузите файл config.json.")
                        end

                    elseif text == "/help" then
                        showHelp()

                    else
                        sendMessage("Неизвестная команда. Используйте /help, чтобы посмотреть доступные команды")
                    end
                end
            end
        end
    end

    os.execute("sleep 1")
end