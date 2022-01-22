QBCore = exports['qb-core']:GetCoreObject()
currentDealer = nil
knockingDoor = false

local dealerIsHome = false

local waitingDelivery = nil
local activeDelivery = nil

local interacting = false
local haskey = false
local refused = false

local deliveryTimeout = 0

local isHealingPerson = false
local healAnimDict = "mini@cpr@char_a@cpr_str"
local healAnim = "cpr_pumpchest"

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('qb-weapondealer:server:RequestConfig', function(DealerConfig)
        Config.Dealers = DealerConfig
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        QBCore.Functions.TriggerCallback('qb-ifruitstore:server:GetItem', function(hasItem)
            if hasItem then
                haskey = true
            end
        end, "labkey")
        if haskey then 
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        nearDealer = false

        for id, dealer in pairs(Config.Dealers) do
            local dealerDist = GetDistanceBetweenCoords(pos, dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"])

            if dealerDist <= 6 then
                nearDealer = true

                if dealerDist <= 1.5 and not isHealingPerson then
                    if not interacting then
                        if not dealerIsHome then
                            DrawText3D(dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"], '[E] Knock')
                            if IsControlJustPressed(0, Keys["E"]) then
                                TriggerEvent('qb-weathersync:client:EnableSync')
                                Citizen.Wait(1000)
                                currentDealer = id
                                knockDealerDoor()
                            end
                        elseif dealerIsHome then
                            if dealer["name"] == "Bogdan" and QBCore.Functions.GetPlayerData().metadata["wepdealerrep"] > Config.RequiredReputationForMethLab and not haskey and not refused then
                                DrawText3D(dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"], 'Do you wanna be Heisenberg? Hit [G] for getting lab key\n [E] to refuse')
                            else
                                DrawText3D(dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"], '[E] To buy / [G] Do assignments')
                            end

                            if IsControlJustPressed(0, Keys["E"]) then
                                if dealer["name"] == "Bogdan" and QBCore.Functions.GetPlayerData().metadata["wepdealerrep"] > Config.RequiredReputationForMethLab and not haskey and not refused then
                                    refused = true
                                    TriggerEvent("chatMessage", Config.Dealers[currentDealer]["name"], "normal", 'As you wish...')
                                else
                                    buyDealerStuff()
                                end
                            end

                            if IsControlJustPressed(0, Keys["G"]) then
                                if dealer["name"] == "Bogdan" and QBCore.Functions.GetPlayerData().metadata["wepdealerrep"] > Config.RequiredReputationForMethLab and not haskey and not refused then
                                    TriggerServerEvent("qb-methlab:givekey", source)
                                    hashkey = true
                                    interacting = false
                                    TriggerEvent("chatMessage", Config.Dealers[currentDealer]["name"], "normal", 'Ok bro, methlab is located at small village called Grapeseed, only two buldings from paint shop.. Enter it from behind.')
                                else
                                    if waitingDelivery == nil then
                                        TriggerEvent("chatMessage", Config.Dealers[currentDealer]["name"], "normal", 'Here you have the products, keep track of your email regarding where to deliver the goods!')
                                        requestDelivery()
                                        interacting = false
                                        dealerIsHome = false
                                    else
                                        TriggerEvent("chatMessage", Config.Dealers[currentDealer]["name"], "error", 'You still have an open delivery. What are you waiting for?')
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not nearDealer then
            dealerIsHome = false
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

function GetClosestPlayer()
    local ped = PlayerPedId()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(ped)

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

knockDealerDoor = function()
    local hours = GetClockHours()
    local min = Config.Dealers[currentDealer]["time"]["min"]
    local max = Config.Dealers[currentDealer]["time"]["max"]

    if min > max then 
        if hours > min or hours < max then
            knockDoorAnim(true)
            return
        else
            knockDoorAnim(false)
            return
        end
    elseif hours >= min and hours <= max then
        knockDoorAnim(true)
        return
    else
        knockDoorAnim(false)
        return
    end         
end

function buyDealerStuff()
    local repItems = {}
    repItems.label = Config.Dealers[currentDealer]["name"]
    repItems.items = {}
    repItems.slots = 30

    for k, v in pairs(Config.Dealers[currentDealer]["products"]) do
        if QBCore.Functions.GetPlayerData().metadata["wepdealerrep"] >= Config.Dealers[currentDealer]["products"][k].minrep then
            repItems.items[k] = Config.Dealers[currentDealer]["products"][k]
        end
    end

    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Dealer_"..Config.Dealers[currentDealer]["name"], repItems)
end

function knockDoorAnim(home)
    local knockAnimLib = "timetable@jimmy@doorknock@"
    local knockAnim = "knockdoor_idle"
    local PlayerPed = GetPlayerPed(-1)
    local myData = QBCore.Functions.GetPlayerData()

    if home then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "knock_door", 0.2)
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        dealerIsHome = true
        if Config.Dealers[currentDealer]["name"] == "Ouweheer" then
            TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "normal", 'Hi, what can I do for you?')
        elseif Config.Dealers[currentDealer]["name"] == "Fred" then
            dealerIsHome = false
            TriggerEvent("chatMessage", Config.Dealers[currentDealer]["name"], "normal", 'Unfortunately, I no longer do business...')
        else
            TriggerEvent("chatMessage", Config.Dealers[currentDealer]["name"], "normal", 'Da '..myData.charinfo.firstname..', What you want?')
        end
        -- knockTimeout()
    else
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "knock_door", 0.2)
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        QBCore.Functions.Notify('No one seems to be home..', 'error', 3500)
    end
end

RegisterNetEvent('qb-weapondealer:client:updateDealerItems')
AddEventHandler('qb-weapondealer:client:updateDealerItems', function(itemData, amount)
    TriggerServerEvent('qb-weapondealer:server:updateDealerItems', itemData, amount, currentDealer)
end)

RegisterNetEvent('qb-weapondealer:client:setDealerItems')
AddEventHandler('qb-weapondealer:client:setDealerItems', function(itemData, amount, dealer)
    Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount
end)

function requestDelivery()
    local location = math.random(1, #Config.DeliveryLocations)
    local amount = math.random(1, 3)
    local item = randomDeliveryItemOnRep()
    waitingDelivery = {
        ["coords"] = Config.DeliveryLocations[location]["coords"],
        ["locationLabel"] = Config.DeliveryLocations[location]["label"],
        ["amount"] = amount,
        ["dealer"] = currentDealer,
        ["itemData"] = Config.DeliveryItems[item]
    }
    QBCore.Functions.TriggerCallback('qb-weapondealer:giveDeliveryItems', function()
    end, amount)
    SetTimeout(7000, function()
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Dealers[currentDealer]["name"],
            subject = "Place of delivery",
            message = "Here is all the information about your delivery, <br>Place: "..waitingDelivery["locationLabel"].."<br>Goods: <br> "..amount.."x "..QBCore.Shared.Items[waitingDelivery["itemData"]["item"]]["label"].."<br><br> Make sure you are on time!",
            button = {
                enabled = true,
                buttonEvent = "qb-weapondealer:client:setLocation",
                buttonData = waitingDelivery
            }
        })
    end)
end

function randomDeliveryItemOnRep()
    local ped = GetPlayerPed(-1)
    local myRep = QBCore.Functions.GetPlayerData().metadata["wepdealerrep"]

    retval = nil

    for k, v in pairs(Config.DeliveryItems) do
        if Config.DeliveryItems[k]["minrep"] <= myRep then
            local availableItems = {}
            table.insert(availableItems, k)

            local item = math.random(1, #availableItems)

            retval = item
        end
    end
    return retval
end

function setMapBlip(x, y)
    SetNewWaypoint(x, y)
    QBCore.Functions.Notify('The route to the delivery point is indicated on your map.', 'success');
end

RegisterNetEvent('qb-weapondealer:client:setLocation')
AddEventHandler('qb-weapondealer:client:setLocation', function(locationData)
    if activeDelivery == nil then
        activeDelivery = locationData
    else
        setMapBlip(activeDelivery["coords"]["x"], activeDelivery["coords"]["y"])
        QBCore.Functions.Notify('You still have an active delivery...')
        return
    end

    deliveryTimeout = 300

    deliveryTimer()

    setMapBlip(activeDelivery["coords"]["x"], activeDelivery["coords"]["y"])

    Citizen.CreateThread(function()
        while true do

            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local inDeliveryRange = false

            if activeDelivery ~= nil then
                local dist = GetDistanceBetweenCoords(pos, activeDelivery["coords"]["x"], activeDelivery["coords"]["y"], activeDelivery["coords"]["z"])

                if dist < 15 then
                    inDeliveryRange = true
                    if dist < 1.5 then
                        DrawText3D(activeDelivery["coords"]["x"], activeDelivery["coords"]["y"], activeDelivery["coords"]["z"], '[E] '..activeDelivery["amount"]..'x '..QBCore.Shared.Items[activeDelivery["itemData"]["item"]]["label"]..' to deliver.')

                        if IsControlJustPressed(0, Keys["E"]) then
                            deliverStuff(activeDelivery)
                            activeDelivery = nil
                            waitingDelivery = nil
                            break
                        end
                    end
                end

                if not inDeliveryRange then
                    Citizen.Wait(1500)
                end
            else
                break
            end

            Citizen.Wait(3)
        end
    end)
end)

function deliveryTimer()
    Citizen.CreateThread(function()
        while true do

            if deliveryTimeout - 1 > 0 then
                deliveryTimeout = deliveryTimeout - 1
            else
                deliveryTimeout = 0
                break
            end

            Citizen.Wait(1000)
        end
    end)
end

function deliverStuff(activeDelivery)
    if deliveryTimeout > 0 then
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        Citizen.Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
        checkPedDistance()
        QBCore.Functions.Progressbar("work_dropbox", "Delivers products..", 3500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('qb-weapondealer:server:succesDelivery', activeDelivery, true)
        end, function() -- Cancel
            ClearPedTasks(GetPlayerPed(-1))
            QBCore.Functions.Notify("Canceled..", "error")
        end)
    else
        TriggerServerEvent('qb-weapondealer:server:succesDelivery', activeDelivery, false)
    end
    deliveryTimeout = 0
end

function checkPedDistance()
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            table.insert(PlayerPeds, ped)
        end
    end
    
    local closestPed, closestDistance = QBCore.Functions.GetClosestPed(coords, PlayerPeds)

    if closestDistance < 40 and closestPed ~= 0 then
        local callChance = math.random(1, 100)

        if callChance < 15 then
            doPoliceAlert()
        end
    end
end

function doPoliceAlert()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then 
        streetLabel = streetLabel .. " " .. street2
    end

    TriggerServerEvent('qb-weapondealer:server:callCops', streetLabel, pos)
end

RegisterNetEvent('qb-weapondealer:client:robberyCall')
AddEventHandler('qb-weapondealer:client:robberyCall', function(msg, streetLabel, coords)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
	TriggerEvent('rs-policealerts:client:AddPoliceAlert', {
		timeOut = 5000,
		alertTitle = "Suspected arms trade",
		coords = {
			x = coords.x,
			y = coords.y,
			z = coords.z,
		},
		details = {
			[1] = {
				icon = '<i class="fas fa-cannabis"></i>',
				detail = "Suspected arms trade",
			},
			[2] = {
				icon = '<i class="fas fa-globe-europe"></i>',
				detail = streetLabel,
			},
		},
		callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
	})
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 458)
    SetBlipColour(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, transG)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Arms deal")
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)

RegisterNetEvent('qb-weapondealer:client:executeEvents')
AddEventHandler('qb-weapondealer:client:executeEvents', function()
    TriggerServerEvent('qb-weapondealer:server:giveDeliveryItems', amount)
end)

RegisterNetEvent('qb-weapondealer:client:sendDeliveryMail')
AddEventHandler('qb-weapondealer:client:sendDeliveryMail', function(type, deliveryData)
    if type == 'perfect' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Delivery",
            message = "You did a great job! I hope to do business with you again soon ;)<br><br>Greetings, "..Config.Dealers[deliveryData["dealer"]]["name"]
        })
    elseif type == 'bad' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Delivery",
            message = "I'm getting a complaint about your delivery, do not let this happen again..."
        })
    elseif type == 'late' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Delivery",
            message = "You were not on time. You had more important things to do than business?"
        })
    end
end)