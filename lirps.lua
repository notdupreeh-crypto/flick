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

local Cam = workspace.CurrentCamera
_G.FovCircle = Drawing.new("Circle")
_G.FovCircle.Color = Color3.fromRGB(140, 0, 255)
_G.FovCircle.Thickness = 1
_G.FovCircle.NumSides = 64
_G.FovCircle.Filled = false
_G.FovCircle.Transparency = 0.6
_G.FovCircle.Visible = false

print("[Xeno System]: Part 1 Memory Core Loaded.")
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

_G.PurgeLirp = function()
    _G.ScriptRunning = false
    _G.ChamsEnabled = false
    _G.TriggerEnabled = false
    _G.AimEnabled = false
    _G.AimWallCheck = false
    _G.SilentAimEnabled = false
    _G.AntiAimEnabled = false
    if _G.FovCircle then _G.FovCircle.Visible = false end
    for _, h in ipairs(_G.ActiveHighlights) do 
        if h and h.Parent then pcall(function() h:Destroy() end) end 
    end 
    table.clear(_G.ActiveHighlights)
    for _, o in ipairs(game:GetDescendants()) do 
        if o:IsA("Highlight") and o.Name == "Lirp_Highlight" then pcall(function() o:Destroy() end) end 
    end 
end
print("[Xeno System]: Part 2 Logic Utilities Loaded.")
local P = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = P.LocalPlayer
local Cam = workspace.CurrentCamera

_G.GetClosestPlayer = function()
    local closest, shortestDist = nil, _G.LirpFOV 
    for _, p in ipairs(P:GetPlayers()) do 
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then 
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then 
                local pos, onScreen = Cam:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then 
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(LP:GetMouse().X, LP:GetMouse().Y)).Magnitude 
                    if dist < shortestDist then shortestDist = dist closest = p.Character.Head end 
                end 
            end 
        end 
    end 
    return closest 
end

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
    end 
end)
print("[Xeno System]: Part 3 Visual Loops Active.")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera

_G.AimConnection = RS.RenderStepped:Connect(function()
    if not _G.ScriptRunning then return end
    if (_G.AimEnabled or _G.SilentAimEnabled) and _G.FovCircle then 
        _G.FovCircle.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
        _G.FovCircle.Radius = _G.LirpFOV 
    end 
    if _G.AimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then 
        local targetHead = _G.GetClosestPlayer()
        if targetHead and (not _G.AimWallCheck or _G.IsVisibleCheck(targetHead.Parent)) then 
            Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, targetHead.Position), 0.15) 
        end 
    end 
    if _G.AntiAimEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod() local args = {...}
    if _G.ScriptRunning and _G.SilentAimEnabled and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local tHead = _G.GetClosestPlayer() if tHead then if method == "Raycast" then args = (tHead.Position - args).Unit * 1500 end return oldNamecall(self, unpack(args)) end
    end
    return oldNamecall(self, ...)
end)
print("[Xeno System]: Part 4 Mobile Hooks Loaded.")
local P = game:GetService("Players")
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local LP = P.LocalPlayer
local Cam = workspace.CurrentCamera

local function mobileFireClick()
    pcall(function()
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.01)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
end

_G.TriggerConnection = RS.RenderStepped:Connect(function()
    if not _G.ScriptRunning then return end
    if _G.TriggerEnabled then 
        local rp = RaycastParams.new() rp.FilterDescendantsInstances = {LP.Character} rp.FilterType = Enum.RaycastFilterType.Exclude 
        local res = workspace:Raycast(Cam.CFrame.Position, Cam.CFrame.LookVector * 1500, rp)
        if res and res.Instance then 
            local ch = res.Instance.Parent if ch and not ch:FindFirstChildOfClass("Humanoid") then ch = res.Instance.Parent.Parent end 
            if ch and ch ~= LP.Character and ch:FindFirstChildOfClass("Humanoid") and ch:FindFirstChildOfClass("Humanoid").Health > 0 then 
                mobileFireClick()
            end 
        end 
    end 
end)
print("[Xeno System]: Part 5 Mobile Triggerbot Loaded.")
local CG = game:GetService("CoreGui")
local LP = game:GetService("Players").LocalPlayer

