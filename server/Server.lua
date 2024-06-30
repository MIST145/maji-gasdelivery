
local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('md-checkCash')
AddEventHandler('md-checkCash', function()
    local src = source
    local player = ESX.GetPlayerFromId(src)
    local moneyType = Config.PayType
    local balance = player.getMoney(moneyType)

    if Config.Debug == true then
        print(moneyType)
    end

    if balance >= Config.TruckPrice then
        if moneyType == 'cash' then
            player.removeMoney(moneyType, Config.TruckPrice, "gas-delivery-truck")
            TriggerClientEvent('spawnTruck', src)
            TriggerClientEvent('TrailerBlip', src)
        else
            player.removeMoney(moneyType, Config.TruckPrice, "gas-delivery-truck")
            TriggerClientEvent('spawnTruck', src)
            TriggerClientEvent('TrailerBlip', src)
        end
    else
        TriggerClientEvent('NotEnoughTruckMoney', src)
    end
end)

RegisterServerEvent('md-ownedtruck')
AddEventHandler('md-ownedtruck', function()
    local src = source
    local player = ESX.GetPlayerFromId(src)
    local moneyType = Config.PayType
    local balance = player.getMoney(moneyType)

    if Config.Debug == true then
        print(moneyType)
    end

    if balance >= Config.TankPrice then
        if moneyType == 'cash' then
            player.removeMoney(moneyType, Config.TankPrice, "gas-Tank-truck")
            TriggerClientEvent('spawnTruck2', src)
            TriggerClientEvent('TrailerBlip', src)
        else
            player.removeMoney(moneyType, Config.TankPrice, "gas-Tank-truck")
            TriggerClientEvent('spawnTruck2', src)
            TriggerClientEvent('TrailerBlip', src)
        end
    else
        TriggerClientEvent('NotEnoughTankMoney', src)
    end
end)

RegisterServerEvent('md-getpaid')
AddEventHandler('md-getpaid', function(stationsRefueled)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    local moneyType = Config.PayType
    local balance = player.getMoney(moneyType)

    player.addMoney(Config.PayType, stationsRefueled * Config.PayPerFueling, "gas-delivery-paycheck")
end)
