local P,CG,RS,UIS=game:GetService("Players"),game:GetService("CoreGui"),game:GetService("RunService"),game:GetService("UserInputService")
local LP,M,CE,TE,MV,SR,AH=P.LocalPlayer,P.LocalPlayer:GetMouse(),true,false,true,true,{}
local AE,FOV,Smooth=false,120,0.15 -- Настройки Аима (AE - включен ли, FOV - радиус, Smooth - плавность)
local EC=Color3.fromRGB(255,0,50) local Cam=workspace.CurrentCamera

local function purge()
    for _,h in ipairs(AH) do if h and h.Parent then pcall(function() h:Destroy() end) end end table.clear(AH)
    for _,o in ipairs(game:GetDescendants()) do if o:IsA("Highlight") and o.Name=="Lirp_Highlight" then pcall(function() o:Destroy() end) end end
end

local function apply(c)
    if not c or c==LP.Character then return end
    local h=c:FindFirstChildOfClass("Humanoid")
    if h and h.Health>0 then
        local hl=c:FindFirstChild("Lirp_Highlight")
        if not hl then
            hl=Instance.new("Highlight") hl.Name="Lirp_Highlight" hl.FillTransparency=0.45
            hl.OutlineColor=Color3.fromRGB(255,255,255) hl.OutlineTransparency=0.1
            hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop hl.Parent=c table.insert(AH,hl)
        end
        hl.FillColor=EC
    end
end

-- Функция поиска ближайшей цели для Аимбота внутри FOV
local function getClosestPlayer()
    local closest, shortestDist = nil, FOV
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

-- RenderStepped Loop (ESP, Triggerbot, Aimbot)
local vC
vC = RS.RenderStepped:Connect(function()
    if not SR then if vC then vC:Disconnect() end return end
    
    -- 1. ESP Logic
    if CE then for _,p in ipairs(P:GetPlayers()) do if p.Character then apply(p.Character) end end else purge() end
    
    -- 2. Aimbot Logic (Smooth camera lerp to target head)
    if AE and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Работает при зажатой ПКМ
        local targetHead = getClosestPlayer()
        if targetHead then
            Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, targetHead.Position), Smooth)
        end
    end
    
    -- 3. Triggerbot Logic
    if TE then
        local rp=RaycastParams.new() rp.FilterDescendantsInstances={LP.Character} rp.FilterType=Enum.RaycastFilterType.Exclude
        local res=workspace:Raycast(Cam.CFrame.Position,Cam.CFrame.LookVector*1500,rp)
        if res and res.Instance then
            local ch=res.Instance.Parent if ch and not ch:FindFirstChildOfClass("Humanoid") then ch=res.Instance.Parent.Parent end
            if ch and ch~=LP.Character then
                local hum=ch:FindFirstChildOfClass("Humanoid") if hum and hum.Health>0 then mouse1click() end
            end
        end
    end
end)

-- UI SYSTEM (LIRP HUB INTERFACE)
local SG=Instance.new("ScreenGui") SG.Name="Lirp_Flick_V9" SG.ResetOnSpawn=false
pcall(function() SG.Parent=CG end) if not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui") end

local MF=Instance.new("Frame") MF.Size=UDim2.new(0,560,0,380) MF.Position=UDim2.new(0.3,0,0.25,0) MF.BackgroundColor3=Color3.fromRGB(12,12,14) MF.BorderSizePixel=1 MF.BorderColor3=Color3.fromRGB(35,35,45) MF.Active=true MF.Draggable=true MF.Parent=SG
local SB=Instance.new("Frame") SB.Size=UDim2.new(0,45,1,0) SB.BackgroundColor3=Color3.fromRGB(8,8,10) SB.BorderSizePixel=0 SB.Parent=MF
local BL=Instance.new("Frame") BL.Size=UDim2.new(1,0,0,2) BL.BackgroundColor3=Color3.fromRGB(65,80,220) BL.BorderSizePixel=0 BL.Parent=MF
local TB=Instance.new("Frame") TB.Size=UDim2.new(1,-45,0,30) TB.Position=UDim2.new(0,45,0,2) TB.BackgroundColor3=Color3.fromRGB(15,15,18) TB.BorderSizePixel=0 TB.Parent=MF

local tA=Instance.new("TextButton") tA.Size=UDim2.new(0,100,1,0) tA.Position=UDim2.new(0,20,0,0) tA.BackgroundTransparency=1 tA.Text="Aimbot" tA.TextColor3=Color3.fromRGB(150,150,150) tA.TextSize=14 tA.Font=Enum.Font.SourceSansBold tA.Parent=TB
local tE=Instance.new("TextButton") tE.Size=UDim2.new(0,100,1,0) tE.Position=UDim2.new(0,130,0,0) tE.BackgroundTransparency=1 tE.Text="ESP" tE.TextColor3=Color3.fromRGB(120,130,230) tE.TextSize=14 tE.Font=Enum.Font.SourceSansBold tE.Parent=TB

