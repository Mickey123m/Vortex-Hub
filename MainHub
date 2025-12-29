local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- [[ STATE VARIABLES ]]
local States = {
    ESP_Players = false,
    ESP_Bandidos = false,
    ESP_Policiais = false,
    ESP_Prisioneiros = false,
    Bypass_Doors = false,
    Auto_KeyCard = false,
    Auto_M9 = false,
    BlindShot_ESP = false,
    Auto_Trophy = false,
    Anti_AFK = false,
    Brainrot_Farm = false,
    
    -- FNAF States
    FNAF_ESP_Animatronics = false,
    FNAF_ESP_Fuses = false,
    FNAF_ESP_Batteries = false,
    FNAF_ESP_Pliers = false,
    FNAF_ESP_Screwdriver = false,
    FNAF_ESP_All = false,
    
    FNAF_FullBright = false,
    FNAF_SpeedHack = false,
    
    FNAF_Pull_Batteries = false,
    FNAF_Pull_Screwdriver = false,
    FNAF_Pull_Pliers = false,
    FNAF_Pull_Fuses = false,
    FNAF_Pull_All = false,
    
    -- Westbound States
    Westbound_ESP_Players = false,
    Westbound_ESP_Animals = false,
    Westbound_ESP_DistanceName = false,
    Westbound_ESP_Name = false,
    
    -- Connections for FNAF
    FNAF_ESP_Connections = {},
    FNAF_Pull_Connections = {},
    FNAF_Lighting_Connection = nil,
    FNAF_Speed_Connection = nil
}

-- [[ TELEPORT SYSTEM ]]
local TeleportCooldown = false
local LastTeleportTime = 0
local TELEPORT_COOLDOWN = 2

local function SafeTeleportWithReturn(cframe, delayBeforeReturn)
    if TeleportCooldown then
        local waitTime = TELEPORT_COOLDOWN - (tick() - LastTeleportTime)
        if waitTime > 0 then
            print("[Vortex Hub] Wait " .. math.ceil(waitTime) .. "s before teleporting again")
            return false
        end
    end
    
    local char = LocalPlayer.Character
    local humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then
        print("[Vortex Hub] Character not found!")
        return false
    end
    
    TeleportCooldown = true
    LastTeleportTime = tick()
    
    local originalPosition = humanoidRootPart.CFrame
    
    humanoidRootPart.CFrame = cframe
    task.wait(0.1)
    
    print("[Vortex Hub] Teleport completed!")
    
    if delayBeforeReturn and delayBeforeReturn > 0 then
        task.wait(delayBeforeReturn)
        humanoidRootPart.CFrame = originalPosition
        task.wait(0.1)
        print("[Vortex Hub] Returned to original position")
    end
    
    task.spawn(function()
        task.wait(TELEPORT_COOLDOWN)
        TeleportCooldown = false
    end)
    
    return true
end

local function SimpleTeleport(cframe)
    if TeleportCooldown then
        local waitTime = TELEPORT_COOLDOWN - (tick() - LastTeleportTime)
        if waitTime > 0 then
            print("[Vortex Hub] Wait " .. math.ceil(waitTime) .. "s before teleporting again")
            return false
        end
    end
    
    local char = LocalPlayer.Character
    local humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then
        print("[Vortex Hub] Character not found!")
        return false
    end
    
    TeleportCooldown = true
    LastTeleportTime = tick()
    
    humanoidRootPart.CFrame = cframe
    task.wait(0.1)
    
    print("[Vortex Hub] Teleport completed!")
    
    task.spawn(function()
        task.wait(TELEPORT_COOLDOWN)
        TeleportCooldown = false
    end)
    
    return true
end

-- [[ ESP NORMAL SYSTEM (PARA PRISON LIFE) - CORRIGIDO DEFINITIVAMENTE ]]
local ESP = {
    Players = {},
    Connections = {},
    Highlights = {}
}

function ESP.ShouldShowESP(player)
    if player == LocalPlayer then return false end
    if not player.Parent then return false end
    
    local teamName = player.Team and player.Team.Name or ""
    local showESP = false
    
    if States.ESP_Players then
        showESP = true
    end
    
    if States.ESP_Bandidos and teamName == "Criminals" then
        showESP = true
    end
    
    if States.ESP_Policiais and teamName == "Guards" then
        showESP = true
    end
    
    if States.ESP_Prisioneiros and teamName == "Inmates" then
        showESP = true
    end
    
    return showESP
end

function ESP.CreateHighlight(player, character)
    if not character or not character.Parent then return nil end
    
    ESP.RemoveHighlight(player)
    
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 2)
    if not humanoidRootPart then return nil end
    
    if ESP.Highlights[player.UserId] then
        local existing = ESP.Highlights[player.UserId]
        if existing and existing.Parent then
            existing:Destroy()
        end
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "VortexChams_" .. player.UserId
    highlight.Adornee = character
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = character
    
    ESP.Players[player] = {
        Highlight = highlight,
        Character = character,
        Team = player.Team
    }
    
    ESP.Highlights[player.UserId] = highlight
    
    ESP.UpdatePlayerESP(player)
    
    return highlight
end

function ESP.RemoveHighlight(player)
    if ESP.Players[player] then
        local data = ESP.Players[player]
        if data.Highlight and data.Highlight.Parent then
            data.Highlight:Destroy()
        end
        ESP.Players[player] = nil
    end
    
    if player then
        local userId = player.UserId
        if ESP.Highlights[userId] then
            local highlight = ESP.Highlights[userId]
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
            ESP.Highlights[userId] = nil
        end
    end
end

function ESP.UpdatePlayerESP(player)
    if not ESP.Players[player] then return end
    
    local data = ESP.Players[player]
    if not data.Highlight or not data.Highlight.Parent then return end
    
    local shouldShow = ESP.ShouldShowESP(player)
    local teamColor = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
    
    data.Highlight.Enabled = shouldShow
    if shouldShow then
        data.Highlight.FillColor = teamColor
        data.Highlight.OutlineColor = Color3.new(1, 1, 1)
    end
end

function ESP.UpdateAllESPs()
    for player, data in pairs(ESP.Players) do
        if player and player.Parent then
            ESP.UpdatePlayerESP(player)
        else
            ESP.RemoveHighlight(player)
        end
    end
end

function ESP.SetupPlayer(player)
    if player == LocalPlayer then return end
    
    ESP.RemoveHighlight(player)
    
    local function HandleCharacter(character)
        if not character then return end
        
        task.wait(1)
        
        local success = pcall(function()
            if character and character.Parent then
                ESP.CreateHighlight(player, character)
            end
        end)
        
        if not success then
            task.wait(0.5)
            pcall(function()
                if character and character.Parent then
                    ESP.CreateHighlight(player, character)
                end
            end)
        end
        
        local humanoid = character:WaitForChild("Humanoid", 2)
        if humanoid then
            local deathConnection = humanoid.Died:Connect(function()
                ESP.RemoveHighlight(player)
            end)
            table.insert(ESP.Connections, deathConnection)
        end
        
        local ancestryConnection = character.AncestryChanged:Connect(function(_, parent)
            if not parent then
                ESP.RemoveHighlight(player)
            end
        end)
        table.insert(ESP.Connections, ancestryConnection)
    end
    
    if player.Character then
        task.spawn(HandleCharacter, player.Character)
    end
    
    local charAdded = player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        HandleCharacter(character)
    end)
    table.insert(ESP.Connections, charAdded)
    
    local teamChanged = player:GetPropertyChangedSignal("Team"):Connect(function()
        task.wait(0.1)
        ESP.UpdatePlayerESP(player)
    end)
    table.insert(ESP.Connections, teamChanged)
    
    local playerRemoving = player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            ESP.RemoveHighlight(player)
        end
    end)
    table.insert(ESP.Connections, playerRemoving)
end

function ESP.Initialize()
    ESP.Cleanup()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            task.spawn(function()
                task.wait(0.2)
                ESP.SetupPlayer(player)
            end)
        end
    end
    
    local playerAdded = Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            task.wait(1)
            ESP.SetupPlayer(player)
        end
    end)
    table.insert(ESP.Connections, playerAdded)
    
    local playerRemoving = Players.PlayerRemoving:Connect(function(player)
        ESP.RemoveHighlight(player)
    end)
    table.insert(ESP.Connections, playerRemoving)
    
    task.spawn(function()
        while task.wait(10) do
            pcall(function()
                for player, data in pairs(ESP.Players) do
                    if not player or not player.Parent then
                        ESP.RemoveHighlight(player)
                    elseif data.Character and not data.Character.Parent then
                        ESP.RemoveHighlight(player)
                    elseif data.Highlight and not data.Highlight.Parent then
                        ESP.RemoveHighlight(player)
                    end
                end
            end)
        end
    end)
end

