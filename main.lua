local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | PREMIUM FARM",
   LoadingTitle = "Checking Level...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

-- Variables
_G.AutoFarm = false
_G.FastAttack = true

-- Function: ຮັບ Quest ແລະ ຫາຊື່ມອນເຕີຕາມເວວ
function GetQuest()
    local lvl = game.Players.LocalPlayer.Data.Level.Value
    if lvl >= 1 and lvl < 10 then
        return "BanditQuest1", "Bandit", "Bandit Quest Giver"
    elseif lvl >= 10 and lvl < 15 then
        return "BanditQuest2", "Monkey", "Monkey Quest Giver" -- ປ່ຽນຕາມຊື່ໃນເກມ
    else
        return "BanditQuest1", "Bandit", "Bandit Quest Giver" -- ເລີ່ມຕົ້ນ
    end
end

local Tab = Window:CreateTab("Auto Farm", 4483362458)
local Section = Tab:CreateSection("Leveling")

Tab:CreateToggle({
   Name = "Auto Farm + Auto Quest",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      spawn(function()
         while _G.AutoFarm do
            task.wait(0.1)
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
                           -- ວາບໄປລັອກເປົ້າໝາຍ (Safe Distance)
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                           
                           -- Fast Attack (ຕີລົວໆ)
                           if _G.FastAttack then
                              game:GetService("VirtualUser"):CaptureController()
                              game:GetService("VirtualUser"):ClickButton1(Vector2.new(851, 158))
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

Tab:CreateToggle({
   Name = "Fast Attack (ຕີໄວ)",
   CurrentValue = true,
   Callback = function(Value)
      _G.FastAttack = Value
   end,
})
