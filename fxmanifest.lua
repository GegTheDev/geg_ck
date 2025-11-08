fx_version "cerulean"
game "gta5"
lua54 "yes"

author "geg_scripts ⭐"
description "Customizable Character Kill system!"
version "1.0.0"

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}

-- Added this in case you want to Asset Escrow our script!
escrow_ignore {
    "config.lua"
}