_G.LirpSG = Instance.new("ScreenGui") _G.LirpSG.Name = "LirpHub_Main" _G.LirpSG.ResetOnSpawn = false
pcall(function() _G.LirpSG.Parent = CG end) if not _G.LirpSG.Parent then _G.LirpSG.Parent = LP:WaitForChild("PlayerGui") end

_G.KF = Instance.new("Frame") _G.KF.Size = UDim2.new(0, 300, 0, 150) _G.KF.Position = UDim2.new(0.4, 0, 0.4, 0) _G.KF.BackgroundColor3 = Color3.fromRGB(15, 15, 18) _G.KF.BorderSizePixel = 1 _G.KF.BorderColor3 = Color3.fromRGB(140, 0, 255) _G.KF.Active = true _G.KF.Draggable = true _G.KF.Parent = _G.LirpSG
local KT = Instance.new("TextLabel") KT.Size = UDim2.new(1, -30, 0, 30) KT.BackgroundTransparency = 1 KT.Text = "LIRP HUB - Enter Key" KT.TextColor3 = Color3.fromRGB(255, 255, 255) KT.Font = Enum.Font.SourceSansBold KT.Parent = _G.KF
_G.KI = Instance.new("TextBox") _G.KI.Size = UDim2.new(0, 240, 0, 30) _G.KI.Position = UDim2.new(0, 30, 0, 50) _G.KI.BackgroundColor3 = Color3.fromRGB(25, 25, 30) _G.KI.TextColor3 = Color3.fromRGB(140, 0, 255) _G.KI.Text = "" _G.KI.PlaceholderText = "Paste Key Here..." _G.KI.Parent = _G.KF
_G.KB = Instance.new("TextButton") _G.KB.Size = UDim2.new(0, 100, 0, 30) _G.KB.Position = UDim2.new(0, 100, 0, 100) _G.KB.BackgroundColor3 = Color3.fromRGB(140, 0, 255) _G.KB.Text = "Verify" _G.KB.TextColor3 = Color3.fromRGB(255, 255, 255) _G.KB.Font = Enum.Font.SourceSansBold _G.KB.Parent = _G.KF
local CX = Instance.new("TextButton") CX.Size = UDim2.new(0, 30, 0, 30) CX.Position = UDim2.new(1, -30, 0, 0) CX.BackgroundTransparency = 1 CX.Text = "X" CX.TextColor3 = Color3.fromRGB(255, 50, 50) CX.Font = Enum.Font.SourceSansBold CX.Parent = _G.KF
CX.MouseButton1Click:Connect(function() _G.LirpSG:Destroy() end)

_G.MF = Instance.new("Frame") _G.MF.Size = UDim2.new(0, 560, 0, 380) _G.MF.Position = UDim2.new(0.3, 0, 0.25, 0) _G.MF.BackgroundColor3 = Color3.fromRGB(12, 12, 14) _G.MF.BorderSizePixel = 1 _G.MF.BorderColor3 = Color3.fromRGB(35, 35, 45) _G.MF.Active = true _G.MF.Draggable = true _G.MF.Visible = false _G.MF.Parent = _G.LirpSG
local SB = Instance.new("Frame") SB.Size = UDim2.new(0, 45, 1, 0) SB.BackgroundColor3 = Color3.fromRGB(8, 8, 10) SB.Parent = _G.MF
local BL = Instance.new("Frame") BL.Size = UDim2.new(1, 0, 0, 2) BL.BackgroundColor3 = Color3.fromRGB(65, 80, 220) BL.Parent = _G.MF
local TB = Instance.new("Frame") TB.Size = UDim2.new(1,-45,0,30) TB.Position = UDim2.new(0, 45, 0, 2) TB.BackgroundColor3 = Color3.fromRGB(15, 15, 18) TB.Parent = _G.MF

