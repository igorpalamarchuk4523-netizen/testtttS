--[[
    Celestia UI Library
    Custom built from scratch
    Dark theme with purple accents
]]

local CelestiaLib = {}
CelestiaLib.__index = CelestiaLib

-- Services
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local CoreGui         = game:GetService("CoreGui")
local Players         = game:GetService("Players")

-- Theme
local Theme = {
    BG          = Color3.fromRGB(13, 13, 20),
    Sidebar     = Color3.fromRGB(17, 17, 26),
    Card        = Color3.fromRGB(22, 22, 34),
    CardHover   = Color3.fromRGB(28, 28, 44),
    Border      = Color3.fromRGB(40, 40, 62),
    Accent      = Color3.fromRGB(124, 77, 255),
    AccentDim   = Color3.fromRGB(80, 50, 180),
    AccentGlow  = Color3.fromRGB(150, 100, 255),
    TabActive   = Color3.fromRGB(30, 22, 55),
    TabText     = Color3.fromRGB(220, 220, 240),
    TabTextDim  = Color3.fromRGB(100, 100, 140),
    SectionText = Color3.fromRGB(120, 100, 200),
    White       = Color3.fromRGB(230, 230, 245),
    SliderFill  = Color3.fromRGB(124, 77, 255),
    SliderBG    = Color3.fromRGB(35, 35, 55),
    ToggleOff   = Color3.fromRGB(55, 55, 80),
    ToggleOn    = Color3.fromRGB(124, 77, 255),
    DropBG      = Color3.fromRGB(28, 28, 44),
    KeybindBG   = Color3.fromRGB(30, 30, 48),
}

-- Helpers
local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 13
    l.TextColor3 = color or Theme.White
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function frame(parent, bg, size, pos)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or Theme.Card
    f.BorderSizePixel = 0
    if size then f.Size = size end
    if pos then f.Position = pos end
    f.Parent = parent
    return f
end