function ESP.Cleanup()
    for player, _ in pairs(ESP.Players) do
        ESP.RemoveHighlight(player)
    end
    
    for userId, highlight in pairs(ESP.Highlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    
    for _, connection in pairs(ESP.Connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    
    ESP.Players = {}
    ESP.Connections = {}
    ESP.Highlights = {}
end

ESP.Initialize()

-- [[ BYPASS DOORS PRISON LIFE ]]
local originalProperties = {}
task.spawn(function()
    while task.wait(0.5) do
        if States.Bypass_Doors then
            pcall(function()
                local doorsFolder = workspace:FindFirstChild("Doors")
                
                if doorsFolder then
                    for _, door in pairs(doorsFolder:GetDescendants()) do
                        if door:IsA("BasePart") then
                            if not originalProperties[door] then
                                originalProperties[door] = {
                                    CanCollide = door.CanCollide,
                                    Transparency = door.Transparency
                                }
                            end
                            
                            door.CanCollide = false
                            door.Transparency = 0.5
                        end
                    end
                end
            end)
        else
            for door, properties in pairs(originalProperties) do
                if door and door.Parent then
                    door.CanCollide = properties.CanCollide
                    door.Transparency = properties.Transparency
                end
            end
        end
    end
end)

-- [[ AUTO KEYCARD/M9 SYSTEM ]]
local AUTO_PICKUP_INTERVAL = 3

local function HasItemInInventory(itemName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if string.find(item.Name:lower(), itemName:lower()) then
                return true
            end
        end
    end
    
    if character then
        for _, item in pairs(character:GetChildren()) do
            if string.find(item.Name:lower(), itemName:lower()) then
                return true
            end
        end
    end
    
    return false
end

local function FindAndPickupItem(itemName)
    pcall(function()
        if HasItemInInventory(itemName) then
            return false
        end
        
        local foundItem = nil
        
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Model") and string.find(item.Name:lower(), itemName:lower()) then
                local mesh = item:FindFirstChild("Mesh") or item:FindFirstChildWhichIsA("MeshPart")
                if mesh then
                    foundItem = item
                    break
                end
            end
        end
        
        if foundItem then
            local char = LocalPlayer.Character
            local humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                local itemPosition = foundItem:GetModelCFrame().Position
                local teleportCFrame = CFrame.new(itemPosition + Vector3.new(0, 2, 2))
                
                SafeTeleportWithReturn(teleportCFrame, 1.5)
                
                if HasItemInInventory(itemName) then
                    print("[Vortex Hub] Picked up " .. itemName .. " successfully!")
                    return true
                else
                    print("[Vortex Hub] Couldn't pick up " .. itemName)
                    return false
                end
            end
        end
        
        return false
    end)
    
    return false
end

task.spawn(function()
    while true do
        task.wait(AUTO_PICKUP_INTERVAL)
        
        if States.Auto_KeyCard then
            FindAndPickupItem("key")
        end
        
        if States.Auto_M9 then
            FindAndPickupItem("m9")
        end
    end
end)

-- [[ FUNCTION TO GET FORMATTED TEAM NAME ]]
local function GetTeamName()
    local team = LocalPlayer.Team
    if not team then return "No Team" end
    
    local teamNames = {
        ["Criminals"] = "Criminals",
        ["Guards"] = "Guards",
        ["Inmates"] = "Inmates",
        ["Neutral"] = "Neutral"
    }
    
    return teamNames[team.Name] or team.Name
end

-- [[ FUNCTION TO GET WEAPONS - COMPLETE ]]
local function GetPrisonWeapon(weaponName)
    if TeleportCooldown then
        local waitTime = TELEPORT_COOLDOWN - (tick() - LastTeleportTime)
        if waitTime > 0 then
            print("[Vortex Hub] Wait " .. math.ceil(waitTime) .. " seconds before teleporting again")
            return
        end
    end
    
    pcall(function()
        local prisonItems = workspace:FindFirstChild("Prison_ITEMS")
        if not prisonItems then
            print("[Vortex Hub] Prison_ITEMS folder not found!")
            return
        end
        
        local giverFolder = prisonItems:FindFirstChild("giver")
        if not giverFolder then
            print("[Vortex Hub] 'giver' folder not found!")
            return
        end
        
        local foundItem = nil
        local currentTeam = LocalPlayer.Team and LocalPlayer.Team.Name or ""
        
        if string.find(weaponName:lower(), "shotgun") then
            print("[Vortex Hub] Looking for shotgun... Current team: " .. currentTeam)
            
            if currentTeam == "Guards" then
                foundItem = giverFolder:FindFirstChild("Remington 870")
                if foundItem then
                    print("[Vortex Hub] Found police Remington 870")
                end
            elseif currentTeam == "Criminals" or currentTeam == "Inmates" then
                foundItem = giverFolder:FindFirstChild("Criminal Remington")
                if foundItem then
                    print("[Vortex Hub] Found Criminal Remington")
                end
            end
            
            if not foundItem then
                print("[Vortex Hub] Searching for any available shotgun...")
                for _, item in pairs(giverFolder:GetChildren()) do
                    if item:IsA("Model") then
                        local itemNameLower = item.Name:lower()
                        if string.find(itemNameLower, "remington") or 
                           string.find(itemNameLower, "shotgun") then
                            foundItem = item
                            print("[Vortex Hub] Found: " .. item.Name)
                            break
                        end
                    end
                end
            end
        else
            foundItem = giverFolder:FindFirstChild(weaponName)
            
            if not foundItem then
                for _, item in pairs(giverFolder:GetChildren()) do
                    if string.find(string.lower(item.Name), string.lower(weaponName)) then
                        foundItem = item
                        break
                    end
                end
            end
        end
        
        if foundItem and foundItem:IsA("Model") then
            local char = LocalPlayer.Character
            local humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                print("[Vortex Hub] Found: " .. foundItem.Name)
                
                local itemPosition = foundItem:GetModelCFrame().Position
                local teleportCFrame = nil
                
                if string.find(weaponName:lower(), "ak") then
                    teleportCFrame = CFrame.new(itemPosition + Vector3.new(0, 2, 3))
                    print("[Vortex Hub] AK-47: Teleporting behind the weapon")
                elseif string.find(weaponName:lower(), "mp5") then
                    teleportCFrame = CFrame.new(itemPosition + Vector3.new(0, 2, 2))
                else
                    teleportCFrame = CFrame.new(itemPosition + Vector3.new(0, 2, 2))
                end
                
                SafeTeleportWithReturn(teleportCFrame, 1.5)
                
                task.wait(0.5)
                if HasItemInInventory(weaponName:lower()) then
                    print("[Vortex Hub] " .. weaponName .. " picked up successfully!")
                else
                    print("[Vortex Hub] Couldn't pick up (click manually)")
                end
            else
                print("[Vortex Hub] Character not found!")
            end
        else
            print("[Vortex Hub] Weapon '" .. weaponName .. "' not found!")
        end
    end)
end

-- [[ TELEPORT TO TROPHY - AGORA COM 15 SEGUNDOS ]]
local function TeleportToTrophy()
    pcall(function()
        local trophy = workspace:FindFirstChild("Trophy")
        
        if not trophy then
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") and string.find(obj.Name:lower(), "trophy") then
                    trophy = obj
                    print("[Blind Shot] Trophy found by name: " .. obj.Name)
                    break
                end
            end
        end
        
        if not trophy then
            print("[Blind Shot] Trophy not found in workspace!")
            return false
        end
        
        print("[Blind Shot] Trophy found: " .. trophy.Name)
        local char = LocalPlayer.Character
        local humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            local trophyPosition
            if trophy:IsA("Model") then
                trophyPosition = trophy:GetModelCFrame().Position
            else
                trophyPosition = trophy.Position
            end
            
            local teleportCFrame = CFrame.new(trophyPosition + Vector3.new(0, 5, 0))
            
            if SimpleTeleport(teleportCFrame) then
                print("[Blind Shot] Successfully teleported to trophy!")
                return true
            else
                print("[Blind Shot] Failed to teleport")
                return false
            end
        else
            print("[Blind Shot] Character not found!")
            return false
        end
    end)
end

-- [[ ESP DEFINITIVO PARA BLIND SHOT - CORRIGIDO (SEM ESP AZUL NA PRÓXIMA RODADA) ]]
local BlindShotESP = {
    Active = false,
    Connections = {},
    RenderConnection = nil,
    Highlights = {}
}

local function ForceVisibility()
    if not BlindShotESP.Active then return end
    
    local jogadoresVivos = workspace:FindFirstChild("jogadoresVivos")
    if not jogadoresVivos then return end

    for _, v in ipairs(jogadoresVivos:GetChildren()) do
        if v.Name ~= LocalPlayer.Name then
            local char = workspace:FindFirstChild(v.Name)
            if char and char:IsA("Model") then
                for _, part in ipairs(char:GetDescendants()) do
                    if part.Name == "hitbox" or part.Name == "HumanoidRootPart" then
                        if part.Transparency ~= 1 then
                            part.Transparency = 1
                        end
                    elseif part:IsA("BasePart") then
                        if part.Transparency ~= 0 then
                            part.Transparency = 0
                        end
                    elseif part:IsA("Decal") or part:IsA("Texture") then
                        if part.Transparency ~= 0 then
                            part.Transparency = 0
                        end
                    elseif part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") then
                        if part.Enabled == false then
                            part.Enabled = true
                        end
                    end
                end
            end
        end
    end

    for _, h in ipairs(workspace:GetChildren()) do
        if h:IsA("Highlight") and h.Name == "Highlight_TEMP" then
            h.FillTransparency = 1
            h.OutlineTransparency = 0
        end
    end
    
    for playerName, highlight in pairs(BlindShotESP.Highlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    BlindShotESP.Highlights = {}
end

local function BypassJump(char)
    if not BlindShotESP.Active then return end
    
    local hum = char:WaitForChild("Humanoid")
    hum:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        if hum.JumpHeight == 0 then
            hum.JumpHeight = 50
        end
    end)
end

local function MonitorNewPlayers()
    if not BlindShotESP.Active then return end
    
    local jogadoresVivos = workspace:FindFirstChild("jogadoresVivos")
    if not jogadoresVivos then return end
    
    for playerName, highlight in pairs(BlindShotESP.Highlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    BlindShotESP.Highlights = {}
end

function BlindShotESP:Initialize()
    print("[Blind Shot ESP] Inicializando sistema DEFINITIVO...")
    
    self:CleanupHighlights()
    
    self.RenderConnection = RunService.RenderStepped:Connect(function()
        local success, err = pcall(ForceVisibility)
        if not success then
            warn("[Vortex Hub] Erro no loop de visibilidade: " .. err)
        end
    end)
    
    if LocalPlayer.Character then 
        BypassJump(LocalPlayer.Character) 
    end
    LocalPlayer.CharacterAdded:Connect(BypassJump)
    
    local gameStartedConnection = workspace.ChildAdded:Connect(function(child)
        if child.Name == "jogadoresVivos" then
            task.wait(0.5)
            MonitorNewPlayers()
        end
    end)
    table.insert(self.Connections, gameStartedConnection)
    
    local gameEndedConnection = workspace.ChildRemoved:Connect(function(child)
        if child.Name == "jogadoresVivos" then
            self:CleanupHighlights()
        end
    end)
    table.insert(self.Connections, gameEndedConnection)
    
    print("[Blind Shot ESP] Sistema DEFINITIVO inicializado! (Sem ESP Azul)")
end

function BlindShotESP:CleanupHighlights()
    for playerName, highlight in pairs(self.Highlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    self.Highlights = {}
end

function BlindShotESP:Enable()
    if self.Active then return end
    
    self.Active = true
    self:Initialize()
    print("[Blind Shot ESP] Ativado! Interceptação de renderização ativa (Sem ESP Azul)")
end

function BlindShotESP:Disable()
    if not self.Active then return end
    
    self.Active = false
    
    if self.RenderConnection then
        self.RenderConnection:Disconnect()
        self.RenderConnection = nil
    end
    
    for _, conn in ipairs(self.Connections) do
        if conn then
            pcall(function() conn:Disconnect() end)
        end
    end
    
    self.Connections = {}
    
    self:CleanupHighlights()
    
    print("[Blind Shot ESP] Desativado COMPLETAMENTE! (Todos os ESPs removidos)")
end

-- [[ ANTI-AFK SYSTEM (MINIMALISTA E FUNCIONAL) ]]
local AntiAFK = {
    Active = false,
    Connection = nil
}

function AntiAFK:Enable()
    if self.Active then return end
    
    self.Active = true
    
    local VirtualUser = game:GetService("VirtualUser")
    
    self.Connection = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    print("[Vortex Hub] Anti-AFK ativado!")
end

function AntiAFK:Disable()
    if not self.Active then return end
    
    self.Active = false
    
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    print("[Vortex Hub] Anti-AFK desativado!")
end

-- [[ AUTO TROPHY LOOP - CORRIGIDO 15 SEGUNDOS ]]
local AutoTrophyRunning = false
local function StartAutoTrophy()
    if AutoTrophyRunning then return end
    AutoTrophyRunning = true
    
    task.spawn(function()
        print("[Vortex Hub] Auto Trophy iniciado! Teleporta a cada 20 segundos")
        
        while States.Auto_Trophy do
            TeleportToTrophy()
            print("[Vortex Hub] Teleportado para o troféu!")
            
            for i = 1, 20 do
                if not States.Auto_Trophy then break end
                task.wait(1)
            end
        end
        
        AutoTrophyRunning = false
        print("[Vortex Hub] Auto Trophy parado")
    end)
end

-- [[ BRAINROT FARM SCRIPT ]]
local BrainrotFarm = {
    Active = false,
    Connection = nil,
    Running = false
}

local function StartBrainrotFarm()
    if BrainrotFarm.Running then return end
    BrainrotFarm.Running = true
    
    task.spawn(function()
        print("[Vortex Hub] Brainrot Farm iniciado!")
        
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        local brainrotsFolder = workspace:WaitForChild("Brainrots")
        local collectedFolder = player:WaitForChild("brainrotsCollected")
        
        local safePosition = rootPart.CFrame
        local ignoredThisCycle = {}
        
        local function getPos(obj)
            if obj:IsA("BasePart") then
                return obj.CFrame
            elseif obj:IsA("Model") then
                if obj.PrimaryPart then
                    return obj.PrimaryPart.CFrame
                end
                local childPart = obj:FindFirstChildWhichIsA("BasePart", true)
                if childPart then
                    return childPart.CFrame
                end
            end
            return nil
        end
        
        player.CharacterAdded:Connect(function(newCharacter)
            character = newCharacter
            rootPart = character:WaitForChild("HumanoidRootPart")
            safePosition = rootPart.CFrame 
        end)
        
        print("[Vortex Hub] Brainrot Farm: Sistema Anti-Loop Inútil Ativado!")
        
        while States.Brainrot_Farm do
            local allItems = brainrotsFolder:GetChildren()
            local itemEncontrado = false
            
            for i = 1, #allItems do
                local currentItem = allItems[i]
                
                if currentItem and not collectedFolder:FindFirstChild(currentItem.Name) and not ignoredThisCycle[currentItem] then
                    local targetCFrame = getPos(currentItem)
                    
                    if targetCFrame then
                        itemEncontrado = true
                        print("[Vortex Hub] Brainrot Farm: Novo item detectado: " .. currentItem.Name)
                        
                        rootPart.CFrame = targetCFrame
                        task.wait(0.2)
                        
                        rootPart.CFrame = safePosition
                        task.wait(0.1)
                        
                        if not collectedFolder:FindFirstChild(currentItem.Name) then
                            print("[Vortex Hub] Brainrot Farm: Item " .. currentItem.Name .. " não registrou. Ignorando para não ficar preso.")
                            ignoredThisCycle[currentItem] = true
                        end
                    end
                end
            end
            
            if not itemEncontrado then
                if (rootPart.Position - safePosition.Position).Magnitude > 3 then
                    rootPart.CFrame = safePosition
                end
            end

            task.wait(0.1)
        end
        
        BrainrotFarm.Running = false
        print("[Vortex Hub] Brainrot Farm parado")
    end)
end

function BrainrotFarm:Enable()
    if self.Active then return end
    
    self.Active = true
    StartBrainrotFarm()
    print("[Vortex Hub] Brainrot Farm ativado!")
end

function BrainrotFarm:Disable()
    if not self.Active then return end
    
    self.Active = false
    print("[Vortex Hub] Brainrot Farm desativado")
end

-- [[ WESTBOUND SYSTEMS - MODIFICADO COM SCRIPTS ESPECÍFICOS ]]
local Westbound = {
    ESP_Players_Active = false,
    ESP_Animals_Active = false,
    ESP_DistanceName_Active = false,
    ESP_Name_Active = false,
    Connections = {}
}

-- Sistema de ESP para Players usando scripts específicos
function Westbound:ToggleESP_Players(state)
    States.Westbound_ESP_Players = state
    
    if state then
        -- Ativar ESP Players
        if not self.ESP_Players_Active then
            local success, result = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Mickey123m/Vortex-Hub/refs/heads/main/Games/Westbound/ESP/ESP_Players"))()
                print("[Vortex Hub] Westbound: ESP Players ativado com sucesso!")
            end)
            
            if not success then
                warn("[Vortex Hub] Westbound: Erro ao carregar ESP Players: " .. tostring(result))
            else
                self.ESP_Players_Active = true
            end
        end
    else
        -- Desativar ESP Players
        if self.ESP_Players_Active then
            local success, result = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Mickey123m/Vortex-Hub/refs/heads/main/Models/Westbound/ESP_REMOVE/ESP_RemoveESPPlayers"))()
                print("[Vortex Hub] Westbound: ESP Players desativado")
            end)
            
            if not success then
                warn("[Vortex Hub] Westbound: Erro ao desativar ESP Players: " .. tostring(result))
            else
                self.ESP_Players_Active = false
            end
        end
    end
end

-- Sistema de ESP para Animals usando scripts específicos
function Westbound:ToggleESP_Animals(state)
    States.Westbound_ESP_Animals = state
    
    if state then
        -- Ativar ESP Animals
        if not self.ESP_Animals_Active then
            local success, result = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Mickey123m/Vortex-Hub/refs/heads/main/Games/Westbound/ESP/ESP_Animals"))()
                print("[Vortex Hub] Westbound: ESP Animals ativado com sucesso!")
            end)
            
            if not success then
                warn("[Vortex Hub] Westbound: Erro ao carregar ESP Animals: " .. tostring(result))
            else
                self.ESP_Animals_Active = true
            end
        end
    else
        -- Desativar ESP Animals
        if self.ESP_Animals_Active then
            local success, result = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Mickey123m/Vortex-Hub/refs/heads/main/Models/Westbound/ESP_REMOVE/ESP_RemoveESPAnimals"))()
                print("[Vortex Hub] Westbound: ESP Animals desativado")
            end)
            
            if not success then
                warn("[Vortex Hub] Westbound: Erro ao desativar ESP Animals: " .. tostring(result))
            else
                self.ESP_Animals_Active = false
            end
        end
    end
end

-- Sistema de ESP Distance + Name usando scripts específicos
function Westbound:ToggleESP_DistanceName(state)
    States.Westbound_ESP_DistanceName = state
    
    if state then
        -- Ativar ESP Distance + Name
        if not self.ESP_DistanceName_Active then
            local success, result = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Mickey123m/Vortex-Hub/refs/heads/main/Games/Westbound/ESP/ESP_DistanceEName"))()
                print("[Vortex Hub] Westbound: ESP Distance + Name ativado com sucesso!")
            end)
            
            if not success then
                warn("[Vortex Hub] Westbound: Erro ao carregar ESP Distance + Name: " .. tostring(result))
            else
                self.ESP_DistanceName_Active = true
            end
        end
    else
        -- Desativar ESP Distance + Name
        if self.ESP_DistanceName_Active then
            local success, result = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Mickey123m/Vortex-Hub/refs/heads/main/Models/Westbound/ESP_REMOVE/ESP_RemoveESPDistanceEName"))()
                print("[Vortex Hub] Westbound: ESP Distance + Name desativado")
            end)
            
            if not success then
                warn("[Vortex Hub] Westbound: Erro ao desativar ESP Distance + Name: " .. tostring(result))
            else
                self.ESP_DistanceName_Active = false
            end
        end
    end
