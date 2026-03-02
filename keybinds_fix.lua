--[[
╔══════════════════════════════════════════════════════════════════╗
║          C E L E S T I A   U I   L I B R A R Y   v2            ║
║       Redesigned to match the premium look                      ║
║       Features: Glow, Proper Slider+Input, Emoji Icons          ║
╠══════════════════════════════════════════════════════════════════╣
║  USAGE:                                                          ║
║    local UI  = loadstring(game:HttpGet("RAW_URL"))()             ║
║    local win = UI:CreateWindow({                                 ║
║        Title      = "Celestia",                                 ║
║        Subtitle   = "Blade Ball Cheat",                         ║
║        ToggleKey  = Enum.KeyCode.Insert,                        ║
║    })                                                            ║
║                                                                  ║
║    local nav  = win:Category("NAVIGATION")                      ║
║    local main = nav:Tab({ Title = "Main", Icon = "🌐" })        ║
║    local c1   = main:Card({ Title = "Auto Parry", Icon = "🌐" })║
║    c1:Toggle({ Title="Auto Parry", Default=false,               ║
║                Callback=function(v) end })                      ║
║    c1:Slider({ Title="Parry Accuracy", Min=1, Max=100,          ║
║                Default=100, Suffix="%",                         ║
║                Callback=function(v) end })                      ║
║    c1:Dropdown({ Title="Parry Type",                            ║
║                  Options={"Camera","Random","Backwards"},       ║
║                  Default="Camera",                              ║
║                  Callback=function(v) end })                    ║
║    win:Show()                                                    ║
╚══════════════════════════════════════════════════════════════════╝
]]

-- ════════════════════════════════════════════════════════
--  SERVICES
-- ════════════════════════════════════════════════════════
local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local UIS           = game:GetService("UserInputService")
local CoreGui       = game:GetService("CoreGui")
local RunService    = game:GetService("RunService")
local lp            = Players.LocalPlayer

-- ════════════════════════════════════════════════════════
--  COLOR PALETTE
-- ════════════════════════════════════════════════════════
local C = {
    -- Backgrounds
    BG              = Color3.fromRGB(10,  12,  22),
    BGAlt           = Color3.fromRGB(13,  15,  27),
    Sidebar         = Color3.fromRGB(12,  14,  24),
    SidebarAct      = Color3.fromRGB(32,  30,  72),
    SidebarHov      = Color3.fromRGB(20,  22,  40),
    Header          = Color3.fromRGB(12,  14,  24),
    Card            = Color3.fromRGB(16,  18,  33),
    CardHov         = Color3.fromRGB(19,  21,  38),
    CardBorder      = Color3.fromRGB(30,  32,  58),
    CardBorderHov   = Color3.fromRGB(55,  50, 140),
    Surface         = Color3.fromRGB(20,  22,  42),
    SurfaceHov      = Color3.fromRGB(28,  30,  54),
    Input           = Color3.fromRGB(12,  14,  26),
    InputFocus      = Color3.fromRGB(18,  20,  38),
    InputBord       = Color3.fromRGB(32,  34,  62),
    InputBordFocus  = Color3.fromRGB(88,  78, 208),

    -- Slider
    SliderBG        = Color3.fromRGB(20,  22,  44),
    SliderFill      = Color3.fromRGB(88,  78, 208),
    SliderFillBr    = Color3.fromRGB(112, 100, 240),
    Knob            = Color3.fromRGB(255, 255, 255),
    KnobShadow      = Color3.fromRGB(88,  78, 208),

    -- Accents
    Accent          = Color3.fromRGB(95,  85, 220),
    AccentBr        = Color3.fromRGB(130, 118, 255),
    AccentDim       = Color3.fromRGB(52,  46, 130),
    AccentDark      = Color3.fromRGB(30,  26,  80),
    AccentGlow      = Color3.fromRGB(80,  70, 200),

    -- Icon backgrounds
    IconBG          = Color3.fromRGB(45,  40, 120),
    IconBGBr        = Color3.fromRGB(60,  54, 155),

    -- Toggle
    TogON           = Color3.fromRGB(88,  78, 208),
    TogOFF          = Color3.fromRGB(25,  24,  48),
    TogKnob         = Color3.fromRGB(255, 255, 255),

    -- Checkbox
    CheckON         = Color3.fromRGB(88,  78, 208),
    CheckOFF        = Color3.fromRGB(22,  20,  45),
    CheckBord       = Color3.fromRGB(50,  44, 118),

    -- Lines / dividers
    Line            = Color3.fromRGB(22,  24,  44),
    LineBr          = Color3.fromRGB(34,  36,  64),

    -- Text
    Text            = Color3.fromRGB(225, 225, 245),
    TextSub         = Color3.fromRGB(145, 140, 180),
    TextDim         = Color3.fromRGB(80,  76, 115),
    TextCat         = Color3.fromRGB(80,  76, 130),
    TextAccent      = Color3.fromRGB(130, 118, 255),
    White           = Color3.fromRGB(255, 255, 255),

    -- Status colors
    Green           = Color3.fromRGB(68,  200, 130),
    GreenDim        = Color3.fromRGB(30,  80,  55),
    Red             = Color3.fromRGB(220,  68,  68),
    RedDim          = Color3.fromRGB(80,  28,  28),
    Yellow          = Color3.fromRGB(230, 185,  50),
    YellowDim       = Color3.fromRGB(80,  65,  20),
    Blue            = Color3.fromRGB(68, 148, 220),

    -- Glow color (used for ImageLabel glow effects)
    GlowAccent      = Color3.fromRGB(88,  78, 208),
    GlowGreen       = Color3.fromRGB(68,  200, 130),
    GlowRed         = Color3.fromRGB(220,  68,  68),
}

-- ════════════════════════════════════════════════════════
--  TWEEN HELPER
-- ════════════════════════════════════════════════════════
local function tw(obj, props, t, style, dir)
    TweenService:Create(
        obj,
        TweenInfo.new(
            t     or 0.18,
            style or Enum.EasingStyle.Quart,
            dir   or Enum.EasingDirection.Out
        ),
        props
    ):Play()
end

