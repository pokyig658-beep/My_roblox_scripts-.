--[[
    LAM HUB PREMIUM [ The Memory Fix ]
    - Modern Rayfield UI (Sidebar, Minimize/Close)
    - Combat: Smooth Aimbot, Silent Aim (Instant Auto-Headshot)
    - Hitbox: Hitbox Expander, Antenna Head (Long Head)
    - Visuals: FOV Circle, Tracers (Red/Yellow Neon)
    - World: Full Bright (Map Brightness)
    - Player: WalkSpeed, JumpPower
    - Optimization: Improved Silent Aim Hook (Fixed Bullet Issue)
--]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM HUB PREMIUM",
   LoadingTitle = "LAM HUB PREMIUM Loading...",
   LoadingSubtitle = "by Manus AI",
   ConfigurationAddon = {
      Enabled = true,
      FolderName = "LamHub",
      FileName = "PremiumConfig"
   },
   KeySystem = false
})

-- // Services // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // Global Settings // --
_G.AimbotEnabled = false
_G.SilentAimEnabled = false
_G.TeamCheck = true
_G.AimPart = "Head"
_G.Smoothness = 2
_G.FOVEnabled = false
_G.FOVRadius = 150
_G.TracerEnabled = false
_G.TracerColor = Color3.fromRGB(255, 0, 0)
_G.FullBright = false

-- // Hitbox & Antenna Settings // --
_G.HitboxEnabled = false
_G.HitboxSize = 5
_G.HitboxTransparency = 0.7
_G.AntennaEnabled = false
_G.AntennaSize = 20

-- // Store Original Lighting Settings // --
local OriginalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd
}

-- // Drawing Setup (FOV Circle) // --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = _G.FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Thickness = 1.5
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false

-- // Tracer System // --
local Tracers = {}

local function CreateTracer(player)
    if Tracers[player] then return Tracers[player] end
    local Line = Drawing.new("Line")
    Line.Visible = false
    Line.Color = _G.TracerColor
    Line.Thickness = 2
    Line.Transparency = 1
    Tracers[player] = Line
    return Line
end

local function RemoveTracer(player)
    if Tracers[player] then
        Tracers[player]:Remove()
        Tracers[player] = nil
    end
end

-- // Tabs // --
local CombatTab = Window:CreateTab("Combat", 4483362458)
local SilentTab = Window:CreateTab("Silent Aim", 4483362458)
local HitboxTab = Window:CreateTab("Hitbox", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483345998)
local WorldTab = Window:CreateTab("World", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362748)

-- // Combat Section // --
CombatTab:CreateSection("Aimbot Settings")
CombatTab:CreateToggle({
   Name = "Enable Smooth Aimbot (Mouse Right)",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value) _G.AimbotEnabled = Value end,
})
CombatTab:CreateSlider({
   Name = "Aimbot Smoothness",
   Range = {1, 10},
   Increment = 1,
   Suffix = "Smooth",
   CurrentValue = 2,
   Flag = "SmoothSlider",
   Callback = function(Value) _G.Smoothness = Value end,
})
CombatTab:CreateDropdown({
   Name = "Target Part",
   Options = {"Head", "UpperTorso", "HumanoidRootPart"},
   CurrentOption = "Head",
   MultipleOptions = false,
   Flag = "PartDropdown",
   Callback = function(Option) _G.AimPart = Option[1] end,
})
CombatTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = true,
   Flag = "TeamToggle",
   Callback = function(Value) _G.TeamCheck = Value end,
})

-- // Silent Aim Section // --
SilentTab:CreateSection("Silent Aim (Auto Headshot)")
SilentTab:CreateToggle({
   Name = "Enable Silent Aim",
   CurrentValue = false,
   Flag = "SilentAimToggle",
   Callback = function(Value) _G.SilentAimEnabled = Value end,
})
SilentTab:CreateLabel("Silent Aim redirects bullets to target's head.")
SilentTab:CreateLabel("No aiming required. Works on Left Click.")

-- // Hitbox Section // --
HitboxTab:CreateSection("Hitbox & Antenna")
HitboxTab:CreateToggle({
   Name = "Enable Hitbox Expander",
   CurrentValue = false,
   Flag = "HitboxToggle",
   Callback = function(Value) _G.HitboxEnabled = Value end,
})
HitboxTab:CreateSlider({
   Name = "Hitbox Size",
   Range = {1, 20},
   Increment = 1,
   Suffix = "Size",
   CurrentValue = 5,
   Flag = "HitboxSizeSlider",
   Callback = function(Value) _G.HitboxSize = Value end,
})
HitboxTab:CreateToggle({
   Name = "Enable Antenna Head (Long Head)",
   CurrentValue = false,
   Flag = "AntennaToggle",
   Callback = function(Value) _G.AntennaEnabled = Value end,
})
HitboxTab:CreateSlider({
   Name = "Antenna Height",
   Range = {5, 50},
   Increment = 5,
   Suffix = "Height",
   CurrentValue = 20,
   Flag = "AntennaSizeSlider",
   Callback = function(Value) _G.AntennaSize = Value end,
})

