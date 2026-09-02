_G.ScriptRunning = true
_G.ChamsEnabled = true
_G.TriggerEnabled = false
_G.AimEnabled = false
_G.AimWallCheck = false
_G.LirpFOV = 120
_G.ActiveHighlights = {}

local Cam = workspace.CurrentCamera
_G.FovCircle = Drawing.new("Circle")
_G.FovCircle.Color = Color3.fromRGB(140, 0, 255)
_G.FovCircle.Thickness = 1
_G.FovCircle.NumSides = 64
_G.FovCircle.Filled = false
_G.FovCircle.Transparency = 0.6
_G.FovCircle.Visible = false

_G.IsVisibleCheck = function(character)
    if not character or not character:FindFirstChild("Head") then return false end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {game:GetService("Players").LocalPlayer.Character, character}
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
    if _G.FovCircle then _G.FovCircle.Visible = false end
    for _, h in ipairs(_G.ActiveHighlights) do if h and h.Parent then pcall(function() h:Destroy() end) end end 
    table.clear(_G.ActiveHighlights)
    for _, o in ipairs(game:GetDescendants()) do if o:IsA("Highlight") and o.Name == "Lirp_Highlight" then pcall(function() o:Destroy() end) end end 
end
print("[Xeno System]: Part 1 Safe Config Loaded.")
local P = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
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
    if _G.AimEnabled and _G.FovCircle then _G.FovCircle.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2) _G.FovCircle.Radius = _G.LirpFOV end 
    if _G.AimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then 
        local targetHead = _G.GetClosestPlayer()
        if targetHead and (not _G.AimWallCheck or _G.IsVisibleCheck(targetHead.Parent)) then Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, targetHead.Position), 0.12) end 
    end 
    if _G.TriggerEnabled then 
        local rp = RaycastParams.new() rp.FilterDescendantsInstances = {LP.Character} rp.FilterType = Enum.RaycastFilterType.Exclude 
        local res = workspace:Raycast(Cam.CFrame.Position, Cam.CFrame.LookVector * 1500, rp)
        if res and res.Instance then 
            local ch = res.Instance.Parent if ch and not ch:FindFirstChildOfClass("Humanoid") then ch = res.Instance.Parent.Parent end 
            if ch and ch ~= LP.Character and ch:FindFirstChildOfClass("Humanoid") and ch:FindFirstChildOfClass("Humanoid").Health > 0 then 
                pcall(function() VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0) task.wait(0.01) VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0) end)
            end 
        end 
    end 
end)
print("[Xeno System]: Part 2 Combat Loops Active.")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

_G.LirpSG = Instance.new("ScreenGui") _G.LirpSG.Name = "LirpHub_LegitMenu" _G.LirpSG.ResetOnSpawn = false
pcall(function() _G.LirpSG.Parent = CG end) if not _G.LirpSG.Parent then _G.LirpSG.Parent = LP:WaitForChild("PlayerGui") end

local MF = Instance.new("Frame") MF.Size = UDim2.new(0, 560, 0, 380) MF.Position = UDim2.new(0.3, 0, 0.25, 0) MF.BackgroundColor3 = Color3.fromRGB(12, 12, 14) MF.BorderSizePixel = 1 MF.BorderColor3 = Color3.fromRGB(35, 35, 45) MF.Active = true MF.Draggable = true MF.Parent = _G.LirpSG
local SB = Instance.new("Frame") SB.Size = UDim2.new(0, 45, 1, 0) SB.BackgroundColor3 = Color3.fromRGB(8, 8, 10) SB.Parent = MF
local BL = Instance.new("Frame") BL.Size = UDim2.new(1, 0, 0, 2) BL.BackgroundColor3 = Color3.fromRGB(65, 80, 220) BL.Parent = MF
local TB = Instance.new("Frame") TB.Size = UDim2.new(1,-45,0,30) TB.Position = UDim2.new(0, 45, 0, 2) TB.BackgroundColor3 = Color3.fromRGB(15, 15, 18) TB.Parent = MF

local tA = Instance.new("TextButton") tA.Size = UDim2.new(0, 80, 1, 0) tA.Position = UDim2.new(0, 20, 0, 0) tA.BackgroundTransparency = 1 tA.Text = "Legit" tA.TextColor3 = Color3.fromRGB(120, 130, 230) tA.Font = Enum.Font.SourceSansBold tA.Parent = TB
local tE = Instance.new("TextButton") tE.Size = UDim2.new(0, 80, 1, 0) tE.Position = UDim2.new(0, 110, 0, 0) tE.BackgroundTransparency = 1 tE.Text = "ESP" tE.TextColor3 = Color3.fromRGB(150, 150, 150) tE.Font = Enum.Font.SourceSansBold tE.Parent = TB

local AP = Instance.new("Frame") AP.Size = UDim2.new(1, -65, 1, -50) AP.Position = UDim2.new(0, 55, 0, 40) AP.BackgroundTransparency = 1 AP.Visible = true AP.Parent = MF
local EP = Instance.new("Frame") EP.Size = UDim2.new(1, -65, 1, -50) EP.Position = UDim2.new(0, 55, 0, 40) EP.BackgroundTransparency = 1 EP.Visible = false EP.Parent = MF

tA.MouseButton1Click:Connect(function() AP.Visible = true; EP.Visible = false; tA.TextColor3 = Color3.fromRGB(120, 130, 230); tE.TextColor3 = Color3.fromRGB(150, 150, 150) end)
tE.MouseButton1Click:Connect(function() AP.Visible = false; EP.Visible = true; tA.TextColor3 = Color3.fromRGB(150, 150, 150); tE.TextColor3 = Color3.fromRGB(120, 130, 230) end)

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
cC.MouseButton1Click:Connect(function() _G.ChamsEnabled = not _G.ChamsEnabled; if not _G.ChamsEnabled then cC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) _G.PurgeLirp() else cC.BackgroundColor3 = Color3.fromRGB(65, 80, 220) _G.ChamsEnabled = true end end)

local UB = Instance.new("TextButton") UB.Size = UDim2.new(0, 180, 0, 30) UB.Position = UDim2.new(0, 55, 1, -40) UB.BackgroundColor3 = Color3.fromRGB(25, 25, 30) UB.BorderSizePixel = 1 UB.BorderColor3 = Color3.fromRGB(40, 40, 50) UB.Text = "Unload Lirp Hub" UB.TextColor3 = Color3.fromRGB(160, 160, 160) UB.Font = Enum.Font.SourceSans UB.Parent = MF

local tConn tConn = UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then _G.LirpSG.Enabled = not _G.LirpSG.Enabled if _G.FovCircle then _G.FovCircle.Visible = (_G.AimEnabled and _G.LirpSG.Enabled) end end
end)

UB.MouseButton1Click:Connect(function()
    _G.PurgeLirp() if _G.VisualConnection then _G.VisualConnection:Disconnect() end if tConn then tConn:Disconnect() end task.wait(0.05) _G.LirpSG:Destroy() print("[Xeno]: Lirp Hub unloaded!")
end)
print("=========================================\n[Xeno System]: Legit Version 100% Active!\n=========================================")