end

-- Sistema de ESP Name usando scripts específicos
function Westbound:ToggleESP_Name(state)
    States.Westbound_ESP_Name = state
    
    if state then
        -- Ativar ESP Name
        if not self.ESP_Name_Active then
            local success, result = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Mickey123m/Vortex-Hub/refs/heads/main/Games/Westbound/ESP/ESP_Name"))()
                print("[Vortex Hub] Westbound: ESP Name ativado com sucesso!")
            end)
            
            if not success then
                warn("[Vortex Hub] Westbound: Erro ao carregar ESP Name: " .. tostring(result))
            else
                self.ESP_Name_Active = true
            end
        end
    else
        -- Desativar ESP Name
        if self.ESP_Name_Active then
            local success, result = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Mickey123m/Vortex-Hub/refs/heads/main/Models/Westbound/ESP_REMOVE/ESP_RemoveESPName"))()
                print("[Vortex Hub] Westbound: ESP Name desativado")
            end)
            
            if not success then
                warn("[Vortex Hub] Westbound: Erro ao desativar ESP Name: " .. tostring(result))
            else
                self.ESP_Name_Active = false
            end
        end
    end
end

-- Função de limpeza completa
function Westbound:Cleanup()
    -- Desativar todos os ESPs
    self:ToggleESP_Players(false)
    self:ToggleESP_Animals(false)
    self:ToggleESP_DistanceName(false)
    self:ToggleESP_Name(false)
    
    -- Limpar conexões
    for _, conn in ipairs(self.Connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    self.Connections = {}
    
    -- Reset states
    States.Westbound_ESP_Players = false
    States.Westbound_ESP_Animals = false
    States.Westbound_ESP_DistanceName = false
    States.Westbound_ESP_Name = false
    
    print("[Vortex Hub] Westbound: Todos os sistemas desativados")
end

-- [[ FNAF: ETERNAL NIGHTS SYSTEMS ]]
local FNAF = {}

-- [[ ESP SYSTEMS FOR FNAF ]]
function FNAF:ApplyESP_Animatronics()
    if not States.FNAF_ESP_Animatronics and not States.FNAF_ESP_All then
        pcall(function()
            local gameFolder = workspace:WaitForChild("Game")
            local mainAnimFolder = gameFolder:WaitForChild("Animatronics")
            local animatronicsFolder = mainAnimFolder:WaitForChild("Animatronics")
            
            for _, anim in ipairs(animatronicsFolder:GetChildren()) do
                if anim:FindFirstChild("Anim_ESP_Internal") then
                    anim.Anim_ESP_Internal:Destroy()
                end
            end
        end)
        return
    end
    
    pcall(function()
        local Workspace = game:GetService("Workspace")
        
        local gameFolder = Workspace:WaitForChild("Game")
        local mainAnimFolder = gameFolder:WaitForChild("Animatronics")
        local animatronicsFolder = mainAnimFolder:WaitForChild("Animatronics")
        
        local characterColors = {
            ["Bonnie"] = Color3.fromRGB(106, 90, 205),
            ["Chica"] = Color3.fromRGB(255, 255, 0),
            ["Cupcake"] = Color3.fromRGB(255, 105, 180),
            ["Foxy"] = Color3.fromRGB(255, 0, 0),
            ["Freddy"] = Color3.fromRGB(139, 69, 19),
            ["Puppet"] = Color3.fromRGB(255, 255, 255)
        }
        
        local function applyAnimatronicESP(animatronic)
            if animatronic:FindFirstChild("Anim_ESP_Internal") then return end
            
            task.wait(0.2) 
            
            local container = Instance.new("Folder")
            container.Name = "Anim_ESP_Internal"
            container.Parent = animatronic
            
            local highlightColor = Color3.fromRGB(200, 200, 200)
            for name, color in pairs(characterColors) do
                if string.find(animatronic.Name, name) then
                    highlightColor = color
                    break
                end
            end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "Outline"
            highlight.Adornee = animatronic
            highlight.FillColor = highlightColor
            highlight.FillTransparency = 0.6
            highlight.OutlineColor = highlightColor
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = container
            
            local root = animatronic:IsA("Model") and (animatronic.PrimaryPart or animatronic:FindFirstChildWhichIsA("BasePart", true)) or animatronic
            
            if root then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NameTag"
                billboard.Adornee = root
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 4, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = container
                
                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = animatronic.Name
                label.TextColor3 = highlightColor
                label.TextStrokeTransparency = 0
                label.TextSize = 20
                label.Font = Enum.Font.SourceSansBold
                label.Parent = billboard
            end
        end
        
        local connection = animatronicsFolder.ChildAdded:Connect(function(child)
            applyAnimatronicESP(child)
        end)
        table.insert(States.FNAF_ESP_Connections, connection)
        
        for _, anim in ipairs(animatronicsFolder:GetChildren()) do
            applyAnimatronicESP(anim)
        end
        
        print("[Vortex Hub] FNAF: ESP Animatrônicos Ativado")
    end)
end

function FNAF:ApplyESP_Fuses()
    if not States.FNAF_ESP_Fuses and not States.FNAF_ESP_All then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Fuse" and obj:FindFirstChild("Item_ESP_Internal") then
                obj.Item_ESP_Internal:Destroy()
            end
        end
        return
    end
    
    pcall(function()
        local Workspace = game:GetService("Workspace")
        local targetName = "Fuse"
        
        local function applyESP(item)
            if item:FindFirstChild("Item_ESP_Internal") then return end
            task.wait(0.1)
            
            local container = Instance.new("Folder")
            container.Name = "Item_ESP_Internal"
            container.Parent = item
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "Outline"
            highlight.Adornee = item
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = container
            
            local targetPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
            
            if targetPart then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NomeTag"
                billboard.Adornee = targetPart
                billboard.Size = UDim2.new(0, 150, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 1.8, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = container
                
                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = targetName
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.TextSize = 14
                label.Font = Enum.Font.SourceSansBold
                label.Parent = billboard
            end
        end
        
        local connection = Workspace.DescendantAdded:Connect(function(obj)
            if obj.Name == targetName then 
                applyESP(obj) 
            end
        end)
        table.insert(States.FNAF_ESP_Connections, connection)
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == targetName then 
                applyESP(obj) 
            end
        end
        
        print("[Vortex Hub] FNAF: ESP Fuses Ativado")
    end)
end

function FNAF:ApplyESP_Batteries()
    if not States.FNAF_ESP_Batteries and not States.FNAF_ESP_All then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Battery" and obj:FindFirstChild("Item_ESP_Internal") then
                obj.Item_ESP_Internal:Destroy()
            end
        end
        return
    end
    
    pcall(function()
        local Workspace = game:GetService("Workspace")
        local targetName = "Battery"
        
        local function applyESP(item)
            if item:FindFirstChild("Item_ESP_Internal") then return end
            task.wait(0.1)
            
            local container = Instance.new("Folder")
            container.Name = "Item_ESP_Internal"
            container.Parent = item
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "Outline"
            highlight.Adornee = item
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = container
            
            local targetPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
            if targetPart then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NomeTag"
                billboard.Adornee = targetPart
                billboard.Size = UDim2.new(0, 150, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 1.8, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = container
                
                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = targetName
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.TextSize = 14
                label.Font = Enum.Font.SourceSansBold
                label.Parent = billboard
            end
        end
        
        local connection = Workspace.DescendantAdded:Connect(function(obj)
            if obj.Name == targetName then applyESP(obj) end
        end)
        table.insert(States.FNAF_ESP_Connections, connection)
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == targetName then applyESP(obj) end
        end
        
        print("[Vortex Hub] FNAF: ESP Batteries Ativado")
    end)
end

function FNAF:ApplyESP_Pliers()
    if not States.FNAF_ESP_Pliers and not States.FNAF_ESP_All then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Pliers" and obj:FindFirstChild("Item_ESP_Internal") then
                obj.Item_ESP_Internal:Destroy()
            end
        end
        return
    end
    
    pcall(function()
        local Workspace = game:GetService("Workspace")
        local targetName = "Pliers"
        
        local function applyESP(item)
            if item:FindFirstChild("Item_ESP_Internal") then return end
            task.wait(0.1)
            
            local container = Instance.new("Folder")
            container.Name = "Item_ESP_Internal"
            container.Parent = item
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "Outline"
            highlight.Adornee = item
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = container
            
            local targetPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
            if targetPart then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NomeTag"
                billboard.Adornee = targetPart
                billboard.Size = UDim2.new(0, 150, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 1.8, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = container
                
                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = targetName
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.TextSize = 14
                label.Font = Enum.Font.SourceSansBold
                label.Parent = billboard
            end
        end
        
        local connection = Workspace.DescendantAdded:Connect(function(obj)
            if obj.Name == targetName then applyESP(obj) end
        end)
        table.insert(States.FNAF_ESP_Connections, connection)
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == targetName then applyESP(obj) end
        end
        
        print("[Vortex Hub] FNAF: ESP Pliers Ativado")
    end)
end

function FNAF:ApplyESP_Screwdriver()
    if not States.FNAF_ESP_Screwdriver and not States.FNAF_ESP_All then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Phillips screwdriver" and obj:FindFirstChild("Item_ESP_Internal") then
                obj.Item_ESP_Internal:Destroy()
            end
        end
        return
    end
    
    pcall(function()
        local Workspace = game:GetService("Workspace")
        local targetName = "Phillips screwdriver"
        
        local function applyESP(item)
            if item:FindFirstChild("Item_ESP_Internal") then return end
            task.wait(0.1)
            
            local container = Instance.new("Folder")
            container.Name = "Item_ESP_Internal"
            container.Parent = item
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "Outline"
            highlight.Adornee = item
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = container
            
            local targetPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
            if targetPart then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NomeTag"
                billboard.Adornee = targetPart
                billboard.Size = UDim2.new(0, 150, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 1.8, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = container
                
                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = targetName
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.TextSize = 14
                label.Font = Enum.Font.SourceSansBold
                label.Parent = billboard
            end
        end
        
        local connection = Workspace.DescendantAdded:Connect(function(obj)
            if obj.Name == targetName then applyESP(obj) end
        end)
        table.insert(States.FNAF_ESP_Connections, connection)
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == targetName then applyESP(obj) end
        end
        
        print("[Vortex Hub] FNAF: ESP Screwdriver Ativado")
    end)
end

function FNAF:ApplyAllESP()
    if States.FNAF_ESP_All then
        self:ApplyESP_Animatronics()
        self:ApplyESP_Fuses()
        self:ApplyESP_Batteries()
        self:ApplyESP_Pliers()
        self:ApplyESP_Screwdriver()
    else
        for _, conn in ipairs(States.FNAF_ESP_Connections) do
            if conn and conn.Connected then
                conn:Disconnect()
            end
        end
        States.FNAF_ESP_Connections = {}
        
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("Item_ESP_Internal") then
                obj.Item_ESP_Internal:Destroy()
            end
            if obj:FindFirstChild("Anim_ESP_Internal") then
                obj.Anim_ESP_Internal:Destroy()
            end
        end
    end
end

-- [[ FULL BRIGHT FOR FNAF ]]
function FNAF:ToggleFullBright(state)
    States.FNAF_FullBright = state
    
    if state then
        local function applyFullBright()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        end
        
        applyFullBright()
        
        States.FNAF_Lighting_Connection = Lighting:GetPropertyChangedSignal("Brightness"):Connect(applyFullBright)
        States.FNAF_Lighting_Connection2 = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(applyFullBright)
        States.FNAF_Lighting_Connection3 = Lighting:GetPropertyChangedSignal("Ambient"):Connect(applyFullBright)
        States.FNAF_Lighting_Connection4 = Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(applyFullBright)
        
        print("[Vortex Hub] FNAF: Full Bright Ativado")
    else
        if States.FNAF_Lighting_Connection then
            States.FNAF_Lighting_Connection:Disconnect()
            States.FNAF_Lighting_Connection = nil
        end
        if States.FNAF_Lighting_Connection2 then
            States.FNAF_Lighting_Connection2:Disconnect()
            States.FNAF_Lighting_Connection2 = nil
        end
        if States.FNAF_Lighting_Connection3 then
            States.FNAF_Lighting_Connection3:Disconnect()
            States.FNAF_Lighting_Connection3 = nil
        end
        if States.FNAF_Lighting_Connection4 then
            States.FNAF_Lighting_Connection4:Disconnect()
            States.FNAF_Lighting_Connection4 = nil
        end
        
        print("[Vortex Hub] FNAF: Full Bright Desativado")
    end
end

-- [[ SPEED HACK FOR FNAF ]]
function FNAF:ToggleSpeedHack(state)
    States.FNAF_SpeedHack = state
    
    if state then
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        
        local velocidadeMaxima = 35
        
        local function hackMovimentacao()
            local character = player.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local values = character:FindFirstChild("Values")
            
            if humanoid then
                if humanoid.WalkSpeed < velocidadeMaxima then
                    humanoid.WalkSpeed = velocidadeMaxima
                end
            end
            
            if values then
                for _, obj in ipairs(values:GetChildren()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        if obj.Name:lower():find("stamina") or obj.Name:lower():find("energy") or obj.Name:lower():find("folego") then
                            obj.Value = 100
                        end
                        
                        if obj.Name == "Speed" then
                            obj.Value = velocidadeMaxima
                        end
                    end
                    
                    if obj:IsA("BoolValue") and (obj.Name:lower():find("tired") or obj.Name:lower():find("cansado")) then
                        obj.Value = false
                    end
                end
            end
        end
        
        States.FNAF_Speed_Connection = RunService.Heartbeat:Connect(hackMovimentacao)
        
        print("[Vortex Hub] FNAF: Speed Hack Ativado")
    else
        if States.FNAF_Speed_Connection then
            States.FNAF_Speed_Connection:Disconnect()
            States.FNAF_Speed_Connection = nil
        end
        
        print("[Vortex Hub] FNAF: Speed Hack Desativado")
    end
end

-- [[ PULL ITEMS SYSTEMS FOR FNAF - MODIFICADO PARA BUTTONS "EXECUTE" ]]
function FNAF:Pull_Batteries_Execute()
    for i, conn in ipairs(States.FNAF_Pull_Connections) do
        if conn.targetName == "Battery" then
            if conn.connection and conn.connection.Connected then
                conn.connection:Disconnect()
            end
            table.remove(States.FNAF_Pull_Connections, i)
            break
        end
    end
    
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    
    local player = Players.LocalPlayer
    local targetName = "Battery"
    
    local function pullItem(item)
        task.wait(0.1)
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local targetPos = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            if item:IsA("Model") then
                item:PivotTo(targetPos)
            elseif item:IsA("BasePart") then
                item.CFrame = targetPos
            end
        end
    end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == targetName then pullItem(obj) end
    end
    
    print("[Vortex Hub] FNAF: Pull Batteries Executado")
end

function FNAF:Pull_Screwdriver_Execute()
    for i, conn in ipairs(States.FNAF_Pull_Connections) do
        if conn.targetName == "Phillips screwdriver" then
            if conn.connection and conn.connection.Connected then
                conn.connection:Disconnect()
            end
            table.remove(States.FNAF_Pull_Connections, i)
            break
        end
    end
    
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    
    local player = Players.LocalPlayer
    local targetName = "Phillips screwdriver"
    
    local function pullItem(item)
        task.wait(0.1)
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local targetPos = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            if item:IsA("Model") then
                item:PivotTo(targetPos)
            elseif item:IsA("BasePart") then
                item.CFrame = targetPos
            end
        end
    end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == targetName then pullItem(obj) end
    end
    
    print("[Vortex Hub] FNAF: Pull Screwdriver Executado")
end

function FNAF:Pull_Pliers_Execute()
    for i, conn in ipairs(States.FNAF_Pull_Connections) do
        if conn.targetName == "Pliers" then
            if conn.connection and conn.connection.Connected then
                conn.connection:Disconnect()
            end
            table.remove(States.FNAF_Pull_Connections, i)
            break
        end
    end
    
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    
    local player = Players.LocalPlayer
    local targetName = "Pliers"
    
    local function pullItem(item)
        task.wait(0.1)
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local targetPos = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            if item:IsA("Model") then
                item:PivotTo(targetPos)
            elseif item:IsA("BasePart") then
                item.CFrame = targetPos
            end
        end
    end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == targetName then pullItem(obj) end
    end
    
    print("[Vortex Hub] FNAF: Pull Pliers Executado")
end

function FNAF:Pull_Fuses_Execute()
    for i, conn in ipairs(States.FNAF_Pull_Connections) do
        if conn.targetName == "Fuse" then
            if conn.connection and conn.connection.Connected then
                conn.connection:Disconnect()
            end
            table.remove(States.FNAF_Pull_Connections, i)
            break
        end
    end
    
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    
    local player = Players.LocalPlayer
    local targetName = "Fuse"
    
    local function pullItem(item)
        if item:IsA("BasePart") or item:IsA("Model") then
            task.wait(0.1)
            
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetPos = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                
                if item:IsA("Model") then
                    item:PivotTo(targetPos)
                else
                    item.CFrame = targetPos
                end
            end
        end
    end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == targetName then
            pullItem(obj)
        end
    end
    
    print("[Vortex Hub] FNAF: Pull Fuses Executado")
end

function FNAF:Pull_All_Execute()
    for _, conn in ipairs(States.FNAF_Pull_Connections) do
        if conn.connection and conn.connection.Connected then
            conn.connection:Disconnect()
        end
    end
    States.FNAF_Pull_Connections = {}
    
    self:Pull_Batteries_Execute()
    self:Pull_Screwdriver_Execute()
    self:Pull_Pliers_Execute()
    self:Pull_Fuses_Execute()
    
    print("[Vortex Hub] FNAF: Todos os Pulls Executados")
end

-- [[ TELEPORT FUNCTIONS FOR FNAF ]]
function FNAF:TeleportSecurityRoom()
    pcall(function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        
        local player = Players.LocalPlayer
        local target = Workspace:WaitForChild("Game"):WaitForChild("Sistema"):WaitForChild("DoorSecurity"):WaitForChild("PackDoor"):WaitForChild("Door"):WaitForChild("Grade")
        
        local function teleport()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                if target:IsA("BasePart") or target:IsA("MeshPart") then
                    character:PivotTo(target.CFrame * CFrame.new(0, 3, 0))
                else
                    character:PivotTo(target:GetPivot() * CFrame.new(0, 3, 0))
                end
            end
        end
        
        teleport()
        print("[Vortex Hub] FNAF: Teleportado para Sala de Segurança")
    end)
end

function FNAF:TeleportPuppetClock()
    pcall(function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        
        local player = Players.LocalPlayer
        local target = Workspace:WaitForChild("Game"):WaitForChild("Sistema"):WaitForChild("Puppet"):WaitForChild("Door")
        
        local function teleport()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetPos = target:GetPivot()
                character:PivotTo(targetPos * CFrame.new(0, 3, 0))
            end
        end
        
        teleport()
        print("[Vortex Hub] FNAF: Teleportado para Relógio da Puppet")
    end)
end

function FNAF:TeleportAboveMap()
    pcall(function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        local function teleportUp()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local newPos = hrp.CFrame + Vector3.new(0, 200, 0)
                character:PivotTo(newPos)
            end
        end
        
        teleportUp()
        print("[Vortex Hub] FNAF: Teleportado para cima do mapa")
    end)
end

function FNAF:TeleportFuseRoom()
    pcall(function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        
        local player = Players.LocalPlayer
        local target = Workspace:WaitForChild("Game"):WaitForChild("Sistema"):WaitForChild("Gerador"):WaitForChild("Fusiveis")
        
        local function teleport()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetPos = target:GetPivot()
                character:PivotTo(targetPos * CFrame.new(0, 3, 0))
            end
        end
        
        teleport()
        print("[Vortex Hub] FNAF: Teleportado para Sala dos Fusíveis")
    end)
end

-- [[ CLEANUP FNAF ]]
function FNAF:Cleanup()
    for _, conn in ipairs(States.FNAF_ESP_Connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    States.FNAF_ESP_Connections = {}
    
    for _, conn in ipairs(States.FNAF_Pull_Connections) do
        if conn.connection and conn.connection.Connected then
            conn.connection:Disconnect()
        end
    end
    States.FNAF_Pull_Connections = {}
    
    if States.FNAF_Lighting_Connection then
        States.FNAF_Lighting_Connection:Disconnect()
        States.FNAF_Lighting_Connection = nil
    end
    if States.FNAF_Lighting_Connection2 then
        States.FNAF_Lighting_Connection2:Disconnect()
        States.FNAF_Lighting_Connection2 = nil
    end
    if States.FNAF_Lighting_Connection3 then
        States.FNAF_Lighting_Connection3:Disconnect()
        States.FNAF_Lighting_Connection3 = nil
    end
    if States.FNAF_Lighting_Connection4 then
        States.FNAF_Lighting_Connection4:Disconnect()
        States.FNAF_Lighting_Connection4 = nil
    end
    
    if States.FNAF_Speed_Connection then
        States.FNAF_Speed_Connection:Disconnect()
        States.FNAF_Speed_Connection = nil
    end
    
    States.FNAF_ESP_Animatronics = false
    States.FNAF_ESP_Fuses = false
    States.FNAF_ESP_Batteries = false
    States.FNAF_ESP_Pliers = false
    States.FNAF_ESP_Screwdriver = false
    States.FNAF_ESP_All = false
    States.FNAF_FullBright = false
    States.FNAF_SpeedHack = false
    States.FNAF_Pull_Batteries = false
    States.FNAF_Pull_Screwdriver = false
    States.FNAF_Pull_Pliers = false
    States.FNAF_Pull_Fuses = false
    States.FNAF_Pull_All = false
    
    print("[Vortex Hub] FNAF: Todos os sistemas desativados")
end

-- [[ INTERFACE ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VortexHub_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999999

local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
ScreenGui.Parent = success and coreGui or LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 450)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromHex("17171C")
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Selectable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Name = "MainStroke"
MainStroke.Thickness = 1
MainStroke.Color = Color3.fromHex("25252D")
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.LineJoinMode = Enum.LineJoinMode.Round
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromHex("1C1C22")
TopBar.BorderSizePixel = 0
TopBar.Active = true
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local HeaderSeparator = Instance.new("Frame")
HeaderSeparator.Name = "Separator"
HeaderSeparator.Size = UDim2.new(1, 0, 0, 1)
HeaderSeparator.Position = UDim2.new(0, 0, 0, 38)
HeaderSeparator.BackgroundColor3 = Color3.fromHex("25252D")
HeaderSeparator.BorderSizePixel = 0
HeaderSeparator.ZIndex = 5
HeaderSeparator.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "VORTEX HUB"
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color3.fromRGB(138, 43, 226)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local VersionLabelTop = Instance.new("TextLabel")
VersionLabelTop.Text = "v2.3.0"
VersionLabelTop.Size = UDim2.new(0, 50, 1, 0)
VersionLabelTop.Position = UDim2.new(0, 105, 0, 0)
VersionLabelTop.TextColor3 = Color3.fromRGB(120, 120, 120)
VersionLabelTop.Font = Enum.Font.Gotham
VersionLabelTop.TextSize = 11
VersionLabelTop.BackgroundTransparency = 1
VersionLabelTop.TextXAlignment = Enum.TextXAlignment.Left
VersionLabelTop.Parent = TopBar

local ButtonHolder = Instance.new("Frame")
ButtonHolder.Size = UDim2.new(0, 40, 1, 0)
ButtonHolder.Position = UDim2.new(1, -45, 0, 0)
ButtonHolder.BackgroundTransparency = 1
ButtonHolder.Parent = TopBar

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = ButtonHolder

local function CreateTopButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Parent = ButtonHolder

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    return btn
end

local CloseBtn = CreateTopButton("X", 1)

local function ApplyHover(button, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0,
            BackgroundColor3 = hoverColor,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(150, 150, 150)
        }):Play()
    end)
end

ApplyHover(CloseBtn, Color3.fromRGB(200, 45, 45))

-- [[ LEFT SIDEBAR ]]
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 150, 1, -38)
SideBar.Position = UDim2.new(0, 0, 0, 38)
SideBar.BackgroundColor3 = Color3.fromHex("121216")
SideBar.BorderSizePixel = 0
SideBar.Active = true
SideBar.Parent = MainFrame

local SideBarCorner = Instance.new("UICorner")
SideBarCorner.CornerRadius = UDim.new(0, 8)
SideBarCorner.Parent = SideBar

local SideBarFix = Instance.new("Frame")
SideBarFix.Name = "Fix"
SideBarFix.Size = UDim2.new(0, 20, 1, 0)
SideBarFix.Position = UDim2.new(1, -20, 0, 0)
SideBarFix.BackgroundColor3 = Color3.fromHex("121216")
SideBarFix.BorderSizePixel = 0
SideBarFix.Parent = SideBar

local VerticalSeparator = Instance.new("Frame")
VerticalSeparator.Size = UDim2.new(0, 1, 1, 0)
VerticalSeparator.Position = UDim2.new(1, 0, 0, 0)
VerticalSeparator.BackgroundColor3 = Color3.fromHex("25252D")
VerticalSeparator.BorderSizePixel = 0
VerticalSeparator.Parent = SideBar

local SideTitle = Instance.new("TextLabel")
SideTitle.Text = "VORTEX HUB"
SideTitle.Size = UDim2.new(1, 0, 0, 45)
SideTitle.Position = UDim2.new(0, 15, 0, 0)
SideTitle.TextColor3 = Color3.fromRGB(138, 43, 226)
SideTitle.Font = Enum.Font.GothamBold
SideTitle.TextSize = 16
SideTitle.BackgroundTransparency = 1
SideTitle.TextXAlignment = Enum.TextXAlignment.Left
SideTitle.Parent = SideBar

local Line1 = Instance.new("Frame")
Line1.Size = UDim2.new(1, 0, 0, 1)
Line1.Position = UDim2.new(0, 0, 0, 45)
Line1.BackgroundColor3 = Color3.fromHex("25252D")
Line1.BorderSizePixel = 0
Line1.Parent = SideBar

-- Profile
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(1, 0, 0, 60)
ProfileFrame.Position = UDim2.new(0, 0, 0, 46)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Active = true
ProfileFrame.Parent = SideBar

local ProfileImage = Instance.new("ImageLabel")
ProfileImage.Size = UDim2.new(0, 35, 0, 35)
ProfileImage.Position = UDim2.new(0, 15, 0.5, -17)
ProfileImage.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
ProfileImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
ProfileImage.Parent = ProfileFrame
Instance.new("UICorner", ProfileImage).CornerRadius = UDim.new(1, 0)

local PlayerName = Instance.new("TextLabel")
PlayerName.Text = LocalPlayer.DisplayName
PlayerName.Size = UDim2.new(1, -60, 0, 15)
PlayerName.Position = UDim2.new(0, 58, 0.5, -12)
PlayerName.TextColor3 = Color3.new(1, 1, 1)
PlayerName.Font = Enum.Font.GothamBold; PlayerName.TextSize = 11
PlayerName.BackgroundTransparency = 1; PlayerName.TextXAlignment = Enum.TextXAlignment.Left
PlayerName.Parent = ProfileFrame

local PlayerTag = Instance.new("TextLabel")
PlayerTag.Text = "@" .. LocalPlayer.Name
PlayerTag.Size = UDim2.new(1, -60, 0, 15)
PlayerTag.Position = UDim2.new(0, 58, 0.5, 2)
PlayerTag.TextColor3 = Color3.fromRGB(150, 150, 150)
PlayerTag.Font = Enum.Font.Gotham; PlayerTag.TextSize = 10
PlayerTag.BackgroundTransparency = 1; PlayerTag.TextXAlignment = Enum.TextXAlignment.Left
PlayerTag.Parent = ProfileFrame

local Line2 = Instance.new("Frame")
Line2.Size = UDim2.new(1, 0, 0, 1)
Line2.Position = UDim2.new(0, 0, 0, 106)
Line2.BackgroundColor3 = Color3.fromHex("25252D")
Line2.BorderSizePixel = 0
Line2.Parent = SideBar

local GamesLabel = Instance.new("TextLabel")
GamesLabel.Text = "GAMES"
GamesLabel.Size = UDim2.new(1, -30, 0, 30)
GamesLabel.Position = UDim2.new(0, 15, 0, 107)
GamesLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
GamesLabel.Font = Enum.Font.GothamBold; GamesLabel.TextSize = 9
GamesLabel.BackgroundTransparency = 1; GamesLabel.TextXAlignment = Enum.TextXAlignment.Left
GamesLabel.Parent = SideBar

-- [[ RIGHT CONTENT AREA ]]
local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.Size = UDim2.new(1, -151, 1, -38)
ContentHolder.Position = UDim2.new(0, 151, 0, 38)
ContentHolder.BackgroundTransparency = 1
ContentHolder.ClipsDescendants = true
ContentHolder.Parent = MainFrame

local WelcomePage = Instance.new("Frame")
WelcomePage.Name = "WelcomePage"
WelcomePage.Size = UDim2.new(1, 0, 1, 0)
WelcomePage.BackgroundTransparency = 1
WelcomePage.Visible = true
WelcomePage.Parent = ContentHolder

local WelcomeTitle = Instance.new("TextLabel")
WelcomeTitle.Text = "WELCOME TO VORTEX HUB"
WelcomeTitle.Size = UDim2.new(1, 0, 0, 20)
WelcomeTitle.Position = UDim2.new(0, 0, 0.5, -15)
WelcomeTitle.Font = Enum.Font.GothamBold; WelcomeTitle.TextSize = 16; WelcomeTitle.TextColor3 = Color3.fromRGB(138, 43, 226)
WelcomeTitle.BackgroundTransparency = 1; WelcomeTitle.Parent = WelcomePage

local WelcomeSub = Instance.new("TextLabel")
WelcomeSub.Text = "Select a game from the sidebar to begin"
WelcomeSub.Size = UDim2.new(1, 0, 0, 20)
WelcomeSub.Position = UDim2.new(0, 0, 0.5, 10)
WelcomeSub.Font = Enum.Font.Gotham; WelcomeSub.TextSize = 12; WelcomeSub.TextColor3 = Color3.fromRGB(150, 150, 150)
WelcomeSub.BackgroundTransparency = 1; WelcomeSub.Parent = WelcomePage

-- [[ COMPONENT FUNCTIONS ]]
local function CreateSection(parent, name)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = name .. "_Section"
    SectionFrame.Size = UDim2.new(1, 0, 0, 25)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = parent

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 6, 0, 6)
    Dot.Position = UDim2.new(0, 0, 0.5, -3)
    Dot.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    Dot.BorderSizePixel = 0
    Dot.Parent = SectionFrame
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local T = Instance.new("TextLabel")
    T.Text = name:upper()
    T.Size = UDim2.new(1, -15, 1, 0)
    T.Position = UDim2.new(0, 15, 0, 0)
    T.Font = Enum.Font.GothamBold; T.TextSize = 10; T.TextColor3 = Color3.fromRGB(100, 100, 100)
    T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = SectionFrame
end

local function CreateToggle(parent, name, desc, tag, callback)
    local Card = Instance.new("Frame")
    Card.Name = name .. "_Card"
    Card.BackgroundColor3 = Color3.fromHex("1C1C22")
    Card.Size = UDim2.new(0, 240, 0, 100) 
    Card.Parent = parent

    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromHex("25252D")
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    local T = Instance.new("TextLabel")
    T.Text = name; T.Size = UDim2.new(1, -80, 0, 20); T.Position = UDim2.new(0, 12, 0, 12)
    T.Font = Enum.Font.GothamBold; T.TextSize = 13; T.TextColor3 = Color3.new(1,1,1); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left; T.Parent = Card

    local D = Instance.new("TextLabel")
    D.Text = desc; D.Size = UDim2.new(1, -85, 0, 35); D.Position = UDim2.new(0, 12, 0, 32)
    D.Font = Enum.Font.Gotham; D.TextSize = 10; D.TextColor3 = Color3.fromRGB(120,120,120); D.BackgroundTransparency = 1; D.TextXAlignment = Enum.TextXAlignment.Left; D.TextWrapped = true; D.Parent = Card

    local TagFrame = Instance.new("Frame")
    TagFrame.Size = UDim2.new(0, 55, 0, 18); TagFrame.Position = UDim2.new(0, 12, 1, -28)
    TagFrame.BackgroundColor3 = Color3.fromHex("25252D"); TagFrame.Parent = Card
    Instance.new("UICorner", TagFrame).CornerRadius = UDim.new(0, 4)

    local TagLabel = Instance.new("TextLabel")
    TagLabel.Text = tag:upper(); TagLabel.Size = UDim2.new(1, 0, 1, 0)
    TagLabel.Font = Enum.Font.GothamBold; TagLabel.TextSize = 8; TagLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    TagLabel.BackgroundTransparency = 1; TagLabel.Parent = TagFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 55, 0, 26); Btn.Position = UDim2.new(1, -67, 0.5, -13)
    Btn.BackgroundColor3 = Color3.fromHex("25252D"); Btn.Text = "OFF"; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 11; Btn.TextColor3 = Color3.new(1,1,1); Btn.Parent = Card
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = state and "ON" or "OFF"
        Btn.BackgroundColor3 = state and Color3.fromRGB(138, 43, 226) or Color3.fromHex("25252D")
        callback(state)
        if string.find(name:lower(), "esp") then
            ESP.UpdateAllESPs()
        end
    end)
end

local function CreateButton(parent, name, desc, tag, callback)
    local Card = Instance.new("Frame")
    Card.Name = name .. "_Card"
    Card.BackgroundColor3 = Color3.fromHex("1C1C22")
    Card.Size = UDim2.new(0, 240, 0, 100) 
    Card.Parent = parent

    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromHex("25252D")
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    local T = Instance.new("TextLabel")
    T.Text = name; T.Size = UDim2.new(1, -90, 0, 20); T.Position = UDim2.new(0, 12, 0, 12)
    T.Font = Enum.Font.GothamBold; T.TextSize = 13; T.TextColor3 = Color3.new(1,1,1); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left; T.Parent = Card

    local D = Instance.new("TextLabel")
    D.Text = desc; D.Size = UDim2.new(1, -95, 0, 35); D.Position = UDim2.new(0, 12, 0, 32)
    D.Font = Enum.Font.Gotham; D.TextSize = 10; D.TextColor3 = Color3.fromRGB(120,120,120); D.BackgroundTransparency = 1; D.TextXAlignment = Enum.TextXAlignment.Left; D.TextWrapped = true; D.Parent = Card

    local TagFrame = Instance.new("Frame")
    TagFrame.Size = UDim2.new(0, 55, 0, 18); TagFrame.Position = UDim2.new(0, 12, 1, -28)
    TagFrame.BackgroundColor3 = Color3.fromHex("25252D"); TagFrame.Parent = Card
    Instance.new("UICorner", TagFrame).CornerRadius = UDim.new(0, 4)

    local TagLabel = Instance.new("TextLabel")
    TagLabel.Text = tag:upper(); TagLabel.Size = UDim2.new(1, 0, 1, 0)
    TagLabel.Font = Enum.Font.GothamBold; TagLabel.TextSize = 8; TagLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    TagLabel.BackgroundTransparency = 1; TagLabel.Parent = TagFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 70, 0, 28); Btn.Position = UDim2.new(1, -82, 0.5, -14)
    Btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226); Btn.Text = "Execute"; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 11; Btn.TextColor3 = Color3.new(1,1,1); Btn.Parent = Card
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(callback)
end

