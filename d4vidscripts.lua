-- d4vidscripts: Vuelo + Fast + TP + Minimizar (Interfaz mejorada)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "d4vidscripts"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 9999
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true

-- Estilos
local BGColor = Color3.fromRGB(35,35,35)
local BtnColor = Color3.fromRGB(60,60,60)
local Accent = Color3.fromRGB(100,100,255)

-- Ventana principal
local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0,320,0,220)
main.Position = UDim2.new(0.35,0,0.25,0)
main.BackgroundColor3 = BGColor
main.BorderSizePixel = 0
main.Parent = screenGui
main.Active = true

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-70,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "d4vidscripts"
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.new(1,1,1)
title.Parent = header

-- Botón minimizar y restaurar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,28,0,20)
minimize.Position = UDim2.new(1,-58,0,5)
minimize.Text = "—"
minimize.BackgroundColor3 = BtnColor
minimize.Parent = header

local floatIcon = Instance.new("TextButton")
floatIcon.Size = UDim2.new(0,64,0,64)
floatIcon.Position = UDim2.new(0.05,0,0.6,0)
floatIcon.BackgroundColor3 = Accent
floatIcon.Text = "≡"
floatIcon.Visible = false
floatIcon.Parent = screenGui

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    floatIcon.Visible = true
end)
floatIcon.MouseButton1Click:Connect(function()
    main.Visible = true
    floatIcon.Visible = false
end)

-- Contenido
local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-30)
content.Position = UDim2.new(0,0,0,30)
content.BackgroundTransparency = 1
content.Parent = main

-- Vuelo
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0,140,0,40)
flyBtn.Position = UDim2.new(0,10,0,10)
flyBtn.Text = "Volar"
flyBtn.BackgroundColor3 = Accent
flyBtn.Parent = content

local flySpeedBox = Instance.new("TextBox")
flySpeedBox.Size = UDim2.new(0,60,0,40)
flySpeedBox.Position = UDim2.new(0,170,0,10)
flySpeedBox.PlaceholderText = "Vel"
flySpeedBox.Text = "60"
flySpeedBox.ClearTextOnFocus = false
flySpeedBox.Parent = content

-- Fast
local fastBtn = Instance.new("TextButton")
fastBtn.Size = UDim2.new(0,140,0,40)
fastBtn.Position = UDim2.new(0,10,0,60)
fastBtn.Text = "Fast"
fastBtn.BackgroundColor3 = BtnColor
fastBtn.Parent = content

local runBox = Instance.new("TextBox")
runBox.Size = UDim2.new(0,60,0,40)
runBox.Position = UDim2.new(0,170,0,60)
runBox.PlaceholderText = "+"
runBox.Text = "10"
runBox.ClearTextOnFocus = false
runBox.Parent = content

-- TP Islas
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0,140,0,40)
tpBtn.Position = UDim2.new(0,10,0,110)
tpBtn.Text = "TP Islas"
tpBtn.BackgroundColor3 = BtnColor
tpBtn.Parent = content

local tpFrame = Instance.new("Frame")
tpFrame.Size = UDim2.new(0,200,0,140)
tpFrame.Position = UDim2.new(1,-210,0,40)
tpFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
tpFrame.Visible = false
tpFrame.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-30)
scroll.Position = UDim2.new(0,0,0,30)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = tpFrame

local lugaresTP = {
    ["Island for Beginners"] = Vector3.new(83.35845184326172,-60.17778396606445,670.6635131835938),
    ["Volcano"] = Vector3.new(147.16506958007812,-118.6424789428711,-1139.555908203125),
    ["Glacial Island"] = Vector3.new(-2199.157958984375,-117.3743667602539,-996.306640625)
}

local y = 0
for nombre,pos in pairs(lugaresTP) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-10,0,35)
    b.Position = UDim2.new(0,5,0,y)
    b.Text = nombre
    b.BackgroundColor3 = Accent
    b.Parent = scroll
    y = y + 40

    b.MouseButton1Click:Connect(function()
        local c = player.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
end
scroll.CanvasSize = UDim2.new(0,0,0,y)
tpBtn.MouseButton1Click:Connect(function()
    tpFrame.Visible = not tpFrame.Visible
end)

-- Sistema de vuelo
local flying = false
local BV,BG2
local keyState = {}

UserInputService.InputBegan:Connect(function(input,g)
    if not g and input.UserInputType==Enum.UserInputType.Keyboard then keyState[input.KeyCode]=true end
end)
UserInputService.InputEnded:Connect(function(input)
    keyState[input.KeyCode]=false
end)

local function ensureChar()
    local c = player.Character or player.CharacterAdded:Wait()
    local r = c:FindFirstChild("HumanoidRootPart")
    local h = c:FindFirstChildOfClass("Humanoid")
    return c,r,h
end

local function startFlying(speed)
    local c,r,h = ensureChar()
    if not r or not h then return end
    flying = true
    if not BV then BV = Instance.new("BodyVelocity",r); BV.MaxForce = Vector3.new(1e5,1e5,1e5); BV.P = 1e4 end
    if not BG2 then BG2 = Instance.new("BodyGyro",r); BG2.MaxTorque = Vector3.new(1e5,1e5,1e5); BG2.P = 1e4 end
    RunService.RenderStepped:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        local fwd = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        local v = Vector3.new(0,0,0)
        if keyState[Enum.KeyCode.W] then v = v + Vector3.new(fwd.X,0,fwd.Z) end
        if keyState[Enum.KeyCode.S] then v = v - Vector3.new(fwd.X,0,fwd.Z) end
        if keyState[Enum.KeyCode.A] then v = v - Vector3.new(right.X,0,right.Z) end
        if keyState[Enum.KeyCode.D] then v = v + Vector3.new(right.X,0,right.Z) end
        if keyState[Enum.KeyCode.Space] then v = v + Vector3.new(0,1,0) end
        if keyState[Enum.KeyCode.LeftShift] then v = v - Vector3.new(0,1,0) end
        if v.Magnitude>0 then v = v.Unit*(speed or tonumber(flySpeedBox.Text) or 60) end
        BV.Velocity = v
        BG2.CFrame = cam.CFrame
    end)
end

flyBtn.MouseButton1Click:Connect(function()
    if not flying then startFlying(); flyBtn.Text="Detener"
    else flying=false; if BV then BV:Destroy() BV=nil end; if BG2 then BG2:Destroy() BG2=nil end; flyBtn.Text="Volar" end
end)

-- Fast
local fastActive = false
local fastConnection
fastBtn.MouseButton1Click:Connect(function()
    local c,r,h = ensureChar()
    if not h then return end
    fastActive = not fastActive
    if fastActive then
        local add = tonumber(runBox.Text) or 10
        local speedF = 16 + add
        fastBtn.Text = "Fast (ON)"
        fastConnection = RunService.Heartbeat:Connect(function() if h then h.WalkSpeed = speedF end end)
    else
        fastBtn.Text = "Fast"
        if fastConnection then fastConnection:Disconnect() end
        h.WalkSpeed = 16
    end
end)
