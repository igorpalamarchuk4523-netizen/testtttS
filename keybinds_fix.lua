local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local CoreGui      = game:GetService("CoreGui")
local lp           = Players.LocalPlayer

-- ════════════════════════════════
--  Colors
-- ════════════════════════════════
local C = {
    BG         = Color3.fromRGB(11,  13,  23),
    Sidebar    = Color3.fromRGB(13,  15,  26),
    SidebarAct = Color3.fromRGB(30,  28,  68),
    SidebarHov = Color3.fromRGB(22,  24,  42),
    Header     = Color3.fromRGB(13,  15,  26),
    Card       = Color3.fromRGB(17,  19,  34),
    CardBorder = Color3.fromRGB(32,  34,  60),
    Surface    = Color3.fromRGB(22,  24,  44),
    Input      = Color3.fromRGB(13,  15,  26),
    InputBord  = Color3.fromRGB(34,  36,  64),
    Slider     = Color3.fromRGB(22,  24,  44),
    SliderFill = Color3.fromRGB(88,  78, 208),
    Knob       = Color3.fromRGB(112,  98, 240),
    Accent     = Color3.fromRGB(95,  85, 220),
    AccentBr   = Color3.fromRGB(120, 108, 245),
    AccentDim  = Color3.fromRGB(55,  48, 145),
    IconBG     = Color3.fromRGB(50,  44, 130),
    Check      = Color3.fromRGB(85,  76, 210),
    CheckBord  = Color3.fromRGB(52,  46, 120),
    TogON      = Color3.fromRGB(88,  78, 208),
    TogOFF     = Color3.fromRGB(28,  26,  52),
    Line       = Color3.fromRGB(24,  26,  46),
    Text       = Color3.fromRGB(220, 220, 240),
    TextSub    = Color3.fromRGB(140, 136, 175),
    TextDim    = Color3.fromRGB(78,  75, 112),
    TextCat    = Color3.fromRGB(78,  75, 125),
    White      = Color3.fromRGB(255, 255, 255),
    Green      = Color3.fromRGB(68, 198, 128),
    Red        = Color3.fromRGB(218,  68,  68),
    Yellow     = Color3.fromRGB(228, 182,  48),
}

-- ════════════════════════════════
--  Helpers
-- ════════════════════════════════
local function tw(o, p, t, s, d)
    TweenService:Create(o, TweenInfo.new(t or 0.18,
        s or Enum.EasingStyle.Quart,
        d or Enum.EasingDirection.Out), p):Play()
end

