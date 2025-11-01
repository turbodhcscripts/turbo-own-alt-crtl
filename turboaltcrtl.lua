


local exe_name, exe_version = identifyexecutor()
local function home999() end
local function home888() end

if exe_name ~= "Wave Windows" then
    hookfunction(home888, home999)
    if isfunctionhooked(home888) == false then
        game.Players.LocalPlayer:Destroy()
        return LPH_CRASH()
    end
end 

local function check_env(env)
    for _, func in env do
        if type(func) ~= "function" then
            continue
        end

        local functionhook = isfunctionhooked(func)

        if functionhook then
            game.Players.LocalPlayer:Destroy()
            return LPH_CRASH()
        end
    end
end

check_env( getgenv() )
check_env( getrenv() )
--

local Lua_Fetch_Connections = getconnections
local Lua_Fetch_Upvalues = getupvalues
local Lua_Hook = hookfunction 
local Lua_Hook_Method = hookmetamethod
local Lua_Unhook = restorefunction
local Lua_Replace_Function = replaceclosure
local Lua_Set_Upvalue = setupvalue
local Lua_Clone_Function = clonefunction

local Game_RunService = game:GetService("RunService")
local Game_LogService = game:GetService("LogService")
local Game_LogService_MessageOut = Game_LogService.MessageOut

local String_Lower = string.lower
local Table_Find = table.find
local Get_Type = type

local Current_Connections = {};
local Hooked_Connections = {};

local function Test_Table(Table, Return_Type)
for TABLE_INDEX, TABLE_VALUE in Table do
    if type(TABLE_VALUE) == String_Lower(Return_Type) then
        return TABLE_VALUE, TABLE_INDEX
    end

    continue
end
end

local function Print_Table(Table)
table.foreach(Table, print)
end

if getgenv().DEBUG then
print("[auth.injected.live] Waiting...")
end

local good_check = 0

function auth_heart()
-- local avalible = pcall(function() return loadstring(game:HttpGet("https://auth.injected.live/" .. directory))() end)

-- if (not avalible or not game:HttpGet("https://auth.injected.live/" .. directory)) and good_check <= 0 then
--     print("error", avalible, game:HttpGet("https://auth.injected.live/" .. directory))
--     game.Players.LocalPlayer:Destroy()
--     return LPH_CRASH()
-- end

return true , true
end

function Lua_Common_Intercept(old, ...)
print(...)
return old(...)
end

function XVNP_L(CONNECTION)
local s, e = pcall(function()
    local OPENAC_TABLE = Lua_Fetch_Upvalues(CONNECTION.Function)[9]
    local OPENAC_FUNCTION = OPENAC_TABLE[1]
    local IGNORED_INDEX = {3, 12, 1, 11, 15, 8, 20, 18, 22}

    --[[
        3(Getfenv), 1(create thread), 12(Some thread function errors btw), 11( buffer (BANS YOU) ), 8(BXOR), 14(WRAP), 15(YIELD), 22(JUNK), 20(Setfenv), 18(Idk for now)
    ]]


    Lua_Set_Upvalue(OPENAC_FUNCTION, 14, function(...)
        return function(...)
            local args = {...}

            if type(args[1]) == "table" and args[1][1] then
                pcall(function()
                    if type(args[1][1]) == "userdata" then
                        args[1][1]:Disconnect()
                        args[1][2]:Disconnect()
                        args[1][3]:Disconnect()
                        args[1][4]:Disconnect()
                        --warn("[XVNP] DISCONNECTING CURRENT FUNCTIONS")
                    end

                    --Print_Table(args[1])
                end)
            end 
        end
    end)

    Lua_Set_Upvalue(OPENAC_FUNCTION, 1, function(...)
        task.wait(200)
    end)

    hookfunction(OPENAC_FUNCTION, function(...)
        --warn("[XVNP DEBUG]", ...)
        return {}
    end)
end)
end

local XVNP_LASTUPDATE = 0
local XVNP_UPDATEINTERVAL = 5

local XVNP_CONNECTIONSNIFFER;

XVNP_CONNECTIONSNIFFER = Game_RunService.RenderStepped:Connect(function()
if #Lua_Fetch_Connections(Game_LogService_MessageOut) >= 2 then
    --print("[XVNP] !Emulator overflow!")
    XVNP_CONNECTIONSNIFFER:Disconnect()
end

if tick() - XVNP_LASTUPDATE >= XVNP_UPDATEINTERVAL then
    XVNP_LASTUPDATE = tick() 

    local OpenAc_Connections = Lua_Fetch_Connections(Game_LogService_MessageOut)

    for _, CONNECTION in OpenAc_Connections do
        if not table.find(Current_Connections, CONNECTION) then
            table.insert(Current_Connections, CONNECTION)
            table.insert(Hooked_Connections, CONNECTION)

            XVNP_L(CONNECTION)
            
        end
    end
end
end)

local last_beat = 0
Game_RunService.RenderStepped:Connect(function()
if last_beat + 1 < tick() then
    last_beat = tick() + 1 

    local what, are = auth_heart()

    if not are or not what then
        if good_check <= 0 then
            game.Players.LocalPlayer:Destroy()
            return LPH_CRASH()
        else
            good_check -=1
        end
    else
        good_check += 1
    end

end
end)

if getgenv().DEBUG then
print("[auth.injected.live] Started Emulation Thread")
end


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:WaitForChild('MainEvent')
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local GroupService = game:GetService("GroupService")
local Lighting = game:GetService("Lighting")
local ChatService = game:GetService("Chat")
local HttpService = game:GetService("HttpService")

--Module scripts
local mainModule = require(ReplicatedStorage:WaitForChild("MainModule"))


--Wait for player to be added
while Players.LocalPlayer == nil do task.wait() end
if getgenv().scriptinject == true then error("Alt control Script is already executed") end
getgenv().scriptinject = true



--Consts
local PLAYER = Players.LocalPlayer
local MOUSE = PLAYER:GetMouse()
local DATA_FOLDER = PLAYER:WaitForChild("DataFolder")
local INFORMATION = DATA_FOLDER:WaitForChild("Information")
local INVENTORY = DATA_FOLDER:WaitForChild("Inventory")
local PLAYER_CREW = INFORMATION:FindFirstChild("Crew")
local PLAYER_CASH = PLAYER.DataFolder:WaitForChild("Currency")
local ORIGINAL_CASH_AMOUNT = PLAYER_CASH.Value
local REQUIRED_CHAR_PARTS = {
    ["Humanoid"] = true,
    ["HumanoidRootPart"] = true,
    ["UpperTorso"] = true,
    ["LowerTorso"] = true,
    ["Head"] = true,
}
local CASHIERS = workspace:WaitForChild("Cashiers")
local IGNORED = workspace:WaitForChild("Ignored")
local PLAYERS_FOLDER = workspace:WaitForChild("Players")
local ITEMS_DROP = IGNORED:WaitForChild("ItemsDrop")
local SHOP = IGNORED:WaitForChild("Shop")
local SHOPS = SHOP:GetChildren()
local SPAWN = IGNORED:WaitForChild("Spawn")
local LIGHTS = workspace:WaitForChild("Lights")
local MAP = workspace:WaitForChild("MAP")
local LOW_GFX_PARTS = {} -- [part] = originalMaterial
local MAIN_EVENT = ReplicatedStorage:WaitForChild("MainEvent")


local TextChatService = cloneref(game:GetService('TextChatService'))

local Chat = function(text)
    local text = tostring(text)
    TextChatService.TextChannels.RBXGeneral:SendAsync(text)
end



local ALT_SETUP_LOCATIONS_V2 = {
["bank"] = {
    [1] = Vector3.new(-387.25, 21.25, -333.5),
    [2] = Vector3.new(-374.75, 21.25, -333.5),
    [3] = Vector3.new(-361.75, 21.25, -333.5),
    [4] = Vector3.new(-387.25, 21.25, -320.5),
    [5] = Vector3.new(-374.75, 21.25, -320.5),
    [6] = Vector3.new(-361.75, 21.25, -320.5),
    [7] = Vector3.new(-387.25, 21.25, -307.5),
    [8] = Vector3.new(-375, 21.25, -307.5),
    [9] = Vector3.new(-361.75, 21.25, -307.5),
    [10] = Vector3.new(-387.25, 21.25, -294.5),
    [11] = Vector3.new(-375.25, 21.25, -293.5),
    [12] = Vector3.new(-361.75, 21.25, -293.5),
    [13] = Vector3.new(-387.25, 21.25, -281.5),
    [14] = Vector3.new(-374.75, 21.25, -281.5),
    [15] = Vector3.new(-361.75, 21.25, -281.5),
    [16] = Vector3.new(-387.25, 21.25, -269.5),
    },
["club2"] = {
    [1] = Vector3.new(-285.592, -6.208, -398.911),
    [2] = Vector3.new(-272.592, -6.208, -398.911),
    [3] = Vector3.new(-258.592, -6.208, -398.911),
    [4] = Vector3.new(-245.592, -6.208, -398.911),
    [5] = Vector3.new(-285.592, -6.208, -386.911),
    [6] = Vector3.new(-272.592, -6.208, -386.911),
    [7] = Vector3.new(-258.592, -6.208, -386.911),
    [8] = Vector3.new(-245.592, -6.208, -386.911),
    [9] = Vector3.new(-285.592, -6.208, -374.911),
    [10] = Vector3.new(-272.592, -6.208, -374.911),
    [11] = Vector3.new(-258.592, -6.208, -374.911),
    [12] = Vector3.new(-245.592, -6.208, -374.911),
    [13] = Vector3.new(-285.592, -6.208, -363.411),
    [14] = Vector3.new(-272.592, -6.208, -363.411),
    [15] = Vector3.new(-258.592, -6.208, -363.411),
    [16] = Vector3.new(-245.592, -6.208, -363.411),
    [17] = Vector3.new(-285.592, -6.208, -352.411),
    [18] = Vector3.new(-272.592, -6.208, -352.411)
},
    ["train"] = {
        [1] = Vector3.new(684.99, 34.1, -149),
        [2] = Vector3.new(674.99, 34.1, -149),
        [3] = Vector3.new(664.99, 34.1, -149),
        [4] = Vector3.new(654.99, 34.1, -149),
        [5] = Vector3.new(644.99, 34.1, -149),
        [6] = Vector3.new(634.99, 34.1, -149),
        [7] = Vector3.new(624.99, 34.1, -149),
        [8] = Vector3.new(614.99, 34.1, -149),
        [9] = Vector3.new(604.99, 34.1, -149),
        [10] = Vector3.new(596.45, 34.1, -143.06),
        [11] = Vector3.new(589.38, 34.1, -135.98),
        [12] = Vector3.new(582.31, 34.1, -128.91),
        [13] = Vector3.new(575.24, 34.1, -121.84),
        [14] = Vector3.new(568.17, 34.1, -114.77),
        [15] = Vector3.new(561.99, 34.1, -107),
        [16] = Vector3.new(561.99, 34.1, -97),
        [17] = Vector3.new(561.99, 34.1, -87),
        [18] = Vector3.new(561.99, 34.1, -77),
        [19] = Vector3.new(561.99, 34.1, -67),
        [20] = Vector3.new(561.99, 34.1, -57),
        [21] = Vector3.new(664.99, 47.1, -54),
        [22] = Vector3.new(652.99, 47.1, -54),
        [23] = Vector3.new(640.99, 47.1, -54),
        [24] = Vector3.new(628.99, 47.1, -54),
        [25] = Vector3.new(616.99, 47.1, -54),
    },
["jail"] = {
    [1] = Vector3.new(-341.25, 22.5, -39.75),
    [2] = Vector3.new(-332.25, 22.5, -39.75),
    [3] = Vector3.new(-323.25, 22.5, -39.75),
    [4] = Vector3.new(-315.25, 22.5, -39.75),
    [5] = Vector3.new(-341.25, 22.5, -33.75),
    [6] = Vector3.new(-332.25, 22.5, -33.75),
    [7] = Vector3.new(-322.25, 22.5, -33.75),
    [8] = Vector3.new(-314.812, 23.182, -33.744),
    [9] = Vector3.new(-341.25, 22.5, -27.75),
    [10] = Vector3.new(-332.25, 22.5, -27.75),
    [11] = Vector3.new(-322.478, 22.499, -27.104),
    [12] = Vector3.new(-314.054, 24.203, -26.925),
    [13] = Vector3.new(-341.25, 22.5, -20.75),
    [14] = Vector3.new(-332.25, 22.5, -20.75),
    [15] = Vector3.new(-322.25, 22.5, -21.2),
    [16] = Vector3.new(-314.25, 22.5, -20.65),
    [17] = Vector3.new(-341.25, 22.5, -12.75),
    [18] = Vector3.new(-332.25, 22.5, -12.75),
    [19] = Vector3.new(-322.25, 22.5, -12.75),
    [20] = Vector3.new(-314.25, 22.5, -12.75),
    [21] = Vector3.new(-341.25, 22.5, -3.75),
    [22] = Vector3.new(-332.25, 22.5, -3.75),
    [23] = Vector3.new(-321.25, 22.5, -3.75),
    [24] = Vector3.new(-314.25, 22.5, -3.75),
    [25] = Vector3.new(-341.25, 22.5, 4.25),
    },
["school"] = {
    [1] = Vector3.new(-662.625, 21.25, 221.25),
    [2] = Vector3.new(-649.625, 21.25, 221.25),
    [3] = Vector3.new(-636.625, 21.25, 221.25),
    [4] = Vector3.new(-624.625, 21.25, 221.25),
    [5] = Vector3.new(-611.625, 21.25, 222.25),
    [6] = Vector3.new(-599.625, 21.25, 222.25),
    [7] = Vector3.new(-586, 21.25, 221.25),
    [8] = Vector3.new(-574, 21.25, 221.25),
    [9] = Vector3.new(-662.625, 21.25, 211.1),
    [10] = Vector3.new(-649.625, 21.25, 211.1),
    [11] = Vector3.new(-623.625, 21.25, 212),
    [12] = Vector3.new(-613.625, 21.25, 212),
    [13] = Vector3.new(-600.625, 21.25, 212),
    [14] = Vector3.new(-586, 21.25, 212),
    [15] = Vector3.new(-574, 21.25, 212),
    [16] = Vector3.new(-662.625, 21.25, 202),
    [17] = Vector3.new(-649.625, 21.25, 202),
    [18] = Vector3.new(-636.625, 21.25, 202),
    [19] = Vector3.new(-623.625, 21.25, 202),
    [20] = Vector3.new(-612.625, 21.25, 202),
    [21] = Vector3.new(-600.625, 21.25, 203),
    [22] = Vector3.new(-587, 21.25, 203),
    [23] = Vector3.new(-573, 21.25, 203),
    [24] = Vector3.new(-562, 21.25, 221.25),
    [25] = Vector3.new(-562, 21.25, 211.5),
    },
["club3"] = {
    [1] = Vector3.new(-269.592, -6.208, -401.911),
    [2] = Vector3.new(-259.592, -6.208, -401.911),
    [3] = Vector3.new(-269.592, -6.208, -395.911),
    [4] = Vector3.new(-259.592, -6.208, -395.911),
    [5] = Vector3.new(-269.592, -6.208, -389.911),
    [6] = Vector3.new(-259.592, -6.208, -389.911),
    [7] = Vector3.new(-269.592, -6.208, -383.911),
    [8] = Vector3.new(-259.592, -6.208, -383.911),
    [9] = Vector3.new(-269.592, -6.208, -378.911),
    [10] = Vector3.new(-259.592, -6.208, -378.911),
    [11] = Vector3.new(-269.592, -6.208, -373.911),
    [12] = Vector3.new(-259.592, -6.208, -373.911),
    [13] = Vector3.new(-269.592, -6.208, -369.061),
    [14] = Vector3.new(-259.592, -6.208, -369.061),
    [15] = Vector3.new(-269.592, -6.208, -364.411),
    [16] = Vector3.new(-259.592, -6.208, -364.411),
    [17] = Vector3.new(-269.592, -6.208, -359.411),
    [18] = Vector3.new(-259.592, -6.208, -359.411),
},
    ["basketball"] = {
        [1] = Vector3.new(-873.01, 22.1, -518),
        [2] = Vector3.new(-896.01, 22.1, -518),
        [3] = Vector3.new(-919.01, 22.1, -518),
        [4] = Vector3.new(-942.01, 22.1, -518),
        [5] = Vector3.new(-965.01, 22.1, -518),
        [6] = Vector3.new(-988.01, 22.1, -518),
        [7] = Vector3.new(-873.01, 22.1, -503),
        [8] = Vector3.new(-896.01, 22.1, -503),
        [9] = Vector3.new(-919.01, 22.1, -503),
        [10] = Vector3.new(-942.01, 22.1, -503),
        [11] = Vector3.new(-965.01, 22.1, -503),
        [12] = Vector3.new(-988.01, 22.1, -503),
        [13] = Vector3.new(-873.01, 22.1, -488),
        [14] = Vector3.new(-896.01, 22.1, -488),
        [15] = Vector3.new(-919.01, 22.1, -488),
        [16] = Vector3.new(-942.01, 22.1, -488),
        [17] = Vector3.new(-965.01, 22.1, -488),
        [18] = Vector3.new(-988.01, 22.1, -488),
        [19] = Vector3.new(-873.01, 22.1, -473),
        [20] = Vector3.new(-896.01, 22.1, -473),
        [21] = Vector3.new(-919.01, 22.1, -473),
        [22] = Vector3.new(-942.01, 22.1, -473),
        [23] = Vector3.new(-965.01, 22.1, -473),
        [24] = Vector3.new(-988.01, 22.1, -473),
        [25] = Vector3.new(-873.01, 22.1, -458),
        [26] = Vector3.new(-896.01, 22.1, -458),
        [27] = Vector3.new(-919.01, 22.1, -458),
        [28] = Vector3.new(-942.01, 22.1, -458),
        [29] = Vector3.new(-965.01, 22.1, -458),
        [30] = Vector3.new(-988.01, 22.1, -458),
        [31] = Vector3.new(-873.01, 22.1, -443),
        [32] = Vector3.new(-896.01, 22.1, -443),
        [33] = Vector3.new(-919.01, 22.1, -443),
        [34] = Vector3.new(-942.01, 22.1, -443),
        [35] = Vector3.new(-965.01, 22.1, -443),
        [36] = Vector3.new(-988.01, 22.1, -443),
        [37] = Vector3.new(-863.55, 19.59, -473.71),
        [38] = Vector3.new(-863.55, 19.59, -490.71),
        [39] = Vector3.new(-866.55, 19.59, -482.21),
	},
    ["club"] = {
    [1] = Vector3.new(-288.592, -6.208, -404.911),
    [2] = Vector3.new(-273.592, -6.208, -404.911),
    [3] = Vector3.new(-258.592, -6.208, -404.911),
    [4] = Vector3.new(-244.592, -6.208, -404.911),
    [5] = Vector3.new(-288.592, -6.208, -393.911),
    [6] = Vector3.new(-273.592, -6.208, -393.911),
    [7] = Vector3.new(-258.592, -6.208, -393.911),
    [8] = Vector3.new(-244.592, -6.208, -393.911),
    [9] = Vector3.new(-287.592, -6.208, -382.911),
    [10] = Vector3.new(-274.592, -6.208, -382.911),
    [11] = Vector3.new(-259.592, -6.208, -382.911),
    [12] = Vector3.new(-244.592, -6.208, -381.911),
    [13] = Vector3.new(-286.592, -6.208, -370.161),
    [14] = Vector3.new(-274.592, -6.208, -369.611),
    [15] = Vector3.new(-259.592, -6.208, -370.161),
    [16] = Vector3.new(-244.592, -6.208, -369.611),
    [17] = Vector3.new(-286.592, -6.208, -360.411),
    [18] = Vector3.new(-274.592, -6.208, -360.411),
    [19] = Vector3.new(-259.592, -6.208, -360.411),
    [20] = Vector3.new(-244.592, -6.208, -359.411),
    [21] = Vector3.new(-286.592, -6.208, -350.411),
    [22] = Vector3.new(-274.592, -6.208, -350.411),
    [23] = Vector3.new(-259.592, -6.208, -350.411),
    [24] = Vector3.new(-245.592, -6.208, -350.411),
    [25] = Vector3.new(-267.592, -6.208, -350.911),
    },
    ["vault"] = {
    [1] = Vector3.new(-636.557, -31.119, -278.97),
    [2] = Vector3.new(-636.557, -31.119, -290.02),
    [3] = Vector3.new(-642.557, -31.103, -278.97),
    [4] = Vector3.new(-642.557, -31.103, -290.02),
    [5] = Vector3.new(-648.557, -31.087, -278.97),
    [6] = Vector3.new(-648.557, -31.087, -290.02),
    [7] = Vector3.new(-655.557, -31.068, -277.97),
    [8] = Vector3.new(-655.557, -31.068, -290.02),
    [9] = Vector3.new(-662.63, -31.049, -277.97),
    [10] = Vector3.new(-662.63, -31.049, -290.02),
    [11] = Vector3.new(-669.63, -31.03, -277.97),
    [12] = Vector3.new(-669.63, -31.03, -290.02),
    [13] = Vector3.new(-675.63, -31.014, -277.97),
    [14] = Vector3.new(-675.63, -31.014, -290.02),
    [15] = Vector3.new(-681.63, -30.998, -277.97),
    [16] = Vector3.new(-681.63, -30.998, -290.02),
    [17] = Vector3.new(-648.557, -31.087, -297.02),
    [18] = Vector3.new(-655.557, -31.068, -297.02),
    [19] = Vector3.new(-662.63, -31.049, -297.02),
    [20] = Vector3.new(-648.557, -31.087, -271.97),
    [21] = Vector3.new(-655.557, -31.068, -271.97),
    [22] = Vector3.new(-662.63, -31.049, -271.97),
    [23] = Vector3.new(-656.057, -31.066, -305.52),
    [24] = Vector3.new(-656.057, -31.067, -262.47),
    [25] = Vector3.new(-669.63, -31.03, -271.97),
    },
}

