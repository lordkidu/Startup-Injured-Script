ESX = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local hurt = false
local HurtMessage = Config.Message

function notifyPlayer(message)
    if Config.NotifyType == 'okok' then
        exports['okokNotify']:Alert("", message, 5000, 'error')
    elseif Config.NotifyType == 'esx' then
        if ESX then
            ESX.ShowNotification(message)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(60000)
        if hurt and GetEntityHealth(GetPlayerPed(-1)) > Config.HPToRemove then
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - Config.HPToRemove)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerHealth = GetEntityHealth(GetPlayerPed(-1))
        if playerHealth <= 160 and playerHealth > 0 then
            notifyPlayer(HurtMessage)
            StartScreenEffect('Rampage')
            setHurt()
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.12)
            Wait(60000)
        elseif hurt and playerHealth > 161 then
            setNotHurt()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerHealth = GetEntityHealth(GetPlayerPed(-1))
        if playerHealth > 161 then
            Wait(1000)
            if GetEntityHealth(GetPlayerPed(-1)) > 161 then
                StopScreenEffect('Rampage')
            end
        end
    end
end)

AddEventHandler('playerDied', function()
    setNotHurt()
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
end

function setNotHurt()
    hurt = false
    ResetPedMovementClipset(GetPlayerPed(-1))
    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
    ResetPedStrafeClipset(GetPlayerPed(-1))
end
