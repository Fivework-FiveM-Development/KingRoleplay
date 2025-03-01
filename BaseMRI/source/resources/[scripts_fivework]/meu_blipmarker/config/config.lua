Config = Config or {}

-- modelo de orgs
local favela = "Morro"
local qg = "Máfia"
local dp = "Delegacia"
local bpm = "Batalhão"
local hp = "Hospital"
local mc = "Mecânica"
local Restaurantes = "Restaurante"


Config.Blips = {
    -- Adicione mais blips aqui
-------------------------------------------------------------------------------------
--- Favelas

    {
        name = favela .. " - FRANÇA", -- COCAINA
        icon = 310,
        size = 0.8,
        color = 1,
        coords = { x = -2493.9, y = 1887.04, z = 211.39 },
    },

    {
        name = favela .. " - PETROLEO",-- MACONHA
        icon = 310,
        size = 0.8,
        color = 1,
        coords = { x = 1389.95, y = -2415.19, z = 82.94 },
    },
    --[[
        {
            name = favela .. " - SEM LOCAL",-- COCAINA
            icon = 310,
            size = 0.8,
            color = 1,
            coords = { x = 0, y = 0, z = 0 },
        },
    ]]

-------------------------------------------------------------------------------------
-- QGs

    {
        name = qg .. " - QG DE MUNIÇÃO", -- mansão
        icon = 310,
        size = 0.8,
        color = 0,
        coords = { x = -2664.42, y = 1317.48, z = 147.45 },-- -2664.42,1317.48,147.45,314.65
    },
    {
        name = qg .. " - QG DE MUNIÇÃO",-- vinhedo / BRATVA
        icon = 310,
        size = 0.8,
        color = 0,
        coords = { x = -1897.75, y = 2047.5, z = 150.84 },-- -586.23,290.26,100.13,314.65    
    },

-------------------------------------------------------------------------------------
-- Policia
    {
        name = dp .. " - Policia Civil",
        icon = 58,
        size = 0.8,
        color = 0,
        coords = { x = 427.46, y = -981.09, z = 33.57 },
    },
    {
        name = bpm .. " - GOE",
        icon = 137,
        size = 0.8,
        color = 0,
        coords = { x = -909.1, y = -2064.2, z = 19.13 },
    },
    {
        name = bpm .. " - Policia Militar",
        icon = 137,
        size = 0.8,
        color = 0,
        coords = { x = 1134.36, y = 801.35, z = 166.36 },
    },
-------------------------------------------------------------------------------------
-- Hospital
    {
        name = hp .. " - King's Clinical SUS",
        icon = 107,
        size = 0.8,
        color = 3,
        coords = { x = 307.22, y = -584.11, z = 64.07 }, -- 307.22 ,-584.11 ,64.07 ,314.65
    },
-------------------------------------------------------------------------------------
-- Mecanico

    {
        name = mc .. " - King's Repair",
        icon = 566,
        size = 0.8,
        color = 0,
        coords = { x = 718.7, y = -1086.26, z = 22.31 },
    },
    {
        name = mc .. " - King's Repair",
        icon = 566,
        size = 0.8,
        color = 0,
        coords = { x = 1182.83, y = 2656.35, z = 40.25 },
    },
-------------------------------------------------------------------------------------
-- bennys
    {
        name = mc .. " - King's Custom",
        icon = 446,
        size = 0.8,
        color = 0,
        coords = { x = 156.51, y = -3024.86, z = 7.04},
    },
-------------------------------------------------------------------------------------
--Lanchonetes
-------------------------------------------------------------------------------------
    --[[
        {
            name = Restaurantes .. " - BurguerShot",
            icon = 137,
            size = 0.8,
            color = 0,
            coords = { x = -1183.09, y = -882.99, z = 13.77 },
        },
    ]]
        

-------------------------------------------------------------------------------------
    -- lojas de roupa


    {   name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords ={  x = 1693.2, y = 4828.11, z = 42.07},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords = { x = -705.5, y = -149.22, z = 37.42},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords =  {x = -1192.61, y = -768.4, z = 17.32},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords = { x = 425.91, y = -801.03, z = 29.49},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords =  {x = -168.73, y = -301.41, z = 39.73},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords =  {x = 75.39, y = -1398.28, z = 29.38},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords = { x = -1445.86, y = -240.78, z = 49.82},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords =  {x = 9.22, y = 6515.74, z = 31.88},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords =  {x = 615.35, y = 2762.72, z = 42.09},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords = { x = 1191.61, y = 2710.91, z = 38.22},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords ={  x = -3171.32, y = 1043.56, z = 20.86},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords ={  x = -1105.52, y = 2707.79, z = 19.11},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords ={  x = -1119.24, y = -1440.6, z = 5.23},
    },
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords ={  x = 124.82, y = -224.36, z = 54.56},
    },
