-- Initialisation des variables locales
local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1 = 
    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil

----------------------------
-- Base URL du serveur
----------------------------
L0_1 = nil
ESX.RegisterServerCallback("camera:getBaseUrl", function(source, cb)
    if not L0_1 then
        L0_1 = GetConvar("web_baseUrl", "")
    end
    cb(L0_1)
end)

----------------------------
-- Préfixe des types de média
----------------------------
local mediaTypes = { Audio = "audio", Image = "image", Video = "video" }

----------------------------
-- Récupérer l'URL présignée
----------------------------
ESX.RegisterServerCallback("camera:getPresignedUrl", function(source, cb, fileType)
    local mediaType = mediaTypes[fileType]
    if not mediaType then
        return cb()
    end

    if Config.UploadMethod[fileType] ~= "Fivemanage" then
        return cb()
    end

    PerformHttpRequest("https://api.fivemanage.com/api/presigned-url?fileType=" .. mediaType, function(statusCode, responseText, headers)
        if statusCode ~= 200 then
            print("Error: Failed to get presigned URL from Fivemanage for " .. mediaType)
            return cb()
        end
        local response = json.decode(responseText)
        cb(response and response.presignedUrl or nil)
    end, "GET", "", { Authorization = API_KEYS[fileType] })
end)

----------------------------
-- Gestion des événements Voix
----------------------------
RegisterNetEvent("phone:setListeningPeerId")
AddEventHandler("phone:setListeningPeerId", function(peerId)
    if not Config.Voice.RecordNearby then
        return
    end

    local src = source
    local player = Player(src)
    local currentPeerId = player.state.listeningPeerId

    if currentPeerId then
        TriggerClientEvent("phone:stoppedListening", -1, currentPeerId)
    end

    player.state.listeningPeerId = peerId
    if peerId then
        TriggerClientEvent("phone:startedListening", -1, src, peerId)
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local player = Player(src)
    local currentPeerId = player.state.listeningPeerId
    if currentPeerId then
        TriggerClientEvent("phone:stoppedListening", -1, currentPeerId)
    end
end)

----------------------------
-- API Upload
----------------------------
ESX.RegisterServerCallback("camera:getUploadApi", function(source, cb, fileType)
    local apiKey = nil
    if fileType then
        apiKey = API_KEYS[fileType]
        if not apiKey then
            return cb()
        end
    else
        return cb()
    end

    if Config.UploadMethod[fileType] == "Fivemanage" then
        DropPlayer(source, "Tried to abuse the upload system")
        return cb()
    end

    cb(apiKey)
end)

----------------------------
-- Définition des métadonnées valides
----------------------------
local validMetadata = {
    selfie = true,
    import = true,
    screenshot = true
}

----------------------------
-- Sauvegarder une image dans la galerie
----------------------------
ESX.RegisterServerCallback("camera:saveToGallery", function(source, cb, phoneNumber, link, size, isVideo, metadata, logUpload)
    if not IsMediaLinkAllowed(link) then
        infoprint("error", ("%s %s tried to save an image with a link that is not allowed"):format(source, phoneNumber))
        return cb(false)
    end

    if metadata then
        if not validMetadata[metadata] then
            debugprint("Invalid metadata", metadata)
            metadata = nil
        end
    end

    local insertedId = MySQL.insert.await("INSERT INTO phone_photos (phone_number, link, is_video, size, metadata) VALUES (?, ?, ?, ?, ?)", {
        phoneNumber,
        link,
        (isVideo == true),
        size or 0,
        metadata
    })

    if logUpload then
        Log("Uploads", source, "info", L("BACKEND.LOGS.UPLOADED_MEDIA"), L("BACKEND.LOGS.UPLOADED_MEDIA_DESCRIPTION", {
            type = isVideo and L("BACKEND.LOGS.VIDEO") or L("BACKEND.LOGS.PHOTO"),
            id = insertedId,
            link = link
        }), link)
        TrackSimpleEvent(isVideo and "take_video" or "take_photo")
    end

    cb(insertedId)
end)

----------------------------
-- Supprimer des images de la galerie
----------------------------
ESX.RegisterServerCallback("camera:deleteFromGallery", function(source, cb, phoneNumber, ids)
    MySQL.update.await("DELETE FROM phone_photos WHERE phone_number = ? AND id IN (?)", { phoneNumber, ids })
    cb(true)
end)

