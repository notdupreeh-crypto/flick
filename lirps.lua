_G.ScriptRunning = false
_G.ChamsEnabled = true
_G.WallCheckEnabled = false
_G.TriggerEnabled = false
_G.AimEnabled = false
_G.LirpFOV = 120
_G.CorrectKey = "LIRP-2026-FLICK"

local P = game:GetService("Players")
local LP = P.LocalPlayer
local Cam = workspace.CurrentCamera
_G.ActiveHighlights = {}

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
    if _G.FovCircle then _G.FovCircle.Visible = false end
    for _, h in ipairs(_G.ActiveHighlights) do 
        if h and h.Parent then pcall(function() h:Destroy() end) end 
    end 
    table.clear(_G.ActiveHighlights)
    for _, o in ipairs(game:GetDescendants()) do 
        if o:IsA("Highlight") and o.Name == "Lirp_Highlight" then pcall(function() o:Destroy() end) end 
    end 
end
print("[Xeno System]: Engine Variables Loaded.")
local P = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = P.LocalPlayer
local M = LP:GetMouse()
local Cam = workspace.CurrentCamera

local function getClosest()
    local closest, shortestDist = nil, _G.LirpFOV 
    for _, p in ipairs(P:GetPlayers()) do 
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then 
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then 
                local pos, onScreen = Cam:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then 
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(M.X, M.Y)).Magnitude 
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
        for _, p in ipairs(P:GetPlayers()) do 
            if p.Character and p ~= LP then 
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then
                    local canSee = not _G.WallCheckEnabled or _G.IsVisibleCheck(p.Character)
                    local hl = p.Character:FindFirstChild("Lirp_Highlight")
                    if canSee then
                        if not hl then 
                            hl = Instance.new("Highlight") hl.Name = "Lirp_Highlight" hl.FillTransparency = 0.45 
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.OutlineTransparency = 0.1 
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop hl.Parent = p.Character table.insert(_G.ActiveHighlights, hl) 
                        end 
                        hl.FillColor = Color3.fromRGB(255, 0, 50)
                    else if hl then hl:Destroy() end end
                end
            end 
        end 
    else _G.PurgeLirp() end 
    if _G.AimEnabled and _G.FovCircle then 
        _G.FovCircle.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
        _G.FovCircle.Radius = _G.LirpFOV 
    end 
    if _G.AimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then 
        local targetHead = getClosest()
        if targetHead then Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, targetHead.Position), 0.15) end 
    end 
    if _G.TriggerEnabled then 
        local rp = RaycastParams.new() rp.FilterDescendantsInstances = {LP.Character} rp.FilterType = Enum.RaycastFilterType.Exclude 
        local res = workspace:Raycast(Cam.CFrame.Position, Cam.CFrame.LookVector * 1500, rp)
        if res and res.Instance then 
            local ch = res.Instance.Parent if ch and not ch:FindFirstChildOfClass("Humanoid") then ch = res.Instance.Parent.Parent end 
            if ch and ch ~= LP.Character then 
                local hum = ch:FindFirstChildOfClass("Humanoid") if hum and hum.Health > 0 then mouse1click() end 
            end 
        end 
    end 
end)
print("[Xeno System]: Logic Loops Activated.")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LirpHub_System"
ScreenGui.ResetOnSpawn = false 
pcall(function() ScreenGui.Parent = CG end)
if not ScreenGui.Parent then ScreenGui.Parent = LP:WaitForChild("PlayerGui") end 

