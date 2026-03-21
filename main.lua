-- LAM V3 - HACKER FAST ATTACK (NO COOLDOWN)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | GOD MODE FARM",
   LoadingTitle = "ກຳລັງ Bypass Cooldown...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

_G.AutoFarm = false
_G.FastAttack = true
_G.Distance = 8 -- ໄລຍະຫ່າງ (ປັບໃຫ້ສູງຂຶ້ນເພື່ອບໍ່ໃຫ້ມອນຕີຮອດ)
_G.Weapon = "Combat"

-- ຟັງຊັນຖືອາວຸດ
function EquipWeapon()
    pcall(function()
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(_G.Weapon) or game.Players.LocalPlayer.Character:FindFirstChild(_G.Weapon)
        if tool and not game.Players.LocalPlayer.Character:FindFirstChild(tool.Name) then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end)
end

local Tab = Window:CreateTab("Auto Farm", 4483362458)

Tab:CreateToggle({
   Name = "Start Fast Farm (ຕີລົວ + ປອດໄພ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      
      -- Loop: ວາບ ແລະ ຮັບ Quest
      spawn(function()
         while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
               local questGui = game.Players.LocalPlayer.PlayerGui.Main.Quest
               if not questGui.Visible then
                  -- ວາບໄປຮັບເຄສ
                  local npc = game.Workspace.NPCs:FindFirstChild("Bandit Quest Giver")
                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
               else
                  -- ວາບໄປຕີມອນເຕີ
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                           task.wait()
                           EquipWeapon()
                           
                           -- ວາບໄປລັອກເປົ້າໝາຍ (ຢູ່ເທິງຫົວ 8 studs ມອນຕີບໍ່ຮອດ)
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                           
                           -- ເຮັດໃຫ້ມອນເຕີຢຸດ (Stun)
                           v.HumanoidRootPart.CanCollide = false
                           v.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                           
                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not questGui.Visible
                        break
                     end
                  end
               end
            end)
         end
      end)

      -- Loop: Fast Attack (ຕີລົວແບບແຮັກ)
      spawn(function()
         while _G.AutoFarm do
            task.wait(0.01) -- ຄວາມໄວລະດັບ Hacker
            pcall(function()
               local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
               if tool then
                  -- ສົ່ງຂໍ້ມູນການຕີລົວໆໂດຍບໍ່ມີ Cooldown
                  game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                  game:GetService("VirtualUser"):CaptureController()
                  game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
               end
            end)
         end
      end)
   end,
})

Tab:CreateSlider({
   Name = "ໄລຍະຫ່າງ (Distance)",
   Range = {5, 15},
   Increment = 1,
   CurrentValue = 8,
   Callback = function(Value) _G.Distance = Value end,
})

Tab:CreateInput({
   Name = "ພິມຊື່ມີດ/ໝັດ (COMBAT)",
   PlaceholderText = "COMBAT / KATANA",
   Callback = function(Text) _G.Weapon = Text end,
})
