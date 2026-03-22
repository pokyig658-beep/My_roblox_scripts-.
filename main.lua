-- [[ LAM HUB V17 - BEAR STYLE & FIXED visuals ]]
local LPlr = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- [[ 1. HARD BYPASS SYSTEM ( Safe from Kicks ) ]]
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
    if not checkcaller() and self:IsA("Humanoid") and (index == "WalkSpeed" or index == "JumpPower") then
        return 16
    end
    return oldIndex(self, index)
end))

-- [[ 2. CONFIG & SETTINGS ]]
_G.Aimbot = false
_G.ESP = false
_G.TracerLines = false
_G.FullBright = false
_G.WalkSpeed = 16
_G.FOVRadius = 120
_G.ShowFOV = true

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false -- ** ແກ້ບັກສີແດງທຶບຄືເກົ່າ **

-- [[ 3. UI DESIGN (BEAR HUB STYLE) ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
local Sidebar = Instance.new("Frame", Main) -- ** ແຖບລາຍການເບື້ອງຊ້າຍ **
local Container = Instance.new("ScrollingFrame", Main) -- ** ພື້ນທີ່ສະແດງປຸ່ມ **
local Title = Instance.new("TextLabel", Sidebar) -- ** ຊື່ HUB **
local UIStroke = Instance.new("UIStroke", Main)

-- ປຸ່ມ Logo L (ປິດ-ເປີດ)
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 45, 0, 45)
Toggle.Position = UDim2.new(0, 20, 0.4, 0)
Toggle.Text = "L"
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- ສີຂາວເໝືອນ Bear Style
Toggle.TextColor3 = Color3.new(1, 1, 1) -- ຕົວໜັງສືດຳ
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke", Toggle)
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)

-- Main Frame (ເບື້ອງຂວາ)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = true
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
UIStroke.Color = Color3.fromRGB(255, 255, 255) -- ຂອບຂາວເໝືອນ Bear Style
UIStroke.Thickness = 1.5

-- Sidebar Design (ແບບໃນຮູບ)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "LAM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

-- Container Design
Container.Size = UDim2.new(1, -130, 1, -10)
Container.Position = UDim2.new(0, 125, 0, 5)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- --- Helper Functions (Bear Style) ---
local function CreateSidebarTab(name, iconId)
    local tab = Instance.new("TextButton", Sidebar)
    tab.Size = UDim2.new(1, -10, 0, 30)
    tab.Position = UDim2.new(0, 5, 0, 45 + (#Sidebar:GetChildren()-2)*35)
    tab.Text = name
    tab.BackgroundColor3 = Color3.fromRGB(30,30,30)
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.Font = Enum.Font.GothamSemibold
    tab.TextSize = 12
    Instance.new("UICorner", tab)
end

local function CreateBtn(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

local function CreateSlider(name, min, max, default, callback)
    local f = Instance.new("Frame", Container)
    f.Size = UDim2.new(1, -10, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", f)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -10, 0, 25)
    t.Position = UDim2.new(0,5,0,0)
    t.Text = name .. ": " .. default
    t.TextColor3 = Color3.new(1, 1, 1)
    t.BackgroundTransparency = 1
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1, -20, 0, 4)
    bar.Position = UDim2.new(0, 10, 0, 35)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Slider ຂາວເໝືອນ Bear Style
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local move = UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local p = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    local v = math.floor(min + (p * (max - min)))
                    t.Text = name .. ": " .. v
                    callback(v)
                end
            end)
            UIS.InputEnded:Connect(function() move:Disconnect() end)
        end
    end)
end

-- --- Sidebar Tabs (Just for Look) ---
CreateSidebarTab("AIMBOT")
CreateSidebarTab("VISUALS")
CreateSidebarTab("LOCAL PLAYER")

-- --- Buttons & Sliders ---
CreateBtn("AIMLOCK (PRECISION): OFF", function(self)
    _G.Aimbot = not _G.Aimbot
    self.Text = "AIMLOCK: " .. (_G.Aimbot and "ON" or "OFF")
    self.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
end)

CreateBtn("ESP (HIGHLIGHT enemy): OFF", function(self)
    _G.ESP = not _G.ESP
    self.Text = "ESP: " .. (_G.ESP and "ON" or "OFF")
end)

CreateBtn("TRACER LINES (FF STYLE): OFF", function(self)
    _G.TracerLines = not _G.TracerLines
    self.Text = "LINES: " .. (_G.TracerLines and "ON" or "OFF")
end)

CreateBtn("FULL BRIGHT (MAP LIGHT): OFF", function(self)
    _G.FullBright = not _G.FullBright
    self.Text = "FULL BRIGHT: " .. (_G.FullBright and "ON" or "OFF")
end)

CreateSlider("SPEED (BYPASS SAFE)", 16, 300, 16, function(v) _G.WalkSpeed = v end)
CreateSlider("FOV RADIUS (AIM SELECT)", 10, 500, 120, function(v) _G.FOVRadius = v end)

-- [[ 4. CORE LOOP ]]
local tracers = {}
RunService.RenderStepped:Connect(function()
    local Center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Radius = _G.FOVRadius
    FOVCircle.Position = Center

    if LPlr.Character and LPlr.Character:FindFirstChild("Humanoid") then
        LPlr.Character.Humanoid.WalkSpeed = _G.WalkSpeed
    end

    if _G.FullBright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    end

    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target, closestMag = nil, _G.FOVRadius
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LPlr and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 and v.Team ~= LPlr.Team then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - Center).Magnitude
                    if mag < closestMag then target = v.Character.Head; closestMag = mag end
                end
            end
        end
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.18) end
    end

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LPlr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local isEnemy = (v.Team ~= LPlr.Team)
            local h = v.Character:FindFirstChild("LAM_ESP")
            if _G.ESP and v.Character.Humanoid.Health > 0 and isEnemy then
                if not h then
                    local hl = Instance.new("Highlight", v.Character)
                    hl.Name = "LAM_ESP"
                    hl.FillColor = Color3.new(1, 0, 0)
                    hl.AlwaysOnTop = true
                end
            else if h then h:Destroy() end end

            if _G.TracerLines and v.Character.Humanoid.Health > 0 and isEnemy then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    if not tracers[v.Name] then tracers[v.Name] = Drawing.new("Line") end
                    local l = tracers[v.Name]
                    l.Visible, l.From, l.To, l.Color = true, Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y), Vector2.new(pos.X, pos.Y), Color3.new(1, 0, 0)
                else if tracers[v.Name] then tracers[v.Name].Visible = false end end
            else if tracers[v.Name] then tracers[v.Name].Visible = false end end
        end
    end
end)