-- [[ PAGE CONTAINER ]]
local GamePages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = ContentHolder

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 15)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Parent = Page

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 20)
    Padding.PaddingTop = UDim.new(0, 20)
    Padding.PaddingRight = UDim.new(0, 25)
    Padding.PaddingBottom = UDim.new(0, 30)
    Padding.Parent = Page

    local PageHeader = Instance.new("Frame")
    PageHeader.Size = UDim2.new(1, 0, 0, 60)
    PageHeader.BackgroundTransparency = 1
    PageHeader.Parent = Page

    local PageTitleLabel = Instance.new("TextLabel")
    PageTitleLabel.Text = name
    PageTitleLabel.Size = UDim2.new(1, 0, 0, 25)
    PageTitleLabel.Font = Enum.Font.GothamBold
    PageTitleLabel.TextSize = 18
    PageTitleLabel.TextColor3 = Color3.new(1,1,1)
    PageTitleLabel.BackgroundTransparency = 1
    PageTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    PageTitleLabel.Parent = PageHeader

    local PageSubLabel = Instance.new("TextLabel")
    PageSubLabel.Text = "Scripts and utilities available"
    PageSubLabel.Size = UDim2.new(1, 0, 0, 15)
    PageSubLabel.Position = UDim2.new(0, 0, 0, 28)
    PageSubLabel.Font = Enum.Font.Gotham
    PageSubLabel.TextSize = 11
    PageSubLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    PageSubLabel.BackgroundTransparency = 1
    PageSubLabel.TextXAlignment = Enum.TextXAlignment.Left
    PageSubLabel.Parent = PageHeader

    local PageSeparator = Instance.new("Frame")
    PageSeparator.Size = UDim2.new(1, 40, 0, 1)
    PageSeparator.Position = UDim2.new(0, -20, 0, 52)
    PageSeparator.BackgroundColor3 = Color3.fromHex("25252D")
    PageSeparator.BorderSizePixel = 0
    PageSeparator.Parent = PageHeader

    local function CreateScriptGrid(parent)
        local G = Instance.new("Frame")
        G.Size = UDim2.new(1, 0, 0, 0)
        G.BackgroundTransparency = 1
        G.AutomaticSize = Enum.AutomaticSize.Y
        G.Parent = parent
        local Grid = Instance.new("UIGridLayout")
        Grid.CellSize = UDim2.new(0, 240, 0, 100)
        Grid.CellPadding = UDim2.new(0, 15, 0, 15)
        Grid.SortOrder = Enum.SortOrder.LayoutOrder
        Grid.Parent = G
        return G
    end

    GamePages[name] = {Page = Page, CreateGrid = CreateScriptGrid}
    return GamePages[name]
