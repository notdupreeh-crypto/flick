-- Инициализируем локальное хранилище вместо проблемного _G
local LirpData = {
    Running = true,
    Chams = true,
    Trigger = false,
    Aim = false,
    WallCheck = false,
    Silent = false,
    AntiAim = false,
    FOV = 120,
    Highlights = {}
}
shared.LirpData = LirpData
print("[Lirp Hub]: Part 1 Protected Memory Layout Loaded.")
local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera

shared.IsVisible = function(character)
    if not character or not character:FindFirstChild("Head") then return false end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {LP.Character, character}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local res = workspace:Raycast(Cam.CFrame.Position, (character.Head.Position - Cam.CFrame.Position), rp)
    return res == nil
end
print("[Lirp Hub]: Part 2 Humanized Raycast Utility Loaded.")
local P = game:GetService("Players")
local LP = P.LocalPlayer
local Cam = workspace.CurrentCamera

shared.GetTarget = function()
    local data = shared.LirpData
    if not data then return nil end
    local closest, shortest = nil, data.FOV
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Cam:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(LP:GetMouse().X, LP:GetMouse().Y)).Magnitude
                    if dist < shortest then shortest = dist closest = p.Character.Head end
                end
            end
        end
    end
    return closest
end
print("[Lirp Hub]: Part 3 Target Selector Synchronized.")
shared.CleanLirp = function()
    local data = shared.LirpData
    if not data then return end
    data.Running = false data.Chams = false data.Trigger = false
    data.Aim = false data.WallCheck = false data.Silent = false data.AntiAim = false
    if shared.FovCircle then shared.FovCircle.Visible = false end
    for _, h in ipairs(data.Highlights) do if h and h.Parent then pcall(function() h:Destroy() end) end end
    table.clear(data.Highlights)
    for _, o in ipairs(game:GetDescendants()) do
        if o:IsA("Highlight") and o.Name == "Lirp_Highlight" then pcall(function() o:Destroy() end) end
    end
end
print("[Lirp Hub]: Part 4 Garbage Collector Ready.")
local P = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = P.LocalPlayer

shared.VisualLoop = RS.RenderStepped:Connect(function()
    local data = shared.LirpData
    if not data or not data.Running then return end
    if data.Chams then
        for _, p in ipairs(P:GetPlayers()) do if p.Character and p ~= LP then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 and not p.Character:FindFirstChild("Lirp_Highlight") then
                local hl = Instance.new("Highlight") hl.Name = "Lirp_Highlight" hl.FillTransparency = 0.45
                hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = p.Character hl.FillColor = Color3.fromRGB(255, 0, 50) table.insert(data.Highlights, hl)
            end
        end end
    else shared.CleanLirp() end
end)
print("[Lirp Hub]: Part 5 Visual Thread Online.")
local CG = game:GetService("CoreGui")
local LP = game:GetService("Players").LocalPlayer

shared.SG = Instance.new("ScreenGui") shared.SG.Name = "LirpPC" shared.SG.ResetOnSpawn = false
pcall(function() shared.SG.Parent = CG end) if not shared.SG.Parent then shared.SG.Parent = LP:WaitForChild("PlayerGui") end

shared.FovCircle = Instance.new("Frame") shared.FovCircle.Name = "LirpFOV" shared.FovCircle.BackgroundTransparency = 0.85 shared.FovCircle.BackgroundColor3 = Color3.fromRGB(140, 0, 255) shared.FovCircle.BorderSizePixel = 0 shared.FovCircle.Visible = false shared.FovCircle.Parent = shared.SG
local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(1, 0) UICorner.Parent = shared.FovCircle

