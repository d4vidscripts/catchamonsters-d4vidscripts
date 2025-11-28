-- d4vidscripts Mejorado: Vuelo + Fast + TP + Minimizar + Cierre
local P = game.Players.LocalPlayer
local G = P:WaitForChild("PlayerGui")
local F = Instance.new
local BG, ACC, BTN = Color3.fromRGB(35,35,35), Color3.fromRGB(100,100,255), Color3.fromRGB(60,60,60)

-- ScreenGui
local S = F("ScreenGui", G)
S.Name = "d4vidscripts"
S.ResetOnSpawn = false

-- Frame principal
local M = F("Frame", S)
M.Size = UDim2.new(0, 320, 0, 240)
M.Position = UDim2.new(0.35, 0, 0.25, 0)
M.BackgroundColor3 = BG
M.BorderSizePixel = 0
M.Active = true

-- Header
local H = F("Frame", M)
H.Size = UDim2.new(1, 0, 0, 30)
H.BackgroundColor3 = Color3.fromRGB(25,25,25)
H.BorderSizePixel = 0

local T = F("TextLabel", H)
T.Size = UDim2.new(1, -60, 1, 0)
T.Position = UDim2.new(0, 10, 0, 0)
T.BackgroundTransparency = 1
T.Text = "d4vidscripts"
T.TextXAlignment = Enum.TextXAlignment.Left
T.TextColor3 = Color3.new(1,1,1)

-- Minimizar / Restaurar
local minimize = F("TextButton", H)
minimize.Size = UDim2.new(0, 28, 0, 20)
minimize.Position = UDim2.new(1, -58, 0, 5)
minimize.Text = "—"
minimize.BackgroundColor3 = BTN

local closeBtn = F("TextButton", H)
closeBtn.Size = UDim2.new(0, 28, 0, 20)
closeBtn.Position = UDim2.new(1, -28, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)

local floatIcon = F("TextButton", S)
floatIcon.Size = UDim2.new(0, 64, 0, 64)
floatIcon.Position = UDim2.new(0.05, 0, 0.6, 0)
floatIcon.Text = "≡"
floatIcon.BackgroundColor3 = ACC
floatIcon.Visible = false

-- Contenido
local content = F("Frame", M)
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1

-- DRAG HEADER
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    M.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
H.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = M.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
H.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- BOTONES MINIMIZAR Y CERRAR
minimize.MouseButton1Click:Connect(function()
    M.Visible = false
    floatIcon.Visible = true
end)
floatIcon.MouseButton1Click:Connect(function()
    M.Visible = true
    floatIcon.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
    S:Destroy()
end)

-- FUNCIONES: Vuelo, Fast, TP
local flyBtn = F("TextButton", content)
flyBtn.Size = UDim2.new(0, 140, 0, 40)
flyBtn.Position = UDim2.new(0, 10, 0, 10)
flyBtn.Text = "Volar"
flyBtn.BackgroundColor3 = ACC

local flySpeedBox = F("TextBox", content)
flySpeedBox.Size = UDim2.new(0, 60, 0, 40)
flySpeedBox.Position = UDim2.new(0, 170, 0, 10)
flySpeedBox.PlaceholderText = "Vel"
flySpeedBox.Text = "60"
flySpeedBox.ClearTextOnFocus = false

local fastBtn = F("TextButton", content)
fastBtn.Size = UDim2.new(0, 140, 0, 40)
fastBtn.Position = UDim2.new(0, 10, 0, 60)
fastBtn.Text = "Fast"
fastBtn.BackgroundColor3 = BTN

local runBox = F("TextBox", content)
runBox.Size = UDim2.new(0, 60, 0, 40)
runBox.Position = UDim2.new(0, 170, 0, 60)
runBox.PlaceholderText = "+"
runBox.Text = "10"
runBox.ClearTextOnFocus = false

-- TP
local tpBtn = F("TextButton", content)
tpBtn.Size = UDim2.new(0, 140, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, 110)
tpBtn.Text = "TP Islas"
tpBtn.BackgroundColor3 = BTN