-- Drag function for window
local function makeDraggable(dragHandle, dragTarget)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = dragTarget.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            dragTarget.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================================
-- INIT: Create the main window
-- ============================================================
function CelestiaLib:Init(config)
    config = config or {}
    local Name    = config.Name or "Celestia"
    local Keybind = config.Keybind and Enum.KeyCode[config.Keybind] or Enum.KeyCode.LeftControl
    local Logo    = config.Logo

    -- Destroy old GUI if exists
    if CoreGui:FindFirstChild("CelestiaUI") then
        CoreGui:FindFirstChild("CelestiaUI"):Destroy()
    end

    -- Screen GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CelestiaUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- Main Window
    local Window = frame(ScreenGui, Theme.BG,
        UDim2.new(0, 860, 0, 540),
        UDim2.new(0.5, -430, 0.5, -270))
    Window.Name = "Window"
    corner(Window, 12)
    stroke(Window, Theme.Border, 1)

    -- Drop shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = Window

    -- Titlebar
    local Titlebar = frame(Window, Theme.Sidebar,
        UDim2.new(1, 0, 0, 44))
    Titlebar.Name = "Titlebar"
    -- top corners only via UICorner + clip
    corner(Titlebar, 12)

    -- Extend titlebar bottom to cover bottom corners
    local TitlebarFix = frame(Window, Theme.Sidebar,
        UDim2.new(1, 0, 0, 12),
        UDim2.new(0, 0, 0, 32))
    TitlebarFix.Name = "TitlebarFix"

    -- Traffic lights
    local lights = {
        {Color3.fromRGB(255, 95, 87), 0},
        {Color3.fromRGB(255, 189, 46), 20},
        {Color3.fromRGB(40, 200, 64), 40},
    }
    for _, l2 in ipairs(lights) do
        local dot = frame(Titlebar, l2[1],
            UDim2.new(0, 12, 0, 12),
            UDim2.new(0, 14 + l2[2], 0.5, -6))
        corner(dot, 6)
    end

    -- Title
    local TitleDot = frame(Titlebar, Theme.Accent,
        UDim2.new(0, 8, 0, 8),
        UDim2.new(0.5, -45, 0.5, -4))
    corner(TitleDot, 4)

    local TitleLabel = label(Titlebar, Name, 14, Theme.White, Enum.Font.GothamBold)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0.5, -33, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    makeDraggable(Titlebar, Window)

    -- Sidebar
    local Sidebar = frame(Window, Theme.Sidebar,
        UDim2.new(0, 190, 1, -44),
        UDim2.new(0, 0, 0, 44))
    Sidebar.Name = "Sidebar"
    stroke(Sidebar, Theme.Border, 1)

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 4)
    SidebarList.Parent = Sidebar

    local SidebarPad = Instance.new("UIPadding")
    SidebarPad.PaddingTop = UDim.new(0, 10)
    SidebarPad.PaddingLeft = UDim.new(0, 8)
    SidebarPad.PaddingRight = UDim.new(0, 8)
    SidebarPad.Parent = Sidebar

    -- Vertical divider between sidebar and content
    local Divider = frame(Window, Theme.Border,
        UDim2.new(0, 1, 1, -44),
        UDim2.new(0, 190, 0, 44))
    Divider.Name = "Divider"

    -- Content area
    local Content = frame(Window, Theme.BG,
        UDim2.new(1, -191, 1, -44),
        UDim2.new(0, 191, 0, 44))
    Content.Name = "Content"
    Content.ClipsDescendants = true

    -- Keybind toggle
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Keybind then
            visible = not visible
            tween(Window, 0.3, {
                Size = visible and UDim2.new(0, 860, 0, 540) or UDim2.new(0, 860, 0, 0),
            })
        end
    end)

    local WindowObj = {
        _gui        = ScreenGui,
        _window     = Window,
        _sidebar    = Sidebar,
        _content    = Content,
        _tabs       = {},
        _activeTab  = nil,
    }
    setmetatable(WindowObj, {__index = CelestiaLib})

    -- DrawTab method
    function WindowObj:DrawTab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Name or "Tab"
        local tabIcon = cfg.Icon

        -- Tab button in sidebar
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundColor3 = Theme.Sidebar
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = self._sidebar
        corner(TabBtn, 8)

        -- Icon (using text symbol or image)
        local iconMap = {
            sword      = "⚔",
            user       = "◉",
            globe      = "◎",
            ["wrap-text"] = "≡",
            layers     = "⬡",
            settings   = "⚙",
        }
        local iconChar = iconMap[tabIcon] or "•"

        local TabIcon = label(TabBtn, iconChar, 14, Theme.TabTextDim, Enum.Font.GothamBold)
        TabIcon.Size = UDim2.new(0, 24, 1, 0)
        TabIcon.Position = UDim2.new(0, 10, 0, 0)
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center

        local TabLabel = label(TabBtn, tabName, 13, Theme.TabTextDim, Enum.Font.GothamMedium)
        TabLabel.Size = UDim2.new(1, -44, 1, 0)
        TabLabel.Position = UDim2.new(0, 38, 0, 0)

        -- Tab content page
        local Page = frame(self._content, Theme.BG,
            UDim2.new(1, 0, 1, 0),
            UDim2.new(0, 0, 0, 0))
        Page.Name = tabName .. "Page"
        Page.Visible = false
        Page.ClipsDescendants = true

        -- Scrollable content inside page
        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, 0, 1, 0)
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.ScrollBarThickness = 3
        Scroll.ScrollBarImageColor3 = Theme.Accent
        Scroll.ScrollBarImageTransparency = 0.4
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Scroll.Parent = Page

        local ScrollPad = Instance.new("UIPadding")
        ScrollPad.PaddingTop = UDim.new(0, 16)
        ScrollPad.PaddingLeft = UDim.new(0, 16)
        ScrollPad.PaddingRight = UDim.new(0, 8)
        ScrollPad.PaddingBottom = UDim.new(0, 16)
        ScrollPad.Parent = Scroll

        local ScrollList = Instance.new("UIListLayout")
        ScrollList.Padding = UDim.new(0, 12)
        ScrollList.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollList.Parent = Scroll

        -- Activate function
        local function activate()
            -- Deactivate all
            for _, t in ipairs(self._tabs) do
                tween(t.btn, 0.2, {BackgroundTransparency = 1})
                tween(t.icon, 0.2, {TextColor3 = Theme.TabTextDim})
                tween(t.lbl, 0.2, {TextColor3 = Theme.TabTextDim})
                t.page.Visible = false
            end
            -- Activate this
            tween(TabBtn, 0.2, {BackgroundTransparency = 0})
            tween(TabIcon, 0.2, {TextColor3 = Theme.AccentGlow})
            tween(TabLabel, 0.2, {TextColor3 = Theme.White})
            TabBtn.BackgroundColor3 = Theme.TabActive
            Page.Visible = true
            self._activeTab = tabName
        end

        TabBtn.MouseButton1Click:Connect(activate)

        TabBtn.MouseEnter:Connect(function()
            if self._activeTab ~= tabName then
                tween(TabBtn, 0.15, {BackgroundTransparency = 0.7})
                TabBtn.BackgroundColor3 = Theme.CardHover
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if self._activeTab ~= tabName then
                tween(TabBtn, 0.15, {BackgroundTransparency = 1})
            end
        end)

        local tabEntry = {
            btn = TabBtn, icon = TabIcon, lbl = TabLabel,
            page = Page, scroll = Scroll,
            activate = activate
        }
        table.insert(self._tabs, tabEntry)

        -- Activate first tab
        if #self._tabs == 1 then activate() end

        -- Section builder
        local TabObj = {_scroll = Scroll, _page = Page, _order = 0}

        function TabObj:AddSection(scfg)
            scfg = scfg or {}
            local secName = scfg.Name or "Section"
            self._order = (self._order or 0) + 1

            -- Section wrapper
            local SecWrap = frame(self._scroll, Color3.fromRGB(0,0,0), UDim2.new(1, -8, 0, 0))
            SecWrap.Name = secName .. "Wrap"
            SecWrap.BackgroundTransparency = 1
            SecWrap.AutomaticSize = Enum.AutomaticSize.Y
            SecWrap.LayoutOrder = self._order

            local SecLayout = Instance.new("UIListLayout")
            SecLayout.Padding = UDim.new(0, 6)
            SecLayout.Parent = SecWrap

            -- Section header
            local SecHeader = label(SecWrap, string.upper(secName), 10, Theme.SectionText, Enum.Font.GothamBold)
            SecHeader.Size = UDim2.new(1, 0, 0, 20)
            SecHeader.LayoutOrder = 0

            -- Grid for cards (2 columns)
            local Grid = frame(SecWrap, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, 0))
            Grid.BackgroundTransparency = 1
            Grid.AutomaticSize = Enum.AutomaticSize.Y
            Grid.LayoutOrder = 1

            local GridLayout = Instance.new("UIGridLayout")
            GridLayout.CellSize = UDim2.new(0.5, -4, 0, 90)
            GridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
            GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            GridLayout.Parent = Grid

            -- But sliders go full width - we'll handle per element
            local SecObj = {
                _grid = Grid,
                _gridLayout = GridLayout,
                _secWrap = SecWrap,
                _order = 0,
                _fullWidthItems = {},
            }

            -- Helper to create a card
            local function makeCard(fullWidth)
                local card = Instance.new("Frame")
                card.BackgroundColor3 = Theme.Card
                card.BorderSizePixel = 0
                card.Name = "Card"
                corner(card, 10)
                stroke(card, Theme.Border, 1)

                if fullWidth then
                    -- Full width card outside the grid
                    card.Size = UDim2.new(1, 0, 0, 62)
                    card.LayoutOrder = SecObj._order
                    card.Parent = SecWrap

                    local pad = Instance.new("UIPadding")
                    pad.PaddingLeft = UDim.new(0, 14)
                    pad.PaddingRight = UDim.new(0, 14)
                    pad.PaddingTop = UDim.new(0, 10)
                    pad.PaddingBottom = UDim.new(0, 10)
                    pad.Parent = card
                else
                    card.Size = UDim2.new(1, 0, 1, 0)
                    card.Parent = Grid

                    local pad = Instance.new("UIPadding")
                    pad.PaddingLeft = UDim.new(0, 12)
                    pad.PaddingRight = UDim.new(0, 12)
                    pad.PaddingTop = UDim.new(0, 10)
                    pad.PaddingBottom = UDim.new(0, 8)
                    pad.Parent = card
                end
                return card
            end

            -- =====================
            -- AddToggle
            -- =====================
            function SecObj:AddToggle(tcfg)
                tcfg = tcfg or {}
                local tName = tcfg.Name or "Toggle"
                local tDefault = tcfg.Default or false
                local tCallback = tcfg.Callback or function() end
                self._order = self._order + 1

                local card = makeCard(false)
                card.LayoutOrder = self._order

                -- Name
                local nameL = label(card, tName, 13, Theme.White, Enum.Font.GothamBold)
                nameL.Size = UDim2.new(1, -46, 0, 18)
                nameL.Position = UDim2.new(0, 0, 0, 0)

                -- Description (small)
                local descMap = {
                    ["Auto Parry"] = "Automatically parry incoming attacks",
                    ["Infinity Detection"] = "Detect infinite combo sequences",
                    ["Phantom Detection"] = "Detect phantom hit patterns",
                    ["Random Parry Accuracy"] = "Randomize parry accuracy value",
                    ["Keypress"] = "Manual keypress override mode",
                    ["Auto Spam Parry"] = "Spam parry when in range",
                    ["Animation Fix"] = "Fix parry animation timing",
                    ["Manual Spam Parry"] = "Manually spam parry input",
                    ["Triggerbot"] = "Auto trigger on ball detection",
                    ["Lobby Auto Parry"] = "Auto parry in lobby training",
                    ["Strafe"] = "Enable strafing movement",
                    ["Spinbot"] = "Spin character rapidly",
                    ["Field of View"] = "Adjust camera field of view",
                    ["Player Cosmetics"] = "Apply visual cosmetics",
                    ["Fly"] = "Enable fly mode",
                    ["Hit Sounds"] = "Play sounds on successful parry",
                    ["Random Accuracy"] = "Randomize parry accuracy value",
                }
                local descText = descMap[tName] or ""
                local descL = label(card, descText, 10, Theme.TabTextDim, Enum.Font.Gotham)
                descL.Size = UDim2.new(1, -46, 0, 14)
                descL.Position = UDim2.new(0, 0, 0, 20)
                descL.TextWrapped = true

                -- Keybind badge
                local KeyBadge = frame(card, Theme.KeybindBG,
                    UDim2.new(0, 44, 0, 18),
                    UDim2.new(0, 0, 1, -20))
                corner(KeyBadge, 4)
                stroke(KeyBadge, Theme.Border, 1)
                local keyL = label(KeyBadge, "None", 9, Theme.TabTextDim, Enum.Font.Gotham)
                keyL.Size = UDim2.new(1, 0, 1, 0)
                keyL.TextXAlignment = Enum.TextXAlignment.Center

                -- Toggle switch
                local switchTrack = frame(card, tDefault and Theme.ToggleOn or Theme.ToggleOff,
                    UDim2.new(0, 36, 0, 20),
                    UDim2.new(1, -36, 0, 0))
                corner(switchTrack, 10)

                local switchCircle = frame(switchTrack,
                    Color3.fromRGB(255, 255, 255),
                    UDim2.new(0, 16, 0, 16),
                    tDefault and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8))
                corner(switchCircle, 8)

                local toggled = tDefault
                if toggled then tCallback(true) end

                local function setToggle(val)
                    toggled = val
                    tween(switchTrack, 0.2, {BackgroundColor3 = val and Theme.ToggleOn or Theme.ToggleOff})
                    tween(switchCircle, 0.2, {Position = val and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                    tCallback(val)
                end

                local ClickBtn = Instance.new("TextButton")
                ClickBtn.Size = UDim2.new(1, 0, 1, 0)
                ClickBtn.BackgroundTransparency = 1
                ClickBtn.Text = ""
                ClickBtn.ZIndex = 5
                ClickBtn.Parent = card
                ClickBtn.MouseButton1Click:Connect(function()
                    setToggle(not toggled)
                end)

                card.MouseEnter:Connect(function()
                    tween(card, 0.15, {BackgroundColor3 = Theme.CardHover})
                end)
                card.MouseLeave:Connect(function()
                    tween(card, 0.15, {BackgroundColor3 = Theme.Card})
                end)

                return {
                    SetValue = function(_, v) setToggle(v) end,
                    GetValue = function() return toggled end,
                }
            end

            -- =====================
            -- AddSlider
            -- =====================
            function SecObj:AddSlider(scfg)
                scfg = scfg or {}
                local sName    = scfg.Name or "Slider"
                local sMin     = scfg.Min or 0
                local sMax     = scfg.Max or 100
                local sDefault = scfg.Default or sMin
                local sCallback = scfg.Callback or function() end
                self._order = self._order + 1

                -- Full width card
                local card = makeCard(true)
                card.LayoutOrder = self._order
                card.Size = UDim2.new(1, 0, 0, 68)

                -- Name + value display
                local nameL = label(card, sName, 13, Theme.White, Enum.Font.GothamBold)
                nameL.Size = UDim2.new(1, -50, 0, 16)
                nameL.Position = UDim2.new(0, 0, 0, 0)

                -- Value badge
                local valBadge = frame(card, Theme.KeybindBG,
                    UDim2.new(0, 44, 0, 20),
                    UDim2.new(1, -44, 0, 0))
                corner(valBadge, 6)
                local valL = label(valBadge, tostring(sDefault), 11, Theme.AccentGlow, Enum.Font.GothamBold)
                valL.Size = UDim2.new(1, 0, 1, 0)
                valL.TextXAlignment = Enum.TextXAlignment.Center

                -- Slider track
                local trackBG = frame(card, Theme.SliderBG,
                    UDim2.new(1, 0, 0, 6),
                    UDim2.new(0, 0, 0, 26))
                corner(trackBG, 3)

                local trackFill = frame(trackBG, Theme.SliderFill,
                    UDim2.new((sDefault - sMin) / (sMax - sMin), 0, 1, 0),
                    UDim2.new(0, 0, 0, 0))
                corner(trackFill, 3)

                -- Knob
                local knob = frame(trackBG, Theme.White,
                    UDim2.new(0, 14, 0, 14),
                    UDim2.new((sDefault - sMin) / (sMax - sMin), -7, 0.5, -7))
                corner(knob, 7)
                stroke(knob, Theme.AccentDim, 2)

                local currentVal = sDefault
                local dragging = false

                local function updateSlider(inputX)
                    local trackPos = trackBG.AbsolutePosition.X
                    local trackSize = trackBG.AbsoluteSize.X
                    local rel = math.clamp((inputX - trackPos) / trackSize, 0, 1)
                    local rawVal = sMin + rel * (sMax - sMin)
                    -- Round to step
                    local step = scfg.Step or 0.5
                    rawVal = math.round(rawVal / step) * step
                    rawVal = math.clamp(rawVal, sMin, sMax)
                    currentVal = rawVal

                    -- Format display
                    local display = tostring(math.floor(rawVal))
                    if rawVal ~= math.floor(rawVal) then
                        display = string.format("%.1f", rawVal)
                    end
                    valL.Text = display

                    tween(trackFill, 0.05, {Size = UDim2.new(rel, 0, 1, 0)})
                    tween(knob, 0.05, {Position = UDim2.new(rel, -7, 0.5, -7)})
                    sCallback(rawVal)
                end

                trackBG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input.Position.X)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input.Position.X)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                sCallback(sDefault)

                return {
                    SetValue = function(_, v)
                        local rel = math.clamp((v - sMin) / (sMax - sMin), 0, 1)
                        currentVal = v
                        valL.Text = tostring(v)
                        trackFill.Size = UDim2.new(rel, 0, 1, 0)
                        knob.Position = UDim2.new(rel, -7, 0.5, -7)
                    end,
                    GetValue = function() return currentVal end,
                }
            end

            -- =====================
            -- AddDropdown
            -- =====================
            function SecObj:AddDropdown(dcfg)
                dcfg = dcfg or {}
                local dName     = dcfg.Name or "Dropdown"
                local dValues   = dcfg.Values or {}
                local dDefault  = dcfg.Default or (dValues[1] or "")
                local dCallback = dcfg.Callback or function() end
                local dMulti    = dcfg.Multi or false
                self._order = self._order + 1

                local card = makeCard(false)
                card.LayoutOrder = self._order

                local nameL = label(card, dName, 13, Theme.White, Enum.Font.GothamBold)
                nameL.Size = UDim2.new(1, 0, 0, 16)
                nameL.Position = UDim2.new(0, 0, 0, 0)

                -- Small description
                local descL = label(card, "Animation curve for parry motion", 10, Theme.TabTextDim, Enum.Font.Gotham)
                descL.Size = UDim2.new(1, 0, 0, 12)
                descL.Position = UDim2.new(0, 0, 0, 18)

                -- Dropdown button
                local dropBtn = Instance.new("TextButton")
                dropBtn.Size = UDim2.new(1, 0, 0, 24)
                dropBtn.Position = UDim2.new(0, 0, 1, -26)
                dropBtn.BackgroundColor3 = Theme.DropBG
                dropBtn.BorderSizePixel = 0
                dropBtn.Text = ""
                dropBtn.AutoButtonColor = false
                dropBtn.Parent = card
                corner(dropBtn, 6)
                stroke(dropBtn, Theme.Border, 1)

                local selectedL = label(dropBtn, dDefault, 11, Theme.White, Enum.Font.GothamMedium)
                selectedL.Size = UDim2.new(1, -24, 1, 0)
                selectedL.Position = UDim2.new(0, 8, 0, 0)
                selectedL.TextXAlignment = Enum.TextXAlignment.Left

                local arrowL = label(dropBtn, "∨", 10, Theme.TabTextDim, Enum.Font.GothamBold)
                arrowL.Size = UDim2.new(0, 20, 1, 0)
                arrowL.Position = UDim2.new(1, -22, 0, 0)
                arrowL.TextXAlignment = Enum.TextXAlignment.Center

                local currentVal = dDefault
                if dDefault ~= "" then dCallback(dDefault) end

                -- Dropdown list (appears above/below)
                local dropOpen = false
                local DropList = nil

                local function closeDropdown()
                    if DropList then
                        DropList:Destroy()
                        DropList = nil
                    end
                    dropOpen = false
                    tween(arrowL, 0.15, {Rotation = 0})
                end

                dropBtn.MouseButton1Click:Connect(function()
                    if dropOpen then
                        closeDropdown()
                        return
                    end
                    dropOpen = true
                    tween(arrowL, 0.15, {Rotation = 180})

                    DropList = frame(CoreGui:FindFirstChild("CelestiaUI"), Theme.DropBG,
                        UDim2.new(0, dropBtn.AbsoluteSize.X, 0, math.min(#dValues * 28, 140)))
                    DropList.Name = "DropList"
                    DropList.ZIndex = 100
                    corner(DropList, 8)
                    stroke(DropList, Theme.Border, 1)
                    DropList.ClipsDescendants = true

                    -- Position below button
                    local absPos = dropBtn.AbsolutePosition
                    local absSize = dropBtn.AbsoluteSize
                    DropList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)

                    local listScroll = Instance.new("ScrollingFrame")
                    listScroll.Size = UDim2.new(1, 0, 1, 0)
                    listScroll.BackgroundTransparency = 1
                    listScroll.BorderSizePixel = 0
                    listScroll.ScrollBarThickness = 2
                    listScroll.ScrollBarImageColor3 = Theme.Accent
                    listScroll.CanvasSize = UDim2.new(0, 0, 0, #dValues * 28)
                    listScroll.Parent = DropList
                    listScroll.ZIndex = 101

                    local listLayout = Instance.new("UIListLayout")
                    listLayout.Parent = listScroll

                    for _, val in ipairs(dValues) do
                        local item = Instance.new("TextButton")
                        item.Size = UDim2.new(1, 0, 0, 28)
                        item.BackgroundColor3 = val == currentVal and Theme.TabActive or Theme.DropBG
                        item.BackgroundTransparency = val == currentVal and 0 or 1
                        item.BorderSizePixel = 0
                        item.Text = val
                        item.TextColor3 = val == currentVal and Theme.White or Theme.TabTextDim
                        item.TextSize = 12
                        item.Font = Enum.Font.GothamMedium
                        item.TextXAlignment = Enum.TextXAlignment.Left
                        item.ZIndex = 102
                        item.AutoButtonColor = false
                        item.Parent = listScroll
                        corner(item, 4)

                        local itemPad = Instance.new("UIPadding")
                        itemPad.PaddingLeft = UDim.new(0, 10)
                        itemPad.Parent = item

                        item.MouseButton1Click:Connect(function()
                            currentVal = val
                            selectedL.Text = val
                            dCallback(val)
                            closeDropdown()
                        end)

                        item.MouseEnter:Connect(function()
                            if val ~= currentVal then
                                tween(item, 0.1, {BackgroundTransparency = 0.7, BackgroundColor3 = Theme.CardHover})
                            end
                        end)
                        item.MouseLeave:Connect(function()
                            if val ~= currentVal then
                                tween(item, 0.1, {BackgroundTransparency = 1})
                            end
                        end)
                    end

                    -- Close on outside click
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            task.wait(0.05)
                            if dropOpen then
                                closeDropdown()
                            end
                            conn:Disconnect()
                        end
                    end)
                end)

                card.MouseEnter:Connect(function()
                    tween(card, 0.15, {BackgroundColor3 = Theme.CardHover})
                end)
                card.MouseLeave:Connect(function()
                    tween(card, 0.15, {BackgroundColor3 = Theme.Card})
                end)

                return {
                    SetValue = function(_, v)
                        currentVal = v
                        selectedL.Text = v
                    end,
                    GetValue = function() return currentVal end,
                }
            end

            -- =====================
            -- AddButton
            -- =====================
            function SecObj:AddButton(bcfg)
                bcfg = bcfg or {}
                local bName     = bcfg.Name or "Button"
                local bCallback = bcfg.Callback or function() end
                self._order = self._order + 1

                local card = makeCard(false)
                card.LayoutOrder = self._order

                local nameL = label(card, bName, 13, Theme.White, Enum.Font.GothamBold)
                nameL.Size = UDim2.new(1, 0, 0, 18)
                nameL.Position = UDim2.new(0, 0, 0.5, -9)
                nameL.TextXAlignment = Enum.TextXAlignment.Center

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.ZIndex = 5
                btn.Parent = card

                btn.MouseButton1Click:Connect(function()
                    tween(card, 0.1, {BackgroundColor3 = Theme.AccentDim})
                    task.delay(0.15, function()
                        tween(card, 0.15, {BackgroundColor3 = Theme.Card})
                    end)
                    bCallback()
                end)

                card.MouseEnter:Connect(function()
                    tween(card, 0.15, {BackgroundColor3 = Theme.CardHover})
                end)
                card.MouseLeave:Connect(function()
                    tween(card, 0.15, {BackgroundColor3 = Theme.Card})
                end)
            end

            -- =====================
            -- AddLabel
            -- =====================
            function SecObj:AddLabel(lcfg)
                lcfg = lcfg or {}
                local lText = type(lcfg) == "string" and lcfg or (lcfg.Name or "Label")
                self._order = self._order + 1

                local card = makeCard(true)
                card.LayoutOrder = self._order
                card.Size = UDim2.new(1, 0, 0, 40)

                local lbl = label(card, lText, 12, Theme.TabTextDim, Enum.Font.Gotham)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.TextWrapped = true

                return {
                    Edit = function(_, v) lbl.Text = v end,
                }
            end

            return SecObj
        end

        return TabObj
    end

    return WindowObj
end

return CelestiaLib
