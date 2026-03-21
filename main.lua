local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | ALL-IN-ONE HUB",
   LoadingTitle = "ກຳລັງໂຫຼດລະບົບຟາມທີ່ດີທີ່ສຸດ...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

-- -- -- VARIABLES -- -- --
_G.AutoFarm = false
_G.BringMob = true
_G.FastAttack = true
_G.AutoEquip = true
_G.Weapon = "Combat" -- ພິມຊື່ມີດ/ໝັດ ໃນເກມ

-- -- -- FUNCTIONS -- -- --
function EquipWeapon()
    pcall(function()
        if _G.AutoEquip then
            local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(_G.Weapon) or game.Players.LocalPlayer.Character:FindFirstChild(_G.Weapon)
            if tool and not game.Players.LocalPlayer.Character:FindFirstChild(tool.Name) then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            end
        end
    end)
end

function GetQuest()
    local lvl = game.Players.LocalPlayer.Data.Level.Value
    if lvl < 10 then return "BanditQuest1", "Bandit", "Bandit Quest Giver"
    elseif lvl < 15 then return "BanditQuest2", "Monkey", "Monkey Quest Giver"
    else return "BanditQuest1", "Bandit", "Bandit Quest Giver" end
end

-- -- -- UI TABS -- -- --
local MainTab = Window:CreateTab("Farming", 4483362458)
local Section = MainTab:CreateSection("Main Leveling")

MainTab:CreateToggle({
   Name = "Auto Farm Level (ຕີ+ຮັບເຄສ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      spawn(function()
         while _G.AutoFarm do
            task.wait(0.1)
            pcall(function()
               local qName, mName, nName = GetQuest()
               if not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
                  -- ວາບໄປຮັບ Quest
                  local npc = game.Workspace.NPCs:FindFirstChild(nName)
                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qName, 1)
               else
                  -- ວາບໄປຕີມອນເຕີ
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == mName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                           task.wait()
                           EquipWeapon()
                           -- ວາບລັອກເປົ້າໝາຍ (Safe Farm)
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                           
                           -- ລວມມອນເຕີ (Fix ບໍ່ໃຫ້ບິນມົ້ວ)
                           if _G.BringMob then
                               v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                               v.HumanoidRootPart.CanCollide = false
                           end

                           -- ລະບົບຕີອັດຕະໂນມັດ (Fast Attack)
                           if _G.FastAttack then
                               local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                               if tool then tool:Activate() end
                               game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                           end
                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible
                     end
                  end
               end
            end)
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "Bring Mob (ລວມມອນ)",
   CurrentValue = true,
   Callback = function(Value) _G.BringMob = Value end,
})

MainTab:CreateInput({
   Name = "ຊື່ມີດ (Weapon)",
   PlaceholderText = "Combat / Katana",
   Callback = function(Text) _G.Weapon = Text end,
})

local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateButton({
   Name = "Infinity Yield (ສະຄິບແອດມິນ)",
   Callback = function()
       loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})
