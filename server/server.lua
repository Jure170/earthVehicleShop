ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function getVehicleByModel(model)
    for _, v in ipairs(Config.Vehicles) do
        if v.model == model then
            return v
        end
    end
    return nil
end

ESX.RegisterServerCallback('salon:provjeriNovac', function(source, cb, voziloModel)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vozilo = getVehicleByModel(voziloModel)

    if vozilo and xPlayer.getMoney() >= vozilo.price then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('salon:kupiVozilo', function(source, cb, voziloModel)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vozilo = getVehicleByModel(voziloModel)

    if vozilo and xPlayer.getMoney() >= vozilo.price then
        local voziloPlate = GeneratePlate()
        xPlayer.removeMoney(vozilo.price)
        cb(voziloPlate)
    else
        cb(nil)
    end
end)

RegisterServerEvent('salon:spremiVozilo')
AddEventHandler('salon:spremiVozilo', function(voziloModel, vehicleProps)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vozilo = getVehicleByModel(voziloModel)

    if vozilo then
        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
            ['@owner']   = xPlayer.identifier,
            ['@plate']   = vehicleProps.plate,
            ['@vehicle'] = json.encode(vehicleProps)
        }, function(rowsChanged)
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'Greška: Vozilo nije pronađeno.')
    end
end)

function GeneratePlate()
    local plate = string.upper(GetRandomLetter(3) .. ' ' .. GetRandomNumber(3))
    return plate
end

function GetRandomLetter(length)
    local letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local result = ''
    for i = 1, length do
        local rand = math.random(1, #letters)
        result = result .. string.sub(letters, rand, rand)
    end
    return result
end

function GetRandomNumber(length)
    local numbers = '0123456789'
    local result = ''
    for i = 1, length do
        local rand = math.random(1, #numbers)
        result = result .. string.sub(numbers, rand, rand)
    end
    return result
end
