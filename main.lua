-- LAM V3 - AUTO CLICK FIX
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | AUTO CLICK FIX",
   LoadingTitle = "ກຳລັງເປີດລະບົບຈຳລອງການຄລິກ...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

local TweenService = game:GetService("TweenService")
_G.AutoFarm = false
_G.Weapon = "Combat" -- ປ່ຽນຕາມຊື່ທີ່ເຈົ້າໃຊ້
_G.TweenSpeed = 250
_G.Distance = 5 -- ໄລຍະການຕີ (ປັບໃຫ້ໃກ້ຂຶ້ນເພື່ອໃຫ້ຕີຮອດ)

-- ຟັງຊັນວາບນິ້ມນວນ (ປ້ອງກັນບິນ)
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

-- ຟັງຊັນຖືອາວຸດ (ແບບບັງຄັບຖື)
function EquipWeapon()
    pcall(function()
        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(_G.Weapon)) then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            end
        end
    end)
end

local Tab = Window:CreateTab("Auto Farm", 4483362458)

Tab:CreateToggle({
   Name = "Start Farm (ຕີແນ່ນອນ 100%)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      
      -- Loop ທີ 1: ວາບໄປຫາເປົ້າໝາຍ
      spawn(function()
         while _G.AutoFarm do
            task.wait()
            pcall(function()
               local questGui = game.Players.LocalPlayer.PlayerGui.Main.Quest
               
               if not questGui.Visible then
                  -- ຮັບເຄສ
                  local npc = game.Workspace.NPCs:FindFirstChild("Bandit Quest Giver")
                  if npc then
                     SmoothTween(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                     task.wait(0.5)
                     game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
                  end
               else
                  -- ວາບໄປຫາມອນເຕີ
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                           task.wait()
                           EquipWeapon()
                           -- ລັອກເປົ້າໝາຍໃຫ້ຢູ່ທາງໜ້າພໍດີ (ໄລຍະ 5)
                           SmoothTween(v.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Distance))
                           
                           -- ລັອກໜ້າໃຫ້ຫັນໄປຫາມອນເຕີສະເໝີ
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
                               game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 
                               v.HumanoidRootPart.Position
                           )
                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not questGui.Visible
                        break 
                     end
                  end
               end
            end)
         end
      end)

      -- Loop ທີ 2: ລະບົບຄລິກອັດຕະໂນມັດ (ຈຳລອງການແຕະໜ້າຈໍ)
      spawn(function()
         local VirtualUser = game:GetService("VirtualUser")
         while _G.AutoFarm do
            task.wait(0.05) -- ຄວາມໄວໃນການລົວໝັດ
            pcall(function()
               local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
               if tool then
                  -- ສັ່ງໃຫ້ເກມຄລິກໜ້າຈໍເອງ (ຕີແນ່ນອນ)
                  VirtualUser:CaptureController()
                  VirtualUser:ClickButton1(Vector2.new(851, 158)) 
                  
                  -- ໃຊ້ Remote ຊ່ວຍໃຫ້ດາເມຈເຂົ້າຮອດ Server
                  game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
               end
            end)
         end
      end)
   end,
})

Tab:CreateInput({
   Name = "ຊື່ມີດ/ໝັດ (ເຊັ່ນ: Combat)",
   PlaceholderText = "Combat / Katana",
   Callback = function(Text) _G.Weapon = Text end,
})