local KF = Instance.new("Frame") KF.Size = UDim2.new(0, 300, 0, 150) KF.Position = UDim2.new(0.4, 0, 0.4, 0) KF.BackgroundColor3 = Color3.fromRGB(15, 15, 18) KF.BorderSizePixel = 1 KF.BorderColor3 = Color3.fromRGB(140, 0, 255) KF.Active = true KF.Draggable = true KF.Parent = ScreenGui
local KT = Instance.new("TextLabel") KT.Size = UDim2.new(1, 0, 0, 30) KT.BackgroundTransparency = 1 KT.Text = "LIRP HUB - Enter Key" KT.TextColor3 = Color3.fromRGB(255, 255, 255) KT.TextSize = 14 KT.Font = Enum.Font.SourceSansBold KT.Parent = KF
local KI = Instance.new("TextBox") KI.Size = UDim2.new(0, 240, 0, 30) KI.Position = UDim2.new(0, 30, 0, 50) KI.BackgroundColor3 = Color3.fromRGB(25, 25, 30) KI.TextColor3 = Color3.fromRGB(140, 0, 255) KI.Text = "" KI.PlaceholderText = "Paste Key Here..." KI.TextSize = 14 KI.Parent = KF
local KB = Instance.new("TextButton") KB.Size = UDim2.new(0, 100, 0, 30) KB.Position = UDim2.new(0, 100, 0, 100) KB.BackgroundColor3 = Color3.fromRGB(140, 0, 255) KB.Text = "Verify" KB.TextColor3 = Color3.fromRGB(255, 255, 255) KB.Font = Enum.Font.SourceSansBold KB.Parent = KF

local MainFrame = Instance.new("Frame") MainFrame.Size = UDim2.new(0, 560, 0, 380) MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0) MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14) MainFrame.BorderSizePixel = 1 MainFrame.BorderColor3 = Color3.fromRGB(35, 35, 45) MainFrame.Active = true MainFrame.Draggable = true MainFrame.Visible = false MainFrame.Parent = ScreenGui 
local Sidebar = Instance.new("Frame") Sidebar.Size = UDim2.new(0, 45, 1, 0) Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10) Sidebar.BorderSizePixel = 0 Sidebar.Parent = MainFrame 
local BlueLine = Instance.new("Frame") BlueLine.Size = UDim2.new(1, 0, 0, 2) BlueLine.BackgroundColor3 = Color3.fromRGB(65, 80, 220) BlueLine.BorderSizePixel = 0 BlueLine.Parent = MainFrame 
local TB = Instance.new("Frame") TB.Size = UDim2.new(1,-45,0,30) TB.Position = UDim2.new(0, 45, 0, 2) TB.BackgroundColor3 = Color3.fromRGB(15, 15, 18) TB.BorderSizePixel = 0 TB.Parent = MainFrame 

local tA = Instance.new("TextButton") tA.Size = UDim2.new(0, 100, 1, 0) tA.Position = UDim2.new(0, 20, 0, 0) tA.BackgroundTransparency = 1 tA.Text = "Aimbot" tA.TextColor3 = Color3.fromRGB(150, 150, 150) tA.TextSize = 14 tA.Font = Enum.Font.SourceSansBold tA.Parent = TB 
local tE = Instance.new("TextButton") tE.Size = UDim2.new(0, 100, 1, 0) tE.Position = UDim2.new(0, 130, 0, 0) tE.BackgroundTransparency = 1 tE.Text = "ESP" tE.TextColor3 = Color3.fromRGB(120, 130, 230) tE.TextSize = 14 tE.Font = Enum.Font.SourceSansBold tE.Parent = TB 
local AP = Instance.new("Frame") AP.Size = UDim2.new(1, -65, 1, -50) AP.Position = UDim2.new(0, 55, 0, 40) AP.BackgroundTransparency = 1 AP.Visible = false AP.Parent = MainFrame 
local EP = Instance.new("Frame") EP.Size = UDim2.new(1, -65, 1, -50) EP.Position = UDim2.new(0, 55, 0, 40) EP.BackgroundTransparency = 1 EP.Visible = true EP.Parent = MainFrame 

tA.MouseButton1Click:Connect(function() AP.Visible = true; EP.Visible = false; tA.TextColor3 = Color3.fromRGB(120, 130, 230); tE.TextColor3 = Color3.fromRGB(150, 150, 150) end)
tE.MouseButton1Click:Connect(function() AP.Visible = false; EP.Visible = true; tA.TextColor3 = Color3.fromRGB(150, 150, 150); tE.TextColor3 = Color3.fromRGB(120, 130, 230) end)