local tpFrame = F("Frame", M)
tpFrame.Size = UDim2.new(0, 200, 0, 140)
tpFrame.Position = UDim2.new(1, -210, 0, 40)
tpFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
tpFrame.Visible = false

local scroll = F("ScrollingFrame", tpFrame)
scroll.Size = UDim2.new(1,0,1,-30)
scroll.Position = UDim2.new(0,0,0,30)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0,0,0,0)

local lugaresTP = {
    ["Island for Beginners"] = Vector3.new(83.358, -60.177, 670.663),
    ["Volcano"] = Vector3.new(147.165, -118.642, -1139.556),
    ["Glacial Island"] = Vector3.new(-2199.158, -117.374, -996.307)
}

local y=0
for n,p in pairs(lugaresTP) do
    local b = F("TextButton", scroll)
    b.Size = UDim2.new(1,-10,0,35)
    b.Position = UDim2.new(0,5,0,y)
    b.Text = n
    b.BackgroundColor3 = ACC
    y = y + 40
    b.MouseButton1Click:Connect(function()
        local c = P.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame = CFrame.new(p)
        end
    end)
end
scroll.CanvasSize = UDim2.new(0,0,0,y)
tpBtn.MouseButton1Click:Connect(function() tpFrame.Visible = not tpFrame.Visible end)

-- Vuelo
local flying=false; local BV,BG2; local keyState={}
local RS=game:GetService("RunService")
UIS.InputBegan:Connect(function(i,g) if not g and i.UserInputType==Enum.UserInputType.Keyboard then keyState[i.KeyCode]=true end end)
UIS.InputEnded:Connect(function(i) keyState[i.KeyCode]=false end)

local function ensureChar()
    local c=P.Character or P.CharacterAdded:Wait()
    local r=c:FindFirstChild("HumanoidRootPart")
    local h=c:FindFirstChildOfClass("Humanoid")
    return c,r,h
end

local function startFlying(speed)
    local c,r,h=ensureChar()
    if not r or not h then return end
    flying=true
    BV=Instance.new("BodyVelocity", r)
    BV.MaxForce = Vector3.new(1e5,1e5,1e5)
    BV.P=1e4
    BG2=Instance.new("BodyGyro", r)
    BG2.MaxTorque = Vector3.new(1e5,1e5,1e5)
    BG2.P=1e4
    RS.RenderStepped:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        local fwd = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        local v = Vector3.new(0,0,0)
        if keyState[Enum.KeyCode.W] then v=v+Vector3.new(fwd.X,0,fwd.Z) end
        if keyState[Enum.KeyCode.S] then v=v-Vector3.new(fwd.X,0,fwd.Z) end
        if keyState[Enum.KeyCode.A] then v=v-Vector3.new(right.X,0,right.Z) end
        if keyState[Enum.KeyCode.D] then v=v+Vector3.new(right.X,0,right.Z) end
        if keyState[Enum.KeyCode.Space] then v=v+Vector3.new(0,1,0) end
        if keyState[Enum.KeyCode.LeftShift] then v=v-Vector3.new(0,1,0) end
        if v.Magnitude>0 then v=v.Unit*(speed or tonumber(flySpeedBox.Text) or 60) end
        BV.Velocity = v
        BG2.CFrame = cam.CFrame
    end)
end
flyBtn.MouseButton1Click:Connect(function()
    if not flying then
        startFlying()
        flyBtn.Text = "Detener"
    else
        flying=false
        if BV then BV:Destroy() end
        if BG2 then BG2:Destroy() end
        flyBtn.Text="Volar"
    end
end)

-- Fast
local fastActive=false; local fastConnection
fastBtn.MouseButton1Click:Connect(function()
    local c,r,h=ensureChar()
    if not h then return end
    fastActive = not fastActive
    if fastActive then
        local add=tonumber(runBox.Text) or 10
        local speedF = 16 + add
        fastBtn.Text="Fast (ON)"
        fastConnection = RS.Heartbeat:Connect(function() if h then h.WalkSpeed = speedF end end)
    else
        fastBtn.Text="Fast"
        if fastConnection then fastConnection:Disconnect() end
        h.WalkSpeed = 16
    end
end)