--------- loja de roupa pier
    {
        name = 'Loja de Roupas',
        icon = 73,
        size = 0.6,
        color = 0,
        coords ={ -1606.45, y = -1074.44, z = 13.02 },
    },
----}, barbearia pier
    {
        name = 'Barbearia',
        icon = 71,
        size = 0.6,
        color = 0,
        coords ={ -1626.68, y = -1092.03, z = 13.02 },
    },
    {
        name = 'Barbearia',
        icon = 71,
        size = 0.6,
        color = 0,
        coords = {  x = -814.22, y = -183.7, z = 37.57 },
    },

    {
        name = 'Barbearia',
        icon = 71,
        size = 0.6,
        color = 0,
        coords = {  x = 136.78, y = -1708.4, z = 29.29 },
    },
    {
        name = 'Barbearia',
        icon = 71,
        size = 0.6,
        color = 0,
        coords ={  x = -1282.57, y = -1116.84, z = 6.99},
    },
    {
        name = 'Barbearia',
        icon = 71,
        size = 0.6,
        color = 0,
        coords ={  x = 1931.41, y = 3729.73, z = 32.84},
    },
    {
        name = 'Barbearia',
        icon = 71,
        size = 0.6,
        color = 0,
        coords ={  x = 1212.8, y = -472.9, z = 65.2},
    },
    {
        name = 'Barbearia',
        icon = 71,
        size = 0.6,
        color = 0,
        coords ={  x = -32.9, y = -152.3, z = 56.1},
    },
    {
        name = 'Barbearia',
        icon = 71,
        size = 0.6,
        color = 0,
        coords ={  x = -278.1, y = 6228.5, z = 30.7},
    },
    -----------------------
    -- tatuagem pier
    {
        name = 'Tatuagens',
        icon = 75,
        size = 0.6,
        color = 4,
        coords ={  x = -1616.51, y = -1087.61, z = 13.02},
    },
    -----------------------
    {
        name = 'Tatuagens',
        icon = 75,
        size = 0.6,
        color = 4,
        coords ={  x = 1322.6, y = -1651.9, z = 51.2},

    },
    {
        name = 'Tatuagens',
        icon = 75,
        size = 0.6,
        color = 4,
        coords ={  x = -1154.01, y = -1425.31, z = 4.95},
 
    },
    {
        name = 'Tatuagens',
        icon = 75,
        size = 0.6,
        color = 4,
        coords ={  x = 322.62, y = 180.34, z = 103.59},

    },
    {
        name = 'Tatuagens',
        icon = 75,
        size = 0.6,
        color = 4,
        coords ={  x = -3169.52, y = 1074.86, z = 20.83},
    },
    {
        name = 'Tatuagens',
        icon = 75,
        size = 0.6,
        color = 4,
        coords ={  x = 1864.1, y = 3747.91, z = 33.03},
    },
    {
        name = 'Tatuagens',
        icon = 75,
        size = 0.6,
        color = 4,
        coords ={  x = -294.24, y = 6200.12, z = 31.49},
    },
    -- barbearias
    -- Estudio Tatuagem
    -- Posto de Gasolina
-------------------------------------------------------------------------------------    


}