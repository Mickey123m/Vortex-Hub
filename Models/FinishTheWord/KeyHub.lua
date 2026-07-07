local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "VortexHub-Services-linkvertise-FinishTheWord"
Junkie.identifier = "1007820"
Junkie.provider = "Vortex-Hub-Key-linkvertise-FinishTheWord"

local Config = {
    ScriptURL = "https://raw.githubusercontent.com/Mickey123m/Vortex-Hub/refs/heads/main/Models/FinishTheWord/AutoType.lua",
    KeyFileName = "vortex_key.txt",
    TimerFileName = "vortex_timer.txt",
    CooldownSeconds = 300
}

getgenv().SCRIPT_KEY = nil
getgenv().UI_CLOSED = false

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function hasFileSystemSupport()
    local hasWritefile = pcall(function() return type(writefile) == "function" end)
    local hasReadfile = pcall(function() return type(readfile) == "function" end)
    local hasIsfile = pcall(function() return type(isfile) == "function" end)
    return hasWritefile and hasReadfile and hasIsfile
end

local fileSystemSupported = hasFileSystemSupport()

local function saveVerifiedKey(key)
    if not fileSystemSupported then return false end
    pcall(function() writefile(Config.KeyFileName, key) end)
    return true
end

local function loadVerifiedKey()
    if not fileSystemSupported then return nil end
    local ok, content = pcall(function()
        if isfile(Config.KeyFileName) then 
            return readfile(Config.KeyFileName) 
        end
    end)
    return ok and content or nil
end

local function clearSavedKey()
    if fileSystemSupported and isfile(Config.KeyFileName) then
        pcall(function() delfile(Config.KeyFileName) end)
    end
end

local function saveTimer()
    if not fileSystemSupported then return end
    pcall(function() writefile(Config.TimerFileName, tostring(os.time())) end)
end

local function getRemainingCooldown()
    if not fileSystemSupported or not isfile(Config.TimerFileName) then return 0 end
    local ok, lastTime = pcall(function() return tonumber(readfile(Config.TimerFileName)) end)
    if ok and lastTime then
        local diff = os.time() - lastTime
        local remaining = Config.CooldownSeconds - diff
        return remaining > 0 and remaining or 0
    end
    return 0
end

local function ShakeFrame(frame)
    local originalPos = frame.Position
    task.spawn(function()
        for i = 1, 4 do
            local offset = (i % 2 == 0 and 5 or -5)
            frame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + offset, 
                                      originalPos.Y.Scale, originalPos.Y.Offset)
            task.wait(0.05)
        end
        frame.Position = originalPos
    end)
end

local KeySystem = {}