shared.MF = Instance.new("Frame") shared.MF.Size = UDim2.new(0, 560, 0, 380) shared.MF.Position = UDim2.new(0.3, 0, 0.25, 0) shared.MF.BackgroundColor3 = Color3.fromRGB(12, 12, 14) shared.MF.BorderSizePixel = 1 shared.MF.BorderColor3 = Color3.fromRGB(35, 35, 45) shared.MF.Active = true shared.MF.Draggable = true shared.MF.Parent = shared.SG
local SB = Instance.new("Frame") SB.Size = UDim2.new(0, 45, 1, 0) SB.BackgroundColor3 = Color3.fromRGB(8, 8, 10) SB.Parent = shared.MF
local BL = Instance.new("Frame") BL.Size = UDim2.new(1, 0, 0, 2) BL.BackgroundColor3 = Color3.fromRGB(65, 80, 220) BL.Parent = shared.MF
shared.TB = Instance.new("Frame") shared.TB.Size = UDim2.new(1,-45,0,30) shared.TB.Position = UDim2.new(0, 45, 0, 2) shared.TB.BackgroundColor3 = Color3.fromRGB(15, 15, 18) shared.TB.Parent = shared.MF
print("[Lirp Hub]: Part 6 Window Layout Built.")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera

local tA = Instance.new("TextButton") tA.Size = UDim2.new(0, 80, 1, 0) tA.Position = UDim2.new(0, 20, 0, 0) tA.BackgroundTransparency = 1 tA.Text = "Legit" tA.TextColor3 = Color3.fromRGB(120, 130, 230) tA.Font = Enum.Font.SourceSansBold tA.Parent = shared.TB
local tE = Instance.new("TextButton") tE.Size = UDim2.new(0, 80, 1, 0) tE.Position = UDim2.new(0, 110, 0, 0) tE.BackgroundTransparency = 1 tE.Text = "ESP" tE.TextColor3 = Color3.fromRGB(150, 150, 150) tE.Font = Enum.Font.SourceSansBold tE.Parent = shared.TB
local tR = Instance.new("TextButton") tR.Size = UDim2.new(0, 80, 1, 0) tR.Position = UDim2.new(0, 200, 0, 0) tR.BackgroundTransparency = 1 tR.Text = "Rage" tR.TextColor3 = Color3.fromRGB(150, 150, 150) tR.Font = Enum.Font.SourceSansBold tR.Parent = shared.TB

local AP = Instance.new("Frame") AP.Size = UDim2.new(1, -65, 1, -50) AP.Position = UDim2.new(0, 55, 0, 40) AP.BackgroundTransparency = 1 AP.Visible = true AP.Parent = shared.MF
local EP = Instance.new("Frame") EP.Size = UDim2.new(1, -65, 1, -50) EP.Position = UDim2.new(0, 55, 0, 40) EP.BackgroundTransparency = 1 EP.Visible = false EP.Parent = shared.MF
local RP = Instance.new("Frame") RP.Size = UDim2.new(1, -65, 1, -50) RP.Position = UDim2.new(0, 55, 0, 40) RP.BackgroundTransparency = 1 RP.Visible = false RP.Parent = shared.MF

tA.MouseButton1Click:Connect(function() AP.Visible = true; EP.Visible = false; RP.Visible = false; tA.TextColor3 = Color3.fromRGB(120, 130, 230); tE.TextColor3 = Color3.fromRGB(150, 150, 150); tR.TextColor3 = Color3.fromRGB(150, 150, 150) end)
tE.MouseButton1Click:Connect(function() AP.Visible = false; EP.Visible = true; RP.Visible = false; tA.TextColor3 = Color3.fromRGB(150, 150, 150); tE.TextColor3 = Color3.fromRGB(120, 130, 230); tR.TextColor3 = Color3.fromRGB(150, 150, 150) end)
tR.MouseButton1Click:Connect(function() AP.Visible = false; EP.Visible = false; RP.Visible = true; tA.TextColor3 = Color3.fromRGB(150, 150, 150); tE.TextColor3 = Color3.fromRGB(150, 150, 150); tR.TextColor3 = Color3.fromRGB(120, 130, 230) end)

