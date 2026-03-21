-- LAM HUB | BLOX FRUITS SCRIPT
-- Version: 1.0
-- ສ້າງຂຶ້ນສຳລັບ Auto Farm ຄົບຊຸດ

-- ປ້ອງກັນການຮັນຫຼາຍຄັ້ງ
if _G.LAM_HUB_LOADED then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "LAM HUB",
        Text = "ສະຄິບຖືກໂຫຼດແລ້ວ!",
        Duration = 3
    })
    return
end
_G.LAM_HUB_LOADED = true

-- ສ້າງ GUI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- ຕົວແປສຳລັບສະຖານະການທຳງານ
local Settings = {
    AutoFarm = false,
    AutoQuest = false,
    AutoCollect = false,
    AutoBoss = false,
    AutoLevel = false,
    AutoStats = false,
    Teleport = false,
    ESP = false,
    SelectedNPC = "Bandit",
    SelectedBoss = "Greybeard",
    FarmRadius = 500,
    WalkSpeed = 16,
    JumpPower = 50,
    SelectedStat = "Melee"
}

-- ສ້າງ ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LAM_HUB"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ສ້າງເມນູຫຼັກ
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true

-- ເພີ່ມເງົາ
local Shadow = Instance.new("UICorner")
Shadow.CornerRadius = UDim.new(0, 12)
Shadow.Parent = MainFrame

-- ແຖບຫົວຂໍ້
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "LAM HUB | BLOX FRUITS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.Size = UDim2.new(0, 40, 1, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.LAM_HUB_LOADED = false
end)

-- ສ້າງ Tab Buttons
local Tabs = {}
local TabContents = {}

local TabFrame = Instance.new("Frame")
TabFrame.Parent = MainFrame
TabFrame.BackgroundTransparency = 1
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.Size = UDim2.new(1, 0, 0, 40)

local TabsList = {"Farm", "Boss", "Teleport", "Player", "Settings"}

for i, tabName in ipairs(TabsList) do
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = TabFrame
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TabButton.BorderSizePixel = 0
    TabButton.Position = UDim2.new(0, (i-1)*120, 0, 5)
    TabButton.Size = UDim2.new(0, 110, 0, 30)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    Tabs[tabName] = TabButton
end

-- ສ້າງ Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.Size = UDim2.new(1, -20, 1, -100)

-- Tab: Farm
local FarmTab = Instance.new("Frame")
FarmTab.Parent = ContentFrame
FarmTab.BackgroundTransparency = 1
FarmTab.Size = UDim2.new(1, 0, 1, 0)
FarmTab.Visible = true
TabContents["Farm"] = FarmTab

-- Auto Farm Button
local AutoFarmBtn = Instance.new("TextButton")
AutoFarmBtn.Parent = FarmTab
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
AutoFarmBtn.Position = UDim2.new(0, 10, 0, 10)
AutoFarmBtn.Size = UDim2.new(0, 180, 0, 45)
AutoFarmBtn.Font = Enum.Font.GothamSemibold
AutoFarmBtn.Text = "Auto Farm: OFF"
AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmBtn.TextSize = 16

local AutoFarmCorner = Instance.new("UICorner")
AutoFarmCorner.CornerRadius = UDim.new(0, 8)
AutoFarmCorner.Parent = AutoFarmBtn

AutoFarmBtn.MouseButton1Click:Connect(function()
    Settings.AutoFarm = not Settings.AutoFarm
    AutoFarmBtn.Text = Settings.AutoFarm and "Auto Farm: ON" or "Auto Farm: OFF"
    AutoFarmBtn.BackgroundColor3 = Settings.AutoFarm and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(65, 65, 75)
    
    if Settings.AutoFarm then
        startAutoFarm()
    end
end)

-- Auto Quest Button
local AutoQuestBtn = Instance.new("TextButton")
AutoQuestBtn.Parent = FarmTab
AutoQuestBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
AutoQuestBtn.Position = UDim2.new(0, 200, 0, 10)
AutoQuestBtn.Size = UDim2.new(0, 180, 0, 45)
AutoQuestBtn.Font = Enum.Font.GothamSemibold
AutoQuestBtn.Text = "Auto Quest: OFF"
AutoQuestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoQuestBtn.TextSize = 16

