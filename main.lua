-- LAM V3 - BLOX FRUITS (RAYFIELD UI)
-- ປັບໜ້າຕາໃຫ້ຄ້າຍຄື Bear Hub ຕາມຮູບສຳລັບມືຖື

-- ໂຫຼດ UI Library (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ສ້າງໜ້າຕ່າງຫຼັກ
local Window = Rayfield:CreateWindow({
   Name = "LAM V3 - PREMIUM HUB | Blox Fruits",
   LoadingTitle = "ລໍຖ້າການເຊື່ອມຕໍ່...",
   LoadingSubtitle = "by LAM THAN PHANNORLITH",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "LAMV3",
      FileName = "Config"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false -- ບໍ່ຕ້ອງໃຊ້ Key
})

-- -- -- VARIABLES (ຕົວແປສຳລັບເປີດ/ປິດ) -- -- --
_G.AutoFarm = false
_G.AutoQuest = true -- ເປີດຮັບເຄສອັດຕະໂນມັດເປັນຄ່າເລີ່ມຕົ້ນ

-- -- -- FUNCTIONS (ຟັງຊັນການທຳງານ) -- -- --

-- Function: ຮັບເຄສອັດຕະໂນມັດ
function CheckQuest()
    local MyLevel = game.Players.LocalPlayer.Data.Level.Value
    local QuestName = ""
    local QuestNPC = ""
    
    -- ຕົວຢ່າງການຕັ້ງຄ່າເຄສ (ຕ້ອງເພີ່ມ ID ເກາະ ແລະ NPC ໃຫ້ຄົບຕາມເວວ)
    -- ໃນນີ້ຂ້ອຍໃສ່ເປັນຕົວຢ່າງ Quest ພື້ນຖານ (Bandit)
    if MyLevel >= 0 and MyLevel <= 10 then
        QuestName = "BanditQuest1"
        QuestNPC = "Bandit Quest Giver" -- ຕ້ອງເປັນຊື່ NPC ທີ່ຖືກຕ້ອງ
    elseif MyLevel >= 11 and MyLevel <= 20 then
        QuestName = "BanditQuest2" -- ປ່ຽນເປັນຊື່ Quest ຂອງເວວນີ້
        QuestNPC = "Bandit Quest Giver" -- ປ່ຽນເປັນຊື່ NPC ຂອງເວວນີ້
    end
    -- ເຈົ້າຕ້ອງເພີ່ມເງື່ອນໄຂເວວອື່ນໆໃສ່ບ່ອນນີ້...

    -- ຖ້າມີ Quest ແລະ ຍັງບໍ່ໄດ້ຮັບ ເຂົ້າໄປຮັບ Quest
    if QuestName ~= "" and game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible == false then
        local NPCModel = game.Workspace.NPCs:FindFirstChild(QuestNPC)
        if NPCModel then
            -- ວາບໄປຫາ NPC
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = NPCModel.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            task.wait(1)
            -- ຄລິກເພື່ອຮັບເຄສ (ຕ້ອງໃຊ້ Remote ຫຼື RemoteFunction ຂອງເກມ)
            -- (ອັນນີ້ແມ່ນ Remote ທົ່ວໄປ ບາງເກມອາດຈະຕ່າງ)
            local args = { [1] = "StartQuest", [2] = QuestName, [3] = 1 }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end

-- -- -- UI TABS (ແທັບເມນູ) -- -- --

-- ແທັບຫຼັກ: "Farm" (ຄືຮູບ Bear Hub)
local FarmTab = Window:CreateTab("Farm", 4483362458)
local FarmSection = FarmTab:CreateSection("Farm Settings")

-- ປຸ່ມ Start Farm (ຄືຮູບ)
FarmTab:CreateToggle({
   Name = "Start Farm",
   CurrentValue = false,
   Flag = "ToggleFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
          Rayfield:Notify({Title = "Status", Content = "Auto Farm Active ✅"})
          spawn(function()
              while _G.AutoFarm do
                  task.wait()
                  pcall(function()
                      -- ຖ້າເປີດ Auto Quest ໃຫ້ໄປເຊັກ Quest ກ່ອນ
                      if _G.AutoQuest then
                          CheckQuest()
                      end
                      
                      -- ລະບົບຊອກຫາມອນເຕີ ແລະ ວາບໄປຫາ
                      for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                          if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                              -- ວາບໄປຂ້າງເທິງມອນເຕີເລັກນ້ອຍເພື່ອບໍ່ໃຫ້ຖືກຕີ ( Safe Farm)
                              game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                          end
                      end
                  end)
              end
          end)
      end
   end,
})

-- ປຸ່ມ Accept Quests (ຄືຮູບ)
FarmTab:CreateToggle({
   Name = "Accept Quests",
   CurrentValue = true, -- ເປີດໄວ້ເລີຍ
   Flag = "ToggleQuest",
   Callback = function(Value)
      _G.AutoQuest = Value
   end,
})

-- ສ່ວນອື່ນໆ (Other) - ຕົວຢ່າງການປັບ WalkSpeed
local OtherSection = FarmTab:CreateSection("Other")
OtherSection:CreateSlider({
   Name = "WalkSpeed (ຄວາມໄວ)",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- ແທັບ Credits
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateSection("Scripted by LAM THAN PHANNORLITH")
CreditsTab:CreateParagraph({Title = "Support", Content = "ຂໍຂອບໃຈທີ່ໃຊ້ສະຄິບຂອງເຮົາ!\nຖ້າມີ Error ບອກໄດ້ເລີຍເດີ້."})

Rayfield:Notify({
   Title = "Executed!",
   Content = "ສະຄິບພ້ອມໃຊ້ງານແລ້ວ!",
   Duration = 5,
   Image = 4483362458,
})
