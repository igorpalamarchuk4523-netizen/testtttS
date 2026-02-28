--[[
    		Airflow Interface - Celestia Redesign

    Author: 4lpaca (redesigned)
    License: MIT
    Github: https://github.com/4lpaca-pin/Airflow
--]]

-- Type --
export type GlobalConfig = {
	Name: string,
	Callback: (... any) -> any,
	Default : boolean & string & number & {string&any} & Enum.KeyCode,
	Min : number,
	Max : number,
	Round : number,
	Type : string,
	Content : string,
	Values : {string},
	Multi : boolean,
	Position : string,
	Numeric : boolean,
	Finished : boolean,
	Placeholder : string,
	Description : string,
	ValueTexts : {
		[number]:string
	}
};

export type Elements = {
	AddLabel : (self, name) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self, Value: boolean) -> nil,
		Destroy : (self) -> nil,
	},
	AddButton : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self, Value: boolean) -> nil,
		Destroy : (self) -> nil,
		Fire : (... any) -> any,
	},
	AddToggle : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self, Value: boolean) -> nil,
		Destroy : (self) -> nil,
		SetValue : (self,Value : boolean) -> any,
	},
	AddSlider : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self, Value: boolean) -> nil,
		Destroy : (self) -> nil,
		SetValue : (self,Value : number) -> any,
	},
	AddKeybind : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
		SetValue : (self ,Value : string & Enum.KeyCode) -> any,
	},
	AddTextbox : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
		SetValue : (self ,Value : string) -> any,
	},
	AddColorPicker : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		SetValue : (self, Value: Color3) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
	},
	AddParagraph : (self,config : GlobalConfig) -> {
		EditName : (self, Value: string) -> nil,
		EditContent : (self, Value: string) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
	},
	AddDropdown : (self, config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		SetValues : (self , Value: {string}) -> nil,
		SetDefault : (self , Value: {string} & string) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
	},
};

export type Tab = {
	Left : Elements,
	Right : Elements,
	AddSection : (self , GlobalConfig) -> Elements,
	Disabled : boolean,
	Disable : (self, Value: boolean , Reason : string & nil) -> any,
};

-- DESIGN TOKENS --
local THEME = {
	BG_WINDOW    = Color3.fromRGB(18, 18, 22),
	BG_SIDEBAR   = Color3.fromRGB(22, 22, 28),
	BG_CONTENT   = Color3.fromRGB(24, 24, 30),
	BG_CARD      = Color3.fromRGB(30, 30, 38),
	BG_CARD2     = Color3.fromRGB(34, 34, 44),
	BG_INPUT     = Color3.fromRGB(40, 40, 52),
	BG_TAB_SEL   = Color3.fromRGB(38, 35, 55),
	ACCENT       = Color3.fromRGB(130, 100, 220),
	ACCENT2      = Color3.fromRGB(160, 130, 240),
	ACCENT_DIM   = Color3.fromRGB(80, 60, 140),
	TEXT_PRIMARY = Color3.fromRGB(240, 240, 248),
	TEXT_SEC     = Color3.fromRGB(160, 160, 180),
	TEXT_DIM     = Color3.fromRGB(100, 100, 120),
	BORDER       = Color3.fromRGB(50, 50, 68),
	BORDER2      = Color3.fromRGB(60, 55, 85),
	SECTION_HDR  = Color3.fromRGB(130, 120, 170),
	TOGGLE_OFF   = Color3.fromRGB(55, 55, 70),
	TOGGLE_ON_BG = Color3.fromRGB(90, 65, 170),
	KEYBIND_BG   = Color3.fromRGB(42, 42, 56),
	SLIDER_TRACK = Color3.fromRGB(42, 42, 56),
	CORNER_SM    = UDim.new(0, 6),
	CORNER_MD    = UDim.new(0, 10),
	CORNER_LG    = UDim.new(0, 14),
};

-- Exploit Environment --
cloneref = cloneref or function(i) return i; end;
cloenfunction = cloenfunction or function(...) return ...; end;
hookfunction = hookfunction or function(a,b) return a; end;
getgenv = getgenv or getfenv;
protect_gui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end;

-- Services --
local TextService = game:GetService('TextService');
local TweenService = game:GetService('TweenService');
local RunService = game:GetService('RunService');
local Players = game:GetService('Players');
local UserInputService = game:GetService('UserInputService');
local Client = Players.LocalPlayer;
local Mouse = Client:GetMouse();
local CurrentCamera = workspace.CurrentCamera;
local AirflowUI = Instance.new("ScreenGui");
local _,CoreGui = xpcall(function()
	return (gethui and gethui()) or game:GetService("CoreGui"):FindFirstChild("RobloxGui");
end,function()
	return Client.PlayerGui;
end);

do
	AirflowUI.Name = "AirflowUI";
	AirflowUI.Parent = CoreGui;
	AirflowUI.ResetOnSpawn = false;
	AirflowUI.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	AirflowUI.IgnoreGuiInset = true;
	protect_gui(AirflowUI);
end;

-- Airflow --
local Airflow = {
	Version = "2.0",
	ScreenGui = AirflowUI,
	Config = {
		Scale = UDim2.new(0, 860, 0, 540),
		Hightlight = THEME.ACCENT,
		Logo = "http://www.roblox.com/asset/?id=118752982916680",
		Keybind = "Delete",
		Resizable = false,
		UnlockMouse = false,
		IconSize = 22,
	},
	FileManager = {},
	Features = {},
	Lucide = {
		["lucide-accessibility"] = "rbxassetid://10709751939",
		["lucide-activity"] = "rbxassetid://10709752035",
		["lucide-air-vent"] = "rbxassetid://10709752131",
		["lucide-airplay"] = "rbxassetid://10709752254",
		["lucide-alarm-check"] = "rbxassetid://10709752405",
		["lucide-alarm-clock"] = "rbxassetid://10709752630",
		["lucide-alert-circle"] = "rbxassetid://10709752996",
		["lucide-alert-triangle"] = "rbxassetid://10709753149",
		["lucide-anchor"] = "rbxassetid://10709761530",
		["lucide-archive"] = "rbxassetid://10709762233",
		["lucide-award"] = "rbxassetid://10709769406",
		["lucide-bell"] = "rbxassetid://10709775704",
		["lucide-bolt"] = "rbxassetid://10709776126",
		["lucide-book"] = "rbxassetid://10709781824",
		["lucide-bot"] = "rbxassetid://10709782230",
		["lucide-bug"] = "rbxassetid://10709782845",
		["lucide-calendar"] = "rbxassetid://10709789505",
		["lucide-check"] = "rbxassetid://10709790644",
		["lucide-check-circle"] = "rbxassetid://10709790387",
		["lucide-chevron-down"] = "rbxassetid://10709790948",
		["lucide-chevron-left"] = "rbxassetid://10709791281",
		["lucide-chevron-right"] = "rbxassetid://10709791437",
		["lucide-chevron-up"] = "rbxassetid://10709791523",
		["lucide-clock"] = "rbxassetid://10709805144",
		["lucide-code"] = "rbxassetid://10709810463",
		["lucide-cog"] = "rbxassetid://10709810948",
		["lucide-command"] = "rbxassetid://10709811365",
		["lucide-compass"] = "rbxassetid://10709811445",
		["lucide-copy"] = "rbxassetid://10709812159",
		["lucide-crosshair"] = "rbxassetid://10709818534",
		["lucide-crown"] = "rbxassetid://10709818626",
		["lucide-database"] = "rbxassetid://10709818996",
		["lucide-edit"] = "rbxassetid://10734883598",
		["lucide-eye"] = "rbxassetid://10723346959",
		["lucide-filter"] = "rbxassetid://10723375128",
		["lucide-flag"] = "rbxassetid://10723375890",
		["lucide-flame"] = "rbxassetid://10723376114",
		["lucide-folder"] = "rbxassetid://10723387563",
		["lucide-gamepad"] = "rbxassetid://10723395457",
		["lucide-gamepad-2"] = "rbxassetid://10723395215",
		["lucide-gauge"] = "rbxassetid://10723395708",
		["lucide-gem"] = "rbxassetid://10723396000",
		["lucide-ghost"] = "rbxassetid://10723396107",
		["lucide-globe"] = "rbxassetid://10723404337",
		["lucide-grid"] = "rbxassetid://10723404936",
		["lucide-hammer"] = "rbxassetid://10723405360",
		["lucide-heart"] = "rbxassetid://10723406885",
		["lucide-home"] = "rbxassetid://10723407389",
		["lucide-info"] = "rbxassetid://10723415903",
		["lucide-key"] = "rbxassetid://10723416652",
		["lucide-keyboard"] = "rbxassetid://10723416765",
		["lucide-layers"] = "rbxassetid://10723424505",
		["lucide-leaf"] = "rbxassetid://10723425539",
		["lucide-list"] = "rbxassetid://10723433811",
		["lucide-lock"] = "rbxassetid://10723434711",
		["lucide-map-pin"] = "rbxassetid://10734886004",
		["lucide-menu"] = "rbxassetid://10734887784",
		["lucide-moon"] = "rbxassetid://10734897102",
		["lucide-mouse"] = "rbxassetid://10734898592",
		["lucide-music"] = "rbxassetid://10734905958",
		["lucide-network"] = "rbxassetid://10734906975",
		["lucide-package"] = "rbxassetid://10734909540",
		["lucide-pencil"] = "rbxassetid://10734919691",
		["lucide-person-standing"] = "rbxassetid://10734920149",
		["lucide-rocket"] = "rbxassetid://10734934585",
		["lucide-save"] = "rbxassetid://10734941499",
		["lucide-search"] = "rbxassetid://10734943674",
		["lucide-settings"] = "rbxassetid://10734950309",
		["lucide-settings-2"] = "rbxassetid://10734950020",
		["lucide-shield"] = "rbxassetid://10734951847",
		["lucide-sliders"] = "rbxassetid://10734963400",
		["lucide-star"] = "rbxassetid://10734966248",
		["lucide-sun"] = "rbxassetid://10734974297",
		["lucide-sword"] = "rbxassetid://10734975486",
		["lucide-swords"] = "rbxassetid://10734975692",
		["lucide-target"] = "rbxassetid://10734977012",
		["lucide-terminal"] = "rbxassetid://10734982144",
		["lucide-toggle-right"] = "rbxassetid://10734985040",
		["lucide-trash"] = "rbxassetid://10747362393",
		["lucide-trending-up"] = "rbxassetid://10747363465",
		["lucide-trophy"] = "rbxassetid://10747363809",
		["lucide-user"] = "rbxassetid://10747373176",
		["lucide-users"] = "rbxassetid://10747373426",
		["lucide-volume-2"] = "rbxassetid://10747375679",
		["lucide-wrench"] = "rbxassetid://10747383470",
		["lucide-x"] = "rbxassetid://10747384394",
		["lucide-x-circle"] = "rbxassetid://10747383819",
		["lucide-zap"] = "rbxassetid://10709790202",
		["lucide-zoom-in"] = "rbxassetid://10747384552",
	},
};

-- Helpers --
function Airflow:RandomString() : string
	return string.char(math.random(65,90),math.random(65,90),math.random(65,90),math.random(65,90),math.random(65,90),math.random(65,90),math.random(65,90),math.random(65,90));
end;

function Airflow:GetIcon(name : string) : string
	return Airflow.Lucide['lucide-'..tostring(name)] or Airflow.Lucide[name] or Airflow.Lucide[tostring(name)] or "";
end;

function Airflow:SetIcon(name : string, value : string) : nil
	Airflow.Lucide[name] = value;
end;

function Airflow:Rounding(num, numDecimalPlaces) : number
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end;

function Airflow:CreateAnimation(Instance: Instance , Time: number , Style : Enum.EasingStyle , Property : {[string] : any}) : Tween
	local Tween = TweenService:Create(Instance, TweenInfo.new(Time or 0.3, Style or Enum.EasingStyle.Quint), Property);
	Tween:Play();
	return Tween;
end;

function Airflow:IsMobile() : boolean
	return UserInputService.TouchEnabled;
end;

function Airflow:IsMouseOverFrame(Frame) : boolean
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;
	return Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y;
end;

function Airflow:NewInput(frame : Frame , Callback : () -> ()) : TextButton
	local Button = Instance.new('TextButton', frame);
	Button.ZIndex = frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1, 1);
	Button.BackgroundTransparency = 1;
	Button.TextTransparency = 1;
	Button.Text = "";
	if Callback then
		Button.MouseButton1Click:Connect(Callback);
	end;
	return Button;
end;

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner", parent);
	c.CornerRadius = radius or THEME.CORNER_SM;
	return c;
end;

local function makeStroke(parent, color, transparency, thickness)
	local s = Instance.new("UIStroke", parent);
	s.Color = color or THEME.BORDER;
	s.Transparency = transparency or 0;
	s.Thickness = thickness or 1;
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
	return s;
end;

local function makePadding(parent, h, v)
	local p = Instance.new("UIPadding", parent);
	p.PaddingLeft = UDim.new(0, h or 10);
	p.PaddingRight = UDim.new(0, h or 10);
	p.PaddingTop = UDim.new(0, v or 8);
	p.PaddingBottom = UDim.new(0, v or 8);
	return p;
end;

-- File Manager --
do
	local SetBlock = function(element, type, value)
		if type == "Keybind" then element:SetValue(value)
		elseif type == "Toggle" then element:SetValue(value)
		elseif type == "Dropdown" then element:SetDefault(value)
		elseif type == "Slider" then element:SetValue(value)
		elseif type == "TextBox" then element:SetValue(value)
		elseif type == "ColorPicker" then element:SetValue(Color3.fromRGB(value[1],value[2],value[3])) end;
	end;

	local ParserObject = function(model, cfg)
		for i,v in next, cfg do
			local element = model:GetElementFromKey(i);
			local Type = string.split(i,'_')[1];
			if element and element.Type == Type then
				SetBlock(element.API, element.Type, v.Value)
			end;
		end;
	end;

	local Parser = function(config, window, VERSION)
		local WinCFG = window:GetConfigs();
		if WinCFG.VERSION ~= VERSION then
			warn("VERSION mismatch");
			return false, "VERSION mismatch";
		end;
		for Tab,Value in next, config do
			local WindowTab = window:GetTabFromKey(tostring(Tab));
			if WindowTab then
				ParserObject(WindowTab.Left, Value.Left);
				ParserObject(WindowTab.Right, Value.Right);
				for i,v in next, Value.Sections do
					local Section = WindowTab:GetSectionFromKey(i);
					if Section then ParserObject(Section, v) end;
				end;
			end;
		end;
		return true;
	end;

	function Airflow.FileManager:WriteConfig(Window, path)
		local config = Window:GetConfigs();
		local mem = game:GetService('HttpService'):JSONEncode(config);
		if writefile then writefile(path, mem) end;
		return mem;
	end;

	function Airflow.FileManager:GetConfig(Window)
		return game:GetService('HttpService'):JSONEncode(Window:GetConfigs());
	end;

	function Airflow.FileManager:LoadConfig(Window, path, VERSION)
		local content = readfile(path);
		local Code = game:GetService('HttpService'):JSONDecode(content);
		return Parser(Code, Window, VERSION or "1.0");
	end;

	function Airflow.FileManager:LoadConfigFromString(Window, str, VERSION)
		local Code = game:GetService('HttpService'):JSONDecode(str);
		return Parser(Code, Window, VERSION or "1.0");
	end;