local AutoQuestCorner = Instance.new("UICorner")
AutoQuestCorner.CornerRadius = UDim.new(0, 8)
AutoQuestCorner.Parent = AutoQuestBtn

AutoQuestBtn.MouseButton1Click:Connect(function()
    Settings.AutoQuest = not Settings.AutoQuest
    AutoQuestBtn.Text = Settings.AutoQuest and "Auto Quest: ON" or "Auto Quest: OFF"
    AutoQuestBtn.BackgroundColor3 = Settings.AutoQuest and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(65, 65, 75)
end)

-- Farm Radius Slider
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Parent = FarmTab
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Position = UDim2.new(0, 10, 0, 70)
RadiusLabel.Size = UDim2.new(0, 200, 0, 25)
RadiusLabel.Font = Enum.Font.Gotham
RadiusLabel.Text = "Farm Radius: " .. Settings.FarmRadius
RadiusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RadiusLabel.TextSize = 14
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tab: Boss
local BossTab = Instance.new("Frame")
BossTab.Parent = ContentFrame
BossTab.BackgroundTransparency = 1
BossTab.Size = UDim2.new(1, 0, 1, 0)
BossTab.Visible = false
TabContents["Boss"] = BossTab

local AutoBossBtn = Instance.new("TextButton")
AutoBossBtn.Parent = BossTab
AutoBossBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
AutoBossBtn.Position = UDim2.new(0, 10, 0, 10)
AutoBossBtn.Size = UDim2.new(0, 180, 0, 45)
AutoBossBtn.Font = Enum.Font.GothamSemibold
AutoBossBtn.Text = "Auto Boss: OFF"
AutoBossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBossBtn.TextSize = 16

local AutoBossCorner = Instance.new("UICorner")
AutoBossCorner.CornerRadius = UDim.new(0, 8)
AutoBossCorner.Parent = AutoBossBtn

AutoBossBtn.MouseButton1Click:Connect(function()
    Settings.AutoBoss = not Settings.AutoBoss
    AutoBossBtn.Text = Settings.AutoBoss and "Auto Boss: ON" or "Auto Boss: OFF"
    AutoBossBtn.BackgroundColor3 = Settings.AutoBoss and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(65, 65, 75)
end)

-- Tab: Teleport
local TeleportTab = Instance.new("Frame")
TeleportTab.Parent = ContentFrame
TeleportTab.BackgroundTransparency = 1
TeleportTab.Size = UDim2.new(1, 0, 1, 0)
TeleportTab.Visible = false
TabContents["Teleport"] = TeleportTab

local Islands = {"Marine", "Desert", "Snow", "Jungle", "Prison", "Sky", "Volcano"}
local TeleportBtns = {}

for i, island in ipairs(Islands) do
    local TeleportBtn = Instance.new("TextButton")
    TeleportBtn.Parent = TeleportTab
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    TeleportBtn.Position = UDim2.new(0, ((i-1)%3)*130 + 10, 0, math.floor((i-1)/3)*55 + 10)
    TeleportBtn.Size = UDim2.new(0, 120, 0, 45)
    TeleportBtn.Font = Enum.Font.GothamSemibold
    TeleportBtn.Text = "Teleport to\n" .. island
    TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportBtn.TextSize = 12
    
    local TeleportCorner = Instance.new("UICorner")
    TeleportCorner.CornerRadius = UDim.new(0, 8)
    TeleportCorner.Parent = TeleportBtn
    
    TeleportBtn.MouseButton1Click:Connect(function()
        -- ເພີ່ມໂຄ້ດ Teleport ຕາມຕ້ອງການ
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "LAM HUB",
            Text = "Teleported to " .. island,
            Duration = 2
        })
    end)
end

-- Tab: Player
local PlayerTab = Instance.new("Frame")
PlayerTab.Parent = ContentFrame
PlayerTab.BackgroundTransparency = 1
PlayerTab.Size = UDim2.new(1, 0, 1, 0)
PlayerTab.Visible = false
TabContents["Player"] = PlayerTab

