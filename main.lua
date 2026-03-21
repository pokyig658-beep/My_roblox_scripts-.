-- LAM HUB V2 | BLOX FRUITS
-- ແກ້ໄຂ Auto Farm ໃຫ້ຕີ Monster ໄດ້ ແລະ ມີປຸ່ມປິດ

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/MainModule"))()

local Window = Library.CreateLib("LAM HUB | BLOX FRUITS", "Ocean")

-- ========== TAB FARM ==========
local FarmTab = Window:NewTab("Auto Farm")
local FarmSection = FarmTab:NewSection("Farm Settings")

local AutoFarmEnabled = false
local FarmTarget = "Bandit"
local FarmRadius = 300
local AutoQuestEnabled = false
local AutoCollectEnabled = false

-- Auto Farm Toggle
FarmSection:NewToggle("Auto Farm", "ຕີ Monster ອັດຕະໂນມັດ", function(state)
    AutoFarmEnabled = state
    if AutoFarmEnabled then
        -- ເລີ່ມ Auto Farm
        spawn(function()
            while AutoFarmEnabled do
                wait(0.1)
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    -- ຊອກຫາ Monster
                    local closestMonster = nil
                    local closestDist = FarmRadius
                    
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            if v.Name:lower():find(FarmTarget:lower()) or FarmTarget == "All" then
                                local dist = (v.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closestMonster = v
                                end
                            end
                        end
                    end
                    
                    -- ຕີ Monster
                    if closestMonster then
                        player.Character.HumanoidRootPart.CFrame = closestMonster.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                        wait(0.2)
                        -- ໃຊ້ອາວຸດ
                        local args = {
                            [1] = closestMonster.HumanoidRootPart.Position,
                            [2] = closestMonster
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("click", args)
                    end
                end
            end
        end)
    end
end)

-- ເລືອກ Monster
FarmSection:NewDropdown("Monster Target", "ເລືອກ Monster ທີ່ຕ້ອງການຕີ", {"Bandit", "Pirate", "Marine", "Brute", "Diamond", "All"}, function(selected)
    FarmTarget = selected
end)

-- ປັບໄລຍະການຟາມ
FarmSection:NewSlider("Farm Radius", "ໄລຍະການຊອກຫາ Monster", 500, 50, function(value)
    FarmRadius = value
end)

-- Auto Quest
FarmSection:NewToggle("Auto Quest", "ຮັບ ແລະ ສົ່ງ Quest ອັດຕະໂນມັດ", function(state)
    AutoQuestEnabled = state
    if AutoQuestEnabled then
        spawn(function()
            while AutoQuestEnabled do
                wait(1)
                -- ຮັບ Quest
                local args = {
                    [1] = "StartQuest",
                    [2] = FarmTarget
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end
        end)
    end
end)

-- Auto Collect Items
FarmSection:NewToggle("Auto Collect", "ເກັບເງິນ ແລະ ໄອເຕັມອັດຕະໂນມັດ", function(state)
    AutoCollectEnabled = state
    if AutoCollectEnabled then
        spawn(function()
            while AutoCollectEnabled do
                wait(0.5)
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Tool") or v:IsA("Model") and v.Name:find("Money") or v.Name:find("Chest") then
                        local player = game.Players.LocalPlayer
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = v:GetPivot()
                            wait(0.2)
                        end
                    end
                end
            end
        end)
    end
end)

-- ========== TAB BOSS ==========
local BossTab = Window:NewTab("Auto Boss")
local BossSection = BossTab:NewSection("Boss Settings")

local AutoBossEnabled = false
local SelectedBoss = "Greybeard"

BossSection:NewToggle("Auto Boss", "ລ່າ Boss ອັດຕະໂນມັດ", function(state)
    AutoBossEnabled = state
    if AutoBossEnabled then
        spawn(function()
            while AutoBossEnabled do
                wait(0.5)
                local player = game.Players.LocalPlayer
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name:lower():find(SelectedBoss:lower()) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if player.Character then
                            player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                            wait(0.3)
                            local args = {
                                [1] = v.HumanoidRootPart.Position,
                                [2] = v
                            }
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("click", args)
                        end
                    end
                end
            end
        end)
    end
end)

BossSection:NewDropdown("Select Boss", "ເລືອກ Boss ທີ່ຕ້ອງການລ່າ", {"Greybeard", "Diamond", "Thunder God", "Cake Queen", "Don Swan"}, function(selected)
    SelectedBoss = selected
end)

-- ========== TAB TELEPORT ==========
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Island Teleport")

local Islands = {
    ["Marine Starter"] = CFrame.new(-386, 73, 255),
    ["Jungle"] = CFrame.new(-1171, 13, 420),
    ["Desert"] = CFrame.new(889, 22, -11),
    ["Snow"] = CFrame.new(1200, 38, -1120),
    ["Sky Island"] = CFrame.new(-478, 208, 439),
    ["Prison"] = CFrame.new(3515, 12, -1143),
    ["Volcano"] = CFrame.new(-1481, 66, 725),
    ["Cake Land"] = CFrame.new(-1766, 40, -2737),
    ["Sea of Treats"] = CFrame.new(-2708, 63, -2774)
}

for name, cf in pairs(Islands) do
    TeleportSection:NewButton(name, "ໂທລະເລີດໄປ " .. name, function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = cf
            Library:Notification("Teleport", "ໄປຫາ " .. name .. " ສຳເລັດ", 2)
        end
    end)
end

-- ========== TAB PLAYER ==========
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("Player Settings")

-- Walk Speed
PlayerSection:NewSlider("Walk Speed", "ປັບຄວາມໄວການເດີນ", 300, 16, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

-- Jump Power
PlayerSection:NewSlider("Jump Power", "ປັບການກະໂດດ", 150, 50, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- Auto Stats
PlayerSection:NewToggle("Auto Stats", "ແຈກສະເຕດອັດຕະໂນມັດໃສ່ Melee/Defense", function(state)
    if state then
        spawn(function()
            while state do
                wait(2)
                local args = {
                    [1] = "AddPoint",
                    [2] = "Melee",
                    [3] = 1
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end
        end)
    end
end)

-- ========== TAB SETTINGS ==========
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("UI Settings")

-- ESP Toggle
local ESPEnabled = false
SettingsSection:NewToggle("ESP Player", "ເບິ່ງຕຳແໜ່ງຜູ້ຫຼິ້ນ ແລະ Monster", function(state)
    ESPEnabled = state
    if ESPEnabled then
        spawn(function()
            while ESPEnabled do
                wait(0.5)
                for _, v in pairs(game.Players:GetChildren()) do
                    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                        if not v.Character.Head:FindFirstChild("ESP_LAM") then
                            local esp = Instance.new("BillboardGui")
                            esp.Name = "ESP_LAM"
                            esp.Adornee = v.Character.Head
                            esp.Size = UDim2.new(0, 100, 0, 30)
                            esp.StudsOffset = Vector3.new(0, 2, 0)
                            esp.Parent = v.Character.Head
                            
                            local label = Instance.new("TextLabel")
                            label.Parent = esp
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = v.Name
                            label.TextColor3 = Color3.fromRGB(255, 0, 0)
                            label.TextScaled = true
                        end
                    end
                end
            end
        end)
    else
        for _, v in pairs(game.Players:GetChildren()) do
            if v.Character and v.Character.Head:FindFirstChild("ESP_LAM") then
                v.Character.Head.ESP_LAM:Destroy()
            end
        end
    end
end)

-- Rejoin Button
SettingsSection:NewButton("Rejoin Game", "ເຂົ້າເກມໃໝ່", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

-- Close UI Button
SettingsSection:NewButton("Close UI", "ປິດເມນູ LAM HUB", function()
    Library:Unload()
    Library = nil
    Window = nil
end)

-- Anti AFK
SettingsSection:NewToggle("Anti AFK", "ປ້ອງກັນການຖືກຕັດເນື່ອງຈາກບໍ່ເຄື່ອນໄຫວ", function(state)
    if state then
        spawn(function()
            while state do
                wait(600)
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
            end
        end)
    end
end)

-- Notification ເມື່ອໂຫຼດສຳເລັດ
Library:Notification("LAM HUB V2", "ໂຫຼດສຳເລັດ! ກົດ Insert ເພື່ອເປີດ/ປິດເມນູ", 5)

print("LAM HUB V2 Loaded Successfully!")
