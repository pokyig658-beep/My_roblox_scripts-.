-- [[ LAM HUB | FLUENT PREMIUM (HYBRID TOGGLE FIX 100%) ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- 1. ສ້າງປຸ່ມລອຍແຄບຊູນ (THE TOP BAR)
-- ==========================================
-- ດຶງຄ່າໜ້າຈໍທີ່ປອດໄພທີ່ສຸດສຳລັບມືຖື
local safeContainer = CoreGui
pcall(function() if gethui then safeContainer = gethui() end end)

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "LAM_PremiumToggle"
ToggleGui.Parent = safeContainer
ToggleGui.ResetOnSpawn = false

local TopBar = Instance.new("Frame")
TopBar.Parent = ToggleGui
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BackgroundTransparency = 0.15
TopBar.Position = UDim2.new(0.5, -100, 0, 15)
TopBar.Size = UDim2.new(0, 200, 0, 38)
TopBar.Active = true
TopBar.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = TopBar

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "LAM HUB | V.I.P"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = TopBar
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Position = UDim2.new(1, -40, 0, 0)
ToggleBtn.Size = UDim2.new(0, 30, 1, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "[ UI ]"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.TextSize = 13

-- ==========================================
-- 2. ໂຫຼດ FLUENT UI
-- ==========================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "LAM HUB",
    SubTitle = "[ Premium Mobile ]",
    TabWidth = 160,
    Size = UDim2.fromOffset(550, 320),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- ==========================================
-- 3. ລະບົບປິດ/ເປີດ UI ທີ່ແຂງແກ່ນທີ່ສຸດ (HYBRID TOGGLE)
-- ==========================================
local menuOpen = true

ToggleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    
    -- ປ່ຽນສີປຸ່ມໃຫ້ຮູ້ສະຖານະ
    if menuOpen then
        UIStroke.Color = Color3.fromRGB(0, 255, 255)
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    else
        UIStroke.Color = Color3.fromRGB(255, 50, 50)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end

    -- ວິທີທີ 1: ໃຊ້ລະບົບ Hardware Keypress ຂອງຕົວລັນມືຖື (Delta/Codex)
    local keySuccess = pcall(function()
        if keypress and keyrelease then
            keypress(0xA3) -- ລະຫັດປຸ່ມ Right Control
            task.wait(0.05)
            keyrelease(0xA3)
            return true
        end
        return false
    end)

    -- ວິທີທີ 2: ໃຊ້ລະບົບ Virtual Input ຂອງ Roblox
    if not keySuccess then
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
            task.wait(0.05)
            vim:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
        end)
    end

    -- ວິທີທີ 3: ໃຊ້ກຳລັງບັງຄັບປິດໜ້າຈໍ (Brute-Force) ເຮັດວຽກແນ່ນອນ 100%
    pcall(function()
        local containers = {CoreGui}
        if gethui then table.insert(containers, gethui()) end
        
        for _, container in ipairs(containers) do
            for _, gui in pairs(container:GetChildren()) do
                -- Fluent UI ຈະມີ Frame ທີ່ຊື່ວ່າ "Window" ສະເໝີ
                if gui:IsA("ScreenGui") and gui.Name ~= "LAM_PremiumToggle" then
                    if gui:FindFirstChild("Window") then
                        gui.Enabled = menuOpen
                    end
                end
            end
        end
    end)
end)

-- ==========================================
-- 4. ຕັ້ງຄ່າເມນູຕ່າງໆ (FEATURES)
-- ==========================================
local Config = {
    Aim = false, HardLock = false, Smooth = 0.2, Part = "Head",
    Team = true, Wall = true, Trigger = false,
    Hitbox = false, HitSize = 5, HitTrans = 0.6,
    FOV = false, FOVRad = 150, ESPLine = false,
    Speed = 16, Jump = 50, InfJump = false, Noclip = false
}

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" })
}

-- [ COMBAT ]
Tabs.Combat:AddToggle("Aim", {Title = "Enable Aimbot", Default = false}):OnChanged(function(v) Config.Aim = v end)
Tabs.Combat:AddToggle("Hard", {Title = "Hard Lock (Instant)", Default = false}):OnChanged(function(v) Config.HardLock = v end)
Tabs.Combat:AddSlider("Smooth", {Title = "Smoothness", Default = 0.2, Min = 0.01, Max = 1, Rounding = 2}):OnChanged(function(v) Config.Smooth = v end)
Tabs.Combat:AddDropdown("Part", {Title = "Target Part", Values = {"Head", "HumanoidRootPart"}, Default = 1}):OnChanged(function(v) Config.Part = v end)
Tabs.Combat:AddToggle("Team", {Title = "Team Check", Default = true}):OnChanged(function(v) Config.Team = v end)
Tabs.Combat:AddToggle("Wall", {Title = "Wall Check", Default = true}):OnChanged(function(v) Config.Wall = v end)

