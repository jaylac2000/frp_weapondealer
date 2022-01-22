QBCore = exports['qb-core']:GetCoreObject()

-- Code

QBCore.Commands.Add("addrep", "Add Reputation to a Player", {{name="id", help="ID of player"}, {name="type", help="dealer/crafting/atcrafting/weapondealer"}, {name="amount", help="Amount of Reputation"}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    
    if Player ~= nil then 
        if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
            local x = tonumber(args[1])
            local y = args[2]
            local z = tonumber(args[3])

            if y == "dealer" then
                local newrep = Player.PlayerData.metadata["dealerrep"] + z
                Player.Functions.SetMetaData("dealerrep", newrep)
				TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", " has been banned for:")
                TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "You received reputation from admin - type of reputation: DEALER - your new reputation: ".. newrep .."")
            end
            if y == "crafting" then
                local newrep = Player.PlayerData.metadata["craftingrep"] + z
                Player.Functions.SetMetaData("craftingrep", newrep)
                TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "You received reputation from admin - type of reputation: CRAFTING - your new reputation: ".. newrep .."")
            end
            if y == "atcrafting" then
                local newrep  = Player.PlayerData.metadata["attachmentcraftingrep"]  + z
                Player.Functions.SetMetaData("attachmentcraftingrep", newrep)
                TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "You received reputation from admin - type of reputation: ATTACHMENT CRAFTING - your new reputation: ".. newrep .."")
            end
            if y == "weapondealer" then
                local newrep  = Player.PlayerData.metadata["wepdealerrep"]  + z
                Player.Functions.SetMetaData("wepdealerrep", newrep)
                TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "You received reputation from admin - type of reputation: WEAPON DEALER - your new reputation: ".. newrep .."")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Not every argument has been entered.")
        end
    else 
       TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not Online")
    end
end, "god")

QBCore.Commands.Add("removerep", "Remove Reputation to a Player", {{name="id", help="ID of player"}, {name="type", help="dealer/crafting/atcrafting/weapondealer"}, {name="amount", help="Amount of Reputation"}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    
    if Player ~= nil then 
        if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
            local x = tonumber(args[1])
            local y = args[2]
            local z = tonumber(args[3])

            if y == "dealer" then
                local newrep = Player.PlayerData.metadata["dealerrep"] - z
                Player.Functions.SetMetaData("dealerrep", newrep)
				TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", " has been banned for:")
                TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "You lost reputation from admin - type of reputation: DEALER - your new reputation: ".. newrep .."")
            end
            if y == "crafting" then
                local newrep = Player.PlayerData.metadata["craftingrep"] - z
                Player.Functions.SetMetaData("craftingrep", newrep)
                TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "You lost reputation from admin - type of reputation: CRAFTING - your new reputation: ".. newrep .."")
            end
            if y == "atcrafting" then
                local newrep  = Player.PlayerData.metadata["attachmentcraftingrep"]  - z
                Player.Functions.SetMetaData("attachmentcraftingrep", newrep)
                TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "You lost reputation from admin - type of reputation: ATTACHMENT CRAFTING - your new reputation: ".. newrep .."")
            end
            if y == "weapondealer" then
                local newrep  = Player.PlayerData.metadata["wepdealerrep"]  - z
                Player.Functions.SetMetaData("wepdealerrep", newrep)
                TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "You lost reputation from admin - type of reputation: WEAPON DEALER - your new reputation: ".. newrep .."")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Not every argument has been entered.")
        end
    else 
       TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not Online")
    end
end, "god")

QBCore.Commands.Add("reputation", "Check your reputation", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	local weapdealer = Player.PlayerData.metadata["wepdealerrep"]
	local attachment = Player.PlayerData.metadata["attachmentcraftingrep"]
	local crafting = Player.PlayerData.metadata["craftingrep"]
	local dealer = Player.PlayerData.metadata["dealerrep"]

	TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "Dealer reputation ".. dealer .."")
	TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "Crafting reputation ".. crafting .."")
	TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "Weapon Attachments reputation ".. attachment .."")
	TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "error", "Weapon Dealer reputation ".. weapdealer .."")
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Me", "Please be careful to not step on too many snails!"}
      })
end)