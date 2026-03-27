-- ╔═══════════════════════════════════════╗
-- ║  LAM HUB  •  V2 (SAFE EDITION)        ║
-- ║  LocalScript > StarterPlayerScripts   ║
-- ╚═══════════════════════════════════════╝

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Lighting         = game:GetService("Lighting")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Camera    = game:GetService("Workspace").CurrentCamera

-- ══════════════════════════════════════════
--  ສີ / THEME
-- ══════════════════════════════════════════
local C = {
	bg0      = Color3.fromRGB(8,   8,   10),   
	bg1      = Color3.fromRGB(13,  13,  17),
	bg2      = Color3.fromRGB(18,  18,  24),
	panel    = Color3.fromRGB(22,  22,  30),
	card     = Color3.fromRGB(28,  28,  38),
	cardHov  = Color3.fromRGB(36,  36,  50),
	line     = Color3.fromRGB(40,  40,  56),

	cyan     = Color3.fromRGB(0,   229, 200),   
	cyanDim  = Color3.fromRGB(0,   140, 122),
	cyanGlow = Color3.fromRGB(80,  255, 235),
	red      = Color3.fromRGB(255, 60,  80),
	gold     = Color3.fromRGB(255, 200, 60),

	text     = Color3.fromRGB(210, 215, 230),
	textDim  = Color3.fromRGB(90,  95,  115),
	textMid  = Color3.fromRGB(150, 155, 175),
	white    = Color3.fromRGB(255, 255, 255),
}

local function tw(obj, props, t, style, dir)
	TweenService:Create(obj,
		TweenInfo.new(t or 0.18,
			style or Enum.EasingStyle.Quart,
			dir   or Enum.EasingDirection.Out),
		props
	):Play()
end

-- ══════════════════════════════════════════
--  SCREEN GUI
-- ══════════════════════════════════════════
local Gui = Instance.new("ScreenGui")
Gui.Name           = "LamHubV2"
Gui.ResetOnSpawn   = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent         = playerGui

-- ລົບ UI ເກົ່າອອກຖ້າມີ
for _, v in pairs(Gui.Parent:GetChildren()) do
	if v.Name == "LamHubV2" and v ~= Gui then
		v:Destroy()
	end
end

-- ══════════════════════════════════════════
--  ຂະໜາດ WINDOW
-- ══════════════════════════════════════════
local W_W     = 460
local W_H     = 340
local TITLE_H = 48
local SIDE_W  = 54     

local Win = Instance.new("Frame")
Win.Name             = "Window"
Win.Size             = UDim2.new(0, W_W, 0, W_H)
Win.Position         = UDim2.new(0.5, -W_W/2, 0.5, -W_H/2)
Win.BackgroundColor3 = C.bg0
Win.BorderSizePixel  = 0
Win.Active           = true
Win.Draggable        = true
Win.ClipsDescendants = true
Win.Parent           = Gui
Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 10)

local winStroke = Instance.new("UIStroke")
winStroke.Color       = C.cyan
winStroke.Thickness   = 1
winStroke.Transparency = 0.72
winStroke.Parent      = Win

local topLine = Instance.new("Frame")
topLine.Size             = UDim2.new(1, 0, 0, 2)
topLine.BackgroundColor3 = C.cyan
topLine.BorderSizePixel  = 0
topLine.ZIndex           = 12
topLine.Parent           = Win

local topLineGrad = Instance.new("UIGradient")
topLineGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.3, C.cyanGlow),
	ColorSequenceKeypoint.new(0.7, C.cyan),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0)),
})
topLineGrad.Parent = topLine

local sOff = 0
RunService.Heartbeat:Connect(function(dt)
	sOff = (sOff + dt * 0.35) % 1
	topLineGrad.Offset = Vector2.new(-sOff * 2.2, 0)
end)

-- ══════════════════════════════════════════
--  TITLE BAR
-- ══════════════════════════════════════════
local TBar = Instance.new("Frame")
TBar.Name             = "TitleBar"
TBar.Size             = UDim2.new(1, 0, 0, TITLE_H)
TBar.Position         = UDim2.new(0, 0, 0, 2)
TBar.BackgroundColor3 = C.bg1
TBar.BorderSizePixel  = 0
TBar.ZIndex           = 10
TBar.Parent           = Win

