ESX = nil
ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local blockedTalk = false


AddEventHandler('onClientResourceStart', function(ressourceName)
    if(GetCurrentResourceName() ~= ressourceName) then
        return
    end 
    print("" ..ressourceName.." start")
    randomlocation()
    talkped()
    friendped()
end)


----FOR PED 1-----
function randomlocation()
    local randomlocation =  math.random(1, #Config.randomlocation)
    return Config.randomlocation[randomlocation]
end

local randomlocation = randomlocation()

----PED 1-----
function talkped()
    local modelName = Config.Ped
    local modelHash = GetHashKey(modelName)
    
    lib.requestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Wait(10)
    end

    spawnedPed = CreatePed(5, modelHash, randomlocation.x, randomlocation.y, randomlocation.z - 1.0 , randomlocation.w, false,false)

    if spawnedPed ~= 0 then
        SetPedDefaultComponentVariation(spawnedPed)
        SetEntityInvincible(spawnedPed, true)
        SetBlockingOfNonTemporaryEvents(spawnedPed, true)
        SetPedFleeAttributes(spawnedPed, 0, 0)
        FreezeEntityPosition(spawnedPed, true)


        ClearPedTasksImmediately(spawnedPed)
        TaskStartScenarioInPlace(spawnedPed, Config.scenario, 0, false)
    end 
end

----PED 2-----
function friendped()

    friendlocation = Config.friendlocation

    local modelName2 = Config.PedFriend
    local modelHash2 = GetHashKey(modelName2)
    
    lib.requestModel(modelHash2)

    while not HasModelLoaded(modelHash2) do
        Wait(10)
    end

    pedFriend = CreatePed(1, modelHash2, friendlocation.x, friendlocation.y, friendlocation.z -1.0, friendlocation.w, false,false)

    if pedFriend ~= 0 then
        SetPedDefaultComponentVariation(pedFriend)
        SetEntityInvincible(pedFriend, true)
        SetBlockingOfNonTemporaryEvents(pedFriend, true)
        SetPedFleeAttributes(pedFriend, 0, 0)
        FreezeEntityPosition(pedFriend, true)


        ClearPedTasksImmediately(pedFriend)
        TaskStartScenarioInPlace(pedFriend, Config.scenariofriend, 0, false)
    end 
end

function wayppointfrd()
    local blipfriend = AddBlipForEntity(pedFriend)
    SetBlipSprite(blipfriend, 280)
    SetBlipRouteColour(blipfriend, 81)
    SetBlipColour(blipfriend, 81)
    SetBlipScale(blipfriend, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Xin")
    EndTextCommandSetBlipName(blipfriend)

    function RemoveFrd()
        RemoveBlip(blipfriend)
    end
end


function janna()
local jannaped = AddBlipForEntity(spawnedPed)
SetBlipSprite(jannaped, 280)
SetBlipRouteColour(jannaped, 3)
SetBlipColour(jannaped, 3)
SetBlipScale(jannaped, 0.8)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Janna")
EndTextCommandSetBlipName(jannaped)

function RemoveJna()
    RemoveBlip(jannaped)
end
end

----FRIEND PED HERE------
exports.ox_target:addBoxZone({
    coords = vec3(-2904.5415, -3.1377, 7.9728),
    size = vec3(2,2,2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'homicides-friendlocation',
            event = '',
            icon = 'fa-regular fa-comments',
            label = 'Talk',
            distance = 1.5,
            onSelect = function()

                if not asked then
                    lib.notify({
                        description = 'Get out of here',
                        duration = 5000,
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            }
                        },
                        icon = 'fa-solid fa-xmark',
                        iconColor = '#C53030',
                        iconAnimation = 'fade',
                        alignIcon = 'center'
                    })
                    return
                end

                if donekill then
                    lib.notify({
                        description = 'You did a great job you got the high here for the work, now fuck off',
                        duration = 5000,
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            }
                        },
                        icon = 'fa-solid fa-check',
                        iconColor = '#2ECC71',
                        iconAnimation = 'fade',
                        alignIcon = 'center'
                    })
                    donekill = false
                    searchvictim = false
                    endtask = true
                    RemoveFrd()
                    xinanimation()

                    lib.requestAnimDict('mp_common')
                    TaskPlayAnim(PlayerPedId(), 'mp_common', "givetake1_b", 8.0, 8.0, -1, 50, 0, true, true, true)

                    Citizen.SetTimeout(2000, function ()
                        ClearPedTasksImmediately(PlayerPedId())
                    end)

                    TriggerServerEvent('lnd-homicides:finish')
                    return
                end

                if taketaskfrd then
                    lib.notify({
                        description = 'Give me a break, come back when you have completed the task',
                        duration = 5000,
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            }
                        },
                        icon = 'fa-solid fa-xmark',
                        iconColor = '#C53030',
                        iconAnimation = 'fade',
                        alignIcon = 'center'
                    })
                    return
                end


                if asked and not taketaskfrd and workdone then

                    if endtask then
                        lib.notify({
                            description = 'I dont have any more work for you get lost',
                            duration = 5000,
                            style = {
                                backgroundColor = '#141517',
                                color = '#C1C2C5',
                                ['.description'] = {
                                    color = '#909296'
                                }
                            },
                            icon = 'fa-solid fa-xmark',
                            iconColor = '#C53030',
                            iconAnimation = 'fade',
                            alignIcon = 'center'
                        })
                        return
                    end

                    lib.notify({
                        title = 'Xin',
                        description = 'I see you came with my stuff, but listen, I have a job for you, you have to kill this motherfucker who owes me fat money.',
                        duration = 5000,
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            },
                        },
                        icon = 'fa-solid fa-question',
                        iconColor = '#1688c6',
                        iconAnimation = 'fade',
                        alignIcon = 'center'
                    })
                    TriggerServerEvent('lnd-homicides:transfer')
                    xinanimation()

                    lib.requestAnimDict('mp_common')
                    TaskPlayAnim(PlayerPedId(), 'mp_common', "givetake1_b", 8.0, 8.0, -1, 50, 0, true, true, true)

                    Citizen.SetTimeout(2000, function ()
                        ClearPedTasksImmediately(PlayerPedId())
                    end)

                    taketaskfrd = true

                    victimped()

                end
            end
        }
    }
})

