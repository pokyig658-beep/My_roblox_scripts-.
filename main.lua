-- LAM V3 HACKER EDITION - ANTI-FLY & SMOOTH FARM
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | HACKER HUB",
   LoadingTitle = "ກຳລັງ Bypass ລະບົບປ້ອງກັນ...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

-- -- -- SETTINGS -- -- --
_G.AutoFarm = false
_G.Weapon = "Combat" -- ພິມຊື່ມີດ/ໝັດ (COMBAT)
_G.FarmDistance = 5 -- ໄລຍະຫ່າງຈາກມອນເຕີ (ປ້ອງກັນການບິນ)

-- -- -- HACKER FUNCTIONS -- -- --

-- ຟັງຊັນຖືອາວຸດອັດຕະໂນມັດ
function EquipWeapon()
    pcall(function()
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(_G.Weapon) or game.Players.LocalPlayer.Character:FindFirstChild(_G.Weapon)
        if tool and not game.Players.LocalPlayer.Character:FindFirstChild(tool.Name) then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end)
end

-- ຟັງຊັນວາບແບບນິ້ມນວນ (Smooth Tween) - ປ້ອງກັນການບິນຂຶ້ນຟ້າ
function SmoothTween(targetCFrame)
    local Character = game.Players.LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = targetCFrame
    end
end

-- -- -- MAIN TABS -- -- --
local Tab = Window:CreateTab("Auto Farm", 4483362458)

Tab:CreateToggle({
   Name = "Start God Farm (ຕີລົວໆ + ບໍ່ບິນ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      
      spawn(function()
         while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
               local questGui = game.Players.LocalPlayer.PlayerGui.Main.Quest
               
               -- 1. ຮັບ Quest (Bandit ເທົ່ານັ້ນສຳລັບເວວເຈົ້າ)
               if not questGui.Visible then
                  local npc = game.Workspace.NPCs:FindFirstChild("Bandit Quest Giver")
                  if npc then
                     SmoothTween(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
                     task.wait(0.5)
                     game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
                  end
               else
                  -- 2. ວາບໄປຕີມອນເຕີ (ແບບລັອກເປົ້າໝາຍ)
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                           task.wait()
                           EquipWeapon()
                           
                           -- ລັອກຕຳແໜ່ງໃຫ້ຢູ່ "ໃຕ້ທ້ອງ" ຫຼື "ທາງໜ້າ" ມອນເຕີ (ບໍ່ໃຫ້ບິນຂຶ້ນຟ້າ)
                           SmoothTween(v.HumanoidRootPart.CFrame * CFrame.new(0, -_G.FarmDistance, 0) * CFrame.Angles(math.rad(90), 0, 0))
                           
                           -- ລະບົບຕີແບບລົວໆ (No Animation)
                           local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                           if tool then 
                              tool:Activate() 
                              game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                           end
                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not questGui.Visible
                     end
                  end
               end
            end)
         end
      end)
   end,
})

Tab:CreateInput({
   Name = "ໃສ່ຊື່ມີດ (ຕົວພິມໃຫຍ່ທັງໝົດ)",
   PlaceholderText = "COMBAT / KATANA",
   Callback = function(Text) _G.Weapon = Text end,
})

Tab:CreateSlider({
   Name = "ໄລຍະຫ່າງ (Farm Distance)",
   Range = {1, 15},
   Increment = 1,
   CurrentValue = 5,
   Callback = function(Value) _G.FarmDistance = Value end,
})
