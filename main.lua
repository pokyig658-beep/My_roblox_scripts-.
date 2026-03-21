-- LAM HUB V3 | BLOX FRUITS
-- ສະຄິບສຳເລັດຮູບ ຕີ Monster ໄດ້ ມີປຸ່ມປິດ ໃຊ້ງານງ່າຍ

-- ຕົວແປສຳລັບການທຳງານ
local LAM = {}
LAM.AutoFarm = false
LAM.AutoQuest = false
LAM.AutoCollect = false
LAM.AutoBoss = false
LAM.WalkSpeed = 16
LAM.JumpPower = 50
LAM.TargetNPC = "Bandit"
LAM.FarmRadius = 300
LAM.ESP = false
LAM.UIEnabled = true

-- ຟັງຊັນສຳລັບສົ່ງການໂຈມຕີ
local function Attack(target)
    if not target or not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then
        return
    end
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    -- ຍ້າຍໄປຫາເປົ້າ
    player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    wait(0.1)
    -- ໂຈມຕີ
    local args = {
        [1] = target.HumanoidRootPart.Position,
        [2] = target
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("click", args)
end

-- ຟັງຊັນຊອກຫາ NPC ທີ່ໃກ້ທີ່ສຸດ
local function FindNearestNPC()
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    local nearest = nil
    local shortestDist = LAM.FarmRadius
    local playerPos = player.Character.HumanoidRootPart.Position
    
    -- ຊອກຫາໃນ workspace
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Humanoid.Health > 0 then
                local name = v.Name:lower()
                if name:find(LAM.TargetNPC:lower()) or LAM.TargetNPC == "All" then
                    local dist = (v.HumanoidRootPart.Position - playerPos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        nearest = v
                    end
                end
            end
        end
    end
    return nearest
end

-- ຟັງຊັນ Auto Farm
local function StartAutoFarm()
    while LAM.AutoFarm do
        wait(0.1)
        local npc = FindNearestNPC()
        if npc then
            Attack(npc)
        end
        -- ປັບສະຖານະ UI
        if LAM.UIEnabled and LAM.StatusLabel then
            LAM.StatusLabel.Text = "ກຳລັງຟາມ: " .. (npc and npc.Name or "ບໍ່ພົບ NPC")
        end
    end
end

-- ຟັງຊັນ Auto Collect
local function StartAutoCollect()
    while LAM.AutoCollect do
        wait(0.3)
        local player = game.Players.LocalPlayer
        if not player.Character then continue end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Tool") or (v:IsA("Model") and (v.Name:find("Money") or v.Name:find("Chest") or v.Name:find("Drop"))) then
                if v:FindFirstChild("Handle") or v:FindFirstChild("HumanoidRootPart") then
                    local part = v:FindFirstChild("Handle") or v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                    if part then
                        player.Character.HumanoidRootPart.CFrame = part.CFrame
                        wait(0.2)
                    end
                end
            end
        end
    end
end

-- ຟັງຊັນ ESP
local ESPObjects = {}
local function StartESP()
    while LAM.ESP do
        wait(0.5)
        -- ລ້າງ ESP ເກົ່າ
        for obj, gui in pairs(ESPObjects) do
            if not obj or not obj.Parent then
                if gui then gui:Destroy() end
                ESPObjects[obj] = nil
            end
        end
        -- ສ້າງ ESP ໃໝ່
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") then
                if v ~= game.Players.LocalPlayer.Character and not ESPObjects[v] then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "LAM_ESP"
                    bill.Adornee = v.Head
                    bill.Size = UDim2.new(0, 120, 0, 30)
                    bill.StudsOffset = Vector3.new(0, 2, 0)
                    bill.Parent = v.Head
                    
                    local label = Instance.new("TextLabel")
                    label.Parent = bill
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = v.Name .. " [" .. math.floor(v.Humanoid.Health) .. " HP]"
                    label.TextColor3 = Color3.fromRGB(255, 100, 100)
                    label.TextScaled = true
                    label.Font = Enum.Font.GothamBold
                    
                    ESPObjects[v] = bill
                end
            end
        end
    end
    -- ລ້າງ ESP ທັງໝົດເມື່ອປິດ
    for _, gui in pairs(ESPObjects) do
        pcall(function() gui:Destroy() end)
    end
    ESPObjects = {}
end

-- ສ້າງ GUI
local function CreateUI()
    -- ເຊັກວ່າມີ GUI ເກົ່າບໍ
    if game:GetService("CoreGui"):FindFirstChild("LAM_HUB") then
        game:GetService("CoreGui").LAM_HUB:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LAM_HUB"
    screenGui.Parent = game:GetService("CoreGui")
    
    -- ເມນູຫຼັກ
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    mainFrame.Size = UDim2.new(0, 550, 0, 400)
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- ມຸມມົນ
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- ແຖບຫົວ
    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Parent = titleBar
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = "🔥 LAM HUB V3 | BLOX FRUITS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- ປຸ່ມປິດ
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        LAM.UIEnabled = false
    end)
    
    -- ສ້າງ Tab Buttons
    local tabs = {"🌾 Farm", "👑 Boss", "🚀 Teleport", "⚡ Player", "⚙️ Settings"}
    local tabButtons = {}
    local tabContents = {}
    
    local tabBar = Instance.new("Frame")
    tabBar.Parent = mainFrame
    tabBar.BackgroundTransparency = 1
    tabBar.Position = UDim2.new(0, 0, 0, 45)
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = tabBar
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.BorderSizePixel = 0
        btn.Position = UDim2.new(0, (i-1)*110 + 5, 0, 0)
        btn.Size = UDim2.new(0, 105, 1, 0)
        btn.Font = Enum.Font.GothamSemibold
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        tabButtons[tabName] = btn
    end
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.new(0, 10, 0, 85)
    contentFrame.Size = UDim2.new(1, -20, 1, -95)
    
    -- Tab 1: Farm
    local farmTab = Instance.new("ScrollingFrame")
    farmTab.Parent = contentFrame
    farmTab.BackgroundTransparency = 1
    farmTab.Size = UDim2.new(1, 0, 1, 0)
    farmTab.CanvasSize = UDim2.new(0, 0, 0, 300)
    farmTab.ScrollBarThickness = 8
    farmTab.Visible = true
    tabContents["🌾 Farm"] = farmTab
    
    -- Auto Farm Button
    local autoFarmBtn = Instance.new("TextButton")
    autoFarmBtn.Parent = farmTab
    autoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    autoFarmBtn.Position = UDim2.new(0, 10, 0, 10)
    autoFarmBtn.Size = UDim2.new(0, 200, 0, 45)
    autoFarmBtn.Font = Enum.Font.GothamBold
    autoFarmBtn.Text = "▶️ Auto Farm: OFF"
    autoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoFarmBtn.TextSize = 14
    
    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 8)
    btnCorner1.Parent = autoFarmBtn
    
    -- ສະແດງສະຖານະ
    LAM.StatusLabel = Instance.new("TextLabel")
    LAM.StatusLabel.Parent = farmTab
    LAM.StatusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    LAM.StatusLabel.Position = UDim2.new(0, 10, 0, 65)
    LAM.StatusLabel.Size = UDim2.new(0, 500, 0, 35)
    LAM.StatusLabel.Font = Enum.Font.Gotham
    LAM.StatusLabel.Text = "🟢 ພ້ອມທຳງານ"
    LAM.StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    LAM.StatusLabel.TextSize = 12
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = LAM.StatusLabel
    
    autoFarmBtn.MouseButton1Click:Connect(function()
        LAM.AutoFarm = not LAM.AutoFarm
        autoFarmBtn.Text = LAM.AutoFarm and "⏹️ Auto Farm: ON" or "▶️ Auto Farm: OFF"
        autoFarmBtn.BackgroundColor3 = LAM.AutoFarm and Color3.fromRGB(70, 200, 70) or Color3.fromRGB(255, 70, 70)
        if LAM.AutoFarm then
            spawn(StartAutoFarm)
        end
    end)
    
    -- ເລືອກ NPC
    local npcLabel = Instance.new("TextLabel")
    npcLabel.Parent = farmTab
    npcLabel.BackgroundTransparency = 1
    npcLabel.Position = UDim2.new(0, 10, 0, 110)
    npcLabel.Size = UDim2.new(0, 100, 0, 25)
    npcLabel.Font = Enum.Font.Gotham
    npcLabel.Text = "Target NPC:"
    npcLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    npcLabel.TextSize = 12
    npcLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local npcDropdown = Instance.new("TextButton")
    npcDropdown.Parent = farmTab
    npcDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    npcDropdown.Position = UDim2.new(0, 120, 0, 110)
    npcDropdown.Size = UDim2.new(0, 150, 0, 25)
    npcDropdown.Font = Enum.Font.Gotham
    npcDropdown.Text = LAM.TargetNPC
    npcDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    npcDropdown.TextSize = 12
    
    local npcCorner = Instance.new("UICorner")
    npcCorner.CornerRadius = UDim.new(0, 6)
    npcCorner.Parent = npcDropdown
    
    local npcList = {"Bandit", "Pirate", "Marine", "Brute", "Diamond", "Snow", "All"}
    npcDropdown.MouseButton1Click:Connect(function()
        local frame = Instance.new("Frame")
        frame.Parent = screenGui
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        frame.Position = UDim2.new(0, 130, 0, 135)
        frame.Size = UDim2.new(0, 150, 0, 150)
        frame.ZIndex = 10
        
        local listCorner = Instance.new("UICorner")
        listCorner.CornerRadius = UDim.new(0, 8)
        listCorner.Parent = frame
        
        for i, name in ipairs(npcList) do
            local btn = Instance.new("TextButton")
            btn.Parent = frame
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            btn.Position = UDim2.new(0, 5, 0, (i-1)*35 + 5)
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Font = Enum.Font.Gotham
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 12
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                LAM.TargetNPC = name
                npcDropdown.Text = name
                frame:Destroy()
            end)
        end
    end)
    
    -- ປຸ່ມ Auto Quest
    local autoQuestBtn = Instance.new("TextButton")
    autoQuestBtn.Parent = farmTab
    autoQuestBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    autoQuestBtn.Position = UDim2.new(0, 220, 0, 10)
    autoQuestBtn.Size = UDim2.new(0, 150, 0, 45)
    autoQuestBtn.Font = Enum.Font.GothamBold
    autoQuestBtn.Text = "📋 Auto Quest: OFF"
    autoQuestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoQuestBtn.TextSize = 12
    
    local questCorner = Instance.new("UICorner")
    questCorner.CornerRadius = UDim.new(0, 8)
    questCorner.Parent = autoQuestBtn
    
    autoQuestBtn.MouseButton1Click:Connect(function()
        LAM.AutoQuest = not LAM.AutoQuest
        autoQuestBtn.Text = LAM.AutoQuest and "📋 Auto Quest: ON" or "📋 Auto Quest: OFF"
        autoQuestBtn.BackgroundColor3 = LAM.AutoQuest and Color3.fromRGB(70, 200, 70) or Color3.fromRGB(65, 65, 75)
        if LAM.AutoQuest then
            spawn(function()
                while LAM.AutoQuest do
                    wait(3)
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", LAM.TargetNPC)
                    end)
                end
            end)
        end
    end)
    
    -- ປຸ່ມ Auto Collect
    local autoCollectBtn = Instance.new("TextButton")
    autoCollectBtn.Parent = farmTab
    autoCollectBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    autoCollectBtn.Position = UDim2.new(0, 380, 0, 10)
    autoCollectBtn.Size = UDim2.new(0, 150, 0, 45)
    autoCollectBtn.Font = Enum.Font.GothamBold
    autoCollectBtn.Text = "💰 Auto Collect: OFF"
    autoCollectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoCollectBtn.TextSize = 12
    
    local collectCorner = Instance.new("UICorner")
    collectCorner.CornerRadius = UDim.new(0, 8)
    collectCorner.Parent = autoCollectBtn
    
    autoCollectBtn.MouseButton1Click:Connect(function()
        LAM.AutoCollect = not LAM.AutoCollect
        autoCollectBtn.Text = LAM.AutoCollect and "💰 Auto Collect: ON" or "💰 Auto Collect: OFF"
        autoCollectBtn.BackgroundColor3 = LAM.AutoCollect and Color3.fromRGB(70, 200, 70) or Color3.fromRGB(65, 65, 75)
        if LAM.AutoCollect then
            spawn(StartAutoCollect)
        end
    end)
    
    -- Tab 5: Settings
    local settingsTab = Instance.new("ScrollingFrame")
    settingsTab.Parent = contentFrame
    settingsTab.BackgroundTransparency = 1
    settingsTab.Size = UDim2.new(1, 0, 1, 0)
    settingsTab.CanvasSize = UDim2.new(0, 0, 0, 250)
    settingsTab.ScrollBarThickness = 8
    settingsTab.Visible = false
    tabContents["⚙️ Settings"] = settingsTab
    
    -- ESP Button
    local espBtn = Instance.new("TextButton")
    espBtn.Parent = settingsTab
    espBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    espBtn.Position = UDim2.new(0, 10, 0, 10)
    espBtn.Size = UDim2.new(0, 200, 0, 45)
    espBtn.Font = Enum.Font.GothamBold
    espBtn.Text = "👁️ ESP: OFF"
    espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    espBtn.TextSize = 14
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 8)
    espCorner.Parent = espBtn
    
    espBtn.MouseButton1Click:Connect(function()
        LAM.ESP = not LAM.ESP
        espBtn.Text = LAM.ESP and "👁️ ESP: ON" or "👁️ ESP: OFF"
        espBtn.BackgroundColor3 = LAM.ESP and Color3.fromRGB(70, 200, 70) or Color3.fromRGB(65, 65, 75)
        if LAM.ESP then
            spawn(StartESP)
        end
    end)
    
    -- Walk Speed Slider
    local wsLabel = Instance.new("TextLabel")
    wsLabel.Parent = settingsTab
    wsLabel.BackgroundTransparency = 1
    wsLabel.Position = UDim2.new(0, 10, 0, 70)
    wsLabel.Size = UDim2.new(0, 200, 0, 25)
    wsLabel.Font = Enum.Font.Gotham
    wsLabel.Text = "Walk Speed: " .. LAM.WalkSpeed
    wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    wsLabel.TextSize = 12
    wsLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local wsSlider = Instance.new("TextButton")
    wsSlider.Parent = settingsTab
    wsSlider.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    wsSlider.Position = UDim2.new(0, 10, 0, 95)
    wsSlider.Size = UDim2.new(0, 250, 0, 20)
    wsSlider.Text = ""
    wsSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local wsFill = Instance.new("Frame")
    wsFill.Parent = wsSlider
    wsFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    wsFill.Size = UDim2.new((LAM.WalkSpeed - 16) / 284, 0, 1, 0)
    wsFill.BorderSizePixel = 0
    
    wsSlider.MouseButton1Down:Connect(function()
        local dragging = true
        local mouse = game.Players.LocalPlayer:GetMouse()
        local connect
        connect = mouse.Move:Connect(function()
            if dragging then
                local pos = math.clamp((mouse.X - wsSlider.AbsolutePosition.X) / wsSlider.AbsoluteSize.X, 0, 1)
                LAM.WalkSpeed = math.floor(16 + (pos * 284))
                wsLabel.Text = "Walk Speed: " .. LAM.WalkSpeed
                wsFill.Size = UDim2.new(pos, 0, 1, 0)
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = LAM.WalkSpeed
                end
            end
        end)
        local release
        release = game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                connect:Disconnect()
                release:Disconnect()
            end
        end)
    end)
    
    -- ປຸ່ມ Rejoin
    local rejoinBtn = Instance.new("TextButton")
    rejoinBtn.Parent = settingsTab
    rejoinBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    rejoinBtn.Position = UDim2.new(0, 10, 0, 130)
    rejoinBtn.Size = UDim2.new(0, 200, 0, 40)
    rejoinBtn.Font = Enum.Font.GothamBold
    rejoinBtn.Text = "🔄 Rejoin Game"
    rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    rejoinBtn.TextSize = 14
    
    local rejoinCorner = Instance.new("UICorner")
    rejoinCorner.CornerRadius = UDim.new(0, 8)
    rejoinCorner.Parent = rejoinBtn
    
    rejoinBtn.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end)
    
    -- Anti AFK
    local antiAFK = false
    local afkBtn = Instance.new("TextButton")
    afkBtn.Parent = settingsTab
    afkBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    afkBtn.Position = UDim2.new(0, 220, 0, 130)
    afkBtn.Size = UDim2.new(0, 150, 0, 40)
    afkBtn.Font = Enum.Font.GothamBold
    afkBtn.Text = "💤 Anti AFK: OFF"
    afkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    afkBtn.TextSize = 12
    
    local afkCorner = Instance.new("UICorner")
    afkCorner.CornerRadius = UDim.new(0, 8)
    afkCorner.Parent = afkBtn
    
    afkBtn.MouseButton1Click:Connect(function()
        antiAFK = not antiAFK
        afkBtn.Text = antiAFK and "💤 Anti AFK: ON" or "💤 Anti AFK: OFF"
        afkBtn.BackgroundColor3 = antiAFK and Color3.fromRGB(70, 200, 70) or Color3.fromRGB(65, 65, 75)
        if antiAFK then
            spawn(function()
                while antiAFK do
                    wait(600)
                    pcall(function()
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                    end)
                end
            end)
        end
    end)
    
    -- ເພີ່ມແທັບອື່ນໆແບບງ່າຍໆ
    for tabName, btn in pairs(tabButtons) do
        btn.MouseButton1Click:Connect(function()
            for _, content in pairs(tabContents) do
                content.Visible = false
            end
            tabContents[tabName].Visible = true
            for _, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            end
            btn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        end)
    end
    
    -- ເລີ່ມຕົ້ນທີ່ແທັບ Farm
    tabButtons["🌾 Farm"].BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    
    -- ແຈ້ງເຕືອນ
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "LAM HUB V3",
        Text = "ໂຫຼດສຳເລັດ! ກົດ Insert ເພື່ອປິດເມນູ",
        Duration = 5
    })
end

-- ເລີ່ມຕົ້ນ
spawn(function()
    wait(1)
    CreateUI()
end)

-- ກົດ Insert ເພື່ອປິດ/ເປີດ
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        local gui = game:GetService("CoreGui"):FindFirstChild("LAM_HUB")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end
end)

print("✅ LAM HUB V3 Loaded Successfully!")
