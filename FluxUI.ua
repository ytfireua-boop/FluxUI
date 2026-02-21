--[[
    Simple UI Library for Roblox
    Standalone version - just copy and use
]]

local Library = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Default settings
local Settings = {
    Accent = Color3.fromRGB(0, 170, 255),
    Dark = Color3.fromRGB(25, 25, 25),
    Light = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    Keybind = Enum.KeyCode.RightShift
}

-- Main GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "LibraryUI"
GUI.ResetOnSpawn = false
GUI.Parent = CoreGui

-- Main Window
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.new(0, 600, 0, 400)
Window.Position = UDim2.new(0.5, -300, 0.5, -200)
Window.BackgroundColor3 = Settings.Dark
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent = GUI

-- Window Corners
local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 8)
WindowCorner.Parent = Window

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Settings.Light
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Window

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 8)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "UI Library"
Title.TextColor3 = Settings.Text
Title.Font = Settings.Font
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0.5, -12.5)
Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Close.Text = "X"
Close.TextColor3 = Settings.Text
Close.Font = Settings.Font
Close.TextSize = 16
Close.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = Close

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Settings.Light
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Window

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel = 0
TabContainer.ScrollBarThickness = 3
TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabContainer.Parent = Sidebar

local TabList = Instance.new("UIListLayout")
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 2)
TabList.Parent = TabContainer

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -150, 1, -35)
Content.Position = UDim2.new(0, 150, 0, 35)
Content.BackgroundTransparency = 1
Content.Parent = Window

local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -20, 1, -20)
ContentContainer.Position = UDim2.new(0, 10, 0, 10)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.ScrollBarThickness = 5
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.Parent = Content

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentContainer

-- Dragging
local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Close button
Close.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
end)

-- Toggle keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Settings.Keybind then
        Window.Visible = not Window.Visible
    end
end)

