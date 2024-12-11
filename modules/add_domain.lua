local io = require("io")
local os = require("os")
local ltn12 = require("ltn12")
local sendMessage = require("modules.send_message")
local restartNetwork = require("modules.restart_network")

local function extractDomain(url)
    return url:match("^https?://([^/]+)") or url:match("^([^/]+)")
end
local function addDomain(domain)
    local cleaned_domain = extractDomain(domain)

    if not cleaned_domain then
        sendMessage("Неверный формат домена. Попробуйте еще раз")
        return
    end

    local dhcp_file = "/etc/config/dhcp"
    local file = io.open(dhcp_file, "a")
    if not file then
        sendMessage("Не удалось найти файл конфигурации dhcp")
        return
    end

    file:write("\tlist domain '" .. cleaned_domain .. "'\n")
    file:close()

    os.execute("service dnsmasq restart")
    restartNetwork()

    sendMessage("Домен " .. cleaned_domain .. " теперь работает через VPN.")
end
return addDomain