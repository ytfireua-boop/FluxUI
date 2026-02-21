-- Load FluxUI
local FluxUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ytfireua-boop/FluxUI/refs/heads/main/FluxUI.ua"))()

-- Create Window
local Window = FluxUI:CreateWindow({
    Title = "FluxUI Demo",
    Keybind = Enum.KeyCode.RightShift,
    Accent = Color3.fromRGB(255, 0, 0) -- Red accent
})

-- Create Tab
local Main = Window:CreateTab("Main")

-- Add Section
Main:AddSection("Basic Elements")

-- Button
Main:AddButton("Click Me", function()
    print("Button clicked!")
end)

-- Toggle
local Toggle = Main:AddToggle("Enable Thing", true, function(state)
    print("Toggle:", state)
end)

-- Slider
Main:AddSlider("Volume", 0, 100, 50, function(value)
    print("Volume:", value)
end)

-- Dropdown
Main:AddDropdown("Options", {"Option 1", "Option 2", "Option 3"}, "Option 1", function(selected)
    print("Selected:", selected)
end)

-- Label
Main:AddLabel("This is a simple text label")

-- Second Tab
local Settings = Window:CreateTab("Settings")

Settings:AddSection("Configuration")

Settings:AddButton("Save Settings", function()
    print("Settings saved!")
end)

Settings:AddToggle("Dark Mode", true, function(state)
    print("Dark Mode:", state)
end)
