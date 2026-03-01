fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ndrp_jobcenter'
author 'thedshadow'
description 'Job Center for new players with skills progression system'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

ui_page 'ui.html'

files {
    'ui.html',
}

dependencies {
    'ox_lib',
    'ox_target',
    'qbx_core',
}
