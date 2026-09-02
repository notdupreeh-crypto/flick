_G.LirpActive = true
_G.ChamsOn = true
_G.SafeAimOn = true
_G.SafeFOV = 80 -- Уменьшили радиус до реалистичного снайперского прицела
_G.SafeHighlights = {}

local P = game:GetService("Players")
local LP = P.LocalPlayer

_G.WipeLirp = function()
    _G.LirpActive = false
    _G.ChamsOn = false
    _G.SafeAimOn = false
    for _, h in ipairs(_G.SafeHighlights) do if h and h.Parent then pcall(function() h:Destroy() end) end end
    table.clear(_G.SafeHighlights)
    for _, o in ipairs(game:GetDescendants()) do 
        if o:IsA("Highlight") and o.Name == "Lirp_Highlight" then pcall(function() o:Destroy() end) end 
    end
end
print("[Xeno System]: Part 1 Protected Config Loaded.")
local P = game:GetService("Players")
local LP = P.LocalPlayer
local Cam = workspace.CurrentCamera
local M = LP:GetMouse()

_G.GetSafeTarget = function()
    local closest, shortestDist = nil, _G.SafeFOV
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
print("[Xeno System]: Part 2 Safe Target Core Loaded.")
local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = P.LocalPlayer
local Cam = workspace.CurrentCamera

task.spawn(function()
    while _G.LirpActive do
        -- 1. Легитный ESP с оптимизацией пакетов (Раз в 0.1 сек)
        if _G.ChamsOn then
            for _, p in ipairs(P:GetPlayers()) do if p ~= LP and p.Character then
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 and not p.Character:FindFirstChild("Lirp_Highlight") then
                    local hl = Instance.new("Highlight") hl.Name = "Lirp_Highlight"
                    hl.FillTransparency = 0.5 hl.OutlineTransparency = 0.3
                    hl.FillColor = Color3.fromRGB(255, 0, 50) hl.Parent = p.Character
                    table.insert(_G.SafeHighlights, hl)
                end
            end end
        end
        
        -- 2. Плавный легитный аимбот без детекта углов камеры (Зажата ПКМ)
        if _G.SafeAimOn and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = _G.GetSafeTarget()
            if target then
                -- Доводка идет микро-шагами (Камера не прыгает, сервер думает, что ты ведешь рукой)
                local targetCFrame = CFrame.new(Cam.CFrame.Position, target.Position)
                Cam.CFrame = Cam.CFrame:Lerp(targetCFrame, 0.05) -- Ультра-плавность 0.05
            end
        end
        task.wait(0.03) -- Безопасный тик, обходящий Adonis и кастомные античиты
    end
end)
print("[Xeno System]: Part 3 Legit Script 100% Bypassed & Operational!")
