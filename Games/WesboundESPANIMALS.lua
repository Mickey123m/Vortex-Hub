-- ESP Outline para Animais
-- Detecta modelos na pasta Animals da workspace

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Configurações
local OutlineColor = Color3.fromRGB(255, 255, 0) -- Amarelo
local MaxDistance = 999999 -- Distância máxima para mostrar
local ShowName = true -- Mostrar nome do animal
local ShowDistance = true -- Mostrar distância

-- Tabela para armazenar os componentes ESP ativos
local ActiveESP = {}

-- Função para extrair o nome do animal (remove o UUID)
local function GetAnimalName(fullName)
    -- Remove o padrão {UUID} do nome
    local cleanName = fullName:match("^(.-)%{") or fullName
    return cleanName
end

-- Função para obter a parte principal do modelo
local function GetModelPart(model)
    return model:FindFirstChild("HumanoidRootPart") or 
           model:FindFirstChild("Torso") or 
           model:FindFirstChild("Head") or
           model:FindFirstChildWhichIsA("BasePart")
end

-- Função para criar ESP completo (Highlight + BillboardGui)
local function CreateESP(model)
    if ActiveESP[model] then return end
    
    local mainPart = GetModelPart(model)
    if not mainPart then return end
    
    ActiveESP[model] = {}
    
    -- Criar Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "AnimalHighlight"
    highlight.Adornee = model
    highlight.FillColor = OutlineColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = OutlineColor
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    
    ActiveESP[model].Highlight = highlight
    
    -- Criar BillboardGui para texto
    if ShowName or ShowDistance then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "AnimalESP"
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
        
        ActiveESP[model].Billboard = billboard
        ActiveESP[model].TextLabel = textLabel
    end
end

-- Função para remover ESP
local function RemoveESP(model)
    if ActiveESP[model] then
        if ActiveESP[model].Highlight then
            ActiveESP[model].Highlight:Destroy()
        end
        if ActiveESP[model].Billboard then
            ActiveESP[model].Billboard:Destroy()
        end
        ActiveESP[model] = nil
    end
end

-- Função para verificar distância
local function GetDistance(model)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    
    local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
    local modelPart = GetModelPart(model)
    if not modelPart then return math.huge end
    
    local modelPos = modelPart.Position
    return (playerPos - modelPos).Magnitude
end

-- Função para atualizar texto do ESP
local function UpdateESPText(model)
    if not ActiveESP[model] or not ActiveESP[model].TextLabel then return end
    
    local distance = GetDistance(model)
    local animalName = GetAnimalName(model.Name)
    local text = ""
    
    if ShowName then
        text = animalName
    end
    
    if ShowDistance then
        if text ~= "" then
            text = text .. "\n"
        end
        text = text .. string.format("[%dm]", math.floor(distance))
    end
    
    ActiveESP[model].TextLabel.Text = text
end

-- Função para processar um animal
local function ProcessAnimal(model)
    if not model:IsA("Model") then return end
    if not model.Parent then return end
    
    local distance = GetDistance(model)
    
    if distance <= MaxDistance then
        if not ActiveESP[model] then
            CreateESP(model)
        end
        UpdateESPText(model)
    else
        RemoveESP(model)
    end
end

-- Função para processar todos os animais
local function UpdateAllAnimals()
    if not Workspace:FindFirstChild("Animals") then return end
    
    local animalsFolder = Workspace.Animals
    
    for _, animal in pairs(animalsFolder:GetChildren()) do
        ProcessAnimal(animal)
    end
end

-- Detecta novos animais
local function OnAnimalAdded(animal)
    task.wait(0.2)
    ProcessAnimal(animal)
end

-- Detecta animais removidos
local function OnAnimalRemoved(animal)
    RemoveESP(animal)
end

-- Inicializar
local function Initialize()
    if Workspace:FindFirstChild("Animals") then
        local animalsFolder = Workspace.Animals
        
        -- Conectar eventos
        animalsFolder.ChildAdded:Connect(OnAnimalAdded)
        animalsFolder.ChildRemoved:Connect(OnAnimalRemoved)
        
        -- Processar animais existentes
        for _, animal in pairs(animalsFolder:GetChildren()) do
            ProcessAnimal(animal)
        end
        
        print("Animal ESP ativado! Encontrados " .. #animalsFolder:GetChildren() .. " animais")
    else
        warn("Pasta 'Animals' não encontrada no Workspace!")
    end
end

-- Loop de atualização
RunService.RenderStepped:Connect(function()
    UpdateAllAnimals()
end)

-- Inicializar
Initialize()