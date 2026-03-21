local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | FIX ATTACK",
   LoadingTitle = "ລໍຖ້າການເຊື່ອມຕໍ່...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

_G.AutoFarm = false
_G.Weapon = "Combat" -- ປ່ຽນຊື່ດາບ ຫຼື ໝັດ ທີ່ເຈົ້າໃຊ້ຢູ່ບ່ອນນີ້

-- ຟັງຊັນຖືອາວຸດອັດຕະໂນມັດ
function EquipWeapon()
    pcall(function()
        if game.Players.LocalPlayer.Backpack:FindFirstChild(_G.Weapon) then
            local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(_G.Weapon)
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end)
end

-- ຟັງຊັນຮັບ Quest ຕາມ Level
function GetQuest()
    local lvl = game.Players.LocalPlayer.Data.Level.Value
    if lvl >= 1 and lvl < 10 then
        return "BanditQuest1", "Bandit", "Bandit Quest Giver"
    elseif lvl >= 10 and lvl < 15 then
        return "BanditQuest2", "Monkey", "Monkey Quest Giver"
    else
        return "BanditQuest1", "Bandit", "Bandit Quest Giver"
    end
end

local Tab = Window:CreateTab("Auto Farm", 4483362458)

Tab:CreateToggle({
   Name = "Start Auto Farm (ຕີອັດຕະໂນມັດ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      spawn(function()
         while _G.AutoFarm do
            task.wait()
            pcall(function()
               local qName, mName, nName = GetQuest()
               
               -- 1. ຮັບ Quest ຖ້າຍັງບໍ່ມີ
               if not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then
                  local npc = game.Workspace.NPCs:FindFirstChild(nName)
                  if npc then
                     game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                     task.wait(0.5)
                     game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qName, 1)
                  end
               else
                  -- 2. ວາບໄປຕີມອນເຕີ
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == mName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                           task.wait()
                           EquipWeapon() -- ຖືອາວຸດອັດຕະໂນມັດ
                           
                           -- ວາບໄປລັອກເປົ້າໝາຍ (Safe Farm)
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                           
                           -- ລະບົບຕີແບບ Fast Attack (ໃຊ້ Remote ເພື່ອຄວາມໄວ)
                           game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                           game:GetService("VirtualUser"):CaptureController()
                           game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
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
   Name = "ຊື່ມີດ/ໝັດ (Weapon Name)",
   PlaceholderText = "Combat / Melee / Katana",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.Weapon = Text
   end,
})
