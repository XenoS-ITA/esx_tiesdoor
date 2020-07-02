ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_tiesdoor:ties', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    local TiesQuantity = xPlayer.getInventoryItem('ties').count

    if TiesQuantity > 0 then
        cb(true)
        xPlayer.removeInventoryItem('ties', 1)
    else
        cb(false)
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You dont have a plastic ties!')
    end    
end)