end

-- [[ VARIABLE TO TRACK SELECTED GAME ]]
local SelectedGame = nil
local GameButtons = {}

local function ShowPage(name)
    WelcomePage.Visible = false
    
    for gameName, btn in pairs(GameButtons) do
        if btn and btn.Parent then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end
    end
    
    if GameButtons[name] then
        TweenService:Create(GameButtons[name], TweenInfo.new(0.2), {
            BackgroundTransparency = 0.7,
            BackgroundColor3 = Color3.fromRGB(138, 43, 226),
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
        SelectedGame = name
    end
    
    for pageName, pageData in pairs(GamePages) do
        pageData.Page.Visible = (pageName == name)
    end
end

-- [[ GAMES LIST SCROLLING ]]
local GamesList = Instance.new("ScrollingFrame")
GamesList.Name = "GamesList"
GamesList.Size = UDim2.new(1, 0, 0, 110)
GamesList.Position = UDim2.new(0, 0, 0, 137)
GamesList.BackgroundTransparency = 1
GamesList.BorderSizePixel = 0
GamesList.ScrollBarThickness = 2
GamesList.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
GamesList.CanvasSize = UDim2.new(0, 0, 0, 0)
GamesList.AutomaticCanvasSize = Enum.AutomaticSize.Y
GamesList.Active = true
GamesList.Parent = SideBar

local GamesLayout = Instance.new("UIListLayout")
GamesLayout.Padding = UDim.new(0, 4)
GamesLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
GamesLayout.Parent = GamesList

local function CreateMenuBtn(text, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 0, 30)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    btn.Text = "      " .. text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Active = true
    btn.Parent = parent

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn

    GameButtons[text] = btn
    
    btn.MouseButton1Click:Connect(function() 
        ShowPage(text) 
    end)
    
    btn.MouseEnter:Connect(function()
        if SelectedGame ~= text then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.9,
                TextColor3 = Color3.fromRGB(138, 43, 226)
            }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if SelectedGame ~= text then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end
    end)
    return btn
end

-- [[ PRISON LIFE CONFIGURATION ]]
local PL_Data = CreatePage("Prison Life")

CreateSection(PL_Data.Page, "Visuals")
local VisualGrid = PL_Data.CreateGrid(PL_Data.Page)

CreateToggle(VisualGrid, "ESP Players", "Visualiza TODOS os jogadores, independente do time.", "Visuals", function(v) States.ESP_Players = v ESP.UpdateAllESPs() end)
CreateToggle(VisualGrid, "ESP Bandidos", "Mostra jogadores do time Criminal (incluindo do seu time).", "Visuals", function(v) States.ESP_Bandidos = v ESP.UpdateAllESPs() end)
CreateToggle(VisualGrid, "ESP Policiais", "Mostra jogadores do time Guards (incluindo do seu time).", "Visuals", function(v) States.ESP_Policiais = v ESP.UpdateAllESPs() end)
CreateToggle(VisualGrid, "ESP Prisioneiros", "Mostra jogadores do time Inmates (incluindo do seu time).", "Visuals", function(v) States.ESP_Prisioneiros = v ESP.UpdateAllESPs() end)

CreateSection(PL_Data.Page, "Utilities")
local UtilGrid = PL_Data.CreateGrid(PL_Data.Page)

CreateToggle(UtilGrid, "Bypass Doors", "Remove a colisão de todas as portas da pasta Doors.", "World", function(v) States.Bypass_Doors = v end)
CreateToggle(UtilGrid, "Auto KeyCard", "Pega KeyCard automaticamente quando dropado (verifica se já tem).", "Auto", function(v) States.Auto_KeyCard = v end)
CreateToggle(UtilGrid, "Auto M9", "Pega M9 automaticamente quando dropada (verifica se já tem).", "Auto", function(v) States.Auto_M9 = v end)

CreateSection(PL_Data.Page, "Teleports")
local TPGrid = PL_Data.CreateGrid(PL_Data.Page)

local TELEPORT_POSITIONS = {
    ["Out Prison"] = CFrame.new(400, 100, 2215),
    ["Criminals Spawn"] = CFrame.new(-920, 95, 2138),
    ["Inside Prison"] = CFrame.new(919, 100, 2379),
    ["Yard Center"] = CFrame.new(789, 98, 2475),
    ["Police Station"] = CFrame.new(827, 100, 2288)
}

CreateButton(TPGrid, "TP Out Prison", "Teletransporta para FORA da prisão.", "TP", function() 
    SimpleTeleport(TELEPORT_POSITIONS["Out Prison"])
end)

CreateButton(TPGrid, "TP Criminals Spawn", "Teletransporta para onde os bandidos nascem.", "TP", function() 
    SimpleTeleport(TELEPORT_POSITIONS["Criminals Spawn"])
end)

CreateButton(TPGrid, "TP Inside Prison", "Teletransporta para DENTRO da prisão (yard).", "TP", function() 
    SimpleTeleport(TELEPORT_POSITIONS["Inside Prison"])
end)

CreateButton(TPGrid, "TP Yard Center", "Teletransporta para o centro do pátio.", "TP", function() 
    SimpleTeleport(TELEPORT_POSITIONS["Yard Center"])
end)

CreateButton(TPGrid, "TP Police Station", "Teletransporta DENTRO do negócio da polícia.", "TP", function() 
    SimpleTeleport(TELEPORT_POSITIONS["Police Station"])
end)

CreateSection(PL_Data.Page, "Prison Items")
local ItemsGrid = PL_Data.CreateGrid(PL_Data.Page)

CreateButton(ItemsGrid, "Get AK-47", "Pega a AK-47 (teleporta atrás para pisar e volta).", "Items", function()
    GetPrisonWeapon("AK-47")
end)

CreateButton(ItemsGrid, "Get MP5", "Pega a MP5 (teleporta e volta automaticamente).", "Items", function()
    GetPrisonWeapon("MP5")
end)

local ShotgunButtonRef = CreateButton(ItemsGrid, "Get Shotgun", "Pega a escopeta (Time: " .. GetTeamName() .. ") - Volta auto.", "Items", function()
    GetPrisonWeapon("Shotgun")
end)

-- [[ BLIND SHOT CONFIGURATION ]]
local BS_Data = CreatePage("Blind Shot")

CreateSection(BS_Data.Page, "Visuals")
local BlindGrid = BS_Data.CreateGrid(BS_Data.Page)

CreateToggle(BlindGrid, "ESP DEFINITIVE", "Intercepta renderização e força visibilidade (Sem ESP Azul)", "VISUAL", function(v)
    States.BlindShot_ESP = v
    
    if v then
        BlindShotESP:Enable()
        print("[Vortex Hub] ESP DEFINITIVO ativado! Interceptando anti-cheat (Sem ESP Azul)")
    else
        BlindShotESP:Disable()
        print("[Vortex Hub] ESP desativado completamente")
    end
end)

CreateSection(BS_Data.Page, "Auto Farm")
local AutoFarmGrid = BS_Data.CreateGrid(BS_Data.Page)

CreateToggle(AutoFarmGrid, "Auto TP to Trophy", "Teleporta automaticamente para o troféu a cada 20s", "FARM", function(v)
    States.Auto_Trophy = v
    
    if v then
        StartAutoTrophy()
        print("[Vortex Hub] Auto TP to Trophy ativado! Teleporta a cada 20s")
    else
        print("[Vortex Hub] Auto TP to Trophy desativado")
    end
end)

CreateToggle(AutoFarmGrid, "Anti-AFK System", "Evita que você seja kickado por inatividade", "UTILITY", function(v)
    States.Anti_AFK = v
    
    if v then
        AntiAFK:Enable()
        print("[Vortex Hub] Anti-AFK ativado! Você não será kickado por inatividade")
    else
        AntiAFK:Disable()
        print("[Vortex Hub] Anti-AFK desativado")
    end
end)

-- [[ FIND THE BRAINROT CONFIGURATION ]]
local BR_Data = CreatePage("Find the Brainrot")

CreateSection(BR_Data.Page, "Auto Farm")
local BrainrotGrid = BR_Data.CreateGrid(BR_Data.Page)

CreateToggle(BrainrotGrid, "Auto Brainrot Farm", "Teleporta automaticamente para todos os brainrots", "TELEPORT", function(v)
    States.Brainrot_Farm = v
    
    if v then
        BrainrotFarm:Enable()
        print("[Vortex Hub] Brainrot Farm ativado! Sistema Anti-Loop ativo")
    else
        BrainrotFarm:Disable()
        print("[Vortex Hub] Brainrot Farm desativado")
    end
end)

CreateSection(BR_Data.Page, "Utilities")
local BrainrotUtilGrid = BR_Data.CreateGrid(BR_Data.Page)

CreateToggle(BrainrotUtilGrid, "Anti-AFK System", "Evita que você seja kickado por inatividade", "UTILITY", function(v)
    States.Anti_AFK = v
    
    if v then
        AntiAFK:Enable()
        print("[Vortex Hub] Anti-AFK ativado! Você não será kickado por inatividade")
    else
        AntiAFK:Disable()
        print("[Vortex Hub] Anti-AFK desativado")
    end
end)

-- [[ WESTBOUND CONFIGURATION - MODIFICADO COM NOVOS ESPs ]]
local WB_Data = CreatePage("Westbound")

CreateSection(WB_Data.Page, "Visuals")
local Westbound_ESPGrid = WB_Data.CreateGrid(WB_Data.Page)

CreateToggle(Westbound_ESPGrid, "ESP Players", "Mostra todos os jogadores no Westbound", "VISUAL", function(v)
    Westbound:ToggleESP_Players(v)
end)

CreateToggle(Westbound_ESPGrid, "ESP Animals", "Mostra todos os animais no Westbound", "VISUAL", function(v)
    Westbound:ToggleESP_Animals(v)
end)

CreateToggle(Westbound_ESPGrid, "ESP Distance + Name", "Mostra distância e nome dos jogadores", "VISUAL", function(v)
    Westbound:ToggleESP_DistanceName(v)
end)

CreateToggle(Westbound_ESPGrid, "ESP Name", "Mostra apenas os nomes dos jogadores", "VISUAL", function(v)
    Westbound:ToggleESP_Name(v)
end)

-- [[ FNAF: ETERNAL NIGHTS CONFIGURATION - MODIFICADO ]]
local FNAF_Data = CreatePage("FNAF: Eternal Nights")

CreateSection(FNAF_Data.Page, "Teleports")
local FNAF_TeleportGrid = FNAF_Data.CreateGrid(FNAF_Data.Page)

CreateButton(FNAF_TeleportGrid, "TP Security Room", "Teleport para a sala de segurança", "TP", function()
    FNAF:TeleportSecurityRoom()
end)

CreateButton(FNAF_TeleportGrid, "TP Puppet Clock", "Teleport para o relógio da Puppet", "TP", function()
    FNAF:TeleportPuppetClock()
end)

CreateButton(FNAF_TeleportGrid, "TP Above Map", "Teleport para cima do mapa", "TP", function()
    FNAF:TeleportAboveMap()
end)

CreateButton(FNAF_TeleportGrid, "TP Fuse Room", "Teleport para sala dos fusíveis", "TP", function()
    FNAF:TeleportFuseRoom()
end)

CreateSection(FNAF_Data.Page, "Visuals")
local FNAF_ESPGrid = FNAF_Data.CreateGrid(FNAF_Data.Page)

CreateToggle(FNAF_ESPGrid, "ESP Animatronics", "Mostra todos os animatrônicos", "VISUAL", function(v)
    States.FNAF_ESP_Animatronics = v
    FNAF:ApplyESP_Animatronics()
end)

CreateToggle(FNAF_ESPGrid, "ESP Fuses", "Mostra todos os fusíveis", "VISUAL", function(v)
    States.FNAF_ESP_Fuses = v
    FNAF:ApplyESP_Fuses()
end)

CreateToggle(FNAF_ESPGrid, "ESP Batteries", "Mostra todas as baterias", "VISUAL", function(v)
    States.FNAF_ESP_Batteries = v
    FNAF:ApplyESP_Batteries()
end)

CreateToggle(FNAF_ESPGrid, "ESP Pliers", "Mostra todos os alicates", "VISUAL", function(v)
    States.FNAF_ESP_Pliers = v
    FNAF:ApplyESP_Pliers()
end)

CreateToggle(FNAF_ESPGrid, "ESP Screwdriver", "Mostra todas as chaves de fenda", "VISUAL", function(v)
    States.FNAF_ESP_Screwdriver = v
    FNAF:ApplyESP_Screwdriver()
end)

CreateToggle(FNAF_ESPGrid, "ESP ALL", "Ativa todos os ESPs de uma vez", "VISUAL", function(v)
    States.FNAF_ESP_All = v
    FNAF:ApplyAllESP()
end)

CreateSection(FNAF_Data.Page, "Pull Items")
local FNAF_PullGrid = FNAF_Data.CreateGrid(FNAF_Data.Page)

CreateButton(FNAF_PullGrid, "Pull Batteries", "Puxa todas as baterias até você (Executa uma vez)", "PULL", function()
    FNAF:Pull_Batteries_Execute()
end)

CreateButton(FNAF_PullGrid, "Pull Screwdriver", "Puxa todas as chaves de fenda (Executa uma vez)", "PULL", function()
    FNAF:Pull_Screwdriver_Execute()
end)

CreateButton(FNAF_PullGrid, "Pull Pliers", "Puxa todos os alicates (Executa uma vez)", "PULL", function()
    FNAF:Pull_Pliers_Execute()
end)

CreateButton(FNAF_PullGrid, "Pull Fuses", "Puxa todos os fusíveis (Executa uma vez)", "PULL", function()
    FNAF:Pull_Fuses_Execute()
end)

CreateButton(FNAF_PullGrid, "Pull ALL Items", "Puxa TODOS os itens de uma vez", "PULL", function()
    FNAF:Pull_All_Execute()
end)

CreateSection(FNAF_Data.Page, "Utilities")
local FNAF_UtilGrid = FNAF_Data.CreateGrid(FNAF_Data.Page)

CreateToggle(FNAF_UtilGrid, "Full Brightness", "Deixa o mapa totalmente claro", "VISUAL", function(v)
    States.FNAF_FullBright = v
    FNAF:ToggleFullBright(v)
end)

CreateToggle(FNAF_UtilGrid, "Infinite Speed", "Velocidade infinita (35 studs/s)", "MOVEMENT", function(v)
    States.FNAF_SpeedHack = v
    FNAF:ToggleSpeedHack(v)
end)

CreateToggle(FNAF_UtilGrid, "Anti-AFK System", "Evita que você seja kickado por inatividade", "UTILITY", function(v)
    States.Anti_AFK = v
    
    if v then
        AntiAFK:Enable()
        print("[Vortex Hub] Anti-AFK ativado! Você não será kickado por inatividade")
    else
        AntiAFK:Disable()
        print("[Vortex Hub] Anti-AFK desativado")
    end
end)

-- [[ AUTOMATIC TEAM UPDATE SYSTEM ]]
local function UpdateShotgunButtonDescription()
    if not ShotgunButtonRef then return end
    
    for _, child in pairs(ItemsGrid:GetChildren()) do
        if child.Name == "Get Shotgun_Card" then
            for _, desc in pairs(child:GetChildren()) do
                if desc:IsA("TextLabel") and desc.Text and string.find(desc.Text, "Pega a escopeta") then
                    desc.Text = "Pega a escopeta (Time: " .. GetTeamName() .. ") - Volta auto."
                    break
                end
            end
            break
        end
    end
end

local teamChangedConnection = LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    task.wait(0.5)
    UpdateShotgunButtonDescription()
end)

