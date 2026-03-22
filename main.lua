-- [[ LAM V3 - ULTIMATE HACKER FAST ATTACK ]] --
getgenv().Config = {
    ["Weapon"] = "Combat", -- ພິມຊື່ມີດ/ໝັດ ບ່ອນນີ້ (ຕົວພິມໃຫຍ່ໂຕທຳອິດ)
    ["Distance"] = 7, -- ໄລຍະຫ່າງ (ສູງກວ່າ 5 ເພື່ອບໍ່ໃຫ້ມອນຕີຮອດ)
    ["AttackSpeed"] = 0.05 -- ຄວາມໄວການຕີ (0.01-0.1)
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | FAST ATTACK PRO",
   LoadingTitle = "ກຳລັງ Bypass ລະບົບ Cooldown...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

_G.AutoFarm = false

-- --- ລະບົບຕີລົວ (Fast Attack Method) ---
spawn(function()
    while task.wait(getgenv().Config["AttackSpeed"]) do
        if _G.AutoFarm then
            pcall(function()
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- ສົ່ງ Remote ຕີໂດຍກົງ (No Cooldown)
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack", tool)
                end
            end)
        end
    end
end)

-- --- ຟັງຊັນຖືອາວຸດ ---
function Equip()
    pcall(function()
        local weaponName = getgenv().Config["Weapon"]
        local backpack = game.Players.LocalPlayer.Backpack
        local char = game.Players.LocalPlayer.Character
        local tool = backpack:FindFirstChild(weaponName) or char:FindFirstChild(weaponName)
        if tool and not char:FindFirstChild(tool.Name) then
            char.Humanoid:EquipTool(tool)
        end
    end)
end

-- --- ລະບົບ Farm ---
local Tab = Window:CreateTab("Main Farm", 4483362458)

Tab:CreateToggle({
   Name = "Start Auto Farm (ຕີລົວ + ຮັບເຄສເອງ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      spawn(function()
         while _G.AutoFarm do
            task.wait()
            pcall(function()
               local questGui = game.Players.LocalPlayer.PlayerGui.Main.Quest
               if not questGui.Visible then
                  -- ວາບໄປຮັບ Quest (Bandit)
                  local npc = game.Workspace.NPCs:FindFirstChild("Bandit Quest Giver")
                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
               else
                  -- ວາບໄປຕີມອນເຕີ
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                           task.wait()
                           Equip()
                           -- ວາບລັອກເປົ້າໝາຍ (ສູງ 7 studs ມອນຕີບໍ່ຮອດ)
                           local dist = getgenv().Config["Distance"]
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                           
                           -- ລັອກມອນເຕີບໍ່ໃຫ້ບິນ (Noclip Mob)
                           v.HumanoidRootPart.CanCollide = false
                           v.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
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
   Name = "ຊື່ມີດ (ເຊັ່ນ: Combat)",
   PlaceholderText = "Combat",
   Callback = function(Text) getgenv().Config["Weapon"] = Text end,
})

Tab:CreateSlider({
   Name = "ໄລຍະຫ່າງ (Distance)",
   Range = {5, 15},
   Increment = 1,
   CurrentValue = 7,
   Callback = function(Value) getgenv().Config["Distance"] = Value end,
})
