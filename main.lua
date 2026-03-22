local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM HUB | Blox Fruits AUTO FARM (Fixed)",
   LoadingTitle = "ກຳລັງແກ້ໄຂລະບົບການຕີ...",
   LoadingSubtitle = "by Lam Than Phannorlith",
})

-- [[ ຂໍ້ມູນການຟາມ ]]
local LevelData = {
    {MinLvl = 1, MaxLvl = 15, QuestNPC = "Bandit Quest", QuestName = "BanditQuest", Monster = "Bandit", NPC_Pos = CFrame.new(1059, 15, 1547)},
    {MinLvl = 15, MaxLvl = 30, QuestNPC = "Monkey Quest", QuestName = "MonkeyQuest", Monster = "Monkey", NPC_Pos = CFrame.new(-1612, 36, 147)},
    {MinLvl = 30, MaxLvl = 60, QuestNPC = "Gorilla Quest", QuestName = "GorillaQuest", Monster = "Gorilla", NPC_Pos = CFrame.new(-1213, 16, -490)},
    {MinLvl = 60, MaxLvl = 90, QuestNPC = "Snow Quest", QuestName = "SnowBanditQuest", Monster = "Snow Bandit", NPC_Pos = CFrame.new(1347, 105, -1328)},
}

_G.AutoFarm = false
_G.WeaponName = "Combat" -- ປ່ຽນຊື່ດາບ ຫຼື ໝັດ ທີ່ເຈົ້າໃຊ້ຢູ່ບ່ອນນີ້

local MainTab = Window:CreateTab("Farm Settings", 4483362458)

-- ປຸ່ມເລືອກອາວຸດ (ສຳຄັນ: ຕ້ອງໃສ່ຊື່ໃຫ້ຖືກ)
MainTab:CreateInput({
   Name = "ຊື່ມີດ ຫຼື ໝັດ (Weapon Name)",
   PlaceholderText = "ຕົວຢ່າງ: Combat ຫຼື Katana",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.WeaponName = Text
   end,
})

MainTab:CreateToggle({
   Name = "ເປີດ Auto Farm + Auto Attack",
   CurrentValue = false,
   Flag = "FarmToggle", 
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then StartFarm() end
   end,
})

-- [[ ຟັງຊັນຖືອາວຸດ ]]
function EquipWeapon()
    local p = game.Players.LocalPlayer
    if p.Backpack:FindFirstChild(_G.WeaponName) then
        local tool = p.Backpack:FindFirstChild(_G.WeaponName)
        p.Character.Humanoid:EquipTool(tool)
    end
end

-- [[ ຟັງຊັນການຕີລົວໆ (Fast Attack) ]]
function FastAttack()
    local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
    local CameraShaker = require(game:GetService("ReplicatedStorage").Util.CameraShaker)
    CameraShaker:Stop() -- ປິດການສັ່ນຂອງໜ້າຈໍ
    
    spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
end

function StartFarm()
    FastAttack() -- ເລີ່ມການຕີ
    spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            local p = game.Players.LocalPlayer
            local myLevel = p.Data.Level.Value
            
            local currentIsland = nil
            for _, v in pairs(LevelData) do
                if myLevel >= v.MinLvl and myLevel < v.MaxLvl then
                    currentIsland = v
                    break
                end
            end
            
            if currentIsland == nil then currentIsland = LevelData[#LevelData] end

            if not p.PlayerGui.Main.Quest.Visible then
                -- ບິນໄປຮັບ Quest
                p.Character.HumanoidRootPart.CFrame = currentIsland.NPC_Pos
                task.wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", currentIsland.QuestName, 1)
            else
                -- ບິນໄປຫາ Monster
                local enemy = workspace.Enemies:FindFirstChild(currentIsland.Monster)
                if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    EquipWeapon() -- ຖືອາວຸດອັດຕະໂນມັດ
                    p.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                else
                    p.Character.HumanoidRootPart.CFrame = currentIsland.NPC_Pos * CFrame.new(0, 40, 0)
                end
            end
        end
    end)
end
