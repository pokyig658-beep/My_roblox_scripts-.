local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 - BLOX FRUITS",
   LoadingTitle = "ກຳລັງໂຫຼດສະຄິບ...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = {
      Enabled = false
   }
})

local Tab = Window:CreateTab("Main Farm", 4483362458)
local Section = Tab:CreateSection("Farm Settings")

Tab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      while _G.AutoFarm do
         task.wait()
         pcall(function()
            if _G.AutoFarm then
               -- ລະບົບຊອກຫາມອນເຕີ ແລະ ວາບໄປຫາ
               for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                  if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                     game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
                  end
               end
            end
         end)
      end
   end,
})

Tab:CreateSlider({
   Name = "WalkSpeed (ຄວາມໄວ)",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

Rayfield:Notify({
   Title = "Executed!",
   Content = "ສະຄິບພ້ອມໃຊ້ງານແລ້ວ!",
   Duration = 5,
   Image = 4483362458,
})