----------------------------
-- Basculer l'état Favoris
----------------------------
ESX.RegisterServerCallback("camera:toggleFavourites", function(source, cb, phoneNumber, isFavourite, ids)
    MySQL.update.await("UPDATE phone_photos SET is_favourite = ? WHERE phone_number = ? AND id IN (?)", { (isFavourite == true), phoneNumber, ids })
    cb(true)
end)

----------------------------
-- Récupérer les images
----------------------------
ESX.RegisterServerCallback("camera:getImages", function(source, cb, phoneNumber, options, page)
    if not (options.showVideos or options.showPhotos) then
        return cb({})
    end

    local params = { phoneNumber }
    local query = "SELECT id, link, is_video, size, metadata, is_favourite, `timestamp` FROM phone_photos WHERE phone_number = ?"

    if options.showPhotos ~= options.showVideos then
        query = query .. " AND (is_video = ? OR is_video != ?)"
        table.insert(params, (options.showVideos == true))
        table.insert(params, (options.showPhotos == true))
    end

    if options.favourites == true then
        query = query .. " AND is_favourite = 1"
    end

    if options.type then
        query = query .. " AND metadata = ?"
        table.insert(params, options.type)
    end

    if options.album then
        query = query .. " AND id IN (SELECT ap.photo_id FROM phone_photo_album_photos ap WHERE ap.album_id = ?)"
        table.insert(params, options.album)
    end

    if options.duplicates then
        query = query .. [[
AND link IN (
    SELECT link
    FROM phone_photos
    WHERE phone_number = ?
    GROUP BY link
    HAVING COUNT(1) > 1
)
]]
        table.insert(params, phoneNumber)
    end

    local perPage = math.clamp(options.perPage or 32, 1, 32)
    query = query .. " ORDER BY `timestamp` DESC LIMIT ?, ?"
    table.insert(params, (page or 0) * perPage)
    table.insert(params, perPage)

    cb(MySQL.query.await(query, params))
end)

----------------------------
-- Récupérer la dernière image
----------------------------
ESX.RegisterServerCallback("camera:getLastImage", function(source, cb, phoneNumber)
    cb(MySQL.scalar.await("SELECT link FROM phone_photos WHERE phone_number = ? ORDER BY `timestamp` DESC LIMIT 1", { phoneNumber }))
end)

----------------------------
-- Gestion des albums
----------------------------
ESX.RegisterServerCallback("camera:createAlbum", function(source, cb, phoneNumber, title)
    cb(MySQL.insert.await("INSERT INTO phone_photo_albums (phone_number, title) VALUES (?, ?)", { phoneNumber, title }))
end)

ESX.RegisterServerCallback("camera:renameAlbum", function(source, cb, phoneNumber, albumId, newTitle)
    cb(MySQL.update.await("UPDATE phone_photo_albums SET title = ? WHERE phone_number = ? AND id = ?", { newTitle, phoneNumber, albumId }) > 0)
end)

ESX.RegisterServerCallback("camera:addToAlbum", function(source, cb, phoneNumber, albumId, photoIds)
    local exists = MySQL.scalar.await("SELECT 1 FROM phone_photo_albums WHERE phone_number = ? AND id = ?", { phoneNumber, albumId })
    if not exists then
        return cb(false)
    end
    MySQL.update.await("INSERT IGNORE INTO phone_photo_album_photos (album_id, photo_id) SELECT ?, id FROM phone_photos WHERE phone_number = ? AND id IN (?)", { albumId, phoneNumber, photoIds })
    cb(true)
end)

ESX.RegisterServerCallback("camera:removeFromAlbum", function(source, cb, phoneNumber, albumId, photoIds)
    local exists = MySQL.scalar.await("SELECT 1 FROM phone_photo_albums WHERE phone_number = ? AND id = ?", { phoneNumber, albumId })
    if not exists then
        return cb(false)
    end
    MySQL.update.await("DELETE FROM phone_photo_album_photos WHERE album_id = ? AND photo_id IN (?)", { albumId, photoIds })
    cb(true)
end)

ESX.RegisterServerCallback("camera:deleteAlbum", function(source, cb, phoneNumber, albumId)
    cb(MySQL.update.await("DELETE FROM phone_photo_albums WHERE phone_number = ? AND id = ?", { phoneNumber, albumId }) > 0)
end)

