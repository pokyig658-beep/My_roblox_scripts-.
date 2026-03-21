-- LAM V3 - HACKER FORCE ATTACK (NO CLICK NEEDED)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | FORCE ATTACK",
   LoadingTitle = "ກຳລັງ Bypass ລະບົບການຕີ...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

local TweenService = game:GetService("TweenService")
_G.AutoFarm = false
_G.Weapon = "Combat" -- ພິມຊື່ມີດ/ໝັດ ໃນເກມ
_G.TweenSpeed = 250

-- ຟັງຊັນຖືອາວຸດ (Equip)
function EquipWeapon()
    pcall(function()
        local backpack = game.Players.LocalPlayer.Backpack
        local char = game.Players.LocalPlayer.Character
        local tool = backpack:FindFirstChild(_G.Weapon) or char:FindFirstChild(_G.Weapon)
        if tool and not char:FindFirstChild(tool.Name) then
            char.Humanoid:EquipTool(tool)
        end
    end)
end

-- ຟັງຊັນວາບນິ້ມນວນ
function SmoothTween(targetCFrame)
    local Character = game.Players.LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local RootPart = Character.HumanoidRootPart
    local Distance = (RootPart.Position - targetCFrame.Position).Magnitude
    local Duration = Distance / _G.TweenSpeed
    local tweenInfo = TweenInfo.new(Duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

local Tab = Window:CreateTab("Main Farm", 4483362458)

Tab:CreateToggle({
   Name = "Start Force Farm (ຕີແຮງ+ແນ່ນອນ)",
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
                  if npc then
                     SmoothTween(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
                     game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
                  end
               else
                  -- ວາບໄປຫາມອນເຕີ
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                           task.wait()
                           EquipWeapon()
                           -- ວາບໄປລັອກເປົ້າໝາຍ (ໄລຍະ 5 studs)
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                           
                           -- --- HACKER ATTACK SYSTEM (ສົ່ງ Remote ໂດຍກົງ) ---
                           local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                           if tool then
                              -- ສັ່ງໃຫ້ຕີຜ່ານ Remote (ບໍ່ຕ້ອງຄລິກຈໍ)
                              game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack", tool)
                              -- ດາເມຈແຮງ
                              game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                           end
                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not questGui.Visible
                        break
                     end
                  end
               end
            end)
         end
      end)
   end,
})

Tab:CreateInput({
   Name = "ພິມຊື່ມີດ (ເຊັ່ນ: Combat)",
   PlaceholderText = "Combat / Katana",
   Callback = function(Text) _G.Weapon = Text end,
})