local tDiv = Instance.new("Frame")
tDiv.Size             = UDim2.new(1, 0, 0, 1)
tDiv.Position         = UDim2.new(0, 0, 1, -1)
tDiv.BackgroundColor3 = C.line
tDiv.BorderSizePixel  = 0
tDiv.ZIndex           = 11
tDiv.Parent           = TBar

local logoFrame = Instance.new("Frame")
logoFrame.Size             = UDim2.new(0, 36, 0, 36)
logoFrame.Position         = UDim2.new(0, 8, 0.5, -18)
logoFrame.BackgroundColor3 = C.bg0
logoFrame.BorderSizePixel  = 0
logoFrame.ZIndex           = 12
logoFrame.Parent           = TBar
Instance.new("UICorner", logoFrame).CornerRadius = UDim.new(1, 0)

local logoStroke = Instance.new("UIStroke")
logoStroke.Color      = C.cyan
logoStroke.Thickness  = 1.5
logoStroke.Transparency = 0.3
logoStroke.Parent     = logoFrame

-- ດຶງຮູບພາບຂອງທ່ານກັບຄືນມາ (ຮູບໂລໂກ້)
local logoImg = Instance.new("ImageLabel")
logoImg.Size                  = UDim2.new(1, 0, 1, 0)
logoImg.BackgroundTransparency = 1
logoImg.Image                 = "rbxassetid://85576746580031"
logoImg.ScaleType             = Enum.ScaleType.Fit
logoImg.ZIndex                = 13
logoImg.Parent                = logoFrame
Instance.new("UICorner", logoImg).CornerRadius = UDim.new(1, 0)

local tTitle = Instance.new("TextLabel")
tTitle.Size              = UDim2.new(0, 90, 0, 20)
tTitle.Position          = UDim2.new(0, 52, 0, 8)
tTitle.BackgroundTransparency = 1
tTitle.Text              = "LAM HUB"
tTitle.TextColor3        = C.white
tTitle.TextSize          = 15
tTitle.Font              = Enum.Font.GothamBold
tTitle.TextXAlignment    = Enum.TextXAlignment.Left
tTitle.ZIndex            = 11
tTitle.Parent            = TBar

local tSub = Instance.new("TextLabel")
tSub.Size              = UDim2.new(0, 120, 0, 16)
tSub.Position          = UDim2.new(0, 52, 0, 27)
tSub.BackgroundTransparency = 1
tSub.Text              = "Safe Edition  •  V2"
tSub.TextColor3        = C.cyanDim
tSub.TextSize          = 10
tSub.Font              = Enum.Font.Gotham
tSub.TextXAlignment    = Enum.TextXAlignment.Left
tSub.ZIndex            = 11
tSub.Parent            = TBar

local function mkBtn(ox, sym, hCol)
	local b = Instance.new("TextButton")
	b.Size             = UDim2.new(0, 24, 0, 24)
	b.Position         = UDim2.new(1, ox, 0.5, -12)
	b.BackgroundColor3 = C.bg2
	b.BorderSizePixel  = 0
	b.Text             = sym
	b.TextColor3       = C.textDim
	b.TextSize         = 11
	b.Font             = Enum.Font.GothamBold
	b.AutoButtonColor  = false
	b.ZIndex           = 12
	b.Parent           = TBar
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
	local sk = Instance.new("UIStroke")
	sk.Color = C.line  sk.Thickness = 1  sk.Parent = b
	b.MouseEnter:Connect(function()
		tw(b, {BackgroundColor3 = hCol or C.cardHov, TextColor3 = C.white})
		tw(sk, {Color = hCol or C.cyan, Transparency = 0.4})
	end)
	b.MouseLeave:Connect(function()
		tw(b, {BackgroundColor3 = C.bg2, TextColor3 = C.textDim})
		tw(sk, {Color = C.line, Transparency = 0})
	end)
	return b
end

local BtnMin   = mkBtn(-86, "_",  C.cyanDim)
local BtnCol   = mkBtn(-58, "[]", C.cyanDim)
local BtnClose = mkBtn(-30, "x",  C.red)