----------------------------
-- Récupérer les données pour la page d'accueil
----------------------------
local albumKeys = {
    "videos",
    "photos",
    "favouritesVideos",
    "favouritesPhotos",
    "selfiesVideos",
    "selfiesPhotos",
    "screenshotsVideos",
    "screenshotsPhotos",
    "importsVideos",
    "importsPhotos",
    "duplicatesPhotos",
    "duplicatesVideos"
}

ESX.RegisterServerCallback("camera:getHomePageData", function(source, cb, phoneNumber)
    local mediaStats = MySQL.single.await([[
        SELECT
            SUM(is_video = 1) AS videos,
            SUM(is_video = 0) AS photos,
            SUM(is_video = 1 AND is_favourite = 1) AS favouritesVideos,
            SUM(is_video = 0 AND is_favourite = 1) AS favouritesPhotos,
            SUM(metadata = 'selfie' AND is_video = 1) AS selfiesVideos,
            SUM(metadata = 'selfie' AND is_video = 0) AS selfiesPhotos,
            SUM(metadata = 'screenshot' AND is_video = 1) AS screenshotsVideos,
            SUM(metadata = 'screenshot' AND is_video = 0) AS screenshotsPhotos,
            SUM(metadata = 'import' AND is_video = 1) AS importsVideos,
            SUM(metadata = 'import' AND is_video = 0) AS importsPhotos,
            SUM(CASE WHEN is_video = 0 THEN 1 ELSE 0 END) - COUNT(DISTINCT CASE WHEN is_video = 0 THEN link END) AS duplicatesPhotos,
            SUM(CASE WHEN is_video = 1 THEN 1 ELSE 0 END) - COUNT(DISTINCT CASE WHEN is_video = 1 THEN link END) AS duplicatesVideos
        FROM phone_photos
        WHERE phone_number = ?
    ]], { phoneNumber })

    for _, key in ipairs(albumKeys) do
        mediaStats[key] = tonumber(mediaStats[key]) or 0
    end

    if mediaStats.duplicatesPhotos > 0 then
        mediaStats.duplicatesPhotos = mediaStats.duplicatesPhotos + 1
    end
    if mediaStats.duplicatesVideos > 0 then
        mediaStats.duplicatesVideos = mediaStats.duplicatesVideos + 1
    end

    local albums = {}

    local recents = {
        id = "recents",
        title = L("APPS.PHOTOS.RECENTS"),
        videoCount = mediaStats.videos,
        photoCount = mediaStats.photos,
        cover = MySQL.scalar.await("SELECT link FROM phone_photos WHERE phone_number = ? ORDER BY id DESC LIMIT 1", { phoneNumber }),
        removable = false
    }

    local favourites = {
        id = "favourites",
        title = L("APPS.PHOTOS.FAVOURITES"),
        videoCount = mediaStats.favouritesVideos,
        photoCount = mediaStats.favouritesPhotos,
        cover = MySQL.scalar.await("SELECT link FROM phone_photos WHERE phone_number = ? AND is_favourite = 1 ORDER BY id DESC LIMIT 1", { phoneNumber }),
        removable = false
    }

    table.insert(albums, recents)
    table.insert(albums, favourites)

    local userAlbums = MySQL.query.await([[
        SELECT
            pa.id,
            pa.title,
            (SELECT link FROM phone_photos WHERE id = MAX(ap.photo_id)) AS cover,
            SUM(CASE WHEN pp.is_video = 1 THEN 1 ELSE 0 END) AS videoCount,
            SUM(CASE WHEN pp.is_video = 0 THEN 1 ELSE 0 END) AS photoCount
        FROM phone_photo_albums pa
        LEFT JOIN phone_photo_album_photos ap ON ap.album_id = pa.id
        LEFT JOIN phone_photos pp ON pp.id = ap.photo_id
        WHERE pa.phone_number = ?
        GROUP BY pa.id
        ORDER BY pa.id ASC
    ]], { phoneNumber })

    for _, album in ipairs(userAlbums) do
        album.removable = true
        album.photoCount = tonumber(album.photoCount) or 0
        album.videoCount = tonumber(album.videoCount) or 0
        album.count = album.photoCount + album.videoCount
        table.insert(albums, album)
    end

    cb({ albums = albums, mediaTypes = mediaStats })
end)
