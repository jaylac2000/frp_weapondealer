Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = Config or {}
local StringCharset = {}
local NumberCharset = {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end
Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.EnableBlips = true
Config.RequiredReputationForMethLab = 15

Config.Dealers = {
    [1] = {
        ["name"] = "Bogdan",
        ["coords"] = {
            ["x"] = 87.09383, 
            ["y"] = -834.9842, 
            ["z"] = 31.06301,
        },
        ["time"] = {
            ["min"] = 0,
            ["max"] = 24,
        },
        ["products"] = {
            [1] = {
                name = "weapon_pistol",
                price = 750,
                amount = 1,
                info = {},
                type = "item",
                slot = 1,
                minrep = 1,
            },

            [2] = {
                name = "pistol_ammo",
                price = 45,
                amount = 10,
                info = {},
                type = "item",
                slot = 2,
                minrep = 25,
            },
            [3] = {
                name = "weapon_combatpistol",
                price = 1100,
                amount = 1,
                info = {},
                type = "item",
                slot = 3,
                minrep = 35,
            },
            
            [4] = {
                name = "weapon_microsmg",
                price = 1700,
                amount = 1,
                info = {},
                type = "item",
                slot = 4,
                minrep = 50,
            },
            [5] = {
                name = "smg_ammo",
                price = 120,
                amount = 10,
                info = {},
                type = "item",
                slot = 5,
                minrep = 50,
            },
            [6] = {
                name = "rifle_ammo",
                price = 420,
                amount = 10,
                info = {},
                type = "item",
                slot = 6,
                minrep = 90,
            },
            [7] = {
                name = "weapon_assaultrifle",
                price = 3500,
                amount = 1,
                info = {},
                type = "item",
                slot = 7,
                minrep = 90,
            },
            [8] = {
                name = "advancedlockpick",
                price = 500,
                amount = 5,
                info = {},
                type = "item",
                slot = 8,
                minrep = 20,
            },
            [9] = {
                name = "thermite",
                price = 1500,
                amount = 5,
                info = {},
                type = "item",
                slot = 9,
                minrep = 50,
            },
            [10] = {
                name = "electronickit",
                price = 3500,
                amount = 5,
                info = {},
                type = "item",
                slot = 10,
                minrep = 35,
            },
            [11] = {
                name = "trojan_usb",
                price = 500,
                amount = 5,
                info = {},
                type = "item",
                slot = 11,
                minrep = 30,
            },
            [12] = {
                name = "gatecrack",
                price = 1500,
                amount = 5,
                info = {},
                type = "item",
                slot = 12,
                minrep = 25,
            },

        },
    },
    [2] = {
        ["name"] = "Olov",
        ["coords"] = {
            ["x"] = -1108.57, 
            ["y"] = -1643.44, 
            ["z"] = 4.64, 
        },
        ["time"] = {
            ["min"] = 0, 
            ["max"] = 24,
        },
        ["products"] = {
            [1] = {
                name = "pistol_extendedclip",
                price = 440,
                amount = 1,
                info = {},
                type = "item",
                slot = 1,
                minrep = 25,
            },
            [2] = {
                name = "pistol_suppressor",
                price = 800,
                amount = 1,
                info = {},
                type = "item",
                slot = 2,
                minrep = 35,
            },
            [3] = {
                name = "smg_flashlight",
                price = 250,
                amount = 1,
                info = {},
                type = "item",
                slot = 3,
                minrep = 50,
            },
            [4] = {
                name = "smg_extendedclip",
                price = 540,
                amount = 1,
                info = {},
                type = "item",
                slot = 4,
                minrep = 55,
            },
            [5] = {
                name = "smg_suppressor",
                price = 1100,
                amount = 1,
                info = {},
                type = "item",
                slot = 5,
                minrep = 60,
            },
            [6] = {
                name = "smg_scope",
                price = 500,
                amount = 1,
                info = {},
                type = "item",
                slot = 6,
                minrep = 60,
            },
            [7] = {
                name = "rifle_extendedclip",
                price = 1300,
                amount = 1,
                info = {},
                type = "item",
                slot = 7,
                minrep = 90,
            },
            [8] = {
                name = "rifle_drummag",
                price = 1800,
                amount = 1,
                info = {},
                type = "item",
                slot = 8,
                minrep = 115,
            },
            [9] = {
                name = "advancedlockpick",
                price = 500,
                amount = 5,
                info = {},
                type = "item",
                slot = 9,
                minrep = 20,
            },
            [10] = {
                name = "thermite",
                price = 1500,
                amount = 5,
                info = {},
                type = "item",
                slot = 10,
                minrep = 50,
            },
            [11] = {
                name = "tablet",
                price = 500,
                amount = 5,
                info = {},
                type = "item",
                slot = 11,
                minrep = 15,
            },
            [12] = {
                name = "electronickit",
                price = 3500,
                amount = 5,
                info = {},
                type = "item",
                slot = 12,
                minrep = 35,
            },
        },
    },
}
Config.DeliveryLocations = {
    [1] = {
        ["label"] = "Bakgata",
        ["coords"] = {
            ["x"] = 367.3167,
            ["y"] = 351.3552,
            ["z"] = 103.3258,
        }
    },
    [2] = {
        ["label"] = "Tivoli",
        ["coords"] = {
            ["x"] = -1711.336,
            ["y"] = -1129.712,
            ["z"] = 13.15505,
        }
    },
    [3] = {
        ["label"] = "Resort",
        ["coords"] = {
            ["x"] = -1245.63,
            ["y"] = 376.21,
            ["z"] = 75.34,
        }
    },
    [4] = {
        ["label"] = "Bahamas Mamas",
        ["coords"] = {
            ["x"] = -1383.1,
            ["y"] = -639.99,
            ["z"] = 28.67,
        }
    },
}

Config.DeliveryItems = {
    [1] = {
        ["item"] = "explosive",
        ["minrep"] = 0,
    },
}

Config.Locations = {
    ["npc"] = {
        ["x"] = 87.09383, 
        ["y"] = -834.9842, 
        ["z"] = 31.06301, 
    },
    ["npc2"] = {
        ["x"] = -1108.57, 
        ["y"] = -1643.44, 
        ["z"] = 4.64,  
    }
}