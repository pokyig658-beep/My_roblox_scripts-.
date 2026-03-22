-- LAM HUB V4 | BLOX FRUITS
-- ແກ້ໄຂ Auto Farm ໃຫ້ຕີໄດ້ ແລະ ຮັບເຄສໄດ້

local LAM = {}
LAM.AutoFarm = false
LAM.AutoQuest = false
LAM.AutoCollect = false
LAM.TargetNPC = "Bandit"
LAM.FarmRadius = 300
LAM.UIEnabled = true

-- ຟັງຊັນສຳລັບຍ້າຍໄປຫາເປົ້າ
local function MoveTo(target)
    local player = game.Players.LocalPlayer
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = target.CFrame * CFrame.new(0, 0, 5)
end

-- ຟັງຊັນໂຈມຕີ
local function Attack(target)
    if not target then return end
    local player = game.Players.LocalPlayer
    if not player.Character then return end
    
    -- ຍ້າຍໄປໃກ້
    MoveTo(target)
    wait(0.1)
    
    -- ໂຈມຕີດ້ວຍວິທີທີ່ຖືກຕ້ອງ
    pcall(function()
        -- ວິທີທີ 1: ໃຊ້ click remote
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("click", target.HumanoidRootPart.Position, target)
        
        -- ວິທີທີ 2: ໃຊ້ attack remote
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("attack", target.HumanoidRootPart.Position, target)
        
        -- ວິທີທີ 3: ໃຊ້ combat
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("combat", target.HumanoidRootPart.Position, target)
    end)
    
    -- ກົດປຸ່ມ E ເພີ່ມ
    local VirtualInput = game:GetService("VirtualInputManager")
    VirtualInput:SendKeyEvent(true, "E", false, game)
    wait(0.05)
    VirtualInput:SendKeyEvent(false, "E", false, game)
end

