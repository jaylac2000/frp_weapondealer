fx_version 'cerulean'
game 'gta5'

description 'Weapon Dealer Script'
version '1.0.0'

client_scripts {
    'client/main.lua',
    'client/deliveries.lua',
}

server_scripts {
    'server/main.lua',
    'server/deliveries.lua',
}

shared_scripts { 
	'config.lua'
}