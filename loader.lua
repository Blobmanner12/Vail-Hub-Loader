repeat
	task.wait()
until game:IsLoaded()

local Hub_Name = "Vail Hub"
local Discord_Invite = "https://discord.gg/z6ngteTcT3"
local Linkvertise_Link = "https://ads.luarmor.net/get_key?for=Vail_Hub_Key-lgGHKWosXGmT"

local PlaceIDs = {
    [12355337193] = "c19180f7c85232d08ac0ee9b3c606e2d",
    [13771457545] = "c19180f7c85232d08ac0ee9b3c606e2d"
}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local current_script_id = PlaceIDs[game.PlaceId]

if not current_script_id then
    warn("Vail Hub: This game is not supported.")
    return
end

if getgenv().VailHubLoaderActive then
    return
end
getgenv().VailHubLoaderActive = true

local function createLoaderUI()
    local LoaderUI = Instance.new("ScreenGui")
    LoaderUI.Name = "VailHub_Loader"
    LoaderUI.ResetOnSpawn = false
    LoaderUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    LoaderUI.Parent = CoreGui

    local MainFrame = Instance.new("Frame"); MainFrame.Size = UDim2.fromOffset(350, 240); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.fromScale(0.5, 0.5); MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35); MainFrame.BorderSizePixel = 0; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(80, 80, 90); MainFrame.Parent = LoaderUI
    local Title = Instance.new("TextLabel"); Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45); Title.Text = Hub_Name; Title.Font = Enum.Font.GothamSemibold; Title.TextSize = 16; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8); Title.Parent = MainFrame
    local KeyInput = Instance.new("TextBox"); KeyInput.Size = UDim2.new(1, -40, 0, 35); KeyInput.Position = UDim2.new(0.5, 0, 0.4, 0); KeyInput.AnchorPoint = Vector2.new(0.5, 0.5); KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25); KeyInput.Font = Enum.Font.Gotham; KeyInput.TextSize = 14; KeyInput.TextColor3 = Color3.fromRGB(220, 220, 220);
    KeyInput.PlaceholderText = "Enter Key...";
    KeyInput.ClearTextOnFocus = false; Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", KeyInput).Color = Color3.fromRGB(80, 80, 90); KeyInput.Parent = MainFrame
    local SubmitButton = Instance.new("TextButton"); SubmitButton.Size = UDim2.new(1, -40, 0, 35); SubmitButton.Position = UDim2.new(0.5, 0, 0.6, 0); SubmitButton.AnchorPoint = Vector2.new(0.5, 0.5); SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255); SubmitButton.Text = "Authenticate"; SubmitButton.Font = Enum.Font.GothamBold; SubmitButton.TextSize = 16; SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", SubmitButton).CornerRadius = UDim.new(0, 6); SubmitButton.Parent = MainFrame
    
    local GetKeyButton = Instance.new("TextButton"); GetKeyButton.Size = UDim2.new(0.5, -25, 0, 25); GetKeyButton.Position = UDim2.new(0.25, 0, 0.8, 0); GetKeyButton.AnchorPoint = Vector2.new(0.5, 0.5); GetKeyButton.BackgroundTransparency = 1; GetKeyButton.Text = "Get Key"; GetKeyButton.Font = Enum.Font.Gotham; GetKeyButton.TextSize = 14; GetKeyButton.TextColor3 = Color3.fromRGB(120, 255, 160); GetKeyButton.Parent = MainFrame
    local DiscordButton = Instance.new("TextButton"); DiscordButton.Size = UDim2.new(0.5, -25, 0, 25); DiscordButton.Position = UDim2.new(0.75, 0, 0.8, 0); DiscordButton.AnchorPoint = Vector2.new(0.5, 0.5); DiscordButton.BackgroundTransparency = 1; DiscordButton.Text = "Join Discord"; DiscordButton.Font = Enum.Font.Gotham; DiscordButton.TextSize = 14; DiscordButton.TextColor3 = Color3.fromRGB(120, 160, 255); DiscordButton.Parent = MainFrame
    
    local StatusLabel = Instance.new("TextLabel"); StatusLabel.Size = UDim2.new(1, -40, 0, 20); StatusLabel.Position = UDim2.new(0.5, 0, 0.98, 0); StatusLabel.AnchorPoint = Vector2.new(0.5, 1); StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.Gotham; StatusLabel.TextSize = 12; StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 190); StatusLabel.Text = ""; StatusLabel.Parent = MainFrame

    DiscordButton.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(Discord_Invite); StatusLabel.TextColor3 = Color3.fromRGB(120, 255, 120); StatusLabel.Text = "Discord link copied to clipboard!"
        else StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80); StatusLabel.Text = "Your executor does not support setclipboard." end
    end)

    GetKeyButton.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(Linkvertise_Link); StatusLabel.TextColor3 = Color3.fromRGB(120, 255, 120); StatusLabel.Text = "Key link copied to clipboard!"
        else StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80); StatusLabel.Text = "Your executor does not support setclipboard." end
    end)
    
    SubmitButton.MouseButton1Click:Connect(function()
        local user_key = KeyInput.Text
        if #user_key < 16 then StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 80); StatusLabel.Text = "Error: Invalid key format."; return end
        
        StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 190); StatusLabel.Text = "Loading..."
        SubmitButton.Text = "..."; SubmitButton.Active = false

        getgenv().script_key = user_key
        
        LoaderUI:Destroy()
        
        local loader_url = "https://api.luarmor.net/files/v3/loaders/" .. current_script_id .. ".lua"
        local success, err = pcall(function()
            loadstring(game:HttpGet(loader_url))()
        end)
        
        if not success then warn("Vail Hub Main Script failed to execute. Error:", tostring(err)) end
        
        getgenv().VailHubLoaderActive = false
    end)

    MainFrame.BackgroundTransparency = 1; for _, child in ipairs(MainFrame:GetChildren()) do if child:IsA("GuiObject") then child.BackgroundTransparency = 1; if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then child.TextTransparency = 1 end end end; task.wait(0.1)
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    for _, child in ipairs(MainFrame:GetChildren()) do if child:IsA("GuiObject") then local bgTrans = 0.8; if child == SubmitButton then bgTrans = 0 end; if child == DiscordButton or child == GetKeyButton then bgTrans = 1 end; TweenService:Create(child, TweenInfo.new(0.5), {BackgroundTransparency = bgTrans, TextTransparency = 0}):Play() end end
end

createLoaderUI()
