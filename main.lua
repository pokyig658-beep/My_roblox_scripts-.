local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("LAM V3 - BLOX FRUITS", "DarkScene")

-- Tab ຫຼັກ
local Tab1 = Window:NewTab("Auto Farm")
local Section1 = Tab1:NewSection("Farm Settings")

_G.AutoFarm = false

Section1:NewToggle("Auto Farm Level", "ຟາມເວລ + ຕີມອນເຕີ", function(state)
    _G.AutoFarm = state
    spawn(function()
        while _G.AutoFarm do
            wait()
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        -- ວາບໄປຫາມອນເຕີ
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                        -- ໂຈມຕີ
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(851, 158))
                    end
                end
            end)
        end
    end)
end)

-- Tab ອັບສະແຕັດ
local Tab2 = Window:NewTab("Auto Stats")
local Section2 = Tab2:NewSection("Choose Stat")

_G.AutoStats = false
Section2:NewToggle("Auto Stats (Melee)", "ອັບໝັດອັດຕະໂນມັດ", function(state)
    _G.AutoStats = state
    spawn(function()
        while _G.AutoStats do
            wait(1)
            local args = { [1] = "AddPoint", [2] = "Melee", [3] = 1 }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end)
end)