local aC = Instance.new("TextButton") aC.Size = UDim2.new(0, 14, 0, 14) aC.Position = UDim2.new(0, 15, 0, 30) aC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) aC.BorderSizePixel = 0 aC.Text = "" aC.Parent = AP 
local aL = Instance.new("TextLabel") aL.Size = UDim2.new(0, 250, 0, 14) aL.Position = UDim2.new(0, 40, 0, 30) aL.BackgroundTransparency = 1 aL.Text = "Enable Smooth Aimbot (Hold RMB)" aL.TextColor3 = Color3.fromRGB(220, 220, 220) aL.TextSize = 14 aL.TextXAlignment = Enum.TextXAlignment.Left aL.Font = Enum.Font.SourceSans aL.Parent = AP 
aC.MouseButton1Click:Connect(function() _G.AimEnabled = not _G.AimEnabled; aC.BackgroundColor3 = _G.AimEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35); if _G.FovCircle then _G.FovCircle.Visible = (_G.AimEnabled and ScreenGui.Enabled) end end)

local tC = Instance.new("TextButton") tC.Size = UDim2.new(0, 14, 0, 14) tC.Position = UDim2.new(0, 15, 0, 65) tC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) tC.BorderSizePixel = 0 tC.Text = "" tC.Parent = AP 
local tL = Instance.new("TextLabel") tL.Size = UDim2.new(0, 250, 0, 14) tL.Position = UDim2.new(0, 40, 0, 65) tL.BackgroundTransparency = 1 tL.Text = "Enable Instant Triggerbot" tL.TextColor3 = Color3.fromRGB(220, 220, 220) tL.TextSize = 14 tL.TextXAlignment = Enum.TextXAlignment.Left tL.Font = Enum.Font.SourceSans tL.Parent = AP 
tC.MouseButton1Click:Connect(function() _G.TriggerEnabled = not _G.TriggerEnabled; tC.BackgroundColor3 = _G.TriggerEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local fovLabel = Instance.new("TextLabel") fovLabel.Size = UDim2.new(0, 200, 0, 20) fovLabel.Position = UDim2.new(0, 15, 0, 105) fovLabel.BackgroundTransparency = 1 fovLabel.Text = "Aim FOV Radius: " .. tostring(_G.LirpFOV) fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200) fovLabel.TextSize = 14 fovLabel.TextXAlignment = Enum.TextXAlignment.Left fovLabel.Font = Enum.Font.SourceSans fovLabel.Parent = AP 
local btnPlus = Instance.new("TextButton") btnPlus.Size = UDim2.new(0, 40, 0, 25) btnPlus.Position = UDim2.new(0, 15, 0, 135) btnPlus.BackgroundColor3 = Color3.fromRGB(35, 35, 40) btnPlus.Text = "[+]" btnPlus.TextColor3 = Color3.fromRGB(255, 255, 255) btnPlus.Font = Enum.Font.SourceSansBold btnPlus.Parent = AP 
local btnMinus = Instance.new("TextButton") btnMinus.Size = UDim2.new(0, 40, 0, 25) btnMinus.Position = UDim2.new(0, 65, 0, 135) btnMinus.BackgroundColor3 = Color3.fromRGB(35, 35, 40) btnMinus.Text = "[-]" btnMinus.TextColor3 = Color3.fromRGB(255, 255, 255) btnMinus.Font = Enum.Font.SourceSansBold btnMinus.Parent = AP 
btnPlus.MouseButton1Click:Connect(function() _G.LirpFOV = math.min(_G.LirpFOV + 20, 600); fovLabel.Text = "Aim FOV Radius: " .. tostring(_G.LirpFOV) end)
btnMinus.MouseButton1Click:Connect(function() _G.LirpFOV = math.max(_G.LirpFOV - 20, 40); fovLabel.Text = "Aim FOV Radius: " .. tostring(_G.LirpFOV) end)

