fx_version 'cerulean'
game 'gta5'
author 'Jure & Johny'
version '1.9.3'
lua54 'yes'

shared_scripts {
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*'
}

client_scripts {
    'client/*'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/bmw.png'
}
