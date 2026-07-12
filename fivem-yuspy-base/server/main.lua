local Players = {}

--- Oyuncu verisini dondurur veya olusturur
---@param source number
---@return table
local function GetPlayerData(source)
    if not Players[source] then
        Players[source] = {
            source = source,
            name = GetPlayerName(source) or 'Bilinmeyen',
            joinedAt = os.time(),
            identifiers = GetPlayerIdentifiers(source),
        }
    end
    return Players[source]
end

--- Konsola formatli log yazar
---@param message string
local function Log(message)
    print(('[^2%s^7] %s'):format(Config.ServerName, message))
end

--- Oyuncunun belirli bir ACE iznine sahip olup olmadigini kontrol eder
---@param source number
---@param ace string
---@return boolean
local function HasAce(source, ace)
    return IsPlayerAceAllowed(source, ace)
end

--- Tum bagli oyunculari dondurur
---@return table
local function GetOnlinePlayers()
    local online = {}
    for _, playerId in ipairs(GetPlayers()) do
        online[#online + 1] = tonumber(playerId)
    end
    return online
end

-- Export fonksiyonlari (diger kaynaklardan kullanilabilir)
exports('GetPlayerData', GetPlayerData)
exports('HasAce', HasAce)
exports('GetOnlinePlayers', GetOnlinePlayers)
exports('Log', Log)

-- Kaynak basladiginda
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    Log(('Kaynak baslatildi. Aktif oyuncu: %d/%d'):format(#GetPlayers(), Config.MaxPlayers))
end)

-- Kaynak durdugunda
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    Log('Kaynak durduruldu.')
end)

-- Oyuncu baglandiginda
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local playerId = source
    deferrals.defer()

    Wait(0)
    deferrals.update('Baglanti kontrol ediliyor...')

    local playerCount = #GetPlayers()
    if playerCount >= Config.MaxPlayers then
        deferrals.done('Sunucu dolu. Lutfen daha sonra tekrar dene.')
        return
    end

    deferrals.done()
end)

-- Oyuncu tamamen yuklendiginde
AddEventHandler('playerJoining', function()
    local playerId = source
    local data = GetPlayerData(playerId)

    if Config.EnableJoinLeaveLogs then
        Log(('%s (%d) sunucuya baglandi.'):format(data.name, playerId))
    end

    TriggerClientEvent('yuspy:client:welcome', playerId, Config.WelcomeMessage:format(data.name))
end)

-- Oyuncu ayrildiginda
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local data = Players[playerId]

    if data and Config.EnableJoinLeaveLogs then
        Log(('%s (%d) sunucudan ayrildi. Sebep: %s'):format(data.name, playerId, reason or 'bilinmiyor'))
    end

    Players[playerId] = nil
end)