-- ══════════════════════════════════════════
--  BODY
-- ══════════════════════════════════════════
local Body = Instance.new("Frame")
Body.Size             = UDim2.new(1, 0, 1, -(TITLE_H + 2))
Body.Position         = UDim2.new(0, 0, 0, TITLE_H + 2)
Body.BackgroundTransparency = 1
Body.ClipsDescendants = false
Body.ZIndex           = 5
Body.Parent           = Win

local Sidebar = Instance.new("Frame")
Sidebar.Size             = UDim2.new(0, SIDE_W, 1, 0)
Sidebar.BackgroundColor3 = C.bg1
Sidebar.BorderSizePixel  = 0
Sidebar.ZIndex           = 6
Sidebar.Parent           = Body

local sLine = Instance.new("Frame")
sLine.Size             = UDim2.new(0, 1, 1, 0)
sLine.Position         = UDim2.new(1, 0, 0, 0)
sLine.BackgroundColor3 = C.line
sLine.BorderSizePixel  = 0
sLine.ZIndex           = 7
sLine.Parent           = Sidebar

local activeBar = Instance.new("Frame")
activeBar.Size             = UDim2.new(0, 3, 0, 32)
activeBar.BackgroundColor3 = C.cyan
activeBar.BorderSizePixel  = 0
activeBar.ZIndex           = 9
activeBar.Parent           = Sidebar
Instance.new("UICorner", activeBar).CornerRadius = UDim.new(1, 0)

local Content = Instance.new("Frame")
Content.Size             = UDim2.new(1, -SIDE_W, 1, 0)
Content.Position         = UDim2.new(0, SIDE_W, 0, 0)
Content.BackgroundColor3 = C.bg2
Content.BorderSizePixel  = 0
Content.ClipsDescendants = true
Content.ZIndex           = 6
Content.Parent           = Body

-- ══════════════════════════════════════════
--  TABS SETUP
-- ══════════════════════════════════════════
local TABS = {
	{ name = "ATK", label = "Combat"   },
	{ name = "VFX", label = "Visuals"  },
	{ name = "CFG", label = "Settings" },
}

local tabBtns   = {}
local tabPanels = {}
local activeTab = 0

local function makePanel()
	local holder = Instance.new("Frame")
	holder.Size             = UDim2.new(1, 0, 1, 0)
	holder.BackgroundTransparency = 1
	holder.Visible          = false
	holder.ZIndex           = 7
	holder.Parent           = Content

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size             = UDim2.new(1, -10, 1, -10)
	scroll.Position         = UDim2.new(0, 5, 0, 5)
	scroll.BackgroundTransparency = 1
	scroll.ScrollBarThickness = 2
	scroll.ScrollBarImageColor3 = C.cyanDim
	scroll.BorderSizePixel  = 0
	scroll.ZIndex           = 8
	scroll.Parent           = holder

	local layout = Instance.new("UIListLayout")
	layout.Padding           = UDim.new(0, 6)
	layout.SortOrder         = Enum.SortOrder.LayoutOrder
	layout.Parent            = scroll

	local pad = Instance.new("UIPadding")
	pad.PaddingTop    = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 4)
	pad.Parent        = scroll

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)

	return holder, scroll
end

local function selectTab(idx)
	if activeTab == idx then return end
	activeTab = idx

	for i, btn in ipairs(tabBtns) do
		local isOn = (i == idx)
		tw(btn, {
			BackgroundColor3 = isOn and C.panel or Color3.fromRGB(0,0,0),
			TextColor3       = isOn and C.cyanGlow or C.textDim,
		})
		tabPanels[i].holder.Visible = isOn
	end
	local targetY = 8 + (idx - 1) * 52
	tw(activeBar, {Position = UDim2.new(0, 0, 0, targetY)}, 0.22, Enum.EasingStyle.Back)
end