local AP=Instance.new("Frame") AP.Size=UDim2.new(1,-65,1,-50) AP.Position=UDim2.new(0,55,0,40) AP.BackgroundTransparency=1 AP.Visible=false AP.Parent=MF
local EP=Instance.new("Frame") EP.Size=UDim2.new(1,-65,1,-50) EP.Position=UDim2.new(0,55,0,40) EP.BackgroundTransparency=1 EP.Visible=true EP.Parent=MF

tA.MouseButton1Click:Connect(function() AP.Visible=true EP.Visible=false tA.TextColor3=Color3.fromRGB(120,130,230) tE.TextColor3=Color3.fromRGB(150,150,150) end)
tE.MouseButton1Click:Connect(function() AP.Visible=false EP.Visible=true tA.TextColor3=Color3.fromRGB(150,150,150) tE.TextColor3=Color3.fromRGB(120,130,230) end)

-- Вкладка Aimbot (Кнопки Аима и Триггера)
local aC=Instance.new("TextButton") aC.Size=UDim2.new(0,14,0,14) aC.Position=UDim2.new(0,15,0,30) aC.BackgroundColor3=Color3.fromRGB(30,30,35) aC.BorderSizePixel=0 aC.Text="" aC.Parent=AP
local aL=Instance.new("TextLabel") aL.Size=UDim2.new(0,250,0,14) aL.Position=UDim2.new(0,40,0,30) aL.BackgroundTransparency=1 aL.Text="Enable Smooth Aimbot (Hold RMB)" aL.TextColor3=Color3.fromRGB(220,220,220) aL.TextSize=14 aL.TextXAlignment=Enum.TextXAlignment.Left aL.Font=Enum.Font.SourceSans aL.Parent=AP
aC.MouseButton1Click:Connect(function() AE=not AE aC.BackgroundColor3=AE and Color3.fromRGB(65,80,220) or Color3.fromRGB(30,30,35) end)

local tC=Instance.new("TextButton") tC.Size=UDim2.new(0,14,0,14) tC.Position=UDim2.new(0,15,0,65) tC.BackgroundColor3=Color3.fromRGB(30,30,35) tC.BorderSizePixel=0 tC.Text="" tC.Parent=AP
local tL=Instance.new("TextLabel") tL.Size=UDim2.new(0,250,0,14) tL.Position=UDim2.new(0,40,0,65) tL.BackgroundTransparency=1 tL.Text="Enable Instant Triggerbot" tL.TextColor3=Color3.fromRGB(220,220,220) tL.TextSize=14 tL.TextXAlignment=Enum.TextXAlignment.Left tL.Font=Enum.Font.SourceSans tL.Parent=AP
tC.MouseButton1Click:Connect(function() TE=not TE tC.BackgroundColor3=TE and Color3.fromRGB(65,80,220) or Color3.fromRGB(30,30,35) end)

-- Вкладка ESP
local cC=Instance.new("TextButton") cC.Size=UDim2.new(0,14,0,14) cC.Position=UDim2.new(0,15,0,30) cC.BackgroundColor3=Color3.fromRGB(65,80,220) cC.BorderSizePixel=0 cC.Text="" cC.Parent=EP
local cL=Instance.new("TextLabel") cL.Size=UDim2.new(0,250,0,14) cL.Position=UDim2.new(0,40,0,30) cL.BackgroundTransparency=1 cL.Text="Enable Chams Visuals (All Players)" cL.TextColor3=Color3.fromRGB(220,220,220) cL.TextSize=14 cL.TextXAlignment=Enum.TextXAlignment.Left cL.Font=Enum.Font.SourceSans cL.Parent=EP
cC.MouseButton1Click:Connect(function() CE=not CE if not CE then cC.BackgroundColor3=Color3.fromRGB(30,30,35) purge() else cC.BackgroundColor3=Color3.fromRGB(65,80,220) end end)

local UB=Instance.new("TextButton") UB.Size=UDim2.new(0,180,0,30) UB.Position=UDim2.new(0,55,1,-40) UB.BackgroundColor3=Color3.fromRGB(25,25,30) UB.BorderSizePixel=1 UB.BorderColor3=Color3.fromRGB(40,40,50) UB.Text="Unload Lirp Hub" UB.TextColor3=Color3.fromRGB(160,160,160) UB.TextSize=13 UB.Font=Enum.Font.SourceSans UB.Parent=MF
local menuVisible=true local tConn tConn=UIS.InputBegan:Connect(function(i,p) if not p and i.KeyCode==Enum.KeyCode.RightShift then menuVisible=not menuVisible SG.Enabled=menuVisible end end)

UB.MouseButton1Click:Connect(function() SR,TE,CE,AE=false,false,false,false if tConn then tConn:Disconnect() end task.wait(0.05) purge() SG:Destroy() print("[Xeno]: Lirp Hub unloaded!") end)
print("=========================================\n[Xeno System]: Flick Sniper Arena Lirp V9 | LOADED\n=========================================")