Tabs.Combat:AddToggle("Hitbox", {Title = "Enable Hitbox", Default = false}):OnChanged(function(v) 
    Config.Hitbox = v 
    if not v then
        pcall(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    p.Character.Head.Size = Vector3.new(1.2, 1.2, 1.2)
                    p.Character.Head.Transparency = 0
                end
            end
        end)
    end
end)
Tabs.Combat:AddSlider("HSize", {Title = "Hitbox Size", Default = 5, Min = 2, Max = 20, Rounding = 0}):OnChanged(function(v) Config.HitSize = v end)

-- [ VISUALS ]
Tabs.Visuals:AddToggle("ESPLine", {Title = "ESP Tracers (Lines)", Default = false}):OnChanged(function(v) Config.ESPLine = v end)
Tabs.Visuals:AddToggle("FOV", {Title = "Show FOV Circle", Default = false}):OnChanged(function(v) Config.FOV = v end)
Tabs.Visuals:AddSlider("FRad", {Title = "FOV Radius", Default = 150, Min = 50, Max = 800, Rounding = 0}):OnChanged(function(v) Config.FOVRad = v end)

-- [ PLAYER (BYPASS MODE) ]
Tabs.Player:AddSlider("WS", {Title = "WalkSpeed (Bypass Mode)", Default = 16, Min = 16, Max = 100, Rounding = 0}):OnChanged(function(v) Config.Speed = v end)
Tabs.Player:AddSlider("JP", {Title = "JumpPower", Default = 50, Min = 50, Max = 300, Rounding = 0}):OnChanged(function(v) Config.Jump = v end)
Tabs.Player:AddToggle("InfJ", {Title = "Infinite Jump (Fly)", Default = false}):OnChanged(function(v) Config.InfJump = v end)
Tabs.Player:AddToggle("Noclip", {Title = "Noclip (Walk through walls)", Default = false}):OnChanged(function(v) Config.Noclip = v end)

-- ==========================================
-- 5. BACKEND LOGIC (ລະບົບໂກງແລ່ນໄວ ແລະ ອື່ນໆ)
-- ==========================================
local hasDraw = pcall(function() local t = Drawing.new("Line") t:Remove() end)
local FOVCircle
if hasDraw then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2; FOVCircle.Color = Color3.fromRGB(0, 255, 255)
    FOVCircle.Filled = false; FOVCircle.Transparency = 1; FOVCircle.Visible = false
end

local ESP_L = {}
Players.PlayerRemoving:Connect(function(p)
    if ESP_L[p] then ESP_L[p]:Remove() ESP_L[p] = nil end
end)

local function IsValid(p)
    if not Config.Team then return true end
    if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then return false end
    return true
end

local function IsVisible(part)
    if not Config.Wall then return true end 
    local ray = RaycastParams.new()
    ray.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    ray.FilterType = Enum.RaycastFilterType.Blacklist
    local res = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000, ray)
    if not res or res.Instance:IsDescendantOf(part.Parent) then return true end return false
end

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local target, shortest = nil, Config.FOVRad
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hum = LocalPlayer.Character.Humanoid
        local hrp = LocalPlayer.Character.HumanoidRootPart
        
        if Config.Speed > 16 then
            hum.WalkSpeed = 16 
            if hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * ((Config.Speed - 16) * deltaTime))
            end
        else
            hum.WalkSpeed = 16
        end
        hum.JumpPower = Config.Jump
    end

    if Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and IsValid(v) and v.Character and v.Character:FindFirstChild(Config.Part) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local part = v.Character[Config.Part]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < shortest and IsVisible(part) then target = v; shortest = dist end
            end
        end
    end

    if Config.Aim and target then
        pcall(function()
            local tPos = target.Character[Config.Part].Position
            if Config.HardLock then Camera.CFrame = CFrame.new(Camera.CFrame.Position, tPos)
            else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, tPos), Config.Smooth) end
        end)
    end

    if hasDraw and FOVCircle then
        FOVCircle.Visible = Config.FOV; FOVCircle.Position = center; FOVCircle.Radius = Config.FOVRad
        FOVCircle.Color = target and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 255)
    end

    if Config.Hitbox then
        pcall(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and IsValid(v) and v.Character and v.Character:FindFirstChild("Head") then
                    v.Character.Head.Size = Vector3.new(Config.HitSize, Config.HitSize, Config.HitSize)
                    v.Character.Head.Transparency = Config.HitTrans
                    v.Character.Head.CanCollide = false
                end
            end
        end)
    end

    if hasDraw then
        if Config.ESPLine then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and IsValid(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if not ESP_L[v] then ESP_L[v] = Drawing.new("Line"); ESP_L[v].Thickness = 1.5; ESP_L[v].Color = Color3.fromRGB(255, 50, 50); ESP_L[v].Transparency = 1 end
                    if onScreen then ESP_L[v].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); ESP_L[v].To = Vector2.new(pos.X, pos.Y); ESP_L[v].Visible = true
                    else ESP_L[v].Visible = false end
                else if ESP_L[v] then ESP_L[v].Visible = false end end
            end
        else for _, l in pairs(ESP_L) do l.Visible = false end end
    end
end)

Window:SelectTab(1)
Fluent:Notify({ Title = "SUCCESS", Content = "ລະບົບ Hybrid Toggle ເປີດໃຊ້ແລ້ວ! ກົດ [ UI ] ໄດ້ເລີຍ.", Duration = 5 })

