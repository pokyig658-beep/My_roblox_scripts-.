local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("LAM V3 - MY UI", "DarkScene")

-- Tab ທຳອິດ: "Main"
local Tab1 = Window:NewTab("Main")
local Section1 = Tab1:NewSection("Player Mods")

Section1:NewSlider("WalkSpeed", "ປັບຄວາມໄວໃນການຍ່າງ", 500, 16, function(s) -- 500 = Max, 16 = Min
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

Section1:NewSlider("JumpPower", "ປັບຄວາມສູງໃນການໂດດ", 500, 50, function(s) -- 500 = Max, 50 = Min
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

Section1:NewButton("Infinite Jump", "ໂດດໄດ້ຕະຫຼອດບໍ່ຈຳກັດ", function()
    local InfiniteJumpEnabled = true
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if InfiniteJumpEnabled then
            game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
        end
    end)
end)

-- Tab ທີສອງ: "Farm"
local Tab2 = Window:NewTab("Farm")
local Section2 = Tab2:NewSection("Auto Farm Options")

Section2:NewToggle("Auto Farm (Demo)", "ຟາມອັດຕະໂນມັດ (ຕົວຢ່າງ)", function(state)
    if state then
        print("ເປີດ Auto Farm...")
        -- ໃສ່ໂຄ້ດ Auto Farm ຂອງເຈົ້າຢູ່ບ່ອນນີ້
    else
        print("ປິດ Auto Farm.")
    end
end)

-- Tab ທີສາມ: "Credits"
local Tab3 = Window:NewTab("Credits")
local Section3 = Tab3:NewSection("Created by LAM THAN PHANNORLITH")
Section3:NewLabel("Support: GitHub/My-Roblox-V3")