local cC = Instance.new("TextButton") cC.Size = UDim2.new(0, 14, 0, 14) cC.Position = UDim2.new(0, 15, 0, 30) cC.BackgroundColor3 = Color3.fromRGB(65, 80, 220) cC.BorderSizePixel = 0 cC.Text = "" cC.Parent = EP 
local cL = Instance.new("TextLabel") cL.Size = UDim2.new(0, 250, 0, 14) cL.Position = UDim2.new(0, 40, 0, 30) cL.BackgroundTransparency = 1 cL.Text = "Enable Chams Visuals" cL.TextColor3 = Color3.fromRGB(220, 220, 220) cL.TextSize = 14 cL.TextXAlignment = Enum.TextXAlignment.Left cL.Font = Enum.Font.SourceSans cL.Parent = EP 
cC.MouseButton1Click:Connect(function() _G.ChamsEnabled = not _G.ChamsEnabled; if not _G.ChamsEnabled then cC.BackgroundColor3 = Color3.fromRGB(30, 30, 35); if _G.PurgeLirp then _G.PurgeLirp() end else cC.BackgroundColor3 = Color3.fromRGB(65, 80, 220) _G.ScriptRunning = true _G.ChamsEnabled = true end end)

local wC = Instance.new("TextButton") wC.Size = UDim2.new(0, 14, 0, 14) wC.Position = UDim2.new(0, 15, 0, 65) wC.BackgroundColor3 = Color3.fromRGB(30, 30, 35) wC.BorderSizePixel = 0 wC.Text = "" wC.Parent = EP 
local wL = Instance.new("TextLabel") wL.Size = UDim2.new(0, 250, 0, 14) wL.Position = UDim2.new(0, 40, 0, 65) wL.BackgroundTransparency = 1 wL.Text = "Enable Wall Check (Visible Only)" wL.TextColor3 = Color3.fromRGB(220, 220, 220) wL.TextSize = 14 wL.TextXAlignment = Enum.TextXAlignment.Left wL.Font = Enum.Font.SourceSans wL.Parent = EP 
wC.MouseButton1Click:Connect(function() _G.WallCheckEnabled = not _G.WallCheckEnabled; wC.BackgroundColor3 = _G.WallCheckEnabled and Color3.fromRGB(65, 80, 220) or Color3.fromRGB(30, 30, 35) end)

local UB = Instance.new("TextButton") UB.Size = UDim2.new(0, 180, 0, 30) UB.Position = UDim2.new(0, 55, 1, -40) UB.BackgroundColor3 = Color3.fromRGB(25, 25, 30) UB.BorderSizePixel = 1 UB.BorderColor3 = Color3.fromRGB(40, 40, 50) UB.Text = "Unload Lirp Hub" UB.TextColor3 = Color3.fromRGB(160, 160, 160) UB.TextSize = 13 UB.Font = Enum.Font.SourceSans UB.Parent = MF 

KB.MouseButton1Click:Connect(function()
    if KeyInput.Text == _G.CorrectKey then KF:Destroy(); MainFrame.Visible = true; _G.ScriptRunning = true; print("[Xeno System]: Access Granted!")
    else KeyInput.Text = ""; KeyInput.PlaceholderText = "WRONG KEY! TRY AGAIN." end
end)

local tConn
tConn = UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift and _G.ScriptRunning then 
        ScreenGui.Enabled = not ScreenGui.Enabled
        if _G.FovCircle then _G.FovCircle.Visible = (_G.AimEnabled and ScreenGui.Enabled) end
    end 
end)

UB.MouseButton1Click:Connect(function() 
    if _G.PurgeLirp then _G.PurgeLirp() end; if _G.VisualConnection then _G.VisualConnection:Disconnect() end; if tConn then tConn:Disconnect() end
    task.wait(0.05) ScreenGui:Destroy() print("[Xeno]: Lirp Hub unloaded!")
end)

print("=========================================")
print("[Xeno System]: Waiting for key...")
print("=========================================")
