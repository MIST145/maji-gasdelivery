
local ESX = nil

Citizen.CreateThread(function() 
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

local props = {
    'prop_storagetank_02b',
}

local refuelProp = 'prop_oil_wellhead_06'

local coords = vector3(1733.08, -1556.68, 112.66)
local heading = 252.0
local tankerCoords = vector3(1738.34, -1530.89, 112.65)
local refuelheading = 254.5
local cooldown = 0
local blip = nil
local stationsRefueled = 0
local maxStations = 0
local truck = 0
local trailer = 0
local nozzleInHand = false
local Rope1 = nil
local Rope2 = nil
local playerPed = PlayerPedId()
local targetCoord = vector3(1688.59, -1460.29, 111.65)
local distanceThreshold = 15.0
local RefuelingStation = false
local timestried = 0
local StoredTruck = nil
local StoredTrailer = nil
local src = source

local trailerModels = {
    '1956216962',
    '3564062519'
}

local myBoxZone = BoxZone:Create(vector3(1694.6, -1460.75, 112.92), 26.8, 15, {
    heading = 345,
    debugPoly = false
})

-- Criar a animação
local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
end

-- Criar o ped do NPC
local pedModel = Config.PedType
local pedCoords = vector4(1721.87, -1557.67, 111.65, 243.12)

Citizen.CreateThread(function()
    while true do
        FreezeEntityPosition(pumpProp, true)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    local pedHash = GetHashKey(pedModel)
    RequestModel(pedHash)

    while not HasModelLoaded(pedHash) do
        Citizen.Wait(0)
    end

    local targetped = CreatePed(4, pedHash, pedCoords.x, pedCoords.y, pedCoords.z, pedCoords.w, false, true)
    SetEntityAsMissionEntity(targetped, true, true)
    SetBlockingOfNonTemporaryEvents(targetped, true)
    SetPedDiesWhenInjured(targetped, false)
    SetPedCanRagdollFromPlayerImpact(targetped, false)
    SetPedCanRagdoll(targetped, false)
    SetPedCanPlayAmbientAnims(targetped, true)
    SetPedCanPlayAmbientBaseAnims(targetped, true)
    SetPedCanPlayGestureAnims(targetped, true)
    SetPedCanPlayVisemeAnims(targetped, false, false)
    SetPedCanPlayInjuredAnims(targetped, false)
    FreezeEntityPosition(targetped, true)
    SetEntityInvincible(targetped, true)

    -- Criar um blip no mapa
    blip = Citizen.InvokeNative(0x23f74c2fda6e7c61, 1664425300, coords.x, coords.y, coords.z, 0.8, 120, 0, 0, 0, 0, 0, 255, false, false, 28422)

    -- Verificar se o jogador está dentro da boxzone
    myBoxZone:OnPlayerInside(function(src, dist)
        if dist < distanceThreshold then
            RefuelingStation = true
        else
            RefuelingStation = false
        end
    end)

    -- Abrir o menu do script
    if Config.UseMenu == true then
        if Config.Menu == 'qb' and Config.Target == 'qb' then
            ESX.UI.Menu.CloseAll()

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_menu', {
                title    = 'Trucker Menu',
                align    = 'top-left',
                elements = {
                    {label = 'Talk To Boss!', value = 'boss'},
                }
            }, function(data, menu)
                if data.current.value == 'boss' then
                    -- Chamar o evento do menu QB
                end
            end, function(data, menu)
                menu.close()
            end)
        end
    end
end)