_G.tA = Instance.new("TextButton") _G.tA.Size = UDim2.new(0, 80, 1, 0) _G.tA.Position = UDim2.new(0, 20, 0, 0) _G.tA.BackgroundTransparency = 1 _G.tA.Text = "Legit" _G.tA.TextColor3 = Color3.fromRGB(120, 130, 230) _G.tA.Font = Enum.Font.SourceSansBold _G.tA.Parent = TB
_G.tE = Instance.new("TextButton") _G.tE.Size = UDim2.new(0, 80, 1, 0) _G.tE.Position = UDim2.new(0, 110, 0, 0) _G.tE.BackgroundTransparency = 1 _G.tE.Text = "ESP" _G.tE.TextColor3 = Color3.fromRGB(150, 150, 150) _G.tE.Font = Enum.Font.SourceSansBold _G.tE.Parent = TB
_G.tR = Instance.new("TextButton") _G.tR.Size = UDim2.new(0, 80, 1, 0) _G.tR.Position = UDim2.new(0, 200, 0, 0) _G.tR.BackgroundTransparency = 1 _G.tR.Text = "Rage" _G.tR.TextColor3 = Color3.fromRGB(150, 150, 150) _G.tR.Font = Enum.Font.SourceSansBold _G.tR.Parent = TB
print("[Xeno System]: Part 6 Panels Injected.")
local UIS = game:GetService("UserInputService")
local AP = Instance.new("Frame") AP.Size = UDim2.new(1, -65, 1, -50) AP.Position = UDim2.new(0, 55, 0, 40) AP.BackgroundTransparency = 1 AP.Visible = true AP.Parent = _G.MF
local EP = Instance.new("Frame") EP.Size = UDim2.new(1, -65, 1, -50) EP.Position = UDim2.new(0, 55, 0, 40) EP.BackgroundTransparency = 1 EP.Visible = false EP.Parent = _G.MF
local RP = Instance.new("Frame") RP.Size = UDim2.new(1, -65, 1, -50) RP.Position = UDim2.new(0, 55, 0, 40) RP.BackgroundTransparency = 1 RP.Visible = false RP.Parent = _G.MF

_G.tA.MouseButton1Click:Connect(function() AP.Visible = true; EP.Visible = false; RP.Visible = false; _G.tA.TextColor3 = Color3.fromRGB(120, 130, 230); _G.tE.TextColor3 = Color3.fromRGB(150, 150, 150); _G.tR.TextColor3 = Color3.fromRGB(150, 150, 150) end)
_G.tE.MouseButton1Click:Connect(function() AP.Visible = false; EP.Visible = true; RP.Visible = false; _G.tA.TextColor3 = Color3.fromRGB(150, 150, 150); _G.tE.TextColor3 = Color3.fromRGB(120, 130, 230); _G.tR.TextColor3 = Color3.fromRGB(150, 150, 150) end)
_G.tR.MouseButton1Click:Connect(function() AP.Visible = false; EP.Visible = false; RP.Visible = true; _G.tA.TextColor3 = Color3.fromRGB(150, 150, 150); _G.tE.TextColor3 = Color3.fromRGB(150, 150, 150); _G.tR.TextColor3 = Color3.fromRGB(120, 130, 230) end)

local aC = Instance.new("TextButton") aC.Size = UDim2.new(0, 14, 0, 14) aC.Position = UDim2.new(0, 15, 0, 25) aC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) aC.Text = "" aC.Parent = AP
local aL = Instance.new("TextLabel") aL.Size = UDim2.new(0, 250, 0, 14) aL.Position = UDim2.new(0, 40, 0, 25) aL.BackgroundTransparency = 1 aL.Text = "Enable Aimbot" aL.TextColor3 = Color3.fromRGB(220, 220, 220) aL.TextXAlignment = Enum.TextXAlignment.Left aL.Font = Enum.Font.SourceSans aL.Parent = AP
aC.MouseButton1Click:Connect(function() _G.AimEnabled = not _G.AimEnabled; aC.BackgroundColor3 = _G.AimEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) if _G.FovCircle then _G.FovCircle.Visible = (_G.AimEnabled and _G.LirpSG.Enabled) end end)

