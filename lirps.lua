_G.ScriptRunning = true
_G.ChamsEnabled = true
_G.TriggerEnabled = false
_G.AimEnabled = false
_G.AimWallCheck = false
_G.SilentAimEnabled = false
_G.AntiAimEnabled = false
_G.LirpFOV = 120
_G.ActiveHighlights = {}
_G.OldCamCFrame = nil

print("[Xeno PC]: Part 1 Protected Config Loaded.")
local P = game:GetService("Players")
local LP = P:GetPlayers() and game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera

_G.IsVisibleCheck = function(character)
    if not character or not character:FindFirstChild("Head") then return false end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {game:GetService("Players").LocalPlayer.Character, character}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local res = workspace:Raycast(Cam.CFrame.Position, (character.Head.Position - Cam.CFrame.Position), rp)
    return res == nil
end
print("[Xeno PC]: Part 2 Visibility System Loaded.")
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
local Mouse = LP:GetMouse()

_G.GetClosestPlayer = function()
    local closest = nil
    local shortestDist = _G.LirpFOV 
    for _, p in ipairs(P:GetPlayers()) do 
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then 
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then 
                local pos, onScreen = Cam:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then 
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude 
                    if dist < shortestDist then shortestDist = dist closest = p.Character.Head end 
                end 
            end 
        end 
    end 
    return closest 
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
local CG = game:GetService("CoreGui")
local LP = game:GetService("Players").LocalPlayer

_G.LirpSG = Instance.new("ScreenGui") _G.LirpSG.Name = "LirpHub_PC_Layout" _G.LirpSG.ResetOnSpawn = false
pcall(function() _G.LirpSG.Parent = CG end) if not _G.LirpSG.Parent then _G.LirpSG.Parent = LP:WaitForChild("PlayerGui") end

_G.FovGuiCircle = Instance.new("Frame") _G.FovGuiCircle.Name = "Lirp_FOV" _G.FovGuiCircle.BackgroundTransparency = 0.85 _G.FovGuiCircle.BackgroundColor3 = Color3.fromRGB(140, 0, 255) _G.FovGuiCircle.BorderSizePixel = 0 _G.FovGuiCircle.Visible = false _G.FovGuiCircle.Parent = _G.LirpSG
local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(1, 0) UICorner.Parent = _G.FovGuiCircle

_G.MF = Instance.new("Frame") _G.MF.Size = UDim2.new(0, 560, 0, 380) _G.MF.Position = UDim2.new(0.3, 0, 0.25, 0) _G.MF.BackgroundColor3 = Color3.fromRGB(12, 12, 14) _G.MF.BorderSizePixel = 1 _G.MF.BorderColor3 = Color3.fromRGB(35, 35, 45) _G.MF.Active = true _G.MF.Draggable = true _G.MF.Parent = _G.LirpSG
_G.SB = Instance.new("Frame") _G.SB.Size = UDim2.new(0, 45, 1, 0) _G.SB.BackgroundColor3 = Color3.fromRGB(8, 8, 10) _G.SB.Parent = _G.MF
_G.BL = Instance.new("Frame") _G.BL.Size = UDim2.new(1, 0, 0, 2) _G.BL.BackgroundColor3 = Color3.fromRGB(65, 80, 220) _G.BL.Parent = _G.MF
_G.LirpTB = Instance.new("Frame") _G.LirpTB.Size = UDim2.new(1,-45,0,30) _G.LirpTB.Position = UDim2.new(0, 45, 0, 2) _G.LirpTB.BackgroundColor3 = Color3.fromRGB(15, 15, 18) _G.LirpTB.Parent = _G.MF
print("[Xeno PC]: Part 6 Frame Construction Ready.")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera

local tA = Instance.new("TextButton") tA.Size = UDim2.new(0, 80, 1, 0) tA.Position = UDim2.new(0, 20, 0, 0) tA.BackgroundTransparency = 1 tA.Text = "Legit" tA.TextColor3 = Color3.fromRGB(120, 130, 230) tA.Font = Enum.Font.SourceSansBold tA.Parent = _G.LirpTB
local tE = Instance.new("TextButton") tE.Size = UDim2.new(0, 80, 1, 0) tE.Position = UDim2.new(0, 110, 0, 0) tE.BackgroundTransparency = 1 tE.Text = "ESP" tE.TextColor3 = Color3.fromRGB(150, 150, 150) tE.Font = Enum.Font.SourceSansBold tE.Parent = _G.LirpTB
local tR = Instance.new("TextButton") tR.Size = UDim2.new(0, 80, 1, 0) tR.Position = UDim2.new(0, 200, 0, 0) tR.BackgroundTransparency = 1 tR.Text = "Rage" tR.TextColor3 = Color3.fromRGB(150, 150, 150) tR.Font = Enum.Font.SourceSansBold tR.Parent = _G.LirpTB