local aC = Instance.new("TextButton") aC.Size = UDim2.new(0, 14, 0, 14) aC.Position = UDim2.new(0, 15, 0, 25) aC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) aC.Text = "" aC.Parent = AP
local aL = Instance.new("TextLabel") aL.Size = UDim2.new(0, 250, 0, 14) aL.Position = UDim2.new(0, 40, 0, 25) aL.BackgroundTransparency = 1 aL.Text = "Enable Aimbot" aL.TextColor3 = Color3.fromRGB(220, 220, 220) aL.TextXAlignment = Enum.TextXAlignment.Left aL.Font = Enum.Font.SourceSans aL.Parent = AP
aC.MouseButton1Click:Connect(function() local d = shared.LirpData if d then d.Aim = not d.Aim aC.BackgroundColor3 = d.Aim and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end end)

local awC = Instance.new("TextButton") awC.Size = UDim2.new(0, 14, 0, 14) awC.Position = UDim2.new(0, 15, 0, 55) awC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) awC.Text = "" awC.Parent = AP
local awL = Instance.new("TextLabel") awL.Size = UDim2.new(0, 250, 0, 14) awL.Position = UDim2.new(0, 40, 0, 55) awL.BackgroundTransparency = 1 awL.Text = "Aimbot Wall Check" awL.TextColor3 = Color3.fromRGB(220, 220, 220) awL.TextXAlignment = Enum.TextXAlignment.Left awL.Font = Enum.Font.SourceSans awL.Parent = AP
awC.MouseButton1Click:Connect(function() local d = shared.LirpData if d then d.WallCheck = not d.WallCheck awC.BackgroundColor3 = d.WallCheck and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end end)

local tC = Instance.new("TextButton") tC.Size = UDim2.new(0, 14, 0, 14) tC.Position = UDim2.new(0, 15, 0, 85) tC.BackgroundColor3 = Color3.fromRGB(30,30,35) tC.Text = "" tC.Parent = AP
local tL = Instance.new("TextLabel") tL.Size = UDim2.new(0, 250, 0, 14) tL.Position = UDim2.new(0, 40, 0, 85) tL.BackgroundTransparency = 1 tL.Text = "Enable Instant Triggerbot" tL.TextColor3 = Color3.fromRGB(220, 220, 220) tL.TextXAlignment = Enum.TextXAlignment.Left tL.Font = Enum.Font.SourceSans tL.Parent = AP
tC.MouseButton1Click:Connect(function() local d = shared.LirpData if d then d.Trigger = not d.Trigger tC.BackgroundColor3 = d.Trigger and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end end)

local cC = Instance.new("TextButton") cC.Size = UDim2.new(0, 14, 0, 14) cC.Position = UDim2.new(0, 15, 0, 30) cC.BackgroundColor3 = Color3.fromRGB(65, 80, 220) cC.Text = "" cC.Parent = EP
local cL = Instance.new("TextLabel") cL.Size = UDim2.new(0, 250, 0, 14) cL.Position = UDim2.new(0, 40, 0, 30) cL.BackgroundTransparency = 1 cL.Text = "Enable Chams Visuals" cL.TextColor3 = Color3.fromRGB(220, 220, 220) cL.TextXAlignment = Enum.TextXAlignment.Left cL.Font = Enum.Font.SourceSans cL.Parent = EP
cC.MouseButton1Click:Connect(function() local d = shared.LirpData if d then d.Chams = not d.Chams cC.BackgroundColor3 = d.Chams and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) if not d.Chams then shared.CleanLirp() end end end)

local saC = Instance.new("TextButton") saC.Size = UDim2.new(0, 14, 0, 14) saC.Position = UDim2.new(0, 15, 0, 25) saC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) saC.Text = "" saC.Parent = RP
local saL = Instance.new("TextLabel") saL.Size = UDim2.new(0, 250, 0, 14) saL.Position = UDim2.new(0, 40, 0, 25) saL.BackgroundTransparency = 1 saL.Text = "Enable Silent Aimbot (Rage)" saL.TextColor3 = Color3.fromRGB(220, 220, 220) saL.TextXAlignment = Enum.TextXAlignment.Left saL.Font = Enum.Font.SourceSans saL.Parent = RP
saC.MouseButton1Click:Connect(function() local d = shared.LirpData if d then d.Silent = not d.Silent saC.BackgroundColor3 = d.Silent and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end end)

