-- [[ LAM HUB | Ultimate Aimbot & Perfect Lock ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ຕັ້ງຄ່າ Config ຫຼັກ
local Config = {
    ShowFOV = false,
    FovRadius = 150,
    CameraFOV = 70, 
    
    Aimbot = false,
    HardLock = false, -- ໂໝດລັອກຕິດໜຶບ
    Smoothness = 0.1,
    TargetPart = "Head", -- "Head" ຫຼື "HumanoidRootPart"
    WallCheck = true, -- ກວດສອບກຳແພງ
    
    SilentAim = false, 
    Hitbox = false,
    Tracers = false
}

---------------------------------------------------------
-- 1. ລະບົບ Backend & Drawing
---------------------------------------------------------
local hasDrawing = pcall(function() local t = Drawing.new("Line") t:Remove() end)

local FOVCircle
if hasDrawing then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(0, 255, 255)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.8
    FOVCircle.Visible = false
end

local ESP_Lines = {}
Players.PlayerRemoving:Connect(function(player)
    if ESP_Lines[player] then ESP_Lines[player]:Remove() ESP_Lines[player] = nil end
end)

---------------------------------------------------------
-- 2. ລະບົບກວດສອບ (Team & Wall Check)
---------------------------------------------------------
local function IsEnemy(player)
    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then return false end
    return true
end

-- ຟັງຊັນກວດສອບວ່າສັດຕູຢູ່ຫຼັງກຳແພງ ຫຼື ບໍ່ (Wall Check)
local function IsVisible(targetPart)
    if not Config.WallCheck then return true end -- ຖ້າປິດ Wall Check ໃຫ້ຖືວ່າເຫັນຕະຫຼອດ
    
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    
    -- ຖ້າບໍ່ຕຳຫຍັງ ຫຼື ຕຳຖືກຕົວສັດຕູ = ແນມເຫັນ
    if not result then return true end
    if result.Instance:IsDescendantOf(targetPart.Parent) then return true end
    return false
end

-- ຊອກຫາເປົ້າໝາຍທີ່ດີທີ່ສຸດໃນວົງ FOV
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Config.FovRadius 
    local mousePos = UserInputService:GetMouseLocation()

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and IsEnemy(v) and v.Character and v.Character:FindFirstChild(Config.TargetPart) and v.Character:FindFirstChild("Humanoid") then
            if v.Character.Humanoid.Health > 0 then
                local targetPart = v.Character[Config.TargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    
                    -- ຕ້ອງຢູ່ໃນວົງມົນ ແລະ (ຜ່ານການທົດສອບກຳແພງ)
                    if distance < shortestDistance and IsVisible(targetPart) then
                        closestPlayer = v
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closestPlayer
end

---------------------------------------------------------
-- 3. ລະບົບ Silent Aim (Magic Bullet)
---------------------------------------------------------
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if Config.SilentAim and t == LocalPlayer:GetMouse() and (k == "Hit" or k == "Target") then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Config.TargetPart) then
            if k == "Hit" then
                return target.Character[Config.TargetPart].CFrame 
            elseif k == "Target" then
                return target.Character[Config.TargetPart]
            end
        end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

---------------------------------------------------------
-- 4. ລະບົບ RenderStepped (ຫັນກ້ອງ & ESP)
---------------------------------------------------------
RunService.RenderStepped:Connect(function()
    
    Camera.FieldOfView = Config.CameraFOV
    local mouseLocation = UserInputService:GetMouseLocation()
    local currentTarget = GetClosestPlayer()

    -- ລະບົບ Aimbot (ຫັນກ້ອງ)
    if Config.Aimbot and currentTarget then
        pcall(function()
            local targetPart = currentTarget.Character:FindFirstChild(Config.TargetPart)
            if targetPart then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                
                if Config.HardLock then
                    -- ລັອກຕິດໜຶບ 100% (ບໍ່ມີລາກ)
                    Camera.CFrame = targetCFrame
                else
                    -- ລັອກແບບນຸ້ມນວນ (Soft Aim)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Config.Smoothness)
                end
            end
        end)
    end
    
    -- ອັບເດດວົງມົນ FOV
    if hasDrawing and FOVCircle then
        if Config.ShowFOV then
            FOVCircle.Visible = true
            FOVCircle.Position = mouseLocation
            FOVCircle.Radius = Config.FovRadius
            
            if currentTarget then
                FOVCircle.Color = Color3.fromRGB(255, 50, 50) -- ສີແດງ (ລັອກເປົ້າແລ້ວ)
            else
                FOVCircle.Color = Color3.fromRGB(0, 255, 255) -- ສີຟ້າ (ປົກກະຕິ)
            end
        else
            FOVCircle.Visible = false
        end
    end

    -- Hitbox Logic
    if Config.Hitbox then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and IsEnemy(v) and v.Character and v.Character:FindFirstChild("Head") then
                v.Character.Head.Size = Vector3.new(5, 5, 5)
                v.Character.Head.Transparency = 0.6
                v.Character.Head.CanCollide = false
            end
        end
    end

    -- ESP Tracers (ມອງເສັ້ນ)
    if hasDrawing then
        if Config.Tracers then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and IsEnemy(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                    if v.Character.Humanoid.Health > 0 then
                        local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                        
                        if not ESP_Lines[v] then
                            ESP_Lines[v] = Drawing.new("Line")
                            ESP_Lines[v].Thickness = 1.5
                            ESP_Lines[v].Color = Color3.fromRGB(255, 50, 50)
                            ESP_Lines[v].Transparency = 1
                        end
                        
                        if onScreen then
                            ESP_Lines[v].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            ESP_Lines[v].To = Vector2.new(pos.X, pos.Y)
                            ESP_Lines[v].Visible = true
                        else
                            ESP_Lines[v].Visible = false
                        end
                    else
                        if ESP_Lines[v] then ESP_Lines[v].Visible = false end
                    end
                else
                    if ESP_Lines[v] then ESP_Lines[v].Visible = false end
                end
            end
        else
            for _, line in pairs(ESP_Lines) do line.Visible = false end
        end
    end
end)

---------------------------------------------------------
-- 5. ການສ້າງໜ້າຕາ UI ດ້ວຍ Rayfield Library
---------------------------------------------------------
local Window = Rayfield:CreateWindow({
   Name = "LAM HUB | Ultimate Aim",
   LoadingTitle = "Loading LAM HUB...",
   LoadingSubtitle = "By LAM",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false, 
})

local CombatTab = Window:CreateTab("🎯 Combat", 4483345998)
local VisualTab = Window:CreateTab("👁️ Visuals", 4483345998)

-- ================= Combat Tab =================
CombatTab:CreateSection("Aimbot Settings (ລະບົບຫັນກ້ອງ)")

CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value) Config.Aimbot = Value end,
})

