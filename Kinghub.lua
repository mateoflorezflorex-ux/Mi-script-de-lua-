-- ============================================================
-- KING HUB
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ====================== VARIABLES ======================
local HitboxEnabled = false
local HitboxSize = 6
local POVEnabled = false
local POVSize = 180
local ESPEnabled = false
local ESPNamesEnabled = false

local HitboxParts = {}
local ESPObjects = {}
local CurrentAnimTrack = nil

-- ====================== GUI PRINCIPAL ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KingHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Botón flotante
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 48, 0, 48)
OpenBtn.Position = UDim2.new(0, 18, 0.5, -24)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
OpenBtn.Text = "K"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 20
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 10)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(80, 80, 100)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

-- Frame principal
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 540, 0, 400)
Main.Position = UDim2.new(0.5, -270, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 50, 65)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 42)
Title.Position = UDim2.new(0, 16, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = ">king hub<"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Cerrar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 15
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 7)
CloseCorner.Parent = CloseBtn

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 145, 1, -55)
Sidebar.Position = UDim2.new(0, 12, 0, 48)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 9)
SideCorner.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 7)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 8)
SidePad.PaddingLeft = UDim.new(0, 8)
SidePad.PaddingRight = UDim.new(0, 8)
SidePad.Parent = Sidebar

-- Contenido
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -175, 1, -60)
Content.Position = UDim2.new(0, 165, 0, 50)
Content.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
Content.BorderSizePixel = 0
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 9)
ContentCorner.Parent = Content

-- ====================== HELPERS ======================
local function CreateSideButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(220, 220, 230)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamMedium
	btn.LayoutOrder = order
	btn.Parent = Sidebar

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 7)
	c.Parent = btn
	return btn
end

local function ClearContent()
	for _, v in ipairs(Content:GetChildren()) do
		if not v:IsA("UICorner") then
			v:Destroy()
		end
	end
end

local function CreateToggle(parent, text, y, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -24, 0, 32)
	frame.Position = UDim2.new(0, 12, 0, y)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.7, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
	lbl.TextSize = 14
	lbl.Font = Enum.Font.Gotham
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 54, 0, 26)
	btn.Position = UDim2.new(1, -58, 0.5, -13)
	btn.BackgroundColor3 = default and Color3.fromRGB(45, 170, 75) or Color3.fromRGB(70, 70, 85)
	btn.Text = default and "ON" or "OFF"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.Parent = frame

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = btn

	local state = default
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.BackgroundColor3 = state and Color3.fromRGB(45, 170, 75) or Color3.fromRGB(70, 70, 85)
		btn.Text = state and "ON" or "OFF"
		callback(state)
	end)
end

local function CreateSlider(parent, text, y, min, max, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -24, 0, 55)
	frame.Position = UDim2.new(0, 12, 0, y)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.Text = text .. ": " .. default
	lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
	lbl.TextSize = 13
	lbl.Font = Enum.Font.Gotham
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, 0, 0, 10)
	bar.Position = UDim2.new(0, 0, 0, 30)
	bar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	bar.BorderSizePixel = 0
	bar.Parent = frame

	local barC = Instance.new("UICorner")
	barC.CornerRadius = UDim.new(1, 0)
	barC.Parent = bar

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
	fill.BorderSizePixel = 0
	fill.Parent = bar

	local fillC = Instance.new("UICorner")
	fillC.CornerRadius = UDim.new(1, 0)
	fillC.Parent = fill

	local dragging = false
	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
	end)
	bar.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			local val = math.floor(min + (max - min) * rel)
			fill.Size = UDim2.new(rel, 0, 1, 0)
			lbl.Text = text .. ": " .. val
			callback(val)
		end
	end)
end

-- ====================== BOTONES SIDEBAR ======================
local HitboxBtn = CreateSideButton("Hitbox POV", 1)
local POVBtn    = CreateSideButton("POV", 2)
local ESPBtn    = CreateSideButton("ESP", 3)
local AnimBtn   = CreateSideButton("Animaciones", 4)

-- ====================== HITBOX ======================
local function ShowHitbox()
	ClearContent()

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -20, 0, 28)
	t.Position = UDim2.new(0, 12, 0, 8)
	t.BackgroundTransparency = 1
	t.Text = "Hitbox POV"
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.TextSize = 18
	t.Font = Enum.Font.GothamBold
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = Content

	CreateToggle(Content, "Activar Hitbox", 50, HitboxEnabled, function(s)
		HitboxEnabled = s
		if not s then
			for _, p in pairs(HitboxParts) do
				if p and p.Parent then p:Destroy() end
			end
			HitboxParts = {}
		end
	end)

	CreateSlider(Content, "Tamaño del cuadrado", 100, 2, 25, HitboxSize, function(v)
		HitboxSize = v
	end)