function KeySystem:CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VortexKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    ScreenGui.Parent = success and coreGui or LocalPlayer:WaitForChild("PlayerGui")

    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.Parent = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromHex("17171C")
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Size = UDim2.new(0, 400, 0, 420)
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromHex("25252D")
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 42)
    TopBar.BackgroundColor3 = Color3.fromHex("1C1C22")
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Text = "VORTEX HUB"
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.TextColor3 = Color3.fromRGB(138, 43, 226)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "×"
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.TextSize = 18
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(200, 45, 45),
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
    end)

    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(150, 150, 150)
        }):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        getgenv().UI_CLOSED = true
        ScreenGui:Destroy()
    end)

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -40, 1, -60)
    Content.Position = UDim2.new(0, 20, 0, 55)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.new(0, 70, 0, 70)
    IconFrame.Position = UDim2.new(0.5, -35, 0, 10)
    IconFrame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    IconFrame.Parent = Content
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 12)
    IconCorner.Parent = IconFrame
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Text = "V"
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 32
    IconLabel.TextColor3 = Color3.new(1, 1, 1)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Parent = IconFrame

    local WelcomeText = Instance.new("TextLabel")
    WelcomeText.Text = "ACCESS VERIFICATION"
    WelcomeText.Size = UDim2.new(1, 0, 0, 24)
    WelcomeText.Position = UDim2.new(0, 0, 0, 90)
    WelcomeText.Font = Enum.Font.GothamBold
    WelcomeText.TextSize = 16
    WelcomeText.TextColor3 = Color3.new(1, 1, 1)
    WelcomeText.BackgroundTransparency = 1
    WelcomeText.TextXAlignment = Enum.TextXAlignment.Center
    WelcomeText.Parent = Content

    local SubText = Instance.new("TextLabel")
    SubText.Text = "Enter your access key to continue"
    SubText.Size = UDim2.new(1, 0, 0, 16)
    SubText.Position = UDim2.new(0, 0, 0, 114)
    SubText.Font = Enum.Font.Gotham
    SubText.TextSize = 12
    SubText.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubText.BackgroundTransparency = 1
    SubText.TextXAlignment = Enum.TextXAlignment.Center
    SubText.Parent = Content

    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, 0, 0, 44)
    InputFrame.Position = UDim2.new(0, 0, 0, 145)
    InputFrame.BackgroundColor3 = Color3.fromHex("1C1C22")
    InputFrame.Parent = Content
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = InputFrame
    
    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromHex("25252D")
    InputStroke.Thickness = 1.5
    InputStroke.Parent = InputFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -20, 1, 0)
    KeyInput.Position = UDim2.new(0, 10, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.PlaceholderText = "Enter key here..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
    KeyInput.Text = ""
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 14
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = InputFrame

    KeyInput.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(138, 43, 226)
        }):Play()
    end)

    KeyInput.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {
            Color = Color3.fromHex("25252D")
        }):Play()
    end)

    local ValidateButton = Instance.new("TextButton")
    ValidateButton.Size = UDim2.new(1, 0, 0, 44)
    ValidateButton.Position = UDim2.new(0, 0, 0, 200)
    ValidateButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    ValidateButton.Text = "VALIDATE KEY"
    ValidateButton.Font = Enum.Font.GothamBold
    ValidateButton.TextSize = 14
    ValidateButton.TextColor3 = Color3.new(1, 1, 1)
    ValidateButton.AutoButtonColor = false
    ValidateButton.Parent = Content
    
    local ValidateCorner = Instance.new("UICorner")
    ValidateCorner.CornerRadius = UDim.new(0, 6)
    ValidateCorner.Parent = ValidateButton

    ValidateButton.MouseEnter:Connect(function()
        TweenService:Create(ValidateButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(158, 63, 246)
        }):Play()
    end)

    ValidateButton.MouseLeave:Connect(function()
        TweenService:Create(ValidateButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        }):Play()
    end)

    local GetKeyButton = Instance.new("TextButton")
    GetKeyButton.Size = UDim2.new(1, 0, 0, 38)
    GetKeyButton.Position = UDim2.new(0, 0, 0, 255)
    GetKeyButton.BackgroundColor3 = Color3.fromHex("25252D")
    GetKeyButton.Text = "GET ACCESS LINK"
    GetKeyButton.Font = Enum.Font.Gotham
    GetKeyButton.TextSize = 12
    GetKeyButton.TextColor3 = Color3.new(1, 1, 1)
    GetKeyButton.AutoButtonColor = false
    GetKeyButton.Parent = Content
    
    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 6)
    GetKeyCorner.Parent = GetKeyButton

    GetKeyButton.MouseEnter:Connect(function()
        TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromHex("2D2D35")
        }):Play()
    end)

    GetKeyButton.MouseLeave:Connect(function()
        TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromHex("25252D")
        }):Play()
    end)

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, 0, 0, 18)
    StatusText.Position = UDim2.new(0, 0, 0, 305)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = ""
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextSize = 11
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusText.TextXAlignment = Enum.TextXAlignment.Center
    StatusText.Parent = Content

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 0, 2)
    ProgressBar.Position = UDim2.new(0, 0, 0, 330)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    ProgressBar.BackgroundTransparency = 1
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = Content

    local function UpdateStatus(text, color)
        StatusText.Text = text
        StatusText.TextColor3 = color or Color3.fromRGB(150, 150, 150)
    end

    local function ShowProgress(percentage, color)
        ProgressBar.BackgroundTransparency = 0
        ProgressBar.BackgroundColor3 = color or Color3.fromRGB(138, 43, 226)
        TweenService:Create(ProgressBar, TweenInfo.new(0.3), {
            Size = UDim2.new(percentage, 0, 0, 2)
        }):Play()
    end

    local isCooldown = false
    local cooldownThread = nil
    
    local function StartCooldown(seconds)
        if cooldownThread then 
            task.cancel(cooldownThread)
            cooldownThread = nil
        end
        
        isCooldown = true
        GetKeyButton.Interactable = false
        GetKeyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        
        cooldownThread = task.spawn(function()
            local remaining = seconds
            while remaining > 0 do
                local mins = math.floor(remaining / 60)
                local secs = remaining % 60
                GetKeyButton.Text = string.format("WAIT %02d:%02d", mins, secs)
                ShowProgress(1 - (remaining / seconds), Color3.fromRGB(200, 100, 50))
                task.wait(1)
                remaining = remaining - 1
                if not GetKeyButton or not GetKeyButton.Parent then 
                    break 
                end
            end
            
            if GetKeyButton and GetKeyButton.Parent then
                isCooldown = false
                GetKeyButton.Interactable = true
                GetKeyButton.Text = "GET ACCESS LINK"
                GetKeyButton.BackgroundColor3 = Color3.fromHex("25252D")
                ShowProgress(0, Color3.fromRGB(138, 43, 226))
                ProgressBar.BackgroundTransparency = 1
                saveTimer()
            end
            cooldownThread = nil
        end)
    end

    local timeLeft = getRemainingCooldown()
    if timeLeft > 0 then
        StartCooldown(timeLeft)
    end

    GetKeyButton.MouseButton1Click:Connect(function()
        if isCooldown then return end
        
        local link = Junkie.get_key_link()
        if not link then
            UpdateStatus("Error: Failed to get access link", Color3.fromRGB(255, 70, 70))
            ShowProgress(1, Color3.fromRGB(255, 70, 70))
            task.delay(2, function()
                ShowProgress(0, Color3.fromRGB(138, 43, 226))
                ProgressBar.BackgroundTransparency = 1
            end)
            return
        end
        
        if setclipboard then
            setclipboard(link)
            UpdateStatus("Link copied to clipboard", Color3.fromRGB(50, 200, 100))
            ShowProgress(1, Color3.fromRGB(50, 200, 100))
            task.delay(1.5, function()
                ShowProgress(0, Color3.fromRGB(138, 43, 226))
                ProgressBar.BackgroundTransparency = 1
            end)
        else
            UpdateStatus("Link: " .. link, Color3.fromRGB(100, 100, 255))
        end
        
        saveTimer()
        StartCooldown(Config.CooldownSeconds)
    end)

    local function ValidateKey()
        if not ValidateButton.Interactable then return end
        
        local key = KeyInput.Text:gsub("%s+", "")
        if #key == 0 then
            InputStroke.Color = Color3.fromRGB(255, 50, 50)
            ShakeFrame(InputFrame)
            UpdateStatus("Please enter a key", Color3.fromRGB(255, 200, 50))
            task.delay(1.5, function()
                InputStroke.Color = Color3.fromHex("25252D")
            end)
            return
        end
        
        ValidateButton.Text = "VERIFYING..."
        ValidateButton.Interactable = false
        KeyInput.Interactable = false
        UpdateStatus("Verifying key...", Color3.fromRGB(100, 100, 255))
        ShowProgress(0.5, Color3.fromRGB(100, 100, 255))
        
        task.spawn(function()
            local result = Junkie.check_key(key)
            
            if result and result.valid then
                InputStroke.Color = Color3.fromRGB(50, 255, 100)
                ValidateButton.Text = "SUCCESS"
                ValidateButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                UpdateStatus("Key validated successfully", Color3.fromRGB(50, 255, 100))
                ShowProgress(1, Color3.fromRGB(50, 255, 100))
                
                saveVerifiedKey(key)
                getgenv().SCRIPT_KEY = key
                
                task.wait(0.8)
                getgenv().UI_CLOSED = true
                ScreenGui:Destroy()
                
                local success, err = pcall(function()
                    loadstring(game:HttpGet(Config.ScriptURL))()
                end)
                
            else
                InputStroke.Color = Color3.fromRGB(255, 50, 50)
                ValidateButton.Text = "INVALID KEY"
                ValidateButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                ShakeFrame(InputFrame)
                UpdateStatus("Invalid key, please try again", Color3.fromRGB(255, 70, 70))
                ShowProgress(1, Color3.fromRGB(255, 70, 70))
                
                task.wait(1.5)
                
                ValidateButton.Text = "VALIDATE KEY"
                ValidateButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
                ValidateButton.Interactable = true
                KeyInput.Interactable = true
                
                InputStroke.Color = Color3.fromHex("25252D")
                ShowProgress(0, Color3.fromRGB(138, 43, 226))
                ProgressBar.BackgroundTransparency = 1
                KeyInput.Text = ""
            end
        end)
    end

    ValidateButton.MouseButton1Click:Connect(ValidateKey)

    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            ValidateKey()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.Escape then
            getgenv().UI_CLOSED = true
            ScreenGui:Destroy()
        end
    end)

    MainFrame.BackgroundTransparency = 1
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    task.delay(0.1, function()
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 400, 0, 420)
        }):Play()
    end)

    return ScreenGui
end

local savedKey = loadVerifiedKey()
if savedKey then
    local result = Junkie.check_key(savedKey)
    if result and result.valid then
        getgenv().SCRIPT_KEY = savedKey
        local success, err = pcall(function()
            loadstring(game:HttpGet(Config.ScriptURL))()
        end)
        if not success then
            KeySystem:CreateGUI()
        end
    else
        clearSavedKey()
        KeySystem:CreateGUI()
    end
else
    KeySystem:CreateGUI()
end

while not getgenv().UI_CLOSED and not getgenv().SCRIPT_KEY do
    task.wait(0.1)
end