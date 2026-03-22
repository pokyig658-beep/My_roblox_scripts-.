-- LAM HUB V5 | FIXED AUTO FARM & QUEST
-- ໃຊ້ງານໂດຍ: ກົດ Insert ເພື່ອເປີດ/ປິດ UI

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/MainModule"))()

local Window = Library.CreateLib("LAM HUB V5 | BLOX FRUITS", "DarkTheme")

-- ========== TAB AUTO FARM ==========
local FarmTab = Window:NewTab("Auto Farm")
local FarmSection = FarmTab:NewSection("Farm Settings")

local autoFarm = false
local autoQuest = false
local autoCollect = false
local targetNPC = "Bandit"
local farmRadius = 300

-- ຟັງຊັນຊອກຫາ NPC
local function GetNearestNPC()
    local player = game.Players.LocalPlayer
    if not player.Character then return nil end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest = nil
    local minDist = farmRadius
    
    -- ຊອກຫາໃນ workspace.Enemies (ຖ້າມີ)
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, v in pairs(enemies:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local name = v.Name:lower()
                if name:find(targetNPC:lower()) or targetNPC == "All" then
                    local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = v
                    end
                end
            end
        end
    end
    
    -- ຖ້າບໍ່ເຫັນ ໃຫ້ຊອກທັງ workspace
    if not nearest then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                if v.Humanoid.Health > 0 and v ~= player.Character then
                    local name = v.Name:lower()
                    if name:find(targetNPC:lower()) or targetNPC == "All" then
                        local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = v
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

-- ຟັງຊັນໂຈມຕີ (ໃຊ້ Remote ທີ່ຖືກຕ້ອງ)
local function Attack(target)
    if not target then return end
    local player = game.Players.LocalPlayer
    if not player.Character then return end
    
    -- ຍ້າຍໄປໃກ້
    player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    wait(0.1)
    
    -- ໂຈມຕີດ້ວຍຫຼາຍວິທີ
    pcall(function()
        -- ວິທີທີ່ໃຊ້ໄດ້ດີທີ່ສຸດ
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("click", target.HumanoidRootPart.Position, target)
    end)
    
    -- ກົດ E ເພີ່ມເຕີມ
    local VirtualInput = game:GetService("VirtualInputManager")
    VirtualInput:SendKeyEvent(true, "E", false, game)
    wait(0.05)
    VirtualInput:SendKeyEvent(false, "E", false, game)
end

-- ຟັງຊັນຮັບເຄສ
local function StartQuest()
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", targetNPC)
    end)
end

-- ຟັງຊັນສົ່ງເຄສ (ຖ້າສຳເລັດ)
local function CompleteQuest()
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CompleteQuest")
    end)
end

-- ຟັງຊັນ Auto Farm ຫຼັກ
local function FarmLoop()
    while autoFarm do
        wait(0.1)
        local player = game.Players.LocalPlayer
        if not player.Character then wait(1) continue end
        
        -- Auto Quest
        if autoQuest then
            CompleteQuest()   -- ລອງສົ່ງກ່ອນ
            StartQuest()      -- ຮັບໃໝ່
        end
        
        -- ຊອກ NPC
        local target = GetNearestNPC()
        if target then
            Attack(target)
        end
    end
end

-- ຟັງຊັນ Auto Collect
local function CollectLoop()
    while autoCollect do
        wait(0.3)
        local player = game.Players.LocalPlayer
        if not player.Character then wait(1) continue end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Tool") or (v:IsA("Model") and (v.Name:find("Money") or v.Name:find("Chest") or v.Name:find("Drop") or v.Name:find("Fruit"))) then
                local part = v:FindFirstChild("Handle") or v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if part and (part.Position - hrp.Position).Magnitude < 50 then
                    hrp.CFrame = part.CFrame
                    wait(0.2)
                end
            end
        end
    end
end

-- UI ສຳລັບຕັ້ງຄ່າ
FarmSection:NewToggle("Auto Farm", "ຕີ NPC ອັດຕະໂນມັດ", function(state)
    autoFarm = state
    if autoFarm then
        spawn(FarmLoop)
    end
end)

FarmSection:NewToggle("Auto Quest", "ຮັບ ແລະ ສົ່ງ Quest ອັດຕະໂນມັດ", function(state)
    autoQuest = state
end)

FarmSection:NewToggle("Auto Collect", "ເກັບເງິນ ແລະ ໄອເຕັມອັດຕະໂນມັດ", function(state)
    autoCollect = state
    if autoCollect then
        spawn(CollectLoop)
    end
end)

FarmSection:NewDropdown("Target NPC", "ເລືອກ NPC ທີ່ຕ້ອງການຕີ", {"Bandit", "Pirate", "Marine", "Brute", "Diamond", "Snow", "Prisoner", "All"}, function(selected)
    targetNPC = selected
end)

FarmSection:NewSlider("Farm Radius", "ໄລຍະທີ່ຈະຊອກຫາ NPC", 500, 50, function(value)
    farmRadius = value
end)

-- ========== TAB PLAYER ==========
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("Movement")

PlayerSection:NewSlider("Walk Speed", "ປັບຄວາມໄວຍ່າງ", 300, 16, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

PlayerSection:NewSlider("Jump Power", "ປັບການກະໂດດ", 150, 50, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- ========== TAB TELEPORT ==========
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Islands")

local islands = {
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

for name, cf in pairs(islands) do
    TeleportSection:NewButton(name, "ໂທລະເລີດໄປ " .. name, function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = cf
            Library:Notification("Teleport", "ໄປຫາ " .. name .. " ສຳເລັດ", 3)
        end
    end)
end

-- ========== TAB SETTINGS ==========
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("General")

SettingsSection:NewButton("Rejoin Game", "ເຂົ້າເກມໃໝ່", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

SettingsSection:NewToggle("Anti AFK", "ປ້ອງກັນການຖືກຕັດເນື່ອງຈາກບໍ່ເຄື່ອນໄຫວ", function(state)
    if state then
        spawn(function()
            while state do
                wait(600)
                pcall(function()
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                end)
            end
        end)
    end
end)

SettingsSection:NewButton("Close UI", "ປິດເມນູ LAM HUB", function()
    Library:Unload()
end)

Library:Notification("LAM HUB V5", "ໂຫຼດສຳເລັດ! ເປີດ Auto Farm ແລະ Auto Quest ເພື່ອເລີ່ມຕົ້ນ", 5)

print("✅ LAM HUB V5 Loaded")