end

-- ====================== POV CÍRCULO ======================
local POVCircle = Instance.new("Frame")
POVCircle.Name = "POVCircle"
POVCircle.Size = UDim2.new(0, POVSize, 0, POVSize)
POVCircle.Position = UDim2.new(0.5, -POVSize/2, 0.5, -POVSize/2)
POVCircle.BackgroundTransparency = 1
POVCircle.Visible = false
POVCircle.Parent = ScreenGui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 60, 60)
stroke.Thickness = 3
stroke.Parent = POVCircle

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = POVCircle

local function ShowPOV()
	ClearContent()

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -20, 0, 28)
	t.Position = UDim2.new(0, 12, 0, 8)
	t.BackgroundTransparency = 1
	t.Text = "POV Círculo"
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.TextSize = 18
	t.Font = Enum.Font.GothamBold
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = Content

	CreateToggle(Content, "Activar Círculo", 50, POVEnabled, function(s)
		POVEnabled = s
		POVCircle.Visible = s
	end)

	CreateSlider(Content, "Tamaño del círculo", 100, 60, 450, POVSize, function(v)
		POVSize = v
		POVCircle.Size = UDim2.new(0, v, 0, v)
		POVCircle.Position = UDim2.new(0.5, -v/2, 0.5, -v/2)
	end)
end

-- ====================== ESP ======================
local function ClearESP()
	for _, obj in pairs(ESPObjects) do
		if obj and obj.Parent then obj:Destroy() end
	end
	ESPObjects = {}
end

local function CreateESP(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local hl = Instance.new("Highlight")
	hl.Adornee = char
	hl.FillColor = Color3.fromRGB(255, 40, 40)
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.FillTransparency = 0.55
	hl.Parent = char
	table.insert(ESPObjects, hl)

	if ESPNamesEnabled then
		local bb = Instance.new("BillboardGui")
		bb.Size = UDim2.new(0, 120, 0, 28)
		bb.StudsOffset = Vector3.new(0, 3.2, 0)
		bb.AlwaysOnTop = true
		bb.Adornee = root
		bb.Parent = char

		local name = Instance.new("TextLabel")
		name.Size = UDim2.new(1, 0, 1, 0)
		name.BackgroundTransparency = 1
		name.Text = plr.Name
		name.TextColor3 = Color3.fromRGB(255, 255, 255)
		name.TextStrokeTransparency = 0.4
		name.TextSize = 14
		name.Font = Enum.Font.GothamBold
		name.Parent = bb

		table.insert(ESPObjects, bb)
	end
end

local function UpdateESP()
	ClearESP()
	if not ESPEnabled then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		CreateESP(plr)
	end
end

local function ShowESP()
	ClearContent()

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -20, 0, 28)
	t.Position = UDim2.new(0, 12, 0, 8)
	t.BackgroundTransparency = 1
	t.Text = "ESP"
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.TextSize = 18
	t.Font = Enum.Font.GothamBold
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = Content

	CreateToggle(Content, "Activar ESP (paredes)", 50, ESPEnabled, function(s)
		ESPEnabled = s
		UpdateESP()
	end)

	CreateToggle(Content, "Mostrar nombre del enemigo", 95, ESPNamesEnabled, function(s)
		ESPNamesEnabled = s
		UpdateESP()
	end)
end

-- ====================== ANIMACIONES ======================
-- IDs de ejemplo R15 (cámbialos por los del juego si quieres)
local Anims = {
	Inactividad = {
		["Idle 1"] = "rbxassetid://507766666",
		["Idle 2"] = "rbxassetid://507766951",
		["Idle 3"] = "rbxassetid://507766388",
	},
	Marcha = {
		["Marcha 1"] = "rbxassetid://507777826",
		["Marcha 2"] = "rbxassetid://507777268",
	},
	Caminata = {
		["Walk 1"] = "rbxassetid://507777826",
		["Walk 2"] = "rbxassetid://913402848",
		["Walk 3"] = "rbxassetid://507777451",
	},
	Salto = {
		["Jump 1"] = "rbxassetid://507765000",
		["Jump 2"] = "rbxassetid://507765000",
	},
	Caida = {
		["Fall 1"] = "rbxassetid://507767968",
		["Fall 2"] = "rbxassetid://507767968",
	},
	Escalada = {
		["Climb 1"] = "rbxassetid://507765644",
		["Climb 2"] = "rbxassetid://507765644",
	},
	Nado = {
		["Swim 1"] = "rbxassetid://507784897",
		["Swim 2"] = "rbxassetid://507784897",
	}
}