CreateMenuBtn("Prison Life", GamesList)
CreateMenuBtn("Blind Shot", GamesList)
CreateMenuBtn("Find the Brainrot", GamesList)
CreateMenuBtn("Westbound", GamesList)
CreateMenuBtn("FNAF: Eternal Nights", GamesList)

local Line3 = Instance.new("Frame")
Line3.Size = UDim2.new(1, 0, 0, 1)
Line3.Position = UDim2.new(0, 0, 0, 250)
Line3.BackgroundColor3 = Color3.fromHex("25252D")
Line3.BorderSizePixel = 0
Line3.Parent = SideBar

local MenuLabel = Instance.new("TextLabel")
MenuLabel.Text = "MENU"
MenuLabel.Size = UDim2.new(1, -30, 0, 30)
MenuLabel.Position = UDim2.new(0, 15, 0, 251)
MenuLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
MenuLabel.Font = Enum.Font.GothamBold
MenuLabel.TextSize = 9
MenuLabel.BackgroundTransparency = 1
MenuLabel.TextXAlignment = Enum.TextXAlignment.Left
MenuLabel.Parent = SideBar

local MenuList = Instance.new("ScrollingFrame")
MenuList.Name = "MenuList"
MenuList.Size = UDim2.new(1, 0, 0, 75)
MenuList.Position = UDim2.new(0, 0, 0, 281)
MenuList.BackgroundTransparency = 1
MenuList.BorderSizePixel = 0
MenuList.ScrollBarThickness = 2
MenuList.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
MenuList.CanvasSize = UDim2.new(0, 0, 0, 0)
MenuList.AutomaticCanvasSize = Enum.AutomaticSize.Y
MenuList.Active = true
MenuList.Parent = SideBar

