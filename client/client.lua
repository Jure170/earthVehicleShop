local ESX  = nil
local otvoren = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    local blip = AddBlipForCoord(-34.04, -1102.32, 26.44)

    SetBlipSprite(blip, 662)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 43)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Autosalon")
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("salon:open", function()
    SendNUIMessage({
        action = "open",
    })
    SendNUIMessage({
        action = "loadCars",
        cars = Config.Vehicles
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    otvoren = true
end)

RegisterNUICallback('zatvori', function(data, cb)
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)
    SendNUIMessage({action = "close"})
    otvoren = false
end)

RegisterNUICallback('kupiVozilo', function(data, cb)
    local voziloModel = data.model
    ESX.TriggerServerCallback('salon:provjeriNovac', function(imaNovca)
        if imaNovca then
            ESX.TriggerServerCallback('salon:kupiVozilo', function(voziloPlate)
                if voziloPlate then
                    local playerPed = PlayerPedId()

                    ESX.Game.SpawnVehicle(voziloModel, vector3(-27.24, -1082.2, 26.64), 75.08, function(vehicle)
                        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                        vehicleProps.plate = voziloPlate
                        SetVehicleNumberPlateText(vehicle, voziloPlate)

                        TriggerServerEvent('salon:spremiVozilo', voziloModel, vehicleProps)
                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        ESX.ShowNotification('The vehicle was successfully purchased and delivered!')
                    end)
                    cb({ success = true })
                else
                    ESX.ShowNotification("An error occurred while generating the tables")
                    cb({ success = false, error = "An error occurred while generating the tables." })
                end
            end, voziloModel)
        else
            ESX.ShowNotification("You don't have enough money!")
            cb({ success = false, error = "You don't have enough money!" })
        end
    end, voziloModel)
end)

RegisterNUICallback('pokreniTestVoznju', function(data, cb)
    local voziloModel = data.model
    local playerPed = PlayerPedId()
    local testDriveLocation = vector3(-1654.16, -3098.40, 13.94)
    SetEntityCoords(playerPed, -1654.16, -3098.40, 13.94)
    ESX.Game.SpawnVehicle(voziloModel, testDriveLocation, 330.0, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    end)

    Citizen.SetTimeout(60000, function()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle ~= nil then
            ESX.Game.DeleteVehicle(vehicle)
        end

        SetEntityCoords(playerPed, -34.88, -1102.24, 26.44)
        SetEntityHeading(playerPed, 180.0)
        ESX.ShowNotification("Test drive finished")
    end)

    cb('ok')
end)

RegisterCommand("salon", function()
    TriggerEvent("salon:open")
end)
