_G.ScriptRunning = false
_G.ChamsEnabled = true
_G.TriggerEnabled = false
_G.AimEnabled = false
_G.AimWallCheck = false
_G.SilentAimEnabled = false
_G.AntiAimEnabled = false
_G.LirpFOV = 120
_G.CorrectKey = "LIRP-2026-FLICK"
_G.ActiveHighlights = {}

print("[Xeno PC]: Part 1 Protected Config Loaded.")
local P = game:GetService("Players")
local LP = P.LocalPlayer
local Cam = workspace.CurrentCamera

_G.IsVisibleCheck = function(character)
    if not character or not character:FindFirstChild("Head") then return false end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {LP.Character, character}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local res = workspace:Raycast(Cam.CFrame.Position, (character.Head.Position - Cam.CFrame.Position), rp)
    return res == nil
end
print("[Xeno PC]: Part 2 Logic Utilities Loaded.")
_G.PurgeLirp = function()
    _G.ScriptRunning = false
    _G.ChamsEnabled = false
    _G.TriggerEnabled = false
    _G.AimEnabled = false
    _G.AimWallCheck = false
    _G.SilentAimEnabled = false
    _G.AntiAimEnabled = false
    if _G.FovGuiCircle then _G.FovGuiCircle.Visible = false end
    for _, h in ipairs(_G.ActiveHighlights) do if h and h.Parent then pcall(function() h:Destroy() end) end end 
    table.clear(_G.ActiveHighlights)
    for _, o in ipairs(game:GetDescendants()) do if o:IsA("Highlight") and o.Name == "Lirp_Highlight" then pcall(function() o:Destroy() end) end end 
end
print("[Xeno PC]: Part 3 Purge Routines Injected.")
local P = game:GetService("Players")
local LP = P.LocalPlayer
local Cam = workspace.CurrentCamera

_G.GetClosestPlayer = function()
    local closest, shortestDist = nil, _G.LirpFOV 
    for _, p in ipairs(P:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then 
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then 
            local pos, onScreen = Cam:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then 
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(LP:GetMouse().X, LP:GetMouse().Y)).Magnitude 
                if dist < shortestDist then shortestDist = dist closest = p.Character.Head end 
            end 
        end 
    end end return closest 
end
print("[Xeno PC]: Part 4 Target Selector Engaged.")
local P = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = P.LocalPlayer

_G.VisualConnection = RS.RenderStepped:Connect(function()
    if not _G.ScriptRunning then return end 
    if _G.ChamsEnabled then 
        for _, p in ipairs(P:GetPlayers()) do if p.Character and p ~= LP then 
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 and not p.Character:FindFirstChild("Lirp_Highlight") then
                local hl = Instance.new("Highlight") hl.Name = "Lirp_Highlight" hl.FillTransparency = 0.45 
                hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
                hl.Parent = p.Character hl.FillColor = Color3.fromRGB(255, 0, 50) table.insert(_G.ActiveHighlights, hl)
            end
        end end
    else _G.PurgeLirp() end 
end)
print("[Xeno PC]: Part 5 Visual Loops Active.")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera

_G.CombatConnection = RS.RenderStepped:Connect(function()
    if not _G.ScriptRunning then return end
    
    -- Обновление круга FOV через UI
    if (_G.AimEnabled or _G.SilentAimEnabled) and _G.FovGuiCircle then 
        _G.FovGuiCircle.Visible = true
        _G.FovGuiCircle.Size = UDim2.new(0, _G.LirpFOV * 2, 0, _G.LirpFOV * 2)
        _G.FovGuiCircle.Position = UDim2.new(0.5, -_G.LirpFOV, 0.5, -_G.LirpFOV)
    else if _G.FovGuiCircle then _G.FovGuiCircle.Visible = false end end 
    
    -- Обычный Аимбот на ПКМ
    if _G.AimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then 
        local target = _G.GetClosestPlayer()
        if target and (not _G.AimWallCheck or _G.IsVisibleCheck(target.Parent)) then Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, target.Position), 0.12) end 
    end 
    
    -- Безопасный Silent Aim на ЛКМ без вызова хуков инжектора
    if _G.SilentAimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target = _G.GetClosestPlayer()
        if target then Cam.CFrame = CFrame.new(Cam.CFrame.Position, target.Position) end
    end

    if _G.AntiAimEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end
end)
print("[Xeno PC]: Part 6 Combat Engines Active.")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

_G.LirpSG = Instance.new("ScreenGui") _G.LirpSG.Name = "LirpHub_PC_Menu" _G.LirpSG.ResetOnSpawn = false
pcall(function() _G.LirpSG.Parent = CG end) if not _G.LirpSG.Parent then _G.LirpSG.Parent = LP:WaitForChild("PlayerGui") end

-- Новый круг FOV через UI (UICorner) вместо Drawing API
_G.FovGuiCircle = Instance.new("Frame") _G.FovGuiCircle.Name = "Lirp_FOV_Circle" _G.FovGuiCircle.BackgroundTransparency = 0.85 _G.FovGuiCircle.BackgroundColor3 = Color3.fromRGB(140, 0, 255) _G.FovGuiCircle.BorderSizePixel = 0 _G.FovGuiCircle.Visible = false _G.FovGuiCircle.Parent = _G.LirpSG
local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(1, 0) UICorner.Parent = _G.FovGuiCircle