end;

-- Color Picker (preserved, minimal changes) --
do
	local ColorPicker = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local ColorPick = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local mouse = Instance.new("ImageLabel")
	local ColorSelect = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_3 = Instance.new("UICorner")
	local move = Instance.new("Frame")
	local left = Instance.new("Frame")
	local right = Instance.new("Frame")
	local Copy = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local Text = Instance.new("TextLabel")
	local Paste = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local Text_2 = Instance.new("TextLabel")

	ColorPicker.Name = Airflow:RandomString()
	ColorPicker.Parent = Airflow.ScreenGui
	ColorPicker.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorPicker.BackgroundColor3 = THEME.BG_CARD
	ColorPicker.BackgroundTransparency = 0.05
	ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPicker.BorderSizePixel = 0
	ColorPicker.ClipsDescendants = true
	ColorPicker.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorPicker.Size = UDim2.new(0.1, 100, 0.1, 100)
	ColorPicker.SizeConstraint = Enum.SizeConstraint.RelativeYY
	ColorPicker.ZIndex = 105
	ColorPicker.Visible = false
	ColorPicker.Active = true

	ColorPicker:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
		ColorPicker.Visible = ColorPicker.BackgroundTransparency <= 0.9;
	end)

	Airflow.Features.ColorPickerRoot = ColorPicker

	makeCorner(ColorPicker, UDim.new(0, 8))
	makeStroke(ColorPicker, THEME.BORDER2, 0.2)

	ColorPick.Name = Airflow:RandomString()
	ColorPick.Parent = ColorPicker
	ColorPick.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
	ColorPick.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPick.BorderSizePixel = 0
	ColorPick.Position = UDim2.new(0, 10, 0, 10)
	ColorPick.Size = UDim2.new(0.75, 0, 0.75, 0)
	ColorPick.ZIndex = 107
	ColorPick.Image = "rbxassetid://4155801252"
	ColorPick.ImageTransparency = 1
	ColorPick.BackgroundTransparency = 1

	makeCorner(ColorPick, UDim.new(0, 5))

	mouse.Name = Airflow:RandomString()
	mouse.Parent = ColorPick
	mouse.BackgroundTransparency = 1
	mouse.BorderColor3 = Color3.fromRGB(0, 0, 0)
	mouse.BorderSizePixel = 0
	mouse.Position = UDim2.new(0, 15, 0, 15)
	mouse.Size = UDim2.new(0, 15, 0, 15)
	mouse.ZIndex = 107
	mouse.Image = "http://www.roblox.com/asset/?id=4805639000"
	mouse.ImageTransparency = 1
	mouse.AnchorPoint = Vector2.new(0.5, 0.5)

	ColorSelect.Name = Airflow:RandomString()
	ColorSelect.Parent = ColorPicker
	ColorSelect.AnchorPoint = Vector2.new(1, 0)
	ColorSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorSelect.BorderSizePixel = 0
	ColorSelect.Position = UDim2.new(1, -10, 0, 10)
	ColorSelect.Size = UDim2.new(0.1, -3, 0.75, 0)
	ColorSelect.SizeConstraint = Enum.SizeConstraint.RelativeYY
	ColorSelect.ZIndex = 107
	ColorSelect.BackgroundTransparency = 1

	UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)),
		ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)),
		ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)),
		ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)),
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)),
		ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)),
		ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)),
		ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
	}
	UIGradient.Rotation = 90
	UIGradient.Parent = ColorSelect

	makeCorner(ColorSelect, UDim.new(0, 4))

	move.Name = Airflow:RandomString()
	move.Parent = ColorSelect
	move.AnchorPoint = Vector2.new(0.5, 0)
	move.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	move.BackgroundTransparency = 1
	move.BorderColor3 = Color3.fromRGB(0, 0, 0)
	move.BorderSizePixel = 0
	move.Position = UDim2.new(0.5, 0, 0, 15)
	move.Size = UDim2.new(1, 8, 0, 2)
	move.ZIndex = 108

	left.Name = Airflow:RandomString(); left.Parent = move
	left.AnchorPoint = Vector2.new(0, 0.5); left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	left.BorderSizePixel = 0; left.Position = UDim2.new(0, 0, 0.5, 0)
	left.Size = UDim2.new(0, 7, 1, 0); left.ZIndex = 109; left.BackgroundTransparency = 1

	right.Name = Airflow:RandomString(); right.Parent = move
	right.AnchorPoint = Vector2.new(1, 0.5); right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	right.BorderSizePixel = 0; right.Position = UDim2.new(1, 0, 0.5, 0)
	right.Size = UDim2.new(0, 7, 1, 0); right.ZIndex = 109; right.BackgroundTransparency = 1

	Copy.Name = Airflow:RandomString()
	Copy.Parent = ColorPicker
	Copy.AnchorPoint = Vector2.new(0, 1)
	Copy.BackgroundColor3 = THEME.BG_INPUT
	Copy.BackgroundTransparency = 0.3
	Copy.BorderSizePixel = 0
	Copy.ClipsDescendants = true
	Copy.Position = UDim2.new(0, 10, 1, -8)
	Copy.Size = UDim2.new(0.5, -12, 0, 24)
	Copy.ZIndex = 300

	makeCorner(Copy, UDim.new(0, 5))

	Text.Parent = Copy
	Text.AnchorPoint = Vector2.new(0.5, 0.5)
	Text.BackgroundTransparency = 1
	Text.BorderSizePixel = 0
	Text.Position = UDim2.new(0.5, 0, 0.5, 0)
	Text.Size = UDim2.new(1, -10, 0, 20)
	Text.ZIndex = 300
	Text.Font = Enum.Font.GothamMedium
	Text.Text = "Copy"
	Text.TextColor3 = THEME.TEXT_PRIMARY
	Text.TextSize = 13
	Text.TextWrapped = true
	Text.TextTransparency = 1

	Paste.Name = Airflow:RandomString()
	Paste.Parent = ColorPicker
	Paste.AnchorPoint = Vector2.new(1, 1)
	Paste.BackgroundColor3 = THEME.BG_INPUT
	Paste.BackgroundTransparency = 0.3
	Paste.BorderSizePixel = 0
	Paste.ClipsDescendants = true
	Paste.Position = UDim2.new(1, -10, 1, -8)
	Paste.Size = UDim2.new(0.5, -12, 0, 24)
	Paste.ZIndex = 300

	makeCorner(Paste, UDim.new(0, 5))

	Text_2.Parent = Paste
	Text_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Text_2.BackgroundTransparency = 1
	Text_2.BorderSizePixel = 0
	Text_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Text_2.Size = UDim2.new(1, -10, 0, 20)
	Text_2.ZIndex = 300
	Text_2.Font = Enum.Font.GothamMedium
	Text_2.Text = "Paste"
	Text_2.TextColor3 = THEME.TEXT_PRIMARY
	Text_2.TextSize = 13
	Text_2.TextWrapped = true
	Text_2.TextTransparency = 1

	Airflow.Features.ColorPickerToggle = false
	Airflow.Features.ColorDefault = Color3.fromRGB(255,255,255)
	Airflow.Features.CopyColor = Airflow.Features.ColorDefault
	Airflow.Features.Callback = nil

	local function hoverCard(frame)
		frame.MouseEnter:Connect(function()
			Airflow:CreateAnimation(frame, 0.2, nil, {BackgroundTransparency = 0.1})
		end)
		frame.MouseLeave:Connect(function()
			Airflow:CreateAnimation(frame, 0.2, nil, {BackgroundTransparency = 0.3})
		end)
	end

	hoverCard(Copy)
	hoverCard(Paste)

	Airflow:NewInput(Copy, function()
		Airflow.Features.CopyColor = Airflow.Features.ColorDefault
	end)

	Airflow:NewInput(Paste, function()
		local H,S,V = Airflow.Features.CopyColor:ToHSV()
		Airflow.Features.ColorDefault = Airflow.Features.CopyColor
		Airflow:CreateAnimation(ColorPick, 0.4, nil, {BackgroundColor3 = Color3.fromHSV(H,1,1)})
		Airflow:CreateAnimation(mouse, 0.4, nil, {Position = UDim2.new(S, 0, 1-V, 0)})
		Airflow:CreateAnimation(move, 0.4, nil, {Position = UDim2.new(0.5, 0, H, 0)})
		if Airflow.Features.Callback then task.spawn(Airflow.Features.Callback, Airflow.Features.ColorDefault) end
	end)

	local OldCode = 0
	local CodeH, CodeV = 1, 1
	local IsPressM1 = false

	ColorPicker.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			IsPressM1 = true
		end
	end)
	ColorPicker.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			IsPressM1 = false
		end
	end)
	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			if not Airflow:IsMouseOverFrame(ColorPicker) then
				Airflow.Features:OnColorPicker(false)
			end
		end
	end)

	ColorSelect.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			IsPressM1 = true
			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do
				task.wait()
				local ColorY = ColorSelect.AbsolutePosition.Y
				local ColorYM = ColorY + ColorSelect.AbsoluteSize.Y
				local Value = math.clamp(Mouse.Y, ColorY, ColorYM)
				local Code = (Value - ColorY) / (ColorYM - ColorY)
				Airflow.Features.ColorDefault = Color3.fromHSV(Code, CodeH, CodeV)
				if Airflow.Features.Callback then task.spawn(Airflow.Features.Callback, Airflow.Features.ColorDefault) end
				Airflow:CreateAnimation(move, 0.4, nil, {Position = UDim2.new(0.5, 0, Code, 0)})
				Airflow:CreateAnimation(ColorPick, 0.4, nil, {BackgroundColor3 = Color3.fromHSV(Code, 1, 1)})
				if Code > OldCode then
					Airflow:CreateAnimation(left, 0.2, nil, {Rotation = 45})
					Airflow:CreateAnimation(right, 0.2, nil, {Rotation = -45})
				elseif Code < OldCode then
					Airflow:CreateAnimation(left, 0.2, nil, {Rotation = -45})
					Airflow:CreateAnimation(right, 0.2, nil, {Rotation = 45})
				else
					Airflow:CreateAnimation(left, 0.2, nil, {Rotation = 0})
					Airflow:CreateAnimation(right, 0.2, nil, {Rotation = 0})
				end
				OldCode = Code
			end
			Airflow:CreateAnimation(left, 0.5, nil, {Rotation = 0})
			Airflow:CreateAnimation(right, 0.5, nil, {Rotation = 0})
		end
	end)

	ColorPick.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			IsPressM1 = true
			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do
				task.wait()
				local PosX = ColorPick.AbsolutePosition.X
				local ScaleX = PosX + ColorPick.AbsoluteSize.X
				local Value = math.clamp(Mouse.X, PosX, ScaleX)
				local PosY = ColorPick.AbsolutePosition.Y
				local ScaleY = PosY + ColorPick.AbsoluteSize.Y
				local Vals = math.clamp(Mouse.Y, PosY, ScaleY)
				CodeH = (Value - PosX) / (ScaleX - PosX)
				CodeV = 1 - ((Vals - PosY) / (ScaleY - PosY))
				Airflow.Features.ColorDefault = Color3.fromHSV(OldCode, CodeH, CodeV)
				if Airflow.Features.Callback then task.spawn(Airflow.Features.Callback, Airflow.Features.ColorDefault) end
				Airflow:CreateAnimation(mouse, 0.2, nil, {Position = UDim2.new(CodeH, 0, 1-CodeV, 0)})
			end
		end
	end)

	function Airflow.Features:SetColor(Color)
		local H,S,V = Color:ToHSV()
		Airflow.Features.ColorDefault = Color
		OldCode = H; CodeH = S; CodeV = V
	end

	function Airflow.Features:SetPosition(Position)
		Airflow:CreateAnimation(ColorPicker, 0.4, nil, {Position = Position})
	end

	function Airflow.Features:OnColorPicker(Value)
		Airflow.Features.ColorPickerToggle = Value
		if Value then
			local H,S,V = Airflow.Features.ColorDefault:ToHSV()
			Airflow:CreateAnimation(ColorPicker, 0.4, nil, {BackgroundTransparency = 0.05, Size = UDim2.new(0.1, 100, 0.1, 100)})
			Airflow:CreateAnimation(ColorPick, 0.6, nil, {ImageTransparency = 0, BackgroundTransparency = 0, BackgroundColor3 = Color3.fromHSV(H,1,1)})
			Airflow:CreateAnimation(mouse, 0.4, nil, {ImageTransparency = 0, Position = UDim2.new(S, 0, 1-V, 0)})
			Airflow:CreateAnimation(ColorSelect, 0.4, nil, {BackgroundTransparency = 0})
			Airflow:CreateAnimation(move, 0.4, nil, {Position = UDim2.new(0.5, 0, H, 0)})
			Airflow:CreateAnimation(left, 0.4, nil, {BackgroundTransparency = 0})
			Airflow:CreateAnimation(right, 0.4, nil, {BackgroundTransparency = 0})
			Airflow:CreateAnimation(Copy, 0.4, nil, {BackgroundTransparency = 0.3})
			Airflow:CreateAnimation(Paste, 0.4, nil, {BackgroundTransparency = 0.3})
			Airflow:CreateAnimation(Text, 0.4, nil, {TextTransparency = 0})
			Airflow:CreateAnimation(Text_2, 0.4, nil, {TextTransparency = 0})
		else
			Airflow.Features.Callback = nil
			Airflow:CreateAnimation(ColorPicker, 0.4, nil, {BackgroundTransparency = 1, Size = UDim2.new(0.1, 85, 0.1, 85)})
			Airflow:CreateAnimation(ColorPick, 0.4, nil, {ImageTransparency = 1, BackgroundTransparency = 1})
			Airflow:CreateAnimation(mouse, 0.4, nil, {ImageTransparency = 1})
			Airflow:CreateAnimation(ColorSelect, 0.4, nil, {BackgroundTransparency = 1})
			Airflow:CreateAnimation(left, 0.4, nil, {BackgroundTransparency = 1})
			Airflow:CreateAnimation(right, 0.4, nil, {BackgroundTransparency = 1})
			Airflow:CreateAnimation(Copy, 0.4, nil, {BackgroundTransparency = 1})
			Airflow:CreateAnimation(Paste, 0.4, nil, {BackgroundTransparency = 1})
			Airflow:CreateAnimation(Text, 0.4, nil, {TextTransparency = 1})
			Airflow:CreateAnimation(Text_2, 0.4, nil, {TextTransparency = 1})
		end
	end

	Airflow.Features:OnColorPicker(false)
