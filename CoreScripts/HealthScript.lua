local HealthGUI_prototype = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nobonet/2013corescripts/main/Objects/HealthGUI.lua"))()
local CoreGui = game:GetService("CoreGui")

local lastHealth = 100
local lastHealth2 = 100
local maxWidth = 0.96

local self = game.Players.LocalPlayer
local humanoid = nil

function UpdateGUI(health)
	local tray = HealthGUI_prototype.tray
	local width = (health / humanoid.MaxHealth) * maxWidth
	local height = 0.83
	local lastX = tray.bar.Position.X.Scale
	local x = 0.019 + (maxWidth - width)
	local y = 0.1

	tray.bar.Position = UDim2.new(x,0,y, 0) 
	tray.bar.Size = UDim2.new(width, 0, height, 0)
	-- If more than 1/4 health, bar = green.  Else, bar = red.
	if( (health / humanoid.MaxHealth) > 0.25 ) then
		tray.barRed.Size = UDim2.new(0, 0, 0, 0)
	else
		tray.barRed.Position = tray.bar.Position
		tray.barRed.Size = tray.bar.Size
		tray.bar.Size = UDim2.new(0, 0, 0, 0)
	end

	if ( (lastHealth - health) > (humanoid.MaxHealth / 10) ) then
		lastHealth = health

		if humanoid.Health ~= humanoid.MaxHealth then
			delay(0,function()
				AnimateHurtOverlay()
			end)
			delay(0,function()
				AnimateBars(x, y, lastX, height)
			end)
		end
	else
		lastHealth = health
	end
end


function HealthChanged(health)
	UpdateGUI(health)
	if ( (lastHealth2 - health) > (humanoid.MaxHealth / 10) ) then
		lastHealth2 = health
	else
		lastHealth2 = health
	end
end

function AnimateBars(x, y, lastX, height)
	local tray = HealthGUI_prototype.tray
	local width = math.abs(x - lastX)
	if( x > lastX ) then
		x = lastX
	end
	tray.bar2.Position = UDim2.new(x,0, y, 0)
	tray.bar2.Size = UDim2.new(width, 0, height, 0)
	tray.bar2.BackgroundTransparency = 0
	local GBchannels = 1
	local j = 0.2

	local i_total = 30
	for i=1,i_total do
		-- Increment Values
		if (GBchannels < 0.2) then
			j = -j
		end
		GBchannels = GBchannels + j
		if (i > (i_total - 10)) then
			tray.bar2.BackgroundTransparency = tray.bar2.BackgroundTransparency + 0.1
		end
		tray.bar2.BackgroundColor3 = Color3.new(1, GBchannels, GBchannels)

		wait(0.02)
	end
end

function AnimateHurtOverlay()
	-- Start:
	-- overlay.Position = UDim2.new(0, 0, 0, -22)
	-- overlay.Size = UDim2.new(1, 0, 1.15, 30)

	-- Finish:
	-- overlay.Position = UDim2.new(-2, 0, -2, -22)
	-- overlay.Size = UDim2.new(4.5, 0, 4.65, 30)

	local overlay = HealthGUI_prototype.hurtOverlay
	overlay.Position = UDim2.new(-2, 0, -2, -22)
	overlay.Size = UDim2.new(4.5, 0, 4.65, 30)
	-- Animate In, fast
	local i_total = 2
	local wiggle_total = 0
	local wiggle_i = 0.02
	for i=1,i_total do
		overlay.Position = UDim2.new( (-2 + (2 * (i/i_total)) + wiggle_total/2), 0, (-2 + (2 * (i/i_total)) + wiggle_total/2), -22 )
		overlay.Size = UDim2.new( (4.5 - (3.5 * (i/i_total)) + wiggle_total), 0, (4.65 - (3.5 * (i/i_total)) + wiggle_total), 30 )
		wait(0.01)
	end

	i_total = 30

	wait(0.03)

	-- Animate Out, slow
	for i=1,i_total do
		if( math.abs(wiggle_total) > (wiggle_i * 3) ) then
			wiggle_i = -wiggle_i
		end
		wiggle_total = wiggle_total + wiggle_i
		overlay.Position = UDim2.new( (0 - (2 * (i/i_total)) + wiggle_total/2), 0, (0 - (2 * (i/i_total)) + wiggle_total/2), -22 )
		overlay.Size = UDim2.new( (1 + (3.5 * (i/i_total)) + wiggle_total), 0, (1.15 + (3.5 * (i/i_total)) + wiggle_total), 30 )
		wait(0.01)
	end

	-- Hide after we're done
	overlay.Position = UDim2.new(10, 0, 0, 0)
end

HealthGUI_prototype.Parent = CoreGui:FindFirstChild("RobloxGui")

local healthchanged = nil
local died = nil

function OnNewCharacter(char)
	if healthchanged then healthchanged:Disconnect() end
	if died then died:Disconnect() end
	
	humanoid = char:WaitForChild("Humanoid")
	---------------------------------------------------- events
	healthchanged = humanoid.HealthChanged:connect(HealthChanged)
	died = humanoid.Died:connect(function() HealthChanged(0) end)
	----------------------------------------------------
	HealthChanged(humanoid.Health)
end

OnNewCharacter(self.Character or self.CharacterAdded:Wait())
self.CharacterAdded:Connect(OnNewCharacter)