local function PlayAnim(id)
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	if CurrentAnimTrack then
		CurrentAnimTrack:Stop()
		CurrentAnimTrack = nil
	end

	local anim = Instance.new("Animation")
	anim.AnimationId = id
	CurrentAnimTrack = hum:LoadAnimation(anim)
	CurrentAnimTrack.Priority = Enum.AnimationPriority.Action4
	CurrentAnimTrack:Play()
end

local function ShowCategory(cat)
	ClearContent()

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -110, 0, 28)
	t.Position = UDim2.new(0, 12, 0, 8)
	t.BackgroundTransparency = 1
	t.Text = "Animaciones → " .. cat
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.TextSize = 16
	t.Font = Enum.Font.GothamBold
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = Content

	local back = Instance.new("TextButton")
	back.Size = UDim2.new(0, 85, 0, 26)
	back.Position = UDim2.new(1, -100, 0, 9)
	back.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
	back.Text = "← Volver"
	back.TextColor3 = Color3.fromRGB(255, 255, 255)
	back.TextSize = 12
	back.Font = Enum.Font.Gotham
	back.Parent = Content
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 6)
	bc.Parent = back
	back.MouseButton1Click:Connect(ShowAnimations)

	local y = 50
	for name, id in pairs(Anims[cat] or {}) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -24, 0, 34)
		b.Position = UDim2.new(0, 12, 0, y)
		b.BackgroundColor3 = Color3.fromRGB(42, 42, 55)
		b.Text = name
		b.TextColor3 = Color3.fromRGB(230, 230, 240)
		b.TextSize = 13
		b.Font = Enum.Font.Gotham
		b.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 7)
		c.Parent = b

		b.MouseButton1Click:Connect(function()
			PlayAnim(id)
		end)
		y = y + 42
	end
end

function ShowAnimations()
	ClearContent()

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -20, 0, 28)
	t.Position = UDim2.new(0, 12, 0, 8)
	t.BackgroundTransparency = 1
	t.Text = "Animaciones"
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.TextSize = 18
	t.Font = Enum.Font.GothamBold
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = Content

	local cats = {"Inactividad", "Marcha", "Caminata", "Salto", "Caida", "Escalada", "Nado"}
	local y = 50
	for _, cat in ipairs(cats) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -24, 0, 36)
		b.Position = UDim2.new(0, 12, 0, y)
		b.BackgroundColor3 = Color3.fromRGB(42, 42, 55)
		b.Text = cat
		b.TextColor3 = Color3.fromRGB(230, 230, 240)
		b.TextSize = 14
		b.Font = Enum.Font.Gotham
		b.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 7)
		c.Parent = b

		b.MouseButton1Click:Connect(function()
			ShowCategory(cat)
		end)
		y = y + 44
	end
end

-- ====================== CONEXIONES ======================
HitboxBtn.MouseButton1Click:Connect(ShowHitbox)
POVBtn.MouseButton1Click:Connect(ShowPOV)
ESPBtn.MouseButton1Click:Connect(ShowESP)
AnimBtn.MouseButton1Click:Connect(ShowAnimations)

CloseBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

OpenBtn.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- ====================== LOOPS ======================
RunService.Heartbeat:Connect(function()
	if HitboxEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr \~= LocalPlayer and plr.Character then
				local root = plr.Character:FindFirstChild("HumanoidRootPart")
				if root then
					local box = HitboxParts[plr]
					if not box or not box.Parent then
						box = Instance.new("Part")
						box.Name = "KingHitbox"
						box.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
						box.Transparency = 0.65
						box.Color = Color3.fromRGB(255, 30, 30)
						box.Material = Enum.Material.ForceField
						box.CanCollide = false
						box.Anchored = true
						box.Parent = workspace
						HitboxParts[plr] = box
					else
						box.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
						box.CFrame = root.CFrame
					end
				end
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if ESPEnabled then
			task.wait(1.2)
			UpdateESP()
		end
	end)
end)

-- Iniciar en Hitbox
ShowHitbox()

print("✅ King Hub cargado")