local function new(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(p, r)
    return new("UICorner", {CornerRadius = UDim.new(0, r or 8)}, p)
end

local function stroke(p, col, th, tr)
    return new("UIStroke", {Color=col or C.CardBorder, Thickness=th or 1, Transparency=tr or 0}, p)
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

local function lbl(props, parent)
    local o = new("TextLabel", {
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        RichText = true,
    }, parent)
    for k, v in pairs(props) do o[k] = v end
    return o
end

local function btn(props, parent)
    local o = new("TextButton", {
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
    }, parent)
    for k, v in pairs(props) do o[k] = v end
    return o
end

-- ════════════════════════════════
--  ScreenGui
-- ════════════════════════════════
local SG = new("ScreenGui", {
    Name           = "CelestiaUI",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})
pcall(function() SG.Parent = CoreGui end)
if not SG.Parent then SG.Parent = lp:WaitForChild("PlayerGui") end

-- ════════════════════════════════
--  Notifications
-- ════════════════════════════════
local NotifHolder = new("Frame", {
    Name                   = "Notifs",
    Size                   = UDim2.fromOffset(290, 0),
    AnchorPoint            = Vector2.new(1, 1),
    Position               = UDim2.new(1, -14, 1, -14),
    BackgroundTransparency = 1,
    AutomaticSize          = Enum.AutomaticSize.Y,
    ZIndex                 = 500,
}, SG)
listV(NotifHolder, 8)

-- ════════════════════════════════
--  Library
-- ════════════════════════════════
local CelestiaUI = {}

function CelestiaUI:Notify(o)
    local title  = o.Title    or "Notice"
    local desc   = o.Desc     or ""
    local dur    = o.Duration or 4
    local accent = ({success=C.Green, error=C.Red, warn=C.Yellow, info=C.Accent})[o.Type or "info"] or C.Accent

    local card = new("Frame", {
        Size             = UDim2.new(1, 0, 0, 64),
        BackgroundColor3 = C.Card,
        ClipsDescendants = true,
        ZIndex           = 501,
    }, NotifHolder)
    corner(card, 10)
    stroke(card, accent, 1, 0.5)

    new("Frame", {Size=UDim2.new(0,3,1,0), BackgroundColor3=accent, BorderSizePixel=0, ZIndex=502}, card)

    lbl({Size=UDim2.fromOffset(260,20), Position=UDim2.fromOffset(13,10),
         Text=title, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=13, ZIndex=502}, card)
    lbl({Size=UDim2.fromOffset(260,16), Position=UDim2.fromOffset(13,30),
         Text=desc,  TextColor3=C.TextSub, Font=Enum.Font.Gotham, TextSize=11, ZIndex=502,
         TextTruncate=Enum.TextTruncate.AtEnd}, card)

    local prog = new("Frame", {
        Size=UDim2.new(1,0,0,2), Position=UDim2.new(0,0,1,-2),
        BackgroundColor3=accent, BorderSizePixel=0, ZIndex=502
    }, card)

    card.Size = UDim2.new(1,0,0,0)
    tw(card, {Size=UDim2.new(1,0,0,64)}, 0.25, Enum.EasingStyle.Back)
    tw(prog, {Size=UDim2.new(0,0,0,2)}, dur, Enum.EasingStyle.Linear)
    task.delay(dur, function()
        tw(card, {Size=UDim2.new(1,0,0,0)}, 0.2)
        task.delay(0.25, function() card:Destroy() end)
    end)
end

-- ════════════════════════════════
--  CreateWindow
-- ════════════════════════════════
function CelestiaUI:CreateWindow(opts)
    opts = opts or {}
    local winTitle  = opts.Title    or "Celestia"
    local winSub    = opts.Subtitle or "UI Library"
    local toggleKey = opts.ToggleKey or Enum.KeyCode.Insert

    local Window = setmetatable({}, {__index=CelestiaUI})

    -- ── Root ─────────────────────────────────────────
    local Root = new("Frame", {
        Name             = "Root",
        Size             = UDim2.fromOffset(750, 520),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = C.BG,
        ClipsDescendants = true,
        ZIndex           = 10,
        Visible          = false,
    }, SG)
    corner(Root, 12)
    stroke(Root, C.CardBorder, 1, 0.3)

    -- ── Header ───────────────────────────────────────
    local Hdr = new("Frame", {
        Size             = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = C.Header,
        ZIndex           = 11,
    }, Root)

    new("Frame", {
        Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=C.Line, BorderSizePixel=0, ZIndex=12
    }, Hdr)

    local hIcon = new("Frame", {
        Size=UDim2.fromOffset(34,34), AnchorPoint=Vector2.new(0,0.5),
        Position=UDim2.new(0,14,0.5,0), BackgroundColor3=C.IconBG, ZIndex=12
    }, Hdr)
    corner(hIcon, 9)
    lbl({Size=UDim2.new(1,0,1,0), Text="+", TextColor3=C.White,
         Font=Enum.Font.GothamBold, TextSize=20,
         TextXAlignment=Enum.TextXAlignment.Center, ZIndex=13}, hIcon)

    lbl({Size=UDim2.fromOffset(340,22), Position=UDim2.fromOffset(58,10),
         Text=winTitle, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=15, ZIndex=12}, Hdr)
    lbl({Size=UDim2.fromOffset(340,16), Position=UDim2.fromOffset(58,30),
         Text=winSub,   TextColor3=C.TextSub, Font=Enum.Font.Gotham, TextSize=11, ZIndex=12}, Hdr)

    local xBtn = new("TextButton", {
        Size=UDim2.fromOffset(32,32), AnchorPoint=Vector2.new(1,0.5),
        Position=UDim2.new(1,-12,0.5,0), BackgroundColor3=C.Surface,
        Text="X", TextColor3=C.TextSub, Font=Enum.Font.GothamBold, TextSize=12,
        AutoButtonColor=false, ZIndex=12,
    }, Hdr)
    corner(xBtn, 8)
    stroke(xBtn, C.CardBorder, 1, 0.3)
    xBtn.MouseEnter:Connect(function()
        tw(xBtn, {BackgroundColor3=Color3.fromRGB(72,24,24), TextColor3=C.Red}, 0.12)
    end)
    xBtn.MouseLeave:Connect(function()
        tw(xBtn, {BackgroundColor3=C.Surface, TextColor3=C.TextSub}, 0.12)
    end)
    xBtn.MouseButton1Click:Connect(function()
        tw(Root, {Size=UDim2.fromOffset(750,0)}, 0.22)
        task.delay(0.25, function() Root.Visible=false end)
    end)

    -- Drag
    local dActive, dStart, dPos
    Hdr.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dActive = true; dStart = i.Position; dPos = Root.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dActive and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dStart
            Root.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset+d.X, dPos.Y.Scale, dPos.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dActive=false end
    end)

    -- ── Body ─────────────────────────────────────────
    local Body = new("Frame", {
        Size=UDim2.new(1,0,1,-56), Position=UDim2.fromOffset(0,56),
        BackgroundTransparency=1, ZIndex=11,
    }, Root)

    -- ── Sidebar ──────────────────────────────────────
    local Sidebar = new("Frame", {
        Size=UDim2.new(0,220,1,0), BackgroundColor3=C.Sidebar, ZIndex=12,
    }, Body)
    new("Frame", {
        Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=C.Line, BorderSizePixel=0, ZIndex=13,
    }, Sidebar)

    local SBScroll = new("ScrollingFrame", {
        Size=UDim2.new(1,-1,1,0), BackgroundTransparency=1,
        ScrollBarThickness=0, CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=13,
    }, Sidebar)
    pad(SBScroll, 12, 12, 10, 10)
    listV(SBScroll, 2)

    -- ── Content ──────────────────────────────────────
    local ContentArea = new("Frame", {
        Size=UDim2.new(1,-220,1,0), Position=UDim2.fromOffset(220,0),
        BackgroundTransparency=1, ClipsDescendants=true, ZIndex=12,
    }, Body)

    -- ── Tab system ───────────────────────────────────
    local allTabs   = {}
    local activeTab = nil

    local function deactivateAll()
        for _, t in ipairs(allTabs) do
            t.page.Visible = false
            tw(t.btn,   {BackgroundColor3=C.Sidebar, BackgroundTransparency=1}, 0.14)
            tw(t.lbl,   {TextColor3=C.TextSub}, 0.14)
            tw(t.dot,   {BackgroundTransparency=1}, 0.14)
        end
    end

    -- ════════════════════════════════
    --  Category
    -- ════════════════════════════════
    function Window:Category(catName)
        local Cat = {}

        lbl({
            Size=UDim2.new(1,0,0,22), Text=catName,
            TextColor3=C.TextCat, Font=Enum.Font.GothamBold, TextSize=10, ZIndex=14,
        }, SBScroll)

        function Cat:Tab(tabOpts)
            local Tab      = {}
            local tabTitle = tabOpts.Title or "Tab"

            -- sidebar row
            local rowBtn = new("TextButton", {
                Size=UDim2.new(1,0,0,36), BackgroundColor3=C.Sidebar,
                BackgroundTransparency=1, Text="", AutoButtonColor=false, ZIndex=14,
            }, SBScroll)
            corner(rowBtn, 8)

            local dot = new("Frame", {
                Size=UDim2.new(0,3,0.6,0), AnchorPoint=Vector2.new(0,0.5),
                Position=UDim2.new(0,0,0.5,0), BackgroundColor3=C.Accent,
                BackgroundTransparency=1, BorderSizePixel=0, ZIndex=15,
            }, rowBtn)
            corner(dot, 2)

            local iBox = new("Frame", {
                Size=UDim2.fromOffset(22,22), AnchorPoint=Vector2.new(0,0.5),
                Position=UDim2.new(0,10,0.5,0), BackgroundColor3=C.IconBG, ZIndex=15,
            }, rowBtn)
            corner(iBox, 6)
            lbl({Size=UDim2.new(1,0,1,0), Text="+", TextColor3=C.AccentBr,
                 Font=Enum.Font.GothamBold, TextSize=12,
                 TextXAlignment=Enum.TextXAlignment.Center, ZIndex=16}, iBox)

            local rowLbl = lbl({
                Size=UDim2.new(1,-46,1,0), Position=UDim2.fromOffset(40,0),
                Text=tabTitle, TextColor3=C.TextSub,
                Font=Enum.Font.Gotham, TextSize=13, ZIndex=15,
            }, rowBtn)

            -- ── Page ────────────────────────────────
            local Page = new("ScrollingFrame", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                ScrollBarThickness=3, ScrollBarImageColor3=C.Accent,
                ScrollBarImageTransparency=0.5,
                CanvasSize=UDim2.new(0,0,0,0),
                Visible=false, ZIndex=13,
            }, ContentArea)
            pad(Page, 14, 14, 14, 14)

            -- ── 2-column layout ──────────────────────
            -- Используем АБСОЛЮТНЫЕ размеры колонок, обновляемые по событию
            local PADDING   = 14  -- padding страницы
            local COL_GAP   = 12
            -- Ширина колонки рассчитывается динамически через AbsoluteSize

            local colL = new("Frame", {
                Name = "ColL",
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = 14,
            }, Page)
            local layoutL = listV(colL, 12)

            local colR = new("Frame", {
                Name = "ColR",
                BackgroundTransparency = 1,
                ZIndex = 14,
            }, Page)
            local layoutR = listV(colR, 12)

            -- Функция обновления позиций и размеров колонок
            local function updateLayout()
                -- Получаем реальную ширину страницы минус padding
                local pageW = Page.AbsoluteSize.X - PADDING * 2
                if pageW <= 0 then pageW = 490 end  -- fallback
                local colW = math.floor((pageW - COL_GAP) / 2)

                local lh = layoutL.AbsoluteContentSize.Y
                local rh = layoutR.AbsoluteContentSize.Y

                colL.Size     = UDim2.fromOffset(colW, lh)
                colL.Position = UDim2.fromOffset(0, 0)

                colR.Size     = UDim2.fromOffset(colW, rh)
                colR.Position = UDim2.fromOffset(colW + COL_GAP, 0)

                -- Canvas по максимальной высоте колонки
                local totalH = math.max(lh, rh) + PADDING * 2
                Page.CanvasSize = UDim2.fromOffset(0, totalH)
            end

            layoutL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateLayout)
            layoutR:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateLayout)
            Page:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)

            -- счётчик карточек для чередования колонок
            local cardCount = 0

            -- activate/deactivate
            local tabInfo = {btn=rowBtn, lbl=rowLbl, dot=dot, page=Page}
            table.insert(allTabs, tabInfo)

            local function activate()
                deactivateAll()
                activeTab = tabInfo
                Page.Visible = true
                tw(rowBtn, {BackgroundColor3=C.SidebarAct, BackgroundTransparency=0}, 0.14)
                tw(rowLbl, {TextColor3=C.Text}, 0.14)
                tw(dot,    {BackgroundTransparency=0}, 0.14)
                task.defer(updateLayout)
            end

            rowBtn.MouseButton1Click:Connect(activate)
            rowBtn.MouseEnter:Connect(function()
                if activeTab ~= tabInfo then
                    tw(rowBtn, {BackgroundColor3=C.SidebarHov, BackgroundTransparency=0}, 0.12)
                end
            end)
            rowBtn.MouseLeave:Connect(function()
                if activeTab ~= tabInfo then
                    tw(rowBtn, {BackgroundTransparency=1}, 0.12)
                end
            end)

            if #allTabs == 1 then activate() end

            -- ════════════════════════════════
            --  Card
            -- ════════════════════════════════
            function Tab:Card(cardOpts)
                local Card  = {}
                local cName = cardOpts.Title or "Card"
                cardCount   = cardCount + 1

                -- чётная → правая, нечётная → левая
                local col = (cardCount % 2 == 1) and colL or colR

                local cardFrame = new("Frame", {
                    Size             = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = C.Card,
                    ClipsDescendants = false,
                    ZIndex           = 15,
                }, col)
                corner(cardFrame, 12)
                stroke(cardFrame, C.CardBorder, 1, 0.2)

                local inner = new("Frame", {
                    Size                   = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    ZIndex                 = 16,
                }, cardFrame)
                pad(inner, 14, 14, 14, 14)
                local innerLayout = listV(inner, 10)

                local function syncCard()
                    local h = innerLayout.AbsoluteContentSize.Y + 28
                    cardFrame.Size = UDim2.new(1, 0, 0, h)
                    inner.Size     = UDim2.new(1, 0, 0, h)
                    task.defer(updateLayout)
                end
                innerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncCard)

                -- card header
                local cHdr = new("Frame", {
                    Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, ZIndex=17,
                }, inner)

                local ciBox = new("Frame", {
                    Size=UDim2.fromOffset(30,30), BackgroundColor3=C.IconBG, ZIndex=18,
                }, cHdr)
                corner(ciBox, 8)
                lbl({Size=UDim2.new(1,0,1,0), Text="+", TextColor3=C.AccentBr,
                     Font=Enum.Font.GothamBold, TextSize=15,
                     TextXAlignment=Enum.TextXAlignment.Center, ZIndex=19}, ciBox)

                lbl({Size=UDim2.new(1,-44,1,0), Position=UDim2.fromOffset(40,0),
                     Text=cName, TextColor3=C.Text,
                     Font=Enum.Font.GothamBold, TextSize=14, ZIndex=18}, cHdr)

                new("Frame", {
                    Size=UDim2.new(1,0,0,1), BackgroundColor3=C.CardBorder,
                    BorderSizePixel=0, ZIndex=17,
                }, inner)

                -- ── Slider ──────────────────────────
                function Card:Slider(o)
                    local sMin = o.Min or 0; local sMax = o.Max or 100
                    local sVal = math.clamp(o.Default or sMin, sMin, sMax)
                    local sSuf = o.Suffix or ""

                    local wrap = new("Frame", {
                        Size=UDim2.new(1,0,0,52), BackgroundTransparency=1, ZIndex=17,
                    }, inner)
                    listV(wrap, 6)

                    -- Верхняя строка: название слева, значение справа
                    local topRow = new("Frame", {
                        Size=UDim2.new(1,0,0,18), BackgroundTransparency=1, ZIndex=18,
                    }, wrap)
                    lbl({Size=UDim2.new(0.65,0,1,0), Text=o.Title or "Slider",
                         TextColor3=C.Text, Font=Enum.Font.GothamSemibold, TextSize=12, ZIndex=19}, topRow)
                    local valLbl = lbl({
                        Size=UDim2.new(0.35,0,1,0), AnchorPoint=Vector2.new(1,0),
                        Position=UDim2.new(1,0,0,0), Text=tostring(sVal)..sSuf,
                        TextColor3=C.Accent, Font=Enum.Font.GothamBold, TextSize=12,
                        TextXAlignment=Enum.TextXAlignment.Right, ZIndex=19,
                    }, topRow)

                    -- Нижняя строка: кнопка минус, трек, кнопка плюс
                    local slRow = new("Frame", {
                        Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, ZIndex=18,
                    }, wrap)

                    -- Кнопка минус (слева)
                    local minusB = new("TextButton", {
                        Size=UDim2.fromOffset(22,22), AnchorPoint=Vector2.new(0,0.5),
                        Position=UDim2.new(0,0,0.5,0),
                        BackgroundColor3=C.Surface, Text="-",
                        TextColor3=C.TextSub, Font=Enum.Font.GothamBold, TextSize=14,
                        AutoButtonColor=false, ZIndex=19,
                    }, slRow)
                    corner(minusB, 5)
                    stroke(minusB, C.InputBord, 1, 0.3)
                    minusB.MouseEnter:Connect(function() tw(minusB,{BackgroundColor3=C.SidebarAct},0.1) end)
                    minusB.MouseLeave:Connect(function() tw(minusB,{BackgroundColor3=C.Surface},0.1) end)

                    -- Кнопка плюс (справа)
                    local plusB = new("TextButton", {
                        Size=UDim2.fromOffset(22,22), AnchorPoint=Vector2.new(1,0.5),
                        Position=UDim2.new(1,0,0.5,0),
                        BackgroundColor3=C.Surface, Text="+",
                        TextColor3=C.TextSub, Font=Enum.Font.GothamBold, TextSize=14,
                        AutoButtonColor=false, ZIndex=19,
                    }, slRow)
                    corner(plusB, 5)
                    stroke(plusB, C.InputBord, 1, 0.3)
                    plusB.MouseEnter:Connect(function() tw(plusB,{BackgroundColor3=C.SidebarAct},0.1) end)
                    plusB.MouseLeave:Connect(function() tw(plusB,{BackgroundColor3=C.Surface},0.1) end)

                    -- Трек между кнопками
                    local track = new("Frame", {
                        Size=UDim2.new(1,-54,0,6), AnchorPoint=Vector2.new(0,0.5),
                        Position=UDim2.new(0,28,0.5,0),
                        BackgroundColor3=C.Slider, BorderSizePixel=0, ZIndex=19,
                    }, slRow)
                    corner(track, 100)

                    local fill = new("Frame", {
                        Size=UDim2.new((sVal-sMin)/(sMax-sMin),0,1,0),
                        BackgroundColor3=C.SliderFill, BorderSizePixel=0, ZIndex=20,
                    }, track)
                    corner(fill, 100)

                    local knob = new("Frame", {
                        Size=UDim2.fromOffset(14,14), AnchorPoint=Vector2.new(0.5,0.5),
                        Position=UDim2.new((sVal-sMin)/(sMax-sMin),0,0.5,0),
                        BackgroundColor3=C.Knob, ZIndex=21,
                    }, track)
                    corner(knob, 100)

                    local function setVal(v)
                        sVal = math.clamp(math.floor(v+0.5), sMin, sMax)
                        local pct = (sVal-sMin)/(sMax-sMin)
                        tw(fill,  {Size=UDim2.new(pct,0,1,0)}, 0.1)
                        tw(knob,  {Position=UDim2.new(pct,0,0.5,0)}, 0.1)
                        valLbl.Text = tostring(sVal)..sSuf
                        if o.Callback then o.Callback(sVal) end
                    end

                    minusB.MouseButton1Click:Connect(function() setVal(sVal-1) end)
                    plusB.MouseButton1Click:Connect(function()  setVal(sVal+1) end)

                    -- Drag по треку
                    local dragging = false
                    track.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            local rel = math.clamp(i.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                            setVal(sMin + (rel/track.AbsoluteSize.X)*(sMax-sMin))
                        end
                    end)
                    UIS.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
                    end)
                    UIS.InputChanged:Connect(function(i)
                        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                            local rel = math.clamp(i.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                            setVal(sMin + (rel/track.AbsoluteSize.X)*(sMax-sMin))
                        end
                    end)

                    return {Set=setVal, Get=function() return sVal end}
                end

                -- ── Dropdown ────────────────────────
                function Card:Dropdown(o)
                    local opts2  = o.Options or {}
                    local sel    = o.Default or (opts2[1] or "–")
                    local isOpen = false

                    lbl({Size=UDim2.new(1,0,0,16), Text=o.Title or "Dropdown",
                         TextColor3=C.Text, Font=Enum.Font.GothamSemibold, TextSize=12, ZIndex=17}, inner)

                    local dHead = new("Frame", {
                        Size=UDim2.new(1,0,0,32), BackgroundColor3=C.Input, ZIndex=17,
                    }, inner)
                    corner(dHead, 7)
                    stroke(dHead, C.InputBord, 1, 0.1)

                    local selLbl = lbl({
                        Size=UDim2.new(1,-30,1,0), Position=UDim2.fromOffset(10,0),
                        Text=sel, TextColor3=C.TextSub, Font=Enum.Font.Gotham, TextSize=12, ZIndex=18,
                    }, dHead)
                    local chev = lbl({
                        Size=UDim2.fromOffset(22,32), AnchorPoint=Vector2.new(1,0),
                        Position=UDim2.new(1,-4,0,0), Text="v", TextColor3=C.TextDim,
                        Font=Enum.Font.GothamBold, TextSize=11, ZIndex=18,
                        TextXAlignment=Enum.TextXAlignment.Center,
                    }, dHead)

                    -- Список парентим к SG чтобы он был поверх ВСЕГО
                    -- Позиция обновляется при открытии через AbsolutePosition dHead
                    local listH_px = math.min(#opts2 * 30 + 8, 150)

                    local dList = new("Frame", {
                        Size=UDim2.fromOffset(0, 0),
                        BackgroundColor3=C.Input,
                        ClipsDescendants=true,
                        ZIndex=200,
                        Visible=false,
                    }, SG)
                    corner(dList, 7)
                    stroke(dList, C.InputBord, 1, 0.1)

                    -- Прозрачный блокер кликов под списком
                    local blocker = new("TextButton", {
                        Size=UDim2.new(1,0,1,0),
                        BackgroundTransparency=1,
                        Text="", AutoButtonColor=false,
                        ZIndex=199, Visible=false,
                    }, SG)

                    local dScroll = new("ScrollingFrame", {
                        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                        ScrollBarThickness=2, ScrollBarImageColor3=C.Accent,
                        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=201,
                    }, dList)
                    pad(dScroll, 4, 4, 6, 6)
                    listV(dScroll, 2)

                    local function closeDropdown()
                        isOpen = false
                        tw(dList, {Size=UDim2.fromOffset(dList.AbsoluteSize.X, 0)}, 0.15)
                        task.delay(0.18, function()
                            dList.Visible  = false
                            blocker.Visible = false
                        end)
                        chev.Text = "v"
                    end

                    blocker.MouseButton1Click:Connect(closeDropdown)

                    for _, opt in ipairs(opts2) do
                        local ob = new("TextButton", {
                            Size=UDim2.new(1,0,0,28), BackgroundColor3=C.SidebarHov,
                            BackgroundTransparency=1, Text=opt,
                            TextColor3=(opt==sel) and C.AccentBr or C.TextSub,
                            Font=Enum.Font.Gotham, TextSize=12,
                            AutoButtonColor=false, ZIndex=202,
                            TextXAlignment=Enum.TextXAlignment.Left,
                        }, dScroll)
                        corner(ob, 5)
                        pad(ob, 0,0,8,0)
                        ob.MouseEnter:Connect(function() tw(ob,{BackgroundTransparency=0.6},0.1) end)
                        ob.MouseLeave:Connect(function() tw(ob,{BackgroundTransparency=1},0.1) end)
                        ob.MouseButton1Click:Connect(function()
                            sel = opt; selLbl.Text = opt
                            closeDropdown()
                            if o.Callback then o.Callback(opt) end
                        end)
                    end

                    local hb = btn({Size=UDim2.new(1,0,1,0), ZIndex=19}, dHead)
                    hb.MouseButton1Click:Connect(function()
                        if isOpen then
                            closeDropdown()
                        else
                            isOpen = true
                            -- Вычисляем абсолютную позицию dHead
                            local absPos  = dHead.AbsolutePosition
                            local absSize = dHead.AbsoluteSize
                            local listW   = absSize.X
                            listH_px      = math.min(#opts2 * 30 + 8, 150)

                            dList.Size     = UDim2.fromOffset(listW, 0)
                            dList.Position = UDim2.fromOffset(absPos.X, absPos.Y + absSize.Y + 4)
                            dList.Visible  = true
                            blocker.Visible = true

                            tw(dList, {Size=UDim2.fromOffset(listW, listH_px)}, 0.2, Enum.EasingStyle.Back)
                            chev.Text = "^"
                        end
                    end)
                    return {Get=function() return sel end}
                end

                -- ── Checkbox ────────────────────────
                function Card:Checkbox(o)
                    local val = o.Default or false

                    local row = new("Frame", {
                        Size=UDim2.new(1,0,0,26), BackgroundTransparency=1, ZIndex=17,
                    }, inner)

                    local box = new("Frame", {
                        Size=UDim2.fromOffset(18,18), AnchorPoint=Vector2.new(0,0.5),
                        Position=UDim2.new(0,0,0.5,0), BackgroundColor3=val and C.Check or C.TogOFF, ZIndex=18,
                    }, row)
                    corner(box, 5)
                    stroke(box, val and C.Accent or C.CheckBord, 1, 0.2)

                    local tick = lbl({
                        Size=UDim2.new(1,0,1,0), Text=val and "✓" or "",
                        TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=13,
                        TextXAlignment=Enum.TextXAlignment.Center, ZIndex=19,
                    }, box)

                    lbl({
                        Size=UDim2.new(1,-28,1,0), Position=UDim2.fromOffset(26,0),
                        Text=o.Title or "Option", TextColor3=C.Text, Font=Enum.Font.Gotham, TextSize=13, ZIndex=18,
                    }, row)

                    local function set(s)
                        val = s
                        tw(box, {BackgroundColor3=s and C.Check or C.TogOFF}, 0.15)
                        tick.Text = s and "✓" or ""
                        if o.Callback then o.Callback(s) end
                    end

                    btn({Size=UDim2.new(1,0,1,0), ZIndex=20}, row).MouseButton1Click:Connect(function() set(not val) end)
                    return {Set=set, Get=function() return val end}
                end

                -- ── Toggle ──────────────────────────
                function Card:Toggle(o)
                    local val = o.Default or false

                    local row = new("Frame", {
                        Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, ZIndex=17,
                    }, inner)

                    lbl({Size=UDim2.new(0.7,0,1,0), Text=o.Title or "Toggle",
                         TextColor3=C.Text, Font=Enum.Font.Gotham, TextSize=13, ZIndex=18}, row)

                    local trackF = new("Frame", {
                        Size=UDim2.fromOffset(40,22), AnchorPoint=Vector2.new(1,0.5),
                        Position=UDim2.new(1,0,0.5,0), BackgroundColor3=val and C.TogON or C.TogOFF, ZIndex=18,
                    }, row)
                    corner(trackF, 100)
                    stroke(trackF, C.InputBord, 1, 0.4)

                    local knobT = new("Frame", {
                        Size=UDim2.fromOffset(16,16), AnchorPoint=Vector2.new(0.5,0.5),
                        Position=UDim2.new(val and 0.73 or 0.27,0,0.5,0),
                        BackgroundColor3=C.White, ZIndex=19,
                    }, trackF)
                    corner(knobT, 100)

                    local function set(s)
                        val = s
                        tw(trackF, {BackgroundColor3=s and C.TogON or C.TogOFF}, 0.15)
                        tw(knobT,  {Position=UDim2.new(s and 0.73 or 0.27,0,0.5,0)}, 0.15)
                        if o.Callback then o.Callback(s) end
                    end
                    btn({Size=UDim2.new(1,0,1,0), ZIndex=20}, row).MouseButton1Click:Connect(function() set(not val) end)
                    return {Set=set, Get=function() return val end}
                end

                -- ── Button ──────────────────────────
                function Card:Button(o)
                    local b = new("TextButton", {
                        Size=UDim2.new(1,0,0,32), BackgroundColor3=C.AccentDim,
                        Text=o.Title or "Button", TextColor3=C.Text,
                        Font=Enum.Font.GothamSemibold, TextSize=13,
                        AutoButtonColor=false, ZIndex=17,
                    }, inner)
                    corner(b, 7)
                    stroke(b, C.Accent, 1, 0.5)
                    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=C.Accent},0.12) end)
                    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=C.AccentDim},0.12) end)
                    b.MouseButton1Click:Connect(function() if o.Callback then o.Callback() end end)
                end

                -- ── Input ───────────────────────────
                function Card:Input(o)
                    lbl({Size=UDim2.new(1,0,0,16), Text=o.Title or "Input",
                         TextColor3=C.Text, Font=Enum.Font.GothamSemibold, TextSize=12, ZIndex=17}, inner)

                    local ibWrap = new("Frame", {
                        Size=UDim2.new(1,0,0,32), BackgroundColor3=C.Input,
                        ClipsDescendants=true, ZIndex=17,
                    }, inner)
                    corner(ibWrap, 7)
                    stroke(ibWrap, C.InputBord, 1, 0.2)

                    local ib = new("TextBox", {
                        Size=UDim2.new(1,-20,1,0), Position=UDim2.fromOffset(10,0),
                        BackgroundTransparency=1,
                        Text=o.Default or "", PlaceholderText=o.Placeholder or "type here...",
                        TextColor3=C.Text, PlaceholderColor3=C.TextDim,
                        Font=Enum.Font.Gotham, TextSize=12,
                        ClearTextOnFocus=false,
                        TextXAlignment=Enum.TextXAlignment.Left,
                        TextYAlignment=Enum.TextYAlignment.Center,
                        TextWrapped=false,
                        ZIndex=18,
                    }, ibWrap)
                    ibWrap:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                        -- keep in sync
                    end)
                    ib.Focused:Connect(function() tw(ibWrap,{BackgroundColor3=C.Surface},0.12) end)
                    ib.FocusLost:Connect(function()
                        tw(ibWrap,{BackgroundColor3=C.Input},0.12)
                        if o.Callback then o.Callback(ib.Text) end
                    end)
                    return {Get=function() return ib.Text end, Set=function(v) ib.Text=v end}
                end

                -- ── Label ───────────────────────────
                function Card:Label(text)
                    lbl({Size=UDim2.new(1,0,0,16), Text=text or "",
                         TextColor3=C.TextSub, Font=Enum.Font.Gotham, TextSize=11, ZIndex=17}, inner)
                end

                task.defer(function() syncCard(); updateLayout() end)
                return Card
            end -- Tab:Card

            return Tab
        end -- Cat:Tab

        return Cat
    end -- Window:Category

    -- keyboard toggle
    UIS.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == toggleKey then
            Root.Visible = not Root.Visible
            if Root.Visible then
                Root.Size = UDim2.fromOffset(750, 0)
                tw(Root, {Size=UDim2.fromOffset(750,520)}, 0.3, Enum.EasingStyle.Back)
            end
        end
    end)

    function Window:Show()
        Root.Visible = true
        Root.Size    = UDim2.fromOffset(750, 0)
        tw(Root, {Size=UDim2.fromOffset(750,520)}, 0.35, Enum.EasingStyle.Back)
    end

    function Window:Hide()
        tw(Root, {Size=UDim2.fromOffset(750,0)}, 0.22)
        task.delay(0.25, function() Root.Visible=false end)
    end

    function Window:Notify(o) CelestiaUI.Notify(CelestiaUI, o) end

    return Window
end

return CelestiaUI