-- WalkSpeed Slider
local WalkSpeedLabel = Instance.new("TextLabel")
WalkSpeedLabel.Parent = PlayerTab
WalkSpeedLabel.BackgroundTransparency = 1
WalkSpeedLabel.Position = UDim2.new(0, 10, 0, 10)
WalkSpeedLabel.Size = UDim2.new(0, 200, 0, 25)
WalkSpeedLabel.Font = Enum.Font.Gotham
WalkSpeedLabel.Text = "Walk Speed: " .. Settings.WalkSpeed
WalkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedLabel.TextSize = 14
WalkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tab: Settings
local SettingsTab = Instance.new("Frame")
SettingsTab.Parent = ContentFrame
SettingsTab.BackgroundTransparency = 1
SettingsTab.Size = UDim2.new(1, 0, 1, 0)
SettingsTab.Visible = false
TabContents["Settings"] = SettingsTab

-- ESP Button
local ESPBtn = Instance.new("TextButton")
ESPBtn.Parent = SettingsTab
ESPBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
ESPBtn.Position = UDim2.new(0, 10, 0, 10)
ESPBtn.Size = UDim2.new(0, 180, 0, 45)
ESPBtn.Font = Enum.Font.GothamSemibold
ESPBtn.Text = "ESP: OFF"
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.TextSize = 16

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 8)
ESPCorner.Parent = ESPBtn

ESPBtn.MouseButton1Click:Connect(function()
    Settings.ESP = not Settings.ESP
    ESPBtn.Text = Settings.ESP and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = Settings.ESP and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(65, 65, 75)
    
    if Settings.ESP then
        startESP()
    else
        stopESP()
    end
end)

-- ຟັງຊັນສຳລັບ Auto Farm
local farmConnection
function startAutoFarm()
    if farmConnection then farmConnection:Disconnect() end
    
    farmConnection = RunService.RenderStepped:Connect(function()
        if not Settings.AutoFarm then return end
        
        -- ຊອກຫາ NPC ທີ່ໃກ້ທີ່ສຸດ
        local nearestNPC = nil
        local shortestDistance = math.huge
        
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") then
                if v.Name:find("Bandit") or v.Name:find("Pirate") or v.Name:find("Marine") then
                    local distance = (v.Head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < Settings.FarmRadius and distance < shortestDistance then
                        shortestDistance = distance
                        nearestNPC = v
                    end
                end
            end
        end
        
        if nearestNPC and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- ເຄື່ອນໄປຫາ NPC
            LocalPlayer.Character.HumanoidRootPart.CFrame = nearestNPC.Head.CFrame
            -- ໂຈມຕີ
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
        end
    end)
end

-- ຟັງຊັນສຳລັບ ESP
local espObjects = {}
function startESP()
    stopESP()
    
    local espLoop = RunService.RenderStepped:Connect(function()
        if not Settings.ESP then return end
        
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") then
                if v ~= LocalPlayer.Character and not espObjects[v] then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESP_LAM"
                    billboard.Adornee = v.Head
                    billboard.Size = UDim2.new(0, 100, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.Parent = v.Head
                    
                    local label = Instance.new("TextLabel")
                    label.Parent = billboard
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = v.Name
                    label.TextColor3 = Color3.fromRGB(255, 0, 0)
                    label.TextScaled = true
                    label.Font = Enum.Font.GothamBold
                    
                    espObjects[v] = billboard
                end
            end
        end
    end)
    
    table.insert(espObjects, espLoop)
end

function stopESP()
    for obj, billboard in pairs(espObjects) do
        if billboard and billboard:IsA("BillboardGui") then
            billboard:Destroy()
        end
    end
    for _, connection in ipairs(espObjects) do
        if type(connection) == "thread" or connection:IsA("RBXScriptConnection") then
            connection:Disconnect()
        end
    end
    espObjects = {}
end

-- ປ່ຽນແທັບ
for tabName, tabButton in pairs(Tabs) do
    tabButton.MouseButton1Click:Connect(function()
        for _, content in pairs(TabContents) do
            content.Visible = false
        end
        TabContents[tabName].Visible = true
        
        for _, btn in pairs(Tabs) do
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end
        tabButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    end)
end

-- ເລີ່ມຕົ້ນໃຫ້ແທັບ Farm ເປັນຄ່າເລີ່ມຕົ້ນ
Tabs["Farm"].BackgroundColor3 = Color3.fromRGB(255, 85, 85)

-- ການປ້ອງກັນ AFK
local afkConnection
afkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "LAM HUB",
    Text = "ສະຄິບຖືກໂຫຼດສຳເລັດ!",
    Duration = 5
})

print("LAM HUB Loaded Successfully!")
