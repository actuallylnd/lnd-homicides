ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local function generateNewToken()
    return math.random(100000, 999999)
end

local serverToken = generateNewToken()

-----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------- 

RegisterNetEvent('lnd-homicides:robbedped')
AddEventHandler('lnd-homicides:robbedped', function(receivedToken)
    receivedToken = serverToken
    local src = source

    function DropItem(player)
        
        local dropChance = Config.dropChance
    
        local randomNumber = math.random(1, 100)
    
        if randomNumber <= dropChance then
            exports.ox_inventory:AddItem(source, Config.randomItem, 30)
            twitterWood(GetPlayerName(src).. " get randomitem " ..Config.randomItem)
        end
    end

    if exports.ox_inventory:CanCarryItem(source, 'orderphone') then
        exports.ox_inventory:AddItem(source, 'orderphone', 1)
        DropItem()
    end

        if serverToken == receivedToken then
            twitterWood(GetPlayerName(src).. " takes order phone")
            serverToken = generateNewToken()
        else
            twitterWood("No Authorization for " .. GetPlayerName(src))
            serverToken = generateNewToken()
            DropPlayer(src, 'Invalid token')
        end
end)

-----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------- 

RegisterNetEvent('lnd-homicides:robbeddone')
AddEventHandler('lnd-homicides:robbeddone', function(receivedToken)
    receivedToken = serverToken
    local src = source

    local count = exports.ox_inventory:GetItemCount(src, 'orderphone')
    exports.ox_inventory:RemoveItem(source, 'orderphone', 1)

    if exports.ox_inventory:CanCarryItem(source, 'mysterydocuments') and count > 0 then
        exports.ox_inventory:AddItem(source, 'mysterydocuments', 1)
        twitterWood(GetPlayerName(src).. " takes mysterydocuments")
    end

        if serverToken == receivedToken then
            serverToken = generateNewToken()
        else
            twitterWood("No Authorization for " .. GetPlayerName(src))
            serverToken = generateNewToken()
            DropPlayer(src, 'Invalid token')
        end
end)

-----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------- 

RegisterNetEvent('lnd-homicides:transfer')
AddEventHandler('lnd-homicides:transfer', function(receivedToken)
    receivedToken = serverToken
    local src = source

    local count = exports.ox_inventory:GetItemCount(src, 'mysterydocuments')
    exports.ox_inventory:RemoveItem(source, 'mysterydocuments', 1)

        if serverToken == receivedToken then
            twitterWood(GetPlayerName(src).. " give mysterydocuments and start killer job")
            serverToken = generateNewToken()
        else
            twitterWood("No Authorization for " .. GetPlayerName(src))
            serverToken = generateNewToken()
            DropPlayer(src, 'Invalid token')
        end
end)

-----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------- 

RegisterNetEvent('lnd-homicides:robkilledvictim')
AddEventHandler('lnd-homicides:robkilledvictim', function(receivedToken)
    receivedToken = serverToken
    local src = source

    function DropItem(player)
        
        local dropChance2 = Config.dropChance2
        local randomNumber = math.random(1, 1000000) ---DROP CHANCE NOW IS 0,001% ON PISTOL
    
        if randomNumber <= dropChance2  then
            exports.ox_inventory:AddItem(source, Config.victimdrop, 1)
            twitterWood(GetPlayerName(src).. " get randomitem from victim " ..Config.victimdrop)
        end
    end
    DropItem()

    if exports.ox_inventory:CanCarryItem(source, 'victimsdrugs') then
        exports.ox_inventory:AddItem(source, 'victimsdrugs', 3)
    end


        if serverToken == receivedToken then
            serverToken = generateNewToken()
        else
            twitterWood("No Authorization for " .. GetPlayerName(src))
            serverToken = generateNewToken()
            DropPlayer(src, 'Invalid token')
        end
end)

-----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------- 

RegisterNetEvent('lnd-homicides:finish')
AddEventHandler('lnd-homicides:finish', function(receivedToken)
    receivedToken = serverToken
    local src = source

    if exports.ox_inventory:CanCarryItem(source, 'money') then
        exports.ox_inventory:AddItem(source, 'money', Config.FinishPrice)
        exports.ox_inventory:GetItemCount(src, 'victimsdrugs')
        exports.ox_inventory:RemoveItem(source, 'victimsdrugs', 3)
    end


        if serverToken == receivedToken then
            twitterWood(GetPlayerName(src).. " end task and earn " ..Config.FinishPrice)
            serverToken = generateNewToken()
        else
            twitterWood("No Authorization for " .. GetPlayerName(src))
            serverToken = generateNewToken()
            DropPlayer(src, 'Invalid token')
        end
end)

-----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------- 

RegisterServerEvent('lnd-homicides:server:startCountdown3')
AddEventHandler('lnd-homicides:server:startCountdown3', function()
    countdownActive3 = true

    local countdownOrder = Config.TakeOrderCooldown
    while countdownOrder > 0 and countdownActive3 do
        Wait(1000)
    
        countdownOrder = countdownOrder - 1

         
        if countdown == 0 then
            asked = true  -- Assuming you want to set Robbed to true when the countdown reaches 0
        end

        TriggerClientEvent('lnd-homicides:client:blockTalk', -1, countdownActive3) 

        print('Pozostały czas odliczania:', countdownOrder)
    end

    TriggerClientEvent('lnd-homicides:client:blockTalk', -1, false)
end)

ESX.RegisterServerCallback('lnd-homicides:server:talkavaible', function(source, cb)
    cb(asked)
end)

RegisterServerEvent('lnd-homicides:server:stopCountdown3')
AddEventHandler('lnd-homicides:server:stopCountdown3', function()
    countdownActive3 = false
end)

-----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------- 


RegisterNetEvent('lnd-homicides:start')
AddEventHandler('lnd-homicides:start', function ()
    local src = source
    twitterWood("Start the homicides " .. GetPlayerName(src))
end)

-----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------- 


twitter = {
    ['twittericon'] = 'https://discord.com/api/webhooks/1216718769733369927/tp-G0hxW185njqfwAUT9ZYhOZejCcWh5HHEeQ1h1krk6z6KF1xNUmqKlXiQAuSKbfnby', --[[DISCORD WEBHOOK LINK]]
    ['name'] = 'Homicides',
    ['image'] = 'https://cdn.discordapp.com/attachments/1166695681679966298/1213641460725977109/wodka.png?ex=65f636b0&is=65e3c1b0&hm=e9e474c56317879ce63482dae28065b04a2aa72ba5b74b55062ed7f044967e24&'
}

function twitterWood(name, message)
    local data = {
        {
            ["color"] = '363940',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(twitter['twittericon'], function(err, text, headers) end, 'POST', json.encode({username = twitter['name'], embeds = data, avatar_url = twitter['image']}), { ['Content-Type'] = 'application/json' })
end