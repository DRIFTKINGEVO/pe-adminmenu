fx_version 'cerulean'

game 'gta5'

lua54 'yes'

description 'An admin menu created with esx_menu_default by Project-Entity'

version '1.0.6'

client_scripts {
    '@es_extended/locale.lua',
    'client/admin_cl.lua',
    'client/entityiter.lua',
    'locales/es.lua',
    'locales/fr.lua',
    'locales/br.lua',
    'locales/en.lua',
    'config.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'server/admin_sv.lua',
    'locales/es.lua',
    'locales/fr.lua',
    'locales/br.lua',
    'locales/en.lua',
    'config.lua'
}