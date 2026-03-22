-- ==================================================
-- LAM HUB V8 | BLOX FRUITS
-- ສະຄິບທີ່ງ່າຍທີ່ສຸດ ສຳລັບທົດສອບ ແລະ ໃຊ້ງານ
-- ຖ້າ UI ບໍ່ຂຶ້ນ ໃຫ້ກວດເບິ່ງຂໍ້ຄວາມໃນ F9 ຫຼື Console
-- ==================================================

-- ຂັ້ນຕອນທີ 1: ທົດສອບວ່າ Executor ເຮັດວຽກ
print("=========================================")
print("LAM HUB V8 ກຳລັງໂຫຼດ...")
print("ຖ້າທ່ານເຫັນຂໍ້ຄວາມນີ້ ສະແດງວ່າ Executor ເຮັດວຽກປົກກະຕິ")
print("=========================================")

-- ແຈ້ງເຕືອນທີ່ໜ້າຈໍ
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "LAM HUB V8",
        Text = "ສະຄິບກຳລັງໂຫຼດ... ລໍຖ້າ 2 ວິນາທີ",
        Duration = 3
    })
end)

-- ລໍຖ້າເລັກນ້ອຍ
wait(2)

-- ຂັ້ນຕອນທີ 2: ສ້າງ GUI ແບບງ່າຍທີ່ສຸດ (ບໍ່ມີອົງປະກອບຊັບຊ້ອນ)
local success, err = pcall(function()
    -- ລ້າງ GUI ເກົ່າ
    if game.CoreGui:FindFirstChild("LAM_HUB_V8") then
        game.CoreGui.LAM_HUB_V8:Destroy()
    end
    
    -- ສ້າງ ScreenGui ຫຼັກ
    local gui = Instance.new("ScreenGui")
    gui.Name = "LAM_HUB_V8"
    gui.Parent = game.CoreGui
    gui.ResetOnSpawn = false
    
    -- ສ້າງ Frame ຫຼັກ (ສີແດງເຂັ້ມ)
    local main = Instance.new("Frame")
    main.Parent = gui
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    main.Position = UDim2.new(0.5, -250, 0.5, -200)
    main.Size = UDim2.new(0, 500, 0, 400)
    main.Active = true
    main.Draggable = true
    
    -- ມຸມມົນ
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main
    
    -- ແຖບຫົວຂໍ້
    local title = Instance.new("Frame")
    title.Parent = main
    title.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    title.Size = UDim2.new(1, 0, 0, 40)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    local titleText = Instance.new("TextLabel")
    titleText.Parent = title
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, 0, 1, 0)
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = "🔥 LAM HUB V8 | BLOX FRUITS"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    
    -- ປຸ່ມປິດ
    local close = Instance.new("TextButton")
    close.Parent = title
    close.BackgroundTransparency = 1
    close.Position = UDim2.new(1, -45, 0, 0)
    close.Size = UDim2.new(0, 45, 1, 0)
    close.Font = Enum.Font.GothamBold
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextSize = 22
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- ເນື້ອໃນ
    local content = Instance.new("Frame")
    content.Parent = main
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 10, 0, 50)
    content.Size = UDim2.new(1, -20, 1, -60)
    
    -- ປຸ່ມ Auto Farm
    local autoFarmBtn = Instance.new("TextButton")
    autoFarmBtn.Parent = content
    autoFarmBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    autoFarmBtn.Position = UDim2.new(0, 0, 0, 10)
    autoFarmBtn.Size = UDim2.new(1, 0, 0, 45)
    autoFarmBtn.Font = Enum.Font.GothamBold
    autoFarmBtn.Text = "🔴 AUTO FARM: OFF"
    autoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoFarmBtn.TextSize = 16
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = autoFarmBtn
    
    -- ສະຖານະ
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = content
    statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    statusLabel.Position = UDim2.new(0, 0, 0, 70)
    statusLabel.Size = UDim2.new(1, 0, 0, 35)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "✅ ພ້ອມທຳງານ | ຍັງບໍ່ໄດ້ເປີດ Auto Farm"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 12
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusLabel
    
    -- ຕົວແປສຳລັບ Auto Farm
    local autoFarm = false
    local farmLoop = nil
    
    -- ຟັງຊັນໂຈມຕີ
    local function Attack(target)
        if not target or not target:FindFirstChild("HumanoidRootPart") then return end
        local player = game.Players.LocalPlayer
        if not player.Character then return end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- ຍ້າຍໄປໃກ້
        hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
        wait(0.05)
        
        -- ໂຈມຕີ
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("click", target.HumanoidRootPart.Position, target)
        end)
        
        -- ກົດ E
        local VirtualInput = game:GetService("VirtualInputManager")
        VirtualInput:SendKeyEvent(true, "E", false, game)
        wait(0.05)
        VirtualInput:SendKeyEvent(false, "E", false, game)
    end
    
    -- ຟັງຊັນຊອກ NPC
    local function GetNearestNPC()
        local player = game.Players.LocalPlayer
        if not player.Character then return nil end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        
        local nearest = nil
        local minDist = 300
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                if v ~= player.Character then
                    local name = v.Name:lower()
                    if name:find("bandit") or name:find("pirate") or name:find("marine") then
                        local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = v
                        end
                    end
                end
            end
        end
        return nearest
    end
    
    -- ຟັງຊັນ Auto Farm Loop
    local function StartFarm()
        if farmLoop then farmLoop:Disconnect() end
        farmLoop = game:GetService("RunService").RenderStepped:Connect(function()
            if not autoFarm then return end
            local target = GetNearestNPC()
            if target then
                Attack(target)
                statusLabel.Text = "⚔️ ກຳລັງຟາມ: " .. target.Name
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                statusLabel.Text = "🔍 ກຳລັງຊອກຫາ NPC..."
                statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            end
        end)
    end
    
    -- ເຫດການກົດປຸ່ມ
    autoFarmBtn.MouseButton1Click:Connect(function()
        autoFarm = not autoFarm
        if autoFarm then
            autoFarmBtn.Text = "🟢 AUTO FARM: ON"
            autoFarmBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            statusLabel.Text = "⚔️ ກຳລັງເລີ່ມ Auto Farm..."
            StartFarm()
        else
            autoFarmBtn.Text = "🔴 AUTO FARM: OFF"
            autoFarmBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            statusLabel.Text = "✅ ຢຸດ Auto Farm ແລ້ວ"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            if farmLoop then
                farmLoop:Disconnect()
                farmLoop = nil
            end
        end
    end)
    
    -- ປຸ່ມ Teleport ງ່າຍໆ
    local teleLabel = Instance.new("TextLabel")
    teleLabel.Parent = content
    teleLabel.BackgroundTransparency = 1
    teleLabel.Position = UDim2.new(0, 0, 0, 120)
    teleLabel.Size = UDim2.new(1, 0, 0, 25)
    teleLabel.Font = Enum.Font.GothamBold
    teleLabel.Text = "📍 Teleport ໄປຫາເກາະ"
    teleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    teleLabel.TextSize = 14
    teleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local islands = {
        {"Marine Starter", CFrame.new(-386, 73, 255)},
        {"Jungle", CFrame.new(-1171, 13, 420)},
        {"Desert", CFrame.new(889, 22, -11)},
        {"Snow", CFrame.new(1200, 38, -1120)},
        {"Sky Island", CFrame.new(-478, 208, 439)}
    }
    
    local yPos = 150
    for i, data in ipairs(islands) do
        local btn = Instance.new("TextButton")
        btn.Parent = content
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.Size = UDim2.new(0.48, 0, 0, 35)
        btn.Font = Enum.Font.Gotham
        btn.Text = data[1]
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        
        local btnCorner2 = Instance.new("UICorner")
        btnCorner2.CornerRadius = UDim.new(0, 6)
        btnCorner2.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = data[2]
                statusLabel.Text = "✅ ໂທລະເລີດໄປ " .. data[1]
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
        end)
        
        -- ຈັດຕຳແໜ່ງ 2 ຖັນ
        if i % 2 == 0 then
            yPos = yPos + 40
        else
            btn.Position = UDim2.new(0.52, 0, 0, yPos)
        end
    end
    
    -- ປຸ່ມປິດເມນູ
    local closeUI = Instance.new("TextButton")
    closeUI.Parent = content
    closeUI.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    closeUI.Position = UDim2.new(0, 0, 0, 340)
    closeUI.Size = UDim2.new(1, 0, 0, 40)
    closeUI.Font = Enum.Font.GothamBold
    closeUI.Text = "❌ ປິດເມນູ"
    closeUI.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeUI.TextSize = 14
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeUI
    
    closeUI.MouseButton1Click:Connect(function()
        gui:Destroy()
        if farmLoop then farmLoop:Disconnect() end
        autoFarm = false
    end)
    
    print("✅ UI ສ້າງສຳເລັດ!")
end)

-- ແຈ້ງເຕືອນຜົນການສ້າງ UI
if success then
    print("=========================================")
    print("✅ LAM HUB V8 ໂຫຼດສຳເລັດ!")
    print("📌 ຖ້າ UI ຍັງບໍ່ຂຶ້ນ ໃຫ້ກົດ F9 ເບິ່ງຂໍ້ຜິດພາດ")
    print("=========================================")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "LAM HUB V8",
            Text = "ໂຫຼດສຳເລັດ! UI ຈະປາກົດທັນທີ",
            Duration = 5
        })
    end)
else
    print("❌ ເກີດຂໍ້ຜິດພາດ: " .. tostring(err))
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "LAM HUB V8",
            Text = "ເກີດຂໍ້ຜິດພາດ: " .. tostring(err):sub(1, 100),
            Duration = 10
        })
    end)
end

-- ເພີ່ມປຸ່ມກົດ Insert ເພື່ອປິດ/ເປີດ UI
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        local gui = game.CoreGui:FindFirstChild("LAM_HUB_V8")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end
end)
