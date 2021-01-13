fx_version 'cerulean'

game 'gta5'

lua54 'yes'

description 'An admin menu created with esx_menu_default'

version '0.9.2'

client_scripts {
    '@es_extended/locale.lua',
    'client/admin_cl.lua',
    'client/entityiter.lua',
    'locales/*.lua',
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server/admin_sv.lua',
    'locales/*.lua',
    'config.lua'
}