local awC = Instance.new("TextButton") awC.Size = UDim2.new(0, 14, 0, 14) awC.Position = UDim2.new(0, 15, 0, 55) awC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) awC.Text = "" awC.Parent = AP
local awL = Instance.new("TextLabel") awL.Size = UDim2.new(0, 250, 0, 14) awL.Position = UDim2.new(0, 40, 0, 55) awL.BackgroundTransparency = 1 awL.Text = "Aimbot Wall Check" awL.TextColor3 = Color3.fromRGB(220, 220, 220) awL.TextXAlignment = Enum.TextXAlignment.Left awL.Font = Enum.Font.SourceSans awL.Parent = AP
awC.MouseButton1Click:Connect(function() _G.AimWallCheck = not _G.AimWallCheck; awC.BackgroundColor3 = _G.AimWallCheck and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local tC = Instance.new("TextButton") tC.Size = UDim2.new(0, 14, 0, 14) tC.Position = UDim2.new(0, 15, 0, 85) tC.BackgroundColor3 = Color3.fromRGB(30,30,35) tC.Text = "" tC.Parent = AP
local tL = Instance.new("TextLabel") tL.Size = UDim2.new(0, 250, 0, 14) tL.Position = UDim2.new(0, 40, 0, 85) tL.BackgroundTransparency = 1 tL.Text = "Enable Instant Triggerbot" tL.TextColor3 = Color3.fromRGB(220, 220, 220) tL.TextXAlignment = Enum.TextXAlignment.Left tL.Font = Enum.Font.SourceSans tL.Parent = AP
tC.MouseButton1Click:Connect(function() _G.TriggerEnabled = not _G.TriggerEnabled; tC.BackgroundColor3 = _G.TriggerEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local fovLabel = Instance.new("TextLabel") fovLabel.Size = UDim2.new(0, 200, 0, 20) fovLabel.Position = UDim2.new(0, 15, 0, 115) fovLabel.BackgroundTransparency = 1 fovLabel.Text = "Aim FOV Radius: " .. tostring(_G.LirpFOV) fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200) fovLabel.TextXAlignment = Enum.TextXAlignment.Left fovLabel.Font = Enum.Font.SourceSans fovLabel.Parent = AP
local btnPlus = Instance.new("TextButton") btnPlus.Size = UDim2.new(0, 40, 0, 25) btnPlus.Position = UDim2.new(0, 15, 0, 140) btnPlus.BackgroundColor3 = Color3.fromRGB(35, 35, 40) btnPlus.Text = "[+]" btnPlus.TextColor3 = Color3.fromRGB(255, 255, 255) btnPlus.Font = Enum.Font.SourceSansBold btnPlus.Parent = AP
local btnMinus = Instance.new("TextButton") btnMinus.Size = UDim2.new(0, 40, 0, 25) btnMinus.Position = UDim2.new(0, 65, 0, 140) btnMinus.BackgroundColor3 = Color3.fromRGB(35, 35, 40) btnMinus.Text = "[-]" btnMinus.TextColor3 = Color3.fromRGB(255, 255, 255) btnMinus.Font = Enum.Font.SourceSansBold btnMinus.Parent = AP
btnPlus.MouseButton1Click:Connect(function() _G.LirpFOV = math.min(_G.LirpFOV + 20, 600) fovLabel.Text = "Aim FOV Radius: " .. tostring(_G.LirpFOV) end)
btnMinus.MouseButton1Click:Connect(function() _G.LirpFOV = math.max(_G.LirpFOV - 20, 40) fovLabel.Text = "Aim FOV Radius: " .. tostring(_G.LirpFOV) end)

local cC = Instance.new("TextButton") cC.Size = UDim2.new(0, 14, 0, 14) cC.Position = UDim2.new(0, 15, 0, 30) cC.BackgroundColor3 = Color3.fromRGB(65, 80, 220) cC.Text = "" cC.Parent = EP
local cL = Instance.new("TextLabel") cL.Size = UDim2.new(0, 250, 0, 14) cL.Position = UDim2.new(0, 40, 0, 30) cL.BackgroundTransparency = 1 cL.Text = "Enable Chams Visuals" cL.TextColor3 = Color3.fromRGB(220, 220, 220) cL.TextXAlignment = Enum.TextXAlignment.Left cL.Font = Enum.Font.SourceSans cL.Parent = EP
cC.MouseButton1Click:Connect(function() _G.ChamsEnabled = not _G.ChamsEnabled; if not _G.ChamsEnabled then cC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) if _G.PurgeLirp then _G.PurgeLirp() end else cC.BackgroundColor3 = Color3.fromRGB(65, 80, 220) _G.ScriptRunning = true _G.ChamsEnabled = true end end)