end

-- Elements Builder --
function Airflow:Elements(element : Frame, OnChange : BindableEvent, windowConfig) : Elements
	local elements = {}
	local delayTick = 0.05
	local ElementConfigs = {}
	local ElementId = 1
	local ElementIDs = {}

	-- Helper: create a card frame (Celestia-style rounded card with border)
	local function makeCard(parent, height)
		local card = Instance.new("Frame")
		card.Name = Airflow:RandomString()
		card.Parent = parent
		card.BackgroundColor3 = THEME.BG_CARD
		card.BackgroundTransparency = 1
		card.BorderSizePixel = 0
		card.Size = UDim2.new(1, 0, 0, height or 72)
		card.ZIndex = 6
		card.ClipsDescendants = false
		makeCorner(card, THEME.CORNER_MD)
		makeStroke(card, THEME.BORDER, 0.5)
		return card
	end

	-- Helper: title label
	local function makeTitle(parent, text, z)
		local lbl = Instance.new("TextLabel")
		lbl.Name = Airflow:RandomString()
		lbl.Parent = parent
		lbl.BackgroundTransparency = 1
		lbl.BorderSizePixel = 0
		lbl.Font = Enum.Font.GothamBold
		lbl.Text = text
		lbl.TextColor3 = THEME.TEXT_PRIMARY
		lbl.TextSize = 14
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextWrapped = true
		lbl.ZIndex = z or 7
		lbl.TextTransparency = 1
		return lbl
	end

	-- Helper: description label
	local function makeDesc(parent, text, z)
		local lbl = Instance.new("TextLabel")
		lbl.Name = Airflow:RandomString()
		lbl.Parent = parent
		lbl.BackgroundTransparency = 1
		lbl.BorderSizePixel = 0
		lbl.Font = Enum.Font.Gotham
		lbl.Text = text or ""
		lbl.TextColor3 = THEME.TEXT_SEC
		lbl.TextSize = 12
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextWrapped = true
		lbl.ZIndex = z or 7
		lbl.TextTransparency = 1
		return lbl
	end

	local function visAnim(card, titleLbl, extra, value)
		if value then
			task.wait(delayTick)
			Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
			Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
			if extra then
				for _, v in ipairs(extra) do
					if v.prop == "TextTransparency" then
						Airflow:CreateAnimation(v.obj, 0.5, nil, {TextTransparency = v.val or 0})
					elseif v.prop == "BackgroundTransparency" then
						Airflow:CreateAnimation(v.obj, 0.5, nil, {BackgroundTransparency = v.val or 0})
					elseif v.prop == "ImageTransparency" then
						Airflow:CreateAnimation(v.obj, 0.5, nil, {ImageTransparency = v.val or 0})
					end
				end
			end
		else
			Airflow:CreateAnimation(card, 0.4, nil, {BackgroundTransparency = 1})
			Airflow:CreateAnimation(titleLbl, 0.4, nil, {TextTransparency = 1})
			if extra then
				for _, v in ipairs(extra) do
					if v.prop == "TextTransparency" then
						Airflow:CreateAnimation(v.obj, 0.4, nil, {TextTransparency = 1})
					elseif v.prop == "BackgroundTransparency" then
						Airflow:CreateAnimation(v.obj, 0.4, nil, {BackgroundTransparency = 1})
					elseif v.prop == "ImageTransparency" then
						Airflow:CreateAnimation(v.obj, 0.4, nil, {ImageTransparency = 1})
					end
				end
			end
		end
	end

	----- AddLabel -----
	function elements:AddLabel(name)
		local ID = ElementId
		local card = makeCard(element, 36)
		makePadding(card, 14, 0)
		local lbl = makeTitle(card, name)
		lbl.Position = UDim2.new(0, 14, 0.5, 0)
		lbl.Size = UDim2.new(1, -28, 0, 18)
		lbl.AnchorPoint = Vector2.new(0, 0.5)

		if OnChange:GetAttribute('Value') then
			task.delay(0.3, Airflow.CreateAnimation, Airflow, card, 0.5, nil, {BackgroundTransparency = 0})
			task.delay(0.3, Airflow.CreateAnimation, Airflow, lbl, 0.5, nil, {TextTransparency = 0})
		end

		OnChange.Event:Connect(function(v) visAnim(card, lbl, nil, v) end)
		ElementId += 1

		local tb = {
			Edit = function(_, v) lbl.Text = v end,
			Visible = function(_, v) card.Visible = v end,
			Destroy = function(_) card:Destroy() end,
			ID = ID,
		}
		ElementIDs[ID] = {Name = name, ID = ID, Type = "Label", API = tb}
		return tb
	end

	----- AddButton -----
	function elements:AddButton(config)
		config = config or {}
		config.Name = config.Name or "Button"
		config.Callback = config.Callback or function() end
		config.Description = config.Description or nil

		local ID = ElementId
		local card = makeCard(element, config.Description and 68 or 50)

		-- Title
		local titleLbl = makeTitle(card, config.Name)
		titleLbl.Position = UDim2.new(0, 14, 0, config.Description and 14 or nil)
		titleLbl.Size = UDim2.new(1, -28, 0, 18)
		titleLbl.AnchorPoint = config.Description and Vector2.new(0, 0) or Vector2.new(0, 0.5)
		if not config.Description then
			titleLbl.Position = UDim2.new(0, 14, 0.5, 0)
		end

		-- Optional desc
		local descLbl
		if config.Description then
			descLbl = makeDesc(card, config.Description)
			descLbl.Position = UDim2.new(0, 14, 0, 36)
			descLbl.Size = UDim2.new(1, -28, 0, 16)
		end

		-- Hover effect
		card.MouseEnter:Connect(function()
			Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD2})
		end)
		card.MouseLeave:Connect(function()
			Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD})
		end)

		-- Click ripple accent
		card.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				local stroke = card:FindFirstChildOfClass("UIStroke")
				if stroke then
					Airflow:CreateAnimation(stroke, 0.1, nil, {Transparency = 0, Color = THEME.ACCENT})
					task.delay(0.3, function()
						Airflow:CreateAnimation(stroke, 0.3, nil, {Transparency = 0.5, Color = THEME.BORDER})
					end)
				end
			end
		end)

		Airflow:NewInput(card, config.Callback)

		if OnChange:GetAttribute('Value') then
			task.delay(0.4, Airflow.CreateAnimation, Airflow, card, 0.5, nil, {BackgroundTransparency = 0})
			task.delay(0.4, Airflow.CreateAnimation, Airflow, titleLbl, 0.5, nil, {TextTransparency = 0})
			if descLbl then task.delay(0.4, Airflow.CreateAnimation, Airflow, descLbl, 0.5, nil, {TextTransparency = 0.35}) end
		end

		local extras = {}
		if descLbl then table.insert(extras, {obj = descLbl, prop = "TextTransparency", val = 0.35}) end
		OnChange.Event:Connect(function(v) visAnim(card, titleLbl, extras, v) end)
		ElementId += 1

		local tb = {
			Edit = function(_, v) titleLbl.Text = v end,
			Visible = function(_, v) card.Visible = v end,
			Fire = config.Callback,
			Destroy = function(_) card:Destroy() end,
		}
		ElementIDs[ID] = {Name = config.Name, ID = ID, Type = "Button", API = tb}
		return tb
	end

	----- AddToggle -----
	function elements:AddToggle(config)
		config = config or {}
		config.Name = config.Name or "Toggle"
		config.Callback = config.Callback or function() end
		config.Default = config.Default or false
		config.Description = config.Description or nil

		local ID = ElementId
		local cardH = config.Description and 72 or 52
		local card = makeCard(element, cardH)

		local titleLbl = makeTitle(card, config.Name)
		titleLbl.Position = UDim2.new(0, 14, 0, config.Description and 14 or nil)
		titleLbl.Size = UDim2.new(1, -80, 0, 18)
		titleLbl.AnchorPoint = config.Description and Vector2.new(0, 0) or Vector2.new(0, 0.5)
		if not config.Description then titleLbl.Position = UDim2.new(0, 14, 0.5, 0) end

		local descLbl
		if config.Description then
			descLbl = makeDesc(card, config.Description)
			descLbl.Position = UDim2.new(0, 14, 0, 36)
			descLbl.Size = UDim2.new(1, -80, 0, 16)
		end

		-- Toggle track
		local track = Instance.new("Frame")
		track.Name = Airflow:RandomString()
		track.Parent = card
		track.AnchorPoint = Vector2.new(1, 0.5)
		track.Position = UDim2.new(1, -14, 0.5, 0)
		track.Size = UDim2.new(0, 42, 0, 22)
		track.BackgroundColor3 = config.Default and THEME.TOGGLE_ON_BG or THEME.TOGGLE_OFF
		track.BackgroundTransparency = 1
		track.BorderSizePixel = 0
		track.ZIndex = 7
		makeCorner(track, UDim.new(1, 0))

		-- Toggle thumb
		local thumb = Instance.new("Frame")
		thumb.Name = Airflow:RandomString()
		thumb.Parent = track
		thumb.AnchorPoint = Vector2.new(0.5, 0.5)
		thumb.Position = config.Default and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.28, 0, 0.5, 0)
		thumb.Size = UDim2.new(0, 16, 0, 16)
		thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		thumb.BackgroundTransparency = 1
		thumb.BorderSizePixel = 0
		thumb.ZIndex = 8
		makeCorner(thumb, UDim.new(1, 0))

		local function updateToggle(val)
			Airflow:CreateAnimation(track, 0.3, nil, {
				BackgroundColor3 = val and THEME.TOGGLE_ON_BG or THEME.TOGGLE_OFF
			})
			Airflow:CreateAnimation(thumb, 0.3, Enum.EasingStyle.Back, {
				Position = val and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.28, 0, 0.5, 0)
			})
		end

		updateToggle(config.Default)

		ElementConfigs["Toggle_"..config.Name.."_"..tostring(ID)] = {Value = config.Default}

		local BindableToggle = Instance.new("BindableEvent", card)
		Airflow:NewInput(card, function()
			config.Default = not config.Default
			BindableToggle:Fire(config.Default)
			ElementConfigs["Toggle_"..config.Name.."_"..tostring(ID)] = {Value = config.Default}
			updateToggle(config.Default)
			config.Callback(config.Default)
		end)

		card.MouseEnter:Connect(function()
			if card.BackgroundTransparency < 0.5 then
				Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD2})
			end
		end)
		card.MouseLeave:Connect(function()
			if card.BackgroundTransparency < 0.5 then
				Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD})
			end
		end)

		if OnChange:GetAttribute('Value') then
			task.delay(0.4, Airflow.CreateAnimation, Airflow, card, 0.5, nil, {BackgroundTransparency = 0})
			task.delay(0.4, Airflow.CreateAnimation, Airflow, track, 0.5, nil, {BackgroundTransparency = 0})
			task.delay(0.4, Airflow.CreateAnimation, Airflow, thumb, 0.5, nil, {BackgroundTransparency = 0})
			task.delay(0.4, Airflow.CreateAnimation, Airflow, titleLbl, 0.5, nil, {TextTransparency = 0})
			if descLbl then task.delay(0.4, Airflow.CreateAnimation, Airflow, descLbl, 0.5, nil, {TextTransparency = 0.35}) end
		end

		local extras = {
			{obj = track, prop = "BackgroundTransparency", val = 0},
			{obj = thumb, prop = "BackgroundTransparency", val = 0},
		}
		if descLbl then table.insert(extras, {obj = descLbl, prop = "TextTransparency", val = 0.35}) end

		OnChange.Event:Connect(function(v)
			visAnim(card, titleLbl, extras, v)
			if not v then updateToggle(false) end
		end)

		ElementId += 1

		local tb = {
			Edit = function(_, v) titleLbl.Text = v end,
			SetValue = function(_, v)
				config.Default = v
				updateToggle(v)
				ElementConfigs["Toggle_"..config.Name.."_"..tostring(ID)] = {Value = v}
				BindableToggle:Fire(v)
				config.Callback(v)
			end,
			Visible = function(_, v) card.Visible = v end,
			AutomaticVisible = function(_, cfg)
				cfg = cfg or {}; cfg.Elements = cfg.Elements or {}
				local cb = function(val)
					for _, el in ipairs(cfg.Elements) do
						el:Visible(val == cfg.Target)
					end
				end
				cb(config.Default)
				return BindableToggle.Event:Connect(cb)
			end,
			Destroy = function(_) card:Destroy() end,
		}
		ElementIDs[ID] = {Name = config.Name, ID = ID, Type = "Toggle", API = tb, IDCode = "Toggle_"..config.Name.."_"..tostring(ID)}
		return tb
	end

	----- AddSlider -----
	function elements:AddSlider(config)
		config = config or {}
		config.Name = config.Name or "Slider"
		config.Callback = config.Callback or function() end
		config.Min = config.Min or 0
		config.Max = config.Max or 100
		config.Round = config.Round or 0
		config.Default = config.Default or config.Min
		config.Type = config.Type or ""
		config.Description = config.Description or nil
		config.ValueTexts = config.ValueTexts or {}

		local ID = ElementId
		local card = makeCard(element, config.Description and 88 or 72)

		-- Title row
		local titleLbl = makeTitle(card, config.Name)
		titleLbl.Position = UDim2.new(0, 14, 0, 14)
		titleLbl.Size = UDim2.new(0.5, 0, 0, 18)

		-- Value badge
		local valueBadge = Instance.new("Frame")
		valueBadge.Name = Airflow:RandomString()
		valueBadge.Parent = card
		valueBadge.AnchorPoint = Vector2.new(1, 0)
		valueBadge.Position = UDim2.new(1, -14, 0, 11)
		valueBadge.Size = UDim2.new(0, 48, 0, 24)
		valueBadge.BackgroundColor3 = THEME.BG_INPUT
		valueBadge.BackgroundTransparency = 1
		valueBadge.BorderSizePixel = 0
		valueBadge.ZIndex = 7
		makeCorner(valueBadge, UDim.new(0, 6))
		makeStroke(valueBadge, THEME.ACCENT_DIM, 0.3)

		local valueLbl = Instance.new("TextLabel")
		valueLbl.Parent = valueBadge
		valueLbl.AnchorPoint = Vector2.new(0.5, 0.5)
		valueLbl.Position = UDim2.new(0.5, 0, 0.5, 0)
		valueLbl.Size = UDim2.new(1, -6, 1, 0)
		valueLbl.BackgroundTransparency = 1
		valueLbl.Font = Enum.Font.GothamBold
		valueLbl.Text = tostring(config.Default)..tostring(config.Type)
		valueLbl.TextColor3 = THEME.ACCENT2
		valueLbl.TextSize = 13
		valueLbl.ZIndex = 8
		valueLbl.TextTransparency = 1

		-- Description
		local descLbl
		local trackY = config.Description and 58 or 44
		if config.Description then
			descLbl = makeDesc(card, config.Description)
			descLbl.Position = UDim2.new(0, 14, 0, 36)
			descLbl.Size = UDim2.new(1, -28, 0, 14)
		end

		-- Track
		local trackBG = Instance.new("Frame")
		trackBG.Name = Airflow:RandomString()
		trackBG.Parent = card
		trackBG.Position = UDim2.new(0, 14, 0, trackY)
		trackBG.Size = UDim2.new(1, -28, 0, 6)
		trackBG.BackgroundColor3 = THEME.SLIDER_TRACK
		trackBG.BackgroundTransparency = 1
		trackBG.BorderSizePixel = 0
		trackBG.ZIndex = 7
		makeCorner(trackBG, UDim.new(1, 0))

		local fill = Instance.new("Frame")
		fill.Name = Airflow:RandomString()
		fill.Parent = trackBG
		fill.BackgroundColor3 = THEME.ACCENT
		fill.BackgroundTransparency = 1
		fill.BorderSizePixel = 0
		fill.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
		fill.ZIndex = 8
		makeCorner(fill, UDim.new(1, 0))

		-- Thumb
		local thumbDot = Instance.new("Frame")
		thumbDot.Parent = fill
		thumbDot.AnchorPoint = Vector2.new(1, 0.5)
		thumbDot.Position = UDim2.new(1, 4, 0.5, 0)
		thumbDot.Size = UDim2.new(0, 14, 0, 14)
		thumbDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		thumbDot.BackgroundTransparency = 1
		thumbDot.BorderSizePixel = 0
		thumbDot.ZIndex = 9
		makeCorner(thumbDot, UDim.new(1, 0))
		makeStroke(thumbDot, THEME.ACCENT, 0.1, 2)

		ElementConfigs["Slider_"..config.Name.."_"..tostring(ID)] = {Value = config.Default}

		if OnChange:GetAttribute('Value') then
			task.delay(0.4, function()
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(valueBadge, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(valueLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(trackBG, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(fill, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(thumbDot, 0.5, nil, {BackgroundTransparency = 0})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.5, nil, {TextTransparency = 0.35}) end
			end)
		end

		local IsHold = false
		local function update(Input)
			local SX = math.clamp((Input.Position.X - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X, 0, 1)
			local Main = (config.Max - config.Min) * SX + config.Min
			local Value = Airflow:Rounding(Main, config.Round)
			local norm = (Value - config.Min) / (config.Max - config.Min)
			TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(norm, 0, 1, 0)}):Play()
			config.Default = Value
			valueLbl.Text = (config.ValueTexts[Value] and config.ValueTexts[Value]) or tostring(Value)..tostring(config.Type)
			ElementConfigs["Slider_"..config.Name.."_"..tostring(ID)] = {Value = Value}
			config.Callback(Value)
		end

		trackBG.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				IsHold = true; update(inp)
			end
		end)
		trackBG.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				IsHold = false
			end
		end)
		UserInputService.InputChanged:Connect(function(inp)
			if IsHold and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
				update(inp)
			end
		end)

		OnChange.Event:Connect(function(v)
			if v then
				task.wait(delayTick)
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(valueBadge, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(valueLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(trackBG, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(fill, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(thumbDot, 0.5, nil, {BackgroundTransparency = 0})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.5, nil, {TextTransparency = 0.35}) end
			else
				Airflow:CreateAnimation(card, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(titleLbl, 0.4, nil, {TextTransparency = 1})
				Airflow:CreateAnimation(valueBadge, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(valueLbl, 0.4, nil, {TextTransparency = 1})
				Airflow:CreateAnimation(trackBG, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(fill, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(thumbDot, 0.4, nil, {BackgroundTransparency = 1})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.4, nil, {TextTransparency = 1}) end
			end
		end)

		ElementId += 1

		local tb = {
			Edit = function(_, v) titleLbl.Text = v end,
			SetValue = function(_, v)
				config.Default = v
				fill.Size = UDim2.new((v - config.Min)/(config.Max - config.Min), 0, 1, 0)
				valueLbl.Text = (config.ValueTexts[v] and config.ValueTexts[v]) or tostring(v)..tostring(config.Type)
				ElementConfigs["Slider_"..config.Name.."_"..tostring(ID)] = {Value = v}
				config.Callback(v)
			end,
			Visible = function(_, v) card.Visible = v end,
			Destroy = function(_) card:Destroy() end,
		}
		ElementIDs[ID] = {Name = config.Name, ID = ID, Type = "Slider", API = tb, IDCode = "Slider_"..config.Name.."_"..tostring(ID)}
		return tb
	end

	----- AddKeybind -----
	function elements:AddKeybind(config)
		config = config or {}
		config.Name = config.Name or "Keybind"
		config.Callback = config.Callback or function() end
		config.Default = config.Default or "None"
		config.Description = config.Description or nil

		local Keys = {
			One='1',Two='2',Three='3',Four='4',Five='5',Six='6',Seven='7',Eight='8',Nine='9',Zero='0',
			['Minus']="-",['Plus']="+",BackSlash="\\",Slash="/",Period='.',Semicolon=';',Colon=":",
			LeftControl="LCtrl",RightControl="RCtrl",LeftShift="LShift",RightShift="RShift",
			Return="Enter",LeftBracket="[",RightBracket="]",Quote="'",Comma=",",Equals="=",LeftSuper="Win"
		}

		local ID = ElementId
		local GetItem = function(item)
			if item then
				if typeof(item) == 'EnumItem' then return Keys[item.Name] or item.Name
				else return Keys[tostring(item)] or tostring(item) end
			end; return 'NONE'
		end

		local cardH = config.Description and 72 or 52
		local card = makeCard(element, cardH)

		local titleLbl = makeTitle(card, config.Name)
		titleLbl.AnchorPoint = config.Description and Vector2.new(0,0) or Vector2.new(0,0.5)
		titleLbl.Position = config.Description and UDim2.new(0,14,0,14) or UDim2.new(0,14,0.5,0)
		titleLbl.Size = UDim2.new(1,-100,0,18)

		local descLbl
		if config.Description then
			descLbl = makeDesc(card, config.Description)
			descLbl.Position = UDim2.new(0,14,0,36)
			descLbl.Size = UDim2.new(1,-100,0,16)
		end

		-- Keybind badge
		local badge = Instance.new("Frame")
		badge.Parent = card
		badge.AnchorPoint = Vector2.new(1, 0.5)
		badge.Position = UDim2.new(1, -14, 0.5, 0)
		badge.Size = UDim2.new(0, 60, 0, 26)
		badge.BackgroundColor3 = THEME.KEYBIND_BG
		badge.BackgroundTransparency = 1
		badge.BorderSizePixel = 0
		badge.ZIndex = 7
		makeCorner(badge, UDim.new(0, 6))
		makeStroke(badge, THEME.BORDER2, 0.3)

		local badgeText = Instance.new("TextLabel")
		badgeText.Parent = badge
		badgeText.AnchorPoint = Vector2.new(0.5, 0.5)
		badgeText.Position = UDim2.new(0.5, 0, 0.5, 0)
		badgeText.Size = UDim2.new(1, -8, 1, 0)
		badgeText.BackgroundTransparency = 1
		badgeText.Font = Enum.Font.GothamMedium
		badgeText.Text = GetItem(config.Default)
		badgeText.TextColor3 = THEME.TEXT_PRIMARY
		badgeText.TextSize = 12
		badgeText.ZIndex = 8
		badgeText.TextTransparency = 1

		local UpdateScale = function()
			local s = TextService:GetTextSize(badgeText.Text, badgeText.TextSize, badgeText.Font, Vector2.new(math.huge, math.huge))
			TweenService:Create(badge, TweenInfo.new(0.1), {Size = UDim2.new(0, s.X + 20, 0, 26)}):Play()
		end
		UpdateScale()

		card.MouseEnter:Connect(function()
			if card.BackgroundTransparency < 0.5 then Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD2}) end
		end)
		card.MouseLeave:Connect(function()
			if card.BackgroundTransparency < 0.5 then Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD}) end
		end)

		local IsBinding = false
		Airflow:NewInput(badge, function()
			if IsBinding then return end
			IsBinding = true
			badgeText.Text = "..."
			UpdateScale()
			local Selected
			while not Selected do
				local Key = UserInputService.InputBegan:Wait()
				if Key.KeyCode ~= Enum.KeyCode.Unknown then Selected = Key.KeyCode
				elseif Key.UserInputType == Enum.UserInputType.MouseButton1 then Selected = "MouseLeft"
				elseif Key.UserInputType == Enum.UserInputType.MouseButton2 then Selected = "MouseRight" end
			end
			config.Default = Selected
			badgeText.Text = GetItem(Selected)
			UpdateScale()
			IsBinding = false
			ElementConfigs["Keybind_"..config.Name.."_"..tostring(ID)] = {Value = (typeof(Selected)=="string" and Selected or Selected.Name)}
			config.Callback(typeof(Selected)=="string" and Selected or Selected.Name)
		end)

		ElementConfigs["Keybind_"..config.Name.."_"..tostring(ID)] = {Value = (typeof(config.Default)=="string" and config.Default or config.Default.Name)}

		if OnChange:GetAttribute('Value') then
			task.delay(0.4, function()
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(badge, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(badgeText, 0.5, nil, {TextTransparency = 0})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.5, nil, {TextTransparency = 0.35}) end
			end)
		end

		OnChange.Event:Connect(function(v)
			if v then
				task.wait(delayTick)
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(badge, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(badgeText, 0.5, nil, {TextTransparency = 0})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.5, nil, {TextTransparency = 0.35}) end
			else
				Airflow:CreateAnimation(card, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(titleLbl, 0.4, nil, {TextTransparency = 1})
				Airflow:CreateAnimation(badge, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(badgeText, 0.4, nil, {TextTransparency = 1})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.4, nil, {TextTransparency = 1}) end
			end
		end)

		ElementId += 1

		local tb = {
			Edit = function(_, v) titleLbl.Text = v end,
			SetValue = function(_, v)
				config.Default = v
				badgeText.Text = GetItem(v); UpdateScale()
				local k = (typeof(v)=="string" and v or v.Name)
				ElementConfigs["Keybind_"..config.Name.."_"..tostring(ID)] = {Value = k}
				config.Callback(k)
			end,
			Visible = function(_, v) card.Visible = v end,
			Destroy = function(_) card:Destroy() end,
		}
		ElementIDs[ID] = {Name = config.Name, ID = ID, Type = "Keybind", API = tb, IDCode = "Keybind_"..config.Name.."_"..tostring(ID)}
		return tb
	end

	----- AddTextbox -----
	function elements:AddTextbox(config)
		config = config or {}
		config.Name = config.Name or "TextBox"
		config.Default = config.Default or ""
		config.Placeholder = config.Placeholder or "Type here..."
		config.Numeric = config.Numeric or false
		config.Finished = config.Finished or false
		config.Callback = config.Callback or function() end

		local ID = ElementId
		local card = makeCard(element, 68)

		local titleLbl = makeTitle(card, config.Name)
		titleLbl.Position = UDim2.new(0, 14, 0, 10)
		titleLbl.Size = UDim2.new(1, -28, 0, 18)

		-- Input box
		local inputBG = Instance.new("Frame")
		inputBG.Name = Airflow:RandomString()
		inputBG.Parent = card
		inputBG.Position = UDim2.new(0, 14, 0, 33)
		inputBG.Size = UDim2.new(1, -28, 0, 26)
		inputBG.BackgroundColor3 = THEME.BG_INPUT
		inputBG.BackgroundTransparency = 1
		inputBG.BorderSizePixel = 0
		inputBG.ZIndex = 7
		inputBG.ClipsDescendants = true
		makeCorner(inputBG, UDim.new(0, 6))
		makeStroke(inputBG, THEME.BORDER, 0.3)

		local tb_box = Instance.new("TextBox")
		tb_box.Parent = inputBG
		tb_box.Position = UDim2.new(0, 10, 0.5, 0)
		tb_box.AnchorPoint = Vector2.new(0, 0.5)
		tb_box.Size = UDim2.new(1, -20, 1, -4)
		tb_box.BackgroundTransparency = 1
		tb_box.BorderSizePixel = 0
		tb_box.ClearTextOnFocus = false
		tb_box.Font = Enum.Font.Gotham
		tb_box.PlaceholderText = config.Placeholder
		tb_box.PlaceholderColor3 = THEME.TEXT_DIM
		tb_box.Text = config.Default
		tb_box.TextColor3 = THEME.TEXT_PRIMARY
		tb_box.TextSize = 13
		tb_box.ZIndex = 8
		tb_box.TextTransparency = 1
		tb_box.TextXAlignment = Enum.TextXAlignment.Left

		inputBG.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				local stroke = inputBG:FindFirstChildOfClass("UIStroke")
				if stroke then Airflow:CreateAnimation(stroke, 0.2, nil, {Transparency = 0, Color = THEME.ACCENT_DIM}) end
			end
		end)
		inputBG.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				local stroke = inputBG:FindFirstChildOfClass("UIStroke")
				if stroke then Airflow:CreateAnimation(stroke, 0.3, nil, {Transparency = 0.3, Color = THEME.BORDER}) end
			end
		end)

		ElementConfigs["TextBox_"..config.Name.."_"..tostring(ID)] = {Value = config.Default}

		local parse = function(text)
			if not text then return "" end
			if config.Numeric then
				local out = string.gsub(tostring(text),'[^0-9.]','')
				return tonumber(out) and tonumber(out) or nil
			end
			return text
		end

		if config.Finished then
			tb_box.FocusLost:Connect(function()
				local value = parse(tb_box.Text)
				if value then
					tb_box.Text = tostring(value)
					config.Callback(value)
				end
				ElementConfigs["TextBox_"..config.Name.."_"..tostring(ID)] = {Value = value}
			end)
		else
			tb_box:GetPropertyChangedSignal('Text'):Connect(function()
				local value = parse(tb_box.Text)
				if value then
					if config.Numeric then tb_box.Text = tostring(value) end
					config.Callback(value)
					ElementConfigs["TextBox_"..config.Name.."_"..tostring(ID)] = {Value = value}
				end
			end)
		end

		if OnChange:GetAttribute('Value') then
			task.delay(0.4, function()
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(inputBG, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(tb_box, 0.5, nil, {TextTransparency = 0})
			end)
		end

		OnChange.Event:Connect(function(v)
			if v then
				task.wait(delayTick)
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(inputBG, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(tb_box, 0.5, nil, {TextTransparency = 0})
			else
				Airflow:CreateAnimation(card, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(titleLbl, 0.4, nil, {TextTransparency = 1})
				Airflow:CreateAnimation(inputBG, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(tb_box, 0.4, nil, {TextTransparency = 1})
			end
		end)

		ElementId += 1

		local tb = {
			Edit = function(_, v) titleLbl.Text = v end,
			SetValue = function(_, v)
				tb_box.Text = tostring(parse(v) or v)
				ElementConfigs["TextBox_"..config.Name.."_"..tostring(ID)] = {Value = parse(v)}
				config.Callback(v)
			end,
			Visible = function(_, v) card.Visible = v end,
			Destroy = function(_) card:Destroy() end,
		}
		ElementIDs[ID] = {Name = config.Name, ID = ID, Type = "TextBox", API = tb, IDCode = "TextBox_"..config.Name.."_"..tostring(ID)}
		return tb
	end

	----- AddColorPicker -----
	function elements:AddColorPicker(config)
		config = config or {}
		config.Name = config.Name or "ColorPicker"
		config.Default = config.Default or Color3.fromRGB(255,255,255)
		config.Callback = config.Callback or function() end
		config.Description = config.Description or nil

		local ID = ElementId
		local cardH = config.Description and 72 or 52
		local card = makeCard(element, cardH)

		local titleLbl = makeTitle(card, config.Name)
		titleLbl.AnchorPoint = config.Description and Vector2.new(0,0) or Vector2.new(0,0.5)
		titleLbl.Position = config.Description and UDim2.new(0,14,0,14) or UDim2.new(0,14,0.5,0)
		titleLbl.Size = UDim2.new(1,-80,0,18)

		local descLbl
		if config.Description then
			descLbl = makeDesc(card, config.Description)
			descLbl.Position = UDim2.new(0,14,0,36)
			descLbl.Size = UDim2.new(1,-80,0,16)
		end

		-- Color swatch
		local swatch = Instance.new("Frame")
		swatch.Name = Airflow:RandomString()
		swatch.Parent = card
		swatch.AnchorPoint = Vector2.new(1, 0.5)
		swatch.Position = UDim2.new(1, -14, 0.5, 0)
		swatch.Size = UDim2.new(0, 52, 0, 24)
		swatch.BackgroundColor3 = config.Default
		swatch.BackgroundTransparency = 1
		swatch.BorderSizePixel = 0
		swatch.ZIndex = 7
		makeCorner(swatch, UDim.new(0, 6))
		makeStroke(swatch, THEME.BORDER2, 0.3)

		-- Input layer
		local btn = Instance.new("TextButton")
		btn.Parent = card
		btn.BackgroundTransparency = 1
		btn.Size = UDim2.fromScale(1,1)
		btn.ZIndex = 16
		btn.TextTransparency = 1
		btn.Text = ""

		card.MouseEnter:Connect(function()
			if card.BackgroundTransparency < 0.5 then Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD2}) end
		end)
		card.MouseLeave:Connect(function()
			if card.BackgroundTransparency < 0.5 then Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD}) end
		end)

		local R,G,B = config.Default.R*255, config.Default.G*255, config.Default.B*255
		ElementConfigs["ColorPicker_"..config.Name.."_"..tostring(ID)] = {Value = {R,G,B}}

		local Detector = function(color)
			config.Default = color
			local r,g,b = color.R*255, color.G*255, color.B*255
			Airflow:CreateAnimation(swatch, 0.3, nil, {BackgroundColor3 = color})
			ElementConfigs["ColorPicker_"..config.Name.."_"..tostring(ID)] = {Value = {r,g,b}}
			config.Callback(color)
		end

		btn.MouseButton1Click:Connect(function()
			task.wait()
			Airflow.Features.ColorPickerToggle = not Airflow.Features.ColorPickerToggle
			Airflow.Features:SetColor(config.Default)
			Airflow.Features:OnColorPicker(Airflow.Features.ColorPickerToggle)
			Airflow.Features:SetPosition(UDim2.fromOffset(swatch.AbsolutePosition.X, swatch.AbsolutePosition.Y))
			Airflow.Features.Callback = Detector
		end)

		if OnChange:GetAttribute('Value') then
			task.delay(0.4, function()
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(swatch, 0.5, nil, {BackgroundTransparency = 0})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.5, nil, {TextTransparency = 0.35}) end
			end)
		end

		OnChange.Event:Connect(function(v)
			if v then
				task.wait(delayTick)
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(swatch, 0.5, nil, {BackgroundTransparency = 0, BackgroundColor3 = config.Default})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.5, nil, {TextTransparency = 0.35}) end
			else
				Airflow:CreateAnimation(card, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(titleLbl, 0.4, nil, {TextTransparency = 1})
				Airflow:CreateAnimation(swatch, 0.4, nil, {BackgroundTransparency = 1})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.4, nil, {TextTransparency = 1}) end
			end
		end)

		ElementId += 1

		local tb = {
			Edit = function(_, v) titleLbl.Text = v end,
			SetValue = function(_, v) Detector(v) end,
			Visible = function(_, v) card.Visible = v end,
			Destroy = function(_) card:Destroy() end,
		}
		ElementIDs[ID] = {Name = config.Name, ID = ID, Type = "ColorPicker", API = tb, IDCode = "ColorPicker_"..config.Name.."_"..tostring(ID)}
		return tb
	end

	----- AddParagraph -----
	function elements:AddParagraph(config)
		config = config or {}
		config.Name = config.Name or "Paragraph"
		config.Content = config.Content or ""

		local ID = ElementId
		local card = makeCard(element, 52)
		card.ClipsDescendants = false

		local titleLbl = makeTitle(card, config.Name)
		titleLbl.Position = UDim2.new(0, 14, 0, 10)
		titleLbl.Size = UDim2.new(1, -28, 0, 18)
		titleLbl.TextColor3 = THEME.TEXT_PRIMARY
		titleLbl.TextSize = 13

		local contentLbl = Instance.new("TextLabel")
		contentLbl.Name = Airflow:RandomString()
		contentLbl.Parent = card
		contentLbl.BackgroundTransparency = 1
		contentLbl.BorderSizePixel = 0
		contentLbl.Position = UDim2.new(0, 14, 0, 30)
		contentLbl.Size = UDim2.new(1, -28, 0, 30)
		contentLbl.ZIndex = 7
		contentLbl.Font = Enum.Font.Gotham
		contentLbl.Text = config.Content
		contentLbl.TextColor3 = THEME.TEXT_SEC
		contentLbl.TextSize = 12
		contentLbl.TextXAlignment = Enum.TextXAlignment.Left
		contentLbl.TextYAlignment = Enum.TextYAlignment.Top
		contentLbl.TextWrapped = true
		contentLbl.TextTransparency = 1

		local updateScale = function()
			local s = TextService:GetTextSize(contentLbl.Text, contentLbl.TextSize, contentLbl.Font, Vector2.new(math.huge, math.huge))
			local h = 30 + s.Y + 18
			Airflow:CreateAnimation(card, 0.3, nil, {Size = UDim2.new(1, 0, 0, h)})
			contentLbl.Size = UDim2.new(1, -28, 0, s.Y + 4)
		end

		task.delay(0.2, updateScale)

		if OnChange:GetAttribute('Value') then
			task.delay(0.4, function()
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(contentLbl, 0.5, nil, {TextTransparency = 0.25})
			end)
		end

		OnChange.Event:Connect(function(v)
			if v then
				task.wait(delayTick)
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(contentLbl, 0.5, nil, {TextTransparency = 0.25})
			else
				Airflow:CreateAnimation(card, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(titleLbl, 0.4, nil, {TextTransparency = 1})
				Airflow:CreateAnimation(contentLbl, 0.4, nil, {TextTransparency = 1})
			end
		end)

		ElementId += 1

		local tb = {
			EditName = function(_, v) titleLbl.Text = v; updateScale() end,
			EditContent = function(_, v) contentLbl.Text = v; updateScale() end,
			Visible = function(_, v) card.Visible = v end,
			Destroy = function(_) card:Destroy() end,
		}
		ElementIDs[ID] = {Name = config.Name, ID = ID, Type = "Paragraph", API = tb, IDCode = "Paragraph_"..config.Name.."_"..tostring(ID)}
		return tb
	end

	----- AddDropdown -----
	function elements:AddDropdown(config)
		config = config or {}
		config.Name = config.Name or "Dropdown"
		config.Values = config.Values or {}
		config.Default = config.Default or {}
		config.Multi = config.Multi or false
		config.Callback = config.Callback or function() end
		config.Description = config.Description or nil

		local parse = function(value)
			if not value then return 'NONE' end
			if typeof(value) == 'table' then
				local x = {}
				if #value > 0 then
					for _,v in next, value do table.insert(x, tostring(v)) end
				else
					for i,v in next, value do if v == true then table.insert(x, tostring(i)) end end
				end
				return table.concat(x, ', ')
			end
			return tostring(value)
		end

		local ID = ElementId
		local cardH = config.Description and 72 or 52
		local card = makeCard(element, cardH)

		local titleLbl = makeTitle(card, config.Name)
		titleLbl.AnchorPoint = config.Description and Vector2.new(0,0) or Vector2.new(0,0.5)
		titleLbl.Position = config.Description and UDim2.new(0,14,0,14) or UDim2.new(0,14,0.5,0)
		titleLbl.Size = UDim2.new(0.4,0,0,18)

		local descLbl
		if config.Description then
			descLbl = makeDesc(card, config.Description)
			descLbl.Position = UDim2.new(0,14,0,36)
			descLbl.Size = UDim2.new(0.55,0,0,16)
		end

		-- Dropdown button
		local dropBtn = Instance.new("Frame")
		dropBtn.Name = Airflow:RandomString()
		dropBtn.Parent = card
		dropBtn.AnchorPoint = Vector2.new(1, 0.5)
		dropBtn.Position = UDim2.new(1, -14, 0.5, 0)
		dropBtn.Size = UDim2.new(0, 110, 0, 28)
		dropBtn.BackgroundColor3 = THEME.BG_INPUT
		dropBtn.BackgroundTransparency = 1
		dropBtn.BorderSizePixel = 0
		dropBtn.ZIndex = 7
		makeCorner(dropBtn, UDim.new(0, 6))
		makeStroke(dropBtn, THEME.BORDER2, 0.2)

		local dropText = Instance.new("TextLabel")
		dropText.Parent = dropBtn
		dropText.AnchorPoint = Vector2.new(0, 0.5)
		dropText.Position = UDim2.new(0, 8, 0.5, 0)
		dropText.Size = UDim2.new(1, -30, 0, 18)
		dropText.BackgroundTransparency = 1
		dropText.Font = Enum.Font.Gotham
		dropText.Text = parse(config.Default)
		dropText.TextColor3 = THEME.TEXT_PRIMARY
		dropText.TextSize = 12
		dropText.ZIndex = 8
		dropText.TextXAlignment = Enum.TextXAlignment.Left
		dropText.TextTransparency = 1
		dropText.TextTruncate = Enum.TextTruncate.SplitWord

		local chevron = Instance.new("ImageLabel")
		chevron.Parent = dropBtn
		chevron.AnchorPoint = Vector2.new(1, 0.5)
		chevron.Position = UDim2.new(1, -8, 0.5, 0)
		chevron.Size = UDim2.new(0, 14, 0, 14)
		chevron.BackgroundTransparency = 1
		chevron.Image = Airflow:GetIcon("chevron-down")
		chevron.ImageTransparency = 1
		chevron.ZIndex = 8

		-- Dropdown panel
		local panel = Instance.new("Frame")
		panel.Name = Airflow:RandomString()
		panel.Parent = dropBtn
		panel.AnchorPoint = Vector2.new(0, 0)
		panel.Position = UDim2.new(0, 0, 1, 4)
		panel.Size = UDim2.new(1, 0, 0, 0)
		panel.BackgroundColor3 = THEME.BG_CARD2
		panel.BorderSizePixel = 0
		panel.ZIndex = 200
		panel.ClipsDescendants = true
		panel.Active = true
		makeCorner(panel, UDim.new(0, 6))
		makeStroke(panel, THEME.BORDER2, 0.2)

		local scroll = Instance.new("ScrollingFrame")
		scroll.Parent = panel
		scroll.AnchorPoint = Vector2.new(0.5, 0.5)
		scroll.Position = UDim2.new(0.5, 0, 0.5, 0)
		scroll.Size = UDim2.new(1, -4, 1, -4)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 2
		scroll.ScrollBarImageColor3 = THEME.ACCENT_DIM
		scroll.ZIndex = 201

		local list = Instance.new("UIListLayout")
		list.Parent = scroll
		list.HorizontalAlignment = Enum.HorizontalAlignment.Center
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Padding = UDim.new(0, 2)

		list:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			scroll.CanvasSize = UDim2.fromOffset(0, list.AbsoluteContentSize.Y + 4)
		end)

		ElementConfigs["Dropdown_"..config.Name.."_"..tostring(ID)] = {Value = config.Default}

		local ToggleValue = false

		local function IsDefault(val)
			if typeof(config.Default) == 'table' then
				return table.find(config.Default, val) or config.Default[val]
			end
			return config.Default == val
		end

		local function refresh()
			for _, ch in ipairs(scroll:GetChildren()) do
				if ch:IsA('TextButton') then ch:Destroy() end
			end

			if config.Multi then
				local Selected = {}
				for _,v in next, config.Values do
					local item = Instance.new("TextButton")
					item.Parent = scroll
					item.BackgroundColor3 = THEME.BG_INPUT
					item.BackgroundTransparency = 1
					item.BorderSizePixel = 0
					item.Size = UDim2.new(1, -4, 0, 28)
					item.ZIndex = 202
					item.Font = Enum.Font.Gotham
					item.Text = "  "..tostring(v)
					item.TextColor3 = THEME.TEXT_SEC
					item.TextSize = 13
					item.TextXAlignment = Enum.TextXAlignment.Left
					makeCorner(item, UDim.new(0, 4))

					if IsDefault(v) then
						item.TextColor3 = THEME.TEXT_PRIMARY
						item.BackgroundTransparency = 0.6
						Selected[v] = true
					end

					item.MouseEnter:Connect(function()
						Airflow:CreateAnimation(item, 0.15, nil, {BackgroundTransparency = 0.5})
					end)
					item.MouseLeave:Connect(function()
						Airflow:CreateAnimation(item, 0.15, nil, {BackgroundTransparency = Selected[v] and 0.6 or 1})
					end)

					item.MouseButton1Click:Connect(function()
						Selected[v] = not Selected[v]
						item.TextColor3 = Selected[v] and THEME.TEXT_PRIMARY or THEME.TEXT_SEC
						item.BackgroundTransparency = Selected[v] and 0.6 or 1
						config.Default = Selected
						dropText.Text = parse(Selected)
						ElementConfigs["Dropdown_"..config.Name.."_"..tostring(ID)] = {Value = Selected}
						config.Callback(Selected)
					end)
				end
			else
				local SelectedItem
				for _,v in next, config.Values do
					local item = Instance.new("TextButton")
					item.Parent = scroll
					item.BackgroundColor3 = THEME.BG_INPUT
					item.BackgroundTransparency = 1
					item.BorderSizePixel = 0
					item.Size = UDim2.new(1, -4, 0, 28)
					item.ZIndex = 202
					item.Font = Enum.Font.Gotham
					item.Text = "  "..tostring(v)
					item.TextColor3 = THEME.TEXT_SEC
					item.TextSize = 13
					item.TextXAlignment = Enum.TextXAlignment.Left
					makeCorner(item, UDim.new(0, 4))

					if v == config.Default then
						item.TextColor3 = THEME.TEXT_PRIMARY
						item.BackgroundTransparency = 0.6
						SelectedItem = item
					end

					item.MouseEnter:Connect(function()
						Airflow:CreateAnimation(item, 0.15, nil, {BackgroundTransparency = 0.5})
					end)
					item.MouseLeave:Connect(function()
						local isSel = SelectedItem == item
						Airflow:CreateAnimation(item, 0.15, nil, {BackgroundTransparency = isSel and 0.6 or 1})
					end)

					item.MouseButton1Click:Connect(function()
						if SelectedItem then
							SelectedItem.TextColor3 = THEME.TEXT_SEC
							Airflow:CreateAnimation(SelectedItem, 0.15, nil, {BackgroundTransparency = 1})
						end
						item.TextColor3 = THEME.TEXT_PRIMARY
						item.BackgroundTransparency = 0.6
						SelectedItem = item
						dropText.Text = parse(v)
						config.Default = v
						ElementConfigs["Dropdown_"..config.Name.."_"..tostring(ID)] = {Value = v}
						config.Callback(v)
					end)
				end
			end
		end

		local function Change(value)
			ToggleValue = value
			if value then
				refresh()
				local contentH = math.min(list.AbsoluteContentSize.Y + 12, 150)
				Airflow:CreateAnimation(panel, 0.3, nil, {Size = UDim2.new(1, 0, 0, contentH)})
				Airflow:CreateAnimation(chevron, 0.3, nil, {Rotation = 180})
				local stroke = dropBtn:FindFirstChildOfClass("UIStroke")
				if stroke then Airflow:CreateAnimation(stroke, 0.2, nil, {Transparency = 0, Color = THEME.ACCENT_DIM}) end
			else
				Airflow:CreateAnimation(panel, 0.25, nil, {Size = UDim2.new(1, 0, 0, 0)})
				Airflow:CreateAnimation(chevron, 0.3, nil, {Rotation = 0})
				local stroke = dropBtn:FindFirstChildOfClass("UIStroke")
				if stroke then Airflow:CreateAnimation(stroke, 0.3, nil, {Transparency = 0.2, Color = THEME.BORDER2}) end
			end
		end

		UserInputService.InputBegan:Connect(function(sts)
			if sts.UserInputType == Enum.UserInputType.MouseButton1 then
				if not Airflow:IsMouseOverFrame(card) and not Airflow:IsMouseOverFrame(panel) then
					Change(false)
				end
			end
		end)

		Airflow:NewInput(card, function()
			ToggleValue = not ToggleValue
			Change(ToggleValue)
		end)

		card.MouseEnter:Connect(function()
			if card.BackgroundTransparency < 0.5 then Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD2}) end
		end)
		card.MouseLeave:Connect(function()
			if card.BackgroundTransparency < 0.5 then Airflow:CreateAnimation(card, 0.2, nil, {BackgroundColor3 = THEME.BG_CARD}) end
		end)

		Change(false)

		if OnChange:GetAttribute('Value') then
			task.delay(0.4, function()
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(dropBtn, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(dropText, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(chevron, 0.5, nil, {ImageTransparency = 0.3})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.5, nil, {TextTransparency = 0.35}) end
			end)
		end

		OnChange.Event:Connect(function(v)
			if v then
				task.wait(delayTick)
				Airflow:CreateAnimation(card, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(titleLbl, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(dropBtn, 0.5, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(dropText, 0.5, nil, {TextTransparency = 0})
				Airflow:CreateAnimation(chevron, 0.5, nil, {ImageTransparency = 0.3})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.5, nil, {TextTransparency = 0.35}) end
			else
				Change(false)
				Airflow:CreateAnimation(card, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(titleLbl, 0.4, nil, {TextTransparency = 1})
				Airflow:CreateAnimation(dropBtn, 0.4, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(dropText, 0.4, nil, {TextTransparency = 1})
				Airflow:CreateAnimation(chevron, 0.4, nil, {ImageTransparency = 1})
				if descLbl then Airflow:CreateAnimation(descLbl, 0.4, nil, {TextTransparency = 1}) end
			end
		end)

		ElementId += 1

		local tb = {
			Edit = function(_, v) titleLbl.Text = v end,
			SetValues = function(_, v) config.Values = v end,
			SetDefault = function(_, v)
				config.Default = v
				dropText.Text = parse(v)
				ElementConfigs["Dropdown_"..config.Name.."_"..tostring(ID)] = {Value = v}
				config.Callback(v)
			end,
			Visible = function(_, v) card.Visible = v end,
			Destroy = function(_) card:Destroy() end,
		}
		ElementIDs[ID] = {Name = config.Name, ID = ID, Type = "Dropdown", API = tb, IDCode = "Dropdown_"..config.Name.."_"..tostring(ID)}
		return tb
	end

	----- Utility -----
	function elements:GetElementFromKey(key)
		local _V = string.split(key,'_')
		local ID = _V[#_V]
		return ElementIDs[ID] or ElementIDs[tostring(ID)] or (function()
			for _,v in next, ElementIDs do
				if v.IDCode == key then return v end
			end
		end)()
	end

	function elements:GetConfigs() return ElementConfigs end
	function elements:GetElementFromId(id) return ElementIDs[id] end
	function elements:GetInfo() return ElementIDs end

	return elements
end

-- Main Init --
function Airflow:Init(config)
	config = config or {}
	config.Name = config.Name or "airflow"
	config.Logo = config.Logo or Airflow.Config.Logo
	config.Scale = config.Scale or Airflow.Config.Scale
	config.Hightlight = config.Highlight or config.Hightlight or Airflow.Config.Hightlight
	config.Keybind = config.Keybind or Airflow.Config.Keybind
	config.Resizable = config.Resizable or Airflow.Config.Resizable
	config.UnlockMouse = config.UnlockMouse or Airflow.Config.UnlockMouse
	config.IconSize = config.IconSize or Airflow.Config.IconSize
	config.Version = config.Version or "1.0"

	local Response = {
		TabElements = {};
		OpenedTab = nil;
		Toggle = true;
		Hightlight = config.Hightlight;
		FirstToggle = true;
		UnlockMouse = config.UnlockMouse;
		TabConfig = {};
	}

	local AirflowWindow = Instance.new("ScreenGui")
	AirflowWindow.Name = ".Airflow="..Airflow:RandomString()
	AirflowWindow.Parent = CoreGui
	AirflowWindow.ResetOnSpawn = false
	AirflowWindow.IgnoreGuiInset = true
	AirflowWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global
	protect_gui(AirflowWindow)

	-- Main window frame
	local WindowFrame = Instance.new("Frame")
	WindowFrame.Active = true
	WindowFrame.Name = Airflow:RandomString()
	WindowFrame.Parent = AirflowWindow
	WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowFrame.BackgroundColor3 = THEME.BG_WINDOW
	WindowFrame.BackgroundTransparency = 1
	WindowFrame.BorderSizePixel = 0
	WindowFrame.ClipsDescendants = true
	WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	WindowFrame.Size = UDim2.new(0, config.Scale.X.Offset - 50, 0, config.Scale.Y.Offset - 50)
	makeCorner(WindowFrame, THEME.CORNER_MD)
	makeStroke(WindowFrame, THEME.BORDER, 0.4)

	WindowFrame:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
		WindowFrame.Visible = WindowFrame.BackgroundTransparency < 0.95
	end)

	-- Title bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = Airflow:RandomString()
	TitleBar.Parent = WindowFrame
	TitleBar.BackgroundColor3 = THEME.BG_SIDEBAR
	TitleBar.BackgroundTransparency = 0
	TitleBar.BorderSizePixel = 0
	TitleBar.Size = UDim2.new(1, 0, 0, 46)
	TitleBar.ZIndex = 3

	-- Separator under title bar
	local TitleSep = Instance.new("Frame")
	TitleSep.Parent = TitleBar
	TitleSep.AnchorPoint = Vector2.new(0, 1)
	TitleSep.Position = UDim2.new(0, 0, 1, 0)
	TitleSep.Size = UDim2.new(1, 0, 0, 1)
	TitleSep.BackgroundColor3 = THEME.BORDER
	TitleSep.BackgroundTransparency = 0.5
	TitleSep.BorderSizePixel = 0
	TitleSep.ZIndex = 4

	-- Window dot controls
	local DotsFrame = Instance.new("Frame")
	DotsFrame.Parent = TitleBar
	DotsFrame.Position = UDim2.new(0, 14, 0.5, 0)
	DotsFrame.AnchorPoint = Vector2.new(0, 0.5)
	DotsFrame.Size = UDim2.new(0, 56, 0, 14)
	DotsFrame.BackgroundTransparency = 1
	DotsFrame.ZIndex = 4

	local dotList = Instance.new("UIListLayout")
	dotList.Parent = DotsFrame
	dotList.FillDirection = Enum.FillDirection.Horizontal
	dotList.VerticalAlignment = Enum.VerticalAlignment.Center
	dotList.Padding = UDim.new(0, 6)

	local dotColors = {Color3.fromRGB(255, 90, 80), Color3.fromRGB(255, 190, 40), Color3.fromRGB(40, 200, 70)}
	for _, c in ipairs(dotColors) do
		local dot = Instance.new("Frame")
		dot.Parent = DotsFrame
		dot.Size = UDim2.new(0, 12, 0, 12)
		dot.BackgroundColor3 = c
		dot.BackgroundTransparency = 0
		dot.BorderSizePixel = 0
		makeCorner(dot, UDim.new(1, 0))
	end

	-- Window title
	local TitleText = Instance.new("TextLabel")
	TitleText.Name = Airflow:RandomString()
	TitleText.Parent = TitleBar
	TitleText.AnchorPoint = Vector2.new(0.5, 0.5)
	TitleText.Position = UDim2.new(0.5, 0, 0.5, 0)
	TitleText.Size = UDim2.new(0.4, 0, 0, 20)
	TitleText.BackgroundTransparency = 1
	TitleText.Font = Enum.Font.GothamMedium
	TitleText.Text = "● "..config.Name
	TitleText.TextColor3 = THEME.TEXT_SEC
	TitleText.TextSize = 14
	TitleText.TextTransparency = 1
	TitleText.ZIndex = 4

	-- Body
	local Body = Instance.new("Frame")
	Body.Name = Airflow:RandomString()
	Body.Parent = WindowFrame
	Body.Position = UDim2.new(0, 0, 0, 46)
	Body.Size = UDim2.new(1, 0, 1, -46)
	Body.BackgroundColor3 = THEME.BG_CONTENT
	Body.BackgroundTransparency = 0
	Body.BorderSizePixel = 0
	Body.ZIndex = 2

	-- Sidebar
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = Airflow:RandomString()
	Sidebar.Parent = Body
	Sidebar.Size = UDim2.new(0, 165, 1, 0)
	Sidebar.BackgroundColor3 = THEME.BG_SIDEBAR
	Sidebar.BackgroundTransparency = 0
	Sidebar.BorderSizePixel = 0
	Sidebar.ZIndex = 4

	local SidebarSep = Instance.new("Frame")
	SidebarSep.Parent = Sidebar
	SidebarSep.AnchorPoint = Vector2.new(1, 0)
	SidebarSep.Position = UDim2.new(1, 0, 0, 0)
	SidebarSep.Size = UDim2.new(0, 1, 1, 0)
	SidebarSep.BackgroundColor3 = THEME.BORDER
	SidebarSep.BackgroundTransparency = 0.5
	SidebarSep.BorderSizePixel = 0
	SidebarSep.ZIndex = 5

	-- Sidebar scroll
	local SidebarScroll = Instance.new("ScrollingFrame")
	SidebarScroll.Parent = Sidebar
	SidebarScroll.Active = true
	SidebarScroll.Position = UDim2.new(0, 0, 0, 8)
	SidebarScroll.Size = UDim2.new(1, 0, 1, -8)
	SidebarScroll.BackgroundTransparency = 1
	SidebarScroll.BorderSizePixel = 0
	SidebarScroll.ScrollBarThickness = 0
	SidebarScroll.ZIndex = 5
	SidebarScroll.ClipsDescendants = false

	local SidebarList = Instance.new("UIListLayout")
	SidebarList.Parent = SidebarScroll
	SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
	SidebarList.Padding = UDim.new(0, 2)
	makePadding(SidebarScroll, 8, 4)

	SidebarList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		SidebarScroll.CanvasSize = UDim2.fromOffset(0, SidebarList.AbsoluteContentSize.Y + 10)
	end)

	-- Content area
	local ContentArea = Instance.new("Frame")
	ContentArea.Name = Airflow:RandomString()
	ContentArea.Parent = Body
	ContentArea.Position = UDim2.new(0, 165, 0, 0)
	ContentArea.Size = UDim2.new(1, -165, 1, 0)
	ContentArea.BackgroundTransparency = 1
	ContentArea.BorderSizePixel = 0
	ContentArea.ZIndex = 3

	-- Toggle animation
	local function ToggleWindow(value)
		if value then
			Airflow:CreateAnimation(WindowFrame, 0.4, Enum.EasingStyle.Quint, {
				BackgroundTransparency = 0,
				Size = config.Scale,
			})
			Airflow:CreateAnimation(TitleText, 0.5, nil, {TextTransparency = 0.2})
			if Response.OpenedTab then Response.OpenedTab(true) end
		else
			for _, cv in next, Response.TabElements do cv(false) end
			Airflow:CreateAnimation(WindowFrame, 0.4, Enum.EasingStyle.Quint, {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, config.Scale.X.Offset - 40, 0, config.Scale.Y.Offset - 40),
			})
			Airflow:CreateAnimation(TitleText, 0.3, nil, {TextTransparency = 1})
			if Response.FirstToggle then
				Response.FirstToggle = false
				Airflow:Notify({
					Title = "Keybind",
					Content = "Press "..tostring(typeof(config.Keybind)=="string" and config.Keybind or config.Keybind.Name).." to toggle UI"
				})
			end
		end
	end

	task.delay(0.5, function()
		if Airflow.Features.ColorPickerRoot then
			Airflow.Features.ColorPickerRoot.Parent = AirflowWindow
		end
	end)

	function Response:Update()
		local s = TextService:GetTextSize(TitleText.Text, TitleText.TextSize, TitleText.Font, Vector2.new(math.huge, math.huge))
		TitleText.Size = UDim2.new(0, s.X + 4, 0, 20)
	end

	function Response:GetTabFromKey(key)
		for _,v in next, Response.TabConfig do
			if (v.Name.."_"..tostring(v.ID)) == key then return v end
		end
	end

	function Response:GetConfigs()
		local process = {}
		for _,v in next, Response.TabConfig do
			process[v.Name.."_"..tostring(v.ID)] = v:GetConfigs()
		end
		process.VERSION = config.Version
		return process
	end

	function Response:DrawTab(tabConfig) : Tab
		tabConfig = tabConfig or {}
		tabConfig.Name = tabConfig.Name or "Tab"
		tabConfig.Icon = tabConfig.Icon or "book"

		-- Sidebar button
		local tabBtn = Instance.new("Frame")
		tabBtn.Name = Airflow:RandomString()
		tabBtn.Parent = SidebarScroll
		tabBtn.BackgroundColor3 = THEME.BG_TAB_SEL
		tabBtn.BackgroundTransparency = 1
		tabBtn.BorderSizePixel = 0
		tabBtn.Size = UDim2.new(1, 0, 0, 38)
		tabBtn.ZIndex = 6
		makeCorner(tabBtn, THEME.CORNER_SM)

		local tabIcon = Instance.new("ImageLabel")
		tabIcon.Parent = tabBtn
		tabIcon.AnchorPoint = Vector2.new(0, 0.5)
		tabIcon.Position = UDim2.new(0, 10, 0.5, 0)
		tabIcon.Size = UDim2.new(0, 18, 0, 18)
		tabIcon.BackgroundTransparency = 1
		tabIcon.Image = Airflow:GetIcon(tabConfig.Icon)
		tabIcon.ImageColor3 = THEME.TEXT_DIM
		tabIcon.ZIndex = 7

		local tabText = Instance.new("TextLabel")
		tabText.Parent = tabBtn
		tabText.AnchorPoint = Vector2.new(0, 0.5)
		tabText.Position = UDim2.new(0, 34, 0.5, 0)
		tabText.Size = UDim2.new(1, -50, 0, 18)
		tabText.BackgroundTransparency = 1
		tabText.Font = Enum.Font.GothamMedium
		tabText.Text = tabConfig.Name
		tabText.TextColor3 = THEME.TEXT_DIM
		tabText.TextSize = 13
		tabText.TextXAlignment = Enum.TextXAlignment.Left
		tabText.ZIndex = 7

		local accentBar = Instance.new("Frame")
		accentBar.Parent = tabBtn
		accentBar.AnchorPoint = Vector2.new(0, 0.5)
		accentBar.Position = UDim2.new(0, 0, 0.5, 0)
		accentBar.Size = UDim2.new(0, 3, 0.65, 0)
		accentBar.BackgroundColor3 = config.Hightlight
		accentBar.BackgroundTransparency = 1
		accentBar.BorderSizePixel = 0
		accentBar.ZIndex = 8
		makeCorner(accentBar, UDim.new(1, 0))

		-- Content panel for this tab
		local TabContent = Instance.new("Frame")
		TabContent.Name = Airflow:RandomString()
		TabContent.Parent = ContentArea
		TabContent.AnchorPoint = Vector2.new(0.5, 0.5)
		TabContent.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabContent.Size = UDim2.new(1, -10, 1, -10)
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.ZIndex = 4

		-- Section label (above columns)
		local SectionLabelArea = Instance.new("Frame")
		SectionLabelArea.Name = Airflow:RandomString()
		SectionLabelArea.Parent = TabContent
		SectionLabelArea.BackgroundTransparency = 1
		SectionLabelArea.Position = UDim2.new(0, 0, 0, 0)
		SectionLabelArea.Size = UDim2.new(1, 0, 0, 0)
		SectionLabelArea.ZIndex = 5

		-- Two-column layout
		local LeftCol = Instance.new("ScrollingFrame")
		LeftCol.Name = Airflow:RandomString()
		LeftCol.Parent = TabContent
		LeftCol.Active = true
		LeftCol.AnchorPoint = Vector2.new(0, 0)
		LeftCol.Position = UDim2.new(0, 0, 0, 0)
		LeftCol.Size = UDim2.new(0.5, -4, 1, 0)
		LeftCol.BackgroundTransparency = 1
		LeftCol.BorderSizePixel = 0
		LeftCol.ScrollBarThickness = 2
		LeftCol.ScrollBarImageColor3 = THEME.ACCENT_DIM
		LeftCol.ZIndex = 5
		LeftCol.ClipsDescendants = false

		local LeftList = Instance.new("UIListLayout")
		LeftList.Parent = LeftCol
		LeftList.HorizontalAlignment = Enum.HorizontalAlignment.Center
		LeftList.SortOrder = Enum.SortOrder.LayoutOrder
		LeftList.Padding = UDim.new(0, 6)
		makePadding(LeftCol, 0, 6)

		LeftList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			LeftCol.CanvasSize = UDim2.fromOffset(0, LeftList.AbsoluteContentSize.Y + 10)
		end)

		local RightCol = Instance.new("ScrollingFrame")
		RightCol.Name = Airflow:RandomString()
		RightCol.Parent = TabContent
		RightCol.Active = true
		RightCol.AnchorPoint = Vector2.new(1, 0)
		RightCol.Position = UDim2.new(1, 0, 0, 0)
		RightCol.Size = UDim2.new(0.5, -4, 1, 0)
		RightCol.BackgroundTransparency = 1
		RightCol.BorderSizePixel = 0
		RightCol.ScrollBarThickness = 2
		RightCol.ScrollBarImageColor3 = THEME.ACCENT_DIM
		RightCol.ZIndex = 5
		RightCol.ClipsDescendants = false

		local RightList = Instance.new("UIListLayout")
		RightList.Parent = RightCol
		RightList.HorizontalAlignment = Enum.HorizontalAlignment.Center
		RightList.SortOrder = Enum.SortOrder.LayoutOrder
		RightList.Padding = UDim.new(0, 6)
		makePadding(RightCol, 0, 6)

		RightList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			RightCol.CanvasSize = UDim2.fromOffset(0, RightList.AbsoluteContentSize.Y + 10)
		end)

		TabContent:GetPropertyChangedSignal('Position'):Connect(function()
			TabContent.Visible = TabContent.Position.Y.Scale < 0.6
		end)

		-- Disabled overlay
		local DisabledText = Instance.new("TextLabel")
		DisabledText.Parent = TabContent
		DisabledText.AnchorPoint = Vector2.new(0.5, 0.5)
		DisabledText.Position = UDim2.new(0.5, 0, 0.5, 0)
		DisabledText.Size = UDim2.new(1, 0, 1, 0)
		DisabledText.BackgroundTransparency = 1
		DisabledText.Font = Enum.Font.GothamMedium
		DisabledText.Text = ""
		DisabledText.TextColor3 = THEME.TEXT_DIM
		DisabledText.TextSize = 14
		DisabledText.TextTransparency = 1
		DisabledText.ZIndex = 10

		local Bindable = Instance.new('BindableEvent', tabBtn)
		local LeftElements = Airflow:Elements(LeftCol, Bindable, Response)
		local RightElements = Airflow:Elements(RightCol, Bindable, Response)

		local TabTable = {
			Left = LeftElements,
			Right = RightElements,
			Disabled = false,
			Name = tabConfig.Name,
			Sections = {},
			ID = #Response.TabElements,
		}

		local SectionId = 1

		local ChangeValue = function(value)
			if value then
				Airflow:CreateAnimation(tabBtn, 0.25, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(accentBar, 0.25, nil, {BackgroundTransparency = 0})
				Airflow:CreateAnimation(tabText, 0.25, nil, {TextColor3 = THEME.TEXT_PRIMARY})
				Airflow:CreateAnimation(tabIcon, 0.25, nil, {ImageColor3 = THEME.ACCENT2})
				Airflow:CreateAnimation(TabContent, 0.3, nil, {Position = UDim2.new(0.5, 0, 0.5, 0)})
				if Bindable:GetAttribute('Value') ~= value and not TabTable.Disabled then
					Bindable:Fire(true); Bindable:SetAttribute('Value', value)
				end
				if TabTable.Disabled then
					Airflow:CreateAnimation(DisabledText, 0.4, nil, {TextTransparency = 0.6})
				end
			else
				if Bindable:GetAttribute('Value') ~= value and not TabTable.Disabled then
					Bindable:Fire(false); Bindable:SetAttribute('Value', value)
				end
				Airflow:CreateAnimation(TabContent, 0.3, nil, {Position = UDim2.new(0.5, 0, 0.75, 0)})
				Airflow:CreateAnimation(tabBtn, 0.25, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(accentBar, 0.25, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(tabText, 0.25, nil, {TextColor3 = THEME.TEXT_DIM})
				Airflow:CreateAnimation(tabIcon, 0.25, nil, {ImageColor3 = THEME.TEXT_DIM})
				if TabTable.Disabled then
					Airflow:CreateAnimation(DisabledText, 0.3, nil, {TextTransparency = 1})
				end
			end
		end

		if not Response.TabElements[1] then
			Response.OpenedTab = ChangeValue
			ChangeValue(true)
		else
			ChangeValue(false)
			TabContent.Visible = false
			task.delay(0.5, Bindable.Fire, Bindable, false)
		end

		tabBtn.MouseEnter:Connect(function()
			if Response.OpenedTab ~= ChangeValue then
				Airflow:CreateAnimation(tabBtn, 0.2, nil, {BackgroundTransparency = 0.6})
				Airflow:CreateAnimation(tabText, 0.2, nil, {TextColor3 = THEME.TEXT_SEC})
			end
		end)
		tabBtn.MouseLeave:Connect(function()
			if Response.OpenedTab ~= ChangeValue then
				Airflow:CreateAnimation(tabBtn, 0.2, nil, {BackgroundTransparency = 1})
				Airflow:CreateAnimation(tabText, 0.2, nil, {TextColor3 = THEME.TEXT_DIM})
			end
		end)

		table.insert(Response.TabElements, ChangeValue)

		local btn = Airflow:NewInput(tabBtn, function()
			for _, cv in next, Response.TabElements do
				if cv == ChangeValue then Response.OpenedTab = cv; cv(true)
				else cv(false) end
			end
		end)
		btn.Modal = Response.UnlockMouse

		function TabTable:Disable(value, reason)
			TabTable.Disabled = value
			DisabledText.Text = tostring(reason or "")
		end

		-- Section header label
		local function makeSection(sectionName, col)
			local hdr = Instance.new("Frame")
			hdr.Name = Airflow:RandomString()
			hdr.Parent = col
			hdr.BackgroundTransparency = 1
			hdr.Size = UDim2.new(1, 0, 0, 28)
			hdr.ZIndex = 5

			local hdrLine = Instance.new("Frame")
			hdrLine.Parent = hdr
			hdrLine.AnchorPoint = Vector2.new(0, 0.5)
			hdrLine.Position = UDim2.new(0, 0, 0.75, 0)
			hdrLine.Size = UDim2.new(1, 0, 0, 1)
			hdrLine.BackgroundColor3 = THEME.BORDER
			hdrLine.BackgroundTransparency = 0.5
			hdrLine.BorderSizePixel = 0
			hdrLine.ZIndex = 5

			local hdrText = Instance.new("TextLabel")
			hdrText.Parent = hdr
			hdrText.Position = UDim2.new(0, 2, 0, 6)
			hdrText.Size = UDim2.new(0.8, 0, 0, 16)
			hdrText.BackgroundTransparency = 1
			hdrText.Font = Enum.Font.GothamBold
			hdrText.Text = string.upper(sectionName)
			hdrText.TextColor3 = THEME.SECTION_HDR
			hdrText.TextSize = 10
			hdrText.TextXAlignment = Enum.TextXAlignment.Left
			hdrText.ZIndex = 6
			hdrText.TextTransparency = 1
			hdrText.TextTracking = 2

			Bindable.Event:Connect(function(v)
				if v then
					task.wait(0.1)
					Airflow:CreateAnimation(hdrText, 1.0, nil, {TextTransparency = 0.4})
				else
					Airflow:CreateAnimation(hdrText, 0.4, nil, {TextTransparency = 1})
				end
			end)

			return hdr
		end

		function TabTable:AddSection(sConfig)
			sConfig = sConfig or {}
			sConfig.Name = sConfig.Name or "Section"
			sConfig.Position = sConfig.Position or "left"

			local targetCol = (string.lower(sConfig.Position) == "left") and LeftCol or RightCol
			local targetList = (string.lower(sConfig.Position) == "left") and LeftList or RightList

			makeSection(sConfig.Name, targetCol)

			local SectionFrame = Instance.new("Frame")
			SectionFrame.Name = Airflow:RandomString()
			SectionFrame.Parent = targetCol
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.BorderSizePixel = 0
			SectionFrame.ClipsDescendants = false
			SectionFrame.Size = UDim2.new(1, 0, 0, 8)

			local SecList = Instance.new("UIListLayout")
			SecList.Parent = SectionFrame
			SecList.HorizontalAlignment = Enum.HorizontalAlignment.Center
			SecList.SortOrder = Enum.SortOrder.LayoutOrder
			SecList.Padding = UDim.new(0, 6)

			SecList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Airflow:CreateAnimation(SectionFrame, 0.35, Enum.EasingStyle.Quint, {
					Size = UDim2.new(1, 0, 0, SecList.AbsoluteContentSize.Y + 2)
				})
			end)

			local secID = "Section_"..sConfig.Name.."_"..TabTable.Name.."_"..tostring(#Response.TabElements).."_"..tostring(SectionId)
			local SectionElements = Airflow:Elements(SectionFrame, Bindable, Response)

			SectionId += 1
			table.insert(TabTable.Sections, {Elements = SectionElements, ID = secID})

			return SectionElements
		end

		function TabTable:GetSectionFromKey(idx)
			local codeX = string.split(idx, "_")
			local ID = codeX[#codeX]
			for _,v in next, TabTable.Sections do
				if v.ID == ID or tostring(v.ID) == tostring(ID) or v.ID == idx then return v.Elements end
			end
		end

		function TabTable:GetSectionFromId(idx)
			for _,v in next, TabTable.Sections do
				if v.ID == idx or tostring(v.ID) == tostring(idx) then return v.Elements end
			end
		end

		function TabTable:GetConfigs()
			local sections = {}
			for _,v in next, TabTable.Sections do sections[v.ID] = v.Elements:GetConfigs() end
			return {Left = LeftElements:GetConfigs(), Right = RightElements:GetConfigs(), Sections = sections}
		end

		table.insert(Response.TabConfig, TabTable)
		return TabTable
	end

	-- Drag
	local dragToggle, dragStart, startPos = nil, nil, nil
	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragToggle = true; dragStart = input.Position; startPos = WindowFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
			local delta = input.Position - dragStart
			Airflow:CreateAnimation(WindowFrame, 0.1, nil, {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			})
		end
	end)

	UserInputService.InputBegan:Connect(function(input, IsType)
		if (input.KeyCode.Name == config.Keybind or input.KeyCode == config.Keybind) and not IsType then
			Response.Toggle = not Response.Toggle
			ToggleWindow(Response.Toggle)
		end
	end)

	function Response:SetKeybind(new) config.Keybind = new end

	function Response:SetResizable(value)
		-- Resizable support (stub for compatibility)
	end

	ToggleWindow(true)
	Response:Update()

	return Response
end

-- Notifications --
do
	local Notifier = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notifier.Name = Airflow:RandomString()
	Notifier.Parent = Airflow.ScreenGui
	Notifier.AnchorPoint = Vector2.new(1, 0)
	Notifier.BackgroundTransparency = 1
	Notifier.BorderSizePixel = 0
	Notifier.Position = UDim2.new(1, -10, 0, 10)
	Notifier.Size = UDim2.new(0, 240, 0, 10)

	UIListLayout.Parent = Notifier
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 6)

	function Airflow:Notify(config)
		config = config or {}
		config.Title = config.Title or "Notification"
		config.Content = config.Content or ""
		config.Duration = config.Duration or 5

		local Outer = Instance.new("Frame")
		Outer.Parent = Notifier
		Outer.BackgroundTransparency = 1
		Outer.BorderSizePixel = 0
		Outer.Size = UDim2.new(0, 240, 0, 60)

		local NotifFrame = Instance.new("Frame")
		NotifFrame.Parent = Outer
		NotifFrame.BackgroundColor3 = THEME.BG_CARD
		NotifFrame.BackgroundTransparency = 0.05
		NotifFrame.BorderSizePixel = 0
		NotifFrame.Size = UDim2.new(0, 240, 0, 60)
		NotifFrame.ZIndex = 121
		NotifFrame.Position = UDim2.fromScale(1.5, 0)
		makeCorner(NotifFrame, THEME.CORNER_MD)
		makeStroke(NotifFrame, THEME.BORDER2, 0.3)

		-- Accent left bar
		local AccentBar = Instance.new("Frame")
		AccentBar.Parent = NotifFrame
		AccentBar.Size = UDim2.new(0, 3, 1, 0)
		AccentBar.BackgroundColor3 = THEME.ACCENT
		AccentBar.BorderSizePixel = 0
		AccentBar.ZIndex = 122
		makeCorner(AccentBar, UDim.new(0, 2))

		local TitleLbl = Instance.new("TextLabel")
		TitleLbl.Parent = NotifFrame
		TitleLbl.Position = UDim2.new(0, 14, 0, 9)
		TitleLbl.Size = UDim2.new(1, -18, 0, 16)
		TitleLbl.BackgroundTransparency = 1
		TitleLbl.Font = Enum.Font.GothamBold
		TitleLbl.Text = config.Title
		TitleLbl.TextColor3 = THEME.TEXT_PRIMARY
		TitleLbl.TextSize = 13
		TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
		TitleLbl.TextTransparency = 1
		TitleLbl.ZIndex = 123

		local ContentLbl = Instance.new("TextLabel")
		ContentLbl.Parent = NotifFrame
		ContentLbl.Position = UDim2.new(0, 14, 0, 28)
		ContentLbl.Size = UDim2.new(1, -18, 0, 26)
		ContentLbl.BackgroundTransparency = 1
		ContentLbl.Font = Enum.Font.Gotham
		ContentLbl.Text = config.Content
		ContentLbl.TextColor3 = THEME.TEXT_SEC
		ContentLbl.TextSize = 12
		ContentLbl.TextXAlignment = Enum.TextXAlignment.Left
		ContentLbl.TextYAlignment = Enum.TextYAlignment.Top
		ContentLbl.TextWrapped = true
		ContentLbl.TextTransparency = 1
		ContentLbl.ZIndex = 123

		local function UpdateScale()
			local ts = TextService:GetTextSize(TitleLbl.Text, TitleLbl.TextSize, TitleLbl.Font, Vector2.new(math.huge, math.huge))
			local cs = TextService:GetTextSize(ContentLbl.Text, ContentLbl.TextSize, ContentLbl.Font, Vector2.new(200, math.huge))
			local h = math.max(60, cs.Y + 40)
			Airflow:CreateAnimation(Outer, 0.2, nil, {Size = UDim2.new(0, 240, 0, h)})
			Airflow:CreateAnimation(NotifFrame, 0.2, nil, {Size = UDim2.new(0, 240, 0, h)})
			AccentBar.Size = UDim2.new(0, 3, 1, 0)
		end

		UpdateScale()

		task.delay(0.1, Airflow.CreateAnimation, Airflow, NotifFrame, 0.4, Enum.EasingStyle.Quint, {Position = UDim2.fromScale(0, 0)})
		task.delay(0.2, Airflow.CreateAnimation, Airflow, TitleLbl, 0.4, nil, {TextTransparency = 0})
		task.delay(0.3, Airflow.CreateAnimation, Airflow, ContentLbl, 0.4, nil, {TextTransparency = 0.2})

		local function close()
			Airflow:CreateAnimation(NotifFrame, 0.35, Enum.EasingStyle.Quint, {Position = UDim2.new(1.5, 0, 0, 0)}).Completed:Connect(function()
				Airflow:CreateAnimation(Outer, 0.25, nil, {Size = UDim2.fromScale(0, 0)}).Completed:Connect(function()
					Outer:Destroy()
				end)
			end)
		end

		if typeof(config.Duration) == 'boolean' then
			return {
				Close = close,
				SetText = function(_, t) TitleLbl.Text = t; UpdateScale() end,
				SetContent = function(_, t) ContentLbl.Text = t; UpdateScale() end,
			}
		else
			task.delay(config.Duration, close)
		end
	end
end

-- DrawList (preserved with new theme) --
function Airflow:DrawList(config)
	config = config or {}
	config.Icon = config.Icon or "keyboard"
	config.Name = config.Name or "keybinds"

	local Response = {Toggle = true}

	local AirflowUI = Instance.new("ScreenGui")
	AirflowUI.Name = Airflow:RandomString()
	AirflowUI.Parent = CoreGui
	AirflowUI.ResetOnSpawn = false
	AirflowUI.IgnoreGuiInset = true
	AirflowUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
	protect_gui(AirflowUI)

	local ListFrame = Instance.new("Frame")
	ListFrame.Active = true
	ListFrame.Name = Airflow:RandomString()
	ListFrame.Parent = AirflowUI
	ListFrame.BackgroundColor3 = THEME.BG_CARD
	ListFrame.BackgroundTransparency = 1
	ListFrame.BorderSizePixel = 0
	ListFrame.ClipsDescendants = true
	ListFrame.Position = UDim2.new(0, 100, 0, 100)
	ListFrame.Size = UDim2.new(0, 200, 0, 0)
	ListFrame.ZIndex = 120
	makeCorner(ListFrame, THEME.CORNER_MD)
	makeStroke(ListFrame, THEME.BORDER2, 0.3)

	local Header = Instance.new("Frame")
	Header.Parent = ListFrame
	Header.BackgroundTransparency = 1
	Header.Position = UDim2.new(0, 0, 0, 0)
	Header.Size = UDim2.new(1, 0, 0, 36)
	Header.ZIndex = 122

	local HIcon = Instance.new("ImageLabel")
	HIcon.Parent = Header
	HIcon.AnchorPoint = Vector2.new(0, 0.5)
	HIcon.Position = UDim2.new(0, 10, 0.5, 0)
	HIcon.Size = UDim2.new(0, 16, 0, 16)
	HIcon.BackgroundTransparency = 1
	HIcon.Image = Airflow:GetIcon(config.Icon)
	HIcon.ImageColor3 = THEME.TEXT_SEC
	HIcon.ImageTransparency = 1
	HIcon.ZIndex = 123

	local HText = Instance.new("TextLabel")
	HText.Parent = Header
	HText.AnchorPoint = Vector2.new(0, 0.5)
	HText.Position = UDim2.new(0, 32, 0.5, 0)
	HText.Size = UDim2.new(1, -40, 0, 18)
	HText.BackgroundTransparency = 1
	HText.Font = Enum.Font.GothamMedium
	HText.Text = config.Name
	HText.TextColor3 = THEME.TEXT_PRIMARY
	HText.TextSize = 13
	HText.TextXAlignment = Enum.TextXAlignment.Left
	HText.ZIndex = 123
	HText.TextTransparency = 1

	local HSep = Instance.new("Frame")
	HSep.Parent = ListFrame
	HSep.Position = UDim2.new(0, 0, 0, 36)
	HSep.Size = UDim2.new(1, 0, 0, 1)
	HSep.BackgroundColor3 = THEME.BORDER
	HSep.BackgroundTransparency = 0.5
	HSep.BorderSizePixel = 0
	HSep.ZIndex = 122

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Parent = ListFrame
	ContentFrame.Position = UDim2.new(0, 0, 0, 37)
	ContentFrame.Size = UDim2.new(1, 0, 1, -37)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.BorderSizePixel = 0
	ContentFrame.ZIndex = 122

	local ContentList = Instance.new("UIListLayout")
	ContentList.Parent = ContentFrame
	ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ContentList.SortOrder = Enum.SortOrder.LayoutOrder
	ContentList.Padding = UDim.new(0, 0)

	ContentList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		if Response.Toggle then
			Airflow:CreateAnimation(ListFrame, 0.3, nil, {Size = UDim2.new(0, 200, 0, ContentList.AbsoluteContentSize.Y + 42)})
		end
	end)

	local function ToggleFun(value)
		if value then
			Airflow:CreateAnimation(ListFrame, 0.3, nil, {BackgroundTransparency = 0, Size = UDim2.new(0, 200, 0, ContentList.AbsoluteContentSize.Y + 42)})
			Airflow:CreateAnimation(HIcon, 0.3, nil, {ImageTransparency = 0.3})
			Airflow:CreateAnimation(HText, 0.3, nil, {TextTransparency = 0.2})
		else
			Airflow:CreateAnimation(ListFrame, 0.3, nil, {BackgroundTransparency = 1, Size = UDim2.new(0, 200, 0, 0)})
			Airflow:CreateAnimation(HIcon, 0.3, nil, {ImageTransparency = 1})
			Airflow:CreateAnimation(HText, 0.3, nil, {TextTransparency = 1})
		end
	end

	function Response:AddFrame(cfg)
		cfg = cfg or {}
		cfg.Key = cfg.Key or "key"
		cfg.Value = cfg.Value or "Value"

		local row = Instance.new("Frame")
		row.Parent = ContentFrame
		row.BackgroundTransparency = 1
		row.BorderSizePixel = 0
		row.Size = UDim2.new(1, 0, 0, 28)
		row.ZIndex = 124

		local keyLbl = Instance.new("TextLabel")
		keyLbl.Parent = row
		keyLbl.AnchorPoint = Vector2.new(0, 0.5)
		keyLbl.Position = UDim2.new(0, 12, 0.5, 0)
		keyLbl.Size = UDim2.new(0.55, 0, 1, 0)
		keyLbl.BackgroundTransparency = 1
		keyLbl.Font = Enum.Font.GothamMedium
		keyLbl.Text = cfg.Key
		keyLbl.TextColor3 = THEME.TEXT_PRIMARY
		keyLbl.TextSize = 13
		keyLbl.TextXAlignment = Enum.TextXAlignment.Left
		keyLbl.ZIndex = 125

		local valLbl = Instance.new("TextLabel")
		valLbl.Parent = row
		valLbl.AnchorPoint = Vector2.new(1, 0.5)
		valLbl.Position = UDim2.new(1, -12, 0.5, 0)
		valLbl.Size = UDim2.new(0.5, 0, 1, 0)
		valLbl.BackgroundTransparency = 1
		valLbl.Font = Enum.Font.Gotham
		valLbl.Text = cfg.Value
		valLbl.TextColor3 = THEME.TEXT_SEC
		valLbl.TextSize = 12
		valLbl.TextXAlignment = Enum.TextXAlignment.Right
		valLbl.ZIndex = 125

		return {
			SetKey = function(_, k) cfg.Key = k; keyLbl.Text = k end,
			SetValue = function(_, v) cfg.Value = v; valLbl.Text = v end,
			Visible = function(_, v) row.Visible = v end,
		}
	end

	ToggleFun(true)

	function Response:Visible(value)
		Response.Toggle = value
		ToggleFun(value)
	end

	-- Drag
	local dragToggle, dragStart, startPos = nil, nil, nil
	ListFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragToggle = true; dragStart = input.Position; startPos = ListFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
			local delta = input.Position - dragStart
			Airflow:CreateAnimation(ListFrame, 0.1, nil, {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			})
		end
	end)

	return Response
end

function Airflow:GetCalculatePosition(planePos, planeNormal, rayOrigin, rayDirection)
	local n = planeNormal; local d = rayDirection; local v = rayOrigin - planePos
	local num = (n.x*v.x)+(n.y*v.y)+(n.z*v.z)
	local den = (n.x*d.x)+(n.y*d.y)+(n.z*d.z)
	return rayOrigin + ((-num/den) * rayDirection)
end

function Airflow:LoadAssets() end

return Airflow