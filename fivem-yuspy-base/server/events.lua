--- Client'tan gelen ping eventi
RegisterNetEvent('yuspy:server:ping', function()
    local playerId = source
    local data = exports[GetCurrentResourceName()]:GetPlayerData(playerId)

    TriggerClientEvent('yuspy:client:pong', playerId, {
        serverTime = os.time(),
        playerName = data.name,
    })
end)

--- Oyuncu bilgisi istegi (ornek: baska bir kaynak kullanabilir)
RegisterNetEvent('yuspy:server:requestPlayerInfo', function(targetId)
    local playerId = source
    targetId = tonumber(targetId)

    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('yuspy:client:notify', playerId, 'Oyuncu bulunamadi.', 'error')
        return
    end

    local targetData = exports[GetCurrentResourceName()]:GetPlayerData(targetId)

    TriggerClientEvent('yuspy:client:notify', playerId, ('%s (ID: %d)'):format(targetData.name, targetId), 'info')
end)

--- Admin: oyuncuya mesaj gonder
RegisterNetEvent('yuspy:server:sendMessage', function(targetId, message)
    local playerId = source

    if not exports[GetCurrentResourceName()]:HasAce(playerId, Config.AdminAce) then
        TriggerClientEvent('yuspy:client:notify', playerId, 'Bu islem icin yetkin yok.', 'error')
        return
    end

    targetId = tonumber(targetId)
    message = tostring(message or ''):sub(1, 200)

    if not targetId or message == '' or not GetPlayerName(targetId) then
        TriggerClientEvent('yuspy:client:notify', playerId, 'Gecersiz hedef veya mesaj.', 'error')
        return
    end

    TriggerClientEvent('yuspy:client:notify', targetId, message, 'admin')
    TriggerClientEvent('yuspy:client:notify', playerId, 'Mesaj gonderildi.', 'success')
end)
