local io = require("io")
local os = require("os")
local sendMessage = require("modules.send_message")
local function testTunnel()
    print("Testing tunnel...")
    local handle = io.popen("curl --interface tun0 ifconfig.me")
    local result = handle:read("*a")
    handle:close()
    sendMessage(result)
end
return testTunnel