local function twSpring(obj, props, t)
    tw(obj, props, t or 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

-- ════════════════════════════════════════════════════════
--  INSTANCE FACTORY
-- ════════════════════════════════════════════════════════
local function new(cls, props, parent)
    local o = Instance.new(cls)
    if props then
        for k, v in pairs(props) do
            o[k] = v
        end
    end
    if parent then o.Parent = parent end
    return o
end

-- ── Shortcuts ──────────────────────────────────────────
local function corner(p, r)
    return new("UICorner", { CornerRadius = UDim.new(0, r or 8) }, p)
end

local function stroke(p, col, th, tr)
    return new("UIStroke", {
        Color        = col or C.CardBorder,
        Thickness    = th  or 1,
        Transparency = tr  or 0,
    }, p)
end

local function pad(p, t, b, l, r)
    return new("UIPadding", {
        PaddingTop    = UDim.new(0, t or 8),
        PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft   = UDim.new(0, l or 10),
        PaddingRight  = UDim.new(0, r or 10),
    }, p)
end

local function listV(p, sp)
    return new("UIListLayout", {
        FillDirection       = Enum.FillDirection.Vertical,
        Padding             = UDim.new(0, sp or 0),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder           = Enum.SortOrder.LayoutOrder,
    }, p)
end

local function listH(p, sp)
    return new("UIListLayout", {
        FillDirection      = Enum.FillDirection.Horizontal,
        Padding            = UDim.new(0, sp or 0),
        VerticalAlignment  = Enum.VerticalAlignment.Center,
        SortOrder          = Enum.SortOrder.LayoutOrder,
    }, p)
end

local function lbl(props, parent)
    local o = new("TextLabel", {
        BackgroundTransparency = 1,
        TextXAlignment         = Enum.TextXAlignment.Left,
        TextYAlignment         = Enum.TextYAlignment.Center,
        RichText               = true,
    }, parent)
    if props then
        for k, v in pairs(props) do o[k] = v end
    end
    return o
end

local function btn(props, parent)
    local o = new("TextButton", {
        BackgroundTransparency = 1,
        AutoButtonColor        = false,
        Text                   = "",
    }, parent)
    if props then
        for k, v in pairs(props) do o[k] = v end
    end
    return o
end

-- ════════════════════════════════════════════════════════
--  GLOW HELPER
--  Многослойный глоу через полупрозрачные фреймы + UICorner
--  Работает без внешних assetid
-- ════════════════════════════════════════════════════════

-- Создаёт "ауру" вокруг элемента: несколько концентрических
-- полупрозрачных прямоугольников с нарастающим corner radius
local function makeGlow(parent, size, color, transparency)
    transparency = transparency or 0.55
    color        = color or Color3.fromRGB(88, 78, 208)
    size         = size  or 80

    local container = new("Frame", {
        Name                   = "GlowContainer",
        AnchorPoint            = Vector2.new(0.5, 0.5),
        Size                   = UDim2.fromOffset(size, size),
        Position               = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        ZIndex                 = parent.ZIndex or 1,
        ClipsDescendants       = false,
    }, parent)

    -- 4 слоя, каждый чуть больше предыдущего и прозрачнее
    local layers = {
        { expand = 0,  alpha = transparency + 0.00 },
        { expand = 6,  alpha = transparency + 0.15 },
        { expand = 12, alpha = transparency + 0.30 },
        { expand = 20, alpha = transparency + 0.48 },
    }
    for _, l in ipairs(layers) do
        local f = new("Frame", {
            AnchorPoint            = Vector2.new(0.5, 0.5),
            Size                   = UDim2.fromOffset(size + l.expand, size + l.expand),
            Position               = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3       = color,
            BackgroundTransparency = math.min(l.alpha, 0.98),
            BorderSizePixel        = 0,
            ZIndex                 = (parent.ZIndex or 1),
        }, container)
        corner(f, math.floor((size + l.expand) / 2))
    end

    return container
end

-- Маленький глоу для иконки карточки
local function makeIconGlow(parent, color)
    return makeGlow(parent, 34, color or Color3.fromRGB(88, 78, 208), 0.72)
end

-- Глоу-обводка для активных элементов (toggle on, checkbox on)
local function makeAccentGlow(frame, color, radius)
    local g = new("UIStroke", {
        Color        = color or Color3.fromRGB(88, 78, 208),
        Thickness    = 2,
        Transparency = 0.0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, frame)
    return g
end

-- ════════════════════════════════════════════════════════
--  SCREEN GUI
-- ════════════════════════════════════════════════════════
local SG = new("ScreenGui", {
    Name           = "CelestiaUI_v2",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})
pcall(function() SG.Parent = CoreGui end)
if not SG.Parent then SG.Parent = lp:WaitForChild("PlayerGui") end

-- ════════════════════════════════════════════════════════
--  NOTIFICATION SYSTEM
-- ════════════════════════════════════════════════════════
local NotifHolder = new("Frame", {
    Name                   = "NotifHolder",
    Size                   = UDim2.fromOffset(300, 0),
    AnchorPoint            = Vector2.new(1, 1),
    Position               = UDim2.new(1, -16, 1, -16),
    BackgroundTransparency = 1,
    AutomaticSize          = Enum.AutomaticSize.Y,
    ZIndex                 = 500,
}, SG)
listV(NotifHolder, 8)

-- ════════════════════════════════════════════════════════
--  LIBRARY OBJECT
-- ════════════════════════════════════════════════════════
local CelestiaUI = {}
CelestiaUI.__index = CelestiaUI

-- ── Notify ─────────────────────────────────────────────
function CelestiaUI:Notify(o)
    o = o or {}
    local title   = o.Title    or "Notice"
    local desc    = o.Desc     or ""
    local dur     = o.Duration or 4
    local nType   = o.Type     or "info"
    local accent  = ({
        success = C.Green,
        error   = C.Red,
        warn    = C.Yellow,
        info    = C.Accent,
    })[nType] or C.Accent
    local glowCol = ({
        success = C.GlowGreen,
        error   = C.GlowRed,
        warn    = C.Yellow,
        info    = C.GlowAccent,
    })[nType] or C.GlowAccent

    local card = new("Frame", {
        Size             = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = C.Card,
        ClipsDescendants = true,
        ZIndex           = 501,
    }, NotifHolder)
    corner(card, 10)
    stroke(card, accent, 1, 0.4)

    -- Акцентная полоска слева уже создаёт визуальный акцент

    -- Left accent bar
    new("Frame", {
        Size             = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accent,
        BorderSizePixel  = 0,
        ZIndex           = 502,
    }, card)

    -- Icon
    local iBox = new("Frame", {
        Size             = UDim2.fromOffset(28, 28),
        AnchorPoint      = Vector2.new(0, 0.5),
        Position         = UDim2.new(0, 14, 0.5, 0),
        BackgroundColor3 = C.IconBG,
        ZIndex           = 503,
    }, card)
    corner(iBox, 7)
    local iconEmoji = ({success="✅", error="❌", warn="⚠️", info="ℹ️"})[nType] or "ℹ️"
    lbl({
        Size=UDim2.new(1,0,1,0), Text=iconEmoji,
        TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Center, ZIndex=504,
    }, iBox)

    -- Text content
    lbl({
        Size=UDim2.fromOffset(230, 18),
        Position=UDim2.fromOffset(52, 10),
        Text=title, TextColor3=C.Text,
        Font=Enum.Font.GothamBold, TextSize=13, ZIndex=503,
    }, card)
    lbl({
        Size=UDim2.fromOffset(230, 16),
        Position=UDim2.fromOffset(52, 30),
        Text=desc, TextColor3=C.TextSub,
        Font=Enum.Font.Gotham, TextSize=11, ZIndex=503,
        TextTruncate=Enum.TextTruncate.AtEnd,
    }, card)

    -- Progress bar
    local prog = new("Frame", {
        Size             = UDim2.new(1, 0, 0, 2),
        Position         = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = accent,
        BorderSizePixel  = 0,
        ZIndex           = 503,
    }, card)

    -- Animate in
    card.Size = UDim2.new(1, 0, 0, 0)
    twSpring(card, { Size = UDim2.new(1, 0, 0, 68) }, 0.3)
    tw(prog, { Size = UDim2.new(0, 0, 0, 2) }, dur, Enum.EasingStyle.Linear)

    task.delay(dur, function()
        tw(card, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
        task.delay(0.25, function() card:Destroy() end)
    end)
end

-- ════════════════════════════════════════════════════════
--  CREATE WINDOW
-- ════════════════════════════════════════════════════════
function CelestiaUI:CreateWindow(opts)
    opts = opts or {}
    local winTitle  = opts.Title      or "Celestia"
    local winSub    = opts.Subtitle   or "UI Library"
    local toggleKey = opts.ToggleKey  or Enum.KeyCode.Insert

    local Window = setmetatable({}, { __index = CelestiaUI })

    -- ── Root Frame ─────────────────────────────────────
    local Root = new("Frame", {
        Name             = "CelestiaRoot",
        Size             = UDim2.fromOffset(820, 540),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = C.BG,
        ClipsDescendants = true,
        ZIndex           = 10,
        Visible          = false,
    }, SG)
    corner(Root, 14)
    stroke(Root, C.CardBorder, 1, 0.2)

    -- Subtle background gradient
    new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(14, 16, 30)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(11, 12, 22)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 11, 20)),
        }),
        Rotation = 135,
    }, Root)

    -- Glow вокруг окна через вложенные фреймы
    local rootGlowContainer = new("Frame", {
        Name                   = "RootGlow",
        Size                   = UDim2.new(1, 0, 1, 0),
        Position               = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        ZIndex                 = 9,
        ClipsDescendants       = false,
    }, Root)
    local winGlowData = {
        { exp = 3,  al = 0.72 },
        { exp = 7,  al = 0.82 },
        { exp = 12, al = 0.90 },
        { exp = 18, al = 0.95 },
    }
    for _, gd in ipairs(winGlowData) do
        local gf = new("Frame", {
            AnchorPoint            = Vector2.new(0.5, 0.5),
            Size                   = UDim2.new(1, gd.exp*2, 1, gd.exp*2),
            Position               = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3       = C.Accent,
            BackgroundTransparency = gd.al,
            BorderSizePixel        = 0,
            ZIndex                 = 9,
        }, rootGlowContainer)
        corner(gf, 14 + gd.exp)
    end

    -- ── Header ─────────────────────────────────────────
    local Hdr = new("Frame", {
        Name             = "Header",
        Size             = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = C.Header,
        ZIndex           = 11,
    }, Root)

    -- Header bottom divider
    new("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = C.Line,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Hdr)

    -- Header gradient
    new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 18, 32)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 24)),
        }),
        Rotation = 90,
    }, Hdr)

    -- App icon box with glow
    local hIconContainer = new("Frame", {
        Size                   = UDim2.fromOffset(38, 38),
        AnchorPoint            = Vector2.new(0, 0.5),
        Position               = UDim2.new(0, 16, 0.5, 0),
        BackgroundTransparency = 1,
        ZIndex                 = 12,
    }, Hdr)
    local hIconBox = new("Frame", {
        Size             = UDim2.fromOffset(38, 38),
        BackgroundColor3 = C.IconBG,
        ZIndex           = 13,
    }, hIconContainer)
    corner(hIconBox, 10)
    stroke(hIconBox, C.AccentBr, 1, 0.5)
    -- Inner gradient on icon box
    new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.IconBGBr),
            ColorSequenceKeypoint.new(1, C.IconBG),
        }),
        Rotation = 135,
    }, hIconBox)
    -- Header icon glow layers
    for _, gd in ipairs({{exp=6,al=0.68},{exp=12,al=0.80},{exp=20,al=0.90}}) do
        local gf = new("Frame", {
            AnchorPoint            = Vector2.new(0.5,0.5),
            Size                   = UDim2.fromOffset(38+gd.exp*2, 38+gd.exp*2),
            Position               = UDim2.new(0.5,0,0.5,0),
            BackgroundColor3       = C.Accent,
            BackgroundTransparency = gd.al,
            BorderSizePixel        = 0,
            ZIndex                 = 12,
        }, hIconContainer)
        corner(gf, 10 + gd.exp)
    end
    lbl({
        Size             = UDim2.new(1, 0, 1, 0),
        Text             = "⬡",
        TextColor3       = C.White,
        Font             = Enum.Font.GothamBold,
        TextSize         = 20,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 14,
    }, hIconBox)

    -- Title + Subtitle
    lbl({
        Size       = UDim2.fromOffset(400, 22),
        Position   = UDim2.fromOffset(64, 10),
        Text       = winTitle,
        TextColor3 = C.Text,
        Font       = Enum.Font.GothamBold,
        TextSize   = 16,
        ZIndex     = 12,
    }, Hdr)
    lbl({
        Size       = UDim2.fromOffset(400, 16),
        Position   = UDim2.fromOffset(64, 34),
        Text       = winSub,
        TextColor3 = C.TextSub,
        Font       = Enum.Font.Gotham,
        TextSize   = 11,
        ZIndex     = 12,
    }, Hdr)

    -- Settings button
    local settBtn = new("TextButton", {
        Size             = UDim2.fromOffset(34, 34),
        AnchorPoint      = Vector2.new(1, 0.5),
        Position         = UDim2.new(1, -54, 0.5, 0),
        BackgroundColor3 = C.Surface,
        Text             = "⚙",
        TextColor3       = C.TextSub,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        AutoButtonColor  = false,
        ZIndex           = 12,
    }, Hdr)
    corner(settBtn, 8)
    stroke(settBtn, C.CardBorder, 1, 0.3)
    settBtn.MouseEnter:Connect(function()
        tw(settBtn, { BackgroundColor3 = C.SidebarAct, TextColor3 = C.AccentBr }, 0.12)
    end)
    settBtn.MouseLeave:Connect(function()
        tw(settBtn, { BackgroundColor3 = C.Surface, TextColor3 = C.TextSub }, 0.12)
    end)

    -- Close button
    local xBtn = new("TextButton", {
        Size             = UDim2.fromOffset(34, 34),
        AnchorPoint      = Vector2.new(1, 0.5),
        Position         = UDim2.new(1, -14, 0.5, 0),
        BackgroundColor3 = C.Surface,
        Text             = "✕",
        TextColor3       = C.TextSub,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        AutoButtonColor  = false,
        ZIndex           = 12,
    }, Hdr)
    corner(xBtn, 8)
    stroke(xBtn, C.CardBorder, 1, 0.3)
    xBtn.MouseEnter:Connect(function()
        tw(xBtn, { BackgroundColor3 = C.RedDim, TextColor3 = C.Red }, 0.12)
    end)
    xBtn.MouseLeave:Connect(function()
        tw(xBtn, { BackgroundColor3 = C.Surface, TextColor3 = C.TextSub }, 0.12)
    end)
    xBtn.MouseButton1Click:Connect(function()
        tw(Root, { Size = UDim2.fromOffset(820, 0) }, 0.22, Enum.EasingStyle.Quart)
        task.delay(0.26, function()
            Root.Visible = false
        end)
    end)

    -- ── Drag system ────────────────────────────────────
    local dragActive, dragStart, dragStartPos
    Hdr.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragActive   = true
            dragStart    = inp.Position
            dragStartPos = Root.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragActive and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            Root.Position = UDim2.new(
                dragStartPos.X.Scale,
                dragStartPos.X.Offset + delta.X,
                dragStartPos.Y.Scale,
                dragStartPos.Y.Offset + delta.Y
            )

        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragActive = false
        end
    end)

    -- ── Body ───────────────────────────────────────────
    local Body = new("Frame", {
        Name                   = "Body",
        Size                   = UDim2.new(1, 0, 1, -60),
        Position               = UDim2.fromOffset(0, 60),
        BackgroundTransparency = 1,
        ZIndex                 = 11,
    }, Root)

    -- ── Sidebar ────────────────────────────────────────
    local Sidebar = new("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, 230, 1, 0),
        BackgroundColor3 = C.Sidebar,
        ZIndex           = 12,
    }, Body)

    new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 16, 28)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 13, 22)),
        }),
        Rotation = 90,
    }, Sidebar)

    -- Sidebar right border
    new("Frame", {
        Size             = UDim2.new(0, 1, 1, 0),
        Position         = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = C.Line,
        BorderSizePixel  = 0,
        ZIndex           = 13,
    }, Sidebar)

    local SBScroll = new("ScrollingFrame", {
        Name                 = "SBScroll",
        Size                 = UDim2.new(1, -1, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness   = 0,
        CanvasSize           = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        ZIndex               = 13,
    }, Sidebar)
    pad(SBScroll, 14, 14, 10, 8)
    listV(SBScroll, 3)

    -- ── Content Area ───────────────────────────────────
    local ContentArea = new("Frame", {
        Name                   = "ContentArea",
        Size                   = UDim2.new(1, -230, 1, 0),
        Position               = UDim2.fromOffset(230, 0),
        BackgroundTransparency = 1,
        ClipsDescendants       = true,
        ZIndex                 = 12,
    }, Body)

    -- ── Tab management ─────────────────────────────────
    local allTabs   = {}
    local activeTab = nil

    local function deactivateAll()
        for _, t in ipairs(allTabs) do
            t.page.Visible = false
            tw(t.btn, { BackgroundColor3 = C.Sidebar, BackgroundTransparency = 1 }, 0.14)
            tw(t.lbl, { TextColor3 = C.TextSub }, 0.14)
            tw(t.dot, { BackgroundTransparency = 1 }, 0.14)
            if t.iconBox then
                tw(t.iconBox, { BackgroundColor3 = C.IconBG }, 0.14)
            end
            if t.iconGlows then
                for _, g in ipairs(t.iconGlows) do
                    tw(g.frame, { BackgroundTransparency = 1 }, 0.14)
                end
            end
        end
    end

    -- ════════════════════════════════════════════════════
    --  CATEGORY
    -- ════════════════════════════════════════════════════
    function Window:Category(catName)
        local Cat = {}

        -- Category label
        local catLbl = lbl({
            Size       = UDim2.new(1, 0, 0, 20),
            Text       = catName,
            TextColor3 = C.TextCat,
            Font       = Enum.Font.GothamBold,
            TextSize   = 10,
            ZIndex     = 14,
        }, SBScroll)
        -- Small top margin via LayoutOrder padding
        new("UIPadding", {
            PaddingLeft = UDim.new(0, 4),
        }, catLbl)

        -- ════════════════════════════════════════════════
        --  TAB
        -- ════════════════════════════════════════════════
        function Cat:Tab(tabOpts)
            local Tab      = {}
            local tabTitle = tabOpts.Title or "Tab"
            local tabIcon  = tabOpts.Icon  or "📋"

            -- ── Sidebar row button ──────────────────────
            local rowContainer = new("Frame", {
                Size                   = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                ZIndex                 = 14,
            }, SBScroll)

            local rowBtn = new("TextButton", {
                Size                   = UDim2.new(1, 0, 1, 0),
                BackgroundColor3       = C.Sidebar,
                BackgroundTransparency = 1,
                Text                   = "",
                AutoButtonColor        = false,
                ZIndex                 = 14,
            }, rowContainer)
            corner(rowBtn, 8)

            -- Active indicator dot (left edge)
            local dot = new("Frame", {
                Size             = UDim2.new(0, 3, 0.6, 0),
                AnchorPoint      = Vector2.new(0, 0.5),
                Position         = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3 = C.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel  = 0,
                ZIndex           = 15,
            }, rowBtn)
            corner(dot, 2)

            -- Tab icon box
            local iBox = new("Frame", {
                Size             = UDim2.fromOffset(26, 26),
                AnchorPoint      = Vector2.new(0, 0.5),
                Position         = UDim2.new(0, 10, 0.5, 0),
                BackgroundColor3 = C.IconBG,
                ZIndex           = 15,
            }, rowBtn)
            corner(iBox, 7)
            new("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, C.IconBGBr),
                    ColorSequenceKeypoint.new(1, C.IconBG),
                }),
                Rotation = 135,
            }, iBox)
            lbl({
                Size           = UDim2.new(1, 0, 1, 0),
                Text           = tabIcon,
                TextColor3     = C.AccentBr,
                Font           = Enum.Font.GothamBold,
                TextSize       = 13,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex         = 16,
            }, iBox)

            -- Tab label
            local rowLbl = lbl({
                Size       = UDim2.new(1, -50, 1, 0),
                Position   = UDim2.fromOffset(44, 0),
                Text       = tabTitle,
                TextColor3 = C.TextSub,
                Font       = Enum.Font.Gotham,
                TextSize   = 13,
                ZIndex     = 15,
            }, rowBtn)

            -- ── Page (content) ─────────────────────────
            local Page = new("ScrollingFrame", {
                Name                 = "Page_"..tabTitle,
                Size                 = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness   = 3,
                ScrollBarImageColor3 = C.Accent,
                ScrollBarImageTransparency = 0.5,
                CanvasSize           = UDim2.new(0, 0, 0, 0),
                Visible              = false,
                ZIndex               = 13,
            }, ContentArea)

            -- ── 2-column layout ────────────────────────
            local PAGE_PAD = 14
            local COL_GAP  = 12

            pad(Page, PAGE_PAD, PAGE_PAD, PAGE_PAD, PAGE_PAD)

            local colL = new("Frame", {
                Name                   = "ColLeft",
                Position               = UDim2.fromOffset(0, 0),
                BackgroundTransparency = 1,
                ZIndex                 = 14,
            }, Page)
            local layoutL = listV(colL, 12)

            local colR = new("Frame", {
                Name                   = "ColRight",
                BackgroundTransparency = 1,
                ZIndex                 = 14,
            }, Page)
            local layoutR = listV(colR, 12)

            local function updateLayout()
                local pageW = Page.AbsoluteSize.X - PAGE_PAD * 2
                if pageW <= 10 then pageW = 540 end
                local colW = math.floor((pageW - COL_GAP) / 2)

                local lh = layoutL.AbsoluteContentSize.Y
                local rh = layoutR.AbsoluteContentSize.Y

                colL.Size     = UDim2.fromOffset(colW, lh)
                colL.Position = UDim2.fromOffset(0, 0)

                colR.Size     = UDim2.fromOffset(colW, rh)
                colR.Position = UDim2.fromOffset(colW + COL_GAP, 0)

                local totalH = math.max(lh, rh) + PAGE_PAD * 2
                Page.CanvasSize = UDim2.fromOffset(0, totalH)
            end

            layoutL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateLayout)
            layoutR:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateLayout)
            Page:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)

            -- Card counter for alternating columns
            local cardCount = 0

            -- ── Activate / Deactivate tab ───────────────
            local tabInfo = { btn = rowBtn, lbl = rowLbl, dot = dot, page = Page, iconBox = iBox }
            table.insert(allTabs, tabInfo)

            -- Sidebar icon glow layers (created once)
            local sidebarIconGlow = {}
            do
                local glowData3 = { {exp=4, al=0.80}, {exp=8, al=0.88} }
                for _, gd in ipairs(glowData3) do
                    local gf = new("Frame", {
                        AnchorPoint            = Vector2.new(0.5,0.5),
                        Size                   = UDim2.fromOffset(26+gd.exp*2, 26+gd.exp*2),
                        Position               = UDim2.new(0.5,0,0.5,0),
                        BackgroundColor3       = C.Accent,
                        BackgroundTransparency = 1, -- hidden by default
                        BorderSizePixel        = 0,
                        ZIndex                 = 15,
                    }, iBox)
                    corner(gf, 7 + gd.exp)
                    table.insert(sidebarIconGlow, {frame=gf, al=gd.al})
                end
            end

            local tabInfo = { btn = rowBtn, lbl = rowLbl, dot = dot, page = Page, iconBox = iBox, iconGlows = sidebarIconGlow }
            table.insert(allTabs, tabInfo)

            local function activateTab()
                deactivateAll()
                activeTab      = tabInfo
                Page.Visible   = true
                tw(rowBtn, { BackgroundColor3 = C.SidebarAct, BackgroundTransparency = 0 }, 0.14)
                tw(rowLbl, { TextColor3 = C.Text }, 0.14)
                tw(dot,    { BackgroundTransparency = 0 }, 0.14)
                tw(iBox,   { BackgroundColor3 = C.AccentDim }, 0.14)
                for _, g in ipairs(sidebarIconGlow) do
                    tw(g.frame, { BackgroundTransparency = g.al }, 0.2)
                end
                task.defer(updateLayout)
            end

            rowBtn.MouseButton1Click:Connect(activateTab)
            rowBtn.MouseEnter:Connect(function()
                if activeTab ~= tabInfo then
                    tw(rowBtn, { BackgroundColor3 = C.SidebarHov, BackgroundTransparency = 0 }, 0.12)
                    tw(rowLbl, { TextColor3 = C.Text }, 0.12)
                end
            end)
            rowBtn.MouseLeave:Connect(function()
                if activeTab ~= tabInfo then
                    tw(rowBtn, { BackgroundTransparency = 1 }, 0.12)
                    tw(rowLbl, { TextColor3 = C.TextSub }, 0.12)
                end
            end)

            if #allTabs == 1 then activateTab() end

            -- ════════════════════════════════════════════
            --  CARD
            -- ════════════════════════════════════════════
            function Tab:Card(cardOpts)
                cardOpts = cardOpts or {}
                local Card      = {}
                local cardTitle = cardOpts.Title or "Card"
                local cardIcon  = cardOpts.Icon  or "🌐"

                cardCount = cardCount + 1
                local col = (cardCount % 2 == 1) and colL or colR

                -- ── Card frame ─────────────────────────
                local cardFrame = new("Frame", {
                    Name             = "Card_"..cardTitle,
                    Size             = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = C.Card,
                    ClipsDescendants = false,
                    ZIndex           = 15,
                }, col)
                corner(cardFrame, 12)
                local cardStroke = stroke(cardFrame, C.CardBorder, 1, 0.15)

                -- Card hover effect
                cardFrame.MouseEnter:Connect(function()
                    tw(cardFrame, { BackgroundColor3 = C.CardHov }, 0.15)
                    tw(cardStroke, { Color = C.CardBorderHov, Transparency = 0.3 }, 0.15)
                end)
                cardFrame.MouseLeave:Connect(function()
                    tw(cardFrame, { BackgroundColor3 = C.Card }, 0.15)
                    tw(cardStroke, { Color = C.CardBorder, Transparency = 0.15 }, 0.15)
                end)

                -- Inner content frame
                local inner = new("Frame", {
                    Name                   = "Inner",
                    Size                   = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    ZIndex                 = 16,
                }, cardFrame)
                pad(inner, 14, 14, 14, 14)
                local innerLayout = listV(inner, 10)

                local function syncCard()
                    local h = innerLayout.AbsoluteContentSize.Y + 28
                    tw(cardFrame, { Size = UDim2.new(1, 0, 0, h) }, 0.12)
                    inner.Size = UDim2.new(1, 0, 0, h)
                    task.defer(updateLayout)
                end
                innerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncCard)

                -- ── Card Header ────────────────────────
                local cHdr = new("Frame", {
                    Name                   = "CardHeader",
                    Size                   = UDim2.new(1, 0, 0, 34),
                    BackgroundTransparency = 1,
                    ZIndex                 = 17,
                }, inner)

                -- Icon container with glow
                local ciContainer = new("Frame", {
                    Size                   = UDim2.fromOffset(34, 34),
                    BackgroundTransparency = 1,
                    ZIndex                 = 17,
                }, cHdr)

                local ciBox = new("Frame", {
                    Size             = UDim2.fromOffset(34, 34),
                    BackgroundColor3 = C.IconBG,
                    ZIndex           = 18,
                }, ciContainer)
                corner(ciBox, 9)
                stroke(ciBox, C.AccentDim, 1, 0.4)
                new("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, C.IconBGBr),
                        ColorSequenceKeypoint.new(1, C.IconBG),
                    }),
                    Rotation = 135,
                }, ciBox)
                -- Glow behind icon (layered frames)
                do
                    local glowData2 = {
                        {exp=4, al=0.70}, {exp=9, al=0.82}, {exp=14, al=0.91}
                    }
                    for _, gd in ipairs(glowData2) do
                        local gf = new("Frame", {
                            AnchorPoint            = Vector2.new(0.5,0.5),
                            Size                   = UDim2.fromOffset(34+gd.exp*2, 34+gd.exp*2),
                            Position               = UDim2.new(0.5,0,0.5,0),
                            BackgroundColor3       = C.Accent,
                            BackgroundTransparency = gd.al,
                            BorderSizePixel        = 0,
                            ZIndex                 = 17,
                        }, ciContainer)
                        corner(gf, 9 + gd.exp)
                    end
                end

                lbl({
                    Size           = UDim2.new(1, 0, 1, 0),
                    Text           = cardIcon,
                    TextColor3     = C.AccentBr,
                    Font           = Enum.Font.GothamBold,
                    TextSize       = 16,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex         = 19,
                }, ciBox)

                -- Card title
                lbl({
                    Size       = UDim2.new(1, -50, 1, 0),
                    Position   = UDim2.fromOffset(44, 0),
                    Text       = cardTitle,
                    TextColor3 = C.Text,
                    Font       = Enum.Font.GothamBold,
                    TextSize   = 14,
                    ZIndex     = 18,
                }, cHdr)

                -- Divider under header
                new("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = C.LineBr,
                    BorderSizePixel  = 0,
                    ZIndex           = 17,
                }, inner)

                -- ══════════════════════════════════════
                --  ELEMENT: SLIDER
                -- ══════════════════════════════════════
                function Card:Slider(o)
                    o = o or {}
                    local sMin  = o.Min     or 0
                    local sMax  = o.Max     or 100
                    local sVal  = math.clamp(o.Default or sMin, sMin, sMax)
                    local sSuf  = o.Suffix  or ""
                    local sStep = o.Step    or 1

                    -- Wrapper
                    local wrap = new("Frame", {
                        Size                   = UDim2.new(1, 0, 0, 60),
                        BackgroundTransparency = 1,
                        ZIndex                 = 17,
                    }, inner)
                    listV(wrap, 6)

                    -- Top row: title | value
                    local topRow = new("Frame", {
                        Size                   = UDim2.new(1, 0, 0, 18),
                        BackgroundTransparency = 1,
                        ZIndex                 = 18,
                    }, wrap)

                    lbl({
                        Size       = UDim2.new(0.6, 0, 1, 0),
                        Text       = o.Title or "Slider",
                        TextColor3 = C.Text,
                        Font       = Enum.Font.GothamSemibold,
                        TextSize   = 12,
                        ZIndex     = 19,
                    }, topRow)

                    local valLbl = lbl({
                        Size           = UDim2.new(0.4, 0, 1, 0),
                        AnchorPoint    = Vector2.new(1, 0),
                        Position       = UDim2.new(1, 0, 0, 0),
                        Text           = tostring(sVal) .. sSuf,
                        TextColor3     = C.AccentBr,
                        Font           = Enum.Font.GothamBold,
                        TextSize       = 12,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        ZIndex         = 19,
                    }, topRow)

                    -- Bottom row: minus | track | value input | plus
                    local slRow = new("Frame", {
                        Size                   = UDim2.new(1, 0, 0, 28),
                        BackgroundTransparency = 1,
                        ZIndex                 = 18,
                    }, wrap)

                    -- Minus button
                    local minusBtn = new("TextButton", {
                        Size             = UDim2.fromOffset(24, 24),
                        AnchorPoint      = Vector2.new(0, 0.5),
                        Position         = UDim2.new(0, 0, 0.5, 0),
                        BackgroundColor3 = C.Surface,
                        Text             = "−",
                        TextColor3       = C.TextSub,
                        Font             = Enum.Font.GothamBold,
                        TextSize         = 16,
                        AutoButtonColor  = false,
                        ZIndex           = 19,
                    }, slRow)
                    corner(minusBtn, 6)
                    stroke(minusBtn, C.InputBord, 1, 0.2)
                    minusBtn.MouseEnter:Connect(function()
                        tw(minusBtn, { BackgroundColor3 = C.SidebarAct, TextColor3 = C.AccentBr }, 0.1)
                    end)
                    minusBtn.MouseLeave:Connect(function()
                        tw(minusBtn, { BackgroundColor3 = C.Surface, TextColor3 = C.TextSub }, 0.1)
                    end)

                    -- Plus button
                    local plusBtn = new("TextButton", {
                        Size             = UDim2.fromOffset(24, 24),
                        AnchorPoint      = Vector2.new(1, 0.5),
                        Position         = UDim2.new(1, -62, 0.5, 0),
                        BackgroundColor3 = C.Surface,
                        Text             = "+",
                        TextColor3       = C.TextSub,
                        Font             = Enum.Font.GothamBold,
                        TextSize         = 16,
                        AutoButtonColor  = false,
                        ZIndex           = 19,
                    }, slRow)
                    corner(plusBtn, 6)
                    stroke(plusBtn, C.InputBord, 1, 0.2)
                    plusBtn.MouseEnter:Connect(function()
                        tw(plusBtn, { BackgroundColor3 = C.SidebarAct, TextColor3 = C.AccentBr }, 0.1)
                    end)
                    plusBtn.MouseLeave:Connect(function()
                        tw(plusBtn, { BackgroundColor3 = C.Surface, TextColor3 = C.TextSub }, 0.1)
                    end)

                    -- Value input box (right side)
                    local valInputWrap = new("Frame", {
                        Size             = UDim2.fromOffset(48, 24),
                        AnchorPoint      = Vector2.new(1, 0.5),
                        Position         = UDim2.new(1, 0, 0.5, 0),
                        BackgroundColor3 = C.Input,
                        ZIndex           = 19,
                    }, slRow)
                    corner(valInputWrap, 6)
                    stroke(valInputWrap, C.InputBord, 1, 0.2)

                    local valInput = new("TextBox", {
                        Size                   = UDim2.new(1, -8, 1, 0),
                        Position               = UDim2.fromOffset(4, 0),
                        BackgroundTransparency = 1,
                        Text                   = tostring(sVal),
                        PlaceholderText        = "0",
                        TextColor3             = C.AccentBr,
                        PlaceholderColor3      = C.TextDim,
                        Font                   = Enum.Font.GothamBold,
                        TextSize               = 11,
                        ClearTextOnFocus       = false,
                        TextXAlignment         = Enum.TextXAlignment.Center,
                        ZIndex                 = 20,
                    }, valInputWrap)

                    -- Slider track (between minus and +/input)
                    local track = new("Frame", {
                        Size             = UDim2.new(1, -116, 0, 6),
                        AnchorPoint      = Vector2.new(0, 0.5),
                        Position         = UDim2.new(0, 32, 0.5, 0),
                        BackgroundColor3 = C.SliderBG,
                        BorderSizePixel  = 0,
                        ZIndex           = 19,
                    }, slRow)
                    corner(track, 100)

                    -- Track gradient
                    new("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 20, 40)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 30, 55)),
                        }),
                    }, track)

                    -- Fill bar
                    local fill = new("Frame", {
                        Size             = UDim2.new((sVal - sMin) / (sMax - sMin), 0, 1, 0),
                        BackgroundColor3 = C.SliderFill,
                        BorderSizePixel  = 0,
                        ZIndex           = 20,
                    }, track)
                    corner(fill, 100)
                    new("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, C.SliderFill),
                            ColorSequenceKeypoint.new(1, C.SliderFillBr),
                        }),
                    }, fill)

                    -- Knob
                    local knobContainer = new("Frame", {
                        Size                   = UDim2.fromOffset(20, 20),
                        AnchorPoint            = Vector2.new(0.5, 0.5),
                        Position               = UDim2.new((sVal - sMin) / (sMax - sMin), 0, 0.5, 0),
                        BackgroundTransparency = 1,
                        ZIndex                 = 21,
                    }, track)
                    local knob = new("Frame", {
                        Size             = UDim2.fromOffset(14, 14),
                        AnchorPoint      = Vector2.new(0.5, 0.5),
                        Position         = UDim2.new(0.5, 0, 0.5, 0),
                        BackgroundColor3 = C.Knob,
                        ZIndex           = 22,
                    }, knobContainer)
                    corner(knob, 100)
                    -- Knob glow ring
                    new("UIStroke", {
                        Color        = C.AccentBr,
                        Thickness    = 2,
                        Transparency = 0.15,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    }, knob)
                    -- Outer knob glow frame
                    local knobGlowFrame = new("Frame", {
                        AnchorPoint            = Vector2.new(0.5,0.5),
                        Size                   = UDim2.fromOffset(22, 22),
                        Position               = UDim2.new(0.5, 0, 0.5, 0),
                        BackgroundColor3       = C.Accent,
                        BackgroundTransparency = 0.65,
                        BorderSizePixel        = 0,
                        ZIndex                 = 21,
                    }, knobContainer)
                    corner(knobGlowFrame, 100)

                    -- SetVal function
                    local function setVal(v, noCallback)
                        sVal = math.clamp(
                            math.floor((v / sStep) + 0.5) * sStep,
                            sMin, sMax
                        )
                        local pct = (sVal - sMin) / (sMax - sMin)
                        tw(fill,          { Size = UDim2.new(pct, 0, 1, 0) }, 0.08)
                        tw(knobContainer, { Position = UDim2.new(pct, 0, 0.5, 0) }, 0.08)
                        valLbl.Text   = tostring(sVal) .. sSuf
                        valInput.Text = tostring(sVal)
                        if not noCallback and o.Callback then o.Callback(sVal) end
                    end

                    -- Minus / Plus clicks
                    minusBtn.MouseButton1Click:Connect(function() setVal(sVal - sStep) end)
                    plusBtn.MouseButton1Click:Connect(function()  setVal(sVal + sStep) end)

                    -- Hold to repeat
                    local function holdRepeat(btn2, delta)
                        btn2.MouseButton1Down:Connect(function()
                            task.delay(0.4, function()
                                while btn2:IsMouseOver() do
                                    setVal(sVal + delta)
                                    task.wait(0.08)
                                end
                            end)
                        end)
                    end
                    holdRepeat(minusBtn, -sStep)
                    holdRepeat(plusBtn,   sStep)

                    -- Drag on track
                    local dragging = false
                    track.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            local rel = math.clamp(
                                inp.Position.X - track.AbsolutePosition.X,
                                0, track.AbsoluteSize.X
                            )
                            setVal(sMin + (rel / track.AbsoluteSize.X) * (sMax - sMin))
                        end
                    end)
                    UIS.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    UIS.InputChanged:Connect(function(inp)
                        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                            local rel = math.clamp(
                                inp.Position.X - track.AbsolutePosition.X,
                                0, track.AbsoluteSize.X
                            )
                            setVal(sMin + (rel / track.AbsoluteSize.X) * (sMax - sMin))
                        end
                    end)

                    -- Type value in input box
                    valInput.Focused:Connect(function()
                        tw(valInputWrap, { BackgroundColor3 = C.InputFocus }, 0.1)
                        tw(valInputWrap:FindFirstChildOfClass("UIStroke"),
                            { Color = C.InputBordFocus }, 0.1)
                    end)
                    valInput.FocusLost:Connect(function()
                        tw(valInputWrap, { BackgroundColor3 = C.Input }, 0.1)
                        tw(valInputWrap:FindFirstChildOfClass("UIStroke"),
                            { Color = C.InputBord }, 0.1)
                        local num = tonumber(valInput.Text)
                        if num then setVal(num)
                        else valInput.Text = tostring(sVal) end
                    end)

                    -- Scroll wheel on track
                    track.InputChanged:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseWheel then
                            setVal(sVal + inp.Position.Z * sStep)
                        end
                    end)

                    return {
                        Set = setVal,
                        Get = function() return sVal end,
                    }
                end

                -- ══════════════════════════════════════
                --  ELEMENT: DROPDOWN
                -- ══════════════════════════════════════
                function Card:Dropdown(o)
                    o = o or {}
                    local opts2  = o.Options or {}
                    local sel    = o.Default or (opts2[1] or "–")
                    local isOpen = false

                    -- Label
                    lbl({
                        Size       = UDim2.new(1, 0, 0, 18),
                        Text       = o.Title or "Dropdown",
                        TextColor3 = C.Text,
                        Font       = Enum.Font.GothamSemibold,
                        TextSize   = 12,
                        ZIndex     = 17,
                    }, inner)

                    -- Dropdown head
                    local dHead = new("Frame", {
                        Size             = UDim2.new(1, 0, 0, 36),
                        BackgroundColor3 = C.Input,
                        ZIndex           = 17,
                    }, inner)
                    corner(dHead, 8)
                    local dStroke = stroke(dHead, C.InputBord, 1, 0.1)
                    new("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 16, 30)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 24)),
                        }),
                        Rotation = 90,
                    }, dHead)

                    local selLbl = lbl({
                        Size       = UDim2.new(1, -36, 1, 0),
                        Position   = UDim2.fromOffset(12, 0),
                        Text       = sel,
                        TextColor3 = C.TextSub,
                        Font       = Enum.Font.Gotham,
                        TextSize   = 12,
                        ZIndex     = 18,
                    }, dHead)

                    -- Chevron
                    local chevBox = new("Frame", {
                        Size             = UDim2.fromOffset(24, 24),
                        AnchorPoint      = Vector2.new(1, 0.5),
                        Position         = UDim2.new(1, -8, 0.5, 0),
                        BackgroundColor3 = C.Surface,
                        ZIndex           = 18,
                    }, dHead)
                    corner(chevBox, 6)
                    local chevLbl = lbl({
                        Size           = UDim2.new(1, 0, 1, 0),
                        Text           = "▾",
                        TextColor3     = C.TextDim,
                        Font           = Enum.Font.GothamBold,
                        TextSize       = 12,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        ZIndex         = 19,
                    }, chevBox)

                    -- Dropdown list (parented to SG for z-order)
                    local listH_px    = math.min(#opts2 * 32 + 10, 160)
                    local dList = new("Frame", {
                        Size             = UDim2.fromOffset(0, 0),
                        BackgroundColor3 = C.Input,
                        ClipsDescendants = true,
                        ZIndex           = 300,
                        Visible          = false,
                    }, SG)
                    corner(dList, 8)
                    stroke(dList, C.InputBordFocus, 1, 0.3)
                    new("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 18, 34)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 26)),
                        }),
                        Rotation = 90,
                    }, dList)

                    -- Blocker
                    local blocker = new("TextButton", {
                        Size                   = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text                   = "",
                        AutoButtonColor        = false,
                        ZIndex                 = 299,
                        Visible                = false,
                    }, SG)

                    local dScroll = new("ScrollingFrame", {
                        Size                 = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        ScrollBarThickness   = 2,
                        ScrollBarImageColor3 = C.Accent,
                        CanvasSize           = UDim2.new(0, 0, 0, 0),
                        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
                        ZIndex               = 301,
                    }, dList)
                    pad(dScroll, 5, 5, 6, 6)
                    listV(dScroll, 2)

                    local function closeDropdown()
                        isOpen = false
                        tw(dList, { Size = UDim2.fromOffset(dList.AbsoluteSize.X, 0) }, 0.15)
                        tw(dStroke, { Color = C.InputBord }, 0.12)
                        tw(chevLbl, { TextColor3 = C.TextDim }, 0.1)
                        task.delay(0.18, function()
                            dList.Visible    = false
                            blocker.Visible  = false
                        end)
                        chevLbl.Text = "▾"
                    end

                    blocker.MouseButton1Click:Connect(closeDropdown)

                    -- Option items
                    for _, opt in ipairs(opts2) do
                        local isSelected = (opt == sel)

                        local ob = new("Frame", {
                            Size             = UDim2.new(1, 0, 0, 30),
                            BackgroundColor3 = isSelected and C.AccentDark or C.Input,
                            BackgroundTransparency = isSelected and 0 or 1,
                            ZIndex           = 302,
                        }, dScroll)
                        corner(ob, 6)

                        lbl({
                            Size       = UDim2.new(1, -10, 1, 0),
                            Position   = UDim2.fromOffset(10, 0),
                            Text       = opt,
                            TextColor3 = isSelected and C.AccentBr or C.TextSub,
                            Font       = isSelected and Enum.Font.GothamSemibold or Enum.Font.Gotham,
                            TextSize   = 12,
                            ZIndex     = 303,
                        }, ob)

                        if isSelected then
                            lbl({
                                Size           = UDim2.fromOffset(16, 30),
                                AnchorPoint    = Vector2.new(1, 0),
                                Position       = UDim2.new(1, -2, 0, 0),
                                Text           = "✓",
                                TextColor3     = C.AccentBr,
                                Font           = Enum.Font.GothamBold,
                                TextSize       = 11,
                                TextXAlignment = Enum.TextXAlignment.Center,
                                ZIndex         = 303,
                            }, ob)
                        end

                        local obBtn = btn({ Size = UDim2.new(1, 0, 1, 0), ZIndex = 304 }, ob)
                        obBtn.MouseEnter:Connect(function()
                            tw(ob, { BackgroundColor3 = C.SidebarAct, BackgroundTransparency = 0 }, 0.1)
                        end)
                        obBtn.MouseLeave:Connect(function()
                            if opt ~= sel then
                                tw(ob, { BackgroundTransparency = 1 }, 0.1)
                            end
                        end)
                        obBtn.MouseButton1Click:Connect(function()
                            sel          = opt
                            selLbl.Text  = opt
                            closeDropdown()
                            if o.Callback then o.Callback(opt) end
                        end)
                    end

                    -- Toggle open/close
                    local hb = btn({ Size = UDim2.new(1, 0, 1, 0), ZIndex = 19 }, dHead)
                    hb.MouseEnter:Connect(function()
                        if not isOpen then
                            tw(dHead, { BackgroundColor3 = C.InputFocus }, 0.1)
                        end
                    end)
                    hb.MouseLeave:Connect(function()
                        if not isOpen then
                            tw(dHead, { BackgroundColor3 = C.Input }, 0.1)
                        end
                    end)
                    hb.MouseButton1Click:Connect(function()
                        if isOpen then
                            closeDropdown()
                        else
                            isOpen = true
                            local absPos  = dHead.AbsolutePosition
                            local absSize = dHead.AbsoluteSize
                            local listW   = absSize.X

                            dList.Size    = UDim2.fromOffset(listW, 0)
                            dList.Position = UDim2.fromOffset(absPos.X, absPos.Y + absSize.Y + 4)
                            dList.Visible  = true
                            blocker.Visible = true

                            tw(dList, { Size = UDim2.fromOffset(listW, listH_px) },
                                0.22, Enum.EasingStyle.Back)
                            tw(dStroke, { Color = C.InputBordFocus }, 0.12)
                            tw(chevLbl, { TextColor3 = C.AccentBr }, 0.1)
                            chevLbl.Text = "▴"
                        end
                    end)

                    return {
                        Get = function() return sel end,
                        Set = function(v)
                            sel         = v
                            selLbl.Text = v
                        end,
                    }
                end

                -- ══════════════════════════════════════
                --  ELEMENT: TOGGLE
                -- ══════════════════════════════════════
                function Card:Toggle(o)
                    o = o or {}
                    local val = o.Default or false

                    local row = new("Frame", {
                        Size                   = UDim2.new(1, 0, 0, 30),
                        BackgroundTransparency = 1,
                        ZIndex                 = 17,
                    }, inner)

                    lbl({
                        Size       = UDim2.new(1, -54, 1, 0),
                        Text       = o.Title or "Toggle",
                        TextColor3 = C.Text,
                        Font       = Enum.Font.Gotham,
                        TextSize   = 13,
                        ZIndex     = 18,
                    }, row)

                    -- Toggle track
                    local trackF = new("Frame", {
                        Size             = UDim2.fromOffset(44, 24),
                        AnchorPoint      = Vector2.new(1, 0.5),
                        Position         = UDim2.new(1, 0, 0.5, 0),
                        BackgroundColor3 = val and C.TogON or C.TogOFF,
                        ZIndex           = 18,
                    }, row)
                    corner(trackF, 100)
                    stroke(trackF, C.InputBord, 1, 0.4)

                    -- Track gradient
                    local trackGrad = new("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0,   val and C.SliderFillBr or C.Surface),
                            ColorSequenceKeypoint.new(1,   val and C.SliderFill   or C.TogOFF),
                        }),
                    }, trackF)

                    -- Knob
                    local knobContainer = new("Frame", {
                        Size                   = UDim2.fromOffset(22, 22),
                        AnchorPoint            = Vector2.new(0.5, 0.5),
                        Position               = UDim2.new(val and 0.75 or 0.28, 0, 0.5, 0),
                        BackgroundTransparency = 1,
                        ZIndex                 = 19,
                    }, trackF)
                    local knobT = new("Frame", {
                        Size             = UDim2.fromOffset(18, 18),
                        AnchorPoint      = Vector2.new(0.5, 0.5),
                        Position         = UDim2.new(0.5, 0, 0.5, 0),
                        BackgroundColor3 = C.TogKnob,
                        ZIndex           = 20,
                    }, knobContainer)
                    corner(knobT, 100)
                    -- Knob shadow/glow
                    local knobGlowStroke = new("UIStroke", {
                        Color        = C.AccentBr,
                        Thickness    = val and 2 or 0,
                        Transparency = 0.3,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    }, knobT)

                    local function setToggle(s)
                        val = s
                        tw(trackF, { BackgroundColor3 = s and C.TogON or C.TogOFF }, 0.15)
                        tw(knobContainer, {
                            Position = UDim2.new(s and 0.75 or 0.28, 0, 0.5, 0),
                        }, 0.18, Enum.EasingStyle.Back)
                        trackGrad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, s and C.SliderFillBr or C.Surface),
                            ColorSequenceKeypoint.new(1, s and C.SliderFill   or C.TogOFF),
                        })
                        -- update knob stroke glow
                        if knobGlowStroke then
                            knobGlowStroke.Thickness = s and 2 or 0
                        end
                        if o.Callback then o.Callback(s) end
                    end

                    btn({ Size = UDim2.new(1, 0, 1, 0), ZIndex = 20 }, row).MouseButton1Click:Connect(
                        function() setToggle(not val) end
                    )

                    return {
                        Set = setToggle,
                        Get = function() return val end,
                    }
                end

                -- ══════════════════════════════════════
                --  ELEMENT: CHECKBOX
                -- ══════════════════════════════════════
                function Card:Checkbox(o)
                    o = o or {}
                    local val = o.Default or false

                    local row = new("Frame", {
                        Size                   = UDim2.new(1, 0, 0, 28),
                        BackgroundTransparency = 1,
                        ZIndex                 = 17,
                    }, inner)

                    -- Box
                    local box = new("Frame", {
                        Size             = UDim2.fromOffset(20, 20),
                        AnchorPoint      = Vector2.new(0, 0.5),
                        Position         = UDim2.new(0, 0, 0.5, 0),
                        BackgroundColor3 = val and C.CheckON or C.CheckOFF,
                        ZIndex           = 18,
                    }, row)
                    corner(box, 5)
                    local boxStroke = stroke(box, val and C.Accent or C.CheckBord, 1, 0.15)

                    -- Checkmark
                    local tick = lbl({
                        Size           = UDim2.new(1, 0, 1, 0),
                        Text           = val and "✓" or "",
                        TextColor3     = C.White,
                        Font           = Enum.Font.GothamBold,
                        TextSize       = 13,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        ZIndex         = 19,
                    }, box)

                    -- Label
                    lbl({
                        Size       = UDim2.new(1, -30, 1, 0),
                        Position   = UDim2.fromOffset(28, 0),
                        Text       = o.Title or "Option",
                        TextColor3 = C.Text,
                        Font       = Enum.Font.Gotham,
                        TextSize   = 13,
                        ZIndex     = 18,
                    }, row)

                    local function setCheck(s)
                        val = s
                        tw(box, { BackgroundColor3 = s and C.CheckON or C.CheckOFF }, 0.15)
                        tw(boxStroke, { Color = s and C.Accent or C.CheckBord }, 0.15)
                        tick.Text = s and "✓" or ""
                        if o.Callback then o.Callback(s) end
                    end

                    btn({ Size = UDim2.new(1, 0, 1, 0), ZIndex = 20 }, row).MouseButton1Click:Connect(
                        function() setCheck(not val) end
                    )

                    return {
                        Set = setCheck,
                        Get = function() return val end,
                    }
                end

                -- ══════════════════════════════════════
                --  ELEMENT: BUTTON
                -- ══════════════════════════════════════
                function Card:Button(o)
                    o = o or {}

                    local b = new("TextButton", {
                        Size             = UDim2.new(1, 0, 0, 36),
                        BackgroundColor3 = C.AccentDim,
                        Text             = o.Title or "Button",
                        TextColor3       = C.White,
                        Font             = Enum.Font.GothamSemibold,
                        TextSize         = 13,
                        AutoButtonColor  = false,
                        ZIndex           = 17,
                    }, inner)
                    corner(b, 8)
                    stroke(b, C.Accent, 1, 0.4)
                    new("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, C.AccentDim),
                            ColorSequenceKeypoint.new(1, C.AccentDark),
                        }),
                        Rotation = 90,
                    }, b)

                    b.MouseEnter:Connect(function()
                        tw(b, { BackgroundColor3 = C.Accent }, 0.12)
                    end)
                    b.MouseLeave:Connect(function()
                        tw(b, { BackgroundColor3 = C.AccentDim }, 0.12)
                    end)
                    b.MouseButton1Down:Connect(function()
                        twSpring(b, { Size = UDim2.new(1, -4, 0, 34) }, 0.1)
                    end)
                    b.MouseButton1Up:Connect(function()
                        twSpring(b, { Size = UDim2.new(1, 0, 0, 36) }, 0.15)
                        if o.Callback then o.Callback() end
                    end)
                end

                -- ══════════════════════════════════════
                --  ELEMENT: INPUT
                -- ══════════════════════════════════════
                function Card:Input(o)
                    o = o or {}

                    lbl({
                        Size       = UDim2.new(1, 0, 0, 18),
                        Text       = o.Title or "Input",
                        TextColor3 = C.Text,
                        Font       = Enum.Font.GothamSemibold,
                        TextSize   = 12,
                        ZIndex     = 17,
                    }, inner)

                    local ibWrap = new("Frame", {
                        Size             = UDim2.new(1, 0, 0, 36),
                        BackgroundColor3 = C.Input,
                        ClipsDescendants = true,
                        ZIndex           = 17,
                    }, inner)
                    corner(ibWrap, 8)
                    local ibStroke = stroke(ibWrap, C.InputBord, 1, 0.15)
                    new("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 16, 30)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 24)),
                        }),
                        Rotation = 90,
                    }, ibWrap)

                    -- Prefix icon
                    local prefixLbl = lbl({
                        Size           = UDim2.fromOffset(26, 36),
                        Text           = "›",
                        TextColor3     = C.AccentBr,
                        Font           = Enum.Font.GothamBold,
                        TextSize       = 16,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        ZIndex         = 18,
                    }, ibWrap)

                    local ib = new("TextBox", {
                        Size                   = UDim2.new(1, -36, 1, 0),
                        Position               = UDim2.fromOffset(26, 0),
                        BackgroundTransparency = 1,
                        Text                   = o.Default or "",
                        PlaceholderText        = o.Placeholder or "type here...",
                        TextColor3             = C.Text,
                        PlaceholderColor3      = C.TextDim,
                        Font                   = Enum.Font.Gotham,
                        TextSize               = 12,
                        ClearTextOnFocus       = false,
                        TextXAlignment         = Enum.TextXAlignment.Left,
                        TextYAlignment         = Enum.TextYAlignment.Center,
                        ZIndex                 = 18,
                    }, ibWrap)

                    ib.Focused:Connect(function()
                        tw(ibWrap, { BackgroundColor3 = C.InputFocus }, 0.12)
                        tw(ibStroke, { Color = C.InputBordFocus, Transparency = 0 }, 0.12)
                        tw(prefixLbl, { TextColor3 = C.AccentBr }, 0.1)
                    end)
                    ib.FocusLost:Connect(function()
                        tw(ibWrap, { BackgroundColor3 = C.Input }, 0.12)
                        tw(ibStroke, { Color = C.InputBord, Transparency = 0.15 }, 0.12)
                        tw(prefixLbl, { TextColor3 = C.TextDim }, 0.1)
                        if o.Callback then o.Callback(ib.Text) end
                    end)

                    return {
                        Get = function() return ib.Text end,
                        Set = function(v) ib.Text = v end,
                    }
                end

                -- ══════════════════════════════════════
                --  ELEMENT: LABEL
                -- ══════════════════════════════════════
                function Card:Label(text, color)
                    lbl({
                        Size       = UDim2.new(1, 0, 0, 18),
                        Text       = text or "",
                        TextColor3 = color or C.TextSub,
                        Font       = Enum.Font.Gotham,
                        TextSize   = 11,
                        ZIndex     = 17,
                    }, inner)
                end

                -- ══════════════════════════════════════
                --  ELEMENT: KEYBIND
                -- ══════════════════════════════════════
                function Card:Keybind(o)
                    o = o or {}
                    local current   = o.Default or Enum.KeyCode.Unknown
                    local listening = false

                    local row = new("Frame", {
                        Size                   = UDim2.new(1, 0, 0, 30),
                        BackgroundTransparency = 1,
                        ZIndex                 = 17,
                    }, inner)

                    lbl({
                        Size       = UDim2.new(1, -80, 1, 0),
                        Text       = o.Title or "Keybind",
                        TextColor3 = C.Text,
                        Font       = Enum.Font.Gotham,
                        TextSize   = 13,
                        ZIndex     = 18,
                    }, row)

                    local kbBtnWrap = new("Frame", {
                        Size             = UDim2.fromOffset(72, 24),
                        AnchorPoint      = Vector2.new(1, 0.5),
                        Position         = UDim2.new(1, 0, 0.5, 0),
                        BackgroundColor3 = C.Surface,
                        ZIndex           = 18,
                    }, row)
                    corner(kbBtnWrap, 6)
                    stroke(kbBtnWrap, C.InputBord, 1, 0.2)

                    local kbLbl = lbl({
                        Size           = UDim2.new(1, 0, 1, 0),
                        Text           = current ~= Enum.KeyCode.Unknown and current.Name or "NONE",
                        TextColor3     = C.AccentBr,
                        Font           = Enum.Font.GothamBold,
                        TextSize       = 10,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        ZIndex         = 19,
                    }, kbBtnWrap)

                    local kbBtn = btn({ Size = UDim2.new(1, 0, 1, 0), ZIndex = 20 }, kbBtnWrap)
                    kbBtn.MouseButton1Click:Connect(function()
                        listening   = true
                        kbLbl.Text  = "..."
                        tw(kbBtnWrap, { BackgroundColor3 = C.AccentDim }, 0.1)
                    end)

                    UIS.InputBegan:Connect(function(inp, gp)
                        if listening and not gp and inp.UserInputType == Enum.UserInputType.Keyboard then
                            current     = inp.KeyCode
                            listening   = false
                            kbLbl.Text  = current.Name
                            tw(kbBtnWrap, { BackgroundColor3 = C.Surface }, 0.1)
                            if o.Callback then o.Callback(current) end
                        end
                    end)

                    return {
                        Get = function() return current end,
                        Set = function(k)
                            current    = k
                            kbLbl.Text = k.Name
                        end,
                    }
                end

                -- ══════════════════════════════════════
                --  ELEMENT: COLOR PICKER (simple HSV)
                -- ══════════════════════════════════════
                function Card:ColorPicker(o)
                    o = o or {}
                    local col = o.Default or Color3.fromRGB(95, 85, 220)

                    local row = new("Frame", {
                        Size                   = UDim2.new(1, 0, 0, 30),
                        BackgroundTransparency = 1,
                        ZIndex                 = 17,
                    }, inner)

                    lbl({
                        Size       = UDim2.new(1, -50, 1, 0),
                        Text       = o.Title or "Color",
                        TextColor3 = C.Text,
                        Font       = Enum.Font.Gotham,
                        TextSize   = 13,
                        ZIndex     = 18,
                    }, row)

                    -- Color preview button
                    local cpBox = new("Frame", {
                        Size             = UDim2.fromOffset(40, 22),
                        AnchorPoint      = Vector2.new(1, 0.5),
                        Position         = UDim2.new(1, 0, 0.5, 0),
                        BackgroundColor3 = col,
                        ZIndex           = 18,
                    }, row)
                    corner(cpBox, 6)
                    stroke(cpBox, C.InputBord, 1, 0.2)

                    -- Hex label inside
                    local function rgb2hex(c)
                        return string.format("#%02X%02X%02X",
                            math.floor(c.R * 255),
                            math.floor(c.G * 255),
                            math.floor(c.B * 255)
                        )
                    end

                    local hexLbl = lbl({
                        Size           = UDim2.new(1, 0, 1, 0),
                        Text           = "",
                        TextColor3     = C.White,
                        Font           = Enum.Font.GothamBold,
                        TextSize       = 8,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        ZIndex         = 19,
                    }, cpBox)

                    local cpBtn = btn({ Size = UDim2.new(1, 0, 1, 0), ZIndex = 20 }, cpBox)

                    -- Simple popup
                    local popup = new("Frame", {
                        Size             = UDim2.fromOffset(220, 0),
                        BackgroundColor3 = C.Card,
                        ZIndex           = 310,
                        Visible          = false,
                    }, SG)
                    corner(popup, 10)
                    stroke(popup, C.InputBordFocus, 1, 0.3)

                    local popupInner = new("Frame", {
                        Size                   = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        ZIndex                 = 311,
                    }, popup)
                    pad(popupInner, 12, 12, 12, 12)
                    listV(popupInner, 8)

                    -- R, G, B sliders in popup
                    local channels = {
                        { name = "R", val = math.floor(col.R * 255), color = C.Red },
                        { name = "G", val = math.floor(col.G * 255), color = C.Green },
                        { name = "B", val = math.floor(col.B * 255), color = C.Blue },
                    }

                    local channelSliders = {}
                    local previewBox = new("Frame", {
                        Size             = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = col,
                        ZIndex           = 312,
                    }, popupInner)
                    corner(previewBox, 6)

                    local function updateColor()
                        local r = channels[1].val / 255
                        local g = channels[2].val / 255
                        local b = channels[3].val / 255
                        col = Color3.new(r, g, b)
                        tw(cpBox, { BackgroundColor3 = col }, 0.1)
                        tw(previewBox, { BackgroundColor3 = col }, 0.1)
                        if o.Callback then o.Callback(col) end
                    end

                    for _, ch in ipairs(channels) do
                        local chRow = new("Frame", {
                            Size                   = UDim2.new(1, 0, 0, 22),
                            BackgroundTransparency = 1,
                            ZIndex                 = 312,
                        }, popupInner)

                        lbl({
                            Size       = UDim2.fromOffset(14, 22),
                            Text       = ch.name,
                            TextColor3 = ch.color,
                            Font       = Enum.Font.GothamBold,
                            TextSize   = 11,
                            ZIndex     = 313,
                        }, chRow)

                        local chTrack = new("Frame", {
                            Size             = UDim2.new(1, -60, 0, 6),
                            Position         = UDim2.fromOffset(20, 8),
                            BackgroundColor3 = C.SliderBG,
                            BorderSizePixel  = 0,
                            ZIndex           = 313,
                        }, chRow)
                        corner(chTrack, 100)

                        local chFill = new("Frame", {
                            Size             = UDim2.new(ch.val / 255, 0, 1, 0),
                            BackgroundColor3 = ch.color,
                            BorderSizePixel  = 0,
                            ZIndex           = 314,
                        }, chTrack)
                        corner(chFill, 100)

                        local chKnob = new("Frame", {
                            Size             = UDim2.fromOffset(10, 10),
                            AnchorPoint      = Vector2.new(0.5, 0.5),
                            Position         = UDim2.new(ch.val / 255, 0, 0.5, 0),
                            BackgroundColor3 = C.White,
                            ZIndex           = 315,
                        }, chTrack)
                        corner(chKnob, 100)

                        local chValLbl = lbl({
                            Size           = UDim2.fromOffset(34, 22),
                            AnchorPoint    = Vector2.new(1, 0),
                            Position       = UDim2.new(1, 0, 0, 0),
                            Text           = tostring(ch.val),
                            TextColor3     = ch.color,
                            Font           = Enum.Font.GothamBold,
                            TextSize       = 10,
                            TextXAlignment = Enum.TextXAlignment.Right,
                            ZIndex         = 313,
                        }, chRow)

                        local chDragging = false
                        local function setChVal(v)
                            ch.val = math.clamp(math.floor(v + 0.5), 0, 255)
                            local pct = ch.val / 255
                            tw(chFill,  { Size = UDim2.new(pct, 0, 1, 0) }, 0.08)
                            tw(chKnob,  { Position = UDim2.new(pct, 0, 0.5, 0) }, 0.08)
                            chValLbl.Text = tostring(ch.val)
                            updateColor()
                        end

                        chTrack.InputBegan:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                                chDragging = true
                                local rel  = math.clamp(inp.Position.X - chTrack.AbsolutePosition.X, 0, chTrack.AbsoluteSize.X)
                                setChVal((rel / chTrack.AbsoluteSize.X) * 255)
                            end
                        end)
                        UIS.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then chDragging = false end
                        end)
                        UIS.InputChanged:Connect(function(inp)
                            if chDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                                local rel = math.clamp(inp.Position.X - chTrack.AbsolutePosition.X, 0, chTrack.AbsoluteSize.X)
                                setChVal((rel / chTrack.AbsoluteSize.X) * 255)
                            end
                        end)

                        table.insert(channelSliders, { set = setChVal })
                    end

                    -- Close popup blocker
                    local cpBlocker = new("TextButton", {
                        Size                   = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text                   = "",
                        AutoButtonColor        = false,
                        ZIndex                 = 309,
                        Visible                = false,
                    }, SG)

                    local popupOpen = false
                    cpBtn.MouseButton1Click:Connect(function()
                        if popupOpen then
                            popupOpen         = false
                            popup.Visible     = false
                            cpBlocker.Visible = false
                        else
                            popupOpen = true
                            local absPos  = cpBox.AbsolutePosition
                            local absSize = cpBox.AbsoluteSize
                            popup.Position    = UDim2.fromOffset(absPos.X - 170, absPos.Y + absSize.Y + 6)
                            popup.Size        = UDim2.fromOffset(220, 0)
                            popup.Visible     = true
                            cpBlocker.Visible = true
                            tw(popup, { Size = UDim2.fromOffset(220, 145) }, 0.22, Enum.EasingStyle.Back)
                        end
                    end)
                    cpBlocker.MouseButton1Click:Connect(function()
                        popupOpen         = false
                        popup.Visible     = false
                        cpBlocker.Visible = false
                    end)

                    return {
                        Get = function() return col end,
                        Set = function(c)
                            col = c
                            tw(cpBox, { BackgroundColor3 = c }, 0.1)
                        end,
                    }
                end

                -- ══════════════════════════════════════
                --  ELEMENT: SEPARATOR
                -- ══════════════════════════════════════
                function Card:Separator(label)
                    if label and label ~= "" then
                        local sepRow = new("Frame", {
                            Size                   = UDim2.new(1, 0, 0, 18),
                            BackgroundTransparency = 1,
                            ZIndex                 = 17,
                        }, inner)

                        new("Frame", {
                            Size             = UDim2.new(0.35, 0, 0, 1),
                            AnchorPoint      = Vector2.new(0, 0.5),
                            Position         = UDim2.new(0, 0, 0.5, 0),
                            BackgroundColor3 = C.LineBr,
                            BorderSizePixel  = 0,
                            ZIndex           = 18,
                        }, sepRow)

                        lbl({
                            Size           = UDim2.new(0.3, 0, 1, 0),
                            AnchorPoint    = Vector2.new(0.5, 0),
                            Position       = UDim2.new(0.5, 0, 0, 0),
                            Text           = label,
                            TextColor3     = C.TextDim,
                            Font           = Enum.Font.GothamBold,
                            TextSize       = 9,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            ZIndex         = 18,
                        }, sepRow)

                        new("Frame", {
                            Size             = UDim2.new(0.35, 0, 0, 1),
                            AnchorPoint      = Vector2.new(1, 0.5),
                            Position         = UDim2.new(1, 0, 0.5, 0),
                            BackgroundColor3 = C.LineBr,
                            BorderSizePixel  = 0,
                            ZIndex           = 18,
                        }, sepRow)
                    else
                        new("Frame", {
                            Size             = UDim2.new(1, 0, 0, 1),
                            BackgroundColor3 = C.LineBr,
                            BorderSizePixel  = 0,
                            ZIndex           = 17,
                        }, inner)
                    end
                end

                -- ══════════════════════════════════════
                --  ELEMENT: STATUS BADGE
                -- ══════════════════════════════════════
                function Card:Status(o)
                    o = o or {}
                    local statusColors = {
                        active  = C.Green,
                        idle    = C.Yellow,
                        offline = C.Red,
                        info    = C.Accent,
                    }
                    local col2 = statusColors[o.Type or "info"] or C.Accent

                    local row = new("Frame", {
                        Size                   = UDim2.new(1, 0, 0, 26),
                        BackgroundTransparency = 1,
                        ZIndex                 = 17,
                    }, inner)

                    -- Dot indicator
                    local dot2 = new("Frame", {
                        Size             = UDim2.fromOffset(8, 8),
                        AnchorPoint      = Vector2.new(0, 0.5),
                        Position         = UDim2.new(0, 0, 0.5, 0),
                        BackgroundColor3 = col2,
                        ZIndex           = 18,
                    }, row)
                    corner(dot2, 100)
                    -- status glow via dot pulse

                    lbl({
                        Size       = UDim2.new(1, -16, 1, 0),
                        Position   = UDim2.fromOffset(16, 0),
                        Text       = o.Text or "Status",
                        TextColor3 = C.Text,
                        Font       = Enum.Font.Gotham,
                        TextSize   = 12,
                        ZIndex     = 18,
                    }, row)

                    -- Pulse animation on dot
                    if o.Type == "active" then
                        task.spawn(function()
                            while true do
                                tw(dot2, { BackgroundTransparency = 0.5 }, 0.6, Enum.EasingStyle.Sine)
                                task.wait(0.6)
                                tw(dot2, { BackgroundTransparency = 0 }, 0.6, Enum.EasingStyle.Sine)
                                task.wait(0.6)
                            end
                        end)
                    end

                    return {
                        SetType = function(t)
                            local c = statusColors[t] or C.Accent
                            tw(dot2, { BackgroundColor3 = c }, 0.2)
                        end,
                        SetText = function(t)
                            row:FindFirstChildOfClass("TextLabel").Text = t
                        end,
                    }
                end

                -- Sync card on creation
                task.defer(function() syncCard(); updateLayout() end)
                return Card
            end -- Tab:Card

            return Tab
        end -- Cat:Tab

        return Cat
    end -- Window:Category

    -- ── Keyboard toggle ────────────────────────────────
    UIS.InputBegan:Connect(function(inp, gp)
        if not gp and inp.KeyCode == toggleKey then
            if Root.Visible then
                tw(Root, { Size = UDim2.fromOffset(820, 0) }, 0.22, Enum.EasingStyle.Quart)
                task.delay(0.25, function() Root.Visible = false end)
            else
                Root.Visible = true
                Root.Size    = UDim2.fromOffset(820, 0)
                twSpring(Root, { Size = UDim2.fromOffset(820, 540) }, 0.35)
            end
        end
    end)

    -- ── Window methods ─────────────────────────────────
    function Window:Show()
        Root.Visible = true
        Root.Size    = UDim2.fromOffset(820, 0)
        twSpring(Root, { Size = UDim2.fromOffset(820, 540) }, 0.35)
    end

    function Window:Hide()
        tw(Root, { Size = UDim2.fromOffset(820, 0) }, 0.22, Enum.EasingStyle.Quart)
        task.delay(0.25, function() Root.Visible = false end)
    end

    function Window:Notify(o2)
        CelestiaUI.Notify(CelestiaUI, o2)
    end

    function Window:Destroy()
        Root:Destroy()
        rootGlowContainer:Destroy()
    end

    return Window
end -- CreateWindow

return CelestiaUI
