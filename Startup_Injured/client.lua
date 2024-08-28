local Config = {
    UseOkokNotify = true -- You can adjust this value according to your needs
}

local hurt = false

Citizen.CreateThread(function()
    while true do
        Wait(60000) -- in ms
        if hurt and GetEntityHealth(GetPlayerPed(-1)) > 3 then
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - 3) -- 3 is the number of HP removed
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerHealth = GetEntityHealth(GetPlayerPed(-1))
        if playerHealth <= 160 and playerHealth > 0 then
            local formattedMessage = Config.Message

            if Config.OKOKNotify and not Config.UseESXDefaultNotify then
                exports['okokNotify']:Alert("", formattedMessage, 5000, 'error')
            elseif Config.UseESXDefaultNotify and not Config.OKOKNotify then
                ESX.ShowNotification(formattedMessage)
            end
            StartScreenEffect('Rampage')
            setHurt()
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.12) -- Add blood effect on screen
            Wait(60000) -- wait 60 seconds after the first notification
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
            Wait(1000) -- Wait for 1000 ms
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
