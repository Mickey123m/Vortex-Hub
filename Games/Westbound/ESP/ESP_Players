-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- CONFIG
local ESP_COLOR = Color3.fromRGB(255, 0, 0)
local OUTLINE_COLOR = Color3.fromRGB(255, 255, 255)

shared.PlayerESP_Enabled = true

-- Função que aplica e trava o Highlight
local function ApplyHighlight(character)
    if not character or not shared.PlayerESP_Enabled then return end
    
    local highlight = character:FindFirstChild("ESP_Highlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Parent = character
    end

    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.FillColor = ESP_COLOR
    highlight.OutlineColor = OUTLINE_COLOR
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
end

local function SetupPlayer(player)
    if player == LocalPlayer then return end

    local function onCharacter(character)
        -- Tenta aplicar imediatamente
        ApplyHighlight(character)

        -- Escuta se algo for deletado do personagem (previne o sistema do Roblox de remover)
        character.ChildRemoved:Connect(function(child)
            if child.Name == "ESP_Highlight" and shared.PlayerESP_Enabled then
                task.wait() -- Pequeno delay para não bugar o motor
                ApplyHighlight(character)
            end
        end)
    end

    player.CharacterAdded:Connect(onCharacter)
    if player.Character then onCharacter(player.Character) end
end

-- Inicializa para todos
for _, player in ipairs(Players:GetPlayers()) do
    SetupPlayer(player)
end

Players.PlayerAdded:Connect(SetupPlayer)

-- LOOP AGRESSIVO (Verifica a cada frame se o ESP existe)
RunService.RenderStepped:Connect(function()
    if not shared.PlayerESP_Enabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            -- Se não tiver o highlight ou se ele estiver desativado, força a volta
            local highlight = char:FindFirstChild("ESP_Highlight")
            if not highlight then
                ApplyHighlight(char)
            end
        end
    end
end)

print("[PLAYER ESP] MODO PROTEGIDO ATIVO")