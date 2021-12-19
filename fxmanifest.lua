fx_version 'cerulean'
game 'gta5'
author 'Codesign#2715'
description 'Devtools'
version '1.0.2'

shared_script 'configs/config.lua'
client_script 'client/client.lua'
server_scripts{
    'server/*.lua'
}

ui_page {
    'html/index.html'
}
files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
}