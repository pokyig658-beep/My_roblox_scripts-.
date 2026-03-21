local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | AUTO FARM LEVEL",
   LoadingTitle = "ກຳລັງກວດສອບເລເວວ...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Farming", 4483362458)
local Section = Tab:CreateSection("Main Farm")

_G.AutoFarm = false

-- ຟັງຊັນເລືອກມອນເຕີຕາມເລເວວ
function GetTarget()
    local lvl = game.Players.LocalPlayer.Data.Level.Value
    local target = ""
    
    if lvl >= 0 and lvl < 10 then
        target = "Bandit"
    elseif lvl >= 10 and lvl < 15 then
        target = "Monkey"
    elseif lvl >= 15 and lvl < 30 then
        target = "Gorilla"
    -- ເຈົ້າສາມາດເພີ່ມເລເວວອື່ນໆໃສ່ບ່ອນນີ້ໄດ້
    end
    return target
end

Tab:CreateToggle({
   Name = "Auto Farm Level (ຕີຕາມເວວ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      spawn(function()
         while _G.AutoFarm do
            task.wait()
            pcall(function()
               local targetName = GetTarget()
               for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                  -- ກວດສອບວ່າເປັນມອນເຕີທີ່ຖືກຕ້ອງ ແລະ ຍັງບໍ່ຕາຍ
                  if v.Name == targetName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                     -- ວາບໄປລັອກເປົ້າໝາຍ
                     game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
                     
                     -- ລະບົບຕີອັດຕະໂນມັດ (Virtual Click)
                     local VirtualUser = game:GetService("VirtualUser")
                     VirtualUser:CaptureController()
                     VirtualUser:ClickButton1(Vector2.new(851, 158))
                  end
               end
            end)
         end
      end)
   end,
})

Tab:CreateSlider({
   Name = "Speed (ຄວາມໄວ)",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})