-- ຟັງຊັນຊອກຫາ NPC
local function FindNearestNPC()
    local player = game.Players.LocalPlayer
    if not player.Character then return nil end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest = nil
    local minDist = LAM.FarmRadius
    
    -- ຊອກຫາໃນ workspace.Enemies ກ່ອນ
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, v in pairs(enemies:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local name = v.Name:lower()
                if name:find(LAM.TargetNPC:lower()) or LAM.TargetNPC == "All" then
                    local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = v
                    end
                end
            end
        end
    end
    
    -- ຖ້າບໍ່ເຫັນ ໃຫ້ຊອກຫາໃນ workspace ທັງໝົດ
    if not nearest then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                if v.Humanoid.Health > 0 and v ~= player.Character then
                    local name = v.Name:lower()
                    if name:find(LAM.TargetNPC:lower()) or LAM.TargetNPC == "All" then
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

-- ຟັງຊັນຮັບເຄສ
local function GetQuest()
    pcall(function()
        -- ຮັບເຄສຕາມ NPC ທີ່ເລືອກ
        local args = {
            [1] = "StartQuest",
            [2] = LAM.TargetNPC
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
end

-- ຟັງຊັນສົ່ງເຄສ (ຖ້າສຳເລັດ)
local function CheckQuestComplete()
    pcall(function()
        -- ກວດສອບວ່າເຄສສຳເລັດຫຼືຍັງ
        local args = {
            [1] = "getquests"
        }
        local quests = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        if quests and quests.Complete then
            local args2 = {
                [1] = "CompleteQuest"
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args2))
        end
    end)
end

-- ຟັງຊັນ Auto Farm ຫຼັກ
local function StartAutoFarm()
    while LAM.AutoFarm do
        wait(0.1)
        
        local player = game.Players.LocalPlayer
        if not player.Character then 
            wait(1)
            continue 
        end
        
        -- ກວດສອບ ແລະ ຮັບເຄສ
        if LAM.AutoQuest then
            CheckQuestComplete()
            GetQuest()
        end
        
        -- ຊອກຫາ NPC
        local target = FindNearestNPC()
        
        if target then
            -- ຍ້າຍໄປຫາ ແລະ ໂຈມຕີ
            Attack(target)
            
            -- ອັບເດດສະຖານະ
            if LAM.StatusLabel then
                LAM.StatusLabel.Text = "⚔️ ກຳລັງຟາມ: " .. target.Name .. " | HP: " .. math.floor(target.Humanoid.Health)
                LAM.StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
        else
            if LAM.StatusLabel then
                LAM.StatusLabel.Text = "🔍 ກຳລັງຊອກຫາ NPC..."
                LAM.StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            end
        end
    end
end

-- ຟັງຊັນ Auto Collect
local function StartAutoCollect()
    while LAM.AutoCollect do
        wait(0.2)
        
        local player = game.Players.LocalPlayer
        if not player.Character then 
            wait(1)
            continue 
        end
        
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        -- ຊອກຫາໄອເຕັມທີ່ຕົກຢູ່
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Tool") or (v:IsA("Model") and (v.Name:find("Money") or v.Name:find("Chest") or v.Name:find("Drop") or v.Name:find("Fruit"))) then
                local part = v:FindFirstChild("Handle") or v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if part then
                    local dist = (part.Position - hrp.Position).Magnitude
                    if dist < 50 then
                        hrp.CFrame = part.CFrame
                        wait(0.1)
                    end
                end
            end
        end
    end
end

-- ຟັງຊັນເພີ່ມຄວາມໄວ
local function SetWalkSpeed(speed)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end

-- ສ້າງ UI
local function CreateUI()
    -- ລ້າງ GUI ເກົ່າ
    if game:GetService("CoreGui"):FindFirstChild("LAM_HUB") then
        game:GetService("CoreGui").LAM_HUB:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LAM_HUB"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- ເມນູຫຼັກ
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    mainFrame.Size = UDim2.new(0, 600, 0, 450)
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- ແຖບຫົວ
    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Parent = titleBar
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Size = UDim2.new(0, 300, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = "🔥 LAM HUB V4 | BLOX FRUITS 🔥"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- ປຸ່ມປິດ
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
        screenGui:Destroy()
        LAM.UIEnabled = false
    end)
    
    -- ແຖບເມນູ
    local tabFrame = Instance.new("Frame")
    tabFrame.Parent = mainFrame
    tabFrame.BackgroundTransparency = 1
    tabFrame.Position = UDim2.new(0, 0, 0, 50)
    tabFrame.Size = UDim2.new(1, 0, 0, 45)
    
    local tabs = {"🌾 FARM", "👑 BOSS", "🚀 TP", "⚙️ SET"}
    local tabButtons = {}
    local tabContents = {}
    
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = tabFrame
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.BorderSizePixel = 0
        btn.Position = UDim2.new(0, (i-1)*150 + 5, 0, 5)
        btn.Size = UDim2.new(0, 145, 0, 35)
        btn.Font = Enum.Font.GothamBold
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        tabButtons[tabName] = btn
    end
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.new(0, 10, 0, 100)
    contentFrame.Size = UDim2.new(1, -20, 1, -115)
    
    -- ========== TAB FARM ==========
    local farmTab = Instance.new("ScrollingFrame")
    farmTab.Parent = contentFrame
    farmTab.BackgroundTransparency = 1
    farmTab.Size = UDim2.new(1, 0, 1, 0)
    farmTab.CanvasSize = UDim2.new(0, 0, 0, 350)
    farmTab.ScrollBarThickness = 6
    farmTab.Visible = true
    tabContents["🌾 FARM"] = farmTab
    
    -- Auto Farm Button
    local autoFarmBtn = Instance.new("TextButton")
    autoFarmBtn.Parent = farmTab
    autoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    autoFarmBtn.Position = UDim2.new(0, 10, 0, 10)
    autoFarmBtn.Size = UDim2.new(0, 250, 0, 50)
    autoFarmBtn.Font = Enum.Font.GothamBold
    autoFarmBtn.Text = "🔴 AUTO FARM: OFF"
    autoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoFarmBtn.TextSize = 16
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = autoFarmBtn
    
    autoFarmBtn.MouseButton1Click:Connect(function()
        LAM.AutoFarm = not LAM.AutoFarm
        autoFarmBtn.Text = LAM.AutoFarm and "🟢 AUTO FARM: ON" or "🔴 AUTO FARM: OFF"
        autoFarmBtn.BackgroundColor3 = LAM.AutoFarm and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(255, 80, 80)
        if LAM.AutoFarm then
            spawn(StartAutoFarm)
        end
    end)
    
    -- Auto Quest Button
    local autoQuestBtn = Instance.new("TextButton")
    autoQuestBtn.Parent = farmTab
    autoQuestBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    autoQuestBtn.Position = UDim2.new(0, 270, 0, 10)
    autoQuestBtn.Size = UDim2.new(0, 250, 0, 50)
    autoQuestBtn.Font = Enum.Font.GothamBold
    autoQuestBtn.Text = "📋 AUTO QUEST: OFF"
    autoQuestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoQuestBtn.TextSize = 16
    
    local questCorner = Instance.new("UICorner")
    questCorner.CornerRadius = UDim.new(0, 10)
    questCorner.Parent = autoQuestBtn
    
    autoQuestBtn.MouseButton1Click:Connect(function()
        LAM.AutoQuest = not LAM.AutoQuest
        autoQuestBtn.Text = LAM.AutoQuest and "📋 AUTO QUEST: ON" or "📋 AUTO QUEST: OFF"
        autoQuestBtn.BackgroundColor3 = LAM.AutoQuest and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(65, 65, 75)
    end)
    
    -- Auto Collect Button
    local autoCollectBtn = Instance.new("TextButton")
    autoCollectBtn.Parent = farmTab
    autoCollectBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    autoCollectBtn.Position = UDim2.new(0, 10, 0, 70)
    autoCollectBtn.Size = UDim2.new(0, 250, 0, 45)
    autoCollectBtn.Font = Enum.Font.GothamBold
    autoCollectBtn.Text = "💰 AUTO COLLECT: OFF"
    autoCollectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoCollectBtn.TextSize = 14
    
    local collectCorner = Instance.new("UICorner")
    collectCorner.CornerRadius = UDim.new(0, 10)
    collectCorner.Parent = autoCollectBtn
    
    autoCollectBtn.MouseButton1Click:Connect(function()
        LAM.AutoCollect = not LAM.AutoCollect
        autoCollectBtn.Text = LAM.AutoCollect and "💰 AUTO COLLECT: ON" or "💰 AUTO COLLECT: OFF"
        autoCollectBtn.BackgroundColor3 = LAM.AutoCollect and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(65, 65, 75)
        if LAM.AutoCollect then
            spawn(StartAutoCollect)
        end
    end)
    
    -- ເລືອກ NPC
    local npcLabel = Instance.new("TextLabel")
    npcLabel.Parent = farmTab
    npcLabel.BackgroundTransparency = 1
    npcLabel.Position = UDim2.new(0, 10, 0, 130)
    npcLabel.Size = UDim2.new(0, 100, 0, 30)
    npcLabel.Font = Enum.Font.GothamBold
    npcLabel.Text = "🎯 TARGET:"
    npcLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    npcLabel.TextSize = 14
    npcLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local npcDropdown = Instance.new("TextButton")
    npcDropdown.Parent = farmTab
    npcDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    npcDropdown.Position = UDim2.new(0, 120, 0, 130)
    npcDropdown.Size = UDim2.new(0, 200, 0, 30)
    npcDropdown.Font = Enum.Font.Gotham
    npcDropdown.Text = LAM.TargetNPC
    npcDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    npcDropdown.TextSize = 14
    
    local npcCorner = Instance.new("UICorner")
    npcCorner.CornerRadius = UDim.new(0, 6)
    npcCorner.Parent = npcDropdown
    
    local npcList = {"Bandit", "Pirate", "Marine", "Brute", "Diamond", "Snow", "Prisoner", "All"}
    npcDropdown.MouseButton1Click:Connect(function()
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Parent = screenGui
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        dropdownFrame.Position = UDim2.new(0, 130, 0, 235)
        dropdownFrame.Size = UDim2.new(0, 200, 0, 250)
        dropdownFrame.ZIndex = 10
        
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 8)
        dropCorner.Parent = dropdownFrame
        
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = dropdownFrame
        scroll.BackgroundTransparency = 1
        scroll.Position = UDim2.new(0, 5, 0, 5)
        scroll.Size = UDim2.new(1, -10, 1, -10)
        scroll.CanvasSize = UDim2.new(0, 0, 0, #npcList * 35)
        scroll.ScrollBarThickness = 4
        
        for i, name in ipairs(npcList) do
            local btn = Instance.new("TextButton")
            btn.Parent = scroll
            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*35)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Font = Enum.Font.Gotham
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 13
            
            local btnCorner2 = Instance.new("UICorner")
            btnCorner2.CornerRadius = UDim.new(0, 4)
            btnCorner2.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                LAM.TargetNPC = name
                npcDropdown.Text = name
                dropdownFrame:Destroy()
            end)
        end
    end)
    
    -- ສະແດງສະຖານະ
    LAM.StatusLabel = Instance.new("TextLabel")
    LAM.StatusLabel.Parent = farmTab
    LAM.StatusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    LAM.StatusLabel.Position = UDim2.new(0, 10, 0, 180)
    LAM.StatusLabel.Size = UDim2.new(0, 530, 0, 45)
    LAM.StatusLabel.Font = Enum.Font.GothamBold
    LAM.StatusLabel.Text = "🟢 ພ້ອມທຳງານ | ເປີດ AUTO FARM ເພື່ອເລີ່ມຕີ"
    LAM.StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    LAM.StatusLabel.TextSize = 13
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = LAM.StatusLabel
    
    -- ========== TAB SETTINGS ==========
    local settingsTab = Instance.new("ScrollingFrame")
    settingsTab.Parent = contentFrame
    settingsTab.BackgroundTransparency = 1
    settingsTab.Size = UDim2.new(1, 0, 1, 0)
    settingsTab.CanvasSize = UDim2.new(0, 0, 0, 200)
    settingsTab.ScrollBarThickness = 6
    settingsTab.Visible = false
    tabContents["⚙️ SET"] = settingsTab
    
    -- Walk Speed Slider
    local wsLabel = Instance.new("TextLabel")
    wsLabel.Parent = settingsTab
    wsLabel.BackgroundTransparency = 1
    wsLabel.Position = UDim2.new(0, 10, 0, 10)
    wsLabel.Size = UDim2.new(0, 200, 0, 25)
    wsLabel.Font = Enum.Font.Gotham
    wsLabel.Text = "🏃 Walk Speed: 16"
    wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    wsLabel.TextSize = 14
    wsLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local wsSlider = Instance.new("Frame")
    wsSlider.Parent = settingsTab
    wsSlider.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    wsSlider.Position = UDim2.new(0, 10, 0, 40)
    wsSlider.Size = UDim2.new(0, 300, 0, 8)
    
    local wsFill = Instance.new("Frame")
    wsFill.Parent = wsSlider
    wsFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    wsFill.Size = UDim2.new(0.1, 0, 1, 0)
    wsFill.BorderSizePixel = 0
    
    local wsValue = 16
    local function UpdateWalkSpeed(value)
        wsValue = math.floor(value)
        wsLabel.Text = "🏃 Walk Speed: " .. wsValue
        wsFill.Size = UDim2.new((wsValue - 16) / 284, 0, 1, 0)
        SetWalkSpeed(wsValue)
    end
    
    wsSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            while game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                local mousePos = game.Players.LocalPlayer:GetMouse().X
                local sliderPos = wsSlider.AbsolutePosition.X
                local percent = math.clamp((mousePos - sliderPos) / wsSlider.AbsoluteSize.X, 0, 1)
                UpdateWalkSpeed(16 + (percent * 284))
                wait()
            end
        end
    end)
    
    -- Rejoin Button
    local rejoinBtn = Instance.new("TextButton")
    rejoinBtn.Parent = settingsTab
    rejoinBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    rejoinBtn.Position = UDim2.new(0, 10, 0, 70)
    rejoinBtn.Size = UDim2.new(0, 200, 0, 45)
    rejoinBtn.Font = Enum.Font.GothamBold
    rejoinBtn.Text = "🔄 REJOIN GAME"
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
    afkBtn.Position = UDim2.new(0, 220, 0, 70)
    afkBtn.Size = UDim2.new(0, 150, 0, 45)
    afkBtn.Font = Enum.Font.GothamBold
    afkBtn.Text = "💤 ANTI AFK: OFF"
    afkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    afkBtn.TextSize = 12
    
    local afkCorner = Instance.new("UICorner")
    afkCorner.CornerRadius = UDim.new(0, 8)
    afkCorner.Parent = afkBtn
    
    afkBtn.MouseButton1Click:Connect(function()
        antiAFK = not antiAFK
        afkBtn.Text = antiAFK and "💤 ANTI AFK: ON" or "💤 ANTI AFK: OFF"
        afkBtn.BackgroundColor3 = antiAFK and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(65, 65, 75)
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
    
    -- Tab switching
    for tabName, btn in pairs(tabButtons) do
        btn.MouseButton1Click:Connect(function()
            for _, content in pairs(tabContents) do
                content.Visible = false
            end
            tabContents[tabName].Visible = true
            for _, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            end
            btn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        end)
    end
    
    -- ເລີ່ມຕົ້ນທີ່ແທັບ Farm
    tabButtons["🌾 FARM"].BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    
    -- ແຈ້ງເຕືອນ
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "LAM HUB V4",
        Text = "ໂຫຼດສຳເລັດ! ເປີດ AUTO FARM ເພື່ອເລີ່ມຕີ ແລະ AUTO QUEST ເພື່ອຮັບເຄສ",
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

print("✅ LAM HUB V4 Loaded Successfully!")
