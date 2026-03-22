local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM HUB | Blox Fruits ⚡ FIXED ATTACK",
   LoadingTitle = "ກຳລັງແກ້ໄຂລະບົບ Attack...",
   LoadingSubtitle = "by Lam Than Phannorlith",
})

_G.AutoFarm = false
_G.SelectWeapon = "Melee" -- ເລືອກປະເພດອາວຸດ

local MainTab = Window:CreateTab("Farm Settings", 4483362458)

MainTab:CreateDropdown({
   Name = "ເລືອກປະເພດອາວຸດ",
   Options = {"Melee","Sword","Fruit"},
   CurrentOption = "Melee",
   Callback = function(Option)
      _G.SelectWeapon = Option
   end,
})

MainTab:CreateToggle({
   Name = "ເປີດ Auto Farm (ຕີແນ່ນອນ 100%)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then StartFarm() end
   end,
})

-- [[ ຟັງຊັນຖືອາວຸດອັດຕະໂນມັດ ]]
function autoEquip()
    pcall(function()
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v.ToolTip == _G.SelectWeapon then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
            end
        end
    end)
end

-- [[ ຟັງຊັນສົ່ງຄຳສັ່ງຕີ (Remote Attack) - ໂຕນີ້ຈະເຮັດໃຫ້ຕີແນ່ນອນ ]]
function hitTarget()
    pcall(function()
        local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
        local CombatFrameworkLib = debug.getupvalues(CombatFramework)[2]
        local CameraShaker = require(game:GetService("ReplicatedStorage").Util.CameraShaker)
        CameraShaker:Stop() -- ປິດການສັ່ນຈໍ
        
        -- ສົ່ງຄຳສັ່ງຕີໂດຍບໍ່ຕ້ອງກົດ Mouse
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack", {})
    end)
end

-- [[ ລະບົບຟາມ ]]
function StartFarm()
    spawn(function()
        while _G.AutoFarm do
            task.wait()
            local p = game.Players.LocalPlayer
            local char = p.Character
            
            -- ຊອກຫາ Monster ທີ່ຢູ່ໃກ້ທີ່ສຸດ (ຕົວຢ່າງ Bandit)
            local enemy = nil
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    enemy = v
                    break
                end
            end
            
            if enemy then
                autoEquip() -- ຖືອາວຸດ
                -- ບິນໄປຫາ (Lock ຕຳແໜ່ງ)
                char.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                -- ຕີລົວໆ
                hitTarget()
            end
        end
    end)
end
