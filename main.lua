-- LAM V3 - DELTA EDITION (ULTRA LIGHT)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmBtn = Instance.new("TextButton")
local SpeedBtn = Instance.new("TextButton")

-- ຕັ້ງຄ່າໜ້າຕາ UI (ສີດຳ-ແດງ ແບບໂຫດໆ)
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- ລາກໄປມາໄດ້

Title.Parent = MainFrame
Title.Text = "LAM V3 - DELTA"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- ປຸ່ມ Auto Farm
FarmBtn.Parent = MainFrame
FarmBtn.Text = "Auto Farm: OFF"
FarmBtn.Position = UDim2.new(0, 10, 0, 50)
FarmBtn.Size = UDim2.new(0, 180, 0, 40)
FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ປຸ່ມ Speed
SpeedBtn.Parent = MainFrame
SpeedBtn.Text = "Speed: OFF"
SpeedBtn.Position = UDim2.new(0, 10, 0, 100)
SpeedBtn.Size = UDim2.new(0, 180, 0, 40)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ລະບົບທຳງານ
_G.AutoFarm = false
_G.Speed = false

FarmBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    FarmBtn.Text = _G.AutoFarm and "Auto Farm: ON ✅" or "Auto Farm: OFF ❌"
    FarmBtn.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    
    spawn(function()
        while _G.AutoFarm do
            task.wait()
            pcall(function()
                for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        -- ວາບໄປຂ້າງເທິງມອນເຕີເລັກນ້ອຍ
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    end
                end
            end)
        end
    end)
end)

SpeedBtn.MouseButton1Click:Connect(function()
    _G.Speed = not _G.Speed
    SpeedBtn.Text = _G.Speed and "Speed: ON ✅" or "Speed: OFF ❌"
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed and 100 or 16
end)