-----------ANIMATIONS-FOR-PEDS--------------
function xinanimation()
    lib.requestAnimDict('mp_common')
    TaskPlayAnim(pedFriend, 'mp_common', "givetake1_b", 8.0, 8.0, -1, 50, 0, true, true, true)
        Citizen.SetTimeout(4000, function ()
        ClearPedTasksImmediately(pedFriend)
        TaskStartScenarioInPlace(pedFriend, Config.scenariofriend, 0, false)
    end)
end
    function Jannaanimation()
        lib.requestAnimDict('mp_common')
        TaskPlayAnim(spawnedPed, 'mp_common', "givetake1_b", 8.0, 8.0, -1, 50, 0, true, true, true)
        Citizen.SetTimeout(4000, function ()
            ClearPedTasksImmediately(spawnedPed)
            TaskStartScenarioInPlace(spawnedPed, Config.scenario, 0, false)
        end)
    end


----MAIN PED HERE------
exports.ox_target:addBoxZone({
    coords = randomlocation,
    size = vec3(2,2,2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'homicides-randomlocation',
            event = '',
            icon = 'fa-regular fa-comments',
            label = 'Talk',
            distance = 1.5,
            onSelect = function()

                if not asked then
                    lib.notify({
                        title = 'Janna',
                        description = 'I see you like to accost people I have a job for you I need you to rob a guy like this he got under my skin if you rob him come see me again',
                        duration = 5000,
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            },
                        },
                        icon = 'fa-solid fa-question',
                        iconColor = '#1688c6',
                        iconAnimation = 'fade',
                        alignIcon = 'center'
                    })
                    TriggerServerEvent('lnd-homicides:start')
                    TriggerServerEvent('lnd-homicides:server:startCountdown3')
                    TriggerServerEvent('lnd-homicides:server:talkavaible')
                    asked = true
                    endtask = false
                    taketaskfrd = false
                    workdone = false
                elseif asked == targetrobbed then
                    lib.notify({
                        description = 'Thanks man, good job Im forwarding the documents to you and delivering them to my friend.',
                        duration = 7000,
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            }
                        },
                        icon = 'fa-solid fa-check',
                        iconColor = '#2ECC71',
                        iconAnimation = 'fade',
                        alignIcon = 'center'
                    })
                    Jannaanimation()
                    RemoveJna()
                    lib.requestAnimDict('mp_common')
                    TaskPlayAnim(PlayerPedId(), 'mp_common', "givetake1_b", 8.0, 8.0, -1, 50, 0, true, true, true)
                    Citizen.SetTimeout(2000, function ()
                        ClearPedTasksImmediately(PlayerPedId())
                    end)
                    
                    targetrobbed = false
                    TriggerServerEvent('lnd-homicides:robbeddone')
                    wayppointfrd()
                    return
                elseif asked == workdone and targetrobbed == false then
                    lib.notify({
                        description = 'Get out of here',
                        duration = 5000,
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            }
                        },
                        icon = 'fa-solid fa-xmark',
                        iconColor = '#C53030',
                        iconAnimation = 'fade',
                        alignIcon = 'center'
                    })
                    return
                else
                    lib.notify({
                        description = 'Dude give me a break, do your job first',
                        duration = 5000,
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            }
                        },
                        icon = 'fa-solid fa-xmark',
                        iconColor = '#C53030',
                        iconAnimation = 'fade',
                        alignIcon = 'center'
                    })
                    return
                end
                robbingped()
            end
        }
    }
})

