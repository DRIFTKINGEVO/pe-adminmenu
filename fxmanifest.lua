fx_version 'adamant'

game 'gta5'

description 'Admin menu created by Bombay'
version '0.1.1'


client_scripts {
    '@es_extended/locale.lua',
    'client/client.lua',
    'client/entityiter.lua',
    'client/discord.lua',
    'locales/es.lua',
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
    'server/server.lua',
    'locales/es.lua',
    'config.lua'
}