--- Konsol log yardimcisi
local function LogCommand(playerId, command, args)
    if not Config.EnableCommandLogs then
        return
    end

    local name = playerId == 0 and 'Konsol' or (GetPlayerName(playerId) or 'Bilinmeyen')
    local argString = table.concat(args, ' ')
    exports[GetCurrentResourceName()]:Log(('%s /%s %s kullandi.'):format(name, command, argString))
end

--- /online - Aktif oyuncu sayisini gosterir
RegisterCommand('online', function(source, args)
    local count = #GetPlayers()
    local message = ('Aktif oyuncu: %d/%d'):format(count, Config.MaxPlayers)

    if source == 0 then
        print(message)
    else
        TriggerClientEvent('yuspy:client:notify', source, message, 'info')
    end

    LogCommand(source, 'online', args)
end, false)

--- /kick [id] [sebep] - Oyuncuyu atar (admin)
RegisterCommand('kick', function(source, args)
    if source ~= 0 and not exports[GetCurrentResourceName()]:HasAce(source, Config.AdminAce) then
        TriggerClientEvent('yuspy:client:notify', source, 'Bu komut icin yetkin yok.', 'error')
        return
    end

    local targetId = tonumber(args[1])
    local reason = table.concat(args, ' ', 2)

    if not targetId or not GetPlayerName(targetId) then
        local msg = 'Kullanim: /kick [id] [sebep]'
        if source == 0 then
            print(msg)
        else
            TriggerClientEvent('yuspy:client:notify', source, msg, 'error')
        end
        return
    end

    reason = reason ~= '' and reason or 'Yonetici tarafindan atildi.'
    DropPlayer(targetId, reason)

    LogCommand(source, 'kick', args)
end, false)

--- /announce [mesaj] - Tum oyunculara duyuru (moderator+)
RegisterCommand('announce', function(source, args)
    if source ~= 0 and not exports[GetCurrentResourceName()]:HasAce(source, Config.ModeratorAce) then
        TriggerClientEvent('yuspy:client:notify', source, 'Bu komut icin yetkin yok.', 'error')
        return
    end

    local message = table.concat(args, ' ')
    if message == '' then
        local msg = 'Kullanim: /announce [mesaj]'
        if source == 0 then
            print(msg)
        else
            TriggerClientEvent('yuspy:client:notify', source, msg, 'error')
        end
        return
    end

    TriggerClientEvent('yuspy:client:notify', -1, message, 'announce')
    LogCommand(source, 'announce', args)
end, false)

--- /coords - Oyuncunun koordinatlarini konsola yazar (debug)
RegisterCommand('coords', function(source, args)
    if source == 0 then
        print('Bu komut sadece oyuncular icin.')
        return
    end

    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local text = ('X: %.2f | Y: %.2f | Z: %.2f | H: %.2f'):format(coords.x, coords.y, coords.z, heading)
    TriggerClientEvent('yuspy:client:notify', source, text, 'info')

    LogCommand(source, 'coords', args)
end, false)
