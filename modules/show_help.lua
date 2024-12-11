local sendMessage = require("modules.send_message")
local function showHelp()
    sendMessage([[
Доступные команды:
/reboot - Перезагружает роутер ♻
/mem - Показывает использование оперативной и постоянной памяти 📊
/net - Перезапускает сеть 🌐
/tun - Тестирует VPN (выводит ip-адрес интерфейса tun0) 🛣
/domain <ссылка> - Разблокирует сайт 📖
/help - Показывает это сообщение ❓
/checkvpn - Отображает статус VPN 🔮
/togglevpn - Включает/выключает VPN 💡
/wake - Включает компьютер по умолчанию 🛌
]])
end
return showHelp