for i, t in ipairs(TABS) do
	local tip = Instance.new("TextLabel")
	tip.Size                = UDim2.new(0, 70, 0, 22)
	tip.Position            = UDim2.new(1, 6, 0, 0)
	tip.BackgroundColor3    = C.panel
	tip.TextColor3          = C.cyanGlow
	tip.Text                = t.label
	tip.TextSize            = 11
	tip.Font                = Enum.Font.GothamBold
	tip.TextXAlignment      = Enum.TextXAlignment.Center
	tip.BorderSizePixel     = 0
	tip.ZIndex              = 20
	tip.Visible             = false
	tip.Parent              = Sidebar
	Instance.new("UICorner", tip).CornerRadius = UDim.new(0, 5)
	local tipS = Instance.new("UIStroke")
	tipS.Color = C.cyan  tipS.Thickness = 1  tipS.Transparency = 0.5  tipS.Parent = tip

	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(1, -4, 0, 40)
	btn.Position         = UDim2.new(0, 2, 0, 8 + (i-1)*52)
	btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
	btn.BackgroundTransparency = i == 1 and 0 or 1
	btn.Text             = t.name
	btn.TextColor3       = C.textDim
	btn.TextSize         = 10
	btn.Font             = Enum.Font.GothamBold
	btn.AutoButtonColor  = false
	btn.BorderSizePixel  = 0
	btn.ZIndex           = 8
	btn.Parent           = Sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	btn.MouseEnter:Connect(function()
		tip.Position = UDim2.new(1, 8, 0, btn.Position.Y.Offset + 9)
		tip.Visible  = true
		if activeTab ~= i then tw(btn, {BackgroundTransparency = 0.7, TextColor3 = C.textMid}) end
	end)
	btn.MouseLeave:Connect(function()
		tip.Visible = false
		if activeTab ~= i then tw(btn, {BackgroundTransparency = 1, TextColor3 = C.textDim}) end
	end)
	btn.MouseButton1Click:Connect(function() selectTab(i) end)

	tabBtns[i] = btn
	local panel, scroll = makePanel()
	tabPanels[i] = { holder = panel, scroll = scroll }
end

-- ══════════════════════════════════════════
--  UI BUILDER FUNCTIONS
-- ══════════════════════════════════════════
local function addHeader(scrollFrame, text)
	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.new(1, -8, 0, 18)
	lbl.BackgroundTransparency = 1
	lbl.Text              = "  " .. string.upper(text)
	lbl.TextColor3        = C.cyanDim
	lbl.TextSize          = 9
	lbl.Font              = Enum.Font.GothamBold
	lbl.TextXAlignment    = Enum.TextXAlignment.Left
	lbl.ZIndex            = 9
	lbl.Parent            = scrollFrame
end

local function addToggle(scrollFrame, label, sublabel, defaultOn, callback)
	local row = Instance.new("Frame")
	row.Size             = UDim2.new(1, -8, 0, sublabel and 44 or 36)
	row.BackgroundColor3 = C.card
	row.BorderSizePixel  = 0
	row.ZIndex           = 9
	row.Parent           = scrollFrame
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

	local rowS = Instance.new("UIStroke")
	rowS.Color = C.line  rowS.Thickness = 1  rowS.Parent = row

	local mark = Instance.new("Frame")
	mark.Size             = UDim2.new(0, 2, 0.6, 0)
	mark.Position         = UDim2.new(0, 0, 0.2, 0)
	mark.BackgroundColor3 = defaultOn and C.cyan or C.line
	mark.BorderSizePixel  = 0
	mark.Parent           = row
	Instance.new("UICorner", mark).CornerRadius = UDim.new(1, 0)

	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.new(1, -60, 0, 16)
	lbl.Position          = UDim2.new(0, 10, 0, sublabel and 7 or 10)
	lbl.BackgroundTransparency = 1
	lbl.Text              = label
	lbl.TextColor3        = C.text
	lbl.TextSize          = 12
	lbl.Font              = Enum.Font.GothamBold
	lbl.TextXAlignment    = Enum.TextXAlignment.Left
	lbl.Parent            = row

	if sublabel then
		local sub = Instance.new("TextLabel")
		sub.Size              = UDim2.new(1, -60, 0, 12)
		sub.Position          = UDim2.new(0, 10, 0, 25)
		sub.BackgroundTransparency = 1
		sub.Text              = sublabel
		sub.TextColor3        = C.textDim
		sub.TextSize          = 9
		sub.Font              = Enum.Font.Gotham
		sub.TextXAlignment    = Enum.TextXAlignment.Left
		sub.Parent            = row
	end

	local track = Instance.new("Frame")
	track.Size             = UDim2.new(0, 38, 0, 20)
	track.Position         = UDim2.new(1, -48, 0.5, -10)
	track.BackgroundColor3 = defaultOn and C.cyan or C.bg0
	track.Parent           = row
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local trkS = Instance.new("UIStroke")
	trkS.Color = defaultOn and C.cyan or C.line
	trkS.Parent = track

	local thumb = Instance.new("Frame")
	thumb.Size             = UDim2.new(0, 14, 0, 14)
	thumb.Position         = defaultOn and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
	thumb.BackgroundColor3 = defaultOn and C.white or C.textDim
	thumb.Parent           = track
	Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

	local clickZone = Instance.new("TextButton")
	clickZone.Size             = UDim2.new(1, 0, 1, 0)
	clickZone.BackgroundTransparency = 1
	clickZone.Text             = ""
	clickZone.Parent           = row

	local state = defaultOn
	clickZone.MouseButton1Click:Connect(function()
		state = not state
		tw(track, {BackgroundColor3 = state and C.cyan or C.bg0})
		tw(trkS,  {Color = state and C.cyan or C.line})
		tw(thumb, {Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7), BackgroundColor3 = state and C.white or C.textDim})
		tw(mark, {BackgroundColor3 = state and C.cyan or C.line})
		if callback then callback(state) end
	end)
