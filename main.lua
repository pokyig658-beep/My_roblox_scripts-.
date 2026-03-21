-- LAM V3 ULTRA LIGHT - ANTI-CRASH & AUTO CLICK
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | FIX ALL BUGS",
   LoadingTitle = "ກຳລັງຕັ້ງຄ່າລະບົບແບບລື່ນໆ...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

_G.AutoFarm = false
_G.Weapon = "Combat" -- ພິມຊື່ມີດ/ໝັດ ຂອງເຈົ້າບ່ອນນີ້

-- ຟັງຊັນຖືອາວຸດ
function EquipWeapon()
    pcall(function()
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(_G.Weapon) or game.Players.LocalPlayer.Character:FindFirstChild(_G.Weapon)
        if tool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end)
end

-- ຟັງຊັນຮັບ Quest ຕາມ Level (0-15)
function GetQuest()
    local lvl = game.Players.LocalPlayer.Data.Level.Value
    if lvl < 10 then return "BanditQuest1", "Bandit", "Bandit Quest Giver"
    elseif lvl < 15 then return "BanditQuest2", "Monkey", "Monkey Quest Giver"
    else return "BanditQuest1", "Bandit", "Bandit Quest Giver" end
end

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateToggle({
   Name = "Start Auto Farm (ຕີອັດຕະໂນມັດ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      
      -- Loop ວາບ ແລະ ຮັບ Quest (ປັບໃຫ້ລື່ນ ບໍ່ໃຫ້ເດ້ງ)
      spawn(function()
         while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
               local qName, mName, nName = GetQuest()
               
               if not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
                  -- ວາບໄປຮັບ Quest
                  local npc = game.Workspace.NPCs:FindFirstChild(nName)
                  if npc then
                     game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                     game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qName, 1)
                  end
               else
                  -- ວາບໄປຕີມອນເຕີ (Fix ບໍ່ໃຫ້ມອນບິນມົ້ວ)
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == mName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                           task.wait()
                           EquipWeapon()
                           -- ວາບໄປລັອກເປົ້າໝາຍຢູ່ເທິງຫົວ (ໄລຍະທີ່ຕີຮອດ)
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                           
                           -- ສັ່ງໃຫ້ຕີອັດຕະໂນມັດ
                           local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                           if tool then tool:Activate() end
                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible
                     end
                  end
               end
            end)
         end
      end)
   end,
})

Tab:CreateInput({
   Name = "ໃສ່ຊື່ມີດ/ໝັດ (Weapon Name)",
   PlaceholderText = "Combat / Katana / Melee",
   Callback = function(Text) _G.Weapon = Text end,
})
