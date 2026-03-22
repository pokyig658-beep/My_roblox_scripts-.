-- ==================================================
-- LAM HUB V7 | BLOX FRUITS
-- ສ້າງໂດຍ: ຕາມຄຳຮ້ອງຂອງທ່ານ
-- ຟັງຊັນ: Auto Farm, Auto Quest, Auto Collect, Teleport, ປັບຄວາມໄວ ແລະ ອື່ນໆ
-- ວິທີໃຊ້: ກົດ INSERT ເພື່ອເປີດ/ປິດ UI
-- ==================================================

-- ຕົວແປຄວບຄຸມສະຖານະ
local Settings = {
    AutoFarm = false,
    AutoQuest = false,
    AutoCollect = false,
    TargetNPC = "Bandit",
    FarmRadius = 300,
    WalkSpeed = 16,
    JumpPower = 50,
    AntiAFK = false
}

-- ຟັງຊັນເຄື່ອງມືທົ່ວໄປ
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local VirtualInput = game:GetService("VirtualInputManager")

-- ຟັງຊັນສົ່ງຄຳສັ່ງ Remote (ໃຊ້ໄດ້ກັບທຸກເວີຊັນ)
local function InvokeRemote(...)
    local success, result = pcall(function()
        return ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
    end)
    return result
end

