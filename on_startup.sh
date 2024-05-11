#!/bin/bash

# Исполняем все комманды от рута!
su root

# Установить переменные окружения
export DISPLAY=:0
export XAUTHORITY=/root/.Xauthority

# Создать screen с именем tg-s53hb и выполнить в нем команды
screen -S tg-s53hb -d -m -q
screen -r tg-s53hb -X stuff "
su root
cd /home/repositories/server53_helper_bot
source start_bot.sh
"

# Создать другой screen с именем mc-server и выполнить в нем команды
screen -S mc-server -d -m -q
screen -r mc-server -X stuff "
su root
cd /home/minecraft/spigot-1.20.2
source start_server.sh
"

# Создать ещё один скрин с именем homeworker и выполнить в нём команды
screen -S homeworker -d -m -q
screen -r homeworker -X stuff "
su root
cd /home/repositories/HwSystem_bot
source start_bot.sh
"


screen -S tg-wbot -d -m -q
screen -r tg-wbot -X stuff "
su root
cd /home/repositories/wbot
source start_bot.sh
"


screen -S tg-clean-chat-bot -d -m -q
screen -r tg-clean-chat-bot -X stuff "
su root
cd /home/repositories/clean-chat-bot
source start_bot.sh
"


# Запуск ragemp сервера
source /opt/ragemp-srv/start_server.sh


# Запускаем какую-то Похуяновскую штуку
systemctl restart nginx gunicorn