local AP = Instance.new("Frame") AP.Size = UDim2.new(1, -65, 1, -50) AP.Position = UDim2.new(0, 55, 0, 40) AP.BackgroundTransparency = 1 AP.Visible = true AP.Parent = _G.MF
local EP = Instance.new("Frame") EP.Size = UDim2.new(1, -65, 1, -50) EP.Position = UDim2.new(0, 55, 0, 40) EP.BackgroundTransparency = 1 EP.Visible = false EP.Parent = _G.MF
local RP = Instance.new("Frame") RP.Size = UDim2.new(1, -65, 1, -50) RP.Position = UDim2.new(0, 55, 0, 40) RP.BackgroundTransparency = 1 RP.Visible = false RP.Parent = _G.MF

tA.MouseButton1Click:Connect(function() AP.Visible = true; EP.Visible = false; RP.Visible = false; tA.TextColor3 = Color3.fromRGB(120, 130, 230); tE.TextColor3 = Color3.fromRGB(150, 150, 150); tR.TextColor3 = Color3.fromRGB(150, 150, 150) end)
tE.MouseButton1Click:Connect(function() AP.Visible = false; EP.Visible = true; RP.Visible = false; tA.TextColor3 = Color3.fromRGB(150, 150, 150); tE.TextColor3 = Color3.fromRGB(120, 130, 230); tR.TextColor3 = Color3.fromRGB(150, 150, 150) end)
tR.MouseButton1Click:Connect(function() AP.Visible = false; EP.Visible = false; RP.Visible = true; tA.TextColor3 = Color3.fromRGB(150, 150, 150); tE.TextColor3 = Color3.fromRGB(150, 150, 150); tR.TextColor3 = Color3.fromRGB(120, 130, 230) end)

local aC = Instance.new("TextButton") aC.Size = UDim2.new(0, 14, 0, 14) aC.Position = UDim2.new(0, 15, 0, 25) aC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) aC.Text = "" aC.Parent = AP
local aL = Instance.new("TextLabel") aL.Size = UDim2.new(0, 250, 0, 14) aL.Position = UDim2.new(0, 40, 0, 25) aL.BackgroundTransparency = 1 aL.Text = "Enable Aimbot" aL.TextColor3 = Color3.fromRGB(220, 220, 220) aL.TextXAlignment = Enum.TextXAlignment.Left aL.Font = Enum.Font.SourceSans aL.Parent = AP
aC.MouseButton1Click:Connect(function() _G.AimEnabled = not _G.AimEnabled; aC.BackgroundColor3 = _G.AimEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)
print("[Xeno PC]: Part 7.1 Tabs Synchronized.")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera

local awC = Instance.new("TextButton") awC.Size = UDim2.new(0, 14, 0, 14) awC.Position = UDim2.new(0, 15, 0, 55) awC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) awC.Text = "" awC.Parent = _G.AP
local awL = Instance.new("TextLabel") awL.Size = UDim2.new(0, 250, 0, 14) awL.Position = UDim2.new(0, 40, 0, 55) awL.BackgroundTransparency = 1 awL.Text = "Aimbot Wall Check" awL.TextColor3 = Color3.fromRGB(220, 220, 220) awL.TextXAlignment = Enum.TextXAlignment.Left awL.Font = Enum.Font.SourceSans awL.Parent = _G.AP
awC.MouseButton1Click:Connect(function() _G.AimWallCheck = not _G.AimWallCheck; awC.BackgroundColor3 = _G.AimWallCheck and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local tC = Instance.new("TextButton") tC.Size = UDim2.new(0, 14, 0, 14) tC.Position = UDim2.new(0, 15, 0, 85) tC.BackgroundColor3 = Color3.fromRGB(30,30,35) tC.Text = "" tC.Parent = _G.AP
local tL = Instance.new("TextLabel") tL.Size = UDim2.new(0, 250, 0, 14) tL.Position = UDim2.new(0, 40, 0, 85) tL.BackgroundTransparency = 1 tL.Text = "Enable Instant Triggerbot" tL.TextColor3 = Color3.fromRGB(220, 220, 220) tL.TextXAlignment = Enum.TextXAlignment.Left tL.Font = Enum.Font.SourceSans tL.Parent = _G.AP
tC.MouseButton1Click:Connect(function() _G.TriggerEnabled = not _G.TriggerEnabled; tC.BackgroundColor3 = _G.TriggerEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local fovLabel = Instance.new("TextLabel") fovLabel.Size = UDim2.new(0, 200, 0, 20) fovLabel.Position = UDim2.new(0, 15, 0, 115) fovLabel.BackgroundTransparency = 1 fovLabel.Text = "Aim FOV Radius: " .. tostring(_G.LirpFOV) fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200) fovLabel.TextXAlignment = Enum.TextXAlignment.Left fovLabel.Font = Enum.Font.SourceSans fovLabel.Parent = _G.AP
local btnPlus = Instance.new("TextButton") btnPlus.Size = UDim2.new(0, 40, 0, 25) btnPlus.Position = UDim2.new(0, 15, 0, 140) btnPlus.BackgroundColor3 = Color3.fromRGB(35, 35, 40) btnPlus.Text = "[+]" btnPlus.TextColor3 = Color3.fromRGB(255, 255, 255) btnPlus.Font = Enum.Font.SourceSansBold btnPlus.Parent = _G.AP
local btnMinus = Instance.new("TextButton") btnMinus.Size = UDim2.new(0, 40, 0, 25) btnMinus.Position = UDim2.new(0, 65, 0, 140) btnMinus.BackgroundColor3 = Color3.fromRGB(35, 35, 40) btnMinus.Text = "[-]" btnMinus.TextColor3 = Color3.fromRGB(255, 255, 255) btnMinus.Font = Enum.Font.SourceSansBold btnMinus.Parent = _G.AP
btnPlus.MouseButton1Click:Connect(function() _G.LirpFOV = math.min(_G.LirpFOV + 20, 600) fovLabel.Text = "Aim FOV Radius: " .. tostring(_G.LirpFOV) end)
btnMinus.MouseButton1Click:Connect(function() _G.LirpFOV = math.max(_G.LirpFOV - 20, 40) fovLabel.Text = "Aim FOV Radius: " .. tostring(_G.LirpFOV) end)

local cC = Instance.new("TextButton") cC.Size = UDim2.new(0, 14, 0, 14) cC.Position = UDim2.new(0, 15, 0, 30) cC.BackgroundColor3 = Color3.fromRGB(65, 80, 220) cC.Text = "" cC.Parent = _G.EP
local cL = Instance.new("TextLabel") cL.Size = UDim2.new(0, 250, 0, 14) cL.Position = UDim2.new(0, 40, 0, 30) cL.BackgroundTransparency = 1 cL.Text = "Enable Chams Visuals" cL.TextColor3 = Color3.fromRGB(220, 220, 220) cL.TextXAlignment = Enum.TextXAlignment.Left cL.Font = Enum.Font.SourceSans cL.Parent = _G.EP
cC.MouseButton1Click:Connect(function() _G.ChamsEnabled = not _G.ChamsEnabled; cC.BackgroundColor3 = _G.ChamsEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) if not _G.ChamsEnabled then _G.PurgeLirp() end end)
print("[Xeno PC]: Part 7.2 Submenus Operational.")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera

local saC = Instance.new("TextButton") saC.Size = UDim2.new(0, 14, 0, 14) saC.Position = UDim2.new(0, 15, 0, 25) saC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) saC.Text = "" saC.Parent = _G.RP
local saL = Instance.new("TextLabel") saL.Size = UDim2.new(0, 250, 0, 14) saL.Position = UDim2.new(0, 40, 0, 25) saL.BackgroundTransparency = 1 saL.Text = "Enable Silent Aimbot (Rage)" saL.TextColor3 = Color3.fromRGB(220, 220, 220) saL.TextXAlignment = Enum.TextXAlignment.Left saL.Font = Enum.Font.SourceSans saL.Parent = _G.RP
saC.MouseButton1Click:Connect(function() _G.SilentAimEnabled = not _G.SilentAimEnabled saC.BackgroundColor3 = _G.SilentAimEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local rC = Instance.new("TextButton") rC.Size = UDim2.new(0, 14, 0, 14) rC.Position = UDim2.new(0, 15, 0, 60) rC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) rC.Text = "" rC.Parent = _G.RP
local rL = Instance.new("TextLabel") rL.Size = UDim2.new(0, 250, 0, 14) rL.Position = UDim2.new(0, 40, 0, 60) rL.BackgroundTransparency = 1 rL.Text = "Enable Anti-Aim (Spin)" rL.TextColor3 = Color3.fromRGB(220, 220, 220) rL.TextXAlignment = Enum.TextXAlignment.Left rL.Font = Enum.Font.SourceSans rL.Parent = _G.RP
rC.MouseButton1Click:Connect(function() _G.AntiAimEnabled = not _G.AntiAimEnabled rC.BackgroundColor3 = _G.AntiAimEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local UB = Instance.new("TextButton") UB.Size = UDim2.new(0, 180, 0, 30) UB.Position = UDim2.new(0, 55, 1, -40) UB.BackgroundColor3 = Color3.fromRGB(25, 25, 30) UB.BorderSizePixel = 1 UB.BorderColor3 = Color3.fromRGB(40, 40, 50) UB.Text = "Unload Lirp Hub" UB.TextColor3 = Color3.fromRGB(160, 160, 160) UB.Font = Enum.Font.SourceSans UB.Parent = _G.MF

_G.CombatConnection = RS.RenderStepped:Connect(function()
    if not _G.ScriptRunning then return end
    if (_G.AimEnabled or _G.SilentAimEnabled) and _G.FovGuiCircle then 
        _G.FovGuiCircle.Visible = true _G.FovGuiCircle.Size = UDim2.new(0, _G.LirpFOV * 2, 0, _G.LirpFOV * 2) _G.FovGuiCircle.Position = UDim2.new(0.5, -_G.LirpFOV, 0.5, -_G.LirpFOV)
    else if _G.FovGuiCircle then _G.FovGuiCircle.Visible = false end end 
    if _G.AimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then 
        local target = _G.GetClosestPlayer()
        if target and (not _G.AimWallCheck or _G.IsVisibleCheck(target.Parent)) then Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, target.Position), 0.12) end 
    end 
    if _G.SilentAimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target = _G.GetClosestPlayer()
        if target then _G.OldCamCFrame = Cam.CFrame Cam.CFrame = CFrame.new(Cam.CFrame.Position, target.Position) task.wait() if _G.OldCamCFrame then Cam.CFrame = _G.OldCamCFrame end end
    end
    if _G.AntiAimEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local char = LP.Character local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.AutoRotate = false end
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(65), 0)
    else if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then LP.Character:FindFirstChildOfClass("Humanoid").AutoRotate = true end end
    if _G.TriggerEnabled then 
        local rp = RaycastParams.new() rp.FilterDescendantsInstances = {LP.Character} rp.FilterType = Enum.RaycastFilterType.Exclude 
        local res = workspace:Raycast(Cam.CFrame.Position, Cam.CFrame.LookVector * 1500, rp)
        if res and res.Instance then 
            local ch = res.Instance.Parent if ch and not ch:FindFirstChildOfClass("Humanoid") then ch = res.Instance.Parent.Parent end 
            if ch and ch ~= LP.Character and ch:FindFirstChildOfClass("Humanoid") and ch:FindFirstChildOfClass("Humanoid").Health > 0 then mouse1click() end 
        end 
    end 
end)

local tConn tConn = UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then _G.LirpSG.Enabled = not _G.LirpSG.Enabled if _G.FovGuiCircle then _G.FovGuiCircle.Visible = ((_G.AimEnabled or _G.SilentAimEnabled) and _G.LirpSG.Enabled) end end
end)

UB.MouseButton1Click:Connect(function()
    _G.PurgeLirp() if _G.VisualConnection then _G.VisualConnection:Disconnect() end if _G.CombatConnection then _G.CombatConnection:Disconnect() end if tConn then tConn:Disconnect() end task.wait(0.05) _G.LirpSG:Destroy() print("[Xeno PC]: Lirp Hub unloaded!")
end)
print("=========================================\n[Xeno PC]: Menu Loaded Automatically!\n=========================================")
