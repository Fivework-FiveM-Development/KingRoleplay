shared_script '' --this line was automatically written by WaveShield





fx_version "cerulean"
game "gta5"
lua54 "yes"

version "1.7.5"

shared_script {
    "config/*.lua",
    "shared/**/*.lua"
}

client_script "client/**/*.lua"

server_scripts {
    "@es_extended/locale.lua",
    "@oxmysql/lib/MySQL.lua",
    "server/**/*.lua",
}

files {
    "ui/dist/**/*",
    "ui/components.js",
    "config/**/*"
}

ui_page "ui/dist/index.html"

dependencies {
    "loaf_lib",
    "oxmysql"
}

escrow_ignore {
    "config/**/*",

    "client/apps/framework/**/*.lua",
    "server/apps/framework/**/*.lua",
    "shared/*.lua",

    "client/custom/**/*.lua",
    "server/custom/**/*.lua",

    "client/misc/debug.lua",
    "server/misc/debug.lua",

    "server/misc/functions.lua",
    "server/misc/databaseChecker/*.lua",

    "server/apiKeys.lua",

    "types.lua"
}

dependency '/assetpacks'
server_script "@es_extended/locale.lua"

dependency 'es_extended'
dependency 'ox_inventory'

export 'UsePhoneItem'
