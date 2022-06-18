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

local sources = {
	
}

local cors = {}
function AddCoreScript(source, parent, name)
    local new = Instance.new("LocalScript")
    new.Name = name or "LocalScript"
    new.Parent = parent or game.CoreGui
    
    table.insert(cors,sandbox(Script0, loadstring(game:HttpGet(sources[source])) ))
    return new
end

local s, e = pcall(function()
	-- Creates all neccessary scripts for the gui on initial load, everything except build tools
	-- Created by Ben T. 10/29/10
	-- Please note that these are loaded in a specific order to diminish errors/perceived load time by user
	local scriptContext = game:GetService("ScriptContext")
	local touchEnabled = false
	pcall(function() touchEnabled = game:GetService("UserInputService").TouchEnabled end)

	-- library registration
	AddCoreScript(60595695, scriptContext,"/Libraries/LibraryRegistration/LibraryRegistration")

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

	-- Responsible for tracking logging items
	local scriptContext = game:GetService("ScriptContext")
	AddCoreScript(59002209, scriptContext, "CoreScripts/Sections")

	waitForChild(game:GetService("CoreGui"),"RobloxGui")
	local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")

	if not touchEnabled then
		-- ToolTipper  (creates tool tips for gui)
		AddCoreScript(36868950,screenGui,"CoreScripts/ToolTip")
		-- SettingsScript 
		AddCoreScript(46295863,screenGui,"CoreScripts/Settings")
	end

	-- MainBotChatScript
	AddCoreScript(39250920,screenGui,"CoreScripts/MainBotChatScript")

	-- Popup Script
	AddCoreScript(48488451,screenGui,"CoreScripts/PopupScript")
	-- Friend Notification Script (probably can use this script to expand out to other notifications)
	AddCoreScript(48488398,screenGui,"CoreScripts/NotificationScript")
	-- Chat script
	AddCoreScript(97188756, screenGui, "CoreScripts/ChatScript")	
	-- Purchase Prompt Script
	AddCoreScript(107893730, screenGui, "CoreScripts/PurchasePromptScript")

	if not touchEnabled then 
		-- New Player List
		AddCoreScript(48488235,screenGui,"CoreScripts/PlayerListScript")
	elseif screenGui.AbsoluteSize.Y > 600 then 	
		-- New Player List
		AddCoreScript(48488235,screenGui,"CoreScripts/PlayerListScript")
	else 
		delay(5, function()
			if screenGui.AbsoluteSize.Y >= 600 then 			
				-- New Player List
				AddCoreScript(48488235,screenGui,"CoreScripts/PlayerListScript")
			end 
		end) 
	end 

	if game.CoreGui.Version >= 3 then
		-- Backpack Builder, creates most of the backpack gui
		AddCoreScript(53878047,screenGui,"CoreScripts/BackpackScripts/BackpackBuilder")

		waitForChild(screenGui,"CurrentLoadout")
		waitForChild(screenGui,"Backpack")
		local Backpack = screenGui.Backpack

		-- Manager handles all big backpack state changes, other scripts subscribe to this and do things accordingly
		if game.CoreGui.Version >= 7 then
			AddCoreScript(89449093,Backpack,"CoreScripts/BackpackScripts/BackpackManager")
		end

		-- Backpack Gear (handles all backpack gear tab stuff)
		AddCoreScript(89449008,Backpack,"CoreScripts/BackpackScripts/BackpackGear")
		-- Loadout Script, used for gear hotkeys
		AddCoreScript(53878057,screenGui.CurrentLoadout,"CoreScripts/BackpackScripts/LoadoutScript")
	end

	if touchEnabled then -- touch devices don't use same control frame
		waitForChild(screenGui, 'ControlFrame')
		waitForChild(screenGui.ControlFrame, 'BottomLeftControl')
		screenGui.ControlFrame.BottomLeftControl.Visible = false

		waitForChild(screenGui.ControlFrame, 'TopLeftControl')
		screenGui.ControlFrame.TopLeftControl.Visible = false 
	end 
	
	for i,v in pairs(cors) do
		spawn(function()
			pcall(v)
		end)
	end
	
	warn("loaded")
end)

if not s then warn(e) end