RegisterNetEvent('lnd-homicides:client:blockTalk')
AddEventHandler('lnd-homicides:client:blockTalk', function(blocked)
    blockedTalk  = blocked

    if blockedTalk  then
        asked  = true
    else
        asked = false
    end
end)


----------------------------VICTIM-PED-----------------------------------

function victimped()

    RemoveFrd()

    function randomvictimpeds()
        local randomvictimped =  math.random(1, #Config.victims)
            return Config.victims[randomvictimped]
    end

    local randomvictimped = randomvictimpeds()

    local modelName = Config.VictimPed
        local modelHash = GetHashKey(modelName)
        
        lib.requestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Wait(10)
        end

        victimpedd = CreatePed(1, modelHash,randomvictimped.x, randomvictimped.y, randomvictimped.z ,randomvictimped.w, true,true)


        if victimpedd ~= 0 then
            SetEntityAsMissionEntity(victimpedd,true,true)
        end

        if DoesEntityExist(victimpedd) and not IsEntityDead(victimpedd) then
            TaskWanderStandard(victimpedd,0.0, 20)
            GiveWeaponToPed(victimpedd, 'WEAPON_PISTOL',80, false, true)


        local blipvictim = AddBlipForEntity(victimpedd)
        SetBlipSprite(blipvictim, 303)
        SetBlipRouteColour(blipvictim, 1)
        SetBlipColour(blipvictim, 1)
        SetBlipScale(blipvictim, 0.6)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Victim")
        EndTextCommandSetBlipName(blipvictim)


        function deletepedandendvictim()
            Citizen.SetTimeout(10000, function ()
                RemoveBlip(blipvictim)
                DeletePed(victimpedd)
            end)
        end
        
        while true do
        Citizen.Wait(1000)

        if DoesEntityExist(victimpedd) and IsEntityDead(victimpedd) then
                exports.ox_target:addLocalEntity(victimpedd, {
                    {
                        name = 'searchvictim',
                        icon = "fa-solid fa-person",
                        label = 'Search Victim',
                        distance = 1.3,
                        onSelect = function ()

                            if searchvictim then
                                lib.notify({
                                    description = 'Had nothing else',
                                    duration = 5000,
                                    style = {
                                        backgroundColor = '#141517',
                                        color = '#C1C2C5',
                                        ['.description'] = {
                                            color = '#909296'
                                        }
                                    },
                                    icon = 'fa-solid fa-xmark',
                                    iconColor = '#C53030',
                                    iconAnimation = 'fade',
                                    alignIcon = 'center'
                                })
                                return
                            end

                            if not searchvictim then
                            lib.progressCircle({
                                duration = 10000,
                                position = 'middle',
                                useWhileDead = false,
                                canCancel = false,
                                disable = {
                                    sprint = true,
                                    move = true
                                },
                                anim = {
                                    dict = 'anim@gangops@facility@servers@bodysearch@',
                                    clip = 'player_search'
                                },
                            })
                            lib.notify({
                                description = 'You found Xin Stuff in his pants',
                                duration = 5000,
                                style = {
                                    backgroundColor = '#141517',
                                    color = '#C1C2C5',
                                    ['.description'] = {
                                        color = '#909296'
                                    }
                                },
                                icon = 'fa-solid fa-check',
                                iconColor = '#2ECC71',
                                iconAnimation = 'fade',
                                alignIcon = 'center'
                            })
                            deletepedandendvictim()
                            taketaskfrd = false
                            donekill = true
                            TriggerServerEvent('lnd-homicides:robkilledvictim')
                        end
                        searchvictim = true
                    end 
                    }
                })
            end
            if IsEntityDead(victimpedd) then
                wayppointfrd()
                lib.notify({
                    description = 'You killed the victim see if he had anything valuable on him',
                    duration = 5000,
                    style = {
                        backgroundColor = '#141517',
                        color = '#C1C2C5',
                        ['.description'] = {
                            color = '#909296'
                        }
                    },
                    icon = 'fa-solid fa-check',
                    iconColor = '#2ECC71',
                    iconAnimation = 'fade',
                    alignIcon = 'center'
                })
                break
            end
        end
    end
end

----ROBBING PED, BLIP, DELETE PED, ROB TARGET, SKILL CHECK------
function robbingped()

    function randompedlocations()
        local randompedlocation =  math.random(1, #Config.PedLocations)
            return Config.PedLocations[randompedlocation]
    end

    local randompedlocation = randompedlocations()

    local modelName = Config.RobbedPed
        local modelHash = GetHashKey(modelName)
        
        lib.requestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Wait(10)
        end

        robped = CreatePed(1, modelHash, randompedlocation.x, randompedlocation.y, randompedlocation.z ,randompedlocation.w, true,true)


        if robped ~= 0 then
            SetEntityAsMissionEntity(robped,true,true)
        end

        if DoesEntityExist(robped) and not IsEntityDead(robped) then

            SetPedFleeAttributes(robped, 0, 0)
            ClearPedTasksImmediately(robped)
            TaskStartScenarioInPlace(robped, Config.scenariorobped, 0, false)

        local blip2 = AddBlipForEntity(robped)
        SetBlipSprite(blip2, 286)
        SetBlipRouteColour(blip2, 11)
        SetBlipColour(blip2, 11)
        SetBlipScale(blip2, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Target")
        EndTextCommandSetBlipName(blip2)


        function deletepedandend()
            RemoveBlip(blip2)
            DeletePed(robped)
        end

        if DoesEntityExist(robped) then
                exports.ox_target:addLocalEntity(robped, {
                    {
                        name = 'robbery&cuting',
                        icon = "fa-solid fa-person",
                        label = 'Rob',
                        distance = 1.3,
                        onSelect = function ()

                            if targetrobbed then
                                lib.notify({
                                    description = 'You Rob him',
                                    duration = 5000,
                                    style = {
                                        backgroundColor = '#141517',
                                        color = '#C1C2C5',
                                        ['.description'] = {
                                          color = '#909296'
                                        }
                                    },
                                    icon = 'fa-solid fa-xmark',
                                    iconColor = '#C53030',
                                    iconAnimation = 'fade',
                                    alignIcon = 'center'
                                })
                                if lib.skillCheckActive() then
                                    lib.cancelSkillCheck()
                                end

                                return
                            end

                        
                            local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'}, {'e'})
                           

                            if not success then
                                lib.notify({
                                    description = 'He felt you were robbing him better catch him',
                                    duration = 5000,
                                    style = {
                                        backgroundColor = '#141517',
                                        color = '#C1C2C5',
                                        ['.description'] = {
                                          color = '#909296'
                                        },
                                        
                                    },
                                    icon = 'fa-solid fa-xmark',
                                    iconColor = '#C53030',
                                    iconAnimation = 'fade',
                                    alignIcon = 'center'
                                })
                                TaskWanderStandard(robped, 10.0, 20)
                                return
                            end

                            if not targetrobbed and success then
                                lib.progressCircle({
                                    duration = 5000,
                                    position = 'middle',
                                    useWhileDead = false,
                                    canCancel = false,
                                    disable = {
                                        sprint = true,
                                        move = true
                                    },
                                    anim = {
                                        dict = 'clothingtrousers',
                                        clip = 'check_out_b'
                                    },
                                })
                                lib.notify({
                                    title = 'Task',
                                    description = 'Good job deliver stolen item',
                                    duration = 5000,
                                    style = {
                                        backgroundColor = '#141517',
                                        color = '#C1C2C5',
                                        ['.description'] = {
                                          color = '#909296'
                                        },
                                        
                                    },
                                    icon = 'fa-solid fa-check',
                                    iconColor = '#2ECC71',
                                    iconAnimation = 'fade',
                                    alignIcon = 'center'
                                })
                                TriggerServerEvent('lnd-homicides:robbedped')
                                targetrobbed = true
                                workdone = true
                                janna()
                                Citizen.SetTimeout(5500, function ()
                                    deletepedandend()
                                end)
                            end
                        end
                        
                    }
                })
        end
    end
end