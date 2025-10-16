repeat
    task.wait()
until game:IsLoaded()

local Hub_Name = 'Vail Hub'
local Discord_Invite = 'https://discord.gg/z6ngteTcT3'
local Linkvertise_Link = 'https://ads.luarmor.net/get_key?for=Vail_Hub_Key-lgGHKWosXGmT'

local PlaceIDs = {
    [12355337193] = 'https://api.luarmor.net/files/v3/loaders/c19180f7c85232d08ac0ee9b3c606e2d.lua',
    [13771457545] = 'https://api.luarmor.net/files/v3/loaders/c19180f7c85232d08ac0ee9b3c606e2d.lua',
}

local UILib
local fakeScriptForLib
pcall(function()
    fakeScriptForLib = Instance.new('Folder')
    getgenv().script = fakeScriptForLib
    local UILibSource = game:HttpGet(
        'https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua',
        true
    )
    UILib = loadstring(UILibSource)()
end)

if not UILib then
    warn('Vail Hub Loader: Critical Error loading UI Library.')
    return
end

makefolder(Hub_Name)
local key_path = Hub_Name .. '/Key.txt'
local saved_key = isfile(key_path) and readfile(key_path) or nil

local API =
    loadstring(game:HttpGet('https://sdkapi-public.luarmor.net/library.lua'))()
local HttpService = game:GetService('HttpService')
local AssetService = game:GetService('AssetService')
local Players = game:GetService('Players')

local current_script_url
local Pages = AssetService:GetGamePlacesAsync():GetCurrentPage()
while true do
    for _, place in ipairs(Pages) do
        if PlaceIDs[place.PlaceId] then
            current_script_url = PlaceIDs[place.PlaceId]
            break
        end
    end
    if current_script_url then
        break
    end
    if Pages.IsFinished then
        break
    end
    Pages:AdvanceToNextPageAsync()
end

local Window = UILib.new(Hub_Name, Players.LocalPlayer.UserId, 'Loader')

local function notify(title, content)
    Window:Notification({ Title = title, Desc = content, expire = 8 })
end

local function authenticate(input_key)
    if not current_script_url then
        notify('Error', 'This game is not supported.')
        return
    end

    local key_to_check = input_key or saved_key
    if not key_to_check or #key_to_check < 16 then
        notify('Error', 'Please enter a valid key.')
        return
    end

    getgenv().script_key = key_to_check
    writefile(key_path, key_to_check)

    Window.MainUI.Parent.Enabled = false

    pcall(function()
        loadstring(game:HttpGet(current_script_url))()
    end)

    Window.MainUI.Parent:Destroy()
    if fakeScriptForLib then
        fakeScriptForLib:Destroy()
    end
end

local Category = Window:Category('Loader', 'rbxassetid://8395726245')
local Tab = Category:Button('Main', 'rbxassetid://8395726245')
local Section = Tab:Section('Authentication', 'Left')
local Section2 = Tab:Section('Support', 'Right')

local KeyInput = Section:Textbox({
    Title = 'License Key',
    Default = saved_key or '',
}, function() end)

Section:Button({
    Title = 'Authenticate',
    ButtonName = 'LOAD',
}, function()
    authenticate(KeyInput:getValue())
end)

Section2:Button({
    Title = 'Get Key',
    ButtonName = 'LINKVERTISE',
}, function()
    setclipboard(Linkvertise_Link)
    notify('Success', 'Linkvertise link copied to clipboard.')
end)

Section2:Button({
    Title = 'Join Discord',
    ButtonName = 'DISCORD',
}, function()
    setclipboard(Discord_Invite)
    notify('Success', 'Discord invite link copied to clipboard.')
end)

Window:ChangeCategory('Loader')
Window:ChangeCategorySelection('Main')

if saved_key then
    authenticate(saved_key)
end