local saC = Instance.new("TextButton") saC.Size = UDim2.new(0, 14, 0, 14) saC.Position = UDim2.new(0, 15, 0, 25) saC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) saC.Text = "" saC.Parent = RP
local saL = Instance.new("TextLabel") saL.Size = UDim2.new(0, 250, 0, 14) saL.Position = UDim2.new(0, 40, 0, 25) saL.BackgroundTransparency = 1 saL.Text = "Enable Silent Aimbot (Rage)" saL.TextColor3 = Color3.fromRGB(220, 220, 220) saL.TextXAlignment = Enum.TextXAlignment.Left saL.Font = Enum.Font.SourceSans saL.Parent = RP
saC.MouseButton1Click:Connect(function() _G.SilentAimEnabled = not _G.SilentAimEnabled saC.BackgroundColor3 = _G.SilentAimEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local rC = Instance.new("TextButton") rC.Size = UDim2.new(0, 14, 0, 14) rC.Position = UDim2.new(0, 15, 0, 60) rC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) rC.Text = "" rC.Parent = RP
local rL = Instance.new("TextLabel") rL.Size = UDim2.new(0, 250, 0, 14) rL.Position = UDim2.new(0, 40, 0, 60) rL.BackgroundTransparency = 1 rL.Text = "Enable Anti-Aim (Spin)" rL.TextColor3 = Color3.fromRGB(220, 220, 220) rL.TextXAlignment = Enum.TextXAlignment.Left rL.Font = Enum.Font.SourceSans rL.Parent = RP
rC.MouseButton1Click:Connect(function() _G.AntiAimEnabled = not _G.AntiAimEnabled rC.BackgroundColor3 = _G.AntiAimEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local UB = Instance.new("TextButton") UB.Size = UDim2.new(0, 180, 0, 30) UB.Position = UDim2.new(0, 55, 1, -40) UB.BackgroundColor3 = Color3.fromRGB(25, 25, 30) UB.BorderSizePixel = 1 UB.BorderColor3 = Color3.fromRGB(40, 40, 50) UB.Text = "Unload Lirp Hub" UB.TextColor3 = Color3.fromRGB(160, 160, 160) UB.Font = Enum.Font.SourceSans UB.Parent = _G.MF

_G.KB.MouseButton1Click:Connect(function()
    if _G.KI.Text == _G.CorrectKey then _G.KF:Destroy(); _G.MF.Visible = true; _G.ScriptRunning = true; print("[Xeno]: Access Granted!")
    else _G.KI.Text = ""; _G.KI.PlaceholderText = "WRONG KEY! TRY AGAIN." end
end)

local tConn tConn = UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift and _G.ScriptRunning then _G.LirpSG.Enabled = not _G.LirpSG.Enabled if _G.FovCircle then _G.FovCircle.Visible = ((_G.AimEnabled or _G.SilentAimEnabled) and _G.LirpSG.Enabled) end end
end)

UB.MouseButton1Click:Connect(function()
    if _G.PurgeLirp then _G.PurgeLirp() end if _G.VisualConnection then _G.VisualConnection:Disconnect() end if _G.AimConnection then _G.AimConnection:Disconnect() end if _G.TriggerConnection then _G.TriggerConnection:Disconnect() end if tConn then tConn:Disconnect() end task.wait(0.05) _G.LirpSG:Destroy() print("[Xeno]: Lirp Hub unloaded!")
end)

print("=========================================")
print("[Xeno System]: Waiting for key...")
print("=========================================")