local MenuLayout = Instance.new("UIListLayout")
MenuLayout.Padding = UDim.new(0, 4)
MenuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MenuLayout.Parent = MenuList

CreateMenuBtn("Settings", MenuList); CreatePage("Settings")
CreateMenuBtn("Discord", MenuList); CreatePage("Discord")
CreateMenuBtn("Credits", MenuList); CreatePage("Credits")

local FooterSeparator = Instance.new("Frame")
FooterSeparator.Size = UDim2.new(1, 0, 0, 1)
FooterSeparator.Position = UDim2.new(0, 0, 0, 362)
FooterSeparator.BackgroundColor3 = Color3.fromHex("25252D")
FooterSeparator.BorderSizePixel = 0
FooterSeparator.Parent = SideBar

local FooterGroup = Instance.new("Frame")
FooterGroup.Name = "FooterGroup"
FooterGroup.Size = UDim2.new(1, 0, 0, 50)
FooterGroup.Position = UDim2.new(0, 0, 0, 363)
FooterGroup.BackgroundTransparency = 1
FooterGroup.Parent = SideBar

local FooterLayout = Instance.new("UIListLayout")
FooterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
FooterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FooterLayout.Padding = UDim.new(0, 2)
FooterLayout.Parent = FooterGroup

local VersionLabelBottom = Instance.new("TextLabel")
VersionLabelBottom.Text = "v2.3.0"
VersionLabelBottom.Size = UDim2.new(1, 0, 0, 14)
VersionLabelBottom.TextColor3 = Color3.fromRGB(80, 85, 85)
VersionLabelBottom.Font = Enum.Font.Gotham
VersionLabelBottom.TextSize = 10
VersionLabelBottom.BackgroundTransparency = 1
VersionLabelBottom.Parent = FooterGroup

