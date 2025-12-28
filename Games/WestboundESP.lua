-- ESP Outline para Players
-- Detecta todos os jogadores no servidor

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Configurações
local OutlineColor = Color3.fromRGB(255, 0, 0) -- Vermelho
local MaxDistance = 1000 -- Distância máxima para mostrar
local ShowName = true -- Mostrar nome do jogador
local ShowDistance = true -- Mostrar distância

-- Tabela para armazenar os componentes ESP ativos
local ActiveESP = {}

-- Função para obter a parte principal do personagem
local function GetCharacterPart(character)
    return character:FindFirstChild("HumanoidRootPart") or 
           character:FindFirstChild("Torso") or 
           character:FindFirstChild("Head") or
           character:FindFirstChildWhichIsA("BasePart")
end

-- Função para criar ESP completo (Highlight + BillboardGui)
local function CreateESP(player, character)
    if ActiveESP[player] then return end
    
    local mainPart = GetCharacterPart(character)
    if not mainPart then return end
    
    ActiveESP[player] = {}
    
    -- Criar Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.Adornee = character
    highlight.FillColor = OutlineColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = OutlineColor
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    ActiveESP[player].Highlight = highlight
    ActiveESP[player].Character = character
    
    -- Criar BillboardGui para texto
    if ShowName or ShowDistance then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESP"
        billboard.Adornee = mainPart
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = mainPart
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = OutlineColor
        textLabel.TextStrokeTransparency = 0.5
        textLabel.TextSize = 16
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Parent = billboard
        
        ActiveESP[player].Billboard = billboard
        ActiveESP[player].TextLabel = textLabel
    end
end

-- Função para remover ESP
local function RemoveESP(player)
    if ActiveESP[player] then
        if ActiveESP[player].Highlight then
            ActiveESP[player].Highlight:Destroy()
        end
        if ActiveESP[player].Billboard then
            ActiveESP[player].Billboard:Destroy()
        end
        ActiveESP[player] = nil
    end
end

-- Função para verificar distância
local function GetDistance(character)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    
    local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
    local characterPart = GetCharacterPart(character)
    if not characterPart then return math.huge end
    
    local characterPos = characterPart.Position
    return (playerPos - characterPos).Magnitude
end

-- Função para atualizar texto do ESP
local function UpdateESPText(player)
    if not ActiveESP[player] or not ActiveESP[player].TextLabel then return end
    if not ActiveESP[player].Character or not ActiveESP[player].Character.Parent then return end
    
    local distance = GetDistance(ActiveESP[player].Character)
    local text = ""
    
    if ShowName then
        text = player.Name
    end
    
    if ShowDistance then
        if text ~= "" then
            text = text .. "\n"
        end
        text = text .. string.format("[%dm]", math.floor(distance))
    end
    
    ActiveESP[player].TextLabel.Text = text
end

-- Função para processar um jogador
local function ProcessPlayer(player)
    if player == LocalPlayer then return end -- Não mostrar ESP no próprio jogador
    
    local character = player.Character
    if not character or not character.Parent then 
        RemoveESP(player)
        return 
    end
    
    local distance = GetDistance(character)
    
    if distance <= MaxDistance then
        if not ActiveESP[player] or ActiveESP[player].Character ~= character then
            RemoveESP(player)
            CreateESP(player, character)
        end
        UpdateESPText(player)
    else
        RemoveESP(player)
    end
end

-- Função para processar todos os jogadores
local function UpdateAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ProcessPlayer(player)
        end
    end
end

-- Detecta quando um jogador entra
local function OnPlayerAdded(player)
    if player == LocalPlayer then return end
    
    -- Espera o personagem spawnar
    player.CharacterAdded:Connect(function(character)
        task.wait(0.2)
        ProcessPlayer(player)
    end)
    
    -- Se já tem personagem
    if player.Character then
        task.wait(0.2)
        ProcessPlayer(player)
    end
end

-- Detecta quando um jogador sai
local function OnPlayerRemoving(player)
    RemoveESP(player)
end

-- Inicializar
local function Initialize()
    -- Conectar eventos
    Players.PlayerAdded:Connect(OnPlayerAdded)
    Players.PlayerRemoving:Connect(OnPlayerRemoving)
    
    -- Processar jogadores existentes
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            OnPlayerAdded(player)
            
            -- Se já tem personagem
            if player.Character then
                ProcessPlayer(player)
            end
        end
    end
    
    local playerCount = #Players:GetPlayers() - 1 -- -1 para não contar o próprio jogador
    print("Player ESP ativado! " .. playerCount .. " jogadores detectados")
end

-- Loop de atualização
RunService.RenderStepped:Connect(function()
    UpdateAllPlayers()
end)

-- Inicializar
Initialize()