end

local function addSlider(scrollFrame, label, minV, maxV, defV, callback)
	local row = Instance.new("Frame")
	row.Size             = UDim2.new(1, -8, 0, 52)
	row.BackgroundColor3 = C.card
	row.Parent           = scrollFrame
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

	local rowS = Instance.new("UIStroke")
	rowS.Color = C.line  rowS.Parent = row

	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.new(0.6, -10, 0, 16)
	lbl.Position          = UDim2.new(0, 10, 0, 8)
	lbl.BackgroundTransparency = 1
	lbl.Text              = label
	lbl.TextColor3        = C.text
	lbl.TextSize          = 12
	lbl.Font              = Enum.Font.GothamBold
	lbl.TextXAlignment    = Enum.TextXAlignment.Left
	lbl.Parent            = row

	local valLbl = Instance.new("TextLabel")
	valLbl.Size              = UDim2.new(0.38, 0, 0, 16)
	valLbl.Position          = UDim2.new(0.62, 0, 0, 8)
	valLbl.BackgroundTransparency = 1
	valLbl.Text              = tostring(defV)
	valLbl.TextColor3        = C.cyanGlow
	valLbl.TextSize          = 12
	valLbl.Font              = Enum.Font.GothamBold
	valLbl.TextXAlignment    = Enum.TextXAlignment.Right
	valLbl.Parent            = row

	local tBg = Instance.new("Frame")
	tBg.Size             = UDim2.new(1, -20, 0, 5)
	tBg.Position         = UDim2.new(0, 10, 1, -18)
	tBg.BackgroundColor3 = C.bg0
	tBg.Parent           = row
	Instance.new("UICorner", tBg).CornerRadius = UDim.new(1, 0)

	local pct = (defV - minV) / (maxV - minV)
	local fill = Instance.new("Frame")
	fill.Size             = UDim2.new(pct, 0, 1, 0)
	fill.BackgroundColor3 = C.cyan
	fill.Parent           = tBg
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local handle = Instance.new("Frame")
	handle.Size             = UDim2.new(0, 12, 0, 12)
	handle.Position         = UDim2.new(pct, -6, 0.5, -6)
	handle.BackgroundColor3 = C.white
	handle.Parent           = tBg
	Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

	local dragBtn = Instance.new("TextButton")
	dragBtn.Size             = UDim2.new(1, 0, 0, 26)
	dragBtn.Position         = UDim2.new(0, 0, 1, -26)
	dragBtn.BackgroundTransparency = 1
	dragBtn.Text             = ""
	dragBtn.Parent           = row

	local dragging = false
	local function updateSlider(inputX)
		local abs  = tBg.AbsolutePosition.X
		local wid  = tBg.AbsoluteSize.X
		local t2   = math.clamp((inputX - abs) / wid, 0, 1)
		local val  = math.floor(minV + t2 * (maxV - minV) + 0.5)
		fill.Size              = UDim2.new(t2, 0, 1, 0)
		handle.Position        = UDim2.new(t2, -6, 0.5, -6)
		valLbl.Text            = tostring(val)
		if callback then callback(val) end
	end

	dragBtn.MouseButton1Down:Connect(function(x) dragging = true  updateSlider(x) end)
	UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	UserInputService.InputChanged:Connect(function(inp) if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(inp.Position.X) end end)
