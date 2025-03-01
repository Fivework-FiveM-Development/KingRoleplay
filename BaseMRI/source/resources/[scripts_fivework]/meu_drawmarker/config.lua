Config = {}

-- Configurações para drawmarkers
Config.DrawMarkers = {
    { -- modelo de drawmarker
        coords = vector3(-431.22, 252.41, 82.97),
        color = { r = 255, g = 0, b = 0 },
        type = 1,
        scale = { x = 1.0, y = 1.0, z = 1.0 },
        text = "DrawMarker A",
        distance = 100.0,
        textDistance = 1.5
    },
    { -- modelo de drawmarker
        coords = vector3(461.97, -981.0, 30.69),
        color = { r = 255, g = 0, b = 0 },
        type = 1,
        scale = { x = 1.0, y = 1.0, z = 1.0 },
        text = "Arsenal Civil",
        distance = 3,
        textDistance = 1.5
    },

    -- modelo  rotas
    { -- modelo de drawmarker
        coords = vector3(-1867.42, 2066.88, 140.98),
        color = { r = 255, g = 0, b = 0 },
        type = 25,
        scale = { x = 1.0, y = 1.0, z = 1.0 },
        text = "Rotas - Bratva",
        distance = 3,
        textDistance = 1.5
    },
}

-- Configurações para teleportes
Config.Teleports = {
    { -- modelo de teleporte
        clickCoords = vector3(578.0, -402.14, 24.77), -- local do clique
        teleportTo = vector3(566.14,-445.71,-69.66), -- local para onde o jogador será teleportado-431.22, 252.41, 82.97
        text = "Teleporte para Local A", -- texto flutuante-431.22, 252.41, 82.97
        distance = 1.5,
        notifyText = "Você foi teleportado para Local A" -- texto de notificação
    }
}