local DevLabelFinal = Instance.new("TextLabel")
DevLabelFinal.Size = UDim2.new(1, 0, 0, 14)
DevLabelFinal.BackgroundTransparency = 1
DevLabelFinal.RichText = true
DevLabelFinal.Text = "<font color='#646464'>Developed by</font> <font color='#8A2BE2'>Y otra</font>"
DevLabelFinal.Font = Enum.Font.Gotham
DevLabelFinal.TextSize = 10
DevLabelFinal.Parent = FooterGroup

-- [[ DRAG & KEYBIND ]]
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Clean connections when closing
CloseBtn.MouseButton1Click:Connect(function()
    if teamChangedConnection then
        teamChangedConnection:Disconnect()
    end
    ESP.Cleanup()
    BlindShotESP:Disable()
    AntiAFK:Disable()
    BrainrotFarm:Disable()
    Westbound:Cleanup()
    FNAF:Cleanup()
    ScreenGui:Destroy()
end)

print("[Vortex Hub] Script loaded successfully! v2.3.0")
print("[Vortex Hub] FNAF: Eternal Nights - Sistema completo integrado")
print("[Vortex Hub] Westbound - Sistema ESP corrigido com scripts específicos de ativação/desativação")
print("[Vortex Hub] Westbound - Novos ESPs adicionados: Distance + Name e Name")
print("[Vortex Hub] ESP Prison Life - Corrigido definitivamente (funciona em todos os jogadores)")
print("[Vortex Hub] ESP Blind Shot - Sem ESP Azul na próxima rodada")
print("[Vortex Hub] FNAF Pull Items - Agora são botões 'Execute' (não mais toggles)")
print("[Vortex Hub] Sistema 100% funcional - Todas as correções aplicadas!")