end

-- ╔══════════════════════════════════════════════╗
-- ║  HACKS LOGIC (Aimbot, ESP, ຯລຯ)              ║
-- ╚══════════════════════════════════════════════╝

local aimbotEnabled = false
local aimbotFOV     = 150
local tracersEnabled= false
local fullbright    = false
local originalLighting = {
	Ambient = Lighting.Ambient,
	Brightness = Lighting.Brightness
}

local isAiming = false
local TracerFolder = Instance.new("Folder", Gui)
TracerFolder.Name = "Tracers"

-- ວົງມົນ FOV
local FOVCircle = nil
if type(Drawing) == "table" then
	FOVCircle = Drawing.new("Circle")
	FOVCircle.Visible = false
	FOVCircle.Thickness = 1.5
	FOVCircle.Color = Color3.fromRGB(0, 229, 200)
	FOVCircle.Filled = false
	FOVCircle.Radius = aimbotFOV
end

-- ກວດສອບສັດຕູ
local function isEnemy(p)
	if p == player then return false end
	if player.Team and p.Team and player.Team == p.Team then return false end
	return true
end

local function getClosestEnemy()
	local closest = nil
	local shortestDist = aimbotFOV
	local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

	for _, v in pairs(Players:GetPlayers()) do
		if isEnemy(v) and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
			local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
			if onScreen then
				local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					closest = v.Character.Head
				end
			end
		end
	end
	return closest
end