CombatTab:CreateToggle({
   Name = "🔥 Hard Lock (ລັອກຕິດໜຶບ 100%)",
   CurrentValue = false,
   Flag = "HardLockToggle",
   Callback = function(Value) Config.HardLock = Value end,
})

CombatTab:CreateSlider({
   Name = "Soft Aim Speed (ໃຊ້ເມື່ອປິດ Hard Lock)",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "Speed",
   CurrentValue = 0.1,
   Flag = "SmoothSlider",
   Callback = function(Value) Config.Smoothness = Value end,
})

CombatTab:CreateSection("Aimbot Config (ການຕັ້ງຄ່າເປົ້າໝາຍ)")

CombatTab:CreateDropdown({
   Name = "Target Part (ເລືອກຈຸດລັອກ)",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "TargetDropdown",
   Callback = function(Option) Config.TargetPart = Option[1] end,
})

CombatTab:CreateToggle({
   Name = "🧱 Wall Check (ບໍ່ລັອກຄົນຫຼັງກຳແພງ)",
   CurrentValue = true,
   Flag = "WallCheckToggle",
   Callback = function(Value) Config.WallCheck = Value end,
})

CombatTab:CreateSection("Silent Aim & Hitbox")

CombatTab:CreateToggle({
   Name = "Enable Silent Aim (ຍິງເຂົ້າເອງ)",
   CurrentValue = false,
   Flag = "SilentAimToggle",
   Callback = function(Value) Config.SilentAim = Value end,
})

CombatTab:CreateToggle({
   Name = "Ultra Hitbox (ຂະຫຍາຍຫົວ)",
   CurrentValue = false,
   Flag = "HitboxToggle",
   Callback = function(Value)
        Config.Hitbox = Value
        if not Value then
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") then
                    v.Character.Head.Size = Vector3.new(1.2, 1.2, 1.2)
                    v.Character.Head.Transparency = 0
                end
            end
        end
   end,
})

-- ================= Visuals Tab =================
VisualTab:CreateSection("ESP Settings")
VisualTab:CreateToggle({
   Name = "Show Tracers (ມອງເສັ້ນ)",
   CurrentValue = false,
   Flag = "TracersToggle",
   Callback = function(Value) Config.Tracers = Value end,
})

VisualTab:CreateSection("FOV Circle")
VisualTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = false,
   Flag = "FOVToggle",
   Callback = function(Value) Config.ShowFOV = Value end,
})
VisualTab:CreateSlider({
   Name = "FOV Radius (ປັບຂະໜາດວົງມົນ)",
   Range = {50, 600},
   Increment = 10,
   Suffix = "Radius",
   CurrentValue = 150,
   Flag = "FOVRadiusSlider",
   Callback = function(Value) Config.FovRadius = Value end,
})

VisualTab:CreateSection("Camera View")
VisualTab:CreateSlider({
   Name = "Camera FOV",
   Range = {70, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "CamFOVSlider",
   Callback = function(Value) Config.CameraFOV = Value end,
})

Rayfield:Notify({
   Title = "LAM HUB Upgraded!",
   Content = "ອັບເກຣດລະບົບ Hard Lock ແລະ Wall Check ແລ້ວ.",
   Duration = 5,
   Image = 4483345998,
})

