local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LAM HUB | Blox Fruits Auto Farm v1.0",
   LoadingTitle = "ກຳລັງເລີ່ມຕົ້ນລະບົບ...",
   LoadingSubtitle = "by Lam Than Phannorlith",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "LamHubConfig",
      FileName = "BloxFruits_Save"
   }
})

-- [[ ຂໍ້ມູນການຟາມຕາມເວລ ]]
local LevelData = {
    {MinLvl = 1, MaxLvl = 15, QuestNPC = "Bandit Quest", QuestName = "BanditQuest", Monster = "Bandit", NPC_Pos = CFrame.new(1059, 15, 1547)},
    {MinLvl = 15, MaxLvl = 30, QuestNPC = "Monkey Quest", QuestName = "MonkeyQuest", Monster = "Monkey", NPC_Pos = CFrame.new(-1612, 36, 147)},
    {MinLvl = 30, MaxLvl = 60, QuestNPC = "Gorilla Quest", QuestName = "GorillaQuest", Monster = "Gorilla", NPC_Pos = CFrame.new(-1213, 16, -490)},
    {MinLvl = 60, MaxLvl = 90, QuestNPC = "Snow Quest", QuestName = "SnowBanditQuest", Monster = "Snow Bandit", NPC_Pos = CFrame.new(1347, 105, -1328)},
    -- ໝາຍເຫດ: ທ່ານສາມາດເພີ່ມພິກັດເກາະອື່ນໆ ໄປຈົນຮອດເວລ 2800 ໄດ້ຢູ່ບ່ອນນີ້
}

-- [[ ຕົວແປຄວບຄຸມ ]]
_G.AutoFarm = false
_G.FastAttack = true

-- [[ ຟັງຊັນປ້ອງກັນການຫຼຸດ (Anti-AFK) ]]
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- [[ ໜ້າຕ່າງ UI ]]
local MainTab = Window:CreateTab("Auto Farm", 4483362458)

local Toggle = MainTab:CreateToggle({
   Name = "Auto Farm Level (1-2800)",
   CurrentValue = false,
   Flag = "FarmToggle", 
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
          StartFarmLoop()
      end
   end,
})

-- [[ Logic ການຟາມອັດຕະໂນມັດ ]]
function StartFarmLoop()
    spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            local p = game.Players.LocalPlayer
            local myLevel = p.Data.Level.Value
            
            -- ເລືອກເກາະທີ່ເໝາະສົມ
            local currentIsland = nil
            for _, v in pairs(LevelData) do
                if myLevel >= v.MinLvl and myLevel < v.MaxLvl then
                    currentIsland = v
                    break
                end
            end
            
            if currentIsland == nil then currentIsland = LevelData[#LevelData] end

            -- ກວດສອບ Quest
            if not p.PlayerGui.Main.Quest.Visible then
                -- ບິນໄປຮັບ Quest
                p.Character.HumanoidRootPart.CFrame = currentIsland.NPC_Pos
                task.wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", currentIsland.QuestName, 1)
            else
                -- ບິນໄປຕີ Monster
                local enemy = workspace.Enemies:FindFirstChild(currentIsland.Monster)
                if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    -- ຕຳແໜ່ງບິນ (ຢູ່ເທິງຫົວເພື່ອຄວາມປອດໄພ)
                    p.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    
                    -- ໂຈມຕີ
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                else
                    -- ຖ້າ Monster ຕາຍ ຫຼື ບໍ່ມີ ໃຫ້ບິນໄປຈຸດເກີດຂອງມັນ
                    p.Character.HumanoidRootPart.CFrame = currentIsland.NPC_Pos * CFrame.new(0, 50, 0)
                end
            end
        end
    end)
end

Rayfield:Notify({
   Title = "ສະຄິບພ້ອມໃຊ້ງານ!",
   Content = "ຍິນດີຕ້ອນຮັບທ່ານ Lam ຂໍໃຫ້ຟາມຢ່າງມີຄວາມສຸກ!",
   Duration = 5,
   Image = 4483362458,
})