-- Loop ຫຼັກ
RunService.RenderStepped:Connect(function()
	-- ອັບເດດ FOV ວົງມົນ
	if FOVCircle and FOVCircle.Visible then
		FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
		FOVCircle.Radius = aimbotFOV
	end

	-- Camera Aimbot (ປອດໄພບໍ່ຕາຍເອງ)
	if aimbotEnabled and isAiming then
		local target = getClosestEnemy()
		if target then
			-- ປ້ອງກັນບັກມຸມກ້ອງທับກັນແລ້ວຕາຍ
			if (Camera.CFrame.Position - target.Position).Magnitude > 2 then
				pcall(function()
					Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
				end)
			end
		end
	end

	-- Fullbright
	if fullbright then
		Lighting.Ambient = Color3.new(1, 1, 1)
		Lighting.Brightness = 2
	end

	-- Tracers (ມອງເສັ້ນ)
	TracerFolder:ClearAllChildren()
	if tracersEnabled then
		for _, v in pairs(Players:GetPlayers()) do
			if isEnemy(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
				local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
				if onScreen then
					local line = Instance.new("Frame")
					line.BackgroundColor3 = C.cyan
					line.BorderSizePixel = 0
					line.AnchorPoint = Vector2.new(0.5, 0.5)
					
					local startX, startY = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y
					local dist = math.sqrt((pos.X - startX)^2 + (pos.Y - startY)^2)
					local center = Vector2.new((startX + pos.X) / 2, (startY + pos.Y) / 2)
					
					line.Position = UDim2.new(0, center.X, 0, center.Y)
					line.Size = UDim2.new(0, dist, 0, 1.5)
					line.Rotation = math.deg(math.atan2(pos.Y - startY, pos.X - startX))
					line.Parent = TracerFolder
				end
			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(inp, gp) if not gp and inp.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end end)
UserInputService.InputEnded:Connect(function(inp, gp) if inp.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end end)

-- ══════════════════════════════════════════
--  POPULATE TABS (ເພີ່ມປຸ່ມເຂົ້າ UI)
-- ══════════════════════════════════════════
local sc = tabPanels

-- Combat
addHeader(sc[1].scroll, "Safe Aimbot")
addToggle(sc[1].scroll, "Show FOV Circle",  "ສະແດງວົງມົນລັດສະໝີ Aimbot", false, function(on) if FOVCircle then FOVCircle.Visible = on end end)
addSlider(sc[1].scroll, "FOV Radius", 50, 600, 150, function(v) aimbotFOV = v end)
addToggle(sc[1].scroll, "Camera Aimbot (Hold RMB)", "ລັອກກ້ອງໃສ່ສັດຕູເມື່ອຄລິກຂວາ (ປອດໄພ)", false, function(on) aimbotEnabled = on end)

-- Visuals
addHeader(sc[2].scroll, "Visuals ESP")
addToggle(sc[2].scroll, "Enemy Tracers", "ສະແດງເສັ້ນຊີ້ໄປຫາສັດຕູທຸກຄົນ", false, function(on) tracersEnabled = on end)
addToggle(sc[2].scroll, "Fullbright", "ເພີ່ມຄວາມສະຫວ່າງໃຫ້ເຕັມແມັບ", false, function(on) 
	fullbright = on 
	if not on then Lighting.Ambient = originalLighting.Ambient Lighting.Brightness = originalLighting.Brightness end
end)

-- Settings
addHeader(sc[3].scroll, "Game Settings")
addToggle(sc[3].scroll, "Anti AFK", "ປ້ອງກັນເກມເຕະອອກເວລາຢືນຊື່ໆ", true, function(on) end)
player.Idled:Connect(function()
	local vu = game:GetService("VirtualUser")
	vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
	task.wait(1)
	vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
end)

-- ══════════════════════════════════════════
--  WINDOW CONTROLS
-- ══════════════════════════════════════════
selectTab(1)
tabPanels[1].holder.Visible = true

local isOpen = true
local EOUT   = TweenInfo.new(0.36, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EIN    = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

BtnMin.MouseButton1Click:Connect(function()
	tw(Win, {Position = UDim2.new(0.5,-W_W/2, 0.5,-W_H/2-20)}, 0.2)
	task.delay(0.16, function() Gui.Enabled = false Win.Position = UDim2.new(0.5,-W_W/2, 0.5,-W_H/2) end)
end)

BtnCol.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	if isOpen then
		TweenService:Create(Win, EOUT, {Size = UDim2.new(0,W_W,0,W_H)}):Play()
		task.delay(0.08, function() Body.Visible = true end)
		BtnCol.Text = "[]"
	else
		Body.Visible = false
		TweenService:Create(Win, EIN, {Size = UDim2.new(0,W_W,0,TITLE_H+2)}):Play()
		BtnCol.Text = "[]"
	end
end)

BtnClose.MouseButton1Click:Connect(function()
	TweenService:Create(Win, EIN, {Size = UDim2.new(0,W_W,0,0), Position = UDim2.new(0.5,-W_W/2,0.5,0)}):Play()
	if FOVCircle then FOVCircle:Remove() end
	task.delay(0.28, function() Gui:Destroy() end)
end)

UserInputService.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.RightShift then
		if Gui.Enabled then
			tw(Win, {Position = UDim2.new(0.5,-W_W/2,0.5,-W_H/2-18)}, 0.16)
			task.delay(0.14, function() Gui.Enabled = false Win.Position = UDim2.new(0.5,-W_W/2,0.5,-W_H/2) if FOVCircle then FOVCircle.Visible=false end end)
		else
			Gui.Enabled = true
			Win.Position = UDim2.new(0.5,-W_W/2,0.5,-W_H/2+18)
			tw(Win, {Position = UDim2.new(0.5,-W_W/2,0.5,-W_H/2)}, 0.28)
			if FOVCircle and aimbotFOV > 0 then end 
		end
	end
end)

Win.Size     = UDim2.new(0, W_W, 0, TITLE_H)
Win.Position = UDim2.new(0.5, -W_W/2, 0.5, -TITLE_H/2)
TweenService:Create(Win, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, W_W, 0, W_H), Position = UDim2.new(0.5, -W_W/2, 0.5, -W_H/2)}):Play()

