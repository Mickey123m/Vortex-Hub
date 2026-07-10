local function CreateBoardImageUI()
    local player = game.Players.LocalPlayer
    
    local parentGui
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then
        parentGui = coreGui
    else
        parentGui = player:WaitForChild("PlayerGui")
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BoardImageViewer"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 2147483647
    screenGui.IgnoreGuiInset = true
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 340, 0, 260)
    mainFrame.Position = UDim2.new(1, -360, 0.5, -130)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.Active = true
    mainFrame.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    topBar.BorderSizePixel = 0
    topBar.Active = true
    topBar.ZIndex = 11
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = topBar
    
    local bottomCover = Instance.new("Frame")
    bottomCover.Size = UDim2.new(1, 0, 0.5, 0)
    bottomCover.Position = UDim2.new(0, 0, 0.5, 0)
    bottomCover.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    bottomCover.BorderSizePixel = 0
    bottomCover.Parent = topBar
    bottomCover.ZIndex = 11
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    titleLabel.Text = "Opponent's Board"
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    titleLabel.ZIndex = 12
    
    local imageFrame = Instance.new("Frame")
    imageFrame.Name = "ImageFrame"
    imageFrame.Size = UDim2.new(1, -24, 0, 200)
    imageFrame.Position = UDim2.new(0, 12, 0, 50)
    imageFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    imageFrame.BorderSizePixel = 0
    imageFrame.ZIndex = 11
    
    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 6)
    imageCorner.Parent = imageFrame
    
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = "BoardImage"
    imageLabel.Size = UDim2.new(1, -10, 1, -10)
    imageLabel.Position = UDim2.new(0, 5, 0, 5)
    imageLabel.BackgroundTransparency = 1
    imageLabel.ScaleType = Enum.ScaleType.Fit
    imageLabel.Parent = imageFrame
    imageLabel.ZIndex = 12
    imageLabel.Visible = false
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 1, -20)
    statusLabel.Position = UDim2.new(0, 10, 0, 10)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    statusLabel.Text = "Not in a match"
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.TextSize = 16
    statusLabel.TextWrapped = true
    statusLabel.ZIndex = 12
    statusLabel.Visible = true
    statusLabel.Parent = imageFrame
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 28, 0, 28)
    minimizeButton.Position = UDim2.new(1, -64, 0, 6)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 210)
    minimizeButton.Text = "-"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 18
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Active = true
    minimizeButton.ZIndex = 13
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 4)
    minCorner.Parent = minimizeButton
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 28, 0, 28)
    closeButton.Position = UDim2.new(1, -34, 0, 6)
    closeButton.BackgroundColor3 = Color3.fromRGB(230, 60, 70)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.BorderSizePixel = 0
    closeButton.Active = true
    closeButton.ZIndex = 13
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local isMinimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            imageFrame.Visible = false
            mainFrame.Size = UDim2.new(0, 340, 0, 40)
            minimizeButton.Text = "+"
        else
            imageFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 340, 0, 260)
            minimizeButton.Text = "-"
        end
    end)
    
    mainFrame.Parent = screenGui
    topBar.Parent = mainFrame
    imageFrame.Parent = mainFrame
    minimizeButton.Parent = mainFrame
    closeButton.Parent = mainFrame
    screenGui.Parent = parentGui
    
    return {
        screenGui = screenGui,
        imageLabel = imageLabel,
        statusLabel = statusLabel,
        mainFrame = mainFrame,
        closeButton = closeButton
    }
end

local function GetOpponentBoardImage()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return nil, "not_seated" end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return nil, "not_seated" end
    
    local duelTables = workspace:FindFirstChild("DuelTables")
    if not duelTables then return nil, "not_seated" end
    
    local isSeated = false
    
    for _, tableModel in ipairs(duelTables:GetChildren()) do
        if tableModel:IsA("Model") and tableModel.Name:match("^Table_") then
            for _, seat in ipairs(tableModel:GetDescendants()) do
                if (seat:IsA("Seat") or seat:IsA("VehicleSeat")) and seat.Occupant == humanoid then
                    isSeated = true
                    local seatNumber = seat.Name:match("(%d+)")
                    if seatNumber then
                        local opponentBoardNumber = seatNumber == "1" and 2 or 1
                        local opponentBoardName = "Board" .. opponentBoardNumber .. "Grid"
                        local opponentBoard = tableModel:FindFirstChild(opponentBoardName, true)
                        if opponentBoard then
                            local imageId = opponentBoard:GetAttribute("BoardImageId")
                            if imageId then
                                return imageId, "has_image"
                            else
                                return nil, "waiting_opponent"
                            end
                        end
                    end
                end
            end
        end
    end
    
    if isSeated then
        return nil, "waiting_opponent"
    end
    
    return nil, "not_seated"
end

local function TryAutoGuess(targetImageId)
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local gameUI = playerGui:FindFirstChild("GameUI")
    if not gameUI then return false end
    
    local menus = gameUI:FindFirstChild("Menus")
    if not menus then return false end
    
    local selectFrame = menus:FindFirstChild("SelectFrame")
    if not selectFrame then return false end
    
    if not selectFrame.Visible then return false end
    
    local normalScroll = selectFrame:FindFirstChild("NormalScroll")
    if not normalScroll then return false end
    
    for _, child in ipairs(normalScroll:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == "CharacterImage" then
            if child.Image == targetImageId then
                local absPos = child.AbsolutePosition
                local absSize = child.AbsoluteSize
                local clickX = absPos.X + (absSize.X / 2)
                local clickY = absPos.Y + (absSize.Y / 2)
                
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(clickX, clickY, 0, true, game, 1)
                task.wait(0.05)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(clickX, clickY, 0, false, game, 1)
                return true
            end
        end
    end
    
    return false
end

local function StartOpponentBoardMonitor()
    local ui = CreateBoardImageUI()
    local running = true
    local lastImageId = nil
    local alreadyGuessed = false
    
    local connection
    connection = ui.closeButton.MouseButton1Click:Connect(function()
        running = false
        if connection then connection:Disconnect() end
        ui.screenGui:Destroy()
    end)
    
    while running do
        local boardImageId, status = GetOpponentBoardImage()
        if running and ui.imageLabel and ui.statusLabel then
            
            if status == "not_seated" then
                ui.imageLabel.Visible = false
                ui.statusLabel.Visible = true
                ui.statusLabel.Text = "Not in a match"
                lastImageId = nil
                alreadyGuessed = false
            elseif status == "waiting_opponent" then
                ui.imageLabel.Visible = false
                ui.statusLabel.Visible = true
                ui.statusLabel.Text = "Waiting for opponent to choose..."
                lastImageId = nil
                alreadyGuessed = false
            elseif status == "has_image" and boardImageId then
                ui.imageLabel.Visible = true
                ui.statusLabel.Visible = false
                ui.imageLabel.Image = boardImageId
                
                if boardImageId ~= lastImageId then
                    alreadyGuessed = false
                    lastImageId = boardImageId
                end
                
                if not alreadyGuessed then
                    local success = TryAutoGuess(boardImageId)
                    if success then
                        alreadyGuessed = true
                    end
                end
            end
        end
        task.wait(0.3)
    end
end

StartOpponentBoardMonitor()