-- ຟັງຊັນຊອກຫາ NPC ທີ່ໃກ້ທີ່ສຸດ
local function GetNearestNPC()
    if not LocalPlayer.Character then return nil end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest = nil
    local minDist = Settings.FarmRadius
    local targetName = Settings.TargetNPC:lower()
    
    -- ຊອກຫາໃນ workspace.Enemies ກ່ອນ (ຖ້າມີ)
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, v in pairs(enemies:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                local name = v.Name:lower()
                if name:find(targetName) or targetName == "all" then
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
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                if v ~= LocalPlayer.Character then
                    local name = v.Name:lower()
                    if name:find(targetName) or targetName == "all" then
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

-- ຟັງຊັນໂຈມຕີ
local function AttackTarget(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- ຍ້າຍໄປໃກ້ເປົ້າ
    hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
    wait(0.05)
    
    -- ໂຈມຕີດ້ວຍ Remote ທີ່ຖືກຕ້ອງ
    pcall(function()
        InvokeRemote("click", target.HumanoidRootPart.Position, target)
    end)
    
    -- ກົດປຸ່ມ E ຊ່ວຍ
    VirtualInput:SendKeyEvent(true, "E", false, game)
    wait(0.05)
    VirtualInput:SendKeyEvent(false, "E", false, game)
end

-- ຟັງຊັນຮັບ/ສົ່ງ Quest
local function HandleQuest()
    if not Settings.AutoQuest then return end
    
    -- ລອງສົ່ງເຄສ (ຖ້າສຳເລັດ)
    pcall(function()
        InvokeRemote("CompleteQuest")
    end)
    
    -- ຮັບເຄສໃໝ່
    pcall(function()
        InvokeRemote("StartQuest", Settings.TargetNPC)
    end)
end

-- ຟັງຊັນເກັບໄອເຕັມ
local function CollectItems()
    if not Settings.AutoCollect then return end
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") or (v:IsA("Model") and (v.Name:find("Money") or v.Name:find("Chest") or v.Name:find("Drop") or v.Name:find("Fruit"))) then
            local part = v:FindFirstChild("Handle") or v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
            if part and (part.Position - hrp.Position).Magnitude < 50 then
                hrp.CFrame = part.CFrame
                wait(0.1)
            end
        end
    end
end

-- ຟັງຊັນປັບຄວາມໄວ ແລະ ການກະໂດດ
local function ApplyMovement()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        humanoid.WalkSpeed = Settings.WalkSpeed
        humanoid.JumpPower = Settings.JumpPower
    end
end

-- ຟັງຊັນ Anti AFK
local function AntiAFK()
    if Settings.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- ==================== UI ====================
local function CreateUI()
    -- ລ້າງ GUI ເກົ່າ
    if game.CoreGui:FindFirstChild("LAM_HUB") then
        game.CoreGui.LAM_HUB:Destroy()
    end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "LAM_HUB"
    gui.Parent = game.CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = gui
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -280)
    mainFrame.Size = UDim2.new(0, 600, 0, 560)
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Parent = titleBar
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Size = UDim2.new(0, 300, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = "🔥 LAM HUB V7 | BLOX FRUITS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(1, -45, 0, 0)
    closeBtn.Size = UDim2.new(0, 45, 1, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 22
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        Settings.AutoFarm = false
        Settings.AutoQuest = false
        Settings.AutoCollect = false
        Settings.AntiAFK = false
    end)
    
    -- Scroll frame ສຳລັບສ່ວນຕ່າງໆ
    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = mainFrame
    scroll.BackgroundTransparency = 1
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 700)
    scroll.ScrollBarThickness = 6
    
    -- ຟັງຊັນຊ່ວຍເພີ່ມອົງປະກອບ
    local function AddToggle(text, y, getter, setter)
        local frame = Instance.new("Frame")
        frame.Parent = scroll
        frame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        frame.Position = UDim2.new(0, 10, 0, y)
        frame.Size = UDim2.new(0, 280, 0, 45)
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local btn = Instance.new("TextButton")
        btn.Parent = frame
        btn.BackgroundColor3 = getter() and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
        btn.Position = UDim2.new(1, -50, 0, 10)
        btn.Size = UDim2.new(0, 40, 0, 25)
        btn.Font = Enum.Font.GothamBold
        btn.Text = getter() and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            local newState = not getter()
            setter(newState)
            btn.BackgroundColor3 = newState and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
            btn.Text = newState and "ON" or "OFF"
        end)
        return frame
    end
    
    local function AddDropdown(text, y, options, current, callback)
        local frame = Instance.new("Frame")
        frame.Parent = scroll
        frame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        frame.Position = UDim2.new(0, 10, 0, y)
        frame.Size = UDim2.new(0, 280, 0, 45)
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(0, 80, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local btn = Instance.new("TextButton")
        btn.Parent = frame
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btn.Position = UDim2.new(0, 100, 0, 10)
        btn.Size = UDim2.new(0, 170, 0, 25)
        btn.Font = Enum.Font.Gotham
        btn.Text = current
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local dropdown = nil
        btn.MouseButton1Click:Connect(function()
            if dropdown then dropdown:Destroy() return end
            dropdown = Instance.new("Frame")
            dropdown.Parent = scroll
            dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            dropdown.Position = UDim2.new(0, 110, 0, y + 45)
            dropdown.Size = UDim2.new(0, 170, 0, #options * 30)
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 6)
            dropCorner.Parent = dropdown
            
            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = dropdown
                optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                optBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optBtn.TextSize = 12
                optBtn.MouseButton1Click:Connect(function()
                    callback(opt)
                    btn.Text = opt
                    dropdown:Destroy()
                    dropdown = nil
                end)
            end
        end)
        return frame
    end
    
    local function AddSlider(text, y, minVal, maxVal, getter, setter)
        local frame = Instance.new("Frame")
        frame.Parent = scroll
        frame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        frame.Position = UDim2.new(0, 10, 0, y)
        frame.Size = UDim2.new(0, 280, 0, 60)
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Size = UDim2.new(0, 200, 0, 20)
        label.Font = Enum.Font.Gotham
        label.Text = text .. ": " .. getter()
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Parent = frame
        sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        sliderBg.Position = UDim2.new(0, 10, 0, 30)
        sliderBg.Size = UDim2.new(0, 260, 0, 6)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBg
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        sliderFill.Size = UDim2.new((getter() - minVal) / (maxVal - minVal), 0, 1, 0)
        
        local function updateValue(value)
            local newVal = math.floor(value)
            setter(newVal)
            label.Text = text .. ": " .. newVal
            sliderFill.Size = UDim2.new((newVal - minVal) / (maxVal - minVal), 0, 1, 0)
        end
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                while game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local mousePos = game.Players.LocalPlayer:GetMouse().X
                    local sliderPos = sliderBg.AbsolutePosition.X
                    local percent = math.clamp((mousePos - sliderPos) / sliderBg.AbsoluteSize.X, 0, 1)
                    updateValue(minVal + (percent * (maxVal - minVal)))
                    wait()
                end
            end
        end)
        return frame
    end
    
    local function AddButton(text, y, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = scroll
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.Size = UDim2.new(0, 280, 0, 40)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    -- ເພີ່ມອົງປະກອບຕ່າງໆ
    local y = 10
    AddToggle("⚔️ Auto Farm", y, function() return Settings.AutoFarm end, function(v)
        Settings.AutoFarm = v
    end)
    y = y + 55
    AddToggle("📋 Auto Quest", y, function() return Settings.AutoQuest end, function(v)
        Settings.AutoQuest = v
    end)
    y = y + 55
    AddToggle("💰 Auto Collect", y, function() return Settings.AutoCollect end, function(v)
        Settings.AutoCollect = v
    end)
    y = y + 55
    AddDropdown("🎯 Target NPC", y, {"Bandit", "Pirate", "Marine", "Brute", "Diamond", "Snow", "All"}, Settings.TargetNPC, function(v)
        Settings.TargetNPC = v
    end)
    y = y + 55
    AddSlider("📏 Farm Radius", y, 50, 500, function() return Settings.FarmRadius end, function(v)
        Settings.FarmRadius = v
    end)
    y = y + 70
    AddSlider("🏃 Walk Speed", y, 16, 300, function() return Settings.WalkSpeed end, function(v)
        Settings.WalkSpeed = v
        ApplyMovement()
    end)
    y = y + 70
    AddSlider("🦘 Jump Power", y, 50, 150, function() return Settings.JumpPower end, function(v)
        Settings.JumpPower = v
        ApplyMovement()
    end)
    y = y + 70
    AddToggle("💤 Anti AFK", y, function() return Settings.AntiAFK end, function(v)
        Settings.AntiAFK = v
    end)
    y = y + 55
    
    -- Teleport Section
    local teleLabel = Instance.new("TextLabel")
    teleLabel.Parent = scroll
    teleLabel.BackgroundTransparency = 1
    teleLabel.Position = UDim2.new(0, 10, 0, y)
    teleLabel.Size = UDim2.new(0, 280, 0, 25)
    teleLabel.Font = Enum.Font.GothamBold
    teleLabel.Text = "📍 Teleport"
    teleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    teleLabel.TextSize = 16
    teleLabel.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 35
    
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
        AddButton(name, y, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = cf
            end
        end)
        y = y + 50
    end
    
    AddButton("🔄 Rejoin Game", y, function()
        TeleportService:Teleport(game.PlaceId)
    end)
    y = y + 50
    
    AddButton("❌ Close UI", y, function()
        gui:Destroy()
        Settings.AutoFarm = false
        Settings.AutoQuest = false
        Settings.AutoCollect = false
        Settings.AntiAFK = false
    end)
    y = y + 50
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)
end

