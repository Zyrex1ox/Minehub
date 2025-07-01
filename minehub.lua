-- MineHub v2 - ThunderZ Style by Zyrex1ox -- Features: Tabs, Fruit Filter, Player Mods, Auto Collect, Chill Mode

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local Lighting = game:GetService("Lighting") local player = Players.LocalPlayer local char = player.Character or player.CharacterAdded:Wait() local hrp = char:WaitForChild("HumanoidRootPart") local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")) gui.Name = "MineHubV2"

-- UI LIBRARY (minimal tab framework) local Tabs = {} local selectedTab = nil local mainFrame = Instance.new("Frame", gui) mainFrame.Size = UDim2.new(0, 400, 0, 300) mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) mainFrame.Visible = true mainFrame.Name = "MainFrame" Instance.new("UICorner", mainFrame)

local tabHolder = Instance.new("Frame", mainFrame) tabHolder.Size = UDim2.new(0, 400, 0, 30) tabHolder.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabHolder.Name = "TabHolder"

local contentFrame = Instance.new("Frame", mainFrame) contentFrame.Position = UDim2.new(0, 0, 0, 30) contentFrame.Size = UDim2.new(1, 0, 1, -30) contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) contentFrame.Name = "ContentFrame"

function addTab(name) local tabBtn = Instance.new("TextButton", tabHolder) tabBtn.Size = UDim2.new(0, 100, 1, 0) tabBtn.Text = name tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) tabBtn.TextColor3 = Color3.new(1, 1, 1) tabBtn.Name = name

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 1, 0)
tabFrame.BackgroundTransparency = 1
tabFrame.Visible = false
tabFrame.Name = name
tabFrame.Parent = contentFrame

tabBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(contentFrame:GetChildren()) do
        child.Visible = false
    end
    tabFrame.Visible = true
end)

Tabs[name] = tabFrame

end

addTab("Main") addTab("Farm") addTab("Player") addTab("Visuals")

-- Example content in Main tab local startBtn = Instance.new("TextButton", Tabs["Main"]) startBtn.Size = UDim2.new(0, 180, 0, 40) startBtn.Position = UDim2.new(0, 10, 0, 10) startBtn.Text = "Start Farm 🟩" startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) Instance.new("UICorner", startBtn)

local collecting = false startBtn.MouseButton1Click:Connect(function() collecting = not collecting if collecting then startBtn.Text = "Stop Farm 🟥" startBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- start collect task (to be expanded) else startBtn.Text = "Start Farm 🟩" startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) end end)

-- Chill Mode local chillToggle = Instance.new("TextButton", Tabs["Visuals"]) chillToggle.Size = UDim2.new(0, 180, 0, 40) chillToggle.Position = UDim2.new(0, 10, 0, 10) chillToggle.Text = "Chill Mode: OFF" chillToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100) Instance.new("UICorner", chillToggle)

local chillOn = false chillToggle.MouseButton1Click:Connect(function() chillOn = not chillOn if chillOn then chillToggle.Text = "Chill Mode: ON" Lighting.GlobalShadows = false Lighting.FogEnd = 1000000 for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then obj.Enabled = false end end else chillToggle.Text = "Chill Mode: OFF" Lighting.GlobalShadows = true Lighting.FogEnd = 1000 end end)

-- Tabs default Tabs["Main"].Visible = true