local rC = Instance.new("TextButton") rC.Size = UDim2.new(0, 14, 0, 14) rC.Position = UDim2.new(0, 15, 0, 60) rC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) rC.Text = "" rC.Parent = RP
local rL = Instance.new("TextLabel") rL.Size = UDim2.new(0, 250, 0, 14) rL.Position = UDim2.new(0, 40, 0, 60) rL.BackgroundTransparency = 1 rL.Text = "Enable Anti-Aim (Spin)" rL.TextColor3 = Color3.fromRGB(220, 220, 220) rL.TextXAlignment = Enum.TextXAlignment.Left rL.Font = Enum.Font.SourceSans rL.Parent = RP
rC.MouseButton1Click:Connect(function() local d = shared.LirpData if d then d.AntiAim = not d.AntiAim rC.BackgroundColor3 = d.AntiAim and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end end)

local UB = Instance.new("TextButton") UB.Size = UDim2.new(0, 180, 0, 30) UB.Position = UDim2.new(0, 55, 1, -40) UB.BackgroundColor3 = Color3.fromRGB(25, 25, 30) UB.BorderSizePixel = 1 UB.BorderColor3 = Color3.fromRGB(40, 40, 50) UB.Text = "Unload Lirp Hub" UB.TextColor3 = Color3.fromRGB(160, 160, 160) UB.Font = Enum.Font.SourceSans UB.Parent = shared.MF

shared.CombatLoop = RS.RenderStepped:Connect(function()
    local d = shared.LirpData if not d or not d.Running then return end
    if (d.Aim or d.Silent) and shared.FovCircle then 
        shared.FovCircle.Visible = true shared.FovCircle.Size = UDim2.new(0, d.FOV * 2, 0, d.FOV * 2) shared.FovCircle.Position = UDim2.new(0.5, -d.FOV, 0.5, -d.FOV)
    else if shared.FovCircle then shared.FovCircle.Visible = false end end 
    if d.Aim and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then 
        local target = shared.GetTarget and shared.GetTarget()
        if target and (not d.WallCheck or shared.IsVisible(target.Parent)) then Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, target.Position), 0.12) end 
    end 
    if d.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target = shared.GetTarget and shared.GetTarget()
        if target then d.OldCamCFrame = Cam.CFrame Cam.CFrame = CFrame.new(Cam.CFrame.Position, target.Position) task.wait() if d.OldCamCFrame then Cam.CFrame = d.OldCamCFrame end end
    end
    if d.AntiAim and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local char = LP.Character local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.AutoRotate = false end
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(65), 0)
    else if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then LP.Character:FindFirstChildOfClass("Humanoid").AutoRotate = true end end
    if d.Trigger then 
        local rp = RaycastParams.new() rp.FilterDescendantsInstances = {LP.Character} rp.FilterType = Enum.RaycastFilterType.Exclude 
        local res = workspace:Raycast(Cam.CFrame.Position, Cam.CFrame.LookVector * 1500, rp)
        if res and res.Instance then 
            local ch = res.Instance.Parent if ch and not ch:FindFirstChildOfClass("Humanoid") then ch = res.Instance.Parent.Parent end 
            if ch and ch ~= LP.Character and ch:FindFirstChildOfClass("Humanoid") and ch:FindFirstChildOfClass("Humanoid").Health > 0 then mouse1click() end 
        end 
    end 
end)

local tConn tConn = UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then shared.SG.Enabled = not shared.SG.Enabled if shared.FovCircle then shared.FovCircle.Visible = ((shared.LirpData.Aim or shared.LirpData.Silent) and shared.SG.Enabled) end end
end)

UB.MouseButton1Click:Connect(function()
    shared.CleanLirp() if shared.VisualLoop then shared.VisualLoop:Disconnect() end if shared.CombatLoop then shared.CombatLoop:Disconnect() end if tConn then tConn:Disconnect() end task.wait(0.05) shared.SG:Destroy() print("[Lirp Hub]: Unloaded Successfully.")
end)
print("=========================================\n[Lirp Hub]: Script Version 10.0 Fully Active!\n=========================================")