-- ==================== MAIN LOOP ====================
-- ການເຄື່ອນໄຫວຫຼັກ
local farmConnection
local collectConnection
local afkConnection

local function StartLoops()
    if farmConnection then farmConnection:Disconnect() end
    if collectConnection then collectConnection:Disconnect() end
    if afkConnection then afkConnection:Disconnect() end
    
    farmConnection = RunService.RenderStepped:Connect(function()
        if Settings.AutoFarm then
            if not LocalPlayer.Character then return end
            HandleQuest()
            local target = GetNearestNPC()
            if target then
                AttackTarget(target)
            end
        end
    end)
    
    collectConnection = RunService.RenderStepped:Connect(function()
        if Settings.AutoCollect then
            CollectItems()
        end
    end)
    
    afkConnection = RunService.RenderStepped:Connect(function()
        AntiAFK()
    end)
end

-- ເລີ່ມ UI ແລະ Loops
spawn(function()
    wait(1)
    CreateUI()
    StartLoops()
end)

-- ກົດ Insert ເພື່ອປິດ/ເປີດ UI
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        local gui = game.CoreGui:FindFirstChild("LAM_HUB")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end
end)

-- ປ້ອງກັນການຕົກນ້ຳຕາຍ
pcall(function()
    local water = workspace:FindFirstChild("Water")
    if water then
        water.CanCollide = false
    end
end)

print("✅ LAM HUB V7 ໂຫຼດສຳເລັດ! ກົດ INSERT ເພື່ອເປີດເມນູ")