-- // Visuals Section // --
VisualsTab:CreateSection("ESP & FOV")
VisualsTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = false,
   Flag = "FOVToggle",
   Callback = function(Value) _G.FOVEnabled = Value; FOVCircle.Visible = Value end,
})
VisualsTab:CreateSlider({
   Name = "FOV Radius",
   Range = {50, 500},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 150,
   Flag = "FOVSlider",
   Callback = function(Value) _G.FOVRadius = Value; FOVCircle.Radius = Value end,
})
VisualsTab:CreateToggle({
   Name = "Enable Tracers (Line View)",
   CurrentValue = false,
   Flag = "TracerToggle",
   Callback = function(Value)
      _G.TracerEnabled = Value
      if not Value then for _, line in pairs(Tracers) do line.Visible = false end end
   end,
})
VisualsTab:CreateDropdown({
   Name = "Tracer Color",
   Options = {"Deep Red", "Neon Yellow", "Cyan", "White"},
   CurrentOption = "Deep Red",
   MultipleOptions = false,
   Flag = "ColorDropdown",
   Callback = function(Option)
      if Option[1] == "Deep Red" then _G.TracerColor = Color3.fromRGB(255, 0, 0)
      elseif Option[1] == "Neon Yellow" then _G.TracerColor = Color3.fromRGB(255, 255, 0)
      elseif Option[1] == "Cyan" then _G.TracerColor = Color3.fromRGB(0, 255, 255)
      elseif Option[1] == "White" then _G.TracerColor = Color3.fromRGB(255, 255, 255) end
   end,
})

-- // World Section // --
WorldTab:CreateSection("Map Lighting")
WorldTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBrightToggle",
   Callback = function(Value)
      _G.FullBright = Value
      if not Value then
          Lighting.Ambient = OriginalLighting.Ambient
          Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
          Lighting.Brightness = OriginalLighting.Brightness
          Lighting.ClockTime = OriginalLighting.ClockTime
      end
   end,
})

-- // Player Section // --
PlayerTab:CreateSection("Player Mods")
PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
          LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})
PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
          LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

-- // Core Logic // --
local function GetClosestPlayer()
    local Target = nil
    local MaxDist = _G.FOVRadius
    local MousePos = UserInputService:GetMouseLocation()
    
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild(_G.AimPart) then
            local Humanoid = Player.Character:FindFirstChild("Humanoid")
            if Humanoid and Humanoid.Health > 0 then
                if _G.TeamCheck and Player.Team == LocalPlayer.Team then continue end
                
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Player.Character[_G.AimPart].Position)
                if OnScreen then
                    local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    if Dist < MaxDist then
                        MaxDist = Dist
                        Target = Player
                    end
                end
            end
        end
    end
    return Target
end

-- Silent Aim Hook (Advanced Hooking for Bullet Redirection)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if _G.SilentAimEnabled and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast" or method == "FindPartOnRay") then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            local HeadPos = Target.Character.Head.Position
            if method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
                args[1] = Ray.new(Camera.CFrame.Position, (HeadPos - Camera.CFrame.Position).Unit * 1000)
            elseif method == "Raycast" then
                args[2] = (HeadPos - args[1]).Unit * 1000
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- Hook Index for Mouse.Hit/Mouse.Target (Works in many games)
mt.__index = newcclosure(function(self, index)
    if _G.SilentAimEnabled and (index == "Hit" or index == "Target") and self == Mouse then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            if index == "Hit" then
                return Target.Character.Head.CFrame
            elseif index == "Target" then
                return Target.Character.Head
            end
        end
    end
    return oldIndex(self, index)
end)

setreadonly(mt, true)

local IsAiming = false
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then IsAiming = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then IsAiming = false end
end)

-- Main Loop (Optimized)
RunService.RenderStepped:Connect(function()
    if _G.FOVEnabled then FOVCircle.Position = UserInputService:GetMouseLocation() end
    
    if _G.FullBright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    end
    
    local Target = GetClosestPlayer()
    
    -- Smooth Aimbot
    if _G.AimbotEnabled and IsAiming and Target then
        local TargetPos, OnScreen = Camera:WorldToViewportPoint(Target.Character[_G.AimPart].Position)
        if OnScreen then
            local MousePos = UserInputService:GetMouseLocation()
            mousemoverel((TargetPos.X - MousePos.X) / _G.Smoothness, (TargetPos.Y - MousePos.Y) / _G.Smoothness)
        end
    end
    
    -- Hitbox & Tracers
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local Head = p.Character:FindFirstChild("Head")
            local HRP = p.Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = p.Character:FindFirstChild("Humanoid")
            
            if Head and Humanoid and Humanoid.Health > 0 then
                local isEnemy = not (_G.TeamCheck and p.Team == LocalPlayer.Team)
                
                if isEnemy then
                    if _G.HitboxEnabled then
                        Head.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                        Head.Transparency = _G.HitboxTransparency
                        Head.CanCollide = false
                    elseif _G.AntennaEnabled then
                        Head.Size = Vector3.new(1.2, _G.AntennaSize, 1.2)
                        Head.Transparency = 0.5
                        Head.CanCollide = false
                    else
                        Head.Size = Vector3.new(1.2, 1.2, 1.2)
                        Head.Transparency = 0
                        Head.CanCollide = true
                    end
                else
                    Head.Size = Vector3.new(1.2, 1.2, 1.2)
                    Head.Transparency = 0
                end
                
                if _G.TracerEnabled and HRP and isEnemy then
                    local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
                    local Tracer = CreateTracer(p)
                    if OnScreen then
                        Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        Tracer.To = Vector2.new(Pos.X, Pos.Y)
                        Tracer.Color = _G.TracerColor
                        Tracer.Visible = true
                    else
                        Tracer.Visible = false
                    end
                elseif Tracers[p] then
                    Tracers[p].Visible = false
                end
            elseif Tracers[p] then
                Tracers[p].Visible = false
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p) RemoveTracer(p) end)

Rayfield:Notify({
   Title = "LAM HUB PREMIUM Loaded!",
   Content = "Silent Aim & Bullet Fix Active!",
   Duration = 5,
   Image = 4483362458,
})
