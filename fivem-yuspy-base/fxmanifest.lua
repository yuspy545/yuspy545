fx_version 'cerulean'
game 'gta5'

name 'yuspy-base'
description 'Temel FiveM server-side kaynak sablonu'
author 'yuspy'
version '1.0.0'

lua54 'yes'

shared_scripts {
    'config.lua',
}

server_scripts {
    'server/main.lua',
    'server/events.lua',
    'server/commands.lua',
}
