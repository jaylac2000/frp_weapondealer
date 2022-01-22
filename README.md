### FRP Weaponsdealer

- QBCore
- You do deliveries to earn "rep" and after X amount of rep you can buy weapons and attachments 
- Time of day (ingame controlled)

#### How to install
in qb-core-> Server -> player.lua add the following  <br>
`PlayerData.metadata["wepdealerrep"] = PlayerData.metadata["wepdealerrep"] ~= nil and PlayerData.metadata["wepdealerrep"] or 0`
