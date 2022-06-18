-- obsolete?

-- Library Registration Script
-- This script is used to register RbxLua libraries on game servers, so game scripts have
-- access to all of the libraries (otherwise only local scripts do)

-- obsolete?

-- Library Registration Script
-- This script is used to register RbxLua libraries on game servers, so game scripts have
-- access to all of the libraries (otherwise only local scripts do)

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
    
    table.insert(cors,sandbox(Script0, loadstring(game:HttpGet(source)) ))
    return new
end

for i,v in pairs(cors) do
	spawn(function()
    	pcall(v)
    end)
end

--[[

local deepakTestingPlace = 3569749
local sc = game:GetService("ScriptContext")
local tries = 0
 
while not sc and tries < 3 do
	tries = tries + 1
	sc = game:GetService("ScriptContext")
	wait(0.2)
end
 
if sc then
	sc:RegisterLibrary("Libraries/RbxGui", "45284430")
	sc:RegisterLibrary("Libraries/RbxGear", "45374389")
	if game.PlaceId == deepakTestingPlace then
		sc:RegisterLibrary("Libraries/RbxStatus", "52177566")
	end
	sc:RegisterLibrary("Libraries/RbxUtility", "60595411")
	sc:RegisterLibrary("Libraries/RbxStamper", "73157242")
	sc:LibraryRegistrationComplete()
else
	print("failed to find script context, libraries did not load")
end

]]
