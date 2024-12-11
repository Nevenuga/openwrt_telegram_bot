# OpenWRT Telegram Bot

## Описание
Этот бот для Telegram позволяет управлять устройством на OpenWRT через мессенджер.

## Возможности
- Управление устройством OpenWRT
- Отправка команд через Telegram
- Мониторинг системы
- Работа с VPN через SingBox

## Установка
1. Клонируйте репозиторий
2. Обновите пакеты и установите `lua-cjson` 
```bash
opkg update
opkg install lua-cjson
```
3. Настройте конфигурацию бота в `config.lua`
4. Запустите бота
```bash
lua main.lua
```