_G.KF = Instance.new("Frame") _G.KF.Size = UDim2.new(0, 300, 0, 150) _G.KF.Position = UDim2.new(0.4, 0, 0.4, 0) _G.KF.BackgroundColor3 = Color3.fromRGB(15, 15, 18) _G.KF.BorderSizePixel = 1 _G.KF.BorderColor3 = Color3.fromRGB(140, 0, 255) _G.KF.Active = true _G.KF.Draggable = true _G.KF.Parent = _G.LirpSG
local KT = Instance.new("TextLabel") KT.Size = UDim2.new(1, -30, 0, 30) KT.BackgroundTransparency = 1 KT.Text = "LIRP HUB - Enter Key" KT.TextColor3 = Color3.fromRGB(255, 255, 255) KT.Font = Enum.Font.SourceSansBold KT.Parent = _G.KF
_G.KI = Instance.new("TextBox") _G.KI.Size = UDim2.new(0, 240, 0, 30) _G.KI.Position = UDim2.new(0, 30, 0, 50) _G.KI.BackgroundColor3 = Color3.fromRGB(25, 25, 30) _G.KI.TextColor3 = Color3.fromRGB(140, 0, 255) _G.KI.Text = "" _G.KI.PlaceholderText = "Paste Key Here..." _G.KI.Parent = _G.KF
_G.KB = Instance.new("TextButton") _G.KB.Size = UDim2.new(0, 100, 0, 30) _G.KB.Position = UDim2.new(0, 100, 0, 100) _G.KB.BackgroundColor3 = Color3.fromRGB(140, 0, 255) _G.KB.Text = "Verify" _G.KB.TextColor3 = Color3.fromRGB(255, 255, 255) _G.KB.Font = Enum.Font.SourceSansBold _G.KB.Parent = _G.KF
local CX = Instance.new("TextButton") CX.Size = UDim2.new(0, 30, 0, 30) CX.Position = UDim2.new(1, -30, 0, 0) CX.BackgroundTransparency = 1 CX.Text = "X" CX.TextColor3 = Color3.fromRGB(255, 50, 50) CX.Font = Enum.Font.SourceSansBold CX.Parent = _G.KF
CX.MouseButton1Click:Connect(function() _G.LirpSG:Destroy() end)

_G.MF = Instance.new("Frame") _G.MF.Size = UDim2.new(0, 560, 0, 380) _G.MF.Position = UDim2.new(0.3, 0, 0.25, 0) _G.MF.BackgroundColor3 = Color3.fromRGB(12, 12, 14) _G.MF.BorderSizePixel = 1 _G.MF.BorderColor3 = Color3.fromRGB(35, 35, 45) _G.MF.Active = true _G.MF.Draggable = true _G.MF.Visible = false _G.MF.Parent = _G.LirpSG
local SB = Instance.new("Frame") SB.Size = UDim2.new(0, 45, 1, 0) SB.BackgroundColor3 = Color3.fromRGB(8, 8, 10) SB.Parent = _G.MF
local BL = Instance.new("Frame") BL.Size = UDim2.new(1, 0, 0, 2) BL.BackgroundColor3 = Color3.fromRGB(65, 80, 220) BL.Parent = _G.MF
_G.LirpTB = Instance.new("Frame") _G.LirpTB.Size = UDim2.new(1,-45,0,30) _G.LirpTB.Position = UDim2.new(0, 45, 0, 2) _G.LirpTB.BackgroundColor3 = Color3.fromRGB(15, 15, 18) _G.LirpTB.Parent = _G.MF

_G.tA = Instance.new("TextButton") _G.tA.Size = UDim2.new(0, 80, 1, 0) _G.tA.Position = UDim2.new(0, 20, 0, 0) _G.tA.BackgroundTransparency = 1 _G.tA.Text = "Legit" _G.tA.TextColor3 = Color3.fromRGB(120, 130, 230) _G.tA.Font = Enum.Font.SourceSansBold _G.tA.Parent = _G.LirpTB
_G.tE = Instance.new("TextButton") _G.tE.Size = UDim2.new(0, 80, 1, 0) _G.tE.Position = UDim2.new(0, 110, 0, 0) _G.tE.BackgroundTransparency = 1 _G.tE.Text = "ESP" _G.tE.TextColor3 = Color3.fromRGB(150, 150, 150) _G.tE.Font = Enum.Font.SourceSansBold _G.tE.Parent = _G.LirpTB
_G.tR = Instance.new("TextButton") _G.tR.Size = UDim2.new(0, 80, 1, 0) _G.tR.Position = UDim2.new(0, 200, 0, 0) _G.tR.BackgroundTransparency = 1 _G.tR.Text = "Rage" _G.tR.TextColor3 = Color3.fromRGB(150, 150, 150) _G.tR.Font = Enum.Font.SourceSansBold _G.tR.Parent = _G.LirpTB

print("=========================================")
print("[Xeno System]: Waiting for key...")
print("=========================================")