local ALT_SETUP_LOCATIONS_OG = {
    ["bank"] = Vector3.new(-389, 22, -373),
    ["club"] = Vector3.new(-291, -6, -405),
    ["train"] = Vector3.new(602, 49, -112),
    ["jail"] = Vector3.new(-312.25, 22.5, -37.25),
    ["school"] = Vector3.new(-609.625, 21.25, 190.5),
    ["bankroof"] = Vector3.new(-437.5, 41.5, -285.1),
    ["basketball"] = Vector3.new(-931.5, 27.6, -482.7),
}

local SETUP_PLATFORMS = {
    ["bank"] = {Size = Vector3.new(80, 1, 136), Position = Vector3.new(-380.755, 18.255, -285.5)},
    ["club"] = {Size = Vector3.new(167, 1, 177), Position = Vector3.new(-268.755, -9.495, -367.25)},
    ["train"] = {Size = Vector3.new(171, 1, 178), Position = Vector3.new(618.995, 31.255, -83.75)},
    ["jail"] = {Size = Vector3.new(171, 1, 178), Position = Vector3.new(-902.755, -36.245, 301)},
    ["school"] = {Size = Vector3.new(36.25, 1, 53.75), Position = Vector3.new(-504.38, 19.755, -284.875)},
    ["bankroof"] = {Size = Vector3.new(100.25, 1, 53.75), Position = Vector3.new(-473.13, 36.005, -284.875)},
    ["basketball"] = {Size = Vector3.new(160.25, 1, 107.5), Position = Vector3.new(-933.38, 18.505, -482.5)},
}

--Vars
getgenv().sendingMessage = false
local friendsCache = {} --[UserId] = true/false/nil
local markedPlayers = {} --[UserId] = true/false/nil
local equippedWeapons = {} --[player] = {"gunname" = true}
local crews = {
    -- [group id (string)] = 
            --.Name - crew name
            --.EmblemUrl (string) = - emblem url
            --.MemberCount (int) - number of members in the server
            --.Loaded = true/nil - whether or not crew data is finished loading
            --.Members = {
                --[playerName] (string) - member list
            --}
        --
}
local isOfficer = false -- is player an officer
local stomping = false -- is this player stomping or not?
local exploiters = {
    ["Swag Mode"] = {},
    ["Enclosed/Encrypt"] = {},
    ["RayX"] = {},
    ["Zapped"] = {},
    ["Pluto"] = {},
    ["BetterDaHood"] = {},
}
local currentHealth = {} -- [player] = currentHealth (int)
local hideCash = false
local joinNotifs = false
local purchasedWeapons = {} -- [character] = {["weaponName"] = true}

--variable settings
local exploiterCommand = ""
local autoUseExploitPremCommand = false
local lowGfx = true -- low gfx
local espMode = "Everyone"

--Gui
local PLAYER_GUI = PLAYER:WaitForChild("PlayerGui")
local CORE_GUI = game.CoreGui

local function countAltsInGame()
    local alts = getgenv().alts
    local count = 0

    -- Iterate through the list of alt IDs
    for _, altID in ipairs(alts) do
        -- Check if the player with the alt ID is in the game
        local player = game.Players:GetPlayerByUserId(altID)
        if player then
            -- If player is found, increment the count
            count = count + 1
        end
    end

    -- Return the count of alts in the game
    return count
end



