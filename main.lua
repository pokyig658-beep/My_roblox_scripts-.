-- ============================================
-- LAM HUB V6 | BLOX FRUITS
-- ແກ້ໄຂ Auto Farm, Auto Quest, Auto Collect
-- ໃຊ້ງານ: ກົດ INSERT ເພື່ອເປີດ/ປິດ UI
-- ============================================

-- ຕົວແປຄວບຄຸມ
local Settings = {
    AutoFarm = false,
    AutoQuest = false,
    AutoCollect = false,
    TargetNPC = "Bandit",
    FarmRadius = 300,
    WalkSpeed = 16,
    JumpPower = 50,
    AntiAFK = false,
    ESP = false
}

-- ຟັງຊັນເຄື່ອງມື
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

-- ຟັງຊັນສົ່ງຄຳສັ່ງ Remote (ໃຊ້ໄດ້ກັບ Blox Fruits ທຸກເວີຊັນ)
local function InvokeRemote(name, ...)
    local success, result = pcall(function()
        return ReplicatedStorage.Remotes.CommF_:InvokeServer(name, ...)
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
    
    -- ຊອກຫາໃນ workspace.Enemies (ຖ້າມີ)
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
    
    -- ຍ້າຍໄປໃກ້
    hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
    wait(0.05)
    
    -- ໂຈມຕີດ້ວຍ Remote ທີ່ຖືກຕ້ອງ
    local success = pcall(function()
        InvokeRemote("click", target.HumanoidRootPart.Position, target)
    end)
    
    -- ກົດ E ຊ່ວຍ
    local VirtualInput = game:GetService("VirtualInputManager")
    VirtualInput:SendKeyEvent(true, "E", false, game)
    wait(0.05)
    VirtualInput:SendKeyEvent(false, "E", false, game)
end

-- ຟັງຊັນຮັບ/ສົ່ງ Quest
local function HandleQuest()
    if not Settings.AutoQuest then return end
    
    -- ລອງສົ່ງເຄສ (ຖ້າສຳເລັດ)
    local complete = pcall(function()
        InvokeRemote("CompleteQuest")
    end)
    
    -- ຮັບເຄສໃໝ່
    pcall(function()
        InvokeRemote("StartQuest", Settings.TargetNPC)
    end)
end

-- ຟັງຊັນ Auto Farm ຫຼັກ
local farmLoop = nil
local function StartAutoFarm()
    if farmLoop then return end
    farmLoop = RunService.RenderStepped:Connect(function()
        if not Settings.AutoFarm then return end
        if not LocalPlayer.Character then return end
        
        -- ຈັດການ Quest
        HandleQuest()
        
        -- ຊອກ ແລະ ໂຈມຕີ NPC
        local target = GetNearestNPC()
        if target then
            AttackTarget(target)
        end
    end)
end

-- ຟັງຊັນ Auto Collect
local collectLoop = nil
local function StartAutoCollect()
    if collectLoop then return end
    collectLoop = RunService.RenderStepped:Connect(function()
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
    end)
end

-- ຟັງຊັນ Anti AFK
local afkLoop = nil
local function StartAntiAFK()
    if afkLoop then return end
    afkLoop = RunService.RenderStepped:Connect(function()
        if not Settings.AntiAFK then return end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

-- ຟັງຊັນປັບ WalkSpeed / JumpPower
local function ApplyMovement()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        humanoid.WalkSpeed = Settings.WalkSpeed
        humanoid.JumpPower = Settings.JumpPower
    end
end

-- ສ້າງ GUI ແບບງ່າຍ (ບໍ່ຕ້ອງພຶ່ງ Library ພາຍນອກ)
local function CreateUI()
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
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
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
    title.Text = "🔥 LAM HUB V6 | BLOX FRUITS"
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
        if farmLoop then farmLoop:Disconnect() farmLoop = nil end
        if collectLoop then collectLoop:Disconnect() collectLoop = nil end
        if afkLoop then afkLoop:Disconnect() afkLoop = nil end
    end)
    
    -- Scroll frame ສຳລັບສ່ວນຕ່າງໆ
    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = mainFrame
    scroll.BackgroundTransparency = 1
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 550)
    scroll.ScrollBarThickness = 6
    
    -- ສ້າງປຸ່ມແບບງ່າຍ
    local function AddButton(text, y, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = scroll
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.Size = UDim2.new(0, 250, 0, 45)
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
    
    local function AddToggle(text, y, getter, setter)
        local frame = Instance.new("Frame")
        frame.Parent = scroll
        frame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        frame.Position = UDim2.new(0, 10, 0, y)
        frame.Size = UDim2.new(0, 250, 0, 45)
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(0, 180, 1, 0)
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
        frame.Size = UDim2.new(0, 250, 0, 45)
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
        btn.Size = UDim2.new(0, 140, 0, 25)
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
            dropdown.Position = UDim2.new(0, 110, 0, y + 40)
            dropdown.Size = UDim2.new(0, 140, 0, #options * 30)
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
    
    -- ເພີ່ມອົງປະກອບຕ່າງໆ
    local y = 10
    AddToggle("Auto Farm", y, function() return Settings.AutoFarm end, function(v)
        Settings.AutoFarm = v
        if v then StartAutoFarm() else if farmLoop then farmLoop:Disconnect() farmLoop = nil end end
    end)
    y = y + 55
    AddToggle("Auto Quest", y, function() return Settings.AutoQuest end, function(v) Settings.AutoQuest = v end)
    y = y + 55
    AddToggle("Auto Collect", y, function() return Settings.AutoCollect end, function(v)
        Settings.AutoCollect = v
        if v then StartAutoCollect() else if collectLoop then collectLoop:Disconnect() collectLoop = nil end end
    end)
    y = y + 55
    AddDropdown("Target NPC", y, {"Bandit", "Pirate", "Marine", "Brute", "Diamond", "Snow", "All"}, Settings.TargetNPC, function(v)
        Settings.TargetNPC = v
    end)
    y = y + 55
    
    -- Slider ສຳລັບ Farm Radius
    local radiusFrame = Instance.new("Frame")
    radiusFrame.Parent = scroll
    radiusFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    radiusFrame.Position = UDim2.new(0, 10, 0, y)
    radiusFrame.Size = UDim2.new(0, 250, 0, 60)
    local radiusCorner = Instance.new("UICorner")
    radiusCorner.CornerRadius = UDim.new(0, 8)
    radiusCorner.Parent = radiusFrame
    
    local radiusLabel = Instance.new("TextLabel")
    radiusLabel.Parent = radiusFrame
    radiusLabel.BackgroundTransparency = 1
    radiusLabel.Position = UDim2.new(0, 10, 0, 5)
    radiusLabel.Size = UDim2.new(0, 200, 0, 20)
    radiusLabel.Font = Enum.Font.Gotham
    radiusLabel.Text = "Farm Radius: " .. Settings.FarmRadius
    radiusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    radiusLabel.TextSize = 12
    radiusLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = radiusFrame
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.Size = UDim2.new(0, 230, 0, 6)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    sliderFill.Size = UDim2.new((Settings.FarmRadius - 50) / 450, 0, 1, 0)
    
    local function updateRadius(value)
        Settings.FarmRadius = math.floor(value)
        radiusLabel.Text = "Farm Radius: " .. Settings.FarmRadius
        sliderFill.Size = UDim2.new((Settings.FarmRadius - 50) / 450, 0, 1, 0)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            while game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                local mousePos = game.Players.LocalPlayer:GetMouse().X
                local sliderPos = sliderBg.AbsolutePosition.X
                local percent = math.clamp((mousePos - sliderPos) / sliderBg.AbsoluteSize.X, 0, 1)
                updateRadius(50 + (percent * 450))
                wait()
            end
        end
    end)
    y = y + 70
    
    -- Walk Speed Slider
    local wsFrame = Instance.new("Frame")
    wsFrame.Parent = scroll
    wsFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    wsFrame.Position = UDim2.new(0, 10, 0, y)
    wsFrame.Size = UDim2.new(0, 250, 0, 60)
    local wsCorner = Instance.new("UICorner")
    wsCorner.CornerRadius = UDim.new(0, 8)
    wsCorner.Parent = wsFrame
    
    local wsLabel = Instance.new("TextLabel")
    wsLabel.Parent = wsFrame
    wsLabel.BackgroundTransparency = 1
    wsLabel.Position = UDim2.new(0, 10, 0, 5)
    wsLabel.Size = UDim2.new(0, 200, 0, 20)
    wsLabel.Font = Enum.Font.Gotham
    wsLabel.Text = "Walk Speed: " .. Settings.WalkSpeed
    wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    wsLabel.TextSize = 12
    wsLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local wsSliderBg = Instance.new("Frame")
    wsSliderBg.Parent = wsFrame
    wsSliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    wsSliderBg.Position = UDim2.new(0, 10, 0, 30)
    wsSliderBg.Size = UDim2.new(0, 230, 0, 6)
    
    local wsSliderFill = Instance.new("Frame")
    wsSliderFill.Parent = wsSliderBg
    wsSliderFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    wsSliderFill.Size = UDim2.new((Settings.WalkSpeed - 16) / 284, 0, 1, 0)
    
    local function updateWalkSpeed(value)
        Settings.WalkSpeed = math.floor(value)
        wsLabel.Text = "Walk Speed: " .. Settings.WalkSpeed
        wsSliderFill.Size = UDim2.new((Settings.WalkSpeed - 16) / 284, 0, 1, 0)
        ApplyMovement()
    end
    
    wsSliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            while game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                local mousePos = game.Players.LocalPlayer:GetMouse().X
                local sliderPos = wsSliderBg.AbsolutePosition.X
                local percent = math.clamp((mousePos - sliderPos) / wsSliderBg.AbsoluteSize.X, 0, 1)
                updateWalkSpeed(16 + (percent * 284))
                wait()
            end
        end
    end)
    y = y + 70
    
    -- Jump Power Slider
    local jpFrame = Instance.new("Frame")
    jpFrame.Parent = scroll
    jpFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    jpFrame.Position = UDim2.new(0, 10, 0, y)
    jpFrame.Size = UDim2.new(0, 250, 0, 60)
    local jpCorner = Instance.new("UICorner")
    jpCorner.CornerRadius = UDim.new(0, 8)
    jpCorner.Parent = jpFrame
    
    local jpLabel = Instance.new("TextLabel")
    jpLabel.Parent = jpFrame
    jpLabel.BackgroundTransparency = 1
    jpLabel.Position = UDim2.new(0, 10, 0, 5)
    jpLabel.Size = UDim2.new(0, 200, 0, 20)
    jpLabel.Font = Enum.Font.Gotham
    jpLabel.Text = "Jump Power: " .. Settings.JumpPower
    jpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    jpLabel.TextSize = 12
    jpLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local jpSliderBg = Instance.new("Frame")
    jpSliderBg.Parent = jpFrame
    jpSliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    jpSliderBg.Position = UDim2.new(0, 10, 0, 30)
    jpSliderBg.Size = UDim2.new(0, 230, 0, 6)
    
    local jpSliderFill = Instance.new("Frame")
    jpSliderFill.Parent = jpSliderBg
    jpSliderFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    jpSliderFill.Size = UDim2.new((Settings.JumpPower - 50) / 100, 0, 1, 0)
    
    local function updateJumpPower(value)
        Settings.JumpPower = math.floor(value)
        jpLabel.Text = "Jump Power: " .. Settings.JumpPower
        jpSliderFill.Size = UDim2.new((Settings.JumpPower - 50) / 100, 0, 1, 0)
        ApplyMovement()
    end
    
    jpSliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            while game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                local mousePos = game.Players.LocalPlayer:GetMouse().X
                local sliderPos = jpSliderBg.AbsolutePosition.X
                local percent = math.clamp((mousePos - sliderPos) / jpSliderBg.AbsoluteSize.X, 0, 1)
                updateJumpPower(50 + (percent * 100))
                wait()
            end
        end
    end)
    y = y + 70
    
    AddToggle("Anti AFK", y, function() return Settings.AntiAFK end, function(v)
        Settings.AntiAFK = v
        if v then StartAntiAFK() else if afkLoop then afkLoop:Disconnect() afkLoop = nil end end
    end)
    y = y + 55
    
    AddButton("Rejoin Game", y, function()
        TeleportService:Teleport(game.PlaceId)
    end)
    y = y + 55
    
    AddButton("Close UI", y, function()
        gui:Destroy()
        Settings.AutoFarm = false
        Settings.AutoQuest = false
        Settings.AutoCollect = false
        Settings.AntiAFK = false
        if farmLoop then farmLoop:Disconnect() farmLoop = nil end
        if collectLoop then collectLoop:Disconnect() collectLoop = nil end
        if afkLoop then afkLoop:Disconnect() afkLoop = nil end
    end)
    y = y + 55
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)
end

-- ເລີ່ມຕົ້ນ
spawn(function()
    wait(1)
    CreateUI()
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

-- ປ້ອງກັນການຕົກຕາຍຍ້ອນນ້ຳ
pcall(function()
    local water = workspace:FindFirstChild("Water")
    if water then
        water.CanCollide = false
    end
end)

print("✅ LAM HUB V6 ໂຫຼດສຳເລັດ! ກົດ INSERT ເພື່ອເປີດເມນູ")
