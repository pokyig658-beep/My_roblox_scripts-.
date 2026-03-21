-- LAM V3 PREMIUM - AUTO FARM + AUTO CLICK + BRING MOB
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | AUTO ATTACK FIX",
   LoadingTitle = "ກຳລັງຕັ້ງຄ່າລະບົບຕີອັດຕະໂນມັດ...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

_G.AutoFarm = false
_G.BringMob = true
_G.FastAttack = true

-- ຟັງຊັນຖືອາວຸດ (Equip Weapon)
function EquipWeapon()
    for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == "Melee" or v.ToolTip == "Sword" or v.Name == "Combat" or v.Name == "Katana") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
end

-- ຟັງຊັນຮັບ Quest ຕາມ Level
function GetQuest()
    local lvl = game.Players.LocalPlayer.Data.Level.Value
    if lvl < 10 then return "BanditQuest1", "Bandit", "Bandit Quest Giver"
    elseif lvl < 15 then return "BanditQuest2", "Monkey", "Monkey Quest Giver"
    else return "BanditQuest1", "Bandit", "Bandit Quest Giver" end
end

local Tab = Window:CreateTab("Farm Level", 4483362458)

Tab:CreateToggle({
   Name = "Start Auto Farm (ຕີເອງ + ລວມມອນ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      
      -- Loop ສຳລັບການວາບ ແລະ ຮັບ Quest
      spawn(function()
         while _G.AutoFarm do
            task.wait()
            pcall(function()
               local qName, mName, nName = GetQuest()
               
               if not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
                  -- ວາບໄປຮັບ Quest
                  local npc = game.Workspace.NPCs:FindFirstChild(nName)
                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qName, 1)
               else
                  -- ວາບໄປຕີມອນເຕີ
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == mName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        EquipWeapon()
                        
                        -- ລວມມອນເຕີ (Bring Mob)
                        if _G.BringMob then
                            v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                            v.HumanoidRootPart.CanCollide = false
                        end
                        
                        -- ວາບໄປລັອກເປົ້າໝາຍ (Safe Farm)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                     end
                  end
               end
            end)
         end
      end)

      -- Loop ສຳລັບການຕີອັດຕະໂນມັດ (Auto Click / Swing)
      spawn(function()
         while _G.AutoFarm do
            task.wait(0.1) -- ຄວາມໄວໃນການຕີ
            pcall(function()
               if _G.AutoFarm then
                  local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                  if tool then
                     -- ສັ່ງໃຫ້ອາວຸດ Swing (ຕີ) ເອງອັດຕະໂນມັດ
                     tool:Activate() 
                     -- ໃຊ້ Remote ຊ່ວຍໃຫ້ຕີແຮງຂຶ້ນ
                     game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                  end
               end
            end)
         end
      end)
   end,
})

Tab:CreateToggle({
   Name = "Bring Mob (ລວມມອນເຕີ)",
   CurrentValue = true,
   Callback = function(Value) _G.BringMob = Value end,
})
