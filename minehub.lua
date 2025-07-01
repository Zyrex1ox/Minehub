local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local collecting = false
local fruitFilter = {"Tomato", "Summer Fruit"}
local collectDistance = 25

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MineHub"
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 180, 0, 45)
toggleBtn.Position = UDim2.new(1, -190, 1, -70)
toggleBtn.Text = "🟩 START FARMING"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 70)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
Instance.new("UICorner", toggleBtn)

local function isFruitTarget(name)
	for _, fruit in pairs(fruitFilter) do
		if string.lower(name):find(string.lower(fruit)) then
			return true
		end
	end
	return false
end

local function tpToGear()
	local gears = {"Trowel", "Sprinkler", "Watering Can", "Harvest Shovel", "Moon Cat"}
	for _, obj in pairs(workspace:GetDescendants()) do
		for _, gear in pairs(gears) do
			if obj.Name:lower():find(gear:lower()) and (obj:IsA("Model") or obj:IsA("Tool") or obj:IsA("BasePart")) then
				local part = obj:IsA("Model") and obj.PrimaryPart or obj
				if part then
					hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
					task.wait(1.5)
				end
			end
		end
	end
end

local function autoSubmit()
	for _, npc in pairs(workspace:GetDescendants()) do
		if npc:IsA("Model") and npc.Name:find("Summer Fruit NPC") then
			local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt then
				hrp.CFrame = npc:GetModelCFrame() + Vector3.new(0, 2, 0)
				task.wait(0.5)
				fireproximityprompt(prompt)
			end
		end
	end
end

local function skipDialog()
	for _, b in pairs(player.PlayerGui:GetDescendants()) do
		if b:IsA("TextButton") and (b.Text:lower():find("next") or b.Text:lower():find("submit")) then
			pcall(function() b:Activate() end)
		end
	end
end

local function startCollect()
	collecting = true
	toggleBtn.Text = "🟥 STOP FARMING"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

	task.spawn(function()
		while collecting do
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent:IsA("BasePart") then
					local part = obj.Parent
					if isFruitTarget(part.Name) and (hrp.Position - part.Position).Magnitude <= collectDistance then
						firetouchinterest(hrp, part, 0)
						task.wait(0.05)
						firetouchinterest(hrp, part, 1)
					end
				end
			end
			tpToGear()
			autoSubmit()
			skipDialog()
			task.wait(3)
		end
	end)
end

toggleBtn.MouseButton1Click:Connect(function()
	if collecting then
		collecting = false
		toggleBtn.Text = "🟩 START FARMING"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 70)
	else
		startCollect()
	end
end)