--Functions
local function findPlayer(name)
	if name then
        --If they typed the name exactly, then return that
        if Players:FindFirstChild(name) then return Players[name] end

        --Otherwise search for player name match
		name = name:lower()

		for _, player in ipairs(Players:GetPlayers()) do
			if name == player.Name:lower():sub(1, #name) then
				return player
			end
		end
	end
	return nil
end



local function constructMessage(arguments, startingFromArg)
	if #arguments < startingFromArg then
		return nil
	end
	
	local message = ""
	for i,arg in pairs(arguments) do
		if i >= startingFromArg then
			if i == startingFromArg then
				message = (message..arg)
			else
				message = (message.." "..arg)
			end
		end
	end
	
	return message
end

local function cashToInt(stringValue)
	local noDollarSign = string.sub(stringValue, 2, #stringValue)
	local noComma = string.gsub(noDollarSign, ",", "")
	local toInt = tonumber(noComma)
	
	return toInt
end

local function countFloorCash()
    local totalFloorCashAmount2 = 0

    for _,v in pairs(workspace.Ignored.Drop:GetChildren()) do
        if v:IsA("Part") then
            local amount = cashToInt(v.BillboardGui.TextLabel.Text)
            --TotalFloorCash
            totalFloorCashAmount2 += amount
        end
    end

    return totalFloorCashAmount2
end

local function isCharacterLoaded(player)
    if player.Character then
        for partName, _ in pairs(REQUIRED_CHAR_PARTS) do
            if not player.Character:FindFirstChild(partName) then
                return false
            end
        end
        return true
    else
        return false
    end
end


local function itemCount(player, itemName) -- needs LPH_JIT_ULTRA, but idk how to do it
    if isCharacterLoaded(player) then
        local count = 0
        for _, v in ipairs(player.Backpack:GetChildren()) do
            if v.Name == itemName then
                count += 1
            end
        end
        for _, v in ipairs(player.Character:GetChildren()) do
            if v.Name == itemName then
                count += 1
            end
        end
        return count
    else
        return 0
    end
end

local function findNearestPlayer(position, playerToExclude)
	local found
	local last = math.huge
    for _, player in pairs(Players:GetPlayers()) do  -- needs LPH_JIT_ULTRA, but idk how to do it
        if (player.Character and player.Character:FindFirstChild("FULLY_LOADED_CHAR") and player.Character.BodyEffects["K.O"].Value ~= true and not playerToExclude) or player ~= playerToExclude then
            local distance = player:DistanceFromCharacter(position)
            if distance < last then
                found = player
                last = distance
            end
        end
    end
	return found
end


local altsCache = {} -- [userId] == true / nil
local function isAlt(userId)
    if altsCache[userId] == true then
        return true
    elseif altsCache[userId] == false then
        return false
    else
        for i, id in ipairs(getgenv().alts) do
            if userId == id then
                altsCache[userId] = true
                return true
            end
        end
        altsCache[userId] = false
        return false
    end
end

local function getAltNumber(userId)
    for i, id in ipairs(getgenv().alts) do
        if userId == id then
            return i
        end
    end
    return false
end

local function isFriend(player)
	if friendsCache[player] == true then
		return true
	else
		if player:IsFriendsWith(PLAYER.UserId) then
            friendsCache[player] = true
			return true
		else
			return false
		end
	end
end

local function isInCrew(player)
    local dataFolder = player:WaitForChild("DataFolder")
    local informationFolder = dataFolder:WaitForChild("Information")
    local playerCrew = informationFolder:FindFirstChild("Crew")
    if PLAYER_CREW and playerCrew and PLAYER_CREW.Value ~= "" and playerCrew.Value ~= "" and PLAYER_CREW.Value == playerCrew.Value then
        return true
    else
        return false
    end
end

local function roundNumber(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function commaValue(amount)
    task.wait()
    local formatted = tostring(amount)
    formatted = formatted:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if formatted:sub(1, 1) == "," then
        formatted = formatted:sub(2)
    end
    return formatted
end

local function calculateSecondsToDrop(amount)
    local seconds = math.floor(amount / 666.667 + 0.5)
    return seconds
end

local function Format(Int)
	return string.format("%02i", Int)
end

local function convertToHMS(Seconds)
	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return Format(Hours)..":"..Format(Minutes)..":"..Format(Seconds)
end

------------------------------------------------------------------------------------- ALT ACCOUNTS -------------------------------------------------------------------------------------
if isAlt(PLAYER.UserId) == true then
    --Setup

    hookfunction(game:GetService("UserInputService").GetFocusedTextBox, newcclosure(function(...)
        return 
    end))
    



    --game.CoreGui:ClearAllChildren()
    StarterGui:ClearAllChildren()
    PLAYER_GUI:ClearAllChildren()

    --AltGui (of 'ScreenGui' class)
	local AltGui = Instance.new("ScreenGui")
	AltGui.Name = "AltGui"
	AltGui.IgnoreGuiInset = true
	AltGui.DisplayOrder = 5
	AltGui.Parent = CORE_GUI
	--Create instances
	local Background = Instance.new("Frame")
	local BackgroundGdt = Instance.new("UIGradient")
	local Info = Instance.new("Frame")
	local DisplayName = Instance.new("TextLabel")
	local BetterDaHood = Instance.new("TextLabel")
	local Username = Instance.new("TextLabel")
	local UIListLayout = Instance.new("UIListLayout")
	local StartingCash = Instance.new("TextLabel")
	local CashGainedLost = Instance.new("TextLabel")
	local CurrentCash = Instance.new("TextLabel")
	local TimeRemainingText = Instance.new("TextLabel")
	local TimeRemaining = Instance.new("TextLabel")
	local TotalFloorCash = Instance.new("TextLabel")
	local RecountFloorCash = Instance.new("TextButton")
	local DestroyFloorCash = Instance.new("TextButton")
	local Options = Instance.new("Frame")
	local DropFrame = Instance.new("Frame")
	local DroppingTitle = Instance.new("TextLabel")
	local DropBtn = Instance.new("TextButton")
	local DropTime = Instance.new("TextLabel")
	local CashAuraFrame = Instance.new("Frame")
	local CashAuraTitle = Instance.new("TextLabel")
	local CashAuraBtn = Instance.new("TextButton")
	local FpsLockFrame = Instance.new("Frame")
	local FpsLockTitle = Instance.new("TextLabel")
	local FpsLockBox = Instance.new("TextBox")
	local Help = Instance.new("Frame")
	local HelpButton = Instance.new("TextButton")
	local HelpFrame = Instance.new("Frame")
	local HelpText = Instance.new("TextLabel")
    local Cursor = Instance.new("Frame")

		Background.Name = "Background"
		Background.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		Background.BackgroundColor3 = Color3.new(1, 1, 1)
		Background.Size = UDim2.new(1, 0, 1, 0)
		Background.Parent = AltGui
		BackgroundGdt.Name = "BackgroundGdt"
		BackgroundGdt.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),ColorSequenceKeypoint.new(1, Color3.new(0.176471, 0.176471, 0.176471)),}
		BackgroundGdt.Rotation = 290
		BackgroundGdt.Parent = Background
		Info.Name = "Info"
		Info.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		Info.AnchorPoint = Vector2.new(0.5, 0.5)
		Info.BackgroundTransparency = 0.949999988079071
		Info.Position = UDim2.new(0.5, 0, 0.4, 0)
		Info.BackgroundColor3 = Color3.new(1, 1, 1)
		Info.Size = UDim2.new(0.5625, 0, 0.5235, 0)
		Info.Parent = Background
		DisplayName.Name = "DisplayName"
		DisplayName.LayoutOrder = 1
		DisplayName.TextStrokeTransparency = 0.75
		DisplayName.Size = UDim2.new(1, 0, 0.25, 0)
		DisplayName.TextColor3 = Color3.new(1, 1, 1)
		DisplayName.TextXAlignment = Enum.TextXAlignment.Left
		DisplayName.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		DisplayName.Text = "Display Name"
		DisplayName.TextSize = 14
		DisplayName.Font = Enum.Font.SourceSans
		DisplayName.BackgroundTransparency = 1
		DisplayName.Position = UDim2.new(0, 0, 0.05, 0)
		DisplayName.TextScaled = true
		DisplayName.BackgroundColor3 = Color3.new(1, 1, 1)
		DisplayName.Parent = Info
		BetterDaHood.Name = "BetterDaHood"
		BetterDaHood.TextTransparency = 0.75
		BetterDaHood.TextStrokeTransparency = 0.8999999761581421
		BetterDaHood.Size = UDim2.new(1, 0, 0.05, 0)
		BetterDaHood.TextColor3 = Color3.new(1, 1, 1)
		BetterDaHood.TextXAlignment = Enum.TextXAlignment.Left
		BetterDaHood.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		BetterDaHood.Text = "Da Hood Scripts"
		BetterDaHood.TextSize = 14
		BetterDaHood.Font = Enum.Font.GothamBold
		BetterDaHood.BackgroundTransparency = 1
		BetterDaHood.TextScaled = true
		BetterDaHood.BackgroundColor3 = Color3.new(1, 1, 1)
		BetterDaHood.Parent = Info
		Username.Name = "Username"
		Username.LayoutOrder = 2
		Username.TextTransparency = 0.5
		Username.TextStrokeTransparency = 0.75
		Username.Size = UDim2.new(1, 0, 0.075, 0)
		Username.TextColor3 = Color3.new(1, 1, 1)
		Username.RichText = true
		Username.TextXAlignment = Enum.TextXAlignment.Left
		Username.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		Username.Text = "<i>@username</i>"
		Username.TextSize = 14
		Username.Font = Enum.Font.SourceSans
		Username.BackgroundTransparency = 1
		Username.Position = UDim2.new(0, 0, 0.3, 0)
		Username.TextScaled = true
		Username.BackgroundColor3 = Color3.new(1, 1, 1)
		Username.Parent = Info
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Parent = Info
		StartingCash.Name = "StartingCash"
		StartingCash.LayoutOrder = 3
		StartingCash.TextStrokeTransparency = 0.75
		StartingCash.Size = UDim2.new(1, 0, 0.1, 0)
		StartingCash.TextColor3 = Color3.new(1, 1, 1)
		StartingCash.RichText = true
		StartingCash.TextXAlignment = Enum.TextXAlignment.Left
		StartingCash.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		StartingCash.Text = "Joined with - <font color='rgb(0,255,0)'>$0</font>"
		StartingCash.TextSize = 14
		StartingCash.Font = Enum.Font.SourceSans
		StartingCash.BackgroundTransparency = 1
		StartingCash.Position = UDim2.new(0, 0, 0.3, 0)
		StartingCash.TextScaled = true
		StartingCash.BackgroundColor3 = Color3.new(1, 1, 1)
		StartingCash.Parent = Info
		CashGainedLost.Name = "CashGainedLost"
		CashGainedLost.LayoutOrder = 5
		CashGainedLost.TextStrokeTransparency = 0.75
		CashGainedLost.Size = UDim2.new(1, 0, 0.1, 0)
		CashGainedLost.TextColor3 = Color3.new(1, 1, 1)
		CashGainedLost.RichText = true
		CashGainedLost.TextXAlignment = Enum.TextXAlignment.Left
		CashGainedLost.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		CashGainedLost.Text = "Cash gained/lost since join - <font color='rgb(255,255,255)'>$0</font>"
		CashGainedLost.TextSize = 14
		CashGainedLost.Font = Enum.Font.SourceSans
		CashGainedLost.BackgroundTransparency = 1
		CashGainedLost.Position = UDim2.new(0, 0, 0.3, 0)
		CashGainedLost.TextScaled = true
		CashGainedLost.BackgroundColor3 = Color3.new(1, 1, 1)
		CashGainedLost.Parent = Info
		CurrentCash.Name = "CurrentCash"
		CurrentCash.LayoutOrder = 4
		CurrentCash.TextStrokeTransparency = 0.75
		CurrentCash.Size = UDim2.new(1, 0, 0.1, 0)
		CurrentCash.TextColor3 = Color3.new(1, 1, 1)
		CurrentCash.RichText = true
		CurrentCash.TextXAlignment = Enum.TextXAlignment.Left
		CurrentCash.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		CurrentCash.Text = "Cash - <font color='rgb(0,255,0)'>$0</font>"
		CurrentCash.TextSize = 14
		CurrentCash.Font = Enum.Font.SourceSans
		CurrentCash.BackgroundTransparency = 1
		CurrentCash.Position = UDim2.new(0, 0, 0.3, 0)
		CurrentCash.TextScaled = true
		CurrentCash.BackgroundColor3 = Color3.new(1, 1, 1)
		CurrentCash.Parent = Info
		TimeRemainingText.Name = "TimeRemainingText"
		TimeRemainingText.LayoutOrder = 8
		TimeRemainingText.TextStrokeTransparency = 0.75
		TimeRemainingText.Size = UDim2.new(1, 0, 0.1, 0)
		TimeRemainingText.TextColor3 = Color3.new(1, 1, 1)
		TimeRemainingText.RichText = true
		TimeRemainingText.TextXAlignment = Enum.TextXAlignment.Left
		TimeRemainingText.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		TimeRemainingText.Text = "ETR until empty -"
		TimeRemainingText.TextSize = 14
		TimeRemainingText.Font = Enum.Font.SourceSans
		TimeRemainingText.BackgroundTransparency = 1
		TimeRemainingText.Position = UDim2.new(0, 0, 0.3, 0)
		TimeRemainingText.TextScaled = true
		TimeRemainingText.BackgroundColor3 = Color3.new(1, 1, 1)
		TimeRemainingText.Parent = Info
		TimeRemaining.Name = "TimeRemaining"
		TimeRemaining.LayoutOrder = 9
		TimeRemaining.TextStrokeTransparency = 0.75
		TimeRemaining.Size = UDim2.new(1, 0, 0.15, 0)
		TimeRemaining.TextColor3 = Color3.new(1, 1, 1)
		TimeRemaining.TextXAlignment = Enum.TextXAlignment.Left
		TimeRemaining.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		TimeRemaining.Text = "00:00:00"
		TimeRemaining.TextSize = 14
		TimeRemaining.Font = Enum.Font.SourceSans
		TimeRemaining.BackgroundTransparency = 1
		TimeRemaining.Position = UDim2.new(0, 0, 0.3, 0)
		TimeRemaining.TextScaled = true
		TimeRemaining.BackgroundColor3 = Color3.new(1, 1, 1)
		TimeRemaining.Parent = Info
		TotalFloorCash.Name = "TotalFloorCash"
		TotalFloorCash.LayoutOrder = 7
		TotalFloorCash.TextStrokeTransparency = 0.75
		TotalFloorCash.Size = UDim2.new(1, 0, 0.1, 0)
		TotalFloorCash.TextColor3 = Color3.new(1, 1, 1)
		TotalFloorCash.RichText = true
		TotalFloorCash.TextXAlignment = Enum.TextXAlignment.Left
		TotalFloorCash.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		TotalFloorCash.Text = "Cash on the floor - <font color='rgb(0,255,0)'>$0</font>"
		TotalFloorCash.TextSize = 14
		TotalFloorCash.Font = Enum.Font.SourceSans
		TotalFloorCash.BackgroundTransparency = 1
		TotalFloorCash.Position = UDim2.new(0, 0, 0.3, 0)
		TotalFloorCash.TextScaled = true
		TotalFloorCash.BackgroundColor3 = Color3.new(1, 1, 1)
		TotalFloorCash.Parent = Info
		RecountFloorCash.Name = "RecountFloorCash"
		RecountFloorCash.TextStrokeTransparency = 0
		RecountFloorCash.AnchorPoint = Vector2.new(1, 0)
		RecountFloorCash.Size = UDim2.new(0.1, 0, 1, 0)
		RecountFloorCash.TextColor3 = Color3.new(1, 1, 1)
		RecountFloorCash.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		RecountFloorCash.Text = "Recount"
		RecountFloorCash.TextSize = 14
		RecountFloorCash.Font = Enum.Font.SourceSans
		RecountFloorCash.Position = UDim2.new(1, 0, 0, 0)
		RecountFloorCash.TextScaled = true
		RecountFloorCash.BackgroundColor3 = Color3.new(0, 0.533333, 1)
		RecountFloorCash.Parent = TotalFloorCash
		DestroyFloorCash.Name = "DestroyFloorCash"
		DestroyFloorCash.TextStrokeTransparency = 0
		DestroyFloorCash.AnchorPoint = Vector2.new(1, 0)
		DestroyFloorCash.Size = UDim2.new(0.1, 0, 1, 0)
		DestroyFloorCash.TextColor3 = Color3.new(1, 1, 1)
		DestroyFloorCash.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		DestroyFloorCash.Text = "Destroy cash (client side)"
		DestroyFloorCash.TextSize = 14
		DestroyFloorCash.Font = Enum.Font.SourceSans
		DestroyFloorCash.Position = UDim2.new(0.899, 0, 0, 0)
		DestroyFloorCash.TextScaled = true
		DestroyFloorCash.BackgroundColor3 = Color3.new(0.364706, 0.364706, 0.364706)
		DestroyFloorCash.Parent = TotalFloorCash
		Options.Name = "Options"
		Options.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		Options.AnchorPoint = Vector2.new(0.5, 0.5)
		Options.BackgroundTransparency = 0.949999988079071
		Options.Position = UDim2.new(0.5, 0, 0.8, 0)
		Options.BackgroundColor3 = Color3.new(1, 1, 1)
		Options.Size = UDim2.new(0.5, 0, 0.2, 0)
		Options.Parent = Background
		DropFrame.Name = "DropFrame"
		DropFrame.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		DropFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		DropFrame.BackgroundTransparency = 1
		DropFrame.Position = UDim2.new(0.25, 0, 0.5, 0)
		DropFrame.BackgroundColor3 = Color3.new(1, 1, 1)
		DropFrame.Size = UDim2.new(0.174, 0, 0.5, 0)
		DropFrame.Parent = Options
		DroppingTitle.Name = "DroppingTitle"
		DroppingTitle.TextStrokeTransparency = 0.75
		DroppingTitle.Size = UDim2.new(1, 0, 0.3, 0)
		DroppingTitle.TextColor3 = Color3.new(1, 1, 1)
		DroppingTitle.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		DroppingTitle.Text = "Dropping"
		DroppingTitle.TextSize = 14
		DroppingTitle.Font = Enum.Font.SourceSans
		DroppingTitle.BackgroundTransparency = 1
		DroppingTitle.TextScaled = true
		DroppingTitle.BackgroundColor3 = Color3.new(1, 1, 1)
		DroppingTitle.Parent = DropFrame
		DropBtn.Name = "DropBtn"
		DropBtn.TextStrokeTransparency = 0
		DropBtn.Size = UDim2.new(1, 0, 0.699, 0)
		DropBtn.TextColor3 = Color3.new(1, 1, 1)
		DropBtn.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		DropBtn.Text = "Off"
		DropBtn.TextSize = 14
		DropBtn.Font = Enum.Font.SourceSans
		DropBtn.Position = UDim2.new(0, 0, 0.3, 0)
		DropBtn.TextScaled = true
		DropBtn.BackgroundColor3 = Color3.new(1, 0, 0)
		DropBtn.Parent = DropFrame
		DropTime.Name = "DropTime"
		DropTime.TextStrokeTransparency = 0.75
		DropTime.Size = UDim2.new(1, 0, 0.3, 0)
		DropTime.TextColor3 = Color3.new(1, 1, 1)
		DropTime.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		DropTime.Text = "0"
		DropTime.Visible = false
		DropTime.TextSize = 14
		DropTime.Font = Enum.Font.SourceSans
		DropTime.BackgroundTransparency = 1
		DropTime.Position = UDim2.new(0, 0, 1, 0)
		DropTime.TextScaled = true
		DropTime.BackgroundColor3 = Color3.new(1, 1, 1)
		DropTime.Parent = DropFrame
		CashAuraFrame.Name = "CashAuraFrame"
		CashAuraFrame.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		CashAuraFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		CashAuraFrame.BackgroundTransparency = 1
		CashAuraFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		CashAuraFrame.BackgroundColor3 = Color3.new(1, 1, 1)
		CashAuraFrame.Size = UDim2.new(0.174, 0, 0.5, 0)
		CashAuraFrame.Parent = Options
		CashAuraTitle.Name = "CashAuraTitle"
		CashAuraTitle.TextStrokeTransparency = 0.75
		CashAuraTitle.Size = UDim2.new(1, 0, 0.3, 0)
		CashAuraTitle.TextColor3 = Color3.new(1, 1, 1)
		CashAuraTitle.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		CashAuraTitle.Text = "Cash Aura"
		CashAuraTitle.TextSize = 14
		CashAuraTitle.Font = Enum.Font.SourceSans
		CashAuraTitle.BackgroundTransparency = 1
		CashAuraTitle.TextScaled = true
		CashAuraTitle.BackgroundColor3 = Color3.new(1, 1, 1)
		CashAuraTitle.Parent = CashAuraFrame
		CashAuraBtn.Name = "CashAuraBtn"
		CashAuraBtn.TextStrokeTransparency = 0
		CashAuraBtn.Size = UDim2.new(1, 0, 0.699, 0)
		CashAuraBtn.TextColor3 = Color3.new(1, 1, 1)
		CashAuraBtn.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		CashAuraBtn.Text = "Off"
		CashAuraBtn.TextSize = 14
		CashAuraBtn.Font = Enum.Font.SourceSans
		CashAuraBtn.Position = UDim2.new(0, 0, 0.3, 0)
		CashAuraBtn.TextScaled = true
		CashAuraBtn.BackgroundColor3 = Color3.new(1, 0, 0)
		CashAuraBtn.Parent = CashAuraFrame
		FpsLockFrame.Name = "FpsLockFrame"
		FpsLockFrame.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		FpsLockFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		FpsLockFrame.BackgroundTransparency = 1
		FpsLockFrame.Position = UDim2.new(0.75, 0, 0.5, 0)
		FpsLockFrame.BackgroundColor3 = Color3.new(1, 1, 1)
		FpsLockFrame.Size = UDim2.new(0.174, 0, 0.5, 0)
		FpsLockFrame.Parent = Options
		FpsLockTitle.Name = "FpsLockTitle"
		FpsLockTitle.TextStrokeTransparency = 0.75
		FpsLockTitle.Size = UDim2.new(1, 0, 0.3, 0)
		FpsLockTitle.TextColor3 = Color3.new(1, 1, 1)
		FpsLockTitle.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		FpsLockTitle.Text = "FPS Lock"
		FpsLockTitle.TextSize = 14
		FpsLockTitle.Font = Enum.Font.SourceSans
		FpsLockTitle.BackgroundTransparency = 1
		FpsLockTitle.TextScaled = true
		FpsLockTitle.BackgroundColor3 = Color3.new(1, 1, 1)
		FpsLockTitle.Parent = FpsLockFrame
		FpsLockBox.Name = "FpsLockBox"
		FpsLockBox.TextStrokeTransparency = 0.75
		FpsLockBox.Size = UDim2.new(1, 0, 0.699, 0)
		FpsLockBox.TextColor3 = Color3.new(1, 1, 1)
		FpsLockBox.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		FpsLockBox.Text = "3"
		FpsLockBox.TextSize = 14
		FpsLockBox.Font = Enum.Font.SourceSans
		FpsLockBox.BackgroundTransparency = 0.800000011920929
		FpsLockBox.Position = UDim2.new(0, 0, 0.3, 0)
		FpsLockBox.ClearTextOnFocus = false
		FpsLockBox.TextScaled = true
		FpsLockBox.BackgroundColor3 = Color3.new(1, 1, 1)
		FpsLockBox.Parent = FpsLockFrame
		Help.Name = "Help"
		Help.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		Help.AnchorPoint = Vector2.new(0, 1)
		Help.BackgroundTransparency = 1
		Help.Position = UDim2.new(0, 0, 1, 0)
		Help.BackgroundColor3 = Color3.new(1, 1, 1)
		Help.Size = UDim2.new(0.25, 0, 0.5, 0)
		Help.Parent = Background
		HelpButton.Name = "HelpButton"
		HelpButton.TextStrokeTransparency = 0.75
		HelpButton.Size = UDim2.new(0.15, 0, 0.15, 0)
		HelpButton.TextColor3 = Color3.new(1, 1, 1)
		HelpButton.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		HelpButton.Text = "Help"
		HelpButton.TextSize = 14
		HelpButton.Font = Enum.Font.SourceSans
		HelpButton.BackgroundTransparency = 0.949999988079071
		HelpButton.Position = UDim2.new(0, 0, 0.85, 0)
		HelpButton.TextScaled = true
		HelpButton.BackgroundColor3 = Color3.new(1, 1, 1)
		HelpButton.Parent = Help
		HelpFrame.Name = "HelpFrame"
		HelpFrame.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		HelpFrame.Visible = false
		HelpFrame.AnchorPoint = Vector2.new(0, 1)
		HelpFrame.BackgroundTransparency = 0.949999988079071
		HelpFrame.Position = UDim2.new(0, 0, 0.85, 0)
		HelpFrame.BackgroundColor3 = Color3.new(1, 1, 1)
		HelpFrame.Size = UDim2.new(1, 0, 0.6, 0)
		HelpFrame.Parent = Help
		HelpText.Name = "HelpText"
		HelpText.TextTransparency = 0.25
		HelpText.TextStrokeTransparency = 0.8999999761581421
		HelpText.Size = UDim2.new(1, 0, 1, 0)
		HelpText.TextColor3 = Color3.new(1, 1, 1)
		HelpText.TextXAlignment = Enum.TextXAlignment.Left
		HelpText.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
		HelpText.Text = "You are seeing this screen because it saves CPU usage. Connect to the server on your main account to control this and any other alts."
		HelpText.TextSize = 14
		HelpText.Font = Enum.Font.SourceSans
		HelpText.BackgroundTransparency = 1
		HelpText.TextYAlignment = Enum.TextYAlignment.Top
		HelpText.TextScaled = true
		HelpText.BackgroundColor3 = Color3.new(1, 1, 1)
		HelpText.Parent = HelpFrame
        Cursor.Name = "Cursor"
        Cursor.LayoutOrder = 1
        Cursor.BorderColor3 = Color3.new(0, 0, 0)
        Cursor.Visible = false
        Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
        Cursor.BackgroundColor3 = Color3.new(0.333333, 0.333333, 0.333333)
        Cursor.BorderSizePixel = 0
        Cursor.Size = UDim2.new(0, 10, 0, 10)
        Cursor.Parent = Background
        local corneraa = Instance.new("UICorner")
        corneraa.CornerRadius = UDim.new(0.5, 0)  -- This makes it a circle
        corneraa.Parent = Cursor
		--Secondary instances
		local secondaryInsts = {{["ClassName"] = "UICorner", ["Parent"] = RecountFloorCash, ["Properties"] = {}},{["ClassName"] = "UICorner", ["Parent"] = DestroyFloorCash, ["Properties"] = {}},{["ClassName"] = "UICorner", ["Parent"] = Info,["Parent"] = Cursor, ["Properties"] = {["CornerRadius"] = UDim.new(0.05, 0),}},{["ClassName"] = "UICorner", ["Parent"] = Options, ["Properties"] = {["CornerRadius"] = UDim.new(0.05, 0),}},{["ClassName"] = "UICorner", ["Parent"] = DropBtn, ["Properties"] = {}},{["ClassName"] = "UICorner", ["Parent"] = CashAuraBtn, ["Properties"] = {}},{["ClassName"] = "UICorner", ["Properties"] = {}},{["ClassName"] = "UICorner", ["Properties"] = {["CornerRadius"] = UDim.new(0.05, 0),}},}
		for _, instInfo in ipairs(secondaryInsts) do
			local inst = Instance.new(instInfo.ClassName)
			for propertyName, value in pairs(instInfo.Properties) do
				inst[propertyName] = value
			end
			inst.Parent = instInfo.Parent
		end

    --
    --
    --Create manual control Gui
    local ManualGui = Instance.new("ScreenGui")
    local UICorner = Instance.new("UICorner")

    ManualGui.Name = "ManualGui"
    ManualGui.Parent = CORE_GUI
    ManualGui.DisplayOrder = 1
    ManualGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local cursorConnection
    local UserInputService = game:GetService("UserInputService")

    Cursor.Visible = true
	cursorConnection = RunService.PreRender:Connect(function()
		local mouseLocation = UserInputService:GetMouseLocation()
		Cursor.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y)
	end)
    --Vars
    local playerOldPosition
    local cleanupConnections = {} -- [character] = cleanupConnection
    local loopkillToggle = false
    local destroyCash = false
    local dropToggle = false

    --Create feetPlatform (parent it to workspace after optimisation is complete
    local feetPlatform = Instance.new("Part")
    feetPlatform.Anchored = true
    feetPlatform.Position = Vector3.new(0, 0, 0)
    feetPlatform.Size = Vector3.new(5, 0.5, 5)

    --Functions
    local function capFps(amount)
        if not amount then amount = 3 end
        FpsLockBox.Text = amount

        --RunService:setThrottleFramerateEnabled(true)
        setfpscap(amount)
    end
    local function uncapFps(amount)
        if not amount then amount = 30 end
        FpsLockBox.Text = amount

        --RunService:setThrottleFramerateEnabled(false)
        setfpscap(amount)
    end

    local cleanedItems = {}
    local function cleanupItem(item)
        if cleanedItems[item] == nil and item:IsA("Tool") then
            task.wait(2)
            for _, descendant in ipairs(item:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.Transparency = 1
                    descendant.Material = Enum.Material.SmoothPlastic
                    if descendant:IsA("MeshPart") then
                        descendant.MeshId = ""
                        descendant.TextureID = ""
                    end
                elseif descendant:IsA("Decal") then
                    descendant.Transparency = 1
                elseif descendant:IsA("BillboardGui") then
                    descendant.Enabled = false
                elseif descendant:IsA("TextLabel") then
                    descendant.Visible = false
                elseif descendant:IsA("Sound") then
                    descendant.SoundId = ""
                elseif descendant:IsA("Mesh") then
                    descendant.MeshId = ""
                    descendant.TextureID = ""
                end
            end
            cleanedItems[item] = true
        end


    end
    local character1 = game.Players.LocalPlayer.Character

    
    local function teleport(cframeLocation)
        PLAYER.Character.HumanoidRootPart.CFrame = cframeLocation
        feetPlatform.Position = PLAYER.Character.HumanoidRootPart.Position + Vector3.new(0, -3, 0)
    end


    local function countAltsInGame()
        local alts = getgenv().alts
        local count = 0

        -- Iterate through the list of alt IDs
        for _, altID in ipairs(alts) do
            -- Check if the player with the alt ID is in the game
            local player = game.Players:GetPlayerByUserId(altID)
            if player then
                -- If player is found, increment the count
                count = count + 1
            end
        end

        -- Return the count of alts in the game
        return count
    end
    --Alt commands
    local altCommands = {}
    --local crouchAnim = PLAYER.Character.Humanoid:LoadAnimation(game.ReplicatedStorage.ClientAnimations.Block)
    altCommands.drop = function(player, args)
        if DropBtn.Text == "On" then
            MAIN_EVENT:FireServer("Block", false) -- (doesn't work if stuff in IGNORED is destroyed idk why)
            Chat("Stopped Dropping")
            DropBtn.Text = "Off"
            DropBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        else
            MAIN_EVENT:FireServer("Block", true)
            Chat("Started Dropping")
            DropBtn.Text = "On"
            DropBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end

        dropToggle = not dropToggle

        task.spawn(function()


            while dropToggle == true do --currency
                MAIN_EVENT:FireServer("DropMoney", 15000)
                DropTime.Visible = true
                for count = 15, 1, -1 do
                    if dropToggle == true then
                        DropTime.Text = count.."s"
                        task.wait(1)
                    else
                        break
                    end
                end
                task.wait(0.15)
            end
            DropTime.Visible = false
            DropBtn.Text = "Off"
            DropBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

            MAIN_EVENT:FireServer("Block", false) -- (doesn't work if stuff in IGNORED is destroyed idk why)
        end)
    end

    local currencyPostFixes = {
        ["k"] = 1000,
        ["m"] = 1000000,
        ["b"] = 1000000000,
    }
    
    local cdrop_stop = false

    altCommands.cdrop = function(player, args)
        local amountString = args[1]
        local limit = tonumber(amountString)
        if not limit then
            for postFix, value in pairs(currencyPostFixes) do
                if string.find(amountString, postFix) then
                    local rawNumberString = string.gsub(amountString, postFix, "")
                    local amountNumber = tonumber(rawNumberString)
                    limit = amountNumber * value
                    break
                end
            end
        end
    
        if limit then
            numberOfAltsInGame = countAltsInGame() 
            targetdrop = limit / numberOfAltsInGame
            timestodrop = targetdrop / 12750 
            roundedTimestoDrop = math.ceil(timestodrop)
            Chat("Started dropping " .. tostring(limit))
            
            for i = 1, roundedTimestoDrop do
                if cdrop_stop == true then
                    cdrop_stop = false
                    return
                end
                
                MAIN_EVENT:FireServer("DropMoney", 15000)
                wait(15.5)
            end
    
            dropToggle = false
            Chat("Finished dropping " .. tostring(limit))
        end
    end
    
    
    

    altCommands.dropped = function(player, args)
        Chat("Cash on floor: $"..commaValue(countFloorCash()))
    end


    altCommands.aura = function(player, args)
  
            if CashAuraBtn.Text == "Off" then
                CashAuraBtn.Text = "On"
                CashAuraBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

                Chat("CashAura Turned On!")
    
                task.spawn(function()
                    while CashAuraBtn.Text == "On" do
                        for _,v in ipairs(workspace.Ignored.Drop:GetChildren()) do
                            if v:IsA("Part") and PLAYER:DistanceFromCharacter(v.Position) < 12 then
                                fireclickdetector(v.ClickDetector)
                                task.wait(0.1)
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            elseif CashAuraBtn.Text == "On" then
                CashAuraBtn.Text = "Off"
                CashAuraBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
    end

    altCommands.dupefor = function(player, args)
        local playerToDupeFor = findPlayer(args[1])

        if playerToDupeFor then
            if PLAYER == playerToDupeFor then
                altCommands.aura(nil, {PLAYER.Name})
            else
                teleport(CFrame.new(playerToDupeFor.Character.HumanoidRootPart.Position + Vector3.new(math.random(70) / 10 - 3.5, -5, math.random(70) / 10 - 3.5)))
                altCommands.drop()
            end
        end
    end

    altCommands.redeem = function(player, args)
        local code = tostring(args[1])

        if code then
            MAIN_EVENT:FireServer("EnterPromoCode", code)
        end
    end

    altCommands.stop = function(player, args)
        dropToggle = false
        cdrop_stop = true
        CashAuraBtn.Text = "Off"
        CashAuraBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

        Chat("Stopped")

        loopkillToggle = false
    end

    altCommands.destroycash = function(player, args)
            for _,v in ipairs(IGNORED.Drop:GetChildren()) do
                if v:IsA("Part") then
                    v:Destroy()
                end
            end
        destroyCash = true
        DestroyFloorCash.Visible = false
        RecountFloorCash.Visible = false
        TotalFloorCash.Text = "Cash on the floor - <font color='rgb(0,255,0)'>N/A</font>"
        Chat("Cash Destroyed")
    end

    altCommands.setup = function(player, args)
        local locationName = tostring(args[1]) -- tostring incase nil
        local ogPlacement = tostring(args[2]) == "og" and true or false

        if not ogPlacement then
            while not isCharacterLoaded(PLAYER) do task.wait() end
            local altNumber = getAltNumber(PLAYER.UserId)
            teleport(CFrame.new(ALT_SETUP_LOCATIONS_V2[locationName][altNumber]))
        elseif ogPlacement == true then
            if ALT_SETUP_LOCATIONS_OG[locationName] then
                while not isCharacterLoaded(PLAYER) do task.wait() end
                local initialPosition = ALT_SETUP_LOCATIONS_OG[locationName]
                local altNumber = getAltNumber(PLAYER.UserId)

                if altNumber > 9 then
                    local firstDigit = tonumber(string.sub(tostring(altNumber), 1, 1))
                    local lastDigit = math.floor(altNumber%10)
        
                    teleport(CFrame.new(initialPosition + Vector3.new((firstDigit*10) / 2, 0, (lastDigit*10) / 2)))
                else
                    local lastDigit = math.floor(altNumber%10)
    
                    teleport(CFrame.new(initialPosition + Vector3.new(0, 0, (lastDigit*10) / 2)))
                end
            elseif locationName == "host" then
                teleport(player.Character.HumanoidRootPart.CFrame)
            end
        end
    end

    altCommands.freeze = function(player, args)
        local playerToFreeze = findPlayer(args[1])

        if playerToFreeze == PLAYER or args[1] == nil then
            PLAYER.Character.HumanoidRootPart.Anchored = true
        end
    end

    altCommands.unfreeze = function(player, args)
        local playerToFreeze = findPlayer(args[1])

        if playerToFreeze == PLAYER or args[1] == nil then
            PLAYER.Character.HumanoidRootPart.Anchored = false
        end
    end

    local player2 = game.Players.LocalPlayer
    local backpack = player2.Backpack
    local character2 = player2.Character or player2.CharacterAdded:Wait() 
altCommands.wallet = function(player, args)
    print(player, args)

    local character = player.Character
    if not character then return end

    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end

    -- Move all tools (except wallet) from character to backpack
    for _, v in pairs(character:GetChildren()) do
        if v:IsA("Tool") and v.Name ~= "[Wallet]" then
            v.Parent = backpack
        end
    end

    local walletInBackpack = backpack:FindFirstChild("[Wallet]")
    local walletInCharacter = character:FindFirstChild("[Wallet]")

    -- Toggle wallet equip
    if walletInBackpack then
        walletInBackpack.Parent = character  -- Equip
    elseif walletInCharacter then
        walletInCharacter.Parent = backpack  -- Unequip
    end
end


    local advertising = false
    altCommands.advert = function(player, args)
        local message = constructMessage(args, 1)

        if message then
            advertising = not advertising
            task.spawn(function()
                while advertising == true do
                    --Players:Chat(message)
                    Chat(message)
                    task.wait(10)
                end
            end)
        end
    end

    altCommands.animation = function(player, args)
            local message = constructMessage(args, 1)
            
            for _, animation in PLAYER.Character.Humanoid:GetPlayingAnimationTracks() do
                PLAYER.Character.HumanoidRootPart.Anchored = false
                animation:Stop()
            end
            if message == "fly" then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://13850660986"

                local loadedanimation = PLAYER.Character.Humanoid:LoadAnimation(animation)
                loadedanimation:Play()
                PLAYER.Character.HumanoidRootPart.Anchored = true
            elseif message == "sturdy" then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://11710524717"

                local loadedanimation = PLAYER.Character.Humanoid:LoadAnimation(animation)
                loadedanimation:Play()
                PLAYER.Character.HumanoidRootPart.Anchored = true
            elseif message == "rossy" then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://1171052744"

                local loadedanimation = PLAYER.Character.Humanoid:LoadAnimation(animation)
                PLAYER.Character.HumanoidRootPart.Anchored = true
                loadedanimation:Play()
                PLAYER.Character.HumanoidRootPart.Anchored = true
            elseif message == "griddy" then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://11710529220"

                local loadedanimation = PLAYER.Character.Humanoid:LoadAnimation(animation)
                loadedanimation:Play()
                PLAYER.Character.HumanoidRootPart.Anchored = true
            elseif message == "tpose" then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://11710524200"

                local loadedanimation = PLAYER.Character.Humanoid:LoadAnimation(animation)
                loadedanimation:Play()
                PLAYER.Character.HumanoidRootPart.Anchored = true
            elseif message == "speed" then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://11710541744"

                local loadedanimation = PLAYER.Character.Humanoid:LoadAnimation(animation)
                loadedanimation:Play()
                PLAYER.Character.HumanoidRootPart.Anchored = true
            end
    end



    altCommands.say = function(player, args)
        local message = constructMessage(args, 1)

        if message then
            Chat(message)
        end
    end

    altCommands.joincrew = function(player, args)
        local crewId = tonumber(args[1])

        if crewId then
            MAIN_EVENT:FireServer("JoinCrew", crewId)
        else
            local crewId = GroupService:GetGroupsAsync(PLAYER.UserId)[1].Id
            MAIN_EVENT:FireServer("JoinCrew", crewId)
        end
    end


    altCommands.airlock = function(player, args)
        teleport(CFrame.new(PLAYER.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)))
    end

    altCommands.hide = function(player, args)
        teleport(CFrame.new(PLAYER.Character.HumanoidRootPart.Position + Vector3.new(0, -6.5, 0)))
    end

    altCommands.line = function(player, args)
        teleport(CFrame.new(player.Character.HumanoidRootPart.Position + Vector3.new(getAltNumber(PLAYER.UserId)*2 - 1, 0, 0)))
    end

    altCommands.hidecash = function(player, args)
        if args[1] then
            if args[1] == "on" then
                hideCash = true
            elseif args[1] == "off" then
                hideCash = false
            end
        else
            hideCash = not hideCash
        end

            if hideCash == true then
                for _, v in pairs(IGNORED.Drop:GetChildren()) do
                    if v:IsA("Part") then
                        if v:FindFirstChild("Decal") then
                            v.Decal:Destroy()
                            v.Decal:Destroy()
                        end
                        v.BillboardGui.Enabled = false
                        v.Transparency = 1
                    end
                end
            else
                for _, v in pairs(IGNORED.Drop:GetChildren()) do
                    if v:IsA("Part") then
                        v.BillboardGui.Enabled = true
                        v.Transparency = 0
                    end
                end
            end
    end



    altCommands.dupefor = function(player, args)
        local playerToDupeFor
        if args[1] == nil or args[1] == "" then
            playerToDupeFor = player
        else
            playerToDupeFor = findPlayer(args[1])
        end

        if playerToDupeFor then
            if PLAYER == playerToDupeFor then
                altCommands.aura(nil, {PLAYER.Name})
            else
                teleport(CFrame.new(playerToDupeFor.Character.HumanoidRootPart.Position + Vector3.new(math.random(70) / 10 - 3.5, -5, math.random(70) / 10 - 3.5)))
                altCommands.drop()
            end
        end
    end



    altCommands.circle = function(player, args)
        local distance = tonumber(args[1])
        local alts = getgenv().alts  -- Fetch the alts from getgenv()
    
        local list = {}
        -- Use getgenv().alts instead of _G.configuration.accounts.ids
        for _, altId in ipairs(alts) do
            for _, p in ipairs(Players:GetPlayers()) do
                if p.UserId == altId then
                    table.insert(list, p.UserId)
                end
            end
        end
    
        -- Calculate the teleport positions based on the alts' positions
        local teleportsetup = (CFrame.new(player.Character.HumanoidRootPart.Position) 
                                   * CFrame.Angles(0, math.rad(360 / #list) * table.find(list, game.Players.LocalPlayer.UserId), 0) 
                                   * CFrame.new(0, 0, distance))
        teleport(teleportsetup)
    end
    
    altCommands.tower = function(player, args)
        -- Fetch the alts from getgenv()
        local alts = getgenv().alts
    
        -- Create a list to hold the actual player objects (not just UserId)
        local list = {}
    
        -- Populate the list with the players from the alts list
        for _, altId in ipairs(alts) do
            for _, p in ipairs(Players:GetPlayers()) do
                if p.UserId == altId then
                    table.insert(list, p)  -- Insert the player object, not just the UserId
                end
            end
        end
    
        -- Set the starting position (right on top of the local player's head)
        local basePosition = player.Character.HumanoidRootPart.Position
        local playerHeight = player.Character.Humanoid.HipHeight  -- Height of the local player's character
        local spacing = playerHeight + 0.5  -- Slightly adjust to ensure no gaps (you can change 0.5)
    
        -- Start with the local player first, their position is the base of the stack
        local currentPosition = basePosition + Vector3.new(0, playerHeight, 0)  -- Start right on top of the player's head
    
        -- Iterate through the list of alts and stack them
        for _, alt in ipairs(list) do
            -- Calculate new position for each alt, stacked right on top of the previous one
            local newPosition = currentPosition + Vector3.new(0, spacing, 0)
            
            -- Only the local player teleports themselves, so each alt teleports relative to the local player's position
            if alt == PLAYER then
                teleport(CFrame.new(newPosition))  -- Teleport the local player
            end
    
            -- Update the position for the next player in the tower
            currentPosition = newPosition
        end
    end
    
    




    --Connect and setup alt ui
    --Display name
    DisplayName.Text = PLAYER.DisplayName
    --Username
    Username.Text = "<i>@"..PLAYER.Name.."</i>"
    --CurrentCash
    CurrentCash.Text = "Cash - <font color='rgb(0,255,0)'>$"..commaValue(PLAYER_CASH.Value).."</font>"
    --StartingCash
    StartingCash.Text = "Joined with - <font color='rgb(0,255,0)'>$"..commaValue(ORIGINAL_CASH_AMOUNT).."</font>"
    --TimeRemaining
    TimeRemaining.Text = convertToHMS(calculateSecondsToDrop(PLAYER_CASH.Value))

    --For already dropped cash
    TotalFloorCash.Text = "Cash on the floor - <font color='rgb(0,255,0)'>$"..commaValue(countFloorCash()).."</font>"

    --Connections
    --Cash added
    IGNORED.Drop.ChildAdded:Connect(function(child)
        if child:IsA("Part") then
            task.wait(5)
            child.Transparency = 1
            child:WaitForChild("Decal"):Destroy()
            child:WaitForChild("Decal"):Destroy()
            child:WaitForChild("BillboardGui").Enabled = false
            if destroyCash == true and child.Parent ~= nil then
                child:Destroy()
            end
        end
    end)

    --Player cash changed
    PLAYER_CASH.Changed:Connect(function(newValue)
        --CurrentCash
        CurrentCash.Text = "Cash - <font color='rgb(0,255,0)'>$"..commaValue(newValue).."</font>"
        --CashGainedLost
        local cashDifference = newValue - ORIGINAL_CASH_AMOUNT
        if cashDifference < 0 then
            CashGainedLost.Text = "Cash lost since join - <font color='rgb(255,0,0)'>-$"..commaValue(math.abs(cashDifference)).."</font>"
        elseif cashDifference > 0 then
            CashGainedLost.Text = "Cash gained since join - <font color='rgb(0,255,0)'>$"..commaValue(cashDifference).."</font>"
        else
            CashGainedLost.Text = "Cash gained/lost since join - <font color='rgb(255,255,255)'>$"..commaValue(cashDifference).."</font>"
        end
        --TimeRemaining
        TimeRemaining.Text = convertToHMS(calculateSecondsToDrop(newValue))
    end)

    --DestroyFloorCash
    DestroyFloorCash.MouseButton1Down:Connect(function()
        altCommands.destroycash()
    end)

    --RecountFloorCash
    RecountFloorCash.MouseButton1Down:Connect(function()
        TotalFloorCash.Text = "Cash on the floor - <font color='rgb(0,255,0)'>$"..commaValue(countFloorCash()).."</font>"
    end)

    --HelpButton
    HelpButton.MouseButton1Down:Connect(function()
        HelpFrame.Visible = not HelpFrame.Visible
    end)

    --DropBtn
    DropBtn.MouseButton1Down:Connect(function()
        altCommands.drop()
    end)

    --CashAuraBtn
    CashAuraBtn.MouseButton1Down:Connect(function()
        altCommands.aura(nil, {PLAYER.Name})
    end)

    --FpsLockBox
    FpsLockBox.FocusLost:Connect(function(enterPressed)
        if enterPressed == true then
            local fpsInput = tonumber(FpsLockBox.Text)
            if fpsInput then
                capFps(fpsInput)
            end
        end
    end)


    --Setup
    --altCommands.setup(nil, {"bank"})

    --Optimise
    setfpscap(4)
    RunService:Set3dRenderingEnabled(false)
    --RunService:setThrottleFramerateEnabled(true)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    settings().Rendering.QualityLevel = 1
  
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") or v:IsA("WedgePart") then
                v.Material = "SmoothPlastic"
                v.Reflectance = 0
                if v.Name ~= "Radius" and v.Name ~= "Siren" and v.Name ~= "SNOWs_" and not v:IsA("VehicleSeat") and not v:IsDescendantOf(ITEMS_DROP) and not v:IsDescendantOf(PLAYERS_FOLDER) and not v:IsDescendantOf(SHOP) and not v:IsDescendantOf(SPAWN) and not v:IsDescendantOf(LIGHTS) and not v:IsDescendantOf(PLAYER.Character) then
                    v:Destroy()
                elseif v.Parent == SPAWN then
                    v.CanCollide = true
                elseif v.Parent == ITEMS_DROP then
                    --Platform the item drop locations
                    local platform = Instance.new("Part")
                    platform.Name = "ItemPlatform"
                    platform.Anchored = true
                    platform.Transparency = 1
                    platform.Size = Vector3.new(5, 0.1, 5)
                    platform.Position = v.Position - Vector3.new(0, 3, 0)
                    platform.Parent = SPAWN
                end
            elseif v:IsA("Decal") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            end
        end
        --Snow
        local snowSkippedFlag = false -- leave 1 snow left
        for _,v in ipairs(IGNORED:GetChildren()) do
            if v.Name == "SNOWs_" then
                if snowSkippedFlag == false then
                    snowSkippedFlag = true
                else
                    v:Destroy()
                end
            end
        end
        for _,v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end

    sethiddenproperty(PLAYER, "SimulationRadius", 0)
    UserSettings().GameSettings.MasterVolume = 0
    UserSettings().GameSettings.SavedQualityLevel = 0

    

    --Create platforms
    --Folder
    local floorPartFolder = Instance.new("Folder")
    floorPartFolder.Name = "FloorParts"
    floorPartFolder.Parent = workspace
    --Feet platform (already created, just needs parenting lol)
    feetPlatform.Parent = floorPartFolder
    --Big Floor platform
    local floorPlatform = Instance.new("Part")
    floorPlatform.Name = "BigFloorPlatform"
    floorPlatform.Anchored = true
    floorPlatform.CanCollide = true
    floorPlatform.Position = Vector3.new(-30, -450, -350)
    floorPlatform.Size = Vector3.new(2047, 1, 2047)
    floorPlatform.Parent = floorPartFolder

    --Setup platforms
    for locationName, platformInfo in pairs(SETUP_PLATFORMS) do
        local platformPart = Instance.new("Part")
        platformPart.Name = locationName.."Platform"
        platformPart.Anchored = true
        platformPart.CanCollide = true
        platformPart.Size = platformInfo.Size
        platformPart.Position = platformInfo.Position
        platformPart.Parent = floorPartFolder
    end

    
    local TextChatService = game:GetService("TextChatService")
    TextChatService.OnIncomingMessage = function(message)
        if message.TextSource then
            local userId = message.TextSource.UserId
            local text = message.Text or ""

            print("New Chat from", userId, ":", text)

            if userId == getgenv().mainId then
                local splitString = string.split(text, " ")

                if #splitString > 0 then
                    local firstWord = splitString[1]
                    local cmdName = ""

                    if firstWord:sub(1, 1) == "/" or firstWord:sub(1, 1) == "." then
                        cmdName = string.lower(firstWord:sub(2))
                    end

                    print("firstWord:", firstWord)
                    print("cmdName:", cmdName)


                    if altCommands[cmdName] then
                        local args = {}
                        for i = 2, #splitString, 1 do
                            table.insert(args, splitString[i])
                        end
                
                        altCommands[cmdName](player, args)
                    end

                end
            end
        end
    end




    task.spawn(function()
        pcall(function()
            local api = loadstring(game:HttpGet('https://raw.githubusercontent.com/furryboy1/dh-code-redeemer/refs/heads/main/codes.lua'))()

            for _, v in pairs(api.codes) do
                task.wait(api.rate)
                Remote:FireServer('EnterPromoCode', v)
            end
        end)
    end)



    --Anti-afk
    local GC = getconnections or get_signal_cons
    if GC then
        for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    end
    print("Ran")   
else -- SELLER GUI
    local function format(value)
        -- Check if the value is negative
        local isNegative = value < 0
        value = math.abs(value)  -- Take the absolute value for formatting
    
        -- Format the number with commas
        local formatted = tostring(value):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    
        -- Add the dollar sign at the beginning
        if isNegative then
            formatted = "$-" .. formatted
        else
            formatted = "$" .. formatted
        end
        
        return formatted
    end
    
    
    hookfunction(game:GetService("UserInputService").GetFocusedTextBox, newcclosure(function(...)
        return 
    end))
    
    
    
    local G2L = {};
    
    
        -- Get the UserInputService to listen for key events
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    
    -- Function to hide all GUIs
    local function hideGUIs()
        if G2L["1"] then
            G2L["1"].Enabled = false  -- Disables the GUI by setting the "Enabled" property to false
        end
    end
    
    -- Function to show all GUIs
    local function showGUIs()
        if G2L["1"] then
            G2L["1"].Enabled = true  -- Enables the GUI by setting the "Enabled" property to true
        end
    end
    
    
    if gethui():FindFirstChild("SELLERGUI") then 
        gethui():FindFirstChild("SELLERGUI"):Destroy()
    end 
    
    -- Assuming G2L is already defined somewhere in the script
    
    -- Create the ScreenGui and place it in the G2L area
    local player = game.Players.LocalPlayer
    G2L["1"] = Instance.new("ScreenGui", gethui())
    G2L["1"].Name = "SELLERGUI"
    G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
    
    -- Create the frame
    G2L["2"] = Instance.new("Frame", G2L["1"])
    G2L["2"]["BorderSizePixel"] = 0
    G2L["2"]["BackgroundColor3"] = Color3.fromRGB(70, 70, 70)
    G2L["2"]["Size"] = UDim2.new(0, 520, 0, 296)
    G2L["2"]["Position"] = UDim2.new(0.12741, 0, 0.29397, 0)
    G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    
    
    -- Create a new frame named "sideFrame" with size {0, 100}, {0, 300} inside G2L["2"]
    local sideFrame = Instance.new("Frame", G2L["2"])
    sideFrame.Name = "sideFrame"  -- Name the inner frame "sideFrame"
    sideFrame.Size = UDim2.new(0, 130, 0, 296)  -- Size {0, 100}, {0, 300}
    sideFrame.Position = UDim2.new(0, 0, 0, 0)  -- Position it inside the parent frame (G2L["2"])
    sideFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Set a different background color to distinguish it
    sideFrame.BorderSizePixel = 0  -- Remove the border
    sideFrame.ZIndex = 2  -- Set a higher ZIndex for sideFrame to appear above the parent
    sideFrame.BackgroundTransparency = 0.5
    
    
    -- Add rounded corners to sideFrame using UICorner
    local uiCorner = Instance.new("UICorner", sideFrame)
    uiCorner.CornerRadius = UDim.new(0, 5)  -- Adjust the radius value to make the corners more or less rounded
    
    
    
    
    -- Function to create buttons
    local function createmobile(parent, position, text, callback)
        local button = Instance.new("TextButton", parent)
        button.Size = UDim2.new(0, 100, 0, 40)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = text
        button.Font = Enum.Font.GothamBold
        button.TextSize = 18
        button.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner", button)
        uiCorner.CornerRadius = UDim.new(0, 8)
    
        -- Button click event
        button.MouseButton1Click:Connect(callback)
        
        return button
    end
    
    
    
    
    -- mobile
    ---------
    local tpframe = Instance.new("Frame", G2L["2"])
    tpframe.Name = "sideFrame"
    tpframe.Size = UDim2.new(0, 70, 0, 10)
    tpframe.Position = UDim2.new(0, 420, 0, -55)
    tpframe.BackgroundColor3 = Color3.fromRGB(50, 25, 50)
    tpframe.BorderSizePixel = 0
    tpframe.ZIndex = 2
    tpframe.BackgroundTransparency = 1
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    -- Create the frames for Alts
    local AltsFrame = Instance.new("ScrollingFrame", G2L["2"])
    AltsFrame["Active"] = true
    AltsFrame["BorderSizePixel"] = 0
    AltsFrame["BackgroundColor3"] = Color3.fromRGB(0, 255, 0)
    AltsFrame["ScrollBarImageTransparency"] = 1
    AltsFrame["Size"] = UDim2.new(0, 396, 0, 296)
    AltsFrame["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0)
    AltsFrame["Position"] = UDim2.new(0.24, 10, 0, 0)
    AltsFrame["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    AltsFrame["BackgroundTransparency"] = 1
    
    AltsFrame.Visible = false  -- Initially hidden
    AltsFrame.ZIndex = 3
    
    
    -- Store the references to the labels to update later
    local altsStockLabel, altsBountyLabel, totalAltsLabel
    
    -- Helper function to create the boxes
    local function createBox2(parent, position, title, number)
        local box = Instance.new("Frame", parent)
        box.Size = UDim2.new(0, 379, 0, 60)
        box.Position = position
        box.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        box.BorderSizePixel = 0
        
        uicorner13 = Instance.new("UICorner", box);
    
        
        -- Title Label
        local titleLabel = Instance.new("TextLabel", box)
        titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
        titleLabel.Position = UDim2.new(0, 0, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 16
        
        -- Number Label
        local numberLabel = Instance.new("TextLabel", box)
        numberLabel.Size = UDim2.new(1, 0, 0.5, 0)
        numberLabel.Position = UDim2.new(0, 0, 0.5, 0)
        numberLabel.BackgroundTransparency = 1
        numberLabel.Text = tostring(number)  -- Set the number dynamically
        numberLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        numberLabel.Font = Enum.Font.GothamBold
        numberLabel.TextSize = 14
        
        -- Return the number label to be stored for future updates
        return numberLabel
    end
    
    -- Create the boxes and store references to the number labels
    altsStockLabel = createBox2(AltsFrame, UDim2.new(0, 0, 0, 10), "Alts Stock", 0)
    altsBountyLabel = createBox2(AltsFrame, UDim2.new(0, 0, 0, 80), "Alts Bounty", 0)
    totalAltsLabel = createBox2(AltsFrame, UDim2.new(0, 0, 0, 150), "Total Alts", 0)
    
    
    
    -- Function to create a dynamic box to display PFP, username, and cash balance
    local function createProfileBox(parent, player, position)
        local box = Instance.new("Frame", parent)
        box.Size = UDim2.new(0, 379, 0, 80)  -- Fixed height for each profile box
        box.Position = position  -- Position passed in as argument
        box.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        box.BorderSizePixel = 0
        box.Name = "ProfileBox_" .. player.UserId  -- Unique name for the box
    
        local uicorner13 = Instance.new("UICorner", box)
    
        local PLACEHOLDER_IMAGE = "rbxassetid://0"
    
        local pfp = Instance.new("ImageLabel", box)
        pfp.Parent = box
        pfp["BorderSizePixel"] = 0;
        pfp["BackgroundColor3"] = Color3.fromRGB(34, 34, 34);
        pfp["Image"] = "rbxasset://textures/ui/GuiImagePlaceholder.png";
        pfp["Size"] = UDim2.new(0, 40, 0, 40);
        pfp["BorderColor3"] = Color3.fromRGB(0, 0, 0);
        pfp.Position = UDim2.new(0, 10, 0, 10)
        
        local userId = player.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        local content, isReady = game:GetService("Players"):GetUserThumbnailAsync(userId, thumbType, thumbSize)
        
        pfp.Image =  (isReady and content) or PLACEHOLDER_IMAGE
        
        
        uicorner2 = Instance.new("UICorner", pfp);
        uicorner2["CornerRadius"] = UDim.new(1, 0);
        
        
        -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.ImageLabel.UIStroke
        stroke2 = Instance.new("UIStroke", pfp);
        stroke2["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
        stroke2["Color"] = Color3.fromRGB(0, 255, 0);
    
        -- Username Label
        local usernameLabel = Instance.new("TextLabel", box)
        usernameLabel.Size = UDim2.new(0, 200, 0, 25)
        usernameLabel.Position = UDim2.new(0, 70, 0, 10)  -- Adjusted position
        usernameLabel.BackgroundTransparency = 1
        usernameLabel.Text = player.Name  -- Player's Username
        usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        usernameLabel.Font = Enum.Font.GothamBold
        usernameLabel.TextSize = 16
    
        -- Cash Balance Label
        local cashBalanceLabel = Instance.new("TextLabel", box)
        cashBalanceLabel.Size = UDim2.new(0, 200, 0, 25)
        cashBalanceLabel.Position = UDim2.new(0, 70, 0, 40)  -- Adjusted position
        cashBalanceLabel.BackgroundTransparency = 0
        cashBalanceLabel.Text = format(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
        cashBalanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        cashBalanceLabel.Font = Enum.Font.GothamBold
        cashBalanceLabel.TextSize = 16
    
        player:WaitForChild("DataFolder"):WaitForChild("Currency").Changed:Connect(function()
            cashBalanceLabel.Text = format(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
        end)
    
    
        return box
    end
    
    -- Function to add the profile boxes dynamically under the existing ones
    local function addProfileBoxes(player)
        -- Get the number of existing profile boxes to calculate the position
        local numBoxes = #AltsFrame:GetChildren()
        
        -- Dynamically calculate the Y position for the new box based on the existing number of boxes
        local positionY = 10 + numBoxes * 70 -- 220 is the starting Y position, 90 is the height of each box
    
        -- Create profile box and set its position
        local newBox = createProfileBox(AltsFrame, player, UDim2.new(0, 0, 0, positionY))
    end
    
    -- Function to remove a profile box when the player leaves
    local function removeProfileBox(player)
        -- Find the profile box by player UserId
        local profileBox = AltsFrame:FindFirstChild("ProfileBox_" .. player.UserId)
        if profileBox then
            profileBox:Destroy()  -- Remove the profile box from the frame
        end
    end
    
    -- Function to update the positioning of the remaining boxes after a player leaves
    local function updateProfileBoxes()
        local numBoxes = #AltsFrame:GetChildren()
    
        -- Adjust the AltsFrame size to fit all boxes
        local boxHeight = 80  -- Height of each profile box
        local padding = 10    -- Optional padding between boxes
        local totalHeight = (numBoxes * boxHeight) + ((numBoxes - 1) * padding)
        AltsFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    
        -- Reposition remaining profile boxes
        local boxPositionY = 220
        for _, profileBox in pairs(AltsFrame:GetChildren()) do
            if profileBox:IsA("Frame") and profileBox.Name:match("ProfileBox_") then
                profileBox.Position = UDim2.new(0, 0, 0, boxPositionY)  -- Update position based on calculated Y position
                boxPositionY = boxPositionY + 90  -- Increment Y position for next box
            end
        end
    end
    
    
    
    
    
    
    -- Function to format the numbers with suffixes (b for billion, m for million, etc.)
    local function formatNumber(value)
        if value >= 1e9 then
            return string.format("%.1fb", value / 1e9)  -- Format in billions
        elseif value >= 1e6 then
            return string.format("%.1fm", value / 1e6)  -- Format in millions
        elseif value >= 1e3 then
            return string.format("%.1fk", value / 1e3)  -- Format in thousands
        else
            return tostring(value)  -- For values less than 1000, no formatting
        end
    end
    
    -- Function to update the box values with formatted numbers
    local function updateAltsValues(altsStock, altsBounty, totalAlts)
        -- Calculate the 15% discount for altsStock
        local discountedAltsStock = altsStock * 0.85
    
        -- Update the labels with formatted values
        altsStockLabel.Text = formatNumber(altsStock) .. " (" .. formatNumber(discountedAltsStock) .. ")"
        altsBountyLabel.Text = formatNumber(altsBounty)  -- Update Alts Bounty value
        totalAltsLabel.Text = formatNumber(totalAlts)  -- Update Total Alts value
    end
    
    local function calculateAltsValues()
        local totalMoney = 0
        local totalBounties = 0
        local altsInGame = 0
    
        -- Loop through all players in the game
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            -- Check if the player is in the alts list
            if table.find(getgenv().alts, player.UserId) then
                -- Wait for the player's data folder and currency value to be available
                local currency = player:WaitForChild("DataFolder"):WaitForChild("Currency")
                local bounty = player:WaitForChild("DataFolder"):WaitForChild("Information"):WaitForChild("Wanted")
    
                -- Add the player's money and bounty to the totals
                totalMoney = totalMoney + currency.Value
                totalBounties = totalBounties + bounty.Value
    
                -- Increment the count of alts in the game
                altsInGame = altsInGame + 1
            end
        end
    
        -- Call the update function with the calculated values
        updateAltsValues(totalMoney, totalBounties, altsInGame)
    end
    
    
    
    -- Create MiscFrame (already provided)
    local MiscFrame = Instance.new("ScrollingFrame", G2L["2"])
    MiscFrame["Active"] = true
    MiscFrame["BorderSizePixel"] = 0
    MiscFrame["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    MiscFrame["ScrollBarImageTransparency"] = 1
    MiscFrame["Size"] = UDim2.new(0, 396, 0, 296)
    MiscFrame["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0)
    MiscFrame["Position"] = UDim2.new(0.24, 10, 0, 0)
    MiscFrame["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    MiscFrame["BackgroundTransparency"] = 1
    MiscFrame.Visible = false  -- Initially hidden
    MiscFrame.ZIndex = 3
    -- Disable scroll functionality by setting CanvasSize to Size and removing the scrollbar
    MiscFrame.CanvasSize = AltsFrame.Size
    MiscFrame.ScrollBarThickness = 0  -- This hides the scrollbar
    
    
    
    -- Function to create buttons
    local function createButton(parent, position, text, callback)
        local button = Instance.new("TextButton", parent)
        button.Size = UDim2.new(0, 379, 0, 40)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = text
        button.Font = Enum.Font.GothamBold
        button.TextSize = 18
        button.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner", button)
        uiCorner.CornerRadius = UDim.new(0, 8)
    
        -- Button click event
        button.MouseButton1Click:Connect(callback)
        
        return button
    end
    
    -- Function to create toggle switches
    local function createToggle1(parent, position, text, initialState, callback)
        local toggleFrame = Instance.new("Frame", parent)
        toggleFrame.Size = UDim2.new(0, 379, 0, 40)
        toggleFrame.Position = position
        toggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        toggleFrame.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner", toggleFrame)
        uiCorner.CornerRadius = UDim.new(0, 8)
    
    
    
        local toggleLabel = Instance.new("TextLabel", toggleFrame)
        toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleLabel.Font = Enum.Font.GothamBold
        toggleLabel.TextSize = 18
    
        local toggleButton = Instance.new("TextButton", toggleFrame)
        toggleButton.Size = UDim2.new(0.3, 0, 1, 0)
        toggleButton.Position = UDim2.new(0.7, 0, 0, 0)
        toggleButton.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleButton.Text = initialState and "ON" or "OFF"
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.TextSize = 18
        toggleButton.BorderSizePixel = 0
        local uiCornerToggle = Instance.new("UICorner", toggleButton)
        uiCornerToggle.CornerRadius = UDim.new(0, 8)
    
        -- Toggle button click event
        toggleButton.MouseButton1Click:Connect(function()
            initialState = not initialState  -- Toggle state
            toggleButton.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            toggleButton.Text = initialState and "ON" or "OFF"
            if callback then
                callback(initialState)  -- Trigger the callback with the new state
            end
        end)
    
        return toggleFrame
    end
    
    local LocalPlayer = game.Players.LocalPlayer
    local function bringallplayers()
        -- Loop through all players in the game
        for _, player in pairs(game.Players:GetPlayers()) do
            -- Check if the player is not LocalPlayer and not in the alts list
            if player ~= LocalPlayer and not table.find(getgenv().alts, player.UserId) then
                -- Fire the server event to kick the player
                game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
            end
        end
    end
    
    local function babyAlts()
        -- Loop through all players in the game
        for _, player in pairs(game.Players:GetPlayers()) do
            -- Check if the player's UserId is in the alts list
            if table.find(getgenv().alts, player.UserId) then
                task.wait(1.5)
                game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "BabySize", player)
            end
        end
    end
    
    
    
    
    -- Create the buttons inside MiscFrame
    createButton(MiscFrame, UDim2.new(0, 0, 0, 10), "Bring all buyers [👑]", function()
        bringallplayers()
    end)
    
    createButton(MiscFrame, UDim2.new(0, 0, 0, 60), "Baby alts [👑]", function()
        babyAlts()
    end)
    -- Define a variable to control the loop state
    local cashAuraActive = false
    
    -- Assuming you have a createToggle function and a MiscFrame for the UI elements
    createToggle1(MiscFrame, UDim2.new(0, 0, 0, 110), "Cash Aura", false, function(state)
    
        
        -- Define the PLAYER variable to represent the local player
        local PLAYER = game.Players.LocalPlayer
        local cashAuraActive = false -- Initialize the state of the cash aura
    
        -- If the state is ON, start the loop
        if state then
            cashAuraActive = true -- Start the loop
    
            -- Run the loop only when Cash Aura is ON
            while cashAuraActive do
                -- Check if the "Drop" folder exists before continuing
                local dropFolder = workspace:FindFirstChild("Ignored") and workspace.Ignored:FindFirstChild("Drop")
                if dropFolder then
                    -- Iterate through the drops in the workspace
                    for _, v in ipairs(dropFolder:GetChildren()) do
                        -- Check if the object is a Part and within a 12-stud radius of the player
                        if v:IsA("Part") and PLAYER:DistanceFromCharacter(v.Position) < 12 then
                            -- Check if the part has a ClickDetector before firing it
                            local clickDetector = v:FindFirstChildOfClass("ClickDetector")
                            if clickDetector then
                                -- Fire the ClickDetector on the part (i.e., interact with the drop)
                                fireclickdetector(clickDetector)
                            end
                        end
                    end
                end
    
                -- Wait for a short time before checking again
                task.wait(0.1)
    
                -- Check if the state has changed to OFF and stop if necessary
                if not state then
                    cashAuraActive = false
                end
            end
        else
            cashAuraActive = false -- Ensure the loop stops if state is OFF
        end
    end)
    
    
    
    
    -- Declare a variable to control the Auto Drop state
    local autoDropActive = false
    
    -- Assuming you have a createToggle function and a MiscFrame for the UI elements
    createToggle1(MiscFrame, UDim2.new(0, 0, 0, 160), "Auto Drop", false, function(state)
    
        
        -- If the state is ON, start the Auto Drop loop
        if state then
            -- Set the autoDropActive flag to true to start the loop
            autoDropActive = true
            
            -- Start an infinite loop that checks every 15.5 seconds
            while autoDropActive do
                -- Fire the DropMoney event with the amount 15000
                game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("DropMoney", 15000)
                
                -- Wait for 15.5 seconds before firing again
                task.wait(15.5)
                
                -- If the state turns OFF, break out of the loop
                if not state then
                    autoDropActive = false
                    break
                end
            end
        else
            -- If state is OFF, stop the loop by setting autoDropActive to false
            autoDropActive = false
        end
    end)
    local IGNORED = workspace:WaitForChild("Ignored")
    -- Declare a flag to control whether cash should be hidden
    local hideCash = false
    
    -- Create the Hide Cash toggle button
    createToggle1(MiscFrame, UDim2.new(0, 0, 0, 210), "Hide Cash", false, function(state)
    
        
        -- Set the hideCash flag based on the state of the toggle
        hideCash = state
    
        -- Apply the hide/unhide effect based on the hideCash flag
        if hideCash == true then
            for _, v in pairs(IGNORED.Drop:GetChildren()) do
                if v:IsA("Part") then
                    -- Hide the Decal if it exists
                    if v:FindFirstChild("Decal") then
                        v.Decal:Destroy()  -- Removing Decal(s)
                        v.Decal:Destroy()  -- Destroying the second Decal instance if it exists
                    end
    
                    -- Hide the BillboardGui and make the part transparent
                    if v:FindFirstChild("BillboardGui") then
                        v.BillboardGui.Enabled = false
                    end
                    v.Transparency = 1  -- Make the part transparent
                end
            end
        else
            for _, v in pairs(IGNORED.Drop:GetChildren()) do
                if v:IsA("Part") then
                    -- Re-enable the BillboardGui and make the part visible again
                    if v:FindFirstChild("BillboardGui") then
                        v.BillboardGui.Enabled = true
                    end
                    v.Transparency = 0  -- Make the part visible again
                end
            end
        end
    end)
    
    
    
    -- Monitor for new parts in the IGNORED.Drop folder (optional)
    IGNORED.Drop.ChildAdded:Connect(function(child)
        if child:IsA("Part") then
            -- Hide new cash parts if the toggle is ON
            if hideCash then
                task.wait(0.5)
                
                -- Destroy all existing decals on the part
                for _, decal in pairs(child:GetChildren()) do
                    if decal:IsA("Decal") then
                        decal:Destroy()
                    end
                end
    
                -- Hide the BillboardGui and make the part transparent
                if child:FindFirstChild("BillboardGui") then
                    child.BillboardGui.Enabled = false
                end
                child.Transparency = 1  -- Make the part transparent
            end
        end
    end)
    
    
    -- Create SettingsFrame (already provided)
    local SettingsFrame = Instance.new("ScrollingFrame", G2L["2"])
    SettingsFrame["Active"] = true
    SettingsFrame["BorderSizePixel"] = 0
    SettingsFrame["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    SettingsFrame["ScrollBarImageTransparency"] = 1
    SettingsFrame["Size"] = UDim2.new(0, 396, 0, 296)
    SettingsFrame["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0)
    SettingsFrame["Position"] = UDim2.new(0.24, 10, 0, 0)
    SettingsFrame["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    SettingsFrame["BackgroundTransparency"] = 1
    SettingsFrame.Visible = false  -- Initially hidden
    SettingsFrame.ZIndex = 3
    SettingsFrame.CanvasSize = UDim2.new(0, 0, 0, 720)  -- Adjusted for scrolling
    SettingsFrame.ScrollBarThickness = 6  -- Custom scroll bar thickness
    
    
    
    
    -- Create altcontrol (already provided)
    local altcontrol = Instance.new("ScrollingFrame", G2L["2"])
    altcontrol["Active"] = true
    altcontrol["BorderSizePixel"] = 0
    altcontrol["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    altcontrol["ScrollBarImageTransparency"] = 1
    altcontrol["Size"] = UDim2.new(0, 396, 0, 296)
    altcontrol["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0)
    altcontrol["Position"] = UDim2.new(0.24, 10, 0, 0)
    altcontrol["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    altcontrol["BackgroundTransparency"] = 1
    altcontrol.Visible = false  -- Initially hidden
    altcontrol.ZIndex = 3
    altcontrol.CanvasSize = UDim2.new(0, 0, 0, 1000)  -- Adjusted for scrolling
    altcontrol.ScrollBarThickness = 6  -- Custom scroll bar thickness
    
    
    
    
    
    
    
    
    local function createKeybindInput(parent, position, text, placeholder, callback)
        local textInputFrame = Instance.new("Frame", parent)
        textInputFrame.Size = UDim2.new(0, 379, 0, 40)
        textInputFrame.Position = position
        textInputFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        textInputFrame.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner", textInputFrame)
        uiCorner.CornerRadius = UDim.new(0, 8)
    
        local textInputFrame22 = Instance.new("UIStroke", textInputFrame)
        textInputFrame22["Thickness"] = 2
        textInputFrame22["Color"] = Color3.fromRGB(34, 34, 34)
    
        local label = Instance.new("TextLabel", textInputFrame)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
    
        local inputBox = Instance.new("TextBox", textInputFrame)
        inputBox["TextColor3"] = Color3.fromRGB(255, 255, 255)
        inputBox["BorderSizePixel"] = 0
        inputBox["TextSize"] = 14
        inputBox["BackgroundColor3"] = Color3.fromRGB(34, 34, 34)
        inputBox["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        inputBox["Size"] = UDim2.new(0, 104, 0, 23)
        inputBox["Position"] = UDim2.new(0.7, 0, 0.2, 0)
        inputBox["BorderColor3"] = Color3.fromRGB(0, 0, 0)
        inputBox["Text"] = placeholder  -- Set placeholder text
        local inputBoxstuff = Instance.new("UICorner", inputBox)
        inputBoxstuff["CornerRadius"] = UDim.new(0, 5)
        local inputBoxstuffstroke = Instance.new("UIStroke", inputBox)
        inputBoxstuffstroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
        inputBoxstuffstroke["Color"] = Color3.fromRGB(50, 50, 50)
    
        -- Set ZIndex for text input fields to be lower
        textInputFrame.ZIndex = 1
    
        -- Listen for when the input box gains focus
        inputBox.FocusEntered:Connect(function()
            -- Listen for key presses when the input box gains focus
            UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
                if gameProcessedEvent then return end  -- Ignore if the game already processed the input (e.g., chat)
    
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    -- Capture the key pressed and update the text box with the key name
                    local keyName = input.KeyCode.Name
                    inputBox.Text = keyName  -- Update the TextBox with the key name
                    if callback then
                        callback(keyName)  -- Call the callback with the key name as the argument
                    end
                end
            end)
        end)
    
        return textInputFrame
    end
    
    local function createTextInput(TEXTBOX, parent, position, text, placeholder, callback)
        if TEXTBOX == false then
            TEXTBOX = ""
        end
    
        -- Create the main frame
        local textInputFrame = Instance.new("Frame", parent)
        textInputFrame.Size = UDim2.new(0, 379, 0, 40)
        textInputFrame.Position = position
        textInputFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        textInputFrame.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner", textInputFrame)
        uiCorner.CornerRadius = UDim.new(0, 8)
    
    
        -- Create the label inside the frame
        local label = Instance.new("TextLabel", textInputFrame)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
    
        -- Create the input box inside the frame
        local inputBox = Instance.new("TextBox", textInputFrame)
        inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        inputBox.BorderSizePixel = 0
        inputBox.TextSize = 14
        inputBox.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
        inputBox.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        inputBox.Size = UDim2.new(0, 104, 0, 23)
        inputBox.Position = UDim2.new(0.7, 0, 0.2, 0)
        inputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        inputBox.Text = TEXTBOX
        inputBox.ClearTextOnFocus = false  -- Keeps placeholder/text after focus
    
        -- Enable text wrapping
        inputBox.TextWrapped = true
    
        -- Add UI corner and stroke to the input box
        local inputBoxCorner = Instance.new("UICorner", inputBox)
        inputBoxCorner.CornerRadius = UDim.new(0, 5)
    
        local inputBoxStroke = Instance.new("UIStroke", inputBox)
        inputBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        inputBoxStroke.Color = Color3.fromRGB(50, 50, 50)
    
        -- Set the ZIndex of the frame
        textInputFrame.ZIndex = 1
    
        -- Connect the FocusLost event for the input box
        inputBox.FocusLost:Connect(function()
            if callback then
                callback(inputBox.Text)
            end
        end)
    
        -- Return the created frame
        return textInputFrame
    end
    
    -- Function to create a dropdown list
    local function createDropdown(TEXTBOX, parent, position, text, options, callback)
        local dropdownFrame = Instance.new("Frame", parent)
        dropdownFrame.Size = UDim2.new(0, 379, 0, 40)
        dropdownFrame.Position = position
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        dropdownFrame.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner", dropdownFrame)
        uiCorner.CornerRadius = UDim.new(0, 8)
    
    
    
    
        local label = Instance.new("TextLabel", dropdownFrame)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
    
        local dropdownButton = Instance.new("TextButton", dropdownFrame)
        dropdownButton.Size = UDim2.new(0, 100, 0, 40)
        dropdownButton.Position = UDim2.new(0.7, 0, 0, 0)
        dropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdownButton.Text = TEXTBOX
        dropdownButton.Font = Enum.Font.GothamBold
        dropdownButton.TextSize = 16
        dropdownButton.BorderSizePixel = 0
        local uiCornerDropdown = Instance.new("UICorner", dropdownButton)
        uiCornerDropdown.CornerRadius = UDim.new(0, 8)
        dropdownButton.MouseButton1Click:Connect(function()
            -- Create the selection frame (the dropdown list)
            local selection = Instance.new("Frame")
            selection.Size = UDim2.new(0, 100, 0, 160)  -- Fixed size for the dropdown (height is fixed)
            selection.Position = UDim2.new(0, 0, 0, dropdownFrame.Position.Y.Offset + 40)  -- Position below the button
            selection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            selection.Parent = parent
            selection.ZIndex = 2  -- Ensure dropdown appears above the button
        
            -- Round the corners of the dropdown box
            local corner = Instance.new("UICorner", selection)
            corner.CornerRadius = UDim.new(0, 10)  -- Set roundness of the dropdown box
        
            -- Create the ScrollingFrame to handle scrollable content
            local scrollFrame = Instance.new("ScrollingFrame", selection)
            scrollFrame.Size = UDim2.new(0, 100, 0, 160)  -- Size matches the parent frame
            scrollFrame.Position = UDim2.new(0, 0, 0, 0)  -- Align with the parent frame
            scrollFrame.BackgroundTransparency = 1
            scrollFrame.ScrollBarThickness = 6  -- Thickness of the scrollbar
            -- Adjust CanvasSize to fit a maximum of 4 options visible
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, math.min(#options, 4) * 80)  -- Allow only 4 options to be visible at once
            scrollFrame.ScrollBarImageTransparency = 0.7  -- Transparency of the scrollbar
            scrollFrame.ZIndex = 3  -- Make sure the scrollable content is above the background
        
            -- Create a button for each option inside the scrollable frame
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton", scrollFrame)
                optionButton.Size = UDim2.new(0, 95, 0, 40)  -- Size each option button
                optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 45)  -- Proper vertical spacing (50px per option)
                optionButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.Text = option
                optionButton.Font = Enum.Font.GothamBold
                optionButton.TextSize = 10
                optionButton.BorderSizePixel = 0
        
                -- Round the corners of the individual option buttons
                local optionCorner = Instance.new("UICorner", optionButton)
                optionCorner.CornerRadius = UDim.new(0, 8)  -- Set roundness for option buttons
        
                optionButton.MouseButton1Click:Connect(function()
                    dropdownButton.Text = option  -- Set selected option text on the button
                    selection:Destroy()  -- Close dropdown after selection
                    if callback then
                        callback(option)  -- Call the callback with selected option
                    end
                end)
            end
        end)
        
    
        return dropdownFrame
    end
    
    
    
    
    
    
    
    -- Function to create toggle switches
    local function createToggle(parent, position, text, initialState, callback)
        local toggleFrame = Instance.new("Frame", parent)
        toggleFrame.Size = UDim2.new(0, 379, 0, 40)
        toggleFrame.Position = position
        toggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        toggleFrame.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner", toggleFrame)
        uiCorner.CornerRadius = UDim.new(0, 8)
    
    
    
    
        local toggleLabel = Instance.new("TextLabel", toggleFrame)
        toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleLabel.Font = Enum.Font.GothamBold
        toggleLabel.TextSize = 13
    
        local toggleButton = Instance.new("TextButton", toggleFrame)
        toggleButton.Size = UDim2.new(0.3, 0, 1, 0)
        toggleButton.Position = UDim2.new(0.7, 0, 0, 0)
        toggleButton.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleButton.Text = initialState and "ON" or "OFF"
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.TextSize = 18
        toggleButton.BorderSizePixel = 0
        local uiCornerToggle = Instance.new("UICorner", toggleButton)
        uiCornerToggle.CornerRadius = UDim.new(0, 8)
    
        -- Set ZIndex to ensure the toggle is above other UI elements
        toggleFrame.ZIndex = 2
        toggleButton.ZIndex = 3  -- Ensure the toggle button itself is above the frame
    
        toggleButton.MouseButton1Click:Connect(function()
            initialState = not initialState
            toggleButton.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            toggleButton.Text = initialState and "ON" or "OFF"
            if callback then
                callback(initialState)
            end
        end)
    
        return toggleFrame
    end
    
    
    local GuiSettings = {
        ["Teleport_Location"] = "Bank",
        ["Teleport_Location_Keybind"] = "c",
        ["Auto_Bring_to_Vault"] = false,
        ["Auto_Kick_on_Finished"] = false, 
        ["Auto_Kick_on_Extra_Pickup"] = false,
        ["Bring_on_Join"] = false,
        ["Join_Audio_id"] = "2927319759",
        ["Goal_Audio_id"] = "7116606826",
        ["Leave_Audio_id"] = "5606947971",
        ["Gui_Image_Background_id"] = "5430597512",
        ["Roblox_Cookie"] = false,
        ["Use_Cookie_block_method"] = false,
        ["Discord_Webhook"] = true,
        ["Send_Webhook_on_complete_order"] = true,
        ["Gui_Open_and_Close"] = "v",
    }
    
    
    local HttpService = game:GetService("HttpService")
    
    
    
    
    local function sendToPHPServer(userid, start_cash, end_cash, discord_webhook, bought)
        -- Construct the URL with the parameters
        local php_url = "https://dahoodcash.com/hook.php/?userid=" .. userid ..
                        "&start_cash=" .. start_cash ..
                        "&end_cash=" .. end_cash ..
                        "&webhook=" .. discord_webhook ..
                        "&total_bought=" .. bought
    
        -- Prepare the request options for a GET request
        local options = {
            Url = php_url,  -- The full URL with query parameters
            Method = "GET"  -- Using GET method
        }
    
        -- Send the HTTP request using the request function
        local response = request(options)
    
        -- Check if the response is successful
        if response.Success then
            print("Image sent to Discord webhook successfully!")
        else
            print("Failed to send image to Discord: " .. response.StatusCode .. " - " .. response.StatusMessage)
        end
    end
    
    
    
    
    
    local function unblockPlayer(userId)
        local cookies = {
            [".ROBLOSECURITY"] = GuiSettings["Roblox_Cookie"],
        }
        local first_response = request({
            Url = "https://accountsettings.roblox.com/v1/users/" .. userId .. "/unblock",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Cookies = cookies
        })
    
        local csrf_token = first_response.Headers["x-csrf-token"]
    
        if csrf_token then
            local second_response = request({
                Url = "https://accountsettings.roblox.com/v1/users/" .. userId .. "/unblock",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["x-csrf-token"] = csrf_token
                },
                Cookies = cookies
            })
    
            if second_response.StatusCode == 200 then
                print("Successfully unblocked player with User ID: " .. userId)
            else
                print("Failed to unblock player. Status Code:", second_response.StatusCode)
            end
        else
            print("CSRF token not found. Could not proceed with blocking.")
        end
    end
    
    
    local function blockPlayer(userId)
        local cookies = {
            [".ROBLOSECURITY"] = GuiSettings["Roblox_Cookie"],
        }
        local first_response = request({
            Url = "https://accountsettings.roblox.com/v1/users/" .. userId .. "/block",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Cookies = cookies
        })
    
        local csrf_token = first_response.Headers["x-csrf-token"]
    
        if csrf_token then
            local second_response = request({
                Url = "https://accountsettings.roblox.com/v1/users/" .. userId .. "/block",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["x-csrf-token"] = csrf_token
                },
                Cookies = cookies
            })
    
            if second_response.StatusCode == 200 then
                print("Successfully blocked player with User ID: " .. userId)
            else
                print("Failed to block player. Status Code:", second_response.StatusCode)
            end
        else
            print("CSRF token not found. Could not proceed with blocking.")
        end
    end
    
    
    
    
    
    
    local function saveData()
        if isfile("Lulu_Gui_Settings.bdh") then
            delfile("Lulu_Gui_Settings.bdh")
        end
        writefile("Lulu_Gui_Settings.bdh", HttpService:JSONEncode(GuiSettings))
    end
    
    local function loadData()
        if isfile("Lulu_Gui_Settings.bdh") then
            local contents = HttpService:JSONDecode(readfile("Lulu_Gui_Settings.bdh"))
            for propertyName, value in pairs(contents) do
                GuiSettings[propertyName] = value
            end
        end
    end
    
    
    
    
    pcall(function() loadData() end)
    
    
    -- Create an ImageLabel to display the image inside the frame
    local imageLabel = Instance.new("ImageLabel", G2L["2"])
    imageLabel.Size = UDim2.new(1, 0, 1, 0)  -- Cover the entire frame
    imageLabel.Position = UDim2.new(0, 0, 0, 0)  -- Align it to the top-left corner
    imageLabel.BackgroundTransparency = 1  -- No background
    local imageId = GuiSettings["Gui_Image_Background_id"]
    if imageId == false then 
        imageId = "5430597512"
    end
    
    
    local success, result = pcall(function()
        return getcustomasset("background.png")
    end)
    
    if success and result then
        imageLabel.Image = result
    end
    
    
    -- Add a UICorner to the ImageLabel to round its corners
    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 5)  -- Adjust the radius to match the frame's radius
    imageCorner.Parent = imageLabel
    
    
    
    
    local Locations = {
        ["Bank"] = CFrame.new(-389, 22, -373),
        ["Club"] = CFrame.new(-264.717, 0.028, -422.911),
        ["Train"] = CFrame.new(602, 49, -112),
        ["Jail"] = CFrame.new(-344, 21.75, -60.25),
        ["School"] = CFrame.new(-667, 21.75, 177.5),
        ["Vault"] = CFrame.new(-437.5, 41.5, -285.1),
        ["Basketball"] = CFrame.new(-636.557, -31.119, -298.02),
        ["Vault"] = CFrame.new(-636.557, -31.119, -298.02),
    }
    
    local function teleportToLocation(locationName)
        local character = game.Players.LocalPlayer.Character
        if character and Locations[locationName] then
            character:SetPrimaryPartCFrame(Locations[locationName])
        end
    end
    
    if UserInputService.TouchEnabled then
        createmobile(tpframe, UDim2.new(0, 0, 0, 10), "Teleport", function()
            teleportToLocation(GuiSettings["Teleport_Location"])
        end)
    end
    
    local function tptobank(user)
        local character = game.Players.LocalPlayer.Character
        local originalPosition = character.HumanoidRootPart.Position
        character:SetPrimaryPartCFrame(CFrame.new(-664, -30, -284))
        task.wait(0.5)
        game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", user)
        task.wait(0.5)
        character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
    end
    
    local function Autokickonfinished(user)
        if GuiSettings["Use_Cookie_block_method"] == true then
            blockPlayer(user.userId)
            task.wait(2)
            unblockPlayer(user.userId)
        else
            game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Kick", user)
        end
    end
    
    
    
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then
            return  -- Ignore the event if the game has already processed it (e.g., in chat)
        end
    
        -- Check for the keybind to open/close the GUI
        local guiKeybind = GuiSettings["Gui_Open_and_Close"]:sub(1, 1):upper()  -- Get first letter and uppercase
        local guiKeyEnum = Enum.KeyCode[guiKeybind]  -- Get the corresponding Enum.KeyCode for GUI toggle
        
        if input.KeyCode == guiKeyEnum then
            -- Toggle the visibility of the GUI when the dynamic key is pressed
            if G2L["1"].Enabled then
                hideGUIs()  -- If the GUI is visible, hide it
            else
                showGUIs()  -- If the GUI is hidden, show it
            end
        end
    
        -- Check for the teleport keybind
        local teleportKeybind = GuiSettings["Teleport_Location_Keybind"]:sub(1, 1):upper()  -- Get first letter and uppercase
        local teleportKeyEnum = Enum.KeyCode[teleportKeybind]  -- Get the corresponding Enum.KeyCode for teleportation
        
        if input.KeyCode == teleportKeyEnum then
            -- Teleport the player to the specified location when the teleport key is pressed
            teleportToLocation(GuiSettings["Teleport_Location"])  -- Teleport to the location specified in GuiSettings
        end
    end)
    
    
    -- settings
    -----------
    -----------
    createDropdown(GuiSettings["Teleport_Location"], SettingsFrame, UDim2.new(0, 0, 0, 10), "Teleport Location", {
        "Bank", 
        "Vault", 
        "Basketball", 
        "Club", 
        "Jail", 
        "Train", 
        "School"

    }, function(location)
        GuiSettings["Teleport_Location"] = location
        saveData()
    end)
    createTextInput(GuiSettings["Teleport_Location_Keybind"], SettingsFrame, UDim2.new(0, 0, 0, 60), "Teleport Location Keybind", "Press a key", function(input)
        GuiSettings["Teleport_Location_Keybind"] = input
        saveData()
    end)
    createToggle(SettingsFrame, UDim2.new(0, 0, 0, 110), "Auto Bring to Vault on Finished [👑]", GuiSettings["Auto_Bring_to_Vault"], function(state)
        GuiSettings["Auto_Bring_to_Vault"] = state
        saveData()
    end)
    createToggle(SettingsFrame, UDim2.new(0, 0, 0, 160), "Auto Kick on Finished [👑]", GuiSettings["Auto_Kick_on_Finished"], function(state)
        GuiSettings["Auto_Kick_on_Finished"] = state
        saveData()
    end)
    createToggle(SettingsFrame, UDim2.new(0, 0, 0, 210), "Auto Kick on Extra Pickup [👑]", GuiSettings["Auto_Kick_on_Extra_Pickup"], function(state)
        GuiSettings["Auto_Kick_on_Extra_Pickup"] = state
        saveData()
    end)
    createToggle(SettingsFrame, UDim2.new(0, 0, 0, 260), "Bring on Join [👑]", GuiSettings["Bring_on_Join"], function(state)
        GuiSettings["Bring_on_Join"] = state
        saveData()
    end)
    createTextInput(GuiSettings["Roblox_Cookie"], SettingsFrame, UDim2.new(0, 0, 0, 310), "Roblox Cookie", "Press a key", function(input)
        GuiSettings["Roblox_Cookie"] = input
        saveData()
    end)
    createToggle(SettingsFrame, UDim2.new(0, 0, 0, 360), "Use Cookie block method [👑]", GuiSettings["Use_Cookie_block_method"], function(state)
        GuiSettings["Use_Cookie_block_method"] = state
        saveData()
    end)
    createTextInput(GuiSettings["Discord_Webhook"], SettingsFrame, UDim2.new(0, 0, 0, 410), "Discord Webhook", "Press a key", function(input)
        GuiSettings["Discord_Webhook"] = input
        saveData()
    end)
    createToggle(SettingsFrame, UDim2.new(0, 0, 0, 460), "Send Webhook on complete order", GuiSettings["Send_Webhook_on_complete_order"], function(state)
        GuiSettings["Send_Webhook_on_complete_order"] = state
        saveData()
    end)
    createTextInput(GuiSettings["Gui_Open_and_Close"], SettingsFrame, UDim2.new(0, 0, 0, 510), "Gui Open and Close", "Press a key", function(input)
        GuiSettings["Gui_Open_and_Close"] = input
        saveData()
    end)
    createTextInput(GuiSettings["Join_Audio_id"], SettingsFrame, UDim2.new(0, 0, 0, 560), "Join Audio id", "Press a key", function(input)
        GuiSettings["Join_Audio_id"] = input
        saveData()
    end)
    createTextInput(GuiSettings["Goal_Audio_id"], SettingsFrame, UDim2.new(0, 0, 0, 610), "Goal Audio id", "Press a key", function(input)
        GuiSettings["Goal_Audio_id"] = input
        saveData()
    end)
    createTextInput(GuiSettings["Leave_Audio_id"], SettingsFrame, UDim2.new(0, 0, 0, 660), "Leave Audio id", "Press a key", function(input)
        GuiSettings["Leave_Audio_id"] = input
        saveData()
    end)
    ----------------
    ----------------
    
    --Alt Control
    -------------
    -------------
    createDropdown("Location", altcontrol, UDim2.new(0, 0, 0, 10), "Setup", {
        "Bank", 
        "Vault", 
        "Basketball", 
        "Club", 
        "Jail", 
        "Train", 
        "School"
    }, function(location)
        game.Players:Chat("/setup " .. string.lower(location))
    end)
    createToggle(altcontrol, UDim2.new(0, 0, 0, 60), "Drop", false, function(state)
        if state == true then
            game.Players:Chat("/drop")
        else
            game.Players:Chat("/stop")
        end
    end)
    createTextInput("", altcontrol, UDim2.new(0, 0, 0, 110), "Cdrop", "Press a key", function(input)
        if input == "" then
            game.Players:Chat("/stop")
        else
            game.Players:Chat("/cdrop " .. string.lower(input))
        end
    end)
    createToggle(altcontrol, UDim2.new(0, 0, 0, 160), "Airlock", false, function(state)
        if state == true then
            game.Players:Chat("/airlock")
        else
            game.Players:Chat("/hide")
        end
    end)
    createToggle(altcontrol, UDim2.new(0, 0, 0, 210), "Hide", false, function(state)
        if state == true then
            game.Players:Chat("/hide")
        else
            game.Players:Chat("/airlock")
        end
    end)
    createToggle(altcontrol, UDim2.new(0, 0, 0, 260), "Line", false, function(state)
        game.Players:Chat("/line")
    end)
    createToggle(altcontrol, UDim2.new(0, 0, 0, 310), "Aura", false, function(state)
        if state == true then
            game.Players:Chat("/aura")
        else
            game.Players:Chat("/stop")
        end
    end)
    createTextInput("", altcontrol, UDim2.new(0, 0, 0, 360), "Redeem", "Press a key", function(input)
        game.Players:Chat("/redeem " .. input)
    end)
    createToggle(altcontrol, UDim2.new(0, 0, 0, 410), "Freeze", false, function(state)
        if state == true then
            game.Players:Chat("/freeze")
        else
            game.Players:Chat("/unfreeze")
        end
    end)
    createTextInput("", altcontrol, UDim2.new(0, 0, 0, 460), "Advert", "Press a key", function(input)
        if input == "" then
            game.Players:Chat("/advert off")
        else
            game.Players:Chat("/advert " .. input)
        end
    end)
    createTextInput("", altcontrol, UDim2.new(0, 0, 0, 510), "Advert", "Press a key", function(input)
        game.Players:Chat("/say " .. input)
    end)
    createTextInput("", altcontrol, UDim2.new(0, 0, 0, 560), "Join Crew", "Press a key", function(input)
        game.Players:Chat("/joincrew " .. input)
    end)
    createDropdown("Animations", altcontrol, UDim2.new(0, 0, 0, 610), "Animation", {
        "fly", 
        "sturdy", 
        "griddy", 
        "tpose", 
        "speed"
    }, function(location)
        game.Players:Chat("/animation " .. location)
    end)
    createDropdown("Circle", altcontrol, UDim2.new(0, 0, 0, 660), "Size", {
        "1", 
        "2", 
        "3", 
        "4", 
        "5",
        "6",
        "7",
        "8",
        "9",
        "10"
    }, function(location)
        game.Players:Chat("/circle " .. location)
    end)
createToggle(altcontrol, UDim2.new(0, 0, 0, 710), "Tower", false, function(state)
    if state then
        game.Players:Chat("/tower on")
    else
        game.Players:Chat("/tower off")
    end
end)
    createToggle(altcontrol, UDim2.new(0, 0, 0, 710), "Dupe", false, function(state)
        if state == true then
            game.Players:Chat("/dupefor")
        else
            game.Players:Chat("/dupefor")
        end
    end)
    createDropdown("Location", altcontrol, UDim2.new(0, 0, 0, 760), "Setup OG", {
        "Bank", 
        "Bankroof", 
        "Basketball", 
        "Club", 
        "Jail", 
        "Train", 
        "School"
    }, function(location)
        game.Players:Chat("/setup " .. string.lower(location) .. " og")
    end)
    
    
    local buttonsData = {
        {Text = "Players", Position = UDim2.new(0, 0, 0, 0), Frame = G2L["7"]},
        {Text = "Alts", Position = UDim2.new(0, 0, 0, 50), Frame = AltsFrame},
        {Text = "Alt Control", Position = UDim2.new(0, 0, 0, 100), Frame = altcontrol},
        {Text = "Misc", Position = UDim2.new(0, 0, 0, 150), Frame = MiscFrame},
        {Text = "Settings", Position = UDim2.new(0, 0, 0, 200), Frame = SettingsFrame}
    }
    
    -- Create buttons inside the sideFrame
    for _, buttonData in ipairs(buttonsData) do
        local button = Instance.new("TextButton", sideFrame)
        button.Size = UDim2.new(1, 0, 0, 40)  -- Set the button size (full width, 40px height)
        button.Position = buttonData.Position  -- Set the position from the data table
        button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)  -- Set the background color
        button.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Set the text color to white
        button.Text = buttonData.Text  -- Set the text of the button (e.g., "Players")
        button.Font = Enum.Font.GothamBold  -- Set the font style
        button.TextSize = 18  -- Set the font size
        button.BorderSizePixel = 0  -- Remove the border around the button
    
        -- Add rounded corners to each button
        local buttonUICorner = Instance.new("UICorner", button)
        buttonUICorner.CornerRadius = UDim.new(0, 8)  -- Adjust the radius for rounded corners
    
        -- Add functionality for button click
        button.MouseButton1Click:Connect(function()
    
            -- Hide all frames first
            G2L["7"].Visible = false
            AltsFrame.Visible = false
            MiscFrame.Visible = false
            SettingsFrame.Visible = false
            altcontrol.Visible = false
    
            -- Show the corresponding frame for the button clicked
            if button.Text == "Players" then
                G2L["7"].Visible = true
            elseif button.Text == "Alts" then
                calculateAltsValues()
                AltsFrame.Visible = true
            elseif button.Text == "Misc" then
                MiscFrame.Visible = true
            elseif button.Text == "Settings" then
                SettingsFrame.Visible = true
    
            elseif button.Text == "Alt Control" then
                altcontrol.Visible = true
            end
        end)
    end
    
    
    
    -- StarterGui.ScreenGui.Frame.UICorner
    G2L["3"] = Instance.new("UICorner", G2L["2"])
    
    -- StarterGui.ScreenGui.Frame.ScrollingFrame
    -- player cards FRAME
    G2L["7"] = Instance.new("ScrollingFrame", G2L["2"])
    G2L["7"]["Active"] = true
    G2L["7"]["BorderSizePixel"] = 0
    G2L["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    G2L["7"]["ScrollBarImageTransparency"] = 1
    G2L["7"]["Size"] = UDim2.new(0, 410, 0, 296)
    G2L["7"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0)
    G2L["7"]["Position"] = UDim2.new(0.24, 0, 0, 0)
    G2L["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    G2L["7"]["BackgroundTransparency"] = 1
    
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.UIListLayout
    G2L["8"] = Instance.new("UIListLayout", G2L["7"])
    G2L["8"]["SortOrder"] = Enum.SortOrder.LayoutOrder
    G2L["8"].Padding = UDim.new(0, 5)
    
    G2L["8"]:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        -- Add extra space for padding and any offsets that might be required
        G2L["7"].CanvasSize = UDim2.new(0, 0, 0, G2L["8"].AbsoluteContentSize.Y + 10)
    end)
    
    
    local function playSound(soundId)
        local sound = Instance.new("Sound", game.Workspace)
        sound.SoundId = "rbxassetid://" .. soundId
        sound:Play()
    end
    
    
    local playerData = {}
    
    -- Initialize data for a player
    function initializePlayerData(player)
        if not playerData[player.Name] then
            playerData[player.Name] = {
                credit = tonumber(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value),
                need = 0,
                missing = 0,
                shouldhave = 0,
                last_cash_amount = 0,
                CASH_SPENT = 0,
                notificationPlayed = false,
                istracking = false,
                starter = 0,
                need2 = 0
            }
        end
    end
    
    -- Access player data
    function getPlayerData(player)
        return playerData[player.Name] or {}
    end
    
    
    if UserInputService.TouchEnabled then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ToggleGui"
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
        -- Create the ToggleButton (Button to trigger the functions)
        local button = Instance.new("TextButton")
        button.Name = "ToggleButton"
        button.Parent = screenGui
        button.Position = UDim2.new(0, 10, 0.5, -25)  -- Position on the left side, centered vertically
        button.Size = UDim2.new(0, 200, 0, 50)  -- Size of the button
        button.Text = "Hide"  -- Text on the button
        button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)  -- Blue background
        button.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
        local uiCorner22 = Instance.new("UICorner", button)
        uiCorner22.CornerRadius = UDim.new(0, 8)
        button["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        button.TextSize = 24
    
        button.MouseButton1Click:Connect(function()
            if button.Text == "Hide" then
                hideGUIs()  -- Call showGUIs when button is clicked
                button.Text = "Open"  -- Change the button text to "Hide GUI"
            else
                showGUIs()  -- Call hideGUIs when button is clicked
                button.Text = "Hide"  -- Change the button text to "Toggle GUI"
            end
        end)
    end
    
    
    
    
    
    
    -- Create the TextLabel for cash display inside G2L["1"]
    local cashDisplay = Instance.new("TextLabel")
    cashDisplay.Size = UDim2.new(0, 300, 0, 50)
    cashDisplay.Position = UDim2.new(0, 10, 0, 10)
    cashDisplay.TextSize = 24
    cashDisplay.BackgroundTransparency = 0.5
    cashDisplay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cashDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    cashDisplay.Text = "Total Floor Cash: $0"
    cashDisplay.Parent = G2L["1"]  -- Set the parent to G2L["1"]
    cashDisplay["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    
    -- Create a UICorner to round the corners of the TextLabel
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)  -- Adjust the radius to your preference
    uiCorner.Parent = cashDisplay
    
    -- Function to convert cash text to integer
    local function cashToInt(cashText)
        -- Remove all non-numeric characters except for the decimal point
        local numericString = cashText:gsub("[^0-9]", "")
        
        -- Convert the cleaned string to a number
        local cashAmount = tonumber(numericString)
        
        -- If the conversion fails (e.g., empty string or invalid characters), return 0
        return cashAmount or 0
    end
    
    -- Function to count floor cash
    local function countFloorCash2()
        local totalFloorCashAmount = 0
    
        -- Loop through all parts in the "Ignored.Drop" folder in workspace
        for _, v in pairs(workspace.Ignored.Drop:GetChildren()) do
            if v:IsA("Part") and v:FindFirstChild("BillboardGui") then
                local billboardGui = v.BillboardGui
                local textLabel = billboardGui:FindFirstChild("TextLabel")
                
                -- If the TextLabel exists and has valid text, process it
                if textLabel and textLabel.Text then
                    local amount = cashToInt(textLabel.Text)
                    totalFloorCashAmount += amount
                end
            end
        end
    
        local casher = format(totalFloorCashAmount)
        cashDisplay.Text = casher
        return totalFloorCashAmount
    end
    
    -- Use Heartbeat to periodically update the total cash
    game:GetService("RunService").Heartbeat:Connect(function()
        countFloorCash2()  -- Call the function to update the cash display
    end)
    
    
    
    
    local function parseAmount(input)
        -- Trim spaces and check for suffixes (k, m, b)
        input = input:match("^%s*(.-)%s*$")  -- Trim spaces
        local num, suffix = input:match("^(%d+%.?%d*)([kmb]?)$")  -- Capture number with optional decimal and suffix
        num = tonumber(num)  -- Convert the number part to a number
        
        if num then
            -- Handle suffixes
            if suffix == "k" then
                return num * 1000
            elseif suffix == "m" then
                return num * 1000000
            elseif suffix == "b" then
                return num * 1000000000
            else
                return num  -- No suffix, return the number as it is
            end
        else
            return 0  -- If the input isn't valid, return 0
        end
    end
    
    
    
    
    
    local function createbox(player, THREE, LABEL1)
    local frame , uicorner1,uistroke1,image1,uicorner2,stroke2,textlabel1,label2,label3,textbox,corner4,uistroke4,padding,label4
    
    
    
    frame = Instance.new("Frame", G2L["7"]);
    frame["BorderSizePixel"] = 0;
    frame["BackgroundColor3"] = Color3.fromRGB(28, 28, 28);
    frame["Size"] = UDim2.new(0, 379, 0, 76);
    frame["Position"] = UDim2.new(-0.02488, 0, -0.01718, 0);
    frame["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    frame.Name = player.Name .. "_Box"  -- Naming the box with player name
    
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.UICorner
    uicorner1 = Instance.new("UICorner", frame);
    
    
    
    local PLACEHOLDER_IMAGE = "rbxassetid://0"
    
    image1 = Instance.new("ImageLabel");
    image1.Parent = frame
    image1["BorderSizePixel"] = 0;
    image1["BackgroundColor3"] = Color3.fromRGB(34, 34, 34);
    image1["Image"] = "rbxasset://textures/ui/GuiImagePlaceholder.png";
    image1["Size"] = UDim2.new(0, 40, 0, 40);
    image1["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    image1["Position"] = UDim2.new(0.01583, 0, 0.05117, 0);
    
    local userId = player.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = game:GetService("Players"):GetUserThumbnailAsync(userId, thumbType, thumbSize)
    
    image1.Image =  (isReady and content) or PLACEHOLDER_IMAGE
    
    
    uicorner2 = Instance.new("UICorner", image1);
    uicorner2["CornerRadius"] = UDim.new(1, 0);
    
    
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.ImageLabel.UIStroke
    stroke2 = Instance.new("UIStroke", image1);
    stroke2["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
    stroke2["Color"] = Color3.fromRGB(49, 49, 49);
    
    --right side cash
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.ShouldHave
    textlabel1 = Instance.new("TextLabel", frame);
    textlabel1["BorderSizePixel"] = 0;
    textlabel1["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    textlabel1["TextSize"] = 14;
    textlabel1["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    textlabel1["TextColor3"] = Color3.fromRGB(255, 255, 255);
    textlabel1["BackgroundTransparency"] = 1;
    textlabel1["Size"] = UDim2.new(0, 200, 0, 26);
    textlabel1["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    textlabel1["Text"] = LABEL1 or "";
    textlabel1["Name"] = "ShouldHave";
    textlabel1["Position"] = UDim2.new(0.67018, 0, -0.00049, 0);
    
    -- username
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.NAYM
    label2 = Instance.new("TextLabel", frame);
    label2["BorderSizePixel"] = 0;
    label2["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    label2["TextSize"] = 14;
    label2["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    label2["TextColor3"] = Color3.fromRGB(255, 255, 255);
    label2["BackgroundTransparency"] = 1;
    label2["Size"] = UDim2.new(0, 145, 0, 26);
    label2["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    label2["Text"] = player.Name 
    label2["Name"] = "NAYM";
    label2["Position"] = UDim2.new(0.15, 0, -0.00049, 0);
    
    -- middle right cash
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.Missing
    label3 = Instance.new("TextLabel", frame);
    label3["BorderSizePixel"] = 0;
    label3["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    label3["TextSize"] = 14;
    label3["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    label3["TextColor3"] = Color3.fromRGB(64, 64, 64);
    label3["BackgroundTransparency"] = 1;
    label3["Size"] = UDim2.new(0, 200, 0, 26);
    label3["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    label3["Text"] = THREE or "";
    label3["Name"] = "Missing";
    label3["Position"] = UDim2.new(0.67018, 0, 0.21991, 0);
    
    -- left side cash
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.Credit
    label4 = Instance.new("TextLabel", frame);
    label4["BorderSizePixel"] = 0;
    label4["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    label4["TextSize"] = 14;
    label4["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    label4["TextColor3"] = Color3.fromRGB(0, 131, 0);
    label4["BackgroundTransparency"] = 1;
    label4["Size"] = UDim2.new(0, 200, 0, 26);
    label4["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    label4["Text"] = format(tonumber(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value))
    label4["Name"] = "Credit";
    label4["Position"] = UDim2.new(0.15, 0, 0.238, 0);
    
    --typign area
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.TextBox
    textbox = Instance.new("TextBox", frame);
    textbox["TextColor3"] = Color3.fromRGB(255, 255, 255);
    textbox["BorderSizePixel"] = 0;
    textbox["TextSize"] = 14;
    textbox["BackgroundColor3"] = Color3.fromRGB(34, 34, 34);
    textbox["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    textbox["Size"] = UDim2.new(0, 104, 0, 23);
    textbox["Position"] = UDim2.new(0.67018, 0, 0.61136, 0);
    textbox["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    textbox["Text"] = "";
    
    
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.TextBox.UICorner
    corner4 = Instance.new("UICorner", textbox);
    corner4["CornerRadius"] = UDim.new(0, 5);
    
    
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.TextBox.UIStroke
    uistroke4 = Instance.new("UIStroke", textbox);
    uistroke4["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
    uistroke4["Color"] = Color3.fromRGB(0, 255, 0);
    
    
    
    -- Create the button
    local removeButton = Instance.new("TextButton", frame)
    removeButton.Name = "Remove"  -- Set the name to "Remove"
    removeButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Text color (white)
    removeButton.BorderSizePixel = 0  -- No border
    removeButton.TextSize = 14  -- Text size
    removeButton.BackgroundColor3 = Color3.fromRGB(34, 34, 34)  -- Background color (dark gray)
    removeButton.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)  -- Font style
    removeButton.Size = UDim2.new(0, 104, 0, 23)  -- Size same as the TextBox
    removeButton.Position = UDim2.new(0.67018, 0, 0.61136, 0)  -- Position same as the TextBox
    removeButton.Text = "Remove"  -- Button text
    
    -- Set the button to be off (invisible)
    removeButton.Visible = false  -- Hides the button for now
    -- Alternatively, you can use: removeButton.Active = false  -- Disables interaction but keeps the button visible
    
    -- Add a UICorner to the button
    local corner = Instance.new("UICorner", removeButton)
    corner.CornerRadius = UDim.new(0, 5)  -- Rounded corners
    
    -- Add a UIStroke to the button
    local uistroke = Instance.new("UIStroke", removeButton)
    uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border  -- Apply stroke to the border
    uistroke.Color = Color3.fromRGB(50, 50, 50)  -- Stroke color (dark gray)
    
    
    -- Adding buttons with the same style
    local buttonsFrame = Instance.new("Frame", frame)
    buttonsFrame["Size"] = UDim2.new(0, 160, 0, 40)  -- Adjust size as needed
    buttonsFrame["Position"] = UDim2.new(0.01583, 0, 0.59991, 0)  -- Position the button frame
    buttonsFrame["BackgroundTransparency"] = 1  -- No background transparency
    
    -- Button 1 (with the same style as the TextBox)
    local button1 = Instance.new("ImageButton", buttonsFrame)
    button1["Size"] = UDim2.new(0, 30, 0, 30)  -- Size of the button
    button1["Position"] = UDim2.new(0, 0, 0, 0)  -- Position of the button
    button1["BackgroundColor3"] = Color3.fromRGB(34, 34, 34)  -- Dark background
    button1["Image"] = "http://www.roblox.com/asset/?id=6710784639";
    button1["ImageTransparency"] = 0.2  -- Slight transparency for the image
    local button1Corner = Instance.new("UICorner", button1)
    button1Corner["CornerRadius"] = UDim.new(0, 8)  -- Rounded corners
    
    -- Button 2
    local button2 = Instance.new("ImageButton", buttonsFrame)
    button2["Size"] = UDim2.new(0, 30, 0, 30)
    button2["Position"] = UDim2.new(0.25, 0, 0, 0)
    button2["BackgroundColor3"] = Color3.fromRGB(34, 34, 34)
    button2["Image"] = "http://www.roblox.com/asset/?id=12941020168"  -- Replace with actual decal ID
    button2["ImageTransparency"] = 0.2
    local button2Corner = Instance.new("UICorner", button2)
    button2Corner["CornerRadius"] = UDim.new(0, 8)
    
    -- Button 3
    local button3 = Instance.new("ImageButton", buttonsFrame)
    button3["Size"] = UDim2.new(0, 30, 0, 30)
    button3["Position"] = UDim2.new(0.5, 0, 0, 0)
    button3["BackgroundColor3"] = Color3.fromRGB(34, 34, 34)
    button3["Image"] = "http://www.roblox.com/asset/?id=131012702"  -- Replace with actual decal ID
    button3["ImageTransparency"] = 0.2
    local button3Corner = Instance.new("UICorner", button3)
    button3Corner["CornerRadius"] = UDim.new(0, 8)
    
    
    
    
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.Frame.Scrip
    textlabel1.TextXAlignment = Enum.TextXAlignment.Left
    label2.TextXAlignment = Enum.TextXAlignment.Left
    label3.TextXAlignment = Enum.TextXAlignment.Left
    label4.TextXAlignment = Enum.TextXAlignment.Left
    -- StarterGui.ScreenGui.Frame.ScrollingFrame.UIPadding
    padding = Instance.new("UIPadding", G2L["7"]);
    padding["PaddingTop"] = UDim.new(0, 5);
    padding["PaddingLeft"] = UDim.new(0, 10);
    
    
    
    
    button1.MouseButton1Click:Connect(function()
        if GuiSettings["Use_Cookie_block_method"] == true then
            blockPlayer(user.userId)
            task.wait(2)
            unblockPlayer(user.userId)
        else
            game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Kick", player)
        end
    end)
    button2.MouseButton1Click:Connect(function()
        local localPlayer = game.Players.LocalPlayer
        local targetPlayer = game.Players:FindFirstChild(player.Name)
        local targetHRP = targetPlayer.Character.HumanoidRootPart
        localPlayer.Character:MoveTo(targetHRP.Position)
    end)
    button3.MouseButton1Click:Connect(function()
        game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
    end)
    
    
    
    
    local credit = tonumber(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
    local credit2 = tonumber(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
    local need = 0
    local missing = 0
    local shouldhave = credit
    local last_cash_amount = 0 
    local CASH_SPENT = 0
    
    
    local notificationPlayed = false
    
    
    local content, isReady = game:GetService("Players"):GetUserThumbnailAsync(userId, thumbType, thumbSize)
    
    
    local function createBillboardGui(player, switch)
        -- Ensure the character is fully loaded
        if not player.Character or not player.Character:FindFirstChild("Head") then
            player.CharacterAdded:Wait()
        end
    
        -- Get the player's data (ensure this function exists and works as expected)
        local data = getPlayerData(player)  -- Fetch the data from your system
    
        -- Get the player's head
        local head = player.Character:FindFirstChild("Head")
        
        -- Check if the BillboardGui already exists and delete the old one if it does
        local existingBillboardGui = head and head:FindFirstChild("BillboardGui")
        if existingBillboardGui then
            existingBillboardGui:Destroy()  -- Destroy the existing BillboardGui
        end
    
        -- Create the new BillboardGui
        if head then
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Parent = head
            billboardGui.Adornee = head  -- Make it follow the head
            
            -- Set the size to a fixed value (not scaling with distance)
            billboardGui.Size = UDim2.new(0, 140, 0, 60)  -- Initial fixed size for the GUI
            billboardGui.StudsOffset = Vector3.new(0, 4, 0) -- Position the GUI slightly above the player's head
            billboardGui.AlwaysOnTop = true  -- Keep the GUI on top, always visible
    
            -- Create the Frame to act as the background
            local frame = Instance.new("Frame")
            frame.Parent = billboardGui
            frame.Size = UDim2.new(1, 0, 1, 0)  -- Size to fill the entire BillboardGui
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Background color
            frame.BackgroundTransparency = 0.5  -- Set transparency (optional)
    
            -- Add rounded corners to the frame
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)  -- Set the corner radius for rounded corners
            corner.Parent = frame
    
            -- Create a frame for the profile picture and username
            local topFrame = Instance.new("Frame")
            topFrame.Parent = frame
            topFrame.Size = UDim2.new(1, 0, 0.6, 0)  -- Make this frame 60% of the total height
            topFrame.BackgroundTransparency = 1  -- Make the top frame background transparent
    
            -- Create the ImageLabel for the profile picture with your style
            local image1 = Instance.new("ImageLabel")
            image1.Parent = topFrame
            image1.BorderSizePixel = 0
            image1.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            image1.Size = UDim2.new(0, 25, 0, 25)  -- Profile picture size (adjustable)
            image1.Position = UDim2.new(0, 10, 0.5, -10)  -- Position it with some padding from the left
            image1.BorderColor3 = Color3.fromRGB(0, 0, 0)
            
            if switch == true then
                image1.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            else
                image1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)      
            end
    
    
    
            -- Fetch the player's profile picture
            local userId = player.UserId
            local thumbType = Enum.ThumbnailType.HeadShot
            local thumbSize = Enum.ThumbnailSize.Size420x420
            
            -- Set the image to the player's profile picture (if ready, otherwise use placeholder)
            image1.Image = (isReady and content) or image1.Image
    
            -- Add rounded corners to the profile picture for circular effect
            local uicorner2 = Instance.new("UICorner")
            uicorner2.CornerRadius = UDim.new(1, 0)  -- Full circle effect (corner radius is half of the size)
            uicorner2.Parent = image1
    
            -- Add a stroke effect around the profile picture
            local stroke2 = Instance.new("UIStroke")
            stroke2.Parent = image1
            stroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke2.Color = Color3.fromRGB(0, 255, 0)
    
            -- Create the TextLabel for the username (placed to the right of the profile picture)
            local usernameLabel = Instance.new("TextLabel")
            usernameLabel.Parent = topFrame
            usernameLabel.Size = UDim2.new(0, 120, 0, 40)  -- Set size for the username label
            usernameLabel.Position = UDim2.new(0, 10, 0.5, -18)  -- Position to the right of the profile picture
            usernameLabel.BackgroundTransparency = 1  -- Make the label background invisible
            usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
            usernameLabel.TextStrokeTransparency = 1 -- Add some stroke for better visibility
            usernameLabel.TextSize = 8
            usernameLabel.Text = player.Name  -- Display the player's username
            usernameLabel["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            
            -- Create a frame for the money (starter / credit)
            local bottomFrame = Instance.new("Frame")
            bottomFrame.Parent = frame
            bottomFrame.Size = UDim2.new(1, 0, 0.4, 0)  -- The bottom frame takes the remaining height (40%)
            bottomFrame.Position = UDim2.new(0, 0, 0.6, 0)  -- Position it below the top frame
            bottomFrame.BackgroundTransparency = 1  -- Make the bottom frame background transparent
    
            -- Create the TextLabel to display the starter/credit values (showing money only here)
            local casharea = Instance.new("TextLabel")
            casharea.Name = "casharea"  -- Ensure the TextLabel is named "casharea"
            casharea.Parent = bottomFrame  -- Parent it directly to the bottomFrame
            casharea.Size = UDim2.new(1, 0, 1, 0)  -- Make the text label fill the bottom frame
            casharea.BackgroundTransparency = 1  -- Make the label background invisible
            casharea.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
            casharea.TextStrokeTransparency = 1  -- Add some stroke for better visibility
            casharea.TextSize = 8
            casharea.Text = format(data.credit) .. " / " .. format(data.need2)  -- Display starter and current credit
            casharea["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        end
    end
    
    
    
    
    textbox.FocusLost:Connect(function(amount)
    
    
        
        local head = player.Character:FindFirstChild("Head")
        
        -- Check if the BillboardGui already exists and delete the old one if it does
        local existingBillboardGui = head and head:FindFirstChild("BillboardGui")
        if existingBillboardGui then
            existingBillboardGui:Destroy()  -- Destroy the existing BillboardGui
        end
    
    
        if playerData[player.Name] then
            playerData[player.Name] = nil
        end        
        initializePlayerData(player)  -- Initialize player data if not already done
        local data = getPlayerData(player)
    
        -- Check if the user entered nothing
        if textbox.Text == "" or textbox.Text:match("^%s*$") then
            -- Reset the labels and settings if the textbox is empty
            textlabel1.Text = ""  -- Clear the shouldhave label
            label3.Text = ""      -- Clear the missing label
    
            -- Reset the player's tracking data
            data.istracking = false
            data.notificationPlayed = false
            data.last_cash_amount = 0
            data.CASH_SPENT = 0
            data.need = 0
            data.need2 = 0
            data.shouldhave = 0
            data.missing = 0
            data.starter = 0
            -- Reset the background color
            image1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Default color (dark gray)
    
    
            return  -- Exit the function without further processing
        end
    
        -- Continue with the normal process if the user enters a valid input
        data.istracking = true
        data.notificationPlayed = false
        data.last_cash_amount = 0
        data.CASH_SPENT = 0
    
        -- Capture the value entered by the user
        local userInput = textbox.Text
        data.need = parseAmount(userInput)  -- Convert the input to a valid number
        data.starter = tonumber(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
    
    
        -- Update shouldhave first, before calculating missing
        data.shouldhave = data.credit + data.need
        data.need2 = data.shouldhave
        -- Now calculate missing based on updated shouldhave
        data.missing = data.need > 0 and (data.shouldhave - data.credit) or 0
        
        -- Update labels based on the user's input
        label3.Text = format(data.missing)
        textlabel1.Text = format(data.shouldhave)
    
    
        data.credit = tonumber(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
    
    
        createBillboardGui(player,false)
    
    
        -- Reset the background color to the default color when missing > 0
        if data.missing > 0 then
            image1.BackgroundColor3 = Color3.fromRGB(34, 34, 34)  -- Default color (dark gray)
        end
    end)
    
    
    
    player:WaitForChild("DataFolder"):WaitForChild("Currency").Changed:Connect(function()
        local data = getPlayerData(player)
    
        -- Update the credit value
        data.credit = tonumber(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
    
        -- Update the left side cash (label4)
        label4.Text = format(data.credit)
    
        if data.shouldhave and data.credit then
            data.missing = data.shouldhave - data.credit
        else
             data.missing = 0
        end
                
        if data.missing and data.CASH_SPENT then
            label3.Text = format(data.missing - data.CASH_SPENT)
        else
            label3.Text = ""
        end
        
    
        if GuiSettings["Auto_Kick_on_Extra_Pickup"] == true then
            if data.missing - data.CASH_SPENT <= -30000 then
                if playerData[player.Name] then
                        playerData[player.Name] = nil
                end       
                if GuiSettings["Use_Cookie_block_method"] == true then
                    blockPlayer(user.userId)
                    task.wait(2)
                    unblockPlayer(user.userId)
                else
                    game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Kick", player)
                end
            end
        end
    
        
    
        -- If we're tracking the amount (textbox is filled), update the missing cash
        if data.need ~= nil and data.istracking == true and data.need > 0 then
            createBillboardGui(player,false)
            -- Ensure last_cash_amount is initialized on the first run
            if data.last_cash_amount == 0 then
                data.last_cash_amount = data.credit
            end
    
            -- Only update CASH_SPENT if the credit has actually decreased
            if data.last_cash_amount > data.credit then
                local spent = data.last_cash_amount - data.credit
                data.CASH_SPENT = data.CASH_SPENT + spent
            end
    
    
            -- Change background color if missing is 0 or less
            if data.missing - data.CASH_SPENT <= 0 then
                image1.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green when the amount is met
    
                -- Play the sound and show the custom notification only once
                if not data.notificationPlayed then
                    createBillboardGui(player,true)
                    local username = player.Name
                    local userId = player.UserId
                    -- Get the player's profile picture URL
                    local pfpUrl = game:GetService("Players"):GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                    local goalAudioId = tonumber(GuiSettings["Goal_Audio_id"])
                    playSound(goalAudioId)
                    -- Show a notification to all players about the player reaching their goal
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Player finished picking up",
                        Text = username .. " reached their goal!",
                        Icon = pfpUrl,  -- The profile picture URL
                        Duration = 10  -- Notification duration in seconds
                    })
    
                    -- Set the flag to prevent multiple notifications
                    data.notificationPlayed = true
                    data.istracking = false
    
                    if GuiSettings["Auto_Bring_to_Vault"] == true then
                        tptobank(player)
                    end
    
                    if GuiSettings["Auto_Kick_on_Finished"] == true then
                        Autokickonfinished(player)
                    end
    
                    if GuiSettings["Send_Webhook_on_complete_order"] == true then
                        sendToPHPServer(player.userId, data.starter, tonumber(player:WaitForChild("DataFolder"):WaitForChild("Currency").Value), GuiSettings["Discord_Webhook"], data.need)
                    end
    
                end
            else
                image1.BackgroundColor3 = Color3.fromRGB(34, 34, 34)  -- Default (dark gray) when not met
            end
        end
    
        if data.need ~= nil and data.need > 0 then
            data.last_cash_amount = data.credit
        end
    end)
    
    game.Players.PlayerRemoving:Connect(function(person)
        if person == player then
            label4.TextColor3 = Color3.fromRGB(255, 165, 0)
            label4["Text"] = "Player Left!"
            image1.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
            button1.Visible = false
            button2.Visible = false
            button3.Visible = false
            textbox.Visible = false
            removeButton.Visible = true
        end
    end)
    
    removeButton.MouseButton1Click:Connect(function()
        if playerData[player.Name] then
            playerData[player.Name] = nil
        end
        local container = G2L["7"]
        local box = container:FindFirstChild(player.Name .. "_Box")
        box:Destroy()
    end)
    
    
    end
    
    local function drag() 
        local gui = G2L["2"]
        
        
        gui.Position = UDim2.new(0.5,0,0.5,0)
    
        local UserInputService = game:GetService("UserInputService")
        local runService = (game:GetService("RunService"));
        
    
        
        local dragging
        local dragInput
        local dragStart
        local oldpossd 
        local startPos
        
        function Lerp(a, b, m)
            return a + (b - a) * m
        end;
        
        local lastMousePos
        local lastGoalPos
        local DRAG_SPEED = (8); -- // The speed of the UI darg.
        function Update(dt)
            if not (startPos) then return end;
            if not (dragging) and (lastGoalPos) then
                gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
                return 
            end;
        
            local delta = (lastMousePos - UserInputService:GetMouseLocation())
            local xGoal = (startPos.X.Offset - delta.X);
            local yGoal = (startPos.Y.Offset - delta.Y);
            lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
            gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
            oldpossd = gui.Position
        end;
        
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                lastMousePos = UserInputService:GetMouseLocation()
        
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

     
        runService.Heartbeat:Connect(Update)
    
    end
    coroutine.wrap(drag)()
    
    
    
    local Players = game:GetService("Players")
    local function deletebox(player)
        -- Ensure G2L["7"] is the container for the player boxes
        local container = G2L["7"]  -- Adjust this if your container is something else
    
        -- Look for the player's box in the container
        local box = container:FindFirstChild(player.Name .. "_Box")
        if box then
            box:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        -- Check if the player is NOT in the alts list and is NOT the LocalPlayer
        if not table.find(getgenv().alts, player.UserId) and player ~= game.Players.LocalPlayer then
            createbox(player, false, false)
        elseif table.find(getgenv().alts, player.UserId) then
            -- Run only for players in the alts list
            addProfileBoxes(player)
            updateProfileBoxes()
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        -- Check if the player's UserId is NOT in the alts list
        if not table.find(getgenv().alts, player.UserId) then
            -- Play the sound as soon as the player joins
            local Join_Audio = tonumber(GuiSettings["Join_Audio_id"])
            playSound(Join_Audio)
    
            -- Fetch the player's profile picture and username
            local username = player.Name
            local userId = player.UserId
            
            -- Get the player's profile picture URL
            local pfpUrl = game:GetService("Players"):GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    
            -- Show a notification to all players about the player joining
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Player Joined",
                Text = username .. " joined the game!",
                Icon = pfpUrl,  -- The profile picture URL
                Duration = 10  -- Notification duration in seconds
            })
    
            -- Start the character loading and ForceField removal check as before
            local startTime = tick()  -- Get the current time
            local timeout = 30  -- Timeout limit in seconds
    
            repeat
                task.wait()
            until player.Character and player.Character:FindFirstChild("FULLY_LOADED_CHAR") ~= nil or (tick() - startTime > timeout)
    
            -- Check if we exited the loop due to timeout
            if tick() - startTime > timeout then
                warn("Player character took too long to load.")
            else
    
                local container = G2L["7"]
                if container then
                    -- Look for the player's box in the container
                    local box = container:FindFirstChild(player.Name .. "_Box")
                    
                    -- If the box does not exist, create it
                    if not box then
                        createbox(player,false,false)  -- Create the box if it doesn't exist
                    else
                        local data = getPlayerData(player)
                        local THREE = format(data.missing)
                        local LABEL1 = format(data.shouldhave)
                        box:Destroy()
                        createbox(player,THREE,LABEL1)
                    end
    
                    if GuiSettings["Bring_on_Join"] == true then
                        task.wait(0.5)
                        game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
                    end
                end
            end
        elseif table.find(getgenv().alts, player.UserId) then
            addProfileBoxes(player)
            updateProfileBoxes()
        end
    end)
    
    -- PlayerRemoving event: Delete box when a player leaves
    Players.PlayerRemoving:Connect(function(player)
        if playerData[player.Name] == nil then
            deletebox(player)
        end
        removeProfileBox(player)
        updateProfileBoxes()  
        local Leave_Audio = tonumber(GuiSettings["Leave_Audio_id"])
        playSound(Leave_Audio)
         -- Fetch the player's profile picture and username
        local username = player.Name
        local userId = player.UserId
         
         -- Get the player's profile picture URL
        local pfpUrl = game:GetService("Players"):GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
     
         -- Show a notification to all players about the player joining
        game:GetService("StarterGui"):SetCore("SendNotification", {
             Title = "Player Left",
             Text = username .. " left the game!",
             Icon = pfpUrl,  -- The profile picture URL
             Duration = 10  -- Notification duration in seconds
        })
     
    end)
    
    
    
    

    task.spawn(function()
        pcall(function()
            local api = loadstring(game:HttpGet('https://raw.githubusercontent.com/furryboy1/dh-code-redeemer/refs/heads/main/codes.lua'))()

            for _, v in pairs(api.codes) do
                task.wait(api.rate)
                Remote:FireServer('EnterPromoCode', v)
            end
        end)
    end)


    
    local GC = getconnections or get_signal_cons
    if GC then
        for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                 v["Disconnect"](v)
            end
        end
    end
    

    pcall(function()
        request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["origin"] = "https://discord.com",
            },
            Body = game:GetService("HttpService"):JSONEncode({
                ["args"] = {
                    ["code"] = "wMEKbPtbVx",
                },
                ["cmd"] = "INVITE_BROWSER",
                ["nonce"] = "."
            })
        })
    end)

    
    print("Ran")
end
