local git = "https://raw.githubusercontent.com/Nobonet/2013corescripts/main"
local CoreGui = game:GetService("CoreGui")

local function sandbox(var,func)
	local env = getfenv(func)
	local newenv = setmetatable({},{
		__index = function(self,k)
			if k=="script" then
				return var
			else
				return env[k]
			end
		end,
	})
	setfenv(func,newenv)
	return func
end

local cors = {}
function AddCoreScript(source, parent, name)
    local new = Instance.new("LocalScript")
    new.Name = name or "LocalScript"
    new.Parent = parent or game.CoreGui
    
    table.insert(cors,sandbox(Script0, loadstring(game:HttpGet(git..source)) ))
    return new
end

local s,e = pcall(function()
	CoreGui:WaitForChild("RobloxGui"):Destroy()
	CoreGui:WaitForChild("PlayerList"):Destroy()
	--
	Instance.new("ScreenGui", CoreGui).Name = "RobloxGui"
	
    -- Creates all neccessary scripts for the gui on initial load, everything except build tools
    -- Created by Ben T. 10/29/10
    -- Please note that these are loaded in a specific order to diminish errors/perceived load time by user
    local scriptContext = game:GetService("ScriptContext")
    local touchEnabled = false
    pcall(function() touchEnabled = game:GetService("UserInputService").TouchEnabled end)

    local function waitForChild(instance, name)
    	while not instance:FindFirstChild(name) do
    		instance.ChildAdded:wait()
    	end
    end
    local function waitForProperty(instance, property)
    	while not instance[property] do
    		instance.Changed:wait()
    	end
    end
    
    waitForChild(CoreGui),"RobloxGui")
    local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
    
    if not touchEnabled then
    	-- ToolTipper  (creates tool tips for gui)
    	AddCoreScript("/CoreScripts/ToolTip.lua",screenGui,"CoreScripts/ToolTip")
    	-- SettingsScript 
    	AddCoreScript("/CoreScripts/Settings.lua",screenGui,"CoreScripts/Settings")
    end
    
    -- MainBotChatScript
    AddCoreScript("/CoreScripts/DialogScript.lua",screenGui,"CoreScripts/MainBotChatScript")
    
    -- Popup Script
    AddCoreScript("/CoreScripts/PopupScript.lua",screenGui,"CoreScripts/PopupScript")
    -- Friend Notification Script (probably can use this script to expand out to other notifications)
    AddCoreScript("/CoreScripts/NotificationScript.lua",screenGui,"CoreScripts/NotificationScript")
    -- Chat script
    AddCoreScript("/CoreScripts/ChatScript.lua", screenGui, "CoreScripts/ChatScript")	
    -- Purchase Prompt Script
    AddCoreScript("/CoreScripts/PurchasePromptScript.lua", screenGui, "CoreScripts/PurchasePromptScript")
    
    if not touchEnabled then 
    	-- New Player List
    	AddCoreScript("/CoreScripts/PlayerList.lua",screenGui,"CoreScripts/PlayerListScript")
    elseif screenGui.AbsoluteSize.Y > 600 then 	
    	-- New Player List
    	AddCoreScript("/CoreScripts/PlayerList.lua",screenGui,"CoreScripts/PlayerListScript")
    else 
    	delay(5, function()
    		if screenGui.AbsoluteSize.Y >= 600 then 			
    			-- New Player List
    			AddCoreScript("/CoreScripts/PlayerList.lua",screenGui,"CoreScripts/PlayerListScript")
    		end 
    	end) 
    end 
    
    -- Backpack Builder, creates most of the backpack gui
    AddCoreScript("/CoreScripts/Backpack/BackpackBuilder.lua",screenGui,"CoreScripts/BackpackScripts/BackpackBuilder")
    
    waitForChild(screenGui,"CurrentLoadout")
    waitForChild(screenGui,"Backpack")
    local Backpack = screenGui.Backpack
    	
    -- Manager handles all big backpack state changes, other scripts subscribe to this and do things accordingly

    AddCoreScript("/CoreScripts/Backpack/BackpackManager.lua",Backpack,"CoreScripts/BackpackScripts/BackpackManager")
    	
    -- Backpack Gear (handles all backpack gear tab stuff)
    AddCoreScript("/CoreScripts/Backpack/BackpackGear.lua",Backpack,"CoreScripts/BackpackScripts/BackpackGear")
    -- Loadout Script, used for gear hotkeys
    AddCoreScript("/CoreScripts/Backpack/LoadoutScript.lua",screenGui.CurrentLoadout,"CoreScripts/BackpackScripts/LoadoutScript")
    
    -----------------------------------------------------------------
    for i,v in pairs(cors) do
    	spawn(function()
    		pcall(v)
    	end)
    end
	
	warn("loaded")
end)


if not s then warn(e) end
