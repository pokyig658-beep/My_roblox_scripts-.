-- [[ LAM V3 - BANANA STYLE FARM ]] --
getgenv().Config = {
    Team = "Pirates",
    FarmConfig = {
        ["Fast Attack Speed"] = 0.01,
        ["Farm Distance"] = 8, -- ໄລຍະຫ່າງທີ່ປອດໄພ
        ["Auto Click"] = true
    },
    Items = {
        ["Weapon Name"] = "Combat" -- ພິມຊື່ມີດ/ໝັດ
    }
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "LAM V3 | PREMIUM HUB",
   LoadingTitle = "ກຳລັງ Bypass ລະບົບປ້ອງກັນ...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = { Enabled = false }
})

-- -- -- HACKER ATTACK SYSTEM (Fast & Smooth) -- -- --
local function AutoAttack()
    pcall(function()
        local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            -- ລະບົບຕີແບບບໍ່ມີ Cooldown (Fast Attack)
            game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
            
            -- ສົ່ງ Remote Attack ໃຫ້ Server ຮັບຮູ້
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack", tool)
        end
    end)
end

-- -- -- AUTO FARM SYSTEM -- -- --
local MainTab = Window:CreateTab("Auto Farm", 4483362458)

MainTab:CreateToggle({
   Name = "Auto Farm Level (ແບບໃນຄລິບ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      spawn(function()
         while _G.AutoFarm do
            task.wait()
            pcall(function()
               local questGui = game.Players.LocalPlayer.PlayerGui.Main.Quest
               if not questGui.Visible then
                  -- ຮັບ Quest (Bandit ສຳລັບເວວ 4)
                  local npc = game.Workspace.NPCs:FindFirstChild("Bandit Quest Giver")
                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1)
               else
                  -- ວາບໄປຕີມອນເຕີ
                  for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                           task.wait()
                           -- ຖືອາວຸດອັດຕະໂນມັດ
                           local weaponName = getgenv().Config.Items["Weapon Name"]
                           local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(weaponName)
                           if tool then game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool) end
                           
                           -- ວາບລັອກເປົ້າໝາຍ (Safe Distance)
                           local dist = getgenv().Config.FarmConfig["Farm Distance"]
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                           
                           -- ລວມມອນເຕີແບບບໍ່ໃຫ້ເດ້ງ
                           v.HumanoidRootPart.CanCollide = false
                           v.HumanoidRootPart.Velocity = Vector3.new(0,0,0)

                           -- ຕີລົວໆ
                           AutoAttack()
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

MainTab:CreateInput({
   Name = "ໃສ່ຊື່ມີດ (Combat / Katana)",
   PlaceholderText = "Combat",
   Callback = function(Text) getgenv().Config.Items["Weapon Name"] = Text end,
})

-- -- -- AUTO STATS SYSTEM -- -- --
local StatTab = Window:CreateTab("Auto Stats", 4483362458)
_G.AutoStats = false

StatTab:CreateToggle({
   Name = "Auto Stats (Melee)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoStats = Value
      spawn(function()
         while _G.AutoStats do
            task.wait(1)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
         end
      end)
   end,
})