-- Library functions
function Library:CreateWindow(config)
    Title.Text = config.Title or "UI Library"
    Settings.Keybind = config.Keybind or Settings.Keybind
    Settings.Accent = config.Accent or Settings.Accent
    
    local WindowAPI = {}
    
    function WindowAPI:CreateTab(name)
        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.BackgroundColor3 = Settings.Dark
        TabButton.Text = name
        TabButton.TextColor3 = Settings.Text
        TabButton.Font = Settings.Font
        TabButton.TextSize = 14
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 5)
        TabButtonCorner.Parent = TabButton
        
        -- Tab content
        local TabContent = Instance.new("Frame")
        TabContent.Name = name
        TabContent.Size = UDim2.new(1, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 8)
        TabContentLayout.Parent = TabContent
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Settings.Dark
                end
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Settings.Accent
        end)
        
        -- Select first tab
        if #ContentContainer:GetChildren() == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Settings.Accent
        end
        
        local TabAPI = {}
        
        function TabAPI:AddSection(name)
            local Section = Instance.new("TextLabel")
            Section.Size = UDim2.new(1, 0, 0, 25)
            Section.BackgroundTransparency = 1
            Section.Text = name
            Section.TextColor3 = Settings.Accent
            Section.Font = Settings.Font
            Section.TextSize = 16
            Section.TextXAlignment = Enum.TextXAlignment.Left
            Section.Parent = TabContent
            
            return Section
        end
        
        function TabAPI:AddButton(text, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
            ButtonFrame.BackgroundColor3 = Settings.Light
            ButtonFrame.Parent = TabContent
            
            local ButtonFrameCorner = Instance.new("UICorner")
            ButtonFrameCorner.CornerRadius = UDim.new(0, 6)
            ButtonFrameCorner.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = text
            Button.TextColor3 = Settings.Text
            Button.Font = Settings.Font
            Button.TextSize = 14
            Button.Parent = ButtonFrame
            
            Button.MouseButton1Click:Connect(callback or function() end)
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Settings.Accent}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Settings.Light}):Play()
            end)
        end
        
        function TabAPI:AddToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = Settings.Light
            ToggleFrame.Parent = TabContent
            
            local ToggleFrameCorner = Instance.new("UICorner")
            ToggleFrameCorner.CornerRadius = UDim.new(0, 6)
            ToggleFrameCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Settings.Text
            ToggleLabel.Font = Settings.Font
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 30, 0, 20)
            ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            ToggleButton.BackgroundColor3 = Settings.Dark
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            ToggleIndicator.Parent = ToggleButton
            
            local ToggleIndicatorCorner = Instance.new("UICorner")
            ToggleIndicatorCorner.CornerRadius = UDim.new(1, 0)
            ToggleIndicatorCorner.Parent = ToggleIndicator
            
            local toggled = default or false
            
            local function update()
                if toggled then
                    ToggleIndicator:TweenPosition(UDim2.new(0, 12, 0.5, -8), "Out", "Quad", 0.2, true)
                    ToggleIndicator:TweenSize(UDim2.new(0, 16, 0, 16), "Out", "Quad", 0.2, true)
                    ToggleIndicator.BackgroundColor3 = Settings.Accent
                else
                    ToggleIndicator:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
                    ToggleIndicator:TweenSize(UDim2.new(0, 16, 0, 16), "Out", "Quad", 0.2, true)
                    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                end
                if callback then
                    callback(toggled)
                end
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                update()
            end)
            
            update()
            
            return {
                Set = function(state)
                    toggled = state
                    update()
                end,
                Get = function()
                    return toggled
                end
            }
        end
        
        function TabAPI:AddSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Settings.Light
            SliderFrame.Parent = TabContent
            
            local SliderFrameCorner = Instance.new("UICorner")
            SliderFrameCorner.CornerRadius = UDim.new(0, 6)
            SliderFrameCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text .. ": " .. (default or min)
            SliderLabel.TextColor3 = Settings.Text
            SliderLabel.Font = Settings.Font
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -30, 0, 8)
            SliderBar.Position = UDim2.new(0, 15, 0, 30)
            SliderBar.BackgroundColor3 = Settings.Dark
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Settings.Accent
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local value = default or min
            local dragging = false
            
            local function update(input)
                local pos = input.Position.X
                local barPos = SliderBar.AbsolutePosition.X
                local barSize = SliderBar.AbsoluteSize.X
                
                local percent = math.clamp((pos - barPos) / barSize, 0, 1)
                value = min + (max - min) * percent
                value = math.floor(value * 100) / 100
                
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderLabel.Text = text .. ": " .. value
                
                if callback then
                    callback(value)
                end
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            return {
                Set = function(new)
                    value = math.clamp(new, min, max)
                    local percent = (value - min) / (max - min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderLabel.Text = text .. ": " .. value
                    if callback then
                        callback(value)
                    end
                end,
                Get = function()
                    return value
                end
            }
        end
        
        function TabAPI:AddDropdown(text, options, default, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            DropdownFrame.BackgroundColor3 = Settings.Light
            DropdownFrame.Parent = TabContent
            DropdownFrame.ClipsDescendants = true
            
            local DropdownFrameCorner = Instance.new("UICorner")
            DropdownFrameCorner.CornerRadius = UDim.new(0, 6)
            DropdownFrameCorner.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 1, 0)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = text .. ": " .. (default or options[1])
            DropdownButton.TextColor3 = Settings.Text
            DropdownButton.Font = Settings.Font
            DropdownButton.TextSize = 14
            DropdownButton.Parent = DropdownFrame
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "List"
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.Position = UDim2.new(0, 0, 1, 0)
            DropdownList.BackgroundColor3 = Settings.Light
            DropdownList.Visible = false
            DropdownList.ClipsDescendants = true
            DropdownList.Parent = DropdownFrame
            
            local DropdownListCorner = Instance.new("UICorner")
            DropdownListCorner.CornerRadius = UDim.new(0, 6)
            DropdownListCorner.Parent = DropdownList
            
            local DropdownListLayout = Instance.new("UIListLayout")
            DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownListLayout.Padding = UDim.new(0, 2)
            DropdownListLayout.Parent = DropdownList
            
            local selected = default or options[1]
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, -10, 0, 30)
                OptionButton.Position = UDim2.new(0, 5, 0, 0)
                OptionButton.BackgroundColor3 = Settings.Dark
                OptionButton.Text = option
                OptionButton.TextColor3 = Settings.Text
                OptionButton.Font = Settings.Font
                OptionButton.TextSize = 14
                OptionButton.Parent = DropdownList
                
                local OptionButtonCorner = Instance.new("UICorner")
                OptionButtonCorner.CornerRadius = UDim.new(0, 4)
                OptionButtonCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    DropdownButton.Text = text .. ": " .. option
                    DropdownList.Visible = false
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                    if callback then
                        callback(option)
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                DropdownList.Visible = not DropdownList.Visible
                if DropdownList.Visible then
                    local height = #options * 32 + 10
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 35 + height)
                else
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                end
            end)
            
            return {
                Set = function(value)
                    if table.find(options, value) then
                        selected = value
                        DropdownButton.Text = text .. ": " .. value
                        if callback then
                            callback(value)
                        end
                    end
                end,
                Get = function()
                    return selected
                end
            }
        end
        
        function TabAPI:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Settings.Text
            Label.Font = Settings.Font
            Label.TextSize = 14
            Label.TextWrapped = true
            Label.Parent = TabContent
            
            return Label
        end
        
        return TabAPI
    end
    
    function WindowAPI:Destroy()
        GUI:Destroy()
    end
    
    function WindowAPI:SetVisible(bool)
        Window.Visible = bool
    end
    
    return WindowAPI
end

return Library
