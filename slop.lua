-- ============================================
-- MAIN SCRIPT
-- ============================================
print("bro")
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
if typeof(Library) == "table" and typeof(Library.Unload) == "function" then
pcall(function() Library:Unload() end)
end
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
getgenv().Library = Library
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
pcall(function()
local old = game:GetService("CoreGui"):FindFirstChild("AutoKillStatusUI")
if old then old:Destroy() end
end)
local function Notify(title, text, duration)
pcall(function()
game.StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = duration or 3})
end)
end
local function GetFlag(name)
local toggle = Toggles[name]
if toggle then return toggle.Value end
local option = Options[name]
if option then return option.Value end
return nil
end
local Window = Library:CreateWindow({
Title = 'evolution',
Center = true,
AutoShow = true,
TabPadding = 8,
MenuFadeTime = 0.2
})
local Tabs = {
Combat = Window:AddTab('Combat'),
Visuals = Window:AddTab('Visuals'),
Misc = Window:AddTab('Misc'),
['UI Settings'] = Window:AddTab('UI Settings'),
}
local CombatTargetAim = Tabs.Combat:AddLeftGroupbox('Target Aim')
local CombatProtectPlayer = Tabs.Combat:AddLeftGroupbox('Protect Player')
local CombatFOV = Tabs.Combat:AddLeftGroupbox('FOV Circle')
local CombatTargetIndicators = Tabs.Combat:AddLeftTabbox('Target Indicators')
local CombatAutoKill = Tabs.Combat:AddRightGroupbox('Auto Kill')
local CombatKnifeHitbox = Tabs.Combat:AddRightGroupbox('Knife Hitbox Expander')
local CombatAntiAim = Tabs.Combat:AddRightGroupbox('Anti-Aim')
local CombatStrafe = Tabs.Combat:AddRightGroupbox('Target Strafe')
local CombatHitsound = Tabs.Combat:AddRightGroupbox('Hitsounds')
local VisualsESP = Tabs.Visuals:AddLeftGroupbox('ESP')
local VisualsHitChams = Tabs.Visuals:AddLeftGroupbox('Hit Chams')
local VisualsHitEffects = Tabs.Visuals:AddLeftGroupbox('Hit Effects')
local VisualsHitLogs = Tabs.Visuals:AddLeftGroupbox('Hit logs')
local VisualsHitVignette = Tabs.Visuals:AddLeftGroupbox('Hit Vignette')
local VisualsHitIndicators = Tabs.Visuals:AddLeftGroupbox('Damage Numbers')
local VisualsTracers = Tabs.Visuals:AddLeftGroupbox('Forcehit Tracers')
local VisualsWorld = Tabs.Visuals:AddRightGroupbox('World')
local VisualsWeather = Tabs.Visuals:AddRightGroupbox('Weather')
local Visuals3DHitmarker = Tabs.Visuals:AddLeftGroupbox('3D Hitmarker')
local VisualsCrosshair = Tabs.Visuals:AddRightGroupbox('Crosshair')
local VisualsClient = Tabs.Visuals:AddRightGroupbox('Client')
local VisualsGunMaterial = Tabs.Visuals:AddRightGroupbox('Gun Material')
local VisualsAspectRatio = Tabs.Visuals:AddRightGroupbox('Aspect Ratio')
-- ===== ESP UI Controls =====
do
local function GetEspTable()
return getgenv().EspLibrary and getgenv().EspLibrary.Table
end
VisualsESP:AddToggle('EspEnabled', {
Text = 'Enabled',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then t.Enabled = Value end
end
})
VisualsESP:AddToggle('EspShowLocal', {
Text = 'Show Local Player',
Default = false,
Callback = function(Value)
local t = GetEspTable()
if t then t.ShowLocalPlayer = Value end
local lib = EspLibrary or getgenv().EspLibrary
if lib and typeof(lib.AddTarget) == 'function' and typeof(lib.RemoveTarget) == 'function' then
if Value then
lib:AddTarget(game:GetService('Players').LocalPlayer)
else
lib:RemoveTarget(game:GetService('Players').LocalPlayer)
end
end
end
})
VisualsESP:AddSlider('EspDistance', {
Text = 'Max Distance',
Default = 7520,
Min = 100,
Max = 10000,
Rounding = 0,
Callback = function(Value)
local t = GetEspTable()
if t then t.Distance = Value end
end
})
VisualsESP:AddDropdown('EspBoxType', {
Text = 'Boxes',
Default = '2D',
Values = {'Off', '2D', 'Corner'},
Callback = function(Value)
local t = GetEspTable()
if not t then return end
if Value == 'Off' then
t.Boxes.Enabled = false
else
t.Boxes.Enabled = true
t.Boxes.Type = Value
end
end
})
VisualsESP:AddToggle('EspDynamicBoxes', {
Text = 'Dynamic Boxes',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.DynamicBoxes = Value end
end
})
VisualsESP:AddToggle('EspBoxOutline', {
Text = 'Box Outline',
Default = false,
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.Outline.Enabled = Value end
end
}):AddColorPicker('EspBoxOutlineColor', {
Title = 'Outline Color',
Default = Color3.fromRGB(0, 0, 0),
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.Outline.Color = Value end
end
})
VisualsESP:AddLabel('Box Gradient'):AddColorPicker('EspBoxGradientTop', {
Title = 'Gradient Top',
Default = Color3.fromRGB(0, 255, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.Gradients.Top = Value end
end
}):AddColorPicker('EspBoxGradientBot', {
Title = 'Gradient Bot',
Default = Color3.fromRGB(0, 85, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.Gradients.Bot = Value end
end
})
VisualsESP:AddToggle('EspBoxGlow', {
Text = 'Box Glow',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes['Box Glow'].Enabled = Value end
end
}):AddColorPicker('EspBoxGlowTop', {
Title = 'Glow Top',
Default = Color3.fromRGB(0, 255, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes['Box Glow'].Top = Value end
end
}):AddColorPicker('EspBoxGlowBot', {
Title = 'Glow Bot',
Default = Color3.fromRGB(0, 255, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes['Box Glow'].Bot = Value end
end
})
VisualsESP:AddToggle('EspBoxFilled', {
Text = 'Filled Box',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.Filled.Enabled = Value end
end
}):AddColorPicker('EspBoxFillTop', {
Title = 'Fill Top',
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.Filled.Top = Value end
end
}):AddColorPicker('EspBoxFillBot', {
Title = 'Fill Bot',
Default = Color3.fromRGB(0, 255, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.Filled.Bot = Value end
end
})
VisualsESP:AddSlider('EspBoxFillT1', {
Text = 'Fill Transparency Top',
Default = 1,
Min = 0,
Max = 1,
Rounding = 2,
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.Filled.Transparency[1] = Value end
end
})
VisualsESP:AddSlider('EspBoxFillT2', {
Text = 'Fill Transparency Bot',
Default = 0.65,
Min = 0,
Max = 1,
Rounding = 2,
Callback = function(Value)
local t = GetEspTable()
if t then t.Boxes.Filled.Transparency[2] = Value end
end
})
VisualsESP:AddToggle('EspHealthBar', {
Text = 'Health Bar',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then t.Bars['Health Bar'].Enabled = Value end
end
}):AddColorPicker('EspHealthBarTop', {
Title = 'Health Top',
Default = Color3.fromRGB(0, 255, 0),
Callback = function(Value)
local t = GetEspTable()
if t then t.Bars['Health Bar'].Top = Value end
end
}):AddColorPicker('EspHealthBarMid', {
Title = 'Health Mid',
Default = Color3.fromRGB(255, 170, 0),
Callback = function(Value)
local t = GetEspTable()
if t then t.Bars['Health Bar'].Mid = Value end
end
}):AddColorPicker('EspHealthBarBot', {
Title = 'Health Bot',
Default = Color3.fromRGB(255, 0, 0),
Callback = function(Value)
local t = GetEspTable()
if t then t.Bars['Health Bar'].Bot = Value end
end
})
VisualsESP:AddDropdown('EspHealthBarPosition', {
Text = 'Health Bar Position',
Default = 'Left',
Values = {'Left', 'Right', 'Bottom'},
Callback = function(Value)
local t = GetEspTable()
if t then t.Bars['Health Bar'].Position = Value end
end
})
VisualsESP:AddToggle('EspHealthBarText', {
Text = 'Health Number',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then t.Bars['Health Bar'].Text.Enabled = Value end
end
}):AddColorPicker('EspHealthBarTextColor', {
Title = 'Health Number Color',
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Bars['Health Bar'].Text.Color = Value end
end
})
VisualsESP:AddToggle('EspName', {
Text = 'Name',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then t.Texts.Name.Enabled = Value end
end
}):AddColorPicker('EspNameColor', {
Title = 'Name Color',
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Texts.Name.Color = Value end
end
})
VisualsESP:AddToggle('EspDistanceText', {
Text = 'Distance',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then t.Texts.Distance.Enabled = Value end
end
}):AddColorPicker('EspDistanceColor', {
Title = 'Distance Color',
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Texts.Distance.Color = Value end
end
})
VisualsESP:AddToggle('EspWeapon', {
Text = 'Weapon',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then t.Texts.Weapon.Enabled = Value end
end
}):AddColorPicker('EspWeaponColor', {
Title = 'Weapon Color',
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
local t = GetEspTable()
if t then t.Texts.Weapon.Color = Value end
end
})
VisualsESP:AddToggle('EspFlags', {
Text = 'Flags',
Default = true,
Callback = function(Value)
local t = GetEspTable()
if t then
t.Flags.Walking.Enabled = Value
t.Flags.Jumping.Enabled = Value
t.Flags.Swimming.Enabled = Value
end
end
})
end
local MiscMovement = Tabs.Misc:AddLeftGroupbox('Movement')
local MiscCosmeticsTabbox = Tabs.Misc:AddLeftTabbox('Cosmetics')
local MiscSkins = MiscCosmeticsTabbox:AddTab('Skins')
local MiscShootSounds = MiscCosmeticsTabbox:AddTab('Shoot Sounds')
local MiscAnimationPlayer = Tabs.Misc:AddLeftGroupbox('Animation Player')
local MiscAnimatedTools = Tabs.Misc:AddLeftGroupbox('Animated Tools')
local MiscAutoFood = Tabs.Misc:AddRightGroupbox('Food')
local MiscCombat = Tabs.Misc:AddRightGroupbox('Automation')
local MiscOther = Tabs.Misc:AddRightGroupbox('Other')
local MiscUseStand = Tabs.Misc:AddRightGroupbox('Use Stand')
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera
local SelectedShootSounds = {
DoubleBarrel = "Mp40",
Revolver = "Mp40",
SMG = "Mp40",
Shotgun = "Mp40",
Silencer = "Mp40",
TacticalShotgun = "Mp40"
}
getgenv().ShootSoundsEnabled = false
getgenv().ShootSoundsVolume = 0.5
local weaponTypes = {"DoubleBarrel", "Revolver", "SMG", "Shotgun", "Silencer", "TacticalShotgun"}
local ShootSoundCooldowns = {DoubleBarrel = 0.4, SMG = 0.07, Revolver = 0.2, TacticalShotgun = 0.7, Silencer = 0.5, Shotgun = 1.35}
local LastShootSoundTime = {}
local soundOptions = {
"Mp40",
"G36C",
"M249",
"Sniper",
"Fortnite Pump",
"DoubleBarrel"
}
local OriginalSoundIds = {}
local getWeaponTool, changeWeaponSound, applyVolumeToAllSounds, applyAllShootSounds
MiscShootSounds:AddToggle('ShootSoundsUse', {
Text = "Use",
Default = false,
Callback = function(Value)
getgenv().ShootSoundsEnabled = Value
if not Value then
for weapon, originalId in pairs(OriginalSoundIds) do
if originalId then
local tool = getWeaponTool(weapon)
if tool and tool:FindFirstChild("Handle") then
local shootSound = tool.Handle:FindFirstChild("Shoot")
if shootSound and shootSound:IsA("Sound") then
shootSound.SoundId = originalId
end
end
end
end
else
applyAllShootSounds()
end
end
})
MiscShootSounds:AddSlider('ShootSoundsVolume', {
Text = "Volume",
Min = 0,
Max = 100,
Default = 50,
Rounding = 0,
Callback = function(Value)
getgenv().ShootSoundsVolume = Value / 100
if getgenv().ShootSoundsEnabled then
applyVolumeToAllSounds()
end
end
})
for _, weapon in ipairs(weaponTypes) do
MiscShootSounds:AddDropdown('ShootSound_' .. weapon, {
Text = weapon,
Values = soundOptions,
Default = "Mp40",
Callback = function(Value)
-- Map the name to the actual sound ID
local soundMap = {
["Mp40"] = "103807799095792",
["G36C"] = "4759267374",
["M249"] = "120962559430237",
["Sniper"] = "135333708100426",
["Fortnite Pump"] = "106427010095959",
["DoubleBarrel"] = "3855292863"
}
SelectedShootSounds[weapon] = soundMap[Value] or soundMap["Mp40"]
if getgenv().ShootSoundsEnabled then
changeWeaponSound(weapon, SelectedShootSounds[weapon])
end
end
})
end
getWeaponTool = function(weaponName)
local char = LocalPlayer.Character
if not char then return nil end
for _, tool in pairs(char:GetChildren()) do
if tool:IsA("Tool") and tool.Name:find(weaponName) then
return tool
end
end
for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
if tool:IsA("Tool") and tool.Name:find(weaponName) then
return tool
end
end
return nil
end
changeWeaponSound = function(weapon, soundId)
local tool = getWeaponTool(weapon)
if not tool then return end
local handle = tool:FindFirstChild("Handle")
if not handle then return end
local shootSound = handle:FindFirstChild("Shoot")
if not shootSound or not shootSound:IsA("Sound") then return end
if not OriginalSoundIds[weapon] then
OriginalSoundIds[weapon] = shootSound.SoundId
end
-- soundId should already be just the ID number
shootSound.SoundId = "rbxassetid://" .. soundId
shootSound.Volume = getgenv().ShootSoundsVolume
end
applyVolumeToAllSounds = function()
for weapon, _ in pairs(SelectedShootSounds) do
local tool = getWeaponTool(weapon)
if tool and tool:FindFirstChild("Handle") then
local shootSound = tool.Handle:FindFirstChild("Shoot")
if shootSound and shootSound:IsA("Sound") then
shootSound.Volume = getgenv().ShootSoundsVolume
end
end
end
end
applyAllShootSounds = function()
if not getgenv().ShootSoundsEnabled then return end
for weapon, soundId in pairs(SelectedShootSounds) do
changeWeaponSound(weapon, soundId)
end
end
local function onToolEquipped(tool)
if not getgenv().ShootSoundsEnabled then return end
task.wait(0.1)
for weapon, soundId in pairs(SelectedShootSounds) do
if tool.Name:find(weapon) then
changeWeaponSound(weapon, soundId)
break
end
end
end
local function getWeaponTypeFromTool(tool)
if not tool then return nil end
for _, wType in ipairs(weaponTypes) do
if tool.Name:find(wType) then
return wType
end
end
return nil
end
getgenv().getWeaponTypeFromTool = getWeaponTypeFromTool
local function playShootSound(weaponType)
if not getgenv().ShootSoundsEnabled then return end
if not weaponType then return end
local soundId = SelectedShootSounds[weaponType]
if not soundId or soundId == "" then return end
-- soundId should already be just the ID number
local cooldown = ShootSoundCooldowns[weaponType] or 0.15
local currentTime = tick()
if LastShootSoundTime[weaponType] and (currentTime - LastShootSoundTime[weaponType]) < cooldown then return end
LastShootSoundTime[weaponType] = currentTime
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://" .. soundId
sound.Volume = getgenv().ShootSoundsVolume
sound.Parent = workspace
sound:Play()
task.spawn(function()
task.wait(5)
if sound and sound.Parent then
sound:Destroy()
end
end)
end
getgenv().playShootSound = playShootSound
if LocalPlayer.Backpack then
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
if child:IsA("Tool") then
child.Equipped:Connect(function()
onToolEquipped(child)
end)
end
end)
for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
if tool:IsA("Tool") then
tool.Equipped:Connect(function()
onToolEquipped(tool)
end)
end
end
end
LocalPlayer.CharacterAdded:Connect(function()
task.wait(0.5)
applyAllShootSounds()
end)
task.wait(1)
applyAllShootSounds()
local hitsounds = {
["Default"]            = "rbxassetid://6565371338",
["Rust Headshot"]      = "rbxassetid://138750331387064",
["Neverlose"]          = "rbxassetid://110168723447153",
["Bubble"]             = "rbxassetid://6534947588",
["Laser"]              = "rbxassetid://7837461331",
["Steve"]              = "rbxassetid://4965083997",
["Call of Duty"]       = "rbxassetid://5952120301",
["Bat"]                = "rbxassetid://3333907347",
["TF2 Critical"]       = "rbxassetid://296102734",
["Saber"]              = "rbxassetid://8415678813",
["Bameware"]           = "rbxassetid://3124331820",
["Money"]              = "rbxassetid://13956013041",
["Notif"]              = "rbxassetid://6696469190",
["Shutter"]            = "rbxassetid://10066921516",
["RIFK7"]              = "rbxassetid://9102080552",
["LazerBeam"]          = "rbxassetid://130791043",
["WindowsXPError"]     = "rbxassetid://160715357",
["TF2Hitsound"]        = "rbxassetid://3455144981",
["TF2Bat"]             = "rbxassetid://3333907347",
["BowHit"]             = "rbxassetid://1053296915",
["Bow"]                = "rbxassetid://3442683707",
["OSU"]                = "rbxassetid://7147454322",
["OneNN"]              = "rbxassetid://7349055654",
["Rust"]               = "rbxassetid://6565371338",
["TF2Pan"]             = "rbxassetid://3431749479",
["Mario"]              = "rbxassetid://5709456554",
["Bell"]               = "rbxassetid://6534947240",
["Pick"]               = "rbxassetid://1347140027",
["Pop"]                = "rbxassetid://198598793",
["Sans"]               = "rbxassetid://3188795283",
["Fart"]               = "rbxassetid://130833677",
["Big"]                = "rbxassetid://5332005053",
["Vine"]               = "rbxassetid://5332680810",
["Bruh"]               = "rbxassetid://4578740568",
["Skeet"]              = "rbxassetid://5633695679",
["Fatality"]           = "rbxassetid://6534947869",
["Bonk"]               = "rbxassetid://5766898159",
["Minecraft"]          = "rbxassetid://5869422451",
["Gamesense"]          = "rbxassetid://4817809188",
["Bamboo"]             = "rbxassetid://3769434519",
["Crowbar"]            = "rbxassetid://546410481",
["Weeb"]               = "rbxassetid://6442965016",
["Beep"]               = "rbxassetid://8177256015",
["Bambi"]              = "rbxassetid://8437203821",
["Stone"]              = "rbxassetid://3581383408",
["Old Fatality"]       = "rbxassetid://6607142036",
["Click"]              = "rbxassetid://8053704437",
["Ding"]               = "rbxassetid://7149516994",
["Snow"]               = "rbxassetid://6455527632",
["Osu"]                = "rbxassetid://7149255551",
["TF2"]                = "rbxassetid://2868331684",
["Slime"]              = "rbxassetid://6916371803",
["Among Us"]           = "rbxassetid://5700183626",
["One"]                = "rbxassetid://7380502345",
["BulletDeflect"]      = "rbxassetid://1657157666",
["HoodCustoms"]            = "rbxassetid://330595293",
["UwU"]                = "rbxassetid://8679659744",
["Cod"]                = "rbxassetid://160432334",
["Blood SFX"]          = "rbxassetid://8164951181",
["Blood Burst"]        = "rbxassetid://3781479909",
["Blood Hit"]          = "rbxassetid://429400881",
["Fortnite Shield"]          = "rbxassetid://140073271098075",
["Fortnite Knocked"]          = "rbxassetid://115413823879705",
}
local HitsoundConfig = {
Enabled = true,
SelectedSound = "Default",
Volume = 1,
}
local function PlayHitsound()
if not HitsoundConfig.Enabled then return end
local soundId = hitsounds[HitsoundConfig.SelectedSound] or hitsounds["Default"]
local sound = Instance.new("Sound")
sound.SoundId = soundId
sound.Volume = HitsoundConfig.Volume * 2
sound.Parent = SoundService
sound:Play()
task.spawn(function()
task.wait(5) -- Wait 5 seconds max, then clean up
if sound and sound.Parent then
sound:Destroy()
end
end)
end
local SilentAim = {
Enabled = false,
FOV = 100,
HitPart = "HumanoidRootPart",
Prediction = 0.1433,
PredictionEnabled = false,
AutoShoot = false,
AutoShootDelay = 0.1,
WallCheck = false,
Target = nil,
ShowFOV = false,
LastShootTime = 0,
}
local silentAimFOV = Drawing.new("Circle")
silentAimFOV.Visible = false
silentAimFOV.Thickness = 1
silentAimFOV.Color = Color3.fromRGB(255, 255, 255)
silentAimFOV.Filled = false
silentAimFOV.NumSides = 64
silentAimFOV.Radius = 100
silentAimFOV.Transparency = 0.5
local HitsoundSection = CombatHitsound
HitsoundSection:AddToggle('HitsoundEnabled',{Text = "Enable Hitsounds",
Default = true,
Callback = function(Value)
HitsoundConfig.Enabled = (Toggles.HitsoundEnabled and Toggles.HitsoundEnabled.Value)
end})
local hitsoundItems = {}
for soundName, _ in pairs(hitsounds) do
table.insert(hitsoundItems, soundName)
end
table.sort(hitsoundItems)
HitsoundSection:AddDropdown('HitsoundSelect',{Text = "Hitsound Sound",
Values = hitsoundItems,
Default = "Default",
Callback = function(Value)
HitsoundConfig.SelectedSound = (Options.HitsoundSelect and Options.HitsoundSelect.Value)
end})
HitsoundSection:AddSlider('HitsoundVolume',{Text = "Hitsound Volume",
Min = 0,
Max = 10,
Default = 5,
Rounding = 0,
Callback = function(Value)
HitsoundConfig.Volume = (Options.HitsoundVolume.Value or 5) / 5
end})
CombatHitsound:AddButton({
Text = "Test Sound",
Func = function()
local soundId = hitsounds[HitsoundConfig.SelectedSound] or hitsounds["Default"]
local sound = Instance.new("Sound")
sound.SoundId = soundId
sound.Volume = HitsoundConfig.Volume
sound.Parent = game:GetService("SoundService")
sound:Play()
task.spawn(function()
task.wait(sound.TimeLength + 0.5)
if sound then sound:Destroy() end
end)
end
})
do
local desync_setback = Instance.new("Part")
desync_setback.Name = "Desync Setback"
desync_setback.Parent = workspace
desync_setback.Size = Vector3.new(2, 2, 1)
desync_setback.CanCollide = false
desync_setback.Anchored = true
desync_setback.Transparency = 1
local desync = {
enabled = false,
mode = "Void",
teleportPosition = Vector3.new(0, 0, 0),
old_position = nil,
voidSpamActive = false,
toggleEnabled = false
}
local Offsetposx = 10
local OffsetposY = 10
local Offsetposz = 10
local function resetCamera()
if LocalPlayer.Character then
local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
workspace.CurrentCamera.CameraSubject = humanoid
end
end
end
local function toggleDesync(state)
desync.enabled = state
if desync.enabled then
workspace.CurrentCamera.CameraSubject = desync_setback
Notify("Notification", desync.mode .. "' Enabled", 2)
else
resetCamera()
Notify("Notification", desync.mode .. "' Disabled", 2)
end
end
local function setDesyncMode(mode)
desync.mode = mode
end
local DesyncSection = CombatAntiAim
DesyncSection:AddToggle('DesyncToggle',{Text = "desynchronization",
Default = false,
Callback = function(Value)
desync.toggleEnabled = (Toggles.DesyncToggle and Toggles.DesyncToggle.Value)
if not desync.toggleEnabled then
toggleDesync(false)
end
end}):AddKeyPicker('DesyncKeybind',{Text = "desynchronization",
Default = 'V',
Callback = function(Value)
if not desync.toggleEnabled or UserInputService:GetFocusedTextBox() then return end
toggleDesync(not desync.enabled)
end,
Mode = 'Toggle'})
DesyncSection:AddDropdown('DesyncMethodDropdown',{Text = "Method",
Values = {"Destroy Cheaters", "Rotation", "Custom", "Underground", "Void Spam", "Raining", "Teleport Maze", "Void", "UnderGroundV2", "Anti Connection v1"},
Default = "Void",
Callback = function(Value)
setDesyncMode(Options.DesyncMethodDropdown.Value)
end})
DesyncSection:AddSlider('Offsetx',{Text = "Custom Pos X",
Min = -30,
Max = 30,
Default = 10,
Rounding = 1,
Callback = function(Value)
Offsetposx = (Options.Offsetx and Options.Offsetx.Value)
end})
DesyncSection:AddSlider('OffsetY',{Text = "Custom Pos Y",
Min = -30,
Max = 30,
Default = 10,
Rounding = 1,
Callback = function(Value)
OffsetposY = (Options.OffsetY and Options.OffsetY.Value)
end})
DesyncSection:AddSlider('OffsetZ',{Text = "Custom Pos Z",
Min = -30,
Max = 30,
Default = 10,
Rounding = 1,
Callback = function(Value)
Offsetposz = (Options.OffsetZ and Options.OffsetZ.Value)
end})
RunService.Heartbeat:Connect(function()
if desync.enabled and LocalPlayer.Character then
local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
desync.old_position = rootPart.CFrame
if desync.mode == "Destroy Cheaters" then
desync.teleportPosition = Vector3.new(11223344556677889900, 1, 1)
elseif desync.mode == "Underground" then
desync.teleportPosition = rootPart.Position - Vector3.new(0, 9, 0)
elseif desync.mode == "UnderGroundV2" then
desync.teleportPosition = rootPart.Position - Vector3.new(0, 11, 0)
elseif desync.mode == "Custom" then
desync.teleportPosition = rootPart.Position - Vector3.new(Offsetposx, OffsetposY, Offsetposz)
elseif desync.mode == "Void Spam" then
desync.teleportPosition = math.random(1, 2) == 1 and desync.old_position.Position or Vector3.new(
math.random(10000, 50000),
math.random(10000, 50000),
math.random(10000, 50000)
)
elseif desync.mode == "Void" then
desync.teleportPosition = Vector3.new(
rootPart.Position.X + math.random(-444444, 444444),
rootPart.Position.Y + math.random(-444444, 444444),
rootPart.Position.Z + math.random(-44444, 44444)
)
elseif desync.mode == "Anti Connection v1" then
desync.teleportPosition = Vector3.new(
rootPart.Position.X + math.random(-444444, 444444),
rootPart.Position.Y + math.random(-444444, 444444),
rootPart.Position.Z + math.random(-44444, 44444)
)
elseif desync.mode == "Raining" then
desync.teleportPosition = Vector3.new(
rootPart.Position.X + math.random(-10, 10),
rootPart.Position.Y + math.random(2, 5),
rootPart.Position.Z + math.random(-10, 10)
)
elseif desync.mode == "Teleport Maze" then
desync.teleportPosition = Vector3.new(
math.random(-100, 100),
math.random(5, 50),
math.random(-100, 100)
)
end
local visualizer = workspace:FindFirstChild("DesyncVisualizer")
if not visualizer then
visualizer = Instance.new("Part")
visualizer.Name = "DesyncVisualizer"
visualizer.Size = Vector3.new(1, 1, 1)
visualizer.Anchored = true
visualizer.CanCollide = false
visualizer.BrickColor = BrickColor.new("Bright blue")
visualizer.Parent = workspace
end
visualizer.Position = desync.teleportPosition
visualizer.Transparency = 1
if desync.mode ~= "Rotation" then
rootPart.CFrame = CFrame.new(desync.teleportPosition)
workspace.CurrentCamera.CameraSubject = desync_setback
RunService.RenderStepped:Wait()
desync_setback.CFrame = desync.old_position * CFrame.new(0, rootPart.Size.Y / 2 + 0.5, 0)
rootPart.CFrame = desync.old_position
end
end
end
end)
end
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local workspace = game:GetService("Workspace")
local Targeting = {
Target = nil,
Highlight = nil,
LockedOn = false,
HighlightEnabled = true,
DotEnabled = false,
TracerEnabled = true,
TracerStartPosition = "Mouse",
HighlightColor = Color3.fromRGB(27, 206, 203),
DotColor = Color3.fromRGB(27, 206, 203),
TracerColor = Color3.fromRGB(27, 206, 203),
TargetAimbotPart = "HumanoidRootPart",
AimbotMethod = "Index",
TracerThickness = 2,
TracerOutlineThickness = 4,
WaitingForRespawn = false,
PredictionEnabled = false,
Prediction = 0.1433,
JumpOffset = 0.5,
AntiGroundShot = false,
SpectateTarget = false,
LookAtTarget = false,
}

local AC = loadstring(game:HttpGet("https://raw.githubusercontent.com/dsfvxcvb/evolution/refs/heads/main/ACTracker.lua"))()

local AutoKill = {
Enabled = false,
Target = nil,
Method = "Knife",
AttachPosition = "Behind",
LockedOn = false,
CycleActive = false,
KnifeExpander = {
Enabled = true,
Size = 20,
Fill = true,
FillColor = Color3.fromRGB(255, 0, 0),
FillTransparency = 0.5,
Outline = true,
OutlineColor = Color3.fromRGB(255, 0, 0),
OutlineTransparency = 0.5,
},
KnifeAura = false,
AuraLockedTarget = nil,
KnifeLoopConnection = nil,
LastKnifeStab = 0,
GunMethod = {
PlatformColor = Color3.fromRGB(255, 0, 255),
PlatformMaterial = Enum.Material.Neon,
VoidPosition = Vector3.new(99999, 500, 99999),
PlatformPart = nil,
IsHiding = false,
IsWaiting = false,
IsKilling = false,
LastTeleportTime = 0,
TeleportCooldown = 0.1,
StompRunning = false,
StompTarget = nil,
StompReturn = nil,
},
Targets = {},
CurrentTargetIndex = 1,
UI = nil,
ForceHitWasEnabled = false,
ForceHitOriginal = nil,
}
local ProtectPlayer = {
Enabled = false,
Method = "Gun",
SelectedName = nil,
StompShooter = false,
SpectateShooter = false,
Active = false,
Shooter = nil,
LastHealth = nil,
BulletConnection = nil,
LoopConnection = nil,
BulletHistory = {},
LastGlobalShooter = nil,
LastGlobalShotTime = 0,
RayThreshold = 10,
BulletWindow = 1.5,
GlobalShotWindow = 0.3,
AttackCooldown = 0.25,
LastAttackTime = 0,
MaxShooterDistance = 200,
StartCFrame = nil,
StompRunning = false,
}
local UnreliableMainEvent = ReplicatedStorage:WaitForChild("UnreliableMainEvent")
function ProtectPlayer.GetSelectedPlayer()
local name = ProtectPlayer.SelectedName
if not name then return nil end
for _, p in ipairs(Players:GetPlayers()) do
if p.Name == name then return p end
end
return nil
end
function ProtectPlayer.IsValidTarget(player)
if not player or player == LocalPlayer then return false end
local char = player.Character
if not char then return false end
local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")
return root ~= nil and hum ~= nil and hum.Health > 0
end
function ProtectPlayer.GetTargetStatus(player)
if not player or not player.Character then return "nochar" end
local hum = player.Character:FindFirstChildOfClass("Humanoid")
if not hum then return "nochar" end
if hum.Health <= 0 then return "dead" end
local be = player.Character:FindFirstChild("BodyEffects")
if be then
local dead = be:FindFirstChild("Dead")
if dead and dead.Value == true then return "dead" end
local ko = be:FindFirstChild("K.O")
if ko and ko.Value == true then return "downed" end
end
return "alive"
end
function ProtectPlayer.HasGunEquipped(player)
local char = player.Character
if not char then return false end
for _, child in ipairs(char:GetChildren()) do
if child:IsA("Tool") then
local name = child.Name
if name == "[DoubleBarrel]" or name == "[Revolver]" or name == "[SMG]" or name == "[Shotgun]"
or name == "[Silencer]" or name == "[TacticalShotgun]" or name == "[Flintlock]"
or name == "[RPG]" or name == "[Glock]" or name == "[Uzi]" or name == "[Ak47]" then
return true
end
end
end
return false
end
function ProtectPlayer.GetNearestEnemyAround(pos, ignorePlayer)
local closestGun, minDistGun = nil, math.huge
local closestAny, minDistAny = nil, math.huge
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p ~= ignorePlayer and ProtectPlayer.IsValidTarget(p) then
local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if root then
local d = (root.Position - pos).Magnitude
if d < minDistAny then
minDistAny = d
closestAny = p
end
if ProtectPlayer.HasGunEquipped(p) and d < minDistGun then
minDistGun = d
closestGun = p
end
end
end
end
return closestGun or closestAny
end
function ProtectPlayer.IsAimingAt(enemy, selected, maxAngle)
local eChar = enemy.Character
local sChar = selected.Character
if not eChar or not sChar then return false end
local eRoot = eChar:FindFirstChild("HumanoidRootPart")
local sRoot = sChar:FindFirstChild("HumanoidRootPart")
if not eRoot or not sRoot then return false end
local dir = (sRoot.Position - eRoot.Position).Unit
local look = eRoot.CFrame.LookVector
local dot = dir:Dot(look)
local angle = math.deg(math.acos(math.clamp(dot, -1, 1)))
return angle <= maxAngle
end
function ProtectPlayer.GetLikelyShooter(selected, pos)
local now = tick()
local maxDist = ProtectPlayer.MaxShooterDistance
-- 1) A bullet ray recently passed close to the protected player.
for i = #ProtectPlayer.BulletHistory, 1, -1 do
local entry = ProtectPlayer.BulletHistory[i]
if now - entry.Time > ProtectPlayer.BulletWindow then
table.remove(ProtectPlayer.BulletHistory, i)
elseif entry.Shooter ~= selected and ProtectPlayer.IsValidTarget(entry.Shooter) then
return entry.Shooter
end
end
-- 2) Someone with a gun out who is currently facing the protected player,
--    but only if they're actually nearby. Don't lock onto a random player
--    across the map just because they looked in the right direction.
local aimed = {}
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p ~= selected and ProtectPlayer.IsValidTarget(p)
and ProtectPlayer.HasGunEquipped(p) and ProtectPlayer.IsAimingAt(p, selected, 35) then
local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if root and (root.Position - pos).Magnitude <= maxDist then
table.insert(aimed, {Player = p, Dist = (root.Position - pos).Magnitude})
end
end
end
table.sort(aimed, function(a, b) return a.Dist < b.Dist end)
if aimed[1] then return aimed[1].Player end
-- No evidence = no target. Prevents randomly chasing far-away players.
return nil
end
function ProtectPlayer.TryEquip(toolName)
local char = LocalPlayer.Character
if not char then return false end
local tool = char:FindFirstChild(toolName)
if tool then return true end
local backpack = LocalPlayer:FindFirstChild("Backpack")
if not backpack then return false end
tool = backpack:FindFirstChild(toolName)
if tool then
tool.Parent = char
return true
end
return false
end
function ProtectPlayer.GetAmmo()
local char = LocalPlayer.Character
if not char then return 0 end
local tool = char:FindFirstChild("[DoubleBarrel]")
if not tool then return 0 end
local scriptObj = tool:FindFirstChild("Script")
if not scriptObj then return 0 end
local ammo = scriptObj:FindFirstChild("Ammo")
local maxAmmo = scriptObj:FindFirstChild("MaxAmmo")
if ammo and maxAmmo and ammo:IsA("IntValue") and maxAmmo:IsA("IntValue") then
return ammo.Value
end
return 0
end
function ProtectPlayer.ReloadDoubleBarrel()
local char = LocalPlayer.Character
if not char then return end
local tool = char:FindFirstChild("[DoubleBarrel]")
if not tool then return end
local mainEvent = getgenv().MainEvent or ReplicatedStorage:FindFirstChild("MainEvent")
if mainEvent then
pcall(function() mainEvent:FireServer("Reload", tool) end)
end
end
function ProtectPlayer.Stomp()
local mainEvent = getgenv().MainEvent or ReplicatedStorage:FindFirstChild("MainEvent")
if mainEvent then
pcall(function() mainEvent:FireServer("Stomp") end)
end
end
function ProtectPlayer.TeleportTo(targetPlayer, offset)
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
if not root or not targetRoot then return end
local cf = targetRoot.CFrame
if offset then
cf = cf * offset
end
root.CFrame = cf
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end
function ProtectPlayer.GunAttack(target)
if not ProtectPlayer.TryEquip("[DoubleBarrel]") then return end
local ammo = ProtectPlayer.GetAmmo()
if ammo <= 0 then
ProtectPlayer.ReloadDoubleBarrel()
return
end
ProtectPlayer.TeleportTo(target, CFrame.new(0, 0, 2))
-- Wait one physics step so the teleport actually replicates before firing.
-- Firing immediately after setting CFrame causes the shot to register from
-- the old position and trips the anti-cheat.
RunService.Heartbeat:Wait()
if getgenv().FH_Fire then
local useForcehit = GetFlag("UseForcehit")
local wasEnabled = getgenv().ForceHit and getgenv().ForceHit.Enabled
if getgenv().ForceHit then
getgenv().ForceHit.Enabled = true
end
pcall(function() getgenv().FH_Fire(target) end)
if getgenv().ForceHit and wasEnabled ~= nil then
-- If the user wants ForceHit on, don't let this temporary override turn it back off.
getgenv().ForceHit.Enabled = useForcehit or wasEnabled
end
else
local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("[DoubleBarrel]")
if tool then
pcall(function() tool:Activate() end)
end
end
ProtectPlayer.LastAttackTime = tick()
end
function ProtectPlayer.KnifeAttack(target)
if not ProtectPlayer.TryEquip("[Knife]") then return end
ProtectPlayer.TeleportTo(target, CFrame.new(0, 0, 1))
RunService.Heartbeat:Wait()
local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("[Knife]")
if tool then
local scriptObj = tool:FindFirstChild("Script")
if scriptObj then
local can1 = scriptObj:FindFirstChild("CanHitPlayer")
local can2 = scriptObj:FindFirstChild("CanHitPlayer2")
if can1 then pcall(function() can1.Value = target.Character end) end
if can2 then pcall(function() can2.Value = target.Character end) end
end
pcall(function() tool:Activate() end)
end
ProtectPlayer.LastAttackTime = tick()
end
function ProtectPlayer.Attack(target)
if ProtectPlayer.Method == "Gun" then
ProtectPlayer.GunAttack(target)
else
ProtectPlayer.KnifeAttack(target)
end
end
function ProtectPlayer.ReturnToStart()
local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if ProtectPlayer.StartCFrame and myRoot and hum then
myRoot.CFrame = ProtectPlayer.StartCFrame
myRoot.AssemblyLinearVelocity = Vector3.zero
myRoot.AssemblyAngularVelocity = Vector3.zero
hum.Sit = false
hum.PlatformStand = false
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
ProtectPlayer.StartCFrame = nil
end
end
function ProtectPlayer.SetSpectate(target)
if not ProtectPlayer.SpectateShooter then return end
if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
Camera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end
end
function ProtectPlayer.StartAutoStomp(target)
local state = getgenv().AutoStompState
if not state or state.running or ProtectPlayer.StompRunning then return end
ProtectPlayer.StompRunning = true
local originalTarget = Targeting.Target
Targeting.Target = target
state.autostomp = true
getgenv().AutoStompLoop()
task.spawn(function()
while state.running do
local stillDowned = false
if target and target.Character then
local b = target.Character:FindFirstChild("BodyEffects")
local ko = b and b:FindFirstChild("K.O")
local dead = b and b:FindFirstChild("Dead")
if ko and ko.Value and (not dead or not dead.Value) then
stillDowned = true
end
end
if not ProtectPlayer.Enabled or not ProtectPlayer.StompRunning or not stillDowned then
state.autostomp = false
end
task.wait(0.05)
end
Targeting.Target = originalTarget
ProtectPlayer.StompRunning = false
end)
end
function ProtectPlayer.StopAutoStomp()
local state = getgenv().AutoStompState
if state then state.autostomp = false end
ProtectPlayer.StompRunning = false
end
function ProtectPlayer.Start()
if ProtectPlayer.LoopConnection then return end
ProtectPlayer.LoopConnection = RunService.Heartbeat:Connect(function()
if not ProtectPlayer.Enabled then return end
local selected = ProtectPlayer.GetSelectedPlayer()
if not selected then return end
-- If shooter is dead/gone, clear and return.
if ProtectPlayer.Shooter and not ProtectPlayer.IsValidTarget(ProtectPlayer.Shooter) then
local status = ProtectPlayer.GetTargetStatus(ProtectPlayer.Shooter)
if status == "dead" or status == "nochar" then
ProtectPlayer.SetSpectate(nil)
ProtectPlayer.StopAutoStomp()
ProtectPlayer.ReturnToStart()
ProtectPlayer.Shooter = nil
ProtectPlayer.Active = false
end
end
-- Determine shooter from health drop if we don't have one.
if not ProtectPlayer.Shooter or not ProtectPlayer.IsValidTarget(ProtectPlayer.Shooter) then
if selected.Character then
local root = selected.Character:FindFirstChild("HumanoidRootPart")
local hum = selected.Character:FindFirstChildOfClass("Humanoid")
if root and hum then
local health = hum.Health
if ProtectPlayer.LastHealth and health < ProtectPlayer.LastHealth then
ProtectPlayer.Shooter = ProtectPlayer.GetLikelyShooter(selected, root.Position)
end
ProtectPlayer.LastHealth = health
end
end
end
-- Engage shooter.
local shooterStatus = ProtectPlayer.Shooter and ProtectPlayer.GetTargetStatus(ProtectPlayer.Shooter) or "nochar"
if shooterStatus ~= "nochar" then
-- Save where we were when protection started so we can return there later.
if not ProtectPlayer.StartCFrame then
local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if myRoot then
ProtectPlayer.StartCFrame = myRoot.CFrame
end
end
if shooterStatus == "alive" then
ProtectPlayer.Active = true
ProtectPlayer.SetSpectate(ProtectPlayer.Shooter)
if tick() - ProtectPlayer.LastAttackTime >= ProtectPlayer.AttackCooldown then
ProtectPlayer.Attack(ProtectPlayer.Shooter)
end
elseif shooterStatus == "downed" and ProtectPlayer.StompShooter then
ProtectPlayer.Active = true
ProtectPlayer.SetSpectate(ProtectPlayer.Shooter)
if not ProtectPlayer.StompRunning then
ProtectPlayer.StartAutoStomp(ProtectPlayer.Shooter)
end
else
ProtectPlayer.SetSpectate(nil)
ProtectPlayer.StopAutoStomp()
ProtectPlayer.ReturnToStart()
ProtectPlayer.Shooter = nil
ProtectPlayer.Active = false
end
else
ProtectPlayer.Active = false
if selected.Character then
local hum = selected.Character:FindFirstChildOfClass("Humanoid")
ProtectPlayer.LastHealth = hum and hum.Health or nil
end
end
end)
if UnreliableMainEvent and not ProtectPlayer.BulletConnection then
local function PointSegmentDist(point, startPos, endPos)
local segment = endPos - startPos
local t = math.clamp((point - startPos):Dot(segment) / math.max(segment:Dot(segment), 1e-6), 0, 1)
return (startPos + segment * t - point).Magnitude
end
local function ResolveShooter(arg)
if typeof(arg) == "Instance" and arg:IsA("Player") then
return arg
elseif typeof(arg) == "string" then
return Players:FindFirstChild(arg)
elseif typeof(arg) == "table" then
for _, v in pairs(arg) do
local p = ResolveShooter(v)
if p then return p end
end
end
return nil
end
ProtectPlayer.BulletConnection = UnreliableMainEvent.OnClientEvent:Connect(function(...)
if not ProtectPlayer.Enabled then return end
local args = {...}
if args[1] ~= "ReplicateBulletRay" then return end
-- Payload order: {"ReplicateBulletRay", {startPos, endPos}, shooter, gunName, bool}
local positions = args[2]
local shooter = ResolveShooter(args[3])
if typeof(positions) ~= "table" or not shooter then return end
if shooter == LocalPlayer then return end
local startPos = positions[1]
local endPos = positions[2]
if typeof(startPos) ~= "Vector3" or typeof(endPos) ~= "Vector3" then return end
-- Always remember the last player to fire a bullet (for fallback).
ProtectPlayer.LastGlobalShooter = shooter
ProtectPlayer.LastGlobalShotTime = tick()
local selected = ProtectPlayer.GetSelectedPlayer()
if not selected or not selected.Character then return end
-- Check if the bullet ray passed close to any part of the selected player.
local closestDist = math.huge
for _, part in ipairs(selected.Character:GetDescendants()) do
if part:IsA("BasePart") then
local d = PointSegmentDist(part.Position, startPos, endPos)
local radius = math.max(part.Size.X, part.Size.Y, part.Size.Z) / 2
if d - radius < closestDist then
closestDist = d - radius
end
end
end
if closestDist < ProtectPlayer.RayThreshold then
ProtectPlayer.Shooter = shooter
table.insert(ProtectPlayer.BulletHistory, {Shooter = shooter, Time = tick()})
if #ProtectPlayer.BulletHistory > 20 then
table.remove(ProtectPlayer.BulletHistory, 1)
end
end
end)
end
end
function ProtectPlayer.Stop()
if ProtectPlayer.LoopConnection then
ProtectPlayer.LoopConnection:Disconnect()
ProtectPlayer.LoopConnection = nil
end
if ProtectPlayer.BulletConnection then
ProtectPlayer.BulletConnection:Disconnect()
ProtectPlayer.BulletConnection = nil
end
ProtectPlayer.Shooter = nil
ProtectPlayer.Active = false
ProtectPlayer.LastHealth = nil
ProtectPlayer.BulletHistory = {}
ProtectPlayer.LastGlobalShooter = nil
ProtectPlayer.LastGlobalShotTime = 0
ProtectPlayer.SetSpectate(nil)
ProtectPlayer.StopAutoStomp()
ProtectPlayer.ReturnToStart()
end
function AutoKill.CreateUI()
if AutoKill.UI then return AutoKill.UI end
local gui = Instance.new("ScreenGui")
gui.Name = "AutoKillStatusUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui
local label = Instance.new("TextLabel")
label.AnchorPoint = Vector2.new(0.5, 0.5)
label.Position = UDim2.new(0.5, 0, 0.48, 0)
label.Size = UDim2.new(0, 400, 0, 26)
label.BackgroundTransparency = 1
label.TextTransparency = 0
label.RichText = true
label.Font = Enum.Font.Code
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
label.Text = ""
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.new(0, 0, 0)
stroke.Thickness = 1
stroke.Transparency = 0.4
stroke.Parent = label
label.Parent = gui
AutoKill.UI = {gui = gui, text = label}
return AutoKill.UI
end
function AutoKill.UpdateUI(status, targetName)
local ui = AutoKill.CreateUI()
if not ui or not ui.text then return end
local name = targetName or ""
if status == "waiting" then
ui.text.Text = '<font color="#4DA3FF">[evolution]</font> <font color="#FFFFFF">waiting for target..</font><font color="#FF6B6B"> (hiding)</font>'
elseif status == "killing" then
ui.text.Text = string.format('<font color="#4DA3FF">[evolution]</font> <font color="#FF4A4A">autokilling</font> <font color="#FFFFFF">"%s"</font>', name)
elseif status == "stomping" then
ui.text.Text = string.format('<font color="#4DA3FF">[evolution]</font> <font color="#FFA500">stomping</font> <font color="#FFFFFF">"%s"</font>', name)
elseif status == "hiding" then
ui.text.Text = '<font color="#4DA3FF">[evolution]</font> <font color="#9966FF">hiding</font> <font color="#FFFFFF">(avoiding danger)</font>'
elseif status == "hiding_stomp" then
ui.text.Text = string.format('<font color="#4DA3FF">[evolution]</font> <font color="#9966FF">hiding</font> <font color="#FFFFFF">after stomping</font> <font color="#FFA500">"%s"</font>', name)
elseif status == "hiding_kill" then
ui.text.Text = string.format('<font color="#4DA3FF">[evolution]</font> <font color="#9966FF">hiding</font> <font color="#FFFFFF">(forcefield detected on</font> <font color="#FF4A4A">"%s"</font><font color="#FFFFFF">)</font>', name)
else
ui.text.Text = ""
end
end
function AutoKill.SetTargetList(list)
AutoKill.Targets = list or {}
AutoKill.CurrentTargetIndex = 1
AutoKill.Target = AutoKill.GetNextValidTarget()
end
function AutoKill.GetNextValidTarget()
local list = AutoKill.Targets
local n = #list
if n == 0 then return nil end
local startIndex = AutoKill.CurrentTargetIndex
if startIndex < 1 or startIndex > n then startIndex = 1 end
for offset = 0, n - 1 do
local idx = ((startIndex - 1 + offset) % n) + 1
local name = list[idx]
for _, p in ipairs(Players:GetPlayers()) do
if p.Name == name and AutoKill.IsValidTarget(p) then
AutoKill.CurrentTargetIndex = (idx % n) + 1
return p
end
end
end
return nil
end
function AutoKill.AdvanceTarget()
if AutoKill.Method == "Knife" and AutoKill.KnifeAura and not AutoKill.HasSelectedTargets() then
AutoKill.Target = AutoKill.GetClosestTarget()
else
AutoKill.Target = AutoKill.GetNextValidTarget()
end
return AutoKill.Target
end
function AutoKill.HasSelectedTargets()
return #AutoKill.Targets > 0
end
function AutoKill.GetAttachOffset()
local posMode = AutoKill.AttachPosition
if posMode == "Random" then
local angle = math.random() * 2 * math.pi
local dist = 4 + math.random() * 3
local height = -1.5 + math.random() * 3
return CFrame.new(math.cos(angle) * dist, height, math.sin(angle) * dist), true
elseif posMode == "Inside" then
return CFrame.new(0, 0, 0), false
elseif posMode == "Left" then
return CFrame.new(-4, 0, 0), true
elseif posMode == "Right" then
return CFrame.new(4, 0, 0), true
elseif posMode == "Below" then
return CFrame.new(0, -6, 0), true
else
return CFrame.new(0, 0, 4), true
end
end
function AutoKill.KnifeAuraStep()
local char = LocalPlayer.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then return end
AutoKill.UnhideCharacter()
AutoKill.RemoveVoidPlatform()
local owner = AutoKill.StandConfig and AutoKill.StandConfig.OwnerPlayer
local function isBadTarget(p)
return not p or p == LocalPlayer or p == owner or AutoKill.IsStandPlayer(p) or AutoKill.IsWhitelisted(p)
end
-- Respect manual target list first, then lock nearest by distance
local target = AutoKill.Target
if target and (isBadTarget(target) or not AutoKill.IsValidTarget(target) or AutoKill.GetTargetStatus(target) ~= "alive") then
target = nil
end
if not target and AutoKill.HasSelectedTargets() then
for _ = 1, #AutoKill.Targets do
target = AutoKill.GetNextValidTarget()
if target and not isBadTarget(target) then break end
target = nil
end
end
if not target then
target = AutoKill.AuraLockedTarget
if target and (isBadTarget(target) or not AutoKill.IsValidTarget(target) or AutoKill.GetTargetStatus(target) ~= "alive") then
target = nil
AutoKill.AuraLockedTarget = nil
end
end
if not target and not AutoKill.HasSelectedTargets() then
target = AutoKill.GetNearestEnemyToOwner()
AutoKill.AuraLockedTarget = target
end
if not target then
AutoKill.Target = nil
AutoKill.UpdateUI("waiting")
return
end
local targetChar = target.Character
if not targetChar then return end
AutoKill.Target = target
AutoKill.UpdateUI("killing", target.DisplayName or target.Name)
-- Make sure knife is out
local knifeTool = char:FindFirstChild("[Knife]")
if not knifeTool then
AutoKill.TryEquipKnife()
knifeTool = char:FindFirstChild("[Knife]")
end
if not knifeTool then return end
-- Aim the knife script at the locked target (working knife expects the Character model)
local scriptObj = knifeTool:FindFirstChild("Script")
if scriptObj then
local can1 = scriptObj:FindFirstChild("CanHitPlayer")
local can2 = scriptObj:FindFirstChild("CanHitPlayer2")
if can1 then pcall(function() can1.Value = targetChar end) end
if can2 then pcall(function() can2.Value = targetChar end) end
end
AutoKill.TryStab()
end
function AutoKill.KillAuraStep()
local char = LocalPlayer.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then return end
local owner = AutoKill.StandConfig and AutoKill.StandConfig.OwnerPlayer
local target = AutoKill.GetNearestEnemyToOwner()
if not target then
AutoKill.Target = nil
AutoKill.UpdateUI("waiting")
return
end
AutoKill.Target = target
local targetName = target.DisplayName or target.Name
AutoKill.UpdateUI("killing", targetName)
local status = AutoKill.GetTargetStatus(target)
if status == "dead" then
return
end
if status == "downed" then
if not AutoKill.GunMethod.StompRunning then
AutoKill.AutoStomp(target)
end
return
end
if not AutoKill.FastEquipDoubleBarrel() then
return
end
local ammo = AutoKill.GetDoubleBarrelAmmo()
if ammo <= 0 then
AutoKill.ReloadDoubleBarrel()
return
end
local targetChar = target.Character
if targetChar and AutoKill.HasForceField(targetChar) then
return
end
local cooldown = 0.4
if getgenv().FH_GetWeaponCooldown then
cooldown = getgenv().FH_GetWeaponCooldown()
end
local timeSince = tick() - (getgenv().ForceHit.LastShotTime or 0)
if timeSince < cooldown then
return
end
if targetChar and getgenv().FH_Fire then
pcall(function() getgenv().FH_Fire(target) end)
else
local tool = char:FindFirstChild("[DoubleBarrel]")
if tool then
pcall(function() tool:Activate() end)
end
end
end
function AutoKill.KnifeAttackStep(target)
if AutoKill.KnifeAura then
AutoKill.KnifeAuraStep()
return
end
if not target or not target.Character then return end
local char = LocalPlayer.Character
if not char then return end
AutoKill.UnhideCharacter()
AutoKill.RemoveVoidPlatform()
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return end
local targetChar = target.Character
local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
if not targetRoot then return end
AutoKill.OwnPart(root)
AutoKill.OwnPart(targetRoot)
local knifeTool = char:FindFirstChild("[Knife]")
if not knifeTool then
AutoKill.TryEquipKnife()
knifeTool = char:FindFirstChild("[Knife]")
end
if knifeTool then
local scriptObj = knifeTool:FindFirstChild("Script")
if scriptObj then
local can1 = scriptObj:FindFirstChild("CanHitPlayer")
local can2 = scriptObj:FindFirstChild("CanHitPlayer2")
if can1 then pcall(function() can1.Value = targetChar end) end
if can2 then pcall(function() can2.Value = targetChar end) end
end
end
pcall(function()
    sethiddenproperty(root, "PhysicsRepRootPart", targetRoot)

    -- Use anti-connection resistant position from Script 2's tables
    local rawCF = targetRoot.CFrame
    local userId = target.UserId
    local lastValid = AC.lastValid[userId]
if lastValid then
    local delta = (rawCF.Position - lastValid.Position).Magnitude
    if delta > AC.MAX_DELTA then
        rawCF = lastValid
    else
        AC.lastValid[userId] = rawCF
    end
else
    AC.lastValid[userId] = rawCF
end
local smooth = AC.smoothed[userId]
if smooth then
    local drift = (targetRoot.CFrame.Position - smooth.Position).Magnitude
    if drift > AC.RECONCILE then
        pcall(function() targetRoot.CFrame = rawCF end)
    end
end

    local offset, lookAt = AutoKill.GetAttachOffset()
    if AutoKill.StandConfig and AutoKill.StandConfig.Enabled and AutoKill.StandConfig.FormationMode == "surround" then
        local angle = AutoKill.StandConfig.FormationAngle
        local dist = 5 + (math.sin(angle * 7) + 1) * 2
        local yOff = math.sin(angle * 3) * 1.5
        offset = CFrame.new(math.sin(angle) * dist, yOff, math.cos(angle) * dist)
        lookAt = true
    end

    if not lookAt then
        root.CFrame = rawCF
    else
        local attachCF = rawCF * offset
        root.CFrame = CFrame.lookAt(attachCF.Position, rawCF.Position)
    end
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end)
AutoKill.TryStab()
end
function AutoKill.IsValidPlayer(player)
if not player or player == LocalPlayer then return false end
for _, p in ipairs(Players:GetPlayers()) do
if p == player then return true end
end
return false
end
function AutoKill.IsWhitelisted(player)
if not player then return false end
local list = AutoKill.StandConfig and AutoKill.StandConfig.Whitelist
return list and list[player.Name:lower()] == true
end
function AutoKill.IsValidTarget(player)
if not AutoKill.IsValidPlayer(player) then return false end
if AutoKill.IsWhitelisted(player) then return false end
local char = player.Character
if not char then return false end
local root = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
return root ~= nil and hum ~= nil and hum.Health > 0
end
function AutoKill.GetTargetStatus(player)
if not AutoKill.IsValidPlayer(player) then return "invalid" end
local char = player.Character
if not char then return "nochar" end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return "nochar" end
if hum.Health <= 0 then return "dead" end
local be = char:FindFirstChild("BodyEffects")
if be then
local dead = be:FindFirstChild("Dead")
if dead and dead.Value == true then return "dead" end
local ko = be:FindFirstChild("K.O")
if ko and ko.Value == true then return "downed" end
end
return "alive"
end
function AutoKill.SetStandAttribute()
local char = LocalPlayer.Character
if char then
pcall(function() char:SetAttribute("IsStand", true) end)
end
end
function AutoKill.ForceResetCharacter()
local lp = game:GetService("Players").LocalPlayer
local char = lp.Character
-- Hood Customs / Da Hood style reset remote
local mainEvent = game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent")
if mainEvent then
pcall(function() mainEvent:FireServer("Reset") end)
end
-- Fallbacks
pcall(function() lp:LoadCharacter() end)
if char then
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
pcall(function() hum.Health = 0 end)
end
pcall(function() char:BreakJoints() end)
end
end
function AutoKill.SetupStandCharacter(char)
AutoKill.SetStandAttribute()
-- clear old connections
for _, c in ipairs(AutoKill.StandConfig.KnockResetConnections or {}) do
pcall(function() c:Disconnect() end)
end
AutoKill.StandConfig.KnockResetConnections = {}
local function track(conn)
table.insert(AutoKill.StandConfig.KnockResetConnections, conn)
end
local function onKnocked()
AutoKill.ForceResetCharacter()
end
local humanoid = char:FindFirstChildOfClass("Humanoid")
if humanoid then
track(humanoid.Died:Connect(onKnocked))
end
local function hookKO(ko)
track(ko:GetPropertyChangedSignal("Value"):Connect(function()
if ko.Value == true then
onKnocked()
end
end))
end
local be = char:FindFirstChild("BodyEffects")
local ko = be and be:FindFirstChild("K.O")
if ko then
hookKO(ko)
end
-- if BodyEffects/K.O appears later, hook it
if be then
track(be.ChildAdded:Connect(function(child)
if child.Name == "K.O" and child:IsA("BoolValue") then
hookKO(child)
end
end))
else
track(char.ChildAdded:Connect(function(child)
if child.Name == "BodyEffects" then
local ko2 = child:FindFirstChild("K.O")
if ko2 then hookKO(ko2) end
track(child.ChildAdded:Connect(function(c2)
if c2.Name == "K.O" and c2:IsA("BoolValue") then
hookKO(c2)
end
end))
end
end))
end
end
function AutoKill.IsStandPlayer(player)
if not player then return false end
if player == LocalPlayer then return true end
if player == (AutoKill.StandConfig and AutoKill.StandConfig.OwnerPlayer) then return true end
local names = AutoKill.StandConfig and AutoKill.StandConfig.StandNames
if names and names[player.Name:lower()] then return true end
local char = player.Character
if char and char:GetAttribute("IsStand") == true then return true end
return false
end
function AutoKill.GetNearestEnemyToOwner()
local owner = AutoKill.StandConfig and AutoKill.StandConfig.OwnerPlayer
local originRoot = owner and owner.Character and owner.Character:FindFirstChild("HumanoidRootPart")
if not originRoot then
originRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end
if not originRoot then return nil end
local closest, minDist = nil, math.huge
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player ~= owner and not AutoKill.IsStandPlayer(player) then
if AutoKill.IsValidTarget(player) and AutoKill.GetTargetStatus(player) == "alive" then
local root = player.Character:FindFirstChild("HumanoidRootPart")
if root then
local dist = (root.Position - originRoot.Position).Magnitude
if dist < minDist then
minDist = dist
closest = player
end
end
end
end
end
return closest
end
function AutoKill.HasForceField(char)
return char and char:FindFirstChildOfClass("ForceField") ~= nil
end
-- Knife method helpers
function AutoKill.TryEquipKnife()
local char = LocalPlayer.Character
if not char then return false end
local humanoid = char:FindFirstChildOfClass("Humanoid")
if not humanoid then return false end
local backpack = LocalPlayer:FindFirstChild("Backpack")
if not backpack then return false end
for _, tool in ipairs(backpack:GetChildren()) do
if tool:IsA("Tool") and string.find(string.lower(tool.Name), "knife") then
pcall(function()
humanoid:EquipTool(tool)
end)
return char:FindFirstChild(tool.Name) ~= nil
end
end
return false
end
function AutoKill.TryStab()
local now = tick()
if now - AutoKill.LastKnifeStab < 0.01 then return end
AutoKill.LastKnifeStab = now
local char = LocalPlayer.Character
if not char then return end
local knife = char:FindFirstChild("[Knife]")
if not knife then
AutoKill.TryEquipKnife()
return
end
pcall(function()
knife:Activate()
end)
end
function AutoKill.OwnPart(part)
if part and part:IsA("BasePart") then
pcall(function() part:SetNetworkOwner(LocalPlayer) end)
end
end
-- Knife attach/stab is now handled inside the unified AutoKill combat cycle.
-- Knife hitbox expander + visualizer
RunService.Heartbeat:Connect(function()
local char = LocalPlayer.Character
if not char then return end
local knife = char:FindFirstChild("[Knife]") or LocalPlayer.Backpack:FindFirstChild("[Knife]")
if not knife then return end
local handle = knife:FindFirstChild("Handle")
if not handle then return end
local hitbox = handle:FindFirstChild("HITBOX_PART")
if not hitbox then return end
pcall(function()
if AutoKill.KnifeExpander.Enabled then
local sz = math.max(AutoKill.KnifeExpander.Size, 1)
hitbox.Size = Vector3.new(sz, sz, sz)
hitbox.CanCollide = false
hitbox.Massless = true
hitbox.Color = AutoKill.KnifeExpander.FillColor
if AutoKill.KnifeExpander.Fill then
hitbox.Transparency = math.clamp(AutoKill.KnifeExpander.FillTransparency, 0, 1)
hitbox.Material = Enum.Material.Neon
else
hitbox.Transparency = 1
end
end
local outline = hitbox:FindFirstChild("KnifeHitboxOutline")
if outline and not outline:IsA("SelectionBox") then
outline:Destroy()
outline = nil
end
if AutoKill.KnifeExpander.Enabled and AutoKill.KnifeExpander.Outline then
if not outline then
outline = Instance.new("SelectionBox")
outline.Name = "KnifeHitboxOutline"
outline.Adornee = hitbox
outline.LineThickness = 0.03
outline.SurfaceTransparency = 1
outline.Parent = hitbox
end
outline.Color3 = AutoKill.KnifeExpander.OutlineColor
outline.Transparency = 1 - math.clamp(AutoKill.KnifeExpander.OutlineTransparency, 0, 1)
outline.Visible = true
elseif outline then
outline.Visible = false
end
end)
end)
-- Gun method helpers
function AutoKill.CreateVoidPlatform()
local GM = AutoKill.GunMethod
if GM.PlatformPart and GM.PlatformPart.Parent then return end
local part = Instance.new("Part")
part.Name = "AutoKillVoidPlatform"
part.Size = Vector3.new(100, 5, 100)
part.Position = GM.VoidPosition
part.Anchored = true
part.CanCollide = true
part.Transparency = 0.2
part.Material = GM.PlatformMaterial
part.Color = GM.PlatformColor
part.Parent = workspace
GM.PlatformPart = part
end
function AutoKill.RemoveVoidPlatform()
local GM = AutoKill.GunMethod
if GM.PlatformPart then
GM.PlatformPart:Destroy()
GM.PlatformPart = nil
end
end
function AutoKill.HideCharacter()
local char = LocalPlayer.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return end
AutoKill.CreateVoidPlatform()
local platformPos = AutoKill.GunMethod.VoidPosition + Vector3.new(0, 5, 0)
root.CFrame = CFrame.new(platformPos)
root.Velocity = Vector3.new(0, 0, 0)
root.RotVelocity = Vector3.new(0, 0, 0)
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") then
if part:GetAttribute("AutoKill_OriginalLTM") == nil then
part:SetAttribute("AutoKill_OriginalLTM", part.LocalTransparencyModifier)
end
part.LocalTransparencyModifier = 1
end
end
AutoKill.GunMethod.IsHiding = true
end
function AutoKill.KeepHidden()
local char = LocalPlayer.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return end
local platformPos = AutoKill.GunMethod.VoidPosition + Vector3.new(0, 5, 0)
root.CFrame = CFrame.new(platformPos)
root.Velocity = Vector3.new(0, 0, 0)
root.RotVelocity = Vector3.new(0, 0, 0)
end
function AutoKill.UnhideCharacter()
local char = LocalPlayer.Character
if not char then return end
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") then
local original = part:GetAttribute("AutoKill_OriginalLTM")
if original ~= nil then
part.LocalTransparencyModifier = original
part:SetAttribute("AutoKill_OriginalLTM", nil)
end
end
end
AutoKill.GunMethod.IsHiding = false
end
function AutoKill.FastEquipDoubleBarrel()
local char = LocalPlayer.Character
if not char then return false end
local humanoid = char:FindFirstChildOfClass("Humanoid")
if not humanoid then return false end
local backpack = LocalPlayer:FindFirstChild("Backpack")
if not backpack then return false end
for _, item in pairs(char:GetChildren()) do
if item:IsA("Tool") and item.Name == "[DoubleBarrel]" then return true end
end
for _, item in pairs(backpack:GetChildren()) do
if item:IsA("Tool") and item.Name == "[DoubleBarrel]" then
pcall(function() humanoid:EquipTool(item) end)
return true
end
end
return false
end
function AutoKill.GetDoubleBarrelAmmo()
local char = LocalPlayer.Character
if not char then return 0 end
local tool = char:FindFirstChild("[DoubleBarrel]")
if not tool then return 0 end
local scriptObj = tool:FindFirstChild("Script")
if scriptObj then
local ammo = scriptObj:FindFirstChild("Ammo")
if ammo and ammo:IsA("IntValue") then
return ammo.Value
end
end
return 0
end
function AutoKill.ReloadDoubleBarrel()
local char = LocalPlayer.Character
if not char then return end
local tool = char:FindFirstChild("[DoubleBarrel]")
if not tool then return end
local be = char:FindFirstChild("BodyEffects")
local reloading = be and be:FindFirstChild("Reloading_CLIENT")
if reloading and reloading.Value then return end
if reloading then reloading.Value = true end
pcall(function()
getgenv().MainEvent:FireServer("Reload", tool)
end)
task.delay(1.5, function()
if reloading then reloading.Value = false end
end)
end
function AutoKill.HideAndReloadDoubleBarrel()
AutoKill.UpdateUI("hiding")
AutoKill.HideCharacter()
AutoKill.ReloadDoubleBarrel()
local reloadStart = tick()
while AutoKill.Enabled and AutoKill.Method == "Gun" do
if not AutoKill.FastEquipDoubleBarrel() then
task.wait(0.1)
continue
end
if AutoKill.GetDoubleBarrelAmmo() > 0 then
break
end
AutoKill.KeepHidden()
if tick() - reloadStart > 2 then
AutoKill.ReloadDoubleBarrel()
reloadStart = tick()
end
task.wait(0.1)
end
end
function AutoKill.TeleportBehindTarget(target)
local char = LocalPlayer.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return end
local targetChar = target.Character
if not targetChar then return end
local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
if not targetRoot then return end
AutoKill.UnhideCharacter()
local offset, lookAt = AutoKill.GetAttachOffset()
if not lookAt then
root.CFrame = targetRoot.CFrame
else
local attachCF = targetRoot.CFrame * offset
root.CFrame = CFrame.lookAt(attachCF.Position, targetRoot.Position)
end
root.Velocity = Vector3.new(0, 0, 0)
end
function AutoKill.AutoStomp(target)
local state = getgenv().AutoStompState
if not state or state.running then return end
AutoKill.GunMethod.StompRunning = true
AutoKill.GunMethod.StompTarget = target
local originalTarget = Targeting.Target
Targeting.Target = target
state.autostomp = true
getgenv().AutoStompLoop()
task.spawn(function()
while state.running do
if not AutoKill.Enabled or AutoKill.Target ~= target then
state.autostomp = false
end
task.wait(0.05)
end
Targeting.Target = originalTarget
AutoKill.GunMethod.StompRunning = false
AutoKill.GunMethod.StompTarget = nil
end)
end
function AutoKill.StopAutoStomp()
local state = getgenv().AutoStompState
if state then state.autostomp = false end
AutoKill.GunMethod.StompRunning = false
AutoKill.GunMethod.StompTarget = nil
end
function AutoKill.GetClosestTarget()
local closest, minDist = nil, math.huge
local mousePos = UserInputService:GetMouseLocation()
for _, player in ipairs(Players:GetPlayers()) do
if AutoKill.IsValidTarget(player) then
local root = player.Character:FindFirstChild("HumanoidRootPart")
local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
if onScreen then
local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
if dist < minDist then
minDist = dist
closest = player
end
end
end
end
if closest then return closest end
-- Fallback to nearest by distance if no one is on screen
local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not myRoot then return nil end
for _, player in ipairs(Players:GetPlayers()) do
if AutoKill.IsValidTarget(player) then
local root = player.Character:FindFirstChild("HumanoidRootPart")
local dist = (root.Position - myRoot.Position).Magnitude
if dist < minDist then
minDist = dist
closest = player
end
end
end
return closest
end
function AutoKill.GetNearestTargetByDistance()
local closest, minDist = nil, math.huge
local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not myRoot then return nil end
for _, player in ipairs(Players:GetPlayers()) do
if AutoKill.IsValidTarget(player) and AutoKill.GetTargetStatus(player) == "alive" then
local root = player.Character:FindFirstChild("HumanoidRootPart")
local dist = (root.Position - myRoot.Position).Magnitude
if dist < minDist then
minDist = dist
closest = player
end
end
end
return closest
end
function AutoKill.StartCombatCycle()
if AutoKill.CycleActive then return end
AutoKill.CycleActive = true
local isKillAura = AutoKill.StandConfig and AutoKill.StandConfig.KillAuraMode
if AutoKill.Method == "Gun" or isKillAura then
if getgenv().ForceHit then
AutoKill.ForceHitWasEnabled = getgenv().ForceHit.Enabled
AutoKill.ForceHitOriginal = {
MaxDistance = getgenv().ForceHit.MaxDistance,
WallCheck = getgenv().ForceHit.WallCheck,
ForceFieldCheck = getgenv().ForceHit.ForceFieldCheck,
DeathCheck = getgenv().ForceHit.DeathCheck,
PrefireForceField = getgenv().ForceHit.PrefireForceField,
HitPart = getgenv().ForceHit.HitPart,
}
getgenv().ForceHit.Enabled = true
getgenv().ForceHit.MaxDistance = 250
getgenv().ForceHit.WallCheck = true
getgenv().ForceHit.ForceFieldCheck = true
getgenv().ForceHit.DeathCheck = true
getgenv().ForceHit.PrefireForceField = false
getgenv().ForceHit.HitPart = "UpperTorso"
end
if not isKillAura then
AutoKill.CreateVoidPlatform()
end
end
task.spawn(function()
-- Kill aura: stands near owner shoot the closest enemy with double barrel
if isKillAura then
while AutoKill.Enabled do
AutoKill.KillAuraStep()
RunService.Heartbeat:Wait()
end
AutoKill.CycleActive = false
AutoKill.GunMethod.IsWaiting = false
AutoKill.GunMethod.IsKilling = false
AutoKill.StopAutoStomp()
AutoKill.UnhideCharacter()
AutoKill.RemoveVoidPlatform()
AutoKill.UpdateUI("off")
return
end
-- Dedicated aura loop: no teleport, no target required, just swing at anyone nearby
if AutoKill.Method == "Knife" and AutoKill.KnifeAura then
while AutoKill.Enabled do
AutoKill.KnifeAuraStep()
RunService.Heartbeat:Wait()
end
AutoKill.CycleActive = false
AutoKill.GunMethod.IsWaiting = false
AutoKill.GunMethod.IsKilling = false
AutoKill.StopAutoStomp()
AutoKill.UnhideCharacter()
AutoKill.RemoveVoidPlatform()
AutoKill.UpdateUI("off")
return
end
while AutoKill.Enabled do
local target = AutoKill.Target
if not target or not AutoKill.IsValidTarget(target) then
target = AutoKill.AdvanceTarget()
if not target then
AutoKill.GunMethod.IsWaiting = true
AutoKill.GunMethod.IsKilling = false
AutoKill.UpdateUI("waiting")
AutoKill.HideCharacter()
task.wait(0.1)
continue
end
end
local targetName = target.DisplayName or target.Name
local status = AutoKill.GetTargetStatus(target)
local targetChar = target.Character
if targetChar and AutoKill.HasForceField(targetChar) then
AutoKill.GunMethod.IsWaiting = true
AutoKill.GunMethod.IsKilling = false
AutoKill.UpdateUI("hiding_kill", targetName)
AutoKill.HideCharacter()
task.wait(0.1)
AutoKill.KeepHidden()
continue
end
if status == "downed" then
if not AutoKill.GunMethod.StompRunning then
AutoKill.UpdateUI("stomping", targetName)
AutoKill.AutoStomp(target)
AutoKill.GunMethod.IsWaiting = true
AutoKill.GunMethod.IsKilling = false
end
if not AutoKill.GunMethod.IsHiding then
AutoKill.UpdateUI("hiding_stomp", targetName)
AutoKill.HideCharacter()
end
task.wait(0.1)
AutoKill.KeepHidden()
elseif status == "alive" then
if AutoKill.GunMethod.IsHiding then
AutoKill.UnhideCharacter()
task.wait(0.05)
end
if AutoKill.GunMethod.StompRunning then
AutoKill.StopAutoStomp()
end
if not AutoKill.GunMethod.IsKilling then
AutoKill.GunMethod.IsWaiting = false
AutoKill.GunMethod.IsKilling = true
AutoKill.UpdateUI("killing", targetName)
if AutoKill.Method == "Gun" then
AutoKill.TeleportBehindTarget(target)
AutoKill.GunMethod.LastTeleportTime = tick()
AutoKill.FastEquipDoubleBarrel()
else
AutoKill.TryEquipKnife()
end
end
if AutoKill.Method == "Gun" then
-- Bail out if a forcefield appeared while we were getting ready
if targetChar and AutoKill.HasForceField(targetChar) then
AutoKill.UpdateUI("hiding_kill", targetName)
AutoKill.HideCharacter()
task.wait(0.1)
AutoKill.KeepHidden()
continue
end
if not AutoKill.FastEquipDoubleBarrel() then
task.wait(0.1)
AutoKill.FastEquipDoubleBarrel()
end
local ammo = AutoKill.GetDoubleBarrelAmmo()
if ammo <= 0 then
AutoKill.HideAndReloadDoubleBarrel()
continue
end
local cooldown = 0.4
if getgenv().FH_GetWeaponCooldown then
cooldown = getgenv().FH_GetWeaponCooldown()
end
local timeSince = tick() - (getgenv().ForceHit.LastShotTime or 0)
local canFire = timeSince >= cooldown
if canFire then
local currentTime = tick()
if currentTime - AutoKill.GunMethod.LastTeleportTime > AutoKill.GunMethod.TeleportCooldown then
AutoKill.TeleportBehindTarget(target)
AutoKill.GunMethod.LastTeleportTime = currentTime
task.wait(0.03)
end
-- One last forcefield check right before the shot
local stillHasField = target.Character and AutoKill.HasForceField(target.Character)
if not stillHasField then
getgenv().FH_Fire(target)
end
local waitTime = cooldown - (tick() - (getgenv().ForceHit.LastShotTime or 0))
if waitTime > 0.02 then
task.wait(waitTime)
else
RunService.Heartbeat:Wait()
end
else
RunService.Heartbeat:Wait()
end
else
AutoKill.KnifeAttackStep(target)
RunService.Heartbeat:Wait()
end
else
-- target is dead/invalid: advance to the next selected target immediately
AutoKill.GunMethod.IsWaiting = true
AutoKill.GunMethod.IsKilling = false
AutoKill.Target = nil
task.wait(0.05)
end
end
AutoKill.CycleActive = false
AutoKill.GunMethod.IsWaiting = false
AutoKill.GunMethod.IsKilling = false
AutoKill.StopAutoStomp()
AutoKill.UnhideCharacter()
AutoKill.RemoveVoidPlatform()
AutoKill.UpdateUI("off")
end)
end
function AutoKill.StopCycle()
AutoKill.LockedOn = false
AutoKill.CycleActive = false
AutoKill.AuraLockedTarget = nil
AutoKill.GunMethod.IsWaiting = false
AutoKill.GunMethod.IsKilling = false
AutoKill.StopAutoStomp()
AutoKill.UnhideCharacter()
AutoKill.RemoveVoidPlatform()
pcall(function()
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if root then
sethiddenproperty(root, "PhysicsRepRootPart", root)
end
end)
if getgenv().ForceHit then
-- Respect the user's ForceHit toggle instead of blindly restoring a stale value.
local desired = (Toggles.UseForcehit and Toggles.UseForcehit.Value) or AutoKill.ForceHitWasEnabled or false
getgenv().ForceHit.Enabled = desired
if AutoKill.ForceHitOriginal then
local orig = AutoKill.ForceHitOriginal
getgenv().ForceHit.MaxDistance = orig.MaxDistance
getgenv().ForceHit.WallCheck = orig.WallCheck
getgenv().ForceHit.ForceFieldCheck = orig.ForceFieldCheck
getgenv().ForceHit.DeathCheck = orig.DeathCheck
getgenv().ForceHit.PrefireForceField = orig.PrefireForceField
getgenv().ForceHit.HitPart = orig.HitPart
AutoKill.ForceHitOriginal = nil
end
end
AutoKill.UpdateUI("off")
end
function AutoKill.StartCycle()
if not AutoKill.Enabled then return end
if not AutoKill.Target then
AutoKill.AdvanceTarget()
end
-- Aura modes don't need a pre-selected target; they pick the nearest enemy
local isAura = (AutoKill.Method == "Knife" and AutoKill.KnifeAura) or (AutoKill.StandConfig and AutoKill.StandConfig.KillAuraMode)
if not AutoKill.Target and not isAura then
return
end
AutoKill.LockedOn = true
AutoKill.StartCombatCycle()
end
-- UI Section
CombatAutoKill:AddToggle('AutoKillEnabled', {
Text = "Auto Kill",
Default = false,
Callback = function(Value)
AutoKill.Enabled = Value
if not Value then
AutoKill.Target = nil
AutoKill.StopCycle()
elseif AutoKill.Target or AutoKill.HasSelectedTargets() or (AutoKill.Method == "Knife" and AutoKill.KnifeAura) then
AutoKill.StartCycle()
end
end
})
CombatAutoKill:AddDropdown('AutoKillMethod', {
Text = "Method",
Values = {"Knife", "Gun"},
Default = "Knife",
Callback = function(Value)
AutoKill.Method = Value
AutoKill.StopCycle()
if AutoKill.Enabled and (AutoKill.Target or AutoKill.HasSelectedTargets() or (Value == "Knife" and AutoKill.KnifeAura)) then
AutoKill.StartCycle()
end
end
})
CombatAutoKill:AddToggle('AutoKillKnifeAura', {
Text = "Knife Aura",
Default = false,
Callback = function(Value)
AutoKill.KnifeAura = Value
AutoKill.AuraLockedTarget = nil
if AutoKill.Enabled and AutoKill.Method == "Knife" then
AutoKill.StopCycle()
AutoKill.AdvanceTarget()
AutoKill.StartCycle()
end
end
})
CombatAutoKill:AddDropdown('AutoKillAttachPosition', {
Text = "Attach Position",
Default = "Behind",
Values = {"Inside", "Behind", "Left", "Right", "Below", "Random"},
Callback = function(Value)
AutoKill.AttachPosition = Value
end
})
CombatAutoKill:AddDropdown('AutoKillManualTargets', {
Text = "Targets",
SpecialType = 'Player',
AllowNull = true,
Multi = true,
Callback = function(Value)
AutoKill.StopCycle()
local selected = {}
if type(Value) == "table" then
for name, active in pairs(Value) do
if active then
table.insert(selected, name)
end
end
elseif Value and Value ~= "" then
table.insert(selected, Value)
end
AutoKill.SetTargetList(selected)
Notify("Auto Kill", #selected .. " target(s) selected", 2)
if AutoKill.Enabled and AutoKill.Target then
AutoKill.StartCycle()
end
end
})
CombatKnifeHitbox:AddToggle('KnifeHitboxToggle', {
Text = "Enabled",
Default = true,
Callback = function(Value)
AutoKill.KnifeExpander.Enabled = Value
end
})
CombatKnifeHitbox:AddSlider('KnifeHitboxSize', {
Text = "Size",
Min = 5,
Max = 200,
Default = 20,
Rounding = 1,
Callback = function(Value)
AutoKill.KnifeExpander.Size = Value
end
})
CombatKnifeHitbox:AddSlider('KnifeHitboxFillTransparency', {
Text = "Fill Transparency",
Min = 0,
Max = 1,
Default = 0.5,
Rounding = 2,
Callback = function(Value)
AutoKill.KnifeExpander.FillTransparency = Value
end
})
CombatKnifeHitbox:AddSlider('KnifeHitboxOutlineTransparency', {
Text = "Outline Transparency",
Min = 0,
Max = 1,
Default = 0.5,
Rounding = 2,
Callback = function(Value)
AutoKill.KnifeExpander.OutlineTransparency = Value
end
})
CombatKnifeHitbox:AddToggle('KnifeHitboxFill', {
Text = "Fill",
Default = true,
Callback = function(Value)
AutoKill.KnifeExpander.Fill = Value
end
}):AddColorPicker('KnifeHitboxFillColor', {
Title = "Fill Color",
Default = AutoKill.KnifeExpander.FillColor,
Callback = function(Value)
AutoKill.KnifeExpander.FillColor = Value
end
})
CombatKnifeHitbox:AddToggle('KnifeHitboxOutline', {
Text = "Outline",
Default = true,
Callback = function(Value)
AutoKill.KnifeExpander.Outline = Value
end
}):AddColorPicker('KnifeHitboxOutlineColor', {
Title = "Outline Color",
Default = AutoKill.KnifeExpander.OutlineColor,
Callback = function(Value)
AutoKill.KnifeExpander.OutlineColor = Value
end
})
CombatAutoKill:AddToggle('AutoKillCustomPlatform', {
Text = "Custom Platform",
Default = true,
Callback = function(Value)
end
}):AddColorPicker('AutoKillPlatformColor', {
Title = "Platform Color",
Default = Color3.fromRGB(255, 0, 255),
Callback = function(Value)
AutoKill.GunMethod.PlatformColor = Value
if AutoKill.GunMethod.PlatformPart then
AutoKill.GunMethod.PlatformPart.Color = Value
end
end
})
CombatAutoKill:AddDropdown('AutoKillPlatformMaterial', {
Text = "Platform Material",
Values = {"Neon", "ForceField", "Glass", "SmoothPlastic", "Wood", "Metal", "Foil", "Granite", "Marble", "Fabric"},
Default = "Neon",
Callback = function(Value)
AutoKill.GunMethod.PlatformMaterial = Enum.Material[Value]
if AutoKill.GunMethod.PlatformPart then
AutoKill.GunMethod.PlatformPart.Material = Enum.Material[Value]
end
end
})
-- Add this after your existing CombatAutoKill toggles

CombatAutoKill:AddToggle('SpectateTarget', {
    Text = "Spectate Target",
    Default = false,
    Callback = function(Value)
        if not Value then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then workspace.CurrentCamera.CameraSubject = hum end
        end
    end
})

RunService.RenderStepped:Connect(function()
    if not (Toggles.SpectateTarget and Toggles.SpectateTarget.Value) then return end
    local target = AutoKill.Target
    if target and target.Character then
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        if hum then workspace.CurrentCamera.CameraSubject = hum end
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then workspace.CurrentCamera.CameraSubject = hum end
    end
end)

getgenv().CombatAutoKill = CombatAutoKill

getgenv().CombatAutoKill = CombatAutoKill
getgenv().AutoKill = AutoKill
getgenv().Toggles = Toggles
getgenv().RunService = RunService
getgenv().ReplicatedStorage = ReplicatedStorage
getgenv().LocalPlayer = LocalPlayer
getgenv().Players = Players

-- Spectate Target: point camera at current auto kill target
CombatAutoKill:AddToggle('SpectateTarget', {
    Text = "Spectate Target",
    Default = false,
    Callback = function(Value)
        Targeting.SpectateTarget = Value
        if not Value then
            -- restore camera back to local player when toggled off
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                workspace.CurrentCamera.CameraSubject = hum
            end
        end
    end
})

-- Auto Stomp: if off, the auto kill loop skips stomping downed targets
CombatAutoKill:AddToggle('AutoStompEnabled', {
    Text = "Auto Stomp",
    Default = true,
    Callback = function(Value)
        getgenv().AutoStompEnabled = Value
    end
})

-- Auto Heal (was HVH): triggers when health drops below the slider %
CombatAutoKill:AddToggle('AutoHealEnabled', {
    Text = "Auto Heal",
    Default = false,
    Callback = function(Value)
        getgenv().AutoHealEnabled = Value
        if Value and getgenv().StartHVH then
            getgenv().StartHVH()
        elseif not Value and getgenv().StopHVH then
            getgenv().StopHVH()
        end
    end
})

CombatAutoKill:AddSlider('AutoHealThreshold', {
    Text = "Health %",
    Min = 1,
    Max = 100,
    Default = 70,
    Rounding = 0,
    Callback = function(Value)
        getgenv().HVHHealthThreshold = Value
    end
})

-- spectate loop: runs every frame and keeps camera on auto kill target
RunService.RenderStepped:Connect(function()
    if not (Toggles.SpectateTarget and Toggles.SpectateTarget.Value) then return end
    local target = AutoKill.Target or Targeting.Target
    if target and target.Character then
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            workspace.CurrentCamera.CameraSubject = hum
        end
    else
        -- no target, restore to self
        local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if myHum then
            workspace.CurrentCamera.CameraSubject = myHum
        end
    end
end)

loadstring(game:HttpGet('https://raw.githubusercontent.com/dsfvxcvb/hvh-test/refs/heads/main/hvh7.lua'))()
print("testing hvh")

-- patch the auto stomp calls to respect the toggle
local _originalAutoStomp = AutoKill.AutoStomp
AutoKill.AutoStomp = function(target)
    if getgenv().AutoStompEnabled == false then return end
    _originalAutoStomp(target)
end

local _originalProtectStomp = ProtectPlayer.StartAutoStomp
ProtectPlayer.StartAutoStomp = function(target)
    if getgenv().AutoStompEnabled == false then return end
    _originalProtectStomp(target)
end

-- patch HVH to use the health threshold slider
getgenv().HVHHealthThreshold = getgenv().HVHHealthThreshold or 70

-- If AutoHeal is already on when this runs
if getgenv().AutoHealEnabled and getgenv().StartHVH then
    getgenv().StartHVH()
end
do
AutoKill.StandConfig = {
Enabled = false,
OwnerName = "",
OwnerPlayer = nil,
FollowConnection = nil,
ChatConnection = nil,
StandAttributeConnection = nil,
IsVanished = false,
BringRunning = false,
FormationMode = "follow",
KnifeAuraMode = false,
KillAuraMode = false,
OrbitMode = false,
OrbitAngle = 0,
FormationAngle = 0,
StandNames = {},
Whitelist = {},
KnockResetConnections = {},
}
-- Give each stand a stable angle so multiple stands spread out automatically
do
local seed = 0
for i = 1, #LocalPlayer.Name do
seed = seed + string.byte(LocalPlayer.Name, i)
end
AutoKill.StandConfig.FormationAngle = (seed % 360) * (math.pi / 180)
end
local function getCircleOffset(angle, distance)
return CFrame.new(math.sin(angle) * distance, 0, math.cos(angle) * distance)
end
local function getOwnerCircleCFrame(distance)
local owner = AutoKill.StandConfig.OwnerPlayer
if not owner or not owner.Character then return nil end
local ownerRoot = owner.Character:FindFirstChild("HumanoidRootPart")
if not ownerRoot then return nil end
local angle = AutoKill.StandConfig.FormationAngle
if AutoKill.StandConfig.OrbitMode then
angle = angle + AutoKill.StandConfig.OrbitAngle
end
-- vary radius per stand so multiple accounts don't perfectly overlap
local dist = distance + math.sin(angle * 5) * 2.5
local offset = getCircleOffset(angle, dist)
-- keep the circle in world space so owner rotation doesn't clump stands
return CFrame.new(ownerRoot.Position) * offset
end
local function findStandPlayer(name)
if not name or name == "" then return nil end
local lower = name:lower()
for _, p in ipairs(Players:GetPlayers()) do
if p.Name:lower():find(lower, 1, true) or (p.DisplayName and p.DisplayName:lower():find(lower, 1, true)) then
return p
end
end
return nil
end
local function findStandTarget(name)
if not name or name == "" then return nil end
local lower = name:lower()
for _, p in ipairs(Players:GetPlayers()) do
if p == LocalPlayer then continue end
if p.Name:lower():find(lower, 1, true) or (p.DisplayName and p.DisplayName:lower():find(lower, 1, true)) then
return p
end
end
return nil
end
local function bringPlayerToOwner(target, owner)
if AutoKill.StandConfig.BringRunning then return end
AutoKill.StandConfig.BringRunning = true
local myChar = LocalPlayer.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
if not myRoot then
AutoKill.StandConfig.BringRunning = false
return
end
-- Knock the target first using target list cycling
AutoKill.SetTargetList({target.Name})
AutoKill.Enabled = true
AutoKill.StartCycle()
local timeout = tick() + 8
while tick() < timeout do
local tc = target.Character
local be = tc and tc:FindFirstChild("BodyEffects")
local ko = be and be:FindFirstChild("K.O")
local dead = be and be:FindFirstChild("Dead")
if (ko and ko.Value) or (dead and dead.Value) then
break
end
task.wait(0.1)
end
AutoKill.Enabled = false
AutoKill.Target = nil
AutoKill.StopCycle()
-- Move stand onto the knocked target and try common grab remotes
local tc = target.Character
local tRoot = tc and tc:FindFirstChild("HumanoidRootPart")
local oc = owner.Character
local oRoot = oc and oc:FindFirstChild("HumanoidRootPart")
if tRoot and oRoot then
myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1.5)
task.wait(0.1)
local mainEvent = ReplicatedStorage:FindFirstChild("MainEvent")
if mainEvent then
local grabAttempts = {
{"Grabbing", true},
{"Grab", target},
{"Grab", target.Character},
{"PickUp", target},
{"PickUp", target.Character},
{"Carry", target},
{"Carry", target.Character},
}
for _, args in ipairs(grabAttempts) do
pcall(function() mainEvent:FireServer(unpack(args)) end)
task.wait(0.05)
end
end
-- Carry them to the owner
for i = 1, 15 do
myRoot.CFrame = oRoot.CFrame * CFrame.new(0, 0, 3)
task.wait(0.05)
end
-- Try to release/drop
if mainEvent then
pcall(function() mainEvent:FireServer("Grabbing", false) end)
end
end
AutoKill.StandConfig.BringRunning = false
end
local function handleStandCommand(msg, sender)
if sender ~= AutoKill.StandConfig.OwnerPlayer then return end
local args = msg:split(" ")
local cmd = args[1] and args[1]:lower()
if not cmd then return end
if cmd == ".godmode" then
if getgenv().AnimGodmode then
local enabled = not getgenv().AnimGodmode.IsEnabled()
getgenv().AnimGodmode.Set(enabled)
end
elseif cmd == ".ak" then
local targetName = args[2]
if not targetName then return end
local target = findStandTarget(targetName)
if target then
AutoKill.StandConfig.IsVanished = false
AutoKill.UnhideCharacter()
AutoKill.SetTargetList({target.Name})
AutoKill.Enabled = true
if Toggles.AutoKillEnabled then
Toggles.AutoKillEnabled:SetValue(true)
end
AutoKill.StartCycle()
end
elseif cmd == ".method" then
local method = args[2] and args[2]:lower()
if method == "knife" then
AutoKill.Method = "Knife"
AutoKill.StopCycle()
if AutoKill.Enabled then AutoKill.StartCycle() end
elseif method == "gun" then
AutoKill.Method = "Gun"
AutoKill.StopCycle()
if AutoKill.Enabled then AutoKill.StartCycle() end
end
elseif cmd == ".vanish" then
AutoKill.StandConfig.IsVanished = true
AutoKill.HideCharacter()
elseif cmd == ".unvanish" then
AutoKill.StandConfig.IsVanished = false
AutoKill.UnhideCharacter()
elseif cmd == ".bring" then
local targetName = args[2]
if not targetName then return end
local target = findStandTarget(targetName)
local owner = AutoKill.StandConfig.OwnerPlayer
if target and owner then
AutoKill.StandConfig.IsVanished = false
AutoKill.UnhideCharacter()
task.spawn(function()
bringPlayerToOwner(target, owner)
end)
end
elseif cmd == ".formation" then
local mode = args[2] and args[2]:lower()
if mode == "circle" or mode == "surround" or mode == "follow" then
AutoKill.StandConfig.FormationMode = mode
else
-- toggle through modes if no valid arg
local modes = {"follow", "circle", "surround"}
local current = table.find(modes, AutoKill.StandConfig.FormationMode) or 1
AutoKill.StandConfig.FormationMode = modes[(current % #modes) + 1]
end
elseif cmd == ".knifeaura" then
local enabled = not AutoKill.StandConfig.KnifeAuraMode
AutoKill.StandConfig.KnifeAuraMode = enabled
AutoKill.StandConfig.KillAuraMode = false
AutoKill.StandConfig.IsVanished = false
AutoKill.UnhideCharacter()
if enabled then
AutoKill.Method = "Knife"
AutoKill.KnifeAura = true
AutoKill.Enabled = true
AutoKill.StopCycle()
AutoKill.StartCycle()
else
AutoKill.KnifeAura = false
AutoKill.Enabled = false
AutoKill.StopCycle()
end
elseif cmd == ".killaura" then
local enabled = not AutoKill.StandConfig.KillAuraMode
AutoKill.StandConfig.KillAuraMode = enabled
AutoKill.StandConfig.KnifeAuraMode = false
AutoKill.KnifeAura = false
AutoKill.StandConfig.IsVanished = false
AutoKill.UnhideCharacter()
if enabled then
AutoKill.Method = "Gun"
AutoKill.Enabled = true
AutoKill.StopCycle()
AutoKill.StartCycle()
else
AutoKill.Enabled = false
AutoKill.Target = nil
AutoKill.StopCycle()
end
elseif cmd == ".orbit" then
AutoKill.StandConfig.OrbitMode = not AutoKill.StandConfig.OrbitMode
elseif cmd == ".stands" then
-- Owner sets the stand account names so aura/knife modes ignore them
local names = {}
for i = 2, #args do
for name in args[i]:gmatch("([^,]+)") do
name = name:match("^%s*(.-)%s*$")
if name ~= "" then
names[name:lower()] = true
end
end
end
AutoKill.StandConfig.StandNames = names
-- also re-resolve owner
if AutoKill.StandConfig.OwnerName ~= "" then
AutoKill.StandConfig.OwnerPlayer = findStandPlayer(AutoKill.StandConfig.OwnerName)
end
elseif cmd == ".whitelist" then
local list = AutoKill.StandConfig.Whitelist
for i = 2, #args do
for name in args[i]:gmatch("([^,]+)") do
name = name:match("^%s*(.-)%s*$")
if name ~= "" then
list[name:lower()] = true
end
end
end
elseif cmd == ".unwhitelist" then
local list = AutoKill.StandConfig.Whitelist
for i = 2, #args do
for name in args[i]:gmatch("([^,]+)") do
name = name:match("^%s*(.-)%s*$")
if name ~= "" then
list[name:lower()] = nil
end
end
end
elseif cmd == ".stop" then
AutoKill.Enabled = false
AutoKill.Target = nil
AutoKill.KnifeAura = false
AutoKill.StopCycle()
AutoKill.UnhideCharacter()
AutoKill.StandConfig.KnifeAuraMode = false
AutoKill.StandConfig.KillAuraMode = false
if Toggles.AutoKillEnabled then
Toggles.AutoKillEnabled:SetValue(false)
end
end
end
local function startStand()
if AutoKill.StandConfig.ChatConnection then return end
local TextChatService = game:GetService("TextChatService")
AutoKill.StandConfig.ChatConnection = TextChatService.MessageReceived:Connect(function(msgObj)
if not AutoKill.StandConfig.Enabled then return end
local textSource = msgObj and msgObj.TextSource
if not textSource then return end
local sender = Players:GetPlayerByUserId(textSource.UserId)
if not sender or sender == LocalPlayer then return end
if not AutoKill.StandConfig.OwnerPlayer then
AutoKill.StandConfig.OwnerPlayer = findStandPlayer(AutoKill.StandConfig.OwnerName)
end
handleStandCommand(msgObj.Text or "", sender)
end)
if AutoKill.StandConfig.FollowConnection then return end
AutoKill.StandConfig.FollowConnection = RunService.Heartbeat:Connect(function(dt)
if not AutoKill.StandConfig.Enabled then return end
if AutoKill.StandConfig.IsVanished then return end
if AutoKill.StandConfig.BringRunning then return end
if AutoKill.GunMethod.StompRunning then return end
if not AutoKill.StandConfig.OwnerPlayer then
AutoKill.StandConfig.OwnerPlayer = findStandPlayer(AutoKill.StandConfig.OwnerName)
end
local owner = AutoKill.StandConfig.OwnerPlayer
if not owner or not owner.Character then return end
local ownerRoot = owner.Character:FindFirstChild("HumanoidRootPart")
local myChar = LocalPlayer.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
if not ownerRoot or not myRoot then return end
if AutoKill.StandConfig.OrbitMode then
dt = dt or (1 / 60)
AutoKill.StandConfig.OrbitAngle = (AutoKill.StandConfig.OrbitAngle + 2 * dt) % (math.pi * 2)
end
local targetCFrame
if AutoKill.StandConfig.KillAuraMode then
targetCFrame = getOwnerCircleCFrame(18)
elseif AutoKill.StandConfig.KnifeAuraMode then
-- Spread stands around the locked target so the knife can actually swing and hit.
-- The ring is tight enough to be in melee range but offset per-stand so they don't slash each other.
local auraTarget = AutoKill.AuraLockedTarget
if not auraTarget or not auraTarget.Character then
auraTarget = AutoKill.GetNearestEnemyToOwner()
if auraTarget then
AutoKill.AuraLockedTarget = auraTarget
end
end
if auraTarget and auraTarget.Character then
local troot = auraTarget.Character:FindFirstChild("HumanoidRootPart")
if troot then
local angle = AutoKill.StandConfig.FormationAngle
local dist = 7 + math.sin(angle * 5) * 1.5 -- 5.5 to 8.5, per-stand variance
local yOff = math.sin(angle * 3) * 1.5
local offset = CFrame.new(math.sin(angle) * dist, yOff, math.cos(angle) * dist)
targetCFrame = troot.CFrame * offset
targetCFrame = CFrame.lookAt(targetCFrame.Position, troot.Position)
else
targetCFrame = getOwnerCircleCFrame(12)
end
else
targetCFrame = getOwnerCircleCFrame(12)
end
elseif AutoKill.StandConfig.FormationMode == "circle" then
if AutoKill.Enabled and AutoKill.Target then return end
targetCFrame = getOwnerCircleCFrame(10)
elseif AutoKill.StandConfig.FormationMode == "surround" then
if AutoKill.Enabled and AutoKill.Target then return end
targetCFrame = getOwnerCircleCFrame(10)
else -- follow
if AutoKill.Enabled and AutoKill.Target then return end
targetCFrame = ownerRoot.CFrame * CFrame.new(0, 0, 8)
end
if targetCFrame then
myRoot.CFrame = targetCFrame
myRoot.AssemblyLinearVelocity = Vector3.zero
myRoot.AssemblyAngularVelocity = Vector3.zero
end
end)
end
local function stopStand()
if AutoKill.StandConfig.ChatConnection then
AutoKill.StandConfig.ChatConnection:Disconnect()
AutoKill.StandConfig.ChatConnection = nil
end
if AutoKill.StandConfig.FollowConnection then
AutoKill.StandConfig.FollowConnection:Disconnect()
AutoKill.StandConfig.FollowConnection = nil
end
for _, c in ipairs(AutoKill.StandConfig.KnockResetConnections or {}) do
pcall(function() c:Disconnect() end)
end
AutoKill.StandConfig.KnockResetConnections = {}
end
-- Clean up old stand connections/cycles when the script is reloaded
local oldUnloadStand = Library.Unload
Library.Unload = function()
stopStand()
AutoKill.Enabled = false
AutoKill.Target = nil
AutoKill.KnifeAura = false
AutoKill.StopCycle()
if oldUnloadStand then
oldUnloadStand()
end
end
MiscUseStand:AddToggle('UseStandEnabled', {
Text = "Use Stand",
Default = false,
Callback = function(Value)
AutoKill.StandConfig.Enabled = Value
if Value then
local ownerName = (Options.UseStandOwner and Options.UseStandOwner.Value) or AutoKill.StandConfig.OwnerName
AutoKill.StandConfig.OwnerPlayer = findStandPlayer(ownerName)
startStand()
AutoKill.SetupStandCharacter(LocalPlayer.Character)
if AutoKill.StandConfig.StandAttributeConnection then
pcall(function() AutoKill.StandConfig.StandAttributeConnection:Disconnect() end)
end
AutoKill.StandConfig.StandAttributeConnection = LocalPlayer.CharacterAdded:Connect(function(char)
task.wait(0.5)
AutoKill.SetupStandCharacter(char)
end)
else
stopStand()
if AutoKill.StandConfig.StandAttributeConnection then
pcall(function() AutoKill.StandConfig.StandAttributeConnection:Disconnect() end)
AutoKill.StandConfig.StandAttributeConnection = nil
end
end
end
})
MiscUseStand:AddInput('UseStandOwner', {
Text = "Owner / Main Account",
Default = "",
Callback = function(Value)
AutoKill.StandConfig.OwnerName = Value
if AutoKill.StandConfig.Enabled then
AutoKill.StandConfig.OwnerPlayer = findStandPlayer(Value)
end
end
})
MiscUseStand:AddDropdown('UseStandWhitelist', {
Text = "Whitelist",
SpecialType = 'Player',
Multi = true,
AllowNull = true,
Callback = function(Value)
local list = {}
if type(Value) == "table" then
for name, active in pairs(Value) do
if active then
list[name:lower()] = true
end
end
elseif Value and Value ~= "" then
list[tostring(Value):lower()] = true
end
AutoKill.StandConfig.Whitelist = list
end
})
MiscUseStand:AddLabel('Commands:')
MiscUseStand:AddLabel('.godmode - toggle anim godmode')
MiscUseStand:AddLabel('.ak <user> - auto kill target')
MiscUseStand:AddLabel('.method knife / .method gun')
MiscUseStand:AddLabel('.formation follow/circle/surround')
MiscUseStand:AddLabel('.knifeaura - circle owner & stab near')
MiscUseStand:AddLabel('.killaura - circle owner & DB closest')
MiscUseStand:AddLabel('.orbit - spin around owner')
MiscUseStand:AddLabel('.stands name1,name2 - stand list')
MiscUseStand:AddLabel('.whitelist name1,name2 - never target')
MiscUseStand:AddLabel('.unwhitelist name1,name2')
MiscUseStand:AddLabel('.vanish - hide on void platform')
MiscUseStand:AddLabel('.unvanish - leave void platform')
MiscUseStand:AddLabel('.bring <user> - bring player to owner')
MiscUseStand:AddLabel('.stop - stop auto kill / aura')
end
getgenv().TargetUIHealthbarColorEnabled = getgenv().TargetUIHealthbarColorEnabled ~= false
getgenv().TargetUIHealthbarStart = getgenv().TargetUIHealthbarStart or Color3.fromRGB(0, 255, 0)
getgenv().TargetUIHealthbarMid = getgenv().TargetUIHealthbarMid or Color3.fromRGB(255, 170, 0)
getgenv().TargetUIHealthbarEnd = getgenv().TargetUIHealthbarEnd or Color3.fromRGB(255, 0, 0)
getgenv().TargetUIAmmoColorEnabled = getgenv().TargetUIAmmoColorEnabled ~= false
getgenv().TargetUIAmmoStart = getgenv().TargetUIAmmoStart or Color3.fromRGB(255, 140, 0)
getgenv().TargetUIAmmoMid = getgenv().TargetUIAmmoMid or Color3.fromRGB(255, 85, 0)
getgenv().TargetUIAmmoEnd = getgenv().TargetUIAmmoEnd or Color3.fromRGB(255, 0, 0)
local function UpdateTargetUIBarColors()
local ui = Library._targetUIInstance
if not ui then return end
local main = ui:FindFirstChildOfClass("Frame")
if not main then return end
local hb = main:FindFirstChild("healthbarvalue", true)
local ab = main:FindFirstChild("armorbarvalue", true)
local function apply(bar, enabled, startCol, midCol, endCol, fallback)
if not bar then return end
local grad = bar:FindFirstChildOfClass("UIGradient")
if not grad then return end
if enabled ~= false then
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, startCol),
ColorSequenceKeypoint.new(0.5, midCol),
ColorSequenceKeypoint.new(1, endCol),
})
else
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, fallback),
ColorSequenceKeypoint.new(0.5, fallback),
ColorSequenceKeypoint.new(1, fallback),
})
end
end
apply(hb, getgenv().TargetUIHealthbarColorEnabled, getgenv().TargetUIHealthbarStart, getgenv().TargetUIHealthbarMid, getgenv().TargetUIHealthbarEnd, Color3.fromRGB(45, 195, 45))
apply(ab, getgenv().TargetUIAmmoColorEnabled, getgenv().TargetUIAmmoStart, getgenv().TargetUIAmmoMid, getgenv().TargetUIAmmoEnd, Color3.fromRGB(255, 140, 0))
end
function Library:targetui_old()
if Library._targetUIInstance then
Library._targetUIInstance:Destroy()
Library._targetUIInstance = nil
end
local IndicatorUI = Instance.new("ScreenGui")
IndicatorUI.Name = "NebulaIndicator"
IndicatorUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
IndicatorUI.Parent = gethui() or CoreGui
IndicatorUI.Enabled = false
Library._targetUIInstance = IndicatorUI
local MainFrame = Instance.new("Frame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, 0, 1, -250)
MainFrame.Size = UDim2.new(0, 322, 0, 147)
MainFrame.Parent = IndicatorUI
MainFrame.Active = true
MainFrame.Draggable = true
local MainUIScale = Instance.new("UIScale")
MainUIScale.Scale = 1
MainUIScale.Parent = MainFrame
local Glow = Instance.new("ImageLabel")
Glow.BackgroundTransparency = 1
Glow.Image = "http://www.roblox.com/asset/?id=18245826428"
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
Glow.ImageColor3 = getgenv().TargetUIGlowColor or getgenv().TargetUIColor or getgenv().TargetUIBorderColor or Color3.fromRGB(27, 206, 203)
Glow.ImageTransparency = 0.85
Glow.Position = UDim2.new(0, -20, 0, -20)
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.ZIndex = MainFrame.ZIndex - 1
Glow.Parent = MainFrame
Glow.Visible = getgenv().TargetUIUseGlow ~= false
Library._targetUIGlow = Glow
local OuterBorder = Instance.new("Frame")
OuterBorder.BackgroundColor3 = getgenv().TargetUIBorderColor or getgenv().TargetUIColor or Color3.fromRGB(27, 206, 203)
OuterBorder.BorderSizePixel = 0
OuterBorder.Position = UDim2.new(0, 1, 0, 1)
OuterBorder.Size = UDim2.new(1, -2, 1, -2)
OuterBorder.Parent = MainFrame
Library._targetUIOuterBorder = OuterBorder
local InnerBorder = Instance.new("Frame")
InnerBorder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InnerBorder.BorderSizePixel = 0
InnerBorder.Position = UDim2.new(0, 1, 0, 1)
InnerBorder.Size = UDim2.new(1, -2, 1, -2)
InnerBorder.Parent = OuterBorder
local ContentFrame = Instance.new("Frame")
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 1, 0, 2)
ContentFrame.Size = UDim2.new(1, -2, 1, -4)
ContentFrame.Parent = InnerBorder
local UIPadding_1 = Instance.new("UIPadding")
UIPadding_1.PaddingLeft = UDim.new(0, 6)
UIPadding_1.Parent = ContentFrame
local Holder = Instance.new("Frame")
Holder.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Holder.BorderSizePixel = 0
Holder.Position = UDim2.new(0, -3, 0, 16)
Holder.Size = UDim2.new(1, 0, 1, -18)
Holder.Name = "holder"
Holder.Parent = ContentFrame
local HolderInner1 = Instance.new("Frame")
HolderInner1.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
HolderInner1.BorderSizePixel = 0
HolderInner1.Position = UDim2.new(0, 1, 0, 1)
HolderInner1.Size = UDim2.new(1, -2, 1, -2)
HolderInner1.Parent = Holder
local HolderInner2 = Instance.new("Frame")
HolderInner2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
HolderInner2.BorderSizePixel = 0
HolderInner2.Position = UDim2.new(0, 1, 0, 1)
HolderInner2.Size = UDim2.new(1, -2, 1, -2)
HolderInner2.Parent = HolderInner1
local UIPadding_2 = Instance.new("UIPadding")
UIPadding_2.PaddingLeft = UDim.new(0, 4)
UIPadding_2.PaddingTop = UDim.new(0, 4)
UIPadding_2.Parent = HolderInner2
local ContentArea = Instance.new("Frame")
ContentArea.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ContentArea.BorderSizePixel = 0
ContentArea.Size = UDim2.new(1, -4, 1, -4)
ContentArea.Parent = HolderInner2
local ContentArea2 = Instance.new("Frame")
ContentArea2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ContentArea2.BorderSizePixel = 0
ContentArea2.Position = UDim2.new(0, 1, 0, 1)
ContentArea2.Size = UDim2.new(1, -2, 1, -2)
ContentArea2.Parent = ContentArea
local ContentArea3 = Instance.new("Frame")
ContentArea3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ContentArea3.BorderSizePixel = 0
ContentArea3.Position = UDim2.new(0, 1, 0, 1)
ContentArea3.Size = UDim2.new(1, -2, 1, -2)
ContentArea3.Parent = ContentArea2
local Gradient1 = Instance.new("UIGradient")
Gradient1.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
Gradient1.Parent = ContentArea3
local UIPadding_3 = Instance.new("UIPadding")
UIPadding_3.PaddingBottom = UDim.new(0, 3)
UIPadding_3.PaddingLeft = UDim.new(0, 4)
UIPadding_3.PaddingRight = UDim.new(0, 3)
UIPadding_3.PaddingTop = UDim.new(0, 4)
UIPadding_3.Parent = ContentArea3
local MainContent = Instance.new("Frame")
MainContent.BackgroundTransparency = 1
MainContent.BorderSizePixel = 0
MainContent.Size = UDim2.new(1, 0, 1, 3)
MainContent.Parent = ContentArea3
local UIListLayout_1 = Instance.new("UIListLayout")
UIListLayout_1.Padding = UDim.new(0, 4)
UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_1.Parent = MainContent
local UIPadding_4 = Instance.new("UIPadding")
UIPadding_4.PaddingBottom = UDim.new(0, 4)
UIPadding_4.Parent = MainContent
local PlayerInfoContainer = Instance.new("Frame")
PlayerInfoContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PlayerInfoContainer.BorderSizePixel = 0
PlayerInfoContainer.Size = UDim2.new(1, -1, 1, 0)
PlayerInfoContainer.Parent = MainContent
local PlayerInfoInner1 = Instance.new("Frame")
PlayerInfoInner1.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
PlayerInfoInner1.BorderSizePixel = 0
PlayerInfoInner1.Position = UDim2.new(0, 1, 0, 1)
PlayerInfoInner1.Size = UDim2.new(1, -2, 1, -2)
PlayerInfoInner1.Parent = PlayerInfoContainer
local PlayerInfoInner2 = Instance.new("Frame")
PlayerInfoInner2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerInfoInner2.BorderSizePixel = 0
PlayerInfoInner2.Position = UDim2.new(0, 1, 0, 1)
PlayerInfoInner2.Size = UDim2.new(1, -2, 1, -2)
PlayerInfoInner2.Parent = PlayerInfoInner1
local Gradient2 = Instance.new("UIGradient")
Gradient2.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
Gradient2.Parent = PlayerInfoInner2
local TopBar = Instance.new("Frame")
TopBar.BackgroundColor3 = getgenv().TargetUIBorderColor or getgenv().TargetUIColor or Color3.fromRGB(27, 206, 203)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 2)
TopBar.Name = "bar"
TopBar.Parent = PlayerInfoInner2
Library._targetUITopBar = TopBar
local InfoHolder = Instance.new("Frame")
InfoHolder.BackgroundTransparency = 1
InfoHolder.BorderSizePixel = 0
InfoHolder.Position = UDim2.new(0, 1, 0, 22)
InfoHolder.Size = UDim2.new(1, -2, 1, -24)
InfoHolder.Name = "holder"
InfoHolder.Parent = PlayerInfoInner2
local UIPadding_5 = Instance.new("UIPadding")
UIPadding_5.PaddingBottom = UDim.new(0, 2)
UIPadding_5.PaddingLeft = UDim.new(0, 3)
UIPadding_5.PaddingRight = UDim.new(0, 3)
UIPadding_5.PaddingTop = UDim.new(0, -1)
UIPadding_5.Parent = InfoHolder
local PlayerInfo = Instance.new("Frame")
PlayerInfo.BackgroundTransparency = 1
PlayerInfo.BorderSizePixel = 0
PlayerInfo.Size = UDim2.new(1, 0, 1, 0)
PlayerInfo.Name = "playerinfo"
PlayerInfo.Parent = InfoHolder
local IconFrame = Instance.new("Frame")
IconFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
IconFrame.BorderSizePixel = 0
IconFrame.Size = UDim2.new(0, 68, 1, 0)
IconFrame.Name = "icon"
IconFrame.Parent = PlayerInfo
local IconInner1 = Instance.new("Frame")
IconInner1.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
IconInner1.BorderSizePixel = 0
IconInner1.Position = UDim2.new(0, 1, 0, 1)
IconInner1.Size = UDim2.new(1, -2, 1, -2)
IconInner1.Parent = IconFrame
local IconInner2 = Instance.new("Frame")
IconInner2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IconInner2.BorderSizePixel = 0
IconInner2.Position = UDim2.new(0, 1, 0, 1)
IconInner2.Size = UDim2.new(1, -2, 1, -2)
IconInner2.Parent = IconInner1
local Gradient4 = Instance.new("UIGradient")
Gradient4.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
Gradient4.Parent = IconInner2
local PlayerIcon = Instance.new("ImageLabel")
PlayerIcon.Image = "rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420"
PlayerIcon.BackgroundTransparency = 1
PlayerIcon.BorderSizePixel = 0
PlayerIcon.Size = UDim2.new(1, 0, 1, 0)
PlayerIcon.Parent = IconInner2
local HealthFrame = Instance.new("Frame")
HealthFrame.AnchorPoint = Vector2.new(0, 1)
HealthFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
HealthFrame.BorderSizePixel = 0
HealthFrame.Position = UDim2.new(0, 72, 1, 0)
HealthFrame.Size = UDim2.new(1, -72, 0, 14)
HealthFrame.Name = "health"
HealthFrame.Parent = PlayerInfo
local HealthInner1 = Instance.new("Frame")
HealthInner1.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
HealthInner1.BorderSizePixel = 0
HealthInner1.Position = UDim2.new(0, 1, 0, 1)
HealthInner1.Size = UDim2.new(1, -2, 1, -2)
HealthInner1.Parent = HealthFrame
local HealthInner2 = Instance.new("Frame")
HealthInner2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HealthInner2.BorderSizePixel = 0
HealthInner2.Position = UDim2.new(0, 1, 0, 1)
HealthInner2.Size = UDim2.new(1, -2, 1, -2)
HealthInner2.Parent = HealthInner1
local Gradient5 = Instance.new("UIGradient")
Gradient5.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
Gradient5.Parent = HealthInner2
local HealthBarValue = Instance.new("Frame")
HealthBarValue.BackgroundColor3 = Color3.fromRGB(45, 195, 45)
HealthBarValue.BorderSizePixel = 0
HealthBarValue.Size = UDim2.new(1, 0, 1, 0)
HealthBarValue.Name = "healthbarvalue"
HealthBarValue.Parent = HealthInner2
local HealthBarGradient = Instance.new("UIGradient")
HealthBarGradient.Rotation = 0
HealthBarGradient.Parent = HealthBarValue
local HealthText = Instance.new("TextLabel")
HealthText.Font = Enum.Font.SourceSans
HealthText.Text = "100/100"
HealthText.TextColor3 = Color3.fromRGB(255, 255, 255)
HealthText.TextSize = 12
HealthText.AnchorPoint = Vector2.new(0.5, 0.5)
HealthText.BackgroundTransparency = 1
HealthText.BorderSizePixel = 0
HealthText.Position = UDim2.new(0.5, 0, 0.5, 0)
HealthText.Size = UDim2.new(1, 0, 1, 0)
HealthText.Name = "healthvalue"
HealthText.Parent = HealthInner2
local InfoFrame = Instance.new("Frame")
InfoFrame.BackgroundTransparency = 1
InfoFrame.BorderSizePixel = 0
InfoFrame.Position = UDim2.new(0.27, 0, 0.029, 0)
InfoFrame.Size = UDim2.new(0, 198, 0, 31)
InfoFrame.Parent = PlayerInfo
local UIListLayout_2 = Instance.new("UIListLayout")
UIListLayout_2.Padding = UDim.new(0, 2)
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Parent = InfoFrame
local NameLabel = Instance.new("TextLabel")
NameLabel.Font = Enum.Font.SourceSans
NameLabel.Text = "Player (@username)"
NameLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
NameLabel.TextSize = 12
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.TextYAlignment = Enum.TextYAlignment.Top
NameLabel.BackgroundTransparency = 1
NameLabel.BorderSizePixel = 0
NameLabel.Size = UDim2.new(0.39, 0, 0.42, 0)
NameLabel.Name = "name"
NameLabel.Parent = InfoFrame
local DistanceLabel = Instance.new("TextLabel")
DistanceLabel.Font = Enum.Font.SourceSans
DistanceLabel.Text = "0 studs"
DistanceLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
DistanceLabel.TextSize = 12
DistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
DistanceLabel.TextYAlignment = Enum.TextYAlignment.Top
DistanceLabel.BackgroundTransparency = 1
DistanceLabel.BorderSizePixel = 0
DistanceLabel.Size = UDim2.new(0.39, 0, 0.42, 0)
DistanceLabel.Name = "studs"
DistanceLabel.Parent = InfoFrame
local ArmorFrame = Instance.new("Frame")
ArmorFrame.AnchorPoint = Vector2.new(0, 1)
ArmorFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ArmorFrame.BorderSizePixel = 0
ArmorFrame.Position = UDim2.new(0, 72, 0.794, 0)
ArmorFrame.Size = UDim2.new(1, -72, 0, 14)
ArmorFrame.Name = "armor"
ArmorFrame.Visible = false
ArmorFrame.Parent = PlayerInfo
local ArmorInner1 = Instance.new("Frame")
ArmorInner1.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ArmorInner1.BorderSizePixel = 0
ArmorInner1.Position = UDim2.new(0, 1, 0, 1)
ArmorInner1.Size = UDim2.new(1, -2, 1, -2)
ArmorInner1.Parent = ArmorFrame
local ArmorInner2 = Instance.new("Frame")
ArmorInner2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ArmorInner2.BorderSizePixel = 0
ArmorInner2.Position = UDim2.new(0, 1, 0, 1)
ArmorInner2.Size = UDim2.new(1, -2, 1, -2)
ArmorInner2.Parent = ArmorInner1
local Gradient6 = Instance.new("UIGradient")
Gradient6.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
Gradient6.Parent = ArmorInner2
local ArmorBarValue = Instance.new("Frame")
ArmorBarValue.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
ArmorBarValue.BorderSizePixel = 0
ArmorBarValue.Size = UDim2.new(1, 0, 1, 0)
ArmorBarValue.Name = "armorbarvalue"
ArmorBarValue.Parent = ArmorInner2
local AmmoBarGradient = Instance.new("UIGradient")
AmmoBarGradient.Rotation = 0
AmmoBarGradient.Parent = ArmorBarValue
local ArmorText = Instance.new("TextLabel")
ArmorText.Font = Enum.Font.SourceSans
ArmorText.Text = "0/0"
ArmorText.TextColor3 = Color3.fromRGB(255, 255, 255)
ArmorText.TextSize = 12
ArmorText.AnchorPoint = Vector2.new(0.5, 0.5)
ArmorText.BackgroundTransparency = 1
ArmorText.BorderSizePixel = 0
ArmorText.Position = UDim2.new(0.5, 0, 0.5, 0)
ArmorText.Size = UDim2.new(1, 0, 1, 0)
ArmorText.Name = "armorvalue"
ArmorText.Parent = ArmorInner2
local TopLabel1Parent = Instance.new("Frame")
TopLabel1Parent.BackgroundTransparency = 1
TopLabel1Parent.BorderSizePixel = 0
TopLabel1Parent.Position = UDim2.new(0, 0, 0, 2)
TopLabel1Parent.Size = UDim2.new(1, 0, 0, 20)
TopLabel1Parent.Name = "top"
TopLabel1Parent.Parent = PlayerInfoInner2
local TopLabel1 = Instance.new("TextLabel")
TopLabel1.Font = Enum.Font.SourceSans
TopLabel1.Text = "Info"
TopLabel1.TextColor3 = Color3.fromRGB(136, 136, 136)
TopLabel1.TextSize = 12
TopLabel1.TextXAlignment = Enum.TextXAlignment.Left
TopLabel1.BackgroundTransparency = 1
TopLabel1.BorderSizePixel = 0
TopLabel1.Size = UDim2.new(1, 0, 1, 0)
TopLabel1.Parent = TopLabel1Parent
local TopLabel2Parent = Instance.new("Frame")
TopLabel2Parent.BackgroundTransparency = 1
TopLabel2Parent.BorderSizePixel = 0
TopLabel2Parent.Size = UDim2.new(1, -4, 0, 20)
TopLabel2Parent.Name = "top"
TopLabel2Parent.Parent = ContentFrame
local TopLabel2 = Instance.new("TextLabel")
TopLabel2.Font = Enum.Font.SourceSans
TopLabel2.Text = "Indicator"
TopLabel2.TextColor3 = Color3.fromRGB(180, 180, 180)
TopLabel2.TextSize = 12
TopLabel2.TextXAlignment = Enum.TextXAlignment.Left
TopLabel2.BackgroundTransparency = 1
TopLabel2.BorderSizePixel = 0
TopLabel2.Size = UDim2.new(0.5, 0, 1, 0)
TopLabel2.Parent = TopLabel2Parent
local targetPlayer = nil
local lastTarget = nil
local function getTargetAmmo(character)
if not character then return 0, 0 end
local tool = character:FindFirstChildOfClass("Tool")
if not tool then return 0, 0 end
local script = tool:FindFirstChild("Script")
if not script then return 0, 0 end
local ammo = script:FindFirstChild("Ammo")
local maxAmmo = script:FindFirstChild("MaxAmmo")
if ammo and maxAmmo and ammo:IsA("IntValue") and maxAmmo:IsA("IntValue") then
return ammo.Value, maxAmmo.Value
end
return 0, 0
end
local function makeGradient(startCol, midCol, endCol)
return ColorSequence.new({
ColorSequenceKeypoint.new(0, startCol),
ColorSequenceKeypoint.new(0.5, midCol),
ColorSequenceKeypoint.new(1, endCol),
})
end
local connection
connection = game:GetService("RunService").RenderStepped:Connect(function()
if not IndicatorUI or not IndicatorUI.Parent then
if connection then connection:Disconnect() end
return
end
if Targeting.LockedOn and Targeting.Target then
targetPlayer = Targeting.Target
elseif AutoKill.Enabled and AutoKill.Target then
targetPlayer = AutoKill.Target
else
if IndicatorUI.Enabled then
IndicatorUI.Enabled = false
end
return
end
if targetPlayer and targetPlayer.Character then
IndicatorUI.Enabled = true
local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
HealthBarValue.Size = UDim2.new(healthPercent, 0, 1, 0)
HealthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
if getgenv().TargetUIHealthbarColorEnabled ~= false then
HealthBarGradient.Color = makeGradient(
getgenv().TargetUIHealthbarStart or Color3.fromRGB(0, 255, 0),
getgenv().TargetUIHealthbarMid or Color3.fromRGB(255, 170, 0),
getgenv().TargetUIHealthbarEnd or Color3.fromRGB(255, 0, 0)
)
else
HealthBarGradient.Color = makeGradient(
Color3.fromRGB(45, 195, 45),
Color3.fromRGB(45, 195, 45),
Color3.fromRGB(45, 195, 45)
)
end
end
if targetPlayer ~= lastTarget then
PlayerIcon.Image = "rbxthumb://type=AvatarHeadShot&id=" .. targetPlayer.UserId .. "&w=420&h=420"
NameLabel.Text = targetPlayer.DisplayName .. " (@" .. targetPlayer.Name .. ")"
lastTarget = targetPlayer
end
local lpChar = LocalPlayer.Character
local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
if lpChar and lpChar:FindFirstChild("HumanoidRootPart") and targetHrp then
local dist = (lpChar.HumanoidRootPart.Position - targetHrp.Position).Magnitude
DistanceLabel.Text = math.floor(dist) .. " studs"
else
DistanceLabel.Text = "N/A studs"
end
local ammoCurrent, ammoMax = getTargetAmmo(targetPlayer.Character)
ArmorFrame.Visible = true
local ammoPercent = (ammoMax > 0) and math.clamp(ammoCurrent / ammoMax, 0, 1) or 0
ArmorBarValue.Size = UDim2.new(ammoPercent, 0, 1, 0)
ArmorText.Text = math.floor(ammoCurrent) .. "/" .. math.floor(ammoMax)
if getgenv().TargetUIAmmoColorEnabled ~= false then
AmmoBarGradient.Color = makeGradient(
getgenv().TargetUIAmmoStart or Color3.fromRGB(255, 140, 0),
getgenv().TargetUIAmmoMid or Color3.fromRGB(255, 85, 0),
getgenv().TargetUIAmmoEnd or Color3.fromRGB(255, 0, 0)
)
else
AmmoBarGradient.Color = makeGradient(
Color3.fromRGB(255, 140, 0),
Color3.fromRGB(255, 140, 0),
Color3.fromRGB(255, 140, 0)
)
end
-- Position handling: Free (draggable) or Follow Target.
-- Re-assert fixed size every frame so nothing else can drift it.
MainFrame.Size = UDim2.new(0, 322, 0, 147)
MainUIScale.Scale = 1
local positionMode = (Options.TargetUIPosition and Options.TargetUIPosition.Value) or getgenv().TargetUIPosition or "Free"
if positionMode == "Follow Target" then
local head = targetPlayer.Character:FindFirstChild("Head")
if head then
local headTop = head.Position + head.CFrame.UpVector * (head.Size.Y * 0.5)
local headRight = head.Position + head.CFrame.RightVector * (head.Size.X * 0.5)
local topScreen, topOnScreen = Camera:WorldToViewportPoint(headTop)
local rightScreen, rightOnScreen = Camera:WorldToViewportPoint(headRight)
if topOnScreen and rightOnScreen then
local absSize = MainFrame.AbsoluteSize
local viewportSize = Camera.ViewportSize
local paddingX, paddingY = 55, 55
-- MainFrame.AnchorPoint is (0.5, 0), so offset by half width horizontally.
local posX = rightScreen.X + absSize.X * 0.5 + paddingX
local posY = topScreen.Y - absSize.Y - paddingY
posX = math.clamp(posX, absSize.X * 0.5, math.max(absSize.X * 0.5, viewportSize.X - absSize.X * 0.5))
posY = math.clamp(posY, 0, math.max(0, viewportSize.Y - absSize.Y))
MainFrame.Draggable = false
MainFrame.Position = UDim2.new(0, posX, 0, posY)
end
end
else
if not MainFrame.Draggable then
MainFrame.Draggable = true
end
end
else
IndicatorUI.Enabled = false
end
end)
IndicatorUI.Destroying:Connect(function()
if connection then connection:Disconnect() end
Library._targetUIInstance = nil
Library._targetUIOuterBorder = nil
Library._targetUITopBar = nil
Library._targetUIGlow = nil
lastTarget = nil
end)
UpdateTargetUIBarColors()
return IndicatorUI
end
function Library:targetui_modern()
local IndicatorUI = Library:targetui_old()
if not IndicatorUI then return nil end
local main = IndicatorUI:FindFirstChildOfClass("Frame")
if not main then return IndicatorUI end
local oldGlow = main:FindFirstChildOfClass("ImageLabel")
if oldGlow then oldGlow:Destroy() end
local mainRadius = 12
local function round(frame, radius)
if not frame or not frame:IsA("GuiObject") then return end
local corner = frame:FindFirstChildOfClass("UICorner")
if not corner then
corner = Instance.new("UICorner")
corner.Parent = frame
end
corner.CornerRadius = UDim.new(0, radius)
end
-- Round every top-level frame. If there are sibling panels (title bar, etc.)
-- they would otherwise stay square and poke through the corners.
for _, sibling in ipairs(IndicatorUI:GetChildren()) do
if sibling:IsA("Frame") then
round(sibling, mainRadius)
if sibling ~= main then
sibling.ClipsDescendants = true
end
end
end
-- Move all existing content into a clipping wrapper so nothing square can
-- poke out past the rounded silhouette. The glow is added afterwards as an
-- unclipped sibling, so it can still spread past the panel edge.
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Size = UDim2.new(1, 0, 1, 0)
Content.Position = UDim2.new(0, 0, 0, 0)
Content.ClipsDescendants = true
Content.ZIndex = main.ZIndex
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, mainRadius)
contentCorner.Parent = Content
for _, child in ipairs(main:GetChildren()) do
if not child:IsA("UICorner") then
child.Parent = Content
end
end
Content.Parent = main
-- === Glow: concentric rounded frames, transparency solved so the
-- combined (fully-stacked) result matches the original image's look ===
local glowColor = getgenv().TargetUIGlowColor or getgenv().TargetUIColor or getgenv().TargetUIBorderColor or Color3.fromRGB(27, 206, 203)
local glowLayers = 8
local glowMaxInset = 12
-- This matches the original 9-slice image's ImageTransparency (0.85).
-- Because all layers overlap near the panel edge, each layer must be much
-- more transparent so the stack compounds back to this target value.
local targetCombinedTransparency = 0.85
local perLayerTransparency = targetCombinedTransparency ^ (1 / glowLayers)
local GlowHolder = Instance.new("Frame")
GlowHolder.Name = "GlowHolder"
GlowHolder.BackgroundTransparency = 1
GlowHolder.Position = UDim2.new(0, 0, 0, 0)
GlowHolder.Size = UDim2.new(1, 0, 1, 0)
GlowHolder.ZIndex = main.ZIndex - 1
GlowHolder.Parent = main
for i = 1, glowLayers do
local t = i / glowLayers
local inset = glowMaxInset * t
local layer = Instance.new("Frame")
layer.Name = "GlowLayer" .. i
layer.BackgroundColor3 = glowColor
layer.BackgroundTransparency = perLayerTransparency
layer.BorderSizePixel = 0
layer.Position = UDim2.new(0, -inset, 0, -inset)
layer.Size = UDim2.new(1, inset * 2, 1, inset * 2)
layer.ZIndex = GlowHolder.ZIndex - (glowLayers - i)
layer.Parent = GlowHolder
local layerCorner = Instance.new("UICorner")
layerCorner.CornerRadius = UDim.new(0, mainRadius + inset)
layerCorner.Parent = layer
end
GlowHolder.Visible = getgenv().TargetUIUseGlow ~= false
Library._targetUIGlow = GlowHolder
-- === end glow ===
local function roundDescendants(obj, depth)
for _, child in ipairs(obj:GetChildren()) do
if child:IsA("Frame") then
-- Leave the thin top accent bar and bar fills sharp.
local name = child.Name
if name ~= "bar" and name ~= "healthbarvalue" and name ~= "armorbarvalue" then
round(child, math.max(2, 12 - depth))
end
roundDescendants(child, depth + 1)
elseif child:IsA("ImageLabel") and child.Parent and child.Parent.Name == "icon" then
round(child, 32)
else
roundDescendants(child, depth)
end
end
end
roundDescendants(Content, 1)
return IndicatorUI
end
function Library:targetui(style)
style = style or getgenv().TargetUIStyle or "Old"
if style == "Modern" then
return Library:targetui_modern()
else
return Library:targetui_old()
end
end
local Config = {
BulletTp = false,
Part = 'Head',
TargetAimShooting = true,
AnchorPlayer = false,
}
local SilentAim = {
Enabled = false,
FOV = 100,
HitPart = "HumanoidRootPart",
Prediction = 0.1433,
PredictionEnabled = false,
AutoShoot = false,
AutoShootDelay = 0.1,
WallCheck = false,
Target = nil,
ShowFOV = false,
LastShootTime = 0,
}
local Crosshair = {
Enabled = true,
FollowTarget = false,
Size = 10,
Gap = 5,
Thickness = 2,
OutlineThickness = 4,
Color = Color3.fromRGB(255, 255, 255),
RotationEnabled = false,
RotationSpeed = 1,
CurrentRotation = 0,
}
local LocalPlayer = Players.LocalPlayer
local JumpOffsetValue = 0
local teleporting = false
local dot = Drawing.new("Circle")
dot.Radius = 10
dot.Thickness = 2
dot.Filled = false
dot.Visible = false
local tracerOutline = Drawing.new("Line")
tracerOutline.Visible = false
tracerOutline.Color = Color3.new(0, 0, 0)
tracerOutline.Thickness = 4
tracerOutline.Transparency = 0.8
local tracer = Drawing.new("Line")
tracer.Visible = false
tracer.Color = Color3.fromRGB(27, 206, 203)
tracer.Thickness = 2
tracer.Transparency = 1
local crosshairLines = {}
local crosshairOutlines = {}
for i = 1, 4 do
local outline = Drawing.new("Line")
outline.Visible = false
outline.Color = Color3.new(0, 0, 0)
outline.Thickness = 4
outline.Transparency = 0.8
crosshairOutlines[i] = outline
local line = Drawing.new("Line")
line.Visible = false
line.Color = Color3.fromRGB(255, 255, 255)
line.Thickness = 2
line.Transparency = 1
crosshairLines[i] = line
end
local silentAimFOV = Drawing.new("Circle")
silentAimFOV.Visible = false
silentAimFOV.Thickness = 1
silentAimFOV.Color = Color3.fromRGB(255, 255, 255)
silentAimFOV.Filled = false
silentAimFOV.NumSides = 64
silentAimFOV.Radius = 100
silentAimFOV.Transparency = 0.5
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Filled = false
fovCircle.NumSides = 64
fovCircle.Radius = 150
fovCircle.Transparency = 1
local fovCircleFill = Drawing.new("Circle")
fovCircleFill.Visible = false
fovCircleFill.Thickness = 1
fovCircleFill.Color = Color3.fromRGB(255, 255, 255)
fovCircleFill.Filled = true
fovCircleFill.NumSides = 64
fovCircleFill.Radius = 150
fovCircleFill.Transparency = 0.85
local fovCircleOutline = Drawing.new("Circle")
fovCircleOutline.Visible = false
fovCircleOutline.Thickness = 3
fovCircleOutline.Color = Color3.fromRGB(0, 0, 0)
fovCircleOutline.Filled = false
fovCircleOutline.NumSides = 64
fovCircleOutline.Radius = 150
fovCircleOutline.Transparency = 0.5
local fovCenterDot = Drawing.new("Circle")
fovCenterDot.Visible = false
fovCenterDot.Filled = true
fovCenterDot.Radius = 3
fovCenterDot.Color = Color3.fromRGB(255, 255, 255)
fovCenterDot.Transparency = 1
fovCenterDot.NumSides = 32
fovCenterDot.Thickness = 1
local FOVCircleConfig = {
Enabled = false,
Radius = 150,
Color = Color3.fromRGB(255, 255, 255),
Thickness = 1,
Transparency = 0,
Filled = false,
FillColor = Color3.fromRGB(255, 255, 255),
FillTransparency = 0.85,
Outline = false,
OutlineColor = Color3.fromRGB(0, 0, 0),
OutlineThickness = 3,
OutlineTransparency = 0.5,
RainbowEnabled = false,
RainbowHue = 0,
DotCenter = false,
DotColor = Color3.fromRGB(255, 255, 255),
DotRadius = 3,
}
local FOVCircleSection = CombatFOV
FOVCircleSection:AddToggle('FOVCircleEnabled',{Text = "Show FOV Circle",
Default = false,
Callback = function(Value)
FOVCircleConfig.Enabled = (Toggles.FOVCircleEnabled and Toggles.FOVCircleEnabled.Value)
if not FOVCircleConfig.Enabled then
fovCircle.Visible = false
fovCircleFill.Visible = false
fovCircleOutline.Visible = false
fovCenterDot.Visible = false
end
end}):AddColorPicker('FOVCircleColor',{Title = "FOV Color",
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
FOVCircleConfig.Color = (Value and Value) or Color3.fromRGB(255, 255, 255)
end})
FOVCircleSection:AddSlider('FOVCircleRadius',{Text = "FOV Radius",
Min = 10,
Max = 800,
Default = 150,
Rounding = 0,
Callback = function(Value)
FOVCircleConfig.Radius = (Options.FOVCircleRadius and Options.FOVCircleRadius.Value) or 150
end})
FOVCircleSection:AddSlider('FOVCircleThickness',{Text = "Thickness",
Min = 1,
Max = 10,
Default = 1,
Rounding = 1,
Callback = function(Value)
FOVCircleConfig.Thickness = (Options.FOVCircleThickness and Options.FOVCircleThickness.Value) or 1
end})
FOVCircleSection:AddSlider('FOVCircleTransparency',{Text = "Transparency",
Min = 0,
Max = 1,
Default = 0,
Rounding = 2,
Callback = function(Value)
FOVCircleConfig.Transparency = (Options.FOVCircleTransparency and Options.FOVCircleTransparency.Value) or 0
end})
FOVCircleSection:AddToggle('FOVCircleFill',{Text = "Fill",
Default = false,
Callback = function(Value)
FOVCircleConfig.Filled = (Toggles.FOVCircleFill and Toggles.FOVCircleFill.Value)
end}):AddColorPicker('FOVCircleFillColor',{Title = "Fill Color",
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
FOVCircleConfig.FillColor = (Value and Value) or Color3.fromRGB(255, 255, 255)
end})
FOVCircleSection:AddSlider('FOVCircleFillTransparency',{Text = "Fill Transparency",
Min = 0,
Max = 1,
Default = 0.85,
Rounding = 2,
Callback = function(Value)
FOVCircleConfig.FillTransparency = (Options.FOVCircleFillTransparency and Options.FOVCircleFillTransparency.Value) or 0.85
end})
FOVCircleSection:AddToggle('FOVCircleOutline',{Text = "Outline",
Default = false,
Callback = function(Value)
FOVCircleConfig.Outline = (Toggles.FOVCircleOutline and Toggles.FOVCircleOutline.Value)
end}):AddColorPicker('FOVCircleOutlineColor',{Title = "Outline Color",
Default = Color3.fromRGB(0, 0, 0),
Callback = function(Value)
FOVCircleConfig.OutlineColor = (Value and Value) or Color3.fromRGB(0, 0, 0)
end})
FOVCircleSection:AddSlider('FOVCircleOutlineThickness',{Text = "Outline Thickness",
Min = 1,
Max = 15,
Default = 3,
Rounding = 1,
Callback = function(Value)
FOVCircleConfig.OutlineThickness = (Options.FOVCircleOutlineThickness and Options.FOVCircleOutlineThickness.Value) or 3
end})
FOVCircleSection:AddSlider('FOVCircleOutlineTransparency',{Text = "Outline Transparency",
Min = 0,
Max = 1,
Default = 0.5,
Rounding = 2,
Callback = function(Value)
FOVCircleConfig.OutlineTransparency = (Options.FOVCircleOutlineTransparency and Options.FOVCircleOutlineTransparency.Value) or 0.5
end})
local Script = {
Functions = {},
Connections = {},
Utility = {
Gun = {},
},
}
Script.Functions.CFrameToOffset = function(Origin, Target)
local ActualOrigin = Origin
* CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
return ActualOrigin:ToObjectSpace(Target):inverse()
end
Script.Functions.TeleportBullet = function(Tool)
local Target = Targeting.Target or SilentAim.Target
if
not (
Target
and Target.Character
and Target.Character:FindFirstChild('HumanoidRootPart')
)
then
return
end
local OriginPart = LocalPlayer.Character
and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
local TargetPart = Target.Character.HumanoidRootPart
if OriginPart and TargetPart then
local OriginalGrip = Tool.Grip
Tool.Parent = LocalPlayer.Backpack
Tool.Grip = Script.Functions.CFrameToOffset(
LocalPlayer.Character.RightHand.CFrame,
TargetPart.CFrame
)
Tool.Parent = LocalPlayer.Character
RunService.RenderStepped:Wait()
Tool.Parent = LocalPlayer.Backpack
Tool.Grip = OriginalGrip
Tool.Parent = LocalPlayer.Character
end
end
local function toggleAnchorPlayer()
Config.AnchorPlayer = (Toggles.AnchorPlayer and Toggles.AnchorPlayer.Value)
teleporting = (Toggles.AnchorPlayer and Toggles.AnchorPlayer.Value)
end
local function onAnchorKeybindPressed()
if (Toggles.AnchorPlayer and Toggles.AnchorPlayer.Value) then
teleporting = not teleporting
end
end
spawn(function()
while true do
wait()
if Targeting.AntiGroundShot and (Toggles.AntiGroundShot and Toggles.AntiGroundShot.Value) and Targeting.Target and Targeting.Target.Character then
local humanoid = Targeting.Target.Character:FindFirstChild("Humanoid")
if humanoid and humanoid.Jump and humanoid.FloorMaterial == Enum.Material.Air then
JumpOffsetValue = GetFlag("JumpOffset") or Targeting.JumpOffset
else
JumpOffsetValue = 0
end
else
JumpOffsetValue = 0
end
end
end)
local function UpdateHighlight(Target)
if Targeting.Highlight then
Targeting.Highlight:Destroy()
Targeting.Highlight = nil
end
if Target and Target.Character and Targeting.HighlightEnabled then
local highlight = Instance.new("Highlight")
highlight.Parent = game.CoreGui
highlight.Adornee = Target.Character
local fillEnabled = Toggles.HighlightFill and Toggles.HighlightFill.Value
local outlineEnabled = Toggles.HighlightOutline and Toggles.HighlightOutline.Value
if fillEnabled then
highlight.FillColor = (Options.HighlightFillColor and Options.HighlightFillColor.Value)
or Color3.fromRGB(27, 206, 203)
highlight.FillTransparency = (Options.HighlightFillTransparency and Options.HighlightFillTransparency.Value) or 0
else
highlight.FillTransparency = 1
end
if outlineEnabled then
highlight.OutlineColor = (Options.HighlightOutlineColor and Options.HighlightOutlineColor.Value)
or Color3.new(1, 1, 1)
highlight.OutlineTransparency = (Options.HighlightOutlineTransparency and Options.HighlightOutlineTransparency.Value) or 0
else
highlight.OutlineTransparency = 1
end
Targeting.Highlight = highlight
end
end
local function ClearTarget()
Targeting.Target = nil
Targeting.WaitingForRespawn = false
UpdateHighlight(nil)
dot.Visible = false
tracer.Visible = false
tracerOutline.Visible = false
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.AutoRotate = true
end
if Targeting.SpectateTarget and (Toggles.SpectateTarget and Toggles.SpectateTarget.Value) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
Camera.CameraSubject = LocalPlayer.Character.Humanoid
end
end
local function UpdateCrosshair()
local centerPos
if Crosshair.FollowTarget then
local followTarget = Targeting.Target or (SilentAim.Enabled and GetFlag("SilentAimEnabled") and SilentAim.Target or nil)
local followPart = Targeting.TargetAimbotPart
if SilentAim.Enabled and GetFlag("SilentAimEnabled") and SilentAim.Target then
followPart = SilentAim.HitPart
end
if followTarget and followTarget.Character then
local targetPart = followTarget.Character:FindFirstChild(followPart)
if targetPart then
local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
if onScreen then
centerPos = Vector2.new(screenPos.X, screenPos.Y)
else
centerPos = UserInputService:GetMouseLocation()
end
else
centerPos = UserInputService:GetMouseLocation()
end
else
centerPos = UserInputService:GetMouseLocation()
end
else
centerPos = UserInputService:GetMouseLocation()
end
if Crosshair.Enabled and (Toggles.CrosshairToggle and Toggles.CrosshairToggle.Value) then
local size = (Options.CrosshairSize and Options.CrosshairSize.Value) or Crosshair.Size
local gap = (Options.CrosshairGap and Options.CrosshairGap.Value) or Crosshair.Gap
local rotation = Crosshair.CurrentRotation
local positions = {
{
from = Vector2.new(centerPos.X + math.sin(rotation) * gap, centerPos.Y - math.cos(rotation) * gap),
to = Vector2.new(centerPos.X + math.sin(rotation) * (gap + size), centerPos.Y - math.cos(rotation) * (gap + size))
},
{
from = Vector2.new(centerPos.X + math.cos(rotation) * gap, centerPos.Y + math.sin(rotation) * gap),
to = Vector2.new(centerPos.X + math.cos(rotation) * (gap + size), centerPos.Y + math.sin(rotation) * (gap + size))
},
{
from = Vector2.new(centerPos.X - math.sin(rotation) * gap, centerPos.Y + math.cos(rotation) * gap),
to = Vector2.new(centerPos.X - math.sin(rotation) * (gap + size), centerPos.Y + math.cos(rotation) * (gap + size))
},
{
from = Vector2.new(centerPos.X - math.cos(rotation) * gap, centerPos.Y - math.sin(rotation) * gap),
to = Vector2.new(centerPos.X - math.cos(rotation) * (gap + size), centerPos.Y - math.sin(rotation) * (gap + size))
}
}
for i = 1, 4 do
crosshairOutlines[i].From = positions[i].from
crosshairOutlines[i].To = positions[i].to
crosshairOutlines[i].Thickness = (Options.CrosshairOutlineThickness and Options.CrosshairOutlineThickness.Value) or Crosshair.OutlineThickness
crosshairOutlines[i].Visible = true
crosshairLines[i].From = positions[i].from
crosshairLines[i].To = positions[i].to
crosshairLines[i].Color = (Options.CrosshairColor and Options.CrosshairColor.Value) and (Options.CrosshairColor and Options.CrosshairColor.Value) or Crosshair.Color
crosshairLines[i].Thickness = (Options.CrosshairThickness and Options.CrosshairThickness.Value) or Crosshair.Thickness
crosshairLines[i].Visible = true
end
else
for i = 1, 4 do
crosshairLines[i].Visible = false
crosshairOutlines[i].Visible = false
end
end
end
local function IsValidTarget(Player)
if not Player or Player == LocalPlayer then
return false
end
local stillInGame = false
for _, p in ipairs(Players:GetPlayers()) do
if p == Player then
stillInGame = true
break
end
end
if not stillInGame then
return false
end
if not Player.Character then
return false
end
local Root = Player.Character:FindFirstChild(Targeting.TargetAimbotPart)
local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
return Root ~= nil and Humanoid ~= nil and Humanoid.Health > 0
end
local function IsTargetDeadOrRespawning(Player)
if not Player then return false end
if not Player.Character then return true end
local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
return not Humanoid or Humanoid.Health <= 0
end
local function GetClosestTarget()
local Closest, MinDist = nil, math.huge
local MousePos = UserInputService:GetMouseLocation()
local useFOV = (Toggles.TargetAimUseFOV and Toggles.TargetAimUseFOV.Value)
local fovRadius = FOVCircleConfig.Radius
for _, Player in ipairs(Players:GetPlayers()) do
if IsValidTarget(Player) then
local Root = Player.Character:FindFirstChild(Targeting.TargetAimbotPart)
local pos, onScreen = Camera:WorldToViewportPoint(Root.Position)
if onScreen then
local screenPos2D = Vector2.new(pos.X, pos.Y)
local mouseDist = (screenPos2D - Vector2.new(MousePos.X, MousePos.Y)).Magnitude
if useFOV and mouseDist > fovRadius then
continue
end
if mouseDist < MinDist then
MinDist = mouseDist
Closest = Player
end
end
end
end
Targeting.Target = Closest
Targeting.WaitingForRespawn = false
UpdateHighlight(Closest)
end
local function GetSilentAimTarget()
local closest, minDist = nil, SilentAim.FOV
local mousePos = UserInputService:GetMouseLocation()
local camPos = Camera.CFrame.Position
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer and IsValidTarget(player) then
local part = player.Character:FindFirstChild(SilentAim.HitPart)
if part then
local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
if onScreen then
local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
if dist < minDist then
if SilentAim.WallCheck and GetFlag("SilentAimWallCheck") then
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
local rayDir = part.Position - camPos
local rayResult = workspace:Raycast(camPos, rayDir, rayParams)
if rayResult and rayResult.Instance:IsDescendantOf(player.Character) then
minDist = dist
closest = player
end
else
minDist = dist
closest = player
end
end
end
end
end
end
return closest
end
local function ToggleLock()
Targeting.LockedOn = not Targeting.LockedOn
if Targeting.LockedOn then
GetClosestTarget()
else
ClearTarget()
end
end
local function toggleTargetAim()
if not (Toggles.TargetAim and Toggles.TargetAim.Value) then
Targeting.LockedOn = false
ClearTarget()
end
end
local function onTargetKeybindPressed()
if not (Toggles.TargetAim and Toggles.TargetAim.Value) then return end
if Targeting.LockedOn and Targeting.Target then
Targeting.LockedOn = false
ClearTarget()
else
Targeting.LockedOn = true
GetClosestTarget()
end
end
local function HandleCharacter(Character)
for _, Conn in ipairs({ 'CharacterChildAdded', 'ChildRemovingCharacter' }) do
if Script.Connections[Conn] then
Script.Connections[Conn]:Disconnect()
end
end
Script.Connections.CharacterChildAdded = Character.ChildAdded:Connect(
function(Tool)
if Tool:IsA('Tool') then
for _, Conn in
ipairs(
getconnections(Tool:GetPropertyChangedSignal('Grip'))
)
do
Conn:Disable()
end
Script.Connections.ToolActivated = Tool.Activated:Connect(
function()
if Config.BulletTp then
Script.Functions.TeleportBullet(Tool)
end
end
)
end
end
)
Script.Connections.ChildRemovingCharacter = Character.ChildRemoved:Connect(
function()
Script.Utility.Gun.Tool = nil
if Script.Connections.ToolActivated then
Script.Connections.ToolActivated:Disconnect()
end
end
)
end
local CurrentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
HandleCharacter(CurrentCharacter)
LocalPlayer.CharacterAdded:Connect(HandleCharacter)
local function setupRespawnHandling(player)
if player and player ~= LocalPlayer then
local connection
connection = player.CharacterAdded:Connect(function(character)
if player == Targeting.Target and Targeting.WaitingForRespawn and Targeting.LockedOn then
task.wait(0.5)
UpdateHighlight(player)
end
end)
end
end
for _, player in ipairs(Players:GetPlayers()) do
setupRespawnHandling(player)
end
Players.PlayerAdded:Connect(setupRespawnHandling)
RunService.RenderStepped:Connect(function()
do
local mousePos = UserInputService:GetMouseLocation()
local showFOV = FOVCircleConfig.Enabled or GetFlag("TargetAimShowFOV")
if showFOV then
FOVCircleConfig.RainbowHue = (FOVCircleConfig.RainbowHue + 0.005) % 1
local displayColor = FOVCircleConfig.RainbowEnabled
and Color3.fromHSV(FOVCircleConfig.RainbowHue, 1, 1)
or FOVCircleConfig.Color
if FOVCircleConfig.Outline then
fovCircleOutline.Position = mousePos
fovCircleOutline.Radius = FOVCircleConfig.Radius
fovCircleOutline.Color = FOVCircleConfig.OutlineColor
fovCircleOutline.Thickness = FOVCircleConfig.OutlineThickness
fovCircleOutline.Transparency = 1 - FOVCircleConfig.OutlineTransparency
fovCircleOutline.Visible = true
else
fovCircleOutline.Visible = false
end
if FOVCircleConfig.Filled then
fovCircleFill.Position = mousePos
fovCircleFill.Radius = FOVCircleConfig.Radius
fovCircleFill.Color = FOVCircleConfig.FillColor
fovCircleFill.Transparency = 1 - FOVCircleConfig.FillTransparency
fovCircleFill.Visible = true
else
fovCircleFill.Visible = false
end
fovCircle.Position = mousePos
fovCircle.Radius = FOVCircleConfig.Radius
fovCircle.Color = displayColor
fovCircle.Thickness = FOVCircleConfig.Thickness
fovCircle.Transparency = 1 - FOVCircleConfig.Transparency
fovCircle.Visible = true
if FOVCircleConfig.DotCenter then
fovCenterDot.Position = mousePos
fovCenterDot.Radius = FOVCircleConfig.DotRadius
fovCenterDot.Color = FOVCircleConfig.DotColor
fovCenterDot.Visible = true
else
fovCenterDot.Visible = false
end
else
fovCircle.Visible = false
fovCircleFill.Visible = false
fovCircleOutline.Visible = false
fovCenterDot.Visible = false
end
end
if SilentAim.Enabled and GetFlag("SilentAimEnabled") then
local now = tick()
if now - (SilentAim.LastScan or 0) >= 0.1 then
SilentAim.LastScan = now
SilentAim.Target = GetSilentAimTarget()
end
else
SilentAim.Target = nil
SilentAim.LastScan = 0
end
if SilentAim.Enabled and GetFlag("SilentAimEnabled") and SilentAim.AutoShoot and GetFlag("SilentAimAutoShoot") and SilentAim.Target then
local currentTime = tick()
if (currentTime - SilentAim.LastShootTime) >= SilentAim.AutoShootDelay then
local char = LocalPlayer.Character
local tool = char and char:FindFirstChildOfClass("Tool")
-- Auto-equip a gun from backpack if none is currently held
if not tool and char then
local humanoid = char:FindFirstChildOfClass("Humanoid")
if humanoid then
for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
if t:IsA("Tool") and t:FindFirstChild("GunScript") then
pcall(function() humanoid:EquipTool(t) end)
break
end
end
end
end
if tool and tool:FindFirstChild("GunScript") and tool.Parent == char then
SilentAim.LastShootTime = currentTime
task.spawn(function()
task.wait()
if tool.Parent == char then
pcall(function() tool:Activate() end)
end
end)
end
end
end
if SilentAim.ShowFOV and GetFlag("SilentAimShowFOV") then
silentAimFOV.Position = UserInputService:GetMouseLocation()
silentAimFOV.Radius = SilentAim.FOV
silentAimFOV.Visible = true
silentAimFOV.Color = (GetFlag("SilentAimFOVColor") and GetFlag("SilentAimFOVColor")) or Color3.fromRGB(255, 255, 255)
else
silentAimFOV.Visible = false
end
if Crosshair.RotationEnabled and (Toggles.CrosshairRotation and Toggles.CrosshairRotation.Value) then
Crosshair.CurrentRotation = Crosshair.CurrentRotation + (Options.CrosshairRotationSpeed.Value or 1) * 0.1
if Crosshair.CurrentRotation > math.pi * 2 then
Crosshair.CurrentRotation = 0
end
else
Crosshair.CurrentRotation = 0
end
UpdateCrosshair()
if Targeting.LockedOn and Targeting.Target then
if IsValidTarget(Targeting.Target) then
Targeting.WaitingForRespawn = false
elseif IsTargetDeadOrRespawning(Targeting.Target) then
if not Targeting.WaitingForRespawn then
Targeting.WaitingForRespawn = true
if Targeting.Highlight then
Targeting.Highlight:Destroy()
Targeting.Highlight = nil
end
end
dot.Visible = false
tracer.Visible = false
tracerOutline.Visible = false
return
else
ClearTarget()
Targeting.LockedOn = false
return
end
elseif Targeting.LockedOn and not Targeting.Target then
GetClosestTarget()
return
end
local vizTarget = nil
local vizPartName = Targeting.TargetAimbotPart
if Targeting.LockedOn and Targeting.Target and IsValidTarget(Targeting.Target) and not Targeting.WaitingForRespawn then
vizTarget = Targeting.Target
elseif AutoKill.Enabled and AutoKill.Target and AutoKill.IsValidTarget(AutoKill.Target) then
vizTarget = AutoKill.Target
elseif SilentAim.Enabled and GetFlag("SilentAimEnabled") and SilentAim.Target and IsValidTarget(SilentAim.Target) then
vizTarget = SilentAim.Target
vizPartName = SilentAim.HitPart
end
if vizTarget and vizTarget.Character and Targeting.HighlightEnabled and (Toggles.HighlightToggle and Toggles.HighlightToggle.Value) then
if not Targeting.Highlight or Targeting.Highlight.Adornee ~= vizTarget.Character then
UpdateHighlight(vizTarget)
end
elseif not vizTarget then
if Targeting.Highlight then
UpdateHighlight(nil)
end
end
if vizTarget and vizTarget.Character then
local targetPart = vizTarget.Character:FindFirstChild(vizPartName)
if targetPart then
if Targeting.DotEnabled and (Toggles.DotToggle and Toggles.DotToggle.Value) then
local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
if onScreen then
dot.Position = Vector2.new(screenPos.X, screenPos.Y)
dot.Color = (Options.DotColor and Options.DotColor.Value) and (Options.DotColor and Options.DotColor.Value) or Targeting.DotColor
dot.Visible = true
else
dot.Visible = false
end
else
dot.Visible = false
end
if Targeting.TracerEnabled and (Toggles.TracerToggle and Toggles.TracerToggle.Value) then
local targetPos = targetPart.Position
local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
local viewportSize = Camera.ViewportSize
local centerX, centerY = viewportSize.X / 2, viewportSize.Y / 2
local tracerStartPos
local startMode = (Options.TracerStartPosition and Options.TracerStartPosition.Value) or Targeting.TracerStartPosition
if startMode == "Mouse" then
tracerStartPos = UserInputService:GetMouseLocation()
elseif startMode == "Bottom" then
tracerStartPos = Vector2.new(centerX, viewportSize.Y)
elseif startMode == "Top" then
tracerStartPos = Vector2.new(centerX, 0)
elseif startMode == "HumanoidRootPart" then
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
local pos, startOnScreen = Camera:WorldToViewportPoint(hrp.Position)
tracerStartPos = Vector2.new(pos.X, pos.Y)
else
tracerStartPos = UserInputService:GetMouseLocation()
end
else
tracerStartPos = UserInputService:GetMouseLocation()
end
local tracerEndPos
if onScreen then
tracerEndPos = Vector2.new(screenPos.X, screenPos.Y)
else
local dirX = screenPos.X - centerX
local dirY = screenPos.Y - centerY
local magnitude = math.sqrt(dirX^2 + dirY^2)
if magnitude > 0 then
dirX = dirX / magnitude
dirY = dirY / magnitude
local edgeX = centerX + dirX * (viewportSize.X / 2 - 50)
local edgeY = centerY + dirY * (viewportSize.Y / 2 - 50)
tracerEndPos = Vector2.new(edgeX, edgeY)
else
tracerEndPos = Vector2.new(centerX, centerY)
end
end
tracerOutline.From = tracerStartPos
tracerOutline.To = tracerEndPos
tracerOutline.Thickness = (Options.TracerOutlineThickness and Options.TracerOutlineThickness.Value) or Targeting.TracerOutlineThickness
tracerOutline.Visible = true
tracer.From = tracerStartPos
tracer.To = tracerEndPos
tracer.Color = (Options.TracerColor and Options.TracerColor.Value) and (Options.TracerColor and Options.TracerColor.Value) or Targeting.TracerColor
tracer.Thickness = (Options.TracerThickness and Options.TracerThickness.Value) or Targeting.TracerThickness
tracer.Visible = true
else
tracer.Visible = false
tracerOutline.Visible = false
end
else
dot.Visible = false
tracer.Visible = false
tracerOutline.Visible = false
end
else
dot.Visible = false
tracer.Visible = false
tracerOutline.Visible = false
end
local anchorTarget = nil
if Targeting.LockedOn and Targeting.Target then
anchorTarget = Targeting.Target
elseif SilentAim.Enabled and GetFlag("SilentAimEnabled") and SilentAim.Target then
anchorTarget = SilentAim.Target
end
if teleporting and Config.AnchorPlayer and (Toggles.AnchorPlayer and Toggles.AnchorPlayer.Value) and anchorTarget then
if anchorTarget.Character and anchorTarget.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
anchorTarget.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -6.5)
end
end
if Targeting.SpectateTarget and (Toggles.SpectateTarget and Toggles.SpectateTarget.Value) then
local spectateTarget = nil
if Targeting.LockedOn and Targeting.Target and Targeting.Target.Character and Targeting.Target.Character:FindFirstChild("Humanoid") then
spectateTarget = Targeting.Target.Character.Humanoid
elseif SilentAim.Enabled and GetFlag("SilentAimEnabled") and SilentAim.Target and SilentAim.Target.Character and SilentAim.Target.Character:FindFirstChild("Humanoid") then
spectateTarget = SilentAim.Target.Character.Humanoid
elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
spectateTarget = LocalPlayer.Character.Humanoid
end
if spectateTarget and Camera.CameraSubject ~= spectateTarget then
Camera.CameraSubject = spectateTarget
end
end
if Targeting.LookAtTarget and (Toggles.LookAtTarget and Toggles.LookAtTarget.Value) then
local lookTarget = nil
if Targeting.LockedOn and Targeting.Target and Targeting.Target.Character then
local part = Targeting.Target.Character:FindFirstChild(Targeting.TargetAimbotPart)
if part then lookTarget = part end
elseif SilentAim.Enabled and GetFlag("SilentAimEnabled") and SilentAim.Target and SilentAim.Target.Character then
local part = SilentAim.Target.Character:FindFirstChild(SilentAim.HitPart)
if part then lookTarget = part end
end
if lookTarget and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local hrp = LocalPlayer.Character.HumanoidRootPart
local myPos = hrp.Position
local targetPos = Vector3.new(lookTarget.Position.X, myPos.Y, lookTarget.Position.Z)
LocalPlayer.Character.Humanoid.AutoRotate = false
hrp.CFrame = CFrame.new(myPos, targetPos)
end
else
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.AutoRotate = true
end
end
end)
Players.PlayerRemoving:Connect(function(player)
if player == Targeting.Target then
ClearTarget()
Targeting.LockedOn = false
end
if player == SilentAim.Target then
SilentAim.Target = nil
end
end)
local Mt = getrawmetatable(game)
setreadonly(Mt, false)
local OldIndex = Mt.__index
Mt.__index = function(Self, Index)
if not checkcaller() and Self == Mouse and Index == "Hit" then
local Target = Targeting.Target
if getgenv().ForceHit and GetFlag("UseForcehit") then
if Target and Target.Character and IsValidTarget(Target) then
local Part = Target.Character:FindFirstChild(Targeting.TargetAimbotPart)
if Part then
local Position = Part.Position
if Targeting.PredictionEnabled and GetFlag("PredictionToggle") then
local predictionValue = GetFlag("PredictionValue") or Targeting.Prediction
Position = Position + (Part.Velocity * predictionValue)
end
if not getgenv().ForceHit.Enabled then
getgenv().ForceHit.Enabled = true
end
task.spawn(function()
getgenv().FH_Fire(Target)
end)
return CFrame.new(Position)
end
end
end
if Config.BulletTp then
local bulletTarget = Target or SilentAim.Target
if bulletTarget and bulletTarget.Character then
local Part = bulletTarget.Character:FindFirstChild(Config.Part)
if Part then
return CFrame.new(Part.Position)
end
end
end
if Targeting.AimbotMethod == "Index" and Targeting.LockedOn and Config.TargetAimShooting and not Config.BulletTp then
if Target and Target.Character and IsValidTarget(Target) then
local Part = Target.Character:FindFirstChild(Targeting.TargetAimbotPart)
if Part then
local Position = Part.Position
if Targeting.PredictionEnabled and GetFlag("PredictionToggle") then
local predictionValue = GetFlag("PredictionValue") or Targeting.Prediction
Position = Position + (Part.Velocity * predictionValue)
end
if Targeting.AntiGroundShot and (Toggles.AntiGroundShot and Toggles.AntiGroundShot.Value) then
Position = Position + Vector3.new(0, JumpOffsetValue, 0)
end
return CFrame.new(Position)
end
end
end
if SilentAim.Enabled and GetFlag("SilentAimEnabled") and not Config.BulletTp then
local sTarget = SilentAim.Target
if sTarget and sTarget.Character then
local Part = sTarget.Character:FindFirstChild(SilentAim.HitPart)
if Part then
local Position = Part.Position
if SilentAim.PredictionEnabled and GetFlag("SilentAimPredictionToggle") then
local predictionValue = GetFlag("SilentAimPredictionValue") or SilentAim.Prediction
Position = Position + (Part.Velocity * predictionValue)
end
return CFrame.new(Position)
end
end
end
if (Index == 'Target' and game.PlaceId == 2788229376) and Config.BulletTp then
local bulletTarget = Target or SilentAim.Target
if bulletTarget and bulletTarget.Character then
local Part = bulletTarget.Character:FindFirstChild(Config.Part)
if Part then
return CFrame.new(Part.Position)
end
end
end
end
return OldIndex(Self, Index)
end
local TargetAimSection = CombatTargetAim
local targetstrafe = CombatStrafe
getgenv().AutoStompState = {autostomp = false, running = false, ret = nil}
getgenv().AutoStompLoop = function()
local state = getgenv().AutoStompState
if not state.autostomp then state.running = false state.ret = nil return end
if state.running then return end
state.running = true
task.spawn(function()
while state.autostomp do
local c = LocalPlayer.Character
local hrp = c and c:FindFirstChild("HumanoidRootPart")
local hum = c and c:FindFirstChildWhichIsA("Humanoid")
if not c or not hrp or not hum then
task.wait(0.1)
else
local target = Targeting.Target
if target and target.Character and target ~= LocalPlayer then
local tc = target.Character
local b = tc:FindFirstChild("BodyEffects")
local ko = b and b:FindFirstChild("K.O") and b["K.O"].Value
local dead = b and b:FindFirstChild("Dead") and b["Dead"].Value
if ko and not dead then
local ut = tc:FindFirstChild("UpperTorso") or tc:FindFirstChild("HumanoidRootPart")
if ut then
if not state.ret then state.ret = hrp.CFrame end
local o = hrp.CFrame
local originalCamOffset = hum.CameraOffset
hum.Sit = false
hum.PlatformStand = false
local originalVel = hrp.AssemblyLinearVelocity
hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
hum.CameraOffset = o.Position - hrp.Position
RunService.RenderStepped:Wait()
for i = 1, 5 do
task.spawn(function()
local me = getgenv().MainEvent
if me then me:FireServer("Stomp") end
end)
end
hum.CameraOffset = originalCamOffset
hrp.CFrame = o
hrp.AssemblyLinearVelocity = originalVel
end
end
end
if state.ret and hrp then
while (hrp.Position - state.ret.Position).Magnitude > 5 do
hrp.CFrame = state.ret
task.wait()
end
state.ret = nil
end
local me = getgenv().MainEvent
if me then pcall(function() me:FireServer("Stomp") end) end
task.wait()
end
end
state.running = false
end)
end
TargetAimSection:AddToggle('TargetAim',{Text = "Target Aim",
Default = false,
Callback = toggleTargetAim}):AddKeyPicker('TargetAimKeybind',{Text = "Target Closest",
Default = 'None',
Callback = onTargetKeybindPressed,
Mode = 'Toggle'})
TargetAimSection:AddToggle('UseForcehit',{Text = "Use Forcehit",
Default = false,
Callback = function(Value)
if getgenv().ForceHit then
getgenv().ForceHit.Enabled = Value
end
end})
-- Keep ForceHit.Enabled in sync with the UI toggle so it doesn't silently desync
-- (some features temporarily disable it; this reapplies the user's intent).
task.spawn(function()
while true do
if getgenv().ForceHit and Toggles.UseForcehit and not getgenv().ForceHit._InternalOverride then
local desired = Toggles.UseForcehit.Value
if getgenv().ForceHit.Enabled ~= desired then
getgenv().ForceHit.Enabled = desired
end
end
task.wait(0.2)
end
end)
TargetAimSection:AddToggle('AutoStompEnabled',{Text = "Auto Stomp",
Default = false,
Callback = function(Value)
local state = getgenv().AutoStompState
if state then
state.autostomp = (Toggles.AutoStompEnabled and Toggles.AutoStompEnabled.Value)
if state.autostomp then
getgenv().AutoStompLoop()
else
state.running = false
state.ret = nil
end
end
end})
TargetAimSection:AddToggle('TargetAimUseFOV',{Text = "Use FOV",
Default = false,
Callback = function(Value) end})
TargetAimSection:AddToggle('PredictionValueToggle',{Text = "Use Prediction",
Default = false,
Callback = function(Value) end})
TargetAimSection:AddInput('PredictionValueTextbox',{Text = "Prediction Value", Default = "0.1433",
Callback = function(Value)
local num = tonumber(Value)
if num then
Targeting.Prediction = math.clamp(num, 0, 1)
end
end})
TargetAimSection:AddToggle('JumpOffsetToggle',{Text = "Use jump offset",
Default = false,
Callback = function(Value) end})
TargetAimSection:AddInput('JumpOffsetTextbox',{Text = "Jump Offset", Default = "0.5",
Callback = function(Value)
local num = tonumber(Value)
if num then
Targeting.JumpOffset = math.clamp(num, 0, 2)
end
end})
TargetAimSection:AddToggle('SpectateTarget',{Text = "Spectate Target",
Default = false,
Callback = function(Value)
Targeting.SpectateTarget = (Toggles.SpectateTarget and Toggles.SpectateTarget.Value)
if not Targeting.SpectateTarget and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
Camera.CameraSubject = LocalPlayer.Character.Humanoid
end
end})
TargetAimSection:AddToggle('LookAtTarget',{Text = "Look At Target",
Default = false,
Callback = function(Value)
Targeting.LookAtTarget = (Toggles.LookAtTarget and Toggles.LookAtTarget.Value)
if not Targeting.LookAtTarget then
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.AutoRotate = true
end
end
end})
local function UpdateProtectPlayerList()
local list = {}
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer then
table.insert(list, p.Name)
end
end
if Options.ProtectPlayerPlayers then
Options.ProtectPlayerPlayers:SetValues(list)
if not table.find(list, ProtectPlayer.SelectedName or "") then
ProtectPlayer.SelectedName = nil
end
end
end
CombatProtectPlayer:AddToggle('ProtectPlayerUse', {Text = "Use",
Default = false,
Callback = function(Value)
ProtectPlayer.Enabled = Value
if Value then
ProtectPlayer.Start()
else
ProtectPlayer.Stop()
end
end})
CombatProtectPlayer:AddDropdown('ProtectPlayerMethod', {Text = "Mode",
Values = {"Gun", "Knife"},
Default = "Gun",
Callback = function(Value)
ProtectPlayer.Method = Value
end})
CombatProtectPlayer:AddDropdown('ProtectPlayerPlayers', {Text = "Players",
Values = {},
Default = nil,
AllowNull = true,
Callback = function(Value)
ProtectPlayer.SelectedName = Value
ProtectPlayer.LastHealth = nil
end})
CombatProtectPlayer:AddToggle('ProtectPlayerStomp', {Text = "Stomp Shooter",
Default = false,
Callback = function(Value)
ProtectPlayer.StompShooter = Value
end})
CombatProtectPlayer:AddToggle('ProtectPlayerSpectate', {Text = "Spectate Shooter",
Default = false,
Callback = function(Value)
ProtectPlayer.SpectateShooter = Value
if not Value then
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end
end
end})
Players.PlayerAdded:Connect(UpdateProtectPlayerList)
Players.PlayerRemoving:Connect(UpdateProtectPlayerList)
task.spawn(UpdateProtectPlayerList)
local CombatTracerTab = CombatTargetIndicators:AddTab('Tracer')
local CombatTargetUITab = CombatTargetIndicators:AddTab('Target UI')
local CombatHighlightTab = CombatTargetIndicators:AddTab('Highlight')
CombatTargetUITab:AddToggle('TargetUI', {
Text = "Target UI",
Default = false,
Callback = function(Value)
if Value then
Library:targetui(getgenv().TargetUIStyle)
else
if Library._targetUIInstance then
Library._targetUIInstance:Destroy()
Library._targetUIInstance = nil
Library._targetUIOuterBorder = nil
Library._targetUITopBar = nil
Library._targetUIGlow = nil
end
end
end
}):AddColorPicker('TargetUIBorderColor', {
Title = "Border Accent Color",
Default = Color3.fromRGB(27, 206, 203),
Callback = function(Value)
getgenv().TargetUIBorderColor = Value
if Library._targetUIOuterBorder then
if Library._targetUIOuterBorder:IsA("UIStroke") then
Library._targetUIOuterBorder.Color = Value
else
Library._targetUIOuterBorder.BackgroundColor3 = Value
end
end
if Library._targetUITopBar then
Library._targetUITopBar.BackgroundColor3 = Value
end
end
}):AddColorPicker('TargetUIGlowColor', {
Title = "Glow Color",
Default = Color3.fromRGB(27, 206, 203),
Callback = function(Value)
getgenv().TargetUIGlowColor = Value
if Library._targetUIGlow then
if Library._targetUIGlow:IsA("ImageLabel") then
Library._targetUIGlow.ImageColor3 = Value
elseif Library._targetUIGlow:IsA("UIStroke") then
Library._targetUIGlow.Color = Value
elseif Library._targetUIGlow:IsA("Frame") and Library._targetUIGlow.Name == "GlowHolder" then
for _, child in ipairs(Library._targetUIGlow:GetChildren()) do
if child:IsA("Frame") and child.Name:sub(1, 9) == "GlowLayer" then
child.BackgroundColor3 = Value
end
end
else
Library._targetUIGlow.BackgroundColor3 = Value
local stroke = Library._targetUIGlow:FindFirstChildOfClass("UIStroke")
if stroke then
stroke.Color = Value
end
end
end
end
})
CombatTargetUITab:AddToggle('UseGlow', {
Text = "Use Glow",
Default = true,
Callback = function(Value)
getgenv().TargetUIUseGlow = Value
if Library._targetUIGlow then
Library._targetUIGlow.Visible = Value
end
end
})
CombatTargetUITab:AddDropdown('TargetUIStyle', {
Text = "Style",
Values = {"Old", "Modern"},
Default = "Old",
Callback = function(Value)
getgenv().TargetUIStyle = Value
if Toggles.TargetUI and Toggles.TargetUI.Value then
Library:targetui(Value)
end
end
})
CombatTargetUITab:AddDropdown('TargetUIPosition', {
Text = "Position",
Values = {"Free", "Follow Target"},
Default = "Free",
Callback = function(Value)
getgenv().TargetUIPosition = Value
if Library._targetUIInstance then
local main = Library._targetUIInstance:FindFirstChildOfClass("Frame")
if main then
main.Draggable = (Value == "Free")
end
end
end
})
CombatTargetUITab:AddToggle('TargetUIHealthbarColor', {
Text = "Healthbar Color",
Default = true,
Callback = function(Value)
getgenv().TargetUIHealthbarColorEnabled = Value
UpdateTargetUIBarColors()
end
}):AddColorPicker('TargetUIHealthbarStart', {
Title = "Start",
Default = Color3.fromRGB(0, 255, 0),
Callback = function(Value)
getgenv().TargetUIHealthbarStart = Value
UpdateTargetUIBarColors()
end
}):AddColorPicker('TargetUIHealthbarMid', {
Title = "Middle",
Default = Color3.fromRGB(255, 170, 0),
Callback = function(Value)
getgenv().TargetUIHealthbarMid = Value
UpdateTargetUIBarColors()
end
}):AddColorPicker('TargetUIHealthbarEnd', {
Title = "End",
Default = Color3.fromRGB(255, 0, 0),
Callback = function(Value)
getgenv().TargetUIHealthbarEnd = Value
UpdateTargetUIBarColors()
end
})
CombatTargetUITab:AddToggle('TargetUIAmmoColor', {
Text = "Ammo Color",
Default = true,
Callback = function(Value)
getgenv().TargetUIAmmoColorEnabled = Value
UpdateTargetUIBarColors()
end
}):AddColorPicker('TargetUIAmmoStart', {
Title = "Start",
Default = Color3.fromRGB(255, 140, 0),
Callback = function(Value)
getgenv().TargetUIAmmoStart = Value
UpdateTargetUIBarColors()
end
}):AddColorPicker('TargetUIAmmoMid', {
Title = "Middle",
Default = Color3.fromRGB(255, 85, 0),
Callback = function(Value)
getgenv().TargetUIAmmoMid = Value
UpdateTargetUIBarColors()
end
}):AddColorPicker('TargetUIAmmoEnd', {
Title = "End",
Default = Color3.fromRGB(255, 0, 0),
Callback = function(Value)
getgenv().TargetUIAmmoEnd = Value
UpdateTargetUIBarColors()
end
})
pcall(function()
if CombatTargetUITab and CombatTargetUITab.Frame then
CombatTargetUITab.Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
CombatTargetUITab.Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
end
end)
local function RefreshHighlight()
if Targeting.Target or SilentAim.Target then
UpdateHighlight(Targeting.Target or SilentAim.Target)
end
end
CombatHighlightTab:AddToggle('HighlightToggle',{Text = "Use",
Default = true,
Callback = function(Value)
Targeting.HighlightEnabled = (Toggles.HighlightToggle and Toggles.HighlightToggle.Value)
if not Targeting.HighlightEnabled and Targeting.Highlight then
UpdateHighlight(nil)
elseif Targeting.HighlightEnabled and (Targeting.Target or SilentAim.Target) then
UpdateHighlight(Targeting.Target or SilentAim.Target)
end
end})
CombatHighlightTab:AddToggle('HighlightFill',{Text = "Fill",
Default = true,
Callback = function(Value)
RefreshHighlight()
end}):AddColorPicker('HighlightFillColor',{Title = "Fill Color",
Default = Color3.fromRGB(27, 206, 203),
Callback = function(Value)
RefreshHighlight()
end})
CombatHighlightTab:AddToggle('HighlightOutline',{Text = "Outline",
Default = true,
Callback = function(Value)
RefreshHighlight()
end}):AddColorPicker('HighlightOutlineColor',{Title = "Outline Color",
Default = Color3.new(1, 1, 1),
Callback = function(Value)
RefreshHighlight()
end})
CombatHighlightTab:AddSlider('HighlightFillTransparency',{Text = "Fill Transparency",
Min = 0,
Max = 1,
Default = 0,
Rounding = 2,
Callback = function(Value)
RefreshHighlight()
end})
CombatHighlightTab:AddSlider('HighlightOutlineTransparency',{Text = "Outline Transparency",
Min = 0,
Max = 1,
Default = 0,
Rounding = 2,
Callback = function(Value)
RefreshHighlight()
end})
CombatTracerTab:AddToggle('TracerToggle',{Text = "Tracer",
Default = true,
Callback = function(Value)
Targeting.TracerEnabled = (Toggles.TracerToggle and Toggles.TracerToggle.Value)
if not Targeting.TracerEnabled then
tracer.Visible = false
tracerOutline.Visible = false
end
end}):AddColorPicker('TracerColor',{Title = "Tracer Color",
Default = Color3.fromRGB(27, 206, 203),
Callback = function(Value)
tracer.Color = Value and Value or Targeting.TracerColor
end})
CombatTracerTab:AddSlider('TracerThickness',{Text = "Tracer Thickness",
Min = 1,
Max = 10,
Default = 2,
Rounding = 0,
Callback = function(Value)
tracer.Thickness = (Options.TracerThickness and Options.TracerThickness.Value) or Targeting.TracerThickness
end})
CombatTracerTab:AddSlider('TracerOutlineThickness',{Text = "Outline Thickness",
Min = 1,
Max = 15,
Default = 4,
Rounding = 0,
Callback = function(Value)
tracerOutline.Thickness = (Options.TracerOutlineThickness and Options.TracerOutlineThickness.Value) or Targeting.TracerOutlineThickness
end})
CombatTracerTab:AddDropdown('TracerStartPosition',{Text = "Starting Position",
Values = {"Bottom", "HumanoidRootPart", "Top", "Mouse"},
Default = "Mouse",
Callback = function(Value)
Targeting.TracerStartPosition = Value
end})
do
local bodyClone = game:GetObjects("rbxassetid://8246626421")[1]
bodyClone.Humanoid:Destroy()
bodyClone.Head.Face:Destroy()
bodyClone.Parent = game.Workspace
bodyClone.HumanoidRootPart.Velocity = Vector3.new()
bodyClone.HumanoidRootPart.CFrame = CFrame.new(9999,9999,9999)
bodyClone.HumanoidRootPart.Transparency = 1
bodyClone.HumanoidRootPart.CanCollide = false
for _, part in pairs(bodyClone:GetChildren()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
part.Material = Enum.Material.Neon
end
end
local TargetStrafeConfig = {
Enabled = false,
Type = "Strafe",
Speed = 5,
Height = 0,
Distance = 8,
RandomRange = 10,
BodyColor = Color3.fromRGB(127, 13, 195),
Visualize = true,
Indicator = false,
IndicatorSmooth = true,
IndicatorColor = Color3.fromRGB(193, 247, 255),
IndicatorGlowColor = Color3.fromRGB(193, 247, 255),
IndicatorBackgroundColor = Color3.fromRGB(15, 15, 15)
}
local Radians = 0
local saved_desync = nil
local hook_active = false
local old_index = nil
local function enableHook()
if not hook_active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
old_index = hookmetamethod(game, "__index", function(self, index)
if not checkcaller()
and TargetStrafeConfig.Enabled
and saved_desync
and index == "CFrame"
and self == LocalPlayer.Character.HumanoidRootPart then
return saved_desync
end
return old_index(self, index)
end)
hook_active = true
end
end
local function disableHook()
if hook_active then
pcall(function()
if old_index then
hookmetamethod(game, "__index", old_index)
end
end)
hook_active = false
old_index = nil
end
end
do
targetstrafe:AddToggle('TargetStrafeEnabled',{Text = "Target strafe",
Default = false,
Callback = function(Value)
TargetStrafeConfig.Enabled = (Toggles.TargetStrafeEnabled and Toggles.TargetStrafeEnabled.Value)
if not TargetStrafeConfig.Enabled then
bodyClone:SetPrimaryPartCFrame(CFrame.new(9999,9999,9999))
disableHook()
end
end}):AddKeyPicker('BulletTPKeybind',{Text = "Bullet TP Toggle",
Default = 'None',
Callback = function(Value)
Toggles.TargetStrafeEnabled:SetValue(not Toggles.TargetStrafeEnabled.Value)
TargetStrafeConfig.Enabled = (Toggles.TargetStrafeEnabled and Toggles.TargetStrafeEnabled.Value)
if not TargetStrafeConfig.Enabled then
bodyClone:SetPrimaryPartCFrame(CFrame.new(9999,9999,9999))
disableHook()
end
end,
Mode = 'Toggle'})
targetstrafe:AddDropdown('StrafeType',{Text = "Strafe Type",
Values = {"Strafe", "Roll", "Tween", "Random"},
Default = "Strafe",
Callback = function(Value)
TargetStrafeConfig.Type = (Options.StrafeType and Options.StrafeType.Value) or "Strafe"
end})
targetstrafe:AddSlider('StrafeSpeed',{Text = "Speed",
Min = 1,
Max = 50,
Default = 5,
Rounding = 0,
Callback = function(Value)
TargetStrafeConfig.Speed = (Options.StrafeSpeed and Options.StrafeSpeed.Value) or 5
end})
targetstrafe:AddSlider('StrafeHeight',{Text = "Height",
Min = -20,
Max = 20,
Default = 0,
Rounding = 0,
Callback = function(Value)
TargetStrafeConfig.Height = (Options.StrafeHeight and Options.StrafeHeight.Value) or 0
end})
targetstrafe:AddSlider('StrafeDistance',{Text = "Distance",
Min = 1,
Max = 50,
Default = 8,
Rounding = 0,
Callback = function(Value)
TargetStrafeConfig.Distance = (Options.StrafeDistance and Options.StrafeDistance.Value) or 8
end})
targetstrafe:AddSlider('RandomRange',{Text = "Random Range",
Min = 1,
Max = 50,
Default = 10,
Rounding = 0,
Callback = function(Value)
TargetStrafeConfig.RandomRange = (Options.RandomRange and Options.RandomRange.Value) or 10
end})
targetstrafe:AddToggle('VisualizeBody',{Text = "Visualize Body",
Default = true,
Callback = function(Value)
TargetStrafeConfig.Visualize = (Toggles.VisualizeBody and Toggles.VisualizeBody.Value)
if not TargetStrafeConfig.Visualize then
bodyClone:SetPrimaryPartCFrame(CFrame.new(9999,9999,9999))
end
end}):AddColorPicker('BodyColor',{Title = "Body Color",
Default = Color3.fromRGB(127, 13, 195),
Callback = function(Value)
TargetStrafeConfig.BodyColor = (Value and Value) or Color3.fromRGB(127, 13, 195)
for _,
part in pairs(bodyClone:GetChildren()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
part.Color = TargetStrafeConfig.BodyColor
end
end
end})
targetstrafe:AddToggle('TargetStrafeIndicator',{Text = "Indicator",
Default = false,
Callback = function(Value)
TargetStrafeConfig.Indicator = (Toggles.TargetStrafeIndicator and Toggles.TargetStrafeIndicator.Value)
if not TargetStrafeConfig.Indicator then
if indicatorObjects and indicatorObjects.circle then
indicatorObjects.circle.Visible = false
indicatorObjects.image.Visible = false
indicatorObjects.glow.Visible = false
indicatorObjects.visible = false
end
end
end}):AddColorPicker('TargetStrafeIndicatorColor',{Title = "Indicator Color",
Default = Color3.fromRGB(193, 247, 255),
Callback = function(Value)
TargetStrafeConfig.IndicatorColor = Value or Color3.fromRGB(193, 247, 255)
end}):AddColorPicker('TargetStrafeIndicatorGlowColor',{Title = "Glow Color",
Default = Color3.fromRGB(193, 247, 255),
Callback = function(Value)
TargetStrafeConfig.IndicatorGlowColor = Value or Color3.fromRGB(193, 247, 255)
end}):AddColorPicker('TargetStrafeIndicatorBackgroundColor',{Title = "Background Color",
Default = Color3.fromRGB(15, 15, 15),
Callback = function(Value)
TargetStrafeConfig.IndicatorBackgroundColor = Value or Color3.fromRGB(15, 15, 15)
end})
end
local strafeIndicatorIconData = "iVBORw0KGgoAAAANSUhEUgAAAB0AAAAdCAMAAABhTZc9AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAPUExURQAAAP///wwMDP39/QAAAJn0DigAAAAFdFJOU/////8A+7YOUwAAAAlwSFlzAABLlgAAS5YBPIKNxAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAD7fwcA6AMAAPt/BwDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAFgdiCkiK10LAAAAZ0lEQVQ4T+XT0QqAMAgF0Gv5/9/cdJrXPYweopeEoe5MGKOgHMDSR/aAiPSNyBaGnT9S4Oi3pnqOtuEqE5kfaiHxG8pYTJoHrMzdzFu1h0qt57oLH58a/YhFfUU/4s967tT/Iv4mVS+LEAmXjonxPAAAAABJRU5ErkJggg=="
local strafeIndicatorShadowData = "iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAQAAABpN6lAAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAHdElNRQfiAQkTIxqKm+UhAAACvElEQVR42u2dzY7aMBhFjxPHEzJQBolRq77/27XSwBCSkD/PwinS7LpBVwrfeYLjI4Ozuy6Cw+HIyHBkOMCxTiIQmYnMzEQi0S9Hz/EUePIlxDpJB58YGRiZmJlTgIKCQMkLYYmwTtLhe2509AwM6QbkFJRUbKnYEChWHGCgp6WhpoF0AzI8gYodB/bs2BDI1aYPYqKn5cIZR7oPkyejoGTLgZ+888aOEq82fRAjHRdOlEBkZGTwODwvVOx55zdH9rxSqE0fxMCVMxXQ0dHS4TwZOYENO9448osDW4La9EH01GyAhhOfBHKy9Ar4JcGeA0d2Kw5QAu3yT+fJcB7IyJdn8JUtO36sOAB0vFISKNJz7+9fgelTKBAIlGrThxEI3z743Fpf/P/GAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0FUAuosQBqATUWQC2gxgKoBdRYALWAGgugFlBjAdQCaiyAWkCNBVALqLEAagE1FkAtoMYCqAXUWAC1gBoLoBZQYwHUAmosgFpAjQVQC6ixAGoBNRZALaDGAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0FUAuosQBqATUWQC2gxgKoBdRYALWAGgugFlBjAdQCaiyAWkCNBVALqLEAagE1FkAtoMYCqAXUWAC1gBoLoBZQYwHUAmosgFpAjQVQC6ixAGoBNRZALaDGAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0FUAuosQBqATUWQC2gxgKoBdRYALWAGgugFlBjAdQCaiyAWkCNBVALqLEAagE1FkAtoMYCqAXUWAC1gBoLoBZQYwHUAmosgFpAjQVQC6ixAGoBNRZALaDGAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0FUAuosQBqATUWQC2gxgKoBdRYALWAGgugFlBjAdQCaiyAWkCNBVALqLEAagE1FkAtoMYCqAXUWAC1gBoLoBZQYwHUAmosgFpAjQVQC6ixAGoBNRZALaDGAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0nfpsi7enp1VIPI53uPriaVmfT9ORAT8eVmhJWvDZ3oea6TK5OzOkGzIz3Lc4N0K04QM0HZy609IzMRM98nyI9UQHt6ic3/3JaEkzMnsjIjYYzJdA8xejqH8403BjTDRjoqHFAx+lJZnc/qOkYmP3yD9AAkY7PJxpe7hnTT2BiAGZG2ieb3p6ILj75+LqL4O7Dq245/HoDpAjx32cQ8QtpRORenSWX2AAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xOdTWsmQAAAAASUVORK5CYII="
local strafeIndicatorPixelData = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAA8nYBAOgDAADydgEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAACOO8FX0xe8TgAAAAxJREFUGFdj+P//PwAF/gL+pzWBhAAAAABJRU5ErkJggg=="
local indicatorObjects = {
circle = nil,
image = nil,
glow = nil,
visible = false
}
local indicatorLastPos = nil
local function destroyIndicator()
if indicatorObjects.circle then
indicatorObjects.circle:Remove()
indicatorObjects.circle = nil
end
if indicatorObjects.image then
indicatorObjects.image:Remove()
indicatorObjects.image = nil
end
if indicatorObjects.glow then
indicatorObjects.glow:Remove()
indicatorObjects.glow = nil
end
indicatorObjects.visible = false
indicatorLastPos = nil
end
local function updateIndicator(worldPosition, dt)
if not TargetStrafeConfig.Indicator or not worldPosition then
if indicatorObjects.visible then
indicatorObjects.circle.Visible = false
indicatorObjects.image.Visible = false
indicatorObjects.glow.Visible = false
indicatorObjects.visible = false
end
return
end
if not indicatorObjects.circle then
indicatorObjects.glow = Drawing.new("Image")
indicatorObjects.glow.Data = base64_decode(strafeIndicatorShadowData)
indicatorObjects.glow.Transparency = 0.09
indicatorObjects.glow.Color = TargetStrafeConfig.IndicatorGlowColor
indicatorObjects.glow.ZIndex = 1
indicatorObjects.glow.Visible = false
indicatorObjects.glow.Position = Vector2.new(0, 0)
indicatorObjects.glow.Size = Vector2.new(73, 73)
indicatorObjects.circle = Drawing.new("Image")
indicatorObjects.circle.Data = base64_decode(strafeIndicatorPixelData)
indicatorObjects.circle.Rounding = 30
indicatorObjects.circle.Transparency = 0.8
indicatorObjects.circle.Color = TargetStrafeConfig.IndicatorBackgroundColor
indicatorObjects.circle.ZIndex = 2
indicatorObjects.circle.Visible = false
indicatorObjects.circle.Position = Vector2.new(0, 0)
indicatorObjects.circle.Size = Vector2.new(65, 65)
indicatorObjects.image = Drawing.new("Image")
indicatorObjects.image.Data = base64_decode(strafeIndicatorIconData)
indicatorObjects.image.Transparency = 0.8
indicatorObjects.image.Color = TargetStrafeConfig.IndicatorColor
indicatorObjects.image.ZIndex = 3
indicatorObjects.image.Visible = false
indicatorObjects.image.Position = Vector2.new(0, 0)
indicatorObjects.image.Size = Vector2.new(29, 29)
end
local pos, onScreen = Camera:WorldToViewportPoint(worldPosition)
if not indicatorLastPos then
indicatorLastPos = Vector2.new(pos.X, pos.Y)
end
local smoothFactor = (dt and dt * 16) or 0.25
indicatorLastPos = indicatorLastPos + (Vector2.new(pos.X, pos.Y) - indicatorLastPos) * smoothFactor
pos = indicatorLastPos
if not onScreen then
indicatorLastPos = nil
if indicatorObjects.visible then
indicatorObjects.circle.Visible = false
indicatorObjects.image.Visible = false
indicatorObjects.glow.Visible = false
indicatorObjects.visible = false
end
return
end
local topPos = Camera:WorldToViewportPoint(worldPosition + Vector3.new(0, 0.5, 0))
local size = math.clamp(math.abs(pos.Y - topPos.Y) * 10, 35, 45)
local screenPos = Vector2.new(pos.X, pos.Y)
local glowSize = Vector2.new(size * 1.1, size * 1.1)
indicatorObjects.glow.Position = screenPos - glowSize / 2
indicatorObjects.glow.Size = glowSize
indicatorObjects.glow.Rounding = size / 2
indicatorObjects.glow.Color = TargetStrafeConfig.IndicatorGlowColor
local circleSize = Vector2.new(size, size)
indicatorObjects.circle.Position = screenPos - circleSize / 2
indicatorObjects.circle.Size = circleSize
indicatorObjects.circle.Color = TargetStrafeConfig.IndicatorBackgroundColor
local imageSize = Vector2.new(size * 0.6, size * 0.6)
indicatorObjects.image.Position = screenPos - imageSize / 2
indicatorObjects.image.Size = imageSize
indicatorObjects.image.Color = TargetStrafeConfig.IndicatorColor
indicatorObjects.glow.Visible = true
indicatorObjects.circle.Visible = true
indicatorObjects.image.Visible = true
indicatorObjects.visible = true
end
local function TargetStrafe(dt)
local TargetPlayer = Targeting.Target
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if hrp then
if TargetStrafeConfig.Enabled then
enableHook()
saved_desync = hrp.CFrame
local Origin
local targetHrp = TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
if targetHrp then
Origin = targetHrp
else
Origin = hrp
end
local randomRange = TargetStrafeConfig.RandomRange
Radians += TargetStrafeConfig.Speed
local calculatedPositions = {
["Strafe"] = Origin.CFrame * CFrame.Angles(0, math.rad(Radians), 0) * CFrame.new(0, TargetStrafeConfig.Height, TargetStrafeConfig.Distance),
["Roll"] = Origin.CFrame * CFrame.new(0, -4, 0) * CFrame.Angles(0, math.rad(math.random(1, 360)), math.rad(-180)),
["Tween"] = (CFrame.new(Origin.Position) + Vector3.new(math.random(-10,10), math.random(-10,10), math.random(-10,10))) * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180))),
["Random"] = (CFrame.new(Origin.Position) + Vector3.new(math.random(-randomRange, randomRange), math.random(-randomRange, randomRange), math.random(-randomRange, randomRange))) * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180))),
}
local PredictedPosition = calculatedPositions[TargetStrafeConfig.Type]
if TargetStrafeConfig.Type == "Tween" then
TweenService:Create(
hrp,
TweenInfo.new(0.1, Enum.EasingStyle.Linear),
{CFrame = PredictedPosition}
):Play()
wait(0.1)
else
hrp.CFrame = PredictedPosition
end
if TargetStrafeConfig.Visualize then
bodyClone:SetPrimaryPartCFrame(PredictedPosition)
end
updateIndicator(PredictedPosition.Position, dt)
RunService.RenderStepped:Wait()
hrp.CFrame = saved_desync
else
bodyClone:SetPrimaryPartCFrame(CFrame.new(9999,9999,9999))
updateIndicator(nil)
disableHook()
end
else
bodyClone:SetPrimaryPartCFrame(CFrame.new(9999,9999,9999))
updateIndicator(nil)
disableHook()
end
end
RunService.Heartbeat:Connect(TargetStrafe)
Players.PlayerRemoving:Connect(function(player)
if player == LocalPlayer then
if bodyClone then
bodyClone:Destroy()
end
destroyIndicator()
disableHook()
end
end)
end
do
Script.Functions.HandleWallbang = function(enabled)
local Ignored = workspace:FindFirstChild("Ignored")
if enabled and Ignored then
for _, WBFolders in ipairs({ 'Vehicles', 'MAP' }) do
local Folders = workspace:FindFirstChild(WBFolders)
if Folders and Folders.Parent ~= Ignored then
Folders.Parent = Ignored
end
end
elseif not enabled and Ignored then
for _, WBFolders in ipairs({ 'Vehicles', 'MAP' }) do
local Folders = Ignored:FindFirstChild(WBFolders)
if Folders then
Folders.Parent = workspace
end
end
end
end
end
do
local InfiniteAmmoEnabled = false
local OriginalGunHold = nil
local AmmoConnections = {}
Script.Functions.HandleInfiniteAmmo = function(enabled)
InfiniteAmmoEnabled = enabled
if enabled then
local u1 = Players.LocalPlayer
local u5 = game:GetService('ReplicatedStorage')
local u11 = u1:WaitForChild('PlayerGui'):WaitForChild('MainScreenGui')
local u15 = require(u5.MainModule)
if not OriginalGunHold then
OriginalGunHold = u15.GunHold
end
u15.GunHold = function(character)
local result = OriginalGunHold(character)
if result and InfiniteAmmoEnabled then
local gun = result[1]
if gun and gun:FindFirstChild('Ammo') then
gun.Ammo.Value = gun.MaxAmmo.Value
end
end
return result
end
local inventory = u1:WaitForChild('DataFolder'):WaitForChild('Inventory')
for _, child in pairs(inventory:GetChildren()) do
if child:IsA('IntValue') then
child.Value = 9999
end
end
AmmoConnections.InventoryConnection = inventory.ChildAdded:Connect(function(child)
if child:IsA('IntValue') and InfiniteAmmoEnabled then
child.Changed:Connect(function()
if InfiniteAmmoEnabled then
child.Value = 9999
end
end)
end
end)
AmmoConnections.UIConnection = game:GetService("RunService").RenderStepped:Connect(function()
if InfiniteAmmoEnabled and u11.AmmoFrame.Visible then
for i, frame in pairs(u11.AmmoFrame.Frame:GetChildren()) do
if frame:IsA('ImageLabel') then
frame.ImageColor3 = Color3.fromRGB(255, 255, 255)
end
end
u11.AmmoFrame.AmmoText.Text = '∞'
end
end)
else
for _, connection in pairs(AmmoConnections) do
if connection then
connection:Disconnect()
end
end
AmmoConnections = {}
if OriginalGunHold then
local u5 = game:GetService('ReplicatedStorage')
local u15 = require(u5.MainModule)
u15.GunHold = OriginalGunHold
end
end
end
end
do
local RapidFireEnabled = false
local RapidFireConnection = nil
local OriginalValues = {}
Script.Functions.HandleRapidFire = function(enabled)
RapidFireEnabled = enabled
if enabled then
local RunService = game:GetService('RunService')
local LocalPlayer = game:GetService('Players').LocalPlayer
RapidFireConnection = RunService.RenderStepped:Connect(function()
if not RapidFireEnabled then return end
local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Tool')
if tool and tool:FindFirstChild('GunScript') then
for _, connection in ipairs(getconnections(tool.Activated)) do
local func = connection.Function
if func then
local funcInfo = debug.getinfo(func)
for i = 1, funcInfo.nups do
local c, n = debug.getupvalue(func, i)
if type(c) == 'number' then
if not OriginalValues[i] then
OriginalValues[i] = c
end
debug.setupvalue(func, i, 0.00001)
end
end
end
end
end
end)
else
if RapidFireConnection then
RapidFireConnection:Disconnect()
RapidFireConnection = nil
end
local LocalPlayer = game:GetService('Players').LocalPlayer
local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Tool')
if tool and tool:FindFirstChild('GunScript') then
for _, connection in ipairs(getconnections(tool.Activated)) do
local func = connection.Function
if func then
local funcInfo = debug.getinfo(func)
for i = 1, funcInfo.nups do
if OriginalValues[i] then
debug.setupvalue(func, i, OriginalValues[i])
end
end
end
end
end
OriginalValues = {}
end
end
end
do
local NoSlowEnabled = false
local NoSlowConnections = {}
local walkspeed = 28
local function setupNoSlow(character)
if not NoSlowEnabled then return end
local humanoid = character:WaitForChild('Humanoid')
local connection = game:GetService("RunService").RenderStepped:Connect(function()
if NoSlowEnabled then
humanoid.WalkSpeed = walkspeed
end
end)
table.insert(NoSlowConnections, connection)
end
Script.Functions.HandleNoSlow = function(enabled)
NoSlowEnabled = enabled
if enabled then
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
if LocalPlayer.Character then
setupNoSlow(LocalPlayer.Character)
end
NoSlowConnections.CharacterConnection = LocalPlayer.CharacterAdded:Connect(setupNoSlow)
else
for _, connection in pairs(NoSlowConnections) do
if connection and connection.Connected then
connection:Disconnect()
end
end
NoSlowConnections = {}
end
end
end
do
end
do
local WalkableEnabled = false
local WalkableDelay = 800
local WalkableInterval = 6
local RunService = game:GetService("RunService")
local InputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local SetProperty = sethiddenproperty
local VProEn = true
function Desync()
task.spawn(function()
while WalkableEnabled do
task.wait()
if LocalPlayer.Character then
local loop = RunService.Heartbeat:Connect(function()
SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
task.wait()
SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
task.wait()
SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
task.wait()
SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
task.wait()
SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
task.wait()
SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
task.wait()
SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
task.wait()
SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
task.wait()
end)
task.wait()
if loop then
loop:Disconnect()
end
end
end
end)
end
function toggleWalkableDesync()
WalkableEnabled = (Toggles.WalkableDesync and Toggles.WalkableDesync.Value)
if WalkableEnabled then
Desync()
Notify("Notification", "Walkable Desync: Enabled", 3)
else
Notify("Notification", "Walkable Desync: Disabled", 3)
end
end
function onWalkableKeybind()
if (Toggles.WalkableDesync and Toggles.WalkableDesync.Value) then
WalkableEnabled = not WalkableEnabled
if WalkableEnabled then
Desync()
Notify("Notification", "Walkable Desync: Enabled", 3)
else
Notify("Notification", "Walkable Desync: Disabled", 3)
end
end
end
function toggleTeleportAway()
local enabled = (Toggles.TeleportAway and Toggles.TeleportAway.Value)
if getgenv().AnimGodmode then
getgenv().AnimGodmode.Set(enabled)
end
if enabled then
Notify("Notification", "Animation Godmode: Enabled", 3)
else
Notify("Notification", "Animation Godmode: Disabled", 3)
end
end
function onTeleportKeybind()
if Toggles.TeleportAway and getgenv().AnimGodmode then
local enabled = not getgenv().AnimGodmode.IsEnabled()
Toggles.TeleportAway:SetValue(enabled)
end
end
function onWalkableDelayChange()
WalkableDelay = (Options.WalkableDelay and Options.WalkableDelay.Value) or 800
end
function onWalkableIntervalChange()
WalkableInterval = (Options.WalkableInterval and Options.WalkableInterval.Value) or 6
end
local WalkableSection = CombatAntiAim
WalkableSection:AddToggle('WalkableDesync',{Text = "Enable Walkable Desync",
Default = false,
Callback = toggleWalkableDesync}):AddKeyPicker('WalkableKeybind',{Text = "Walkable Keybind",
Default = 'None',
Callback = onWalkableKeybind,
Mode = 'Toggle'})
WalkableSection:AddSlider('WalkableDelay',{Text = "Desync Delay",
Min = 100,
Max = 2000,
Default = 800,
Rounding = 0,
Callback = onWalkableDelayChange})
WalkableSection:AddSlider('WalkableInterval',{Text = "Desync Interval",
Min = 1,
Max = 20,
Default = 6,
Rounding = 0,
Callback = onWalkableIntervalChange})
WalkableSection:AddToggle('TeleportAway',{Text = "Godmode",
Default = false,
Callback = toggleTeleportAway}):AddKeyPicker('TeleportKeybind',{Text = "Godmode Keybind",
Default = 'None',
Callback = onTeleportKeybind,
Mode = 'Toggle'})
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
if key == "FallenPartsDestroyHeight" and VProEn then
return -500000000000
end
return oldIndex(self, key)
end)
workspace.FallenPartsDestroyHeight = -500000000000
LocalPlayer.CharacterAdded:Connect(function(character)
task.wait(1)
if character:FindFirstChild("Humanoid") then
character.Humanoid.BreakJointsOnDeath = false
character.Humanoid.HealthChanged:Connect(function(health)
if health <= 0 and character:FindFirstChild("HumanoidRootPart") then
if character.HumanoidRootPart.Position.Y < -100 then
character.Humanoid.Health = character.Humanoid.MaxHealth
end
end
end)
end
end)
end
local HitChamsSettings = {}
local lastHitChamsTime = {}
do
HitChamsSettings.Enabled = false
HitChamsSettings.Color = Color3.fromRGB(0, 255, 255)
HitChamsSettings.Duration = 0.5
HitChamsSettings.Transparency = 0.3
HitChamsSettings.Material = Enum.Material.Neon
HitChamsSettings.FadeOut = false
end
local HitEffectModule = {
Locals = {
Type = {
["Nova"] = nil,
["Crescent Slash"] = nil,
["Coom"] = nil,
["Cosmic Explosion"] = nil,
["Slash"] = nil,
["Atomic Slash"] = nil,
},
},
Functions = {},
Settings = {HitEffect = {Color = Color3.fromRGB(255, 255, 255)}}
}
local HitChamsFolder = Instance.new("Folder")
HitChamsFolder.Name = "HitChamsFolder"
HitChamsFolder.Parent = Workspace
getgenv().HitChamsFolder = HitChamsFolder
do
local Insane = Instance.new("Part")
Insane.Parent = ReplicatedStorage
local Attachment = Instance.new("Attachment")
Attachment.Name = "Attachment"
Attachment.Parent = Insane
HitEffectModule.Locals.Type["Crescent Slash"] = Attachment
local Glow = Instance.new("ParticleEmitter")
Glow.Name = "Glow"
Glow.Lifetime = NumberRange.new(0.16, 0.16)
Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
Glow.Color = ColorSequence.new(Color3.fromRGB(91, 177, 252))
Glow.Speed = NumberRange.new(0, 0)
Glow.Brightness = 5
Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
Glow.Enabled = false
Glow.ZOffset = -0.0565939
Glow.Rate = 50
Glow.Texture = "rbxassetid://8708637750"
local Gradient1 = Instance.new("ParticleEmitter")
Gradient1.Name = "Gradient1"
Gradient1.Lifetime = NumberRange.new(0.3, 0.3)
Gradient1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)})
Gradient1.Color = ColorSequence.new(Color3.fromRGB(115, 201, 255))
Gradient1.Speed = NumberRange.new(0, 0)
Gradient1.Brightness = 6
Gradient1.Size = NumberSequence.new(0, 11.6261358)
Gradient1.Enabled = false
Gradient1.ZOffset = 0.9187313
Gradient1.Rate = 50
Gradient1.Texture = "rbxassetid://8196169974"
Gradient1.Parent = Attachment
local Shards = Instance.new("ParticleEmitter")
Shards.Name = "Shards"
Shards.Lifetime = NumberRange.new(0.19, 0.7)
Shards.SpreadAngle = Vector2.new(-90, 90)
Shards.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
Shards.Drag = 10
Shards.VelocitySpread = -90
Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
Shards.Brightness = 4
Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
Shards.Enabled = false
Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
Shards.ZOffset = 0.5705321
Shards.Rate = 50
Shards.Texture = "rbxassetid://8030734851"
Shards.Rotation = NumberRange.new(90, 90)
Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
Shards.Parent = Attachment
local ShardsDark = Instance.new("ParticleEmitter")
ShardsDark.Name = "ShardsDark"
ShardsDark.Lifetime = NumberRange.new(0.19, 0.35)
ShardsDark.SpreadAngle = Vector2.new(-90, 90)
ShardsDark.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
ShardsDark.Drag = 10
ShardsDark.VelocitySpread = -90
ShardsDark.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
ShardsDark.Speed = NumberRange.new(97.7530136, 146.9970093)
ShardsDark.Brightness = 4
ShardsDark.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.290774, 0.6734411, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
ShardsDark.Enabled = false
ShardsDark.ZOffset = 0.5705321
ShardsDark.Rate = 50
ShardsDark.Texture = "rbxassetid://8030734851"
ShardsDark.Rotation = NumberRange.new(90, 90)
ShardsDark.Orientation = Enum.ParticleOrientation.VelocityParallel
ShardsDark.Parent = Attachment
local Specs = Instance.new("ParticleEmitter")
Specs.Name = "Specs"
Specs.Lifetime = NumberRange.new(0.33, 1.4)
Specs.SpreadAngle = Vector2.new(360, -1000)
Specs.Color = ColorSequence.new(Color3.fromRGB(98, 174, 255))
Specs.Drag = 10
Specs.VelocitySpread = 360
Specs.Speed = NumberRange.new(36.7492523, 146.9970093)
Specs.Brightness = 7
Specs.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.200774, 2.0311937, 0.4363973), NumberSequenceKeypoint.new(1, 0)})
Specs.Enabled = false
Specs.Acceleration = Vector3.new(0, 36.74925231933594, 0)
Specs.Rate = 50
Specs.Texture = "rbxassetid://8030760338"
Specs.EmissionDirection = Enum.NormalId.Right
Specs.Parent = Attachment
local Specs1 = Instance.new("ParticleEmitter")
Specs1.Name = "Specs"
Specs1.Lifetime = NumberRange.new(0.33, 1.75)
Specs1.SpreadAngle = Vector2.new(90, -90)
Specs1.Color = ColorSequence.new(Color3.fromRGB(106, 171, 255))
Specs1.Drag = 9
Specs1.VelocitySpread = 90
Specs1.Speed = NumberRange.new(42.2616425, 73.4985046)
Specs1.Brightness = 6
Specs1.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.210774, 0.3978962, 0.1855686), NumberSequenceKeypoint.new(1, 0)})
Specs1.Enabled = false
Specs1.Acceleration = Vector3.new(0, -20.21208953857422, 0)
Specs1.ZOffset = 0.5144895
Specs1.Rate = 50
Specs1.Texture = "rbxassetid://8030760338"
Specs1.Parent = Attachment
local Specs2 = Instance.new("ParticleEmitter")
Specs2.Name = "Specs"
Specs2.Lifetime = NumberRange.new(0.19, 1.2)
Specs2.SpreadAngle = Vector2.new(360, -1000)
Specs2.Color = ColorSequence.new(Color3.fromRGB(98, 174, 255))
Specs2.Drag = 10
Specs2.VelocitySpread = 360
Specs2.Speed = NumberRange.new(36.7492523, 146.9970093)
Specs2.Brightness = 7
Specs2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.200774, 2.0311937, 0.4363973), NumberSequenceKeypoint.new(1, 0)})
Specs2.Enabled = false
Specs2.Acceleration = Vector3.new(0, 36.74925231933594, 0)
Specs2.Rate = 50
Specs2.Texture = "rbxassetid://8030760338"
Specs2.EmissionDirection = Enum.NormalId.Right
Specs2.Parent = Attachment
local Specs21 = Instance.new("ParticleEmitter")
Specs21.Name = "Specs2"
Specs21.Lifetime = NumberRange.new(0.19, 1.35)
Specs21.SpreadAngle = Vector2.new(90, -90)
Specs21.Color = ColorSequence.new(Color3.fromRGB(106, 171, 255))
Specs21.Drag = 12
Specs21.VelocitySpread = 90
Specs21.Speed = NumberRange.new(42.2616425, 73.4985046)
Specs21.Brightness = 6
Specs21.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.216774, 0.5721694, 0.1855686), NumberSequenceKeypoint.new(1, 0)})
Specs21.Enabled = false
Specs21.Acceleration = Vector3.new(0, -20.21208953857422, 0)
Specs21.ZOffset = 0.5144895
Specs21.Rate = 50
Specs21.Texture = "rbxassetid://8030760338"
Specs21.Parent = Attachment
local ddddddddddddddddddd = Instance.new("ParticleEmitter")
ddddddddddddddddddd.Name = "ddddddddddddddddddd"
ddddddddddddddddddd.Lifetime = NumberRange.new(0.19, 0.37)
ddddddddddddddddddd.SpreadAngle = Vector2.new(90, -90)
ddddddddddddddddddd.LockedToPart = true
ddddddddddddddddddd.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6429392, 0), NumberSequenceKeypoint.new(1, 0)})
ddddddddddddddddddd.LightEmission = 1
ddddddddddddddddddd.Color = ColorSequence.new(Color3.fromRGB(90, 184, 255), Color3.fromRGB(165, 251, 255))
ddddddddddddddddddd.Drag = 6
ddddddddddddddddddd.TimeScale = 0.7
ddddddddddddddddddd.VelocitySpread = 90
ddddddddddddddddddd.Speed = NumberRange.new(81.5833435, 110.2477646)
ddddddddddddddddddd.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.410774, 0.6711507, 0.3356177), NumberSequenceKeypoint.new(1, 0)})
ddddddddddddddddddd.Enabled = false
ddddddddddddddddddd.Acceleration = Vector3.new(0, -81.58334350585938, 0)
ddddddddddddddddddd.ZOffset = 0.8345273
ddddddddddddddddddd.Rate = 50
ddddddddddddddddddd.Texture = "rbxassetid://1053546634"
ddddddddddddddddddd.RotSpeed = NumberRange.new(-444, 166)
ddddddddddddddddddd.Rotation = NumberRange.new(-360, 360)
ddddddddddddddddddd.Parent = Attachment
local large_shard = Instance.new("ParticleEmitter")
large_shard.Name = "large_shard"
large_shard.Lifetime = NumberRange.new(0.19, 0.28)
large_shard.SpreadAngle = Vector2.new(-90, 90)
large_shard.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
large_shard.Drag = 10
large_shard.VelocitySpread = -90
large_shard.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
large_shard.Speed = NumberRange.new(97.7530136, 146.9970093)
large_shard.Brightness = 4
large_shard.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.260774, 3.515605, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
large_shard.Enabled = false
large_shard.ZOffset = 0.5705321
large_shard.Rate = 50
large_shard.Texture = "rbxassetid://8030734851"
large_shard.Rotation = NumberRange.new(90, 90)
large_shard.Orientation = Enum.ParticleOrientation.VelocityParallel
large_shard.Parent = Attachment
local out_Specs = Instance.new("ParticleEmitter")
out_Specs.Name = "out_Specs"
out_Specs.Lifetime = NumberRange.new(0.19, 1)
out_Specs.SpreadAngle = Vector2.new(44, -1000)
out_Specs.Color = ColorSequence.new(Color3.fromRGB(98, 174, 255))
out_Specs.Drag = 10
out_Specs.VelocitySpread = 44
out_Specs.Speed = NumberRange.new(36.7492523, 146.9970093)
out_Specs.Brightness = 7
out_Specs.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.244774, 0.5469525, 0.1433053), NumberSequenceKeypoint.new(1, 0)})
out_Specs.Enabled = false
out_Specs.Acceleration = Vector3.new(0, -3.215559720993042, 0)
out_Specs.Rate = 50
out_Specs.Texture = "rbxassetid://8030760338"
out_Specs.EmissionDirection = Enum.NormalId.Right
out_Specs.Parent = Attachment
local Effect = Instance.new("ParticleEmitter")
Effect.Name = "Effect"
Effect.Lifetime = NumberRange.new(0.4, 0.7)
Effect.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
Effect.SpreadAngle = Vector2.new(360, -360)
Effect.LockedToPart = true
Effect.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)})
Effect.LightEmission = 1
Effect.Color = ColorSequence.new(Color3.fromRGB(92, 161, 252))
Effect.Drag = 1
Effect.VelocitySpread = 360
Effect.Speed = NumberRange.new(0.0036749, 0.0036749)
Effect.Brightness = 2.0999999
Effect.Size = NumberSequence.new(6.9680691, 9.9213123)
Effect.Enabled = false
Effect.ZOffset = 0.4777403
Effect.Rate = 50
Effect.Texture = "rbxassetid://9484012464"
Effect.RotSpeed = NumberRange.new(-150, -150)
Effect.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
Effect.Rotation = NumberRange.new(50, 50)
Effect.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Effect.Parent = Attachment
local Crescents = Instance.new("ParticleEmitter")
Crescents.Name = "Crescents"
Crescents.Lifetime = NumberRange.new(0.19, 0.38)
Crescents.SpreadAngle = Vector2.new(-360, 360)
Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
Crescents.LightEmission = 1
Crescents.Color = ColorSequence.new(Color3.fromRGB(92, 161, 252))
Crescents.VelocitySpread = -360
Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
Crescents.Brightness = 20
Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
Crescents.Enabled = false
Crescents.ZOffset = 0.4542207
Crescents.Rate = 50
Crescents.Texture = "rbxassetid://12509373457"
Crescents.RotSpeed = NumberRange.new(800, 1000)
Crescents.Rotation = NumberRange.new(-360, 360)
Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Crescents.Parent = Attachment
Insane.Parent = workspace
end
do
local part = Instance.new("Part")
part.Parent = ReplicatedStorage
local attachment = Instance.new("Attachment")
attachment.Name = "Attachment"
attachment.Parent = part
HitEffectModule.Locals.Type["Particles"] = attachment
part.Parent = workspace
end
do
local Part = Instance.new("Part")
Part.Parent = ReplicatedStorage
local Attachment = Instance.new("Attachment")
Attachment.Name = "Attachment"
Attachment.Parent = Part
HitEffectModule.Locals.Type["Cosmic Explosion"] = Attachment
local Glow = Instance.new("ParticleEmitter")
Glow.Name = "Glow"
Glow.Lifetime = NumberRange.new(0.16, 0.16)
Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
Glow.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Glow.Speed = NumberRange.new(0, 0)
Glow.Brightness = 5
Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
Glow.Enabled = false
Glow.ZOffset = -0.0565939
Glow.Rate = 50
Glow.Texture = "rbxassetid://8708637750"
Glow.Parent = Attachment
local Effect = Instance.new("ParticleEmitter")
Effect.Name = "Effect"
Effect.Lifetime = NumberRange.new(0.4, 0.7)
Effect.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
Effect.SpreadAngle = Vector2.new(360, -360)
Effect.LockedToPart = true
Effect.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)})
Effect.LightEmission = 1
Effect.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Effect.Drag = 1
Effect.VelocitySpread = 360
Effect.Speed = NumberRange.new(0.0036749, 0.0036749)
Effect.Brightness = 2.0999999
Effect.Size = NumberSequence.new(6.9680691, 9.9213123)
Effect.Enabled = false
Effect.ZOffset = 0.4777403
Effect.Rate = 50
Effect.Texture = "rbxassetid://9484012464"
Effect.RotSpeed = NumberRange.new(-150, -150)
Effect.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
Effect.Rotation = NumberRange.new(50, 50)
Effect.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Effect.Parent = Attachment
local Gradient1 = Instance.new("ParticleEmitter")
Gradient1.Name = "Gradient1"
Gradient1.Lifetime = NumberRange.new(0.3, 0.3)
Gradient1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)})
Gradient1.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Gradient1.Speed = NumberRange.new(0, 0)
Gradient1.Brightness = 6
Gradient1.Size = NumberSequence.new(0, 11.6261358)
Gradient1.Enabled = false
Gradient1.ZOffset = 0.9187313
Gradient1.Rate = 50
Gradient1.Texture = "rbxassetid://8196169974"
Gradient1.Parent = Attachment
local Shards = Instance.new("ParticleEmitter")
Shards.Name = "Shards"
Shards.Lifetime = NumberRange.new(0.19, 0.7)
Shards.SpreadAngle = Vector2.new(-90, 90)
Shards.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Shards.Drag = 10
Shards.VelocitySpread = -90
Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
Shards.Brightness = 4
Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
Shards.Enabled = false
Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
Shards.ZOffset = 0.5705321
Shards.Rate = 50
Shards.Texture = "rbxassetid://8030734851"
Shards.Rotation = NumberRange.new(90, 90)
Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
Shards.Parent = Attachment
local Crescents = Instance.new("ParticleEmitter")
Crescents.Name = "Crescents"
Crescents.Lifetime = NumberRange.new(0.19, 0.38)
Crescents.SpreadAngle = Vector2.new(-360, 360)
Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
Crescents.LightEmission = 10
Crescents.Color = ColorSequence.new(Color3.fromRGB(160, 96, 255))
Crescents.VelocitySpread = -360
Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
Crescents.Brightness = 4
Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
Crescents.Enabled = false
Crescents.ZOffset = 0.4542207
Crescents.Rate = 50
Crescents.Texture = "rbxassetid://12509373457"
Crescents.RotSpeed = NumberRange.new(800, 1000)
Crescents.Rotation = NumberRange.new(-360, 360)
Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Crescents.Parent = Attachment
local ParticleEmitter2 = Instance.new("ParticleEmitter")
ParticleEmitter2.Name = "ParticleEmitter2"
ParticleEmitter2.FlipbookFramerate = NumberRange.new(20, 20)
ParticleEmitter2.Lifetime = NumberRange.new(0.19, 0.38)
ParticleEmitter2.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
ParticleEmitter2.SpreadAngle = Vector2.new(360, 360)
ParticleEmitter2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.209842, 0.5), NumberSequenceKeypoint.new(0.503842, 0.263333), NumberSequenceKeypoint.new(0.799842, 0.5), NumberSequenceKeypoint.new(1, 1)})
ParticleEmitter2.LightEmission = 1
ParticleEmitter2.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
ParticleEmitter2.VelocitySpread = 360
ParticleEmitter2.Speed = NumberRange.new(0.0161231, 0.0161231)
ParticleEmitter2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 4.3125), NumberSequenceKeypoint.new(0.3985056, 7.9375), NumberSequenceKeypoint.new(1, 10)})
ParticleEmitter2.Enabled = false
ParticleEmitter2.ZOffset = 0.15
ParticleEmitter2.Rate = 100
ParticleEmitter2.Texture = "http://www.roblox.com/asset/?id=12394566430"
ParticleEmitter2.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
ParticleEmitter2.Rotation = NumberRange.new(39, 999)
ParticleEmitter2.Orientation = Enum.ParticleOrientation.VelocityParallel
ParticleEmitter2.Parent = Attachment
Part.Parent = workspace
end
do
local Part = Instance.new("Part")
Part.Parent = ReplicatedStorage
local Attachment = Instance.new("Attachment")
Attachment.Parent = Part
HitEffectModule.Locals.Type["Coom"] = Attachment
local Foam = Instance.new("ParticleEmitter")
Foam.Name = "Foam"
Foam.LightInfluence = 0.5
Foam.Lifetime = NumberRange.new(1, 1)
Foam.SpreadAngle = Vector2.new(360, -360)
Foam.VelocitySpread = 360
Foam.Squash = NumberSequence.new(1)
Foam.Speed = NumberRange.new(20, 20)
Foam.Brightness = 2.5
Foam.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.1016692, 0.6508875, 0.6508875), NumberSequenceKeypoint.new(0.6494689, 1.4201183, 0.4127519), NumberSequenceKeypoint.new(1, 0)})
Foam.Enabled = false
Foam.Acceleration = Vector3.new(0, -66.04029846191406, 0)
Foam.Rate = 100
Foam.Texture = "rbxassetid://8297030850"
Foam.Rotation = NumberRange.new(-90, -90)
Foam.Orientation = Enum.ParticleOrientation.VelocityParallel
Foam.Parent = Attachment
Part.Parent = workspace
end
do
local Part = Instance.new("Part")
Part.Parent = ReplicatedStorage
local Attachment = Instance.new("Attachment")
Attachment.Parent = Part
HitEffectModule.Locals.Type["Slash"] = Attachment
local Crescents = Instance.new("ParticleEmitter")
Crescents.Name = "Crescents"
Crescents.Lifetime = NumberRange.new(0.19, 0.38)
Crescents.SpreadAngle = Vector2.new(-360, 360)
Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
Crescents.LightEmission = 10
Crescents.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 96, 255)), ColorSequenceKeypoint.new(0.3160622, Color3.fromRGB(160, 96, 255)), ColorSequenceKeypoint.new(0.5146805, Color3.fromRGB(154, 82, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 96, 255))})
Crescents.VelocitySpread = -360
Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
Crescents.Brightness = 4
Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
Crescents.Enabled = false
Crescents.ZOffset = 0.4542207
Crescents.Rate = 50
Crescents.Texture = "rbxassetid://12509373457"
Crescents.RotSpeed = NumberRange.new(800, 1000)
Crescents.Rotation = NumberRange.new(-360, 360)
Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Crescents.Parent = Attachment
Part.Parent = workspace
end
do
local Part = Instance.new("Part")
Part.Parent = ReplicatedStorage
local Attachment = Instance.new("Attachment")
Attachment.Parent = Part
HitEffectModule.Locals.Type["Atomic Slash"] = Attachment
local Crescents = Instance.new("ParticleEmitter")
Crescents.Name = "Crescents"
Crescents.Lifetime = NumberRange.new(0.19, 0.38)
Crescents.SpreadAngle = Vector2.new(-360, 360)
Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
Crescents.LightEmission = 10
Crescents.Color = ColorSequence.new(Color3.fromRGB(160, 96, 255))
Crescents.VelocitySpread = -360
Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
Crescents.Brightness = 4
Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
Crescents.Enabled = false
Crescents.ZOffset = 0.4542207
Crescents.Rate = 50
Crescents.Texture = "rbxassetid://12509373457"
Crescents.RotSpeed = NumberRange.new(800, 1000)
Crescents.Rotation = NumberRange.new(-360, 360)
Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Crescents.Parent = Attachment
local Glow = Instance.new("ParticleEmitter")
Glow.Name = "Glow"
Glow.Lifetime = NumberRange.new(0.16, 0.16)
Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
Glow.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Glow.Speed = NumberRange.new(0, 0)
Glow.Brightness = 5
Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
Glow.Enabled = false
Glow.ZOffset = -0.0565939
Glow.Rate = 50
Glow.Texture = "rbxassetid://8708637750"
Glow.Parent = Attachment
local Effect = Instance.new("ParticleEmitter")
Effect.Name = "Effect"
Effect.Lifetime = NumberRange.new(0.4, 0.7)
Effect.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
Effect.SpreadAngle = Vector2.new(360, -360)
Effect.LockedToPart = true
Effect.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)})
Effect.LightEmission = 1
Effect.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Effect.Drag = 1
Effect.VelocitySpread = 360
Effect.Speed = NumberRange.new(0.0036749, 0.0036749)
Effect.Brightness = 2.0999999
Effect.Size = NumberSequence.new(6.9680691, 9.9213123)
Effect.Enabled = false
Effect.ZOffset = 0.4777403
Effect.Rate = 50
Effect.Texture = "rbxassetid://9484012464"
Effect.RotSpeed = NumberRange.new(-150, -150)
Effect.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
Effect.Rotation = NumberRange.new(50, 50)
Effect.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Effect.Parent = Attachment
local Gradient1 = Instance.new("ParticleEmitter")
Gradient1.Name = "Gradient1"
Gradient1.Lifetime = NumberRange.new(0.3, 0.3)
Gradient1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)})
Gradient1.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Gradient1.Speed = NumberRange.new(0, 0)
Gradient1.Brightness = 6
Gradient1.Size = NumberSequence.new(0, 11.6261358)
Gradient1.Enabled = false
Gradient1.ZOffset = 0.9187313
Gradient1.Rate = 50
Gradient1.Texture = "rbxassetid://8196169974"
Gradient1.Parent = Attachment
local Shards = Instance.new("ParticleEmitter")
Shards.Name = "Shards"
Shards.Lifetime = NumberRange.new(0.19, 0.7)
Shards.SpreadAngle = Vector2.new(-90, 90)
Shards.Color = ColorSequence.new(Color3.fromRGB(179, 145, 253))
Shards.Drag = 10
Shards.VelocitySpread = -90
Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
Shards.Brightness = 4
Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
Shards.Enabled = false
Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
Shards.ZOffset = 0.5705321
Shards.Rate = 50
Shards.Texture = "rbxassetid://8030734851"
Shards.Rotation = NumberRange.new(90, 90)
Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
Shards.Parent = Attachment
Part.Parent = workspace
end
do
local part = Instance.new("Part")
part.Parent = ReplicatedStorage
local attachment = Instance.new("Attachment")
attachment.Name = "Attachment"
attachment.Parent = part
HitEffectModule.Locals.Type["Nova"] = attachment
local function createParticleEmitter(acceleration)
local emitter = Instance.new("ParticleEmitter")
emitter.Name = "ParticleEmitter"
emitter.Acceleration = acceleration
emitter.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(0.495, HitEffectModule.Settings.HitEffect.Color),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
emitter.Lifetime = NumberRange.new(0.5, 0.5)
emitter.LightEmission = 1
emitter.LockedToPart = true
emitter.Rate = 1
emitter.Rotation = NumberRange.new(0, 360)
emitter.Size = NumberSequence.new({
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(1, 10),
NumberSequenceKeypoint.new(1, 1)
})
emitter.Speed = NumberRange.new(0, 0)
emitter.Texture = "rbxassetid://1084991215"
emitter.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0),
NumberSequenceKeypoint.new(0, 0.1),
NumberSequenceKeypoint.new(0.534, 0.25),
NumberSequenceKeypoint.new(1, 0.5),
NumberSequenceKeypoint.new(1, 0)
})
emitter.ZOffset = 1
emitter.Parent = attachment
return emitter
end
createParticleEmitter(Vector3.new(0, 0, 1))
local perpendicularEmitter = createParticleEmitter(Vector3.new(0, 1, -0.001))
perpendicularEmitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
end
local HitEffectsSettings = {}
local lastHitEffectsTime = {}
local HitLogsSettings = {}
local lastHitLogTime = {}
do
HitEffectsSettings.Enabled = false
HitEffectsSettings.Type = "Nova"
HitEffectsSettings.FadeOut = true
HitEffectsSettings.Duration = 0.1
HitEffectsSettings.Color = Color3.fromRGB(255, 255, 255)
HitEffectModule.Settings.HitEffect.Color = HitEffectsSettings.Color
HitLogsSettings.Enabled = false
HitLogsSettings.NotificationTime = 3
end
local DamageNumberSettings = {}
local lastDamageNumberTime = {}
local HitmarkerSettings = {}
local lastHitmarkerTime = {}
local D3HitmarkerSettings = {}
local lastD3HitmarkerTime = {}
local KillMarkerSettings = {}
local lastKillMarkerTime = {}
do
DamageNumberSettings.Enabled = false
DamageNumberSettings.Color = Color3.fromRGB(255, 255, 255)
DamageNumberSettings.OutlineColor = Color3.fromRGB(0, 0, 0)
DamageNumberSettings.Preset = "Default"
DamageNumberSettings.UseTemplate = true
DamageNumberSettings.FadeOut = true
DamageNumberSettings.FlyOut = true
DamageNumberSettings.Outline = true
DamageNumberSettings.SplitDigits = true
DamageNumberSettings.Lifetime = 1.1
DamageNumberSettings.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold)
HitmarkerSettings.Enabled = false
HitmarkerSettings.Color = Color3.fromRGB(255, 255, 255)
HitmarkerSettings.Lifetime = 0.5
HitmarkerSettings.Size = 100
D3HitmarkerSettings.Enabled = false
D3HitmarkerSettings.Color = Color3.fromRGB(255, 255, 255)
D3HitmarkerSettings.OutlineColor = Color3.fromRGB(0, 0, 0)
D3HitmarkerSettings.LethalColor = Color3.fromRGB(255, 0, 0)
D3HitmarkerSettings.Thickness = 1
D3HitmarkerSettings.OutlineThickness = 3
D3HitmarkerSettings.Size = 10
D3HitmarkerSettings.Lifetime = 0.5
KillMarkerSettings.Enabled = false
KillMarkerSettings.Lifetime = 3
end
local function ApplyDamageNumberPreset(name)
if name == "Hoodcustoms" then
DamageNumberSettings.Color = Color3.fromRGB(255, 255, 255)
DamageNumberSettings.OutlineColor = Color3.fromRGB(0, 0, 0)
DamageNumberSettings.UseTemplate = true
DamageNumberSettings.FadeOut = true
DamageNumberSettings.FlyOut = true
DamageNumberSettings.Outline = true
DamageNumberSettings.SplitDigits = true
DamageNumberSettings.Lifetime = 1.1
DamageNumberSettings.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold)
else
DamageNumberSettings.Color = Color3.fromRGB(255, 255, 255)
DamageNumberSettings.OutlineColor = Color3.fromRGB(0, 0, 0)
DamageNumberSettings.UseTemplate = false
DamageNumberSettings.FadeOut = true
DamageNumberSettings.FlyOut = true
DamageNumberSettings.Outline = true
DamageNumberSettings.SplitDigits = false
DamageNumberSettings.Lifetime = 1.0
DamageNumberSettings.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
end
DamageNumberSettings.Preset = name
end
local ForceHitTracersSection = VisualsTracers
ForceHitTracersSection:AddToggle('ForceHitTracersEnabled',{Text = "Use",
Default = true,
Callback = function(Value)
if getgenv().FH_TracerConfig then
getgenv().FH_TracerConfig.Enabled = (Toggles.ForceHitTracersEnabled and Toggles.ForceHitTracersEnabled.Value)
end
end}):AddColorPicker('ForceHitTracersColor',{Title = "Start Color",
Default = Color3.fromRGB(255, 50, 50),
Callback = function(Value)
if getgenv().FH_TracerConfig then
getgenv().FH_TracerConfig.Color = Value or Color3.fromRGB(255, 50, 50)
end
end}):AddColorPicker('ForceHitTracersEndColor',{Title = "End Color",
Default = Color3.fromRGB(255, 50, 50),
Callback = function(Value)
if getgenv().FH_TracerConfig then
getgenv().FH_TracerConfig.EndColor = Value or Color3.fromRGB(255, 50, 50)
end
end})
ForceHitTracersSection:AddToggle('ForceHitTracersFadeOut',{Text = "Fade Out",
Default = true,
Callback = function(Value)
if getgenv().FH_TracerConfig then
getgenv().FH_TracerConfig.FadeOut = (Toggles.ForceHitTracersFadeOut and Toggles.ForceHitTracersFadeOut.Value)
end
end})
ForceHitTracersSection:AddToggle('ForceHitTracersGradient', {
Text = "Use Gradient",
Default = false,
Callback = function(Value)
if getgenv().FH_TracerConfig then
getgenv().FH_TracerConfig.UseGradient = (Toggles.ForceHitTracersGradient and Toggles.ForceHitTracersGradient.Value)
end
end
})
ForceHitTracersSection:AddToggle('ForceHitTracersUseSpread',{Text = "Use Spread",
Default = true,
Callback = function(Value)
if getgenv().FH_TracerConfig then
getgenv().FH_TracerConfig.UseSpread = (Toggles.ForceHitTracersUseSpread and Toggles.ForceHitTracersUseSpread.Value)
end
end})
ForceHitTracersSection:AddSlider('ForceHitTracersLifetime',{Text = "Lifetime",
Min = 0.1,
Max = 5,
Default = 0.8,
Rounding = 1,
Callback = function(Value)
if getgenv().FH_TracerConfig then
getgenv().FH_TracerConfig.Lifetime = (Options.ForceHitTracersLifetime and Options.ForceHitTracersLifetime.Value) or 2
end
end})
ForceHitTracersSection:AddDropdown('ForceHitTracersTexture',{Text = "Tracer Texture",
Values = {"Default", "Hoodcustoms", "laser", "light", "flow", "Drawing"},
Default = "Hoodcustoms",
Callback = function(Value)
if getgenv().FH_TracerConfig then
local cfg = getgenv().FH_TracerConfig
local selected = (Options.ForceHitTracersTexture and Options.ForceHitTracersTexture.Value) or "Hoodcustoms"
cfg.TextureName = selected
if selected == "Drawing" then
cfg.Mode = "Drawing"
else
cfg.Mode = "Beam"
local textureMap = {
["Default"] = "rbxassetid://130791043",
["Hoodcustoms"] = "rbxassetid://130791043",
["laser"] = "rbxassetid://12781800668",
["light"] = "rbxassetid://2382169232",
["flow"] = "rbxassetid://12788927812"
}
cfg.Texture = textureMap[selected] or textureMap["Default"]
end
end
end})
-- Standalone ForceHit bullet tracer renderer.
do
if not getgenv().FH_TracerConfig then
getgenv().FH_TracerConfig = {
Enabled = true,
Color = Color3.fromRGB(255, 50, 50),
EndColor = Color3.fromRGB(255, 50, 50),
FadeOut = true,
UseGradient = false,
UseSpread = true,
Lifetime = 0.8,
TextureName = "Hoodcustoms",
Texture = "rbxassetid://130791043",
Mode = "Beam",
}
end
local TracerFolder = Instance.new("Folder")
TracerFolder.Name = "ForceHitTracers"
TracerFolder.Parent = workspace
local function FadeOutBeam(beam, partA, partB, lifetime)
local start = tick()
while tick() - start < lifetime do
local t = (tick() - start) / lifetime
beam.Transparency = NumberSequence.new(t, t)
task.wait(0.05)
end
partA:Destroy()
partB:Destroy()
beam:Destroy()
end
local function DrawBeamTracer(startPos, endPos, cfg)
local children = TracerFolder:GetChildren()
if #children > 30 then
for i = 1, #children - 30 do
children[i]:Destroy()
end
end
local partA = Instance.new("Part")
partA.Anchored = true
partA.CanCollide = false
partA.Transparency = 1
partA.Size = Vector3.new(0.1, 0.1, 0.1)
partA.CFrame = CFrame.new(startPos)
partA.Parent = TracerFolder
local partB = Instance.new("Part")
partB.Anchored = true
partB.CanCollide = false
partB.Transparency = 1
partB.Size = Vector3.new(0.1, 0.1, 0.1)
partB.CFrame = CFrame.new(endPos)
partB.Parent = TracerFolder
local attA = Instance.new("Attachment")
attA.Parent = partA
local attB = Instance.new("Attachment")
attB.Parent = partB
local beam = Instance.new("Beam")
beam.Attachment0 = attA
beam.Attachment1 = attB
local startColor = cfg.Color or Color3.fromRGB(255, 50, 50)
local endColor = cfg.UseGradient and (cfg.EndColor or startColor) or startColor
beam.Color = ColorSequence.new(startColor, endColor)
beam.Texture = cfg.Texture or "rbxassetid://130791043"
beam.TextureMode = Enum.TextureMode.Wrap
beam.TextureLength = 5
beam.Width0 = 0.5
beam.Width1 = 0.5
beam.FaceCamera = true
beam.LightEmission = 1
beam.LightInfluence = 0
local t0 = cfg.UseGradient and 0 or 0
local t1 = cfg.UseGradient and 1 or 0
beam.Transparency = NumberSequence.new(t0, t1)
beam.Parent = TracerFolder
if cfg.FadeOut then
task.spawn(FadeOutBeam, beam, partA, partB, cfg.Lifetime or 2)
else
task.delay(cfg.Lifetime or 2, function()
partA:Destroy()
partB:Destroy()
beam:Destroy()
end)
end
end
local function DrawLineTracer(startPos, endPos, cfg)
local line = Drawing.new("Line")
line.Color = cfg.Color or Color3.fromRGB(255, 50, 50)
line.Thickness = 1
line.Transparency = 1
line.Visible = true
local cam = Camera
local vSize = cam.ViewportSize
local cx, cy = vSize.X / 2, vSize.Y / 2
local function getScreen(p)
local pos, on = cam:WorldToViewportPoint(p)
if pos.Z < 0 then
pos = Vector3.new(
math.clamp(cx + (cx - pos.X), 0, vSize.X),
math.clamp(cy + (cy - pos.Y), 0, vSize.Y),
pos.Z
)
end
return Vector2.new(pos.X, pos.Y), on or pos.Z > 0
end
local elapsed = 0
local conn
conn = RunService.RenderStepped:Connect(function(dt)
elapsed = elapsed + dt
local s, onS = getScreen(startPos)
local e, onE = getScreen(endPos)
if onS or onE then
line.Visible = true
line.From = s
line.To = e
if elapsed > (cfg.Lifetime or 0.8) then
local fade = math.clamp((elapsed - (cfg.Lifetime or 0.8)) / 0.3, 0, 1)
line.Transparency = 1 - fade
if fade >= 1 then
conn:Disconnect()
line:Destroy()
end
end
else
line.Visible = false
end
end)
end
local function DrawTracer(startPos, endPos)
local cfg = getgenv().FH_TracerConfig
if not cfg or not cfg.Enabled then return end
if (startPos - endPos).Magnitude < 0.1 then return end
if cfg.Mode == "Drawing" then
DrawLineTracer(startPos, endPos, cfg)
else
DrawBeamTracer(startPos, endPos, cfg)
end
end
local BulletRayConnection = nil
local function ProcessBulletRay(beam)
if beam.Name ~= "BULLET_RAYS" or not beam:IsA("Beam") then return end
if beam:GetAttribute("OwnerCharacter") ~= LocalPlayer.Name then return end
local cfg = getgenv().FH_TracerConfig
if not cfg or not cfg.Enabled then return end
local att0 = beam.Attachment0
local att1 = beam.Attachment1
if not att0 or not att1 then return end
local startPos = att0.WorldPosition
local endPos = att1.WorldPosition
if (startPos - endPos).Magnitude < 0.1 then return end
task.defer(function()
beam:Destroy()
end)
DrawTracer(startPos, endPos)
end
local function DestroyDefaultBulletRays()
local cfg = getgenv().FH_TracerConfig
if not cfg or not cfg.Enabled then return end
for _, desc in ipairs(workspace:GetDescendants()) do
if desc.Name == "BULLET_RAYS" then
pcall(function() desc:Destroy() end)
end
end
end
local function HookBulletRays()
if BulletRayConnection then
BulletRayConnection:Disconnect()
BulletRayConnection = nil
end
BulletRayConnection = workspace.DescendantAdded:Connect(function(child)
if child.Name == "BULLET_RAYS" and child:IsA("Beam") then
ProcessBulletRay(child)
end
end)
end
DestroyDefaultBulletRays()
HookBulletRays()
end
do
local WorldSection = VisualsWorld
local WorldSettings = {
FogEnabled = false,
FogColor = Color3.fromRGB(192, 192, 192),
FogStart = 0,
FogEnd = 100000,
AmbientEnabled = false,
Ambient = Color3.fromRGB(70, 70, 70),
OutdoorAmbient = Color3.fromRGB(140, 140, 140),
SkyboxEnabled = false,
SkyboxChoice = "black storm",
TimeEnabled = false,
TimeValue = 14,
SunEnabled = false,
SunTextureId = "",
MoonEnabled = false,
BloomEnabled = false,
BloomIntensity = 0.75,
BloomSize = 24,
BloomThreshold = 1,
ColorCorrectionEnabled = false,
CCBrightness = 0,
CCContrast = 0,
CCSaturation = 0,
CCTintColor = Color3.fromRGB(255, 255, 255),
WeatherEnabled = false,
WeatherType = "rain",
WeatherColor = Color3.fromRGB(255, 255, 255),
WeatherRate = 100,
WeatherSoundEnabled = true,
WeatherSound = "Rain 1",
WeatherVolume = 0.5,
}
local Lighting = game:GetService("Lighting")
local OriginalLighting = {
FogColor = Lighting.FogColor,
FogStart = Lighting.FogStart,
FogEnd = Lighting.FogEnd,
Ambient = Lighting.Ambient,
OutdoorAmbient = Lighting.OutdoorAmbient,
Brightness = Lighting.Brightness,
ClockTime = Lighting.ClockTime,
}
local bloomEffect = nil
local colorCorrectionEffect = nil
local function getOrCreateEffect(className, name)
local existing = Lighting:FindFirstChild(name)
if existing then return existing end
local effect = Instance.new(className)
effect.Name = name
effect.Parent = Lighting
return effect
end
WorldSection:AddToggle('FogEnabled',{Text = "Custom Fog",
Default = false,
Callback = function(Value)
WorldSettings.FogEnabled = (Toggles.FogEnabled and Toggles.FogEnabled.Value)
if not WorldSettings.FogEnabled then
Lighting.FogColor = OriginalLighting.FogColor
Lighting.FogStart = OriginalLighting.FogStart
Lighting.FogEnd = OriginalLighting.FogEnd
end
end}):AddColorPicker('FogColor',{Title = "Fog Color",
Default = Color3.fromRGB(192, 192, 192),
Callback = function(Value)
WorldSettings.FogColor = (Value and Value) or Color3.fromRGB(192, 192, 192)
if WorldSettings.FogEnabled then
Lighting.FogColor = WorldSettings.FogColor
end
end})
WorldSection:AddSlider('FogStart',{Text = "Fog Start",
Min = 0,
Max = 10000,
Default = 0,
Rounding = 0,
Callback = function(Value)
WorldSettings.FogStart = (Options.FogStart and Options.FogStart.Value) or 0
if WorldSettings.FogEnabled then
Lighting.FogStart = WorldSettings.FogStart
end
end})
WorldSection:AddSlider('FogEnd',{Text = "Fog End",
Min = 100,
Max = 100000,
Default = 100000,
Rounding = 0,
Callback = function(Value)
WorldSettings.FogEnd = (Options.FogEnd and Options.FogEnd.Value) or 100000
if WorldSettings.FogEnabled then
Lighting.FogEnd = WorldSettings.FogEnd
end
end})
WorldSection:AddToggle('AmbientEnabled',{Text = "Custom Ambient",
Default = false,
Callback = function(Value)
WorldSettings.AmbientEnabled = (Toggles.AmbientEnabled and Toggles.AmbientEnabled.Value)
if not WorldSettings.AmbientEnabled then
Lighting.Ambient = OriginalLighting.Ambient
Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
end
end}):AddColorPicker('AmbientColor',{Title = "Ambient Color",
Default = Color3.fromRGB(70, 70, 70),
Callback = function(Value)
WorldSettings.Ambient = (Value and Value) or Color3.fromRGB(70, 70, 70)
if WorldSettings.AmbientEnabled then
Lighting.Ambient = WorldSettings.Ambient
end
end})
WorldSection:AddToggle('OutdoorAmbientEnabled',{Text = "Custom Outdoor Ambient",
Default = false,
Callback = function(Value) end}):AddColorPicker('OutdoorAmbientColor',{Title = "Outdoor Ambient",
Default = Color3.fromRGB(140, 140, 140),
Callback = function(Value)
WorldSettings.OutdoorAmbient = (Value and Value) or Color3.fromRGB(140, 140, 140)
if (Toggles.OutdoorAmbientEnabled and Toggles.OutdoorAmbientEnabled.Value) then
Lighting.OutdoorAmbient = WorldSettings.OutdoorAmbient
end
end})
WorldSection:AddToggle('TimeEnabled',{Text = "Custom Time",
Default = false,
Callback = function(Value)
WorldSettings.TimeEnabled = (Toggles.TimeEnabled and Toggles.TimeEnabled.Value)
if not WorldSettings.TimeEnabled then
Lighting.ClockTime = OriginalLighting.ClockTime
end
end})
WorldSection:AddSlider('TimeOfDay',{Text = "Time of Day",
Min = 0,
Max = 24,
Default = 14,
Rounding = 1,
Callback = function(Value)
WorldSettings.TimeValue = (Options.TimeOfDay and Options.TimeOfDay.Value) or 14
if WorldSettings.TimeEnabled then
Lighting.ClockTime = WorldSettings.TimeValue
end
end})
WorldSection:AddToggle('BloomEnabled',{Text = "Bloom",
Default = false,
Callback = function(Value)
WorldSettings.BloomEnabled = (Toggles.BloomEnabled and Toggles.BloomEnabled.Value)
if WorldSettings.BloomEnabled then
bloomEffect = getOrCreateEffect("BloomEffect", "CustomBloom")
bloomEffect.Intensity = WorldSettings.BloomIntensity
bloomEffect.Size = WorldSettings.BloomSize
bloomEffect.Threshold = WorldSettings.BloomThreshold
bloomEffect.Enabled = true
else
if bloomEffect then bloomEffect.Enabled = false end
end
end})
WorldSection:AddSlider('BloomIntensity',{Text = "Bloom Intensity",
Min = 0,
Max = 5,
Default = 0.75,
Rounding = 2,
Callback = function(Value)
WorldSettings.BloomIntensity = (Options.BloomIntensity and Options.BloomIntensity.Value) or 0.75
if bloomEffect and WorldSettings.BloomEnabled then
bloomEffect.Intensity = WorldSettings.BloomIntensity
end
end})
WorldSection:AddSlider('BloomSize',{Text = "Bloom Size",
Min = 1,
Max = 56,
Default = 24,
Rounding = 0,
Callback = function(Value)
WorldSettings.BloomSize = (Options.BloomSize and Options.BloomSize.Value) or 24
if bloomEffect and WorldSettings.BloomEnabled then
bloomEffect.Size = WorldSettings.BloomSize
end
end})
WorldSection:AddSlider('BloomThreshold',{Text = "Bloom Threshold",
Min = 0,
Max = 2,
Default = 1,
Rounding = 1,
Callback = function(Value)
WorldSettings.BloomThreshold = (Options.BloomThreshold and Options.BloomThreshold.Value) or 1
if bloomEffect and WorldSettings.BloomEnabled then
bloomEffect.Threshold = WorldSettings.BloomThreshold
end
end})
WorldSection:AddToggle('ColorCorrectionEnabled',{Text = "Color Correction",
Default = false,
Callback = function(Value)
WorldSettings.ColorCorrectionEnabled = (Toggles.ColorCorrectionEnabled and Toggles.ColorCorrectionEnabled.Value)
if WorldSettings.ColorCorrectionEnabled then
colorCorrectionEffect = getOrCreateEffect("ColorCorrectionEffect", "CustomColorCorrection")
colorCorrectionEffect.Brightness = WorldSettings.CCBrightness
colorCorrectionEffect.Contrast = WorldSettings.CCContrast
colorCorrectionEffect.Saturation = WorldSettings.CCSaturation
colorCorrectionEffect.TintColor = WorldSettings.CCTintColor
colorCorrectionEffect.Enabled = true
else
if colorCorrectionEffect then colorCorrectionEffect.Enabled = false end
end
end}):AddColorPicker('CCTintColor',{Title = "Tint Color",
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
WorldSettings.CCTintColor = (Value and Value) or Color3.fromRGB(255, 255, 255)
if colorCorrectionEffect and WorldSettings.ColorCorrectionEnabled then
colorCorrectionEffect.TintColor = WorldSettings.CCTintColor
end
end})
WorldSection:AddSlider('CCBrightness',{Text = "CC Brightness",
Min = -1,
Max = 1,
Default = 0,
Rounding = 2,
Callback = function(Value)
WorldSettings.CCBrightness = (Options.CCBrightness and Options.CCBrightness.Value) or 0
if colorCorrectionEffect and WorldSettings.ColorCorrectionEnabled then
colorCorrectionEffect.Brightness = WorldSettings.CCBrightness
end
end})
WorldSection:AddSlider('CCContrast',{Text = "CC Contrast",
Min = -1,
Max = 1,
Default = 0,
Rounding = 2,
Callback = function(Value)
WorldSettings.CCContrast = (Options.CCContrast and Options.CCContrast.Value) or 0
if colorCorrectionEffect and WorldSettings.ColorCorrectionEnabled then
colorCorrectionEffect.Contrast = WorldSettings.CCContrast
end
end})
WorldSection:AddSlider('CCSaturation',{Text = "CC Saturation",
Min = -1,
Max = 1,
Default = 0,
Rounding = 2,
Callback = function(Value)
WorldSettings.CCSaturation = (Options.CCSaturation and Options.CCSaturation.Value) or 0
if colorCorrectionEffect and WorldSettings.ColorCorrectionEnabled then
colorCorrectionEffect.Saturation = WorldSettings.CCSaturation
end
end})
-- Skybox
local skyboxOriginal = nil
local skyboxes = {
["black storm"] = {
["SkyboxLf"] = "rbxassetid://15502507918",
["SkyboxUp"] = "rbxassetid://15502511911",
["SkyboxRt"] = "rbxassetid://15502509398",
["SkyboxFt"] = "rbxassetid://15502510289",
["SkyboxDn"] = "rbxassetid://15502508460",
["SkyboxBk"] = "rbxassetid://15502511288"
},
["blue space"] = {
["SkyboxLf"] = "rbxassetid://15536114370",
["SkyboxUp"] = "rbxassetid://15536117282",
["SkyboxRt"] = "rbxassetid://15536118762",
["SkyboxFt"] = "rbxassetid://15536116141",
["SkyboxDn"] = "rbxassetid://15536112543",
["SkyboxBk"] = "rbxassetid://15536110634"
},
["realistic"] = {
["SkyboxUp"] = "rbxassetid://653719321",
["SkyboxDn"] = "rbxassetid://653718790",
["SkyboxLf"] = "rbxassetid://653719190",
["SkyboxFt"] = "rbxassetid://653719067",
["SkyboxRt"] = "rbxassetid://653718931",
["SkyboxBk"] = "rbxassetid://653719502"
},
["stormy"] = {
["SkyboxUp"] = "http://www.roblox.com/asset/?id=18703232671",
["SkyboxBk"] = "http://www.roblox.com/asset/?id=18703245834",
["SkyboxLf"] = "http://www.roblox.com/asset/?id=18703237556",
["SkyboxDn"] = "http://www.roblox.com/asset/?id=18703243349",
["SkyboxFt"] = "http://www.roblox.com/asset/?id=18703240532",
["SkyboxRt"] = "http://www.roblox.com/asset/?id=18703235430"
},
["pink"] = {
["SkyboxUp"] = "rbxassetid://12216108877",
["SkyboxLf"] = "rbxassetid://12216110170",
["SkyboxRt"] = "rbxassetid://12216110471",
["SkyboxFt"] = "rbxassetid://12216109489",
["SkyboxBk"] = "rbxassetid://12216109205",
["SkyboxDn"] = "rbxassetid://12216109875"
}
}
local function getSky()
local sky = Lighting:FindFirstChildOfClass("Sky")
if not sky then
sky = Instance.new("Sky")
sky.Name = "CustomSky"
sky.Parent = Lighting
end
return sky
end
local function applySkybox(name)
local sky = getSky()
if not skyboxOriginal then
skyboxOriginal = {
SkyboxBk = sky.SkyboxBk,
SkyboxDn = sky.SkyboxDn,
SkyboxFt = sky.SkyboxFt,
SkyboxLf = sky.SkyboxLf,
SkyboxRt = sky.SkyboxRt,
SkyboxUp = sky.SkyboxUp
}
end
if name == "default" or not WorldSettings.SkyboxEnabled then
for prop, id in pairs(skyboxOriginal) do
sky[prop] = id
end
return
end
local ids = skyboxes[name]
if not ids then return end
sky.SkyboxBk = ids.SkyboxBk
sky.SkyboxDn = ids.SkyboxDn
sky.SkyboxFt = ids.SkyboxFt
sky.SkyboxLf = ids.SkyboxLf
sky.SkyboxRt = ids.SkyboxRt
sky.SkyboxUp = ids.SkyboxUp
end
WorldSection:AddToggle('SkyboxEnabled',{Text = "Skybox",
Default = false,
Callback = function(Value)
WorldSettings.SkyboxEnabled = Value
applySkybox(Value and WorldSettings.SkyboxChoice or "default")
end})
WorldSection:AddDropdown('SkyboxChoice',{Text = "Sky",
Values = {"black storm", "blue space", "realistic", "stormy", "pink"},
Default = "black storm",
Callback = function(Value)
WorldSettings.SkyboxChoice = Value
if WorldSettings.SkyboxEnabled then
applySkybox(Value)
end
end})
-- Weather
local weatherPart = nil
local weatherParticle = nil
local weatherConnection = nil
local weatherSound = nil
local weatherTypes = {
["rain"] = {
Speed = NumberRange.new(60, 60),
LockedToPart = true,
Rate = 600,
Texture = "rbxassetid://1822883048",
EmissionDirection = Enum.NormalId.Bottom,
Transparency = NumberSequence.new{
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(0.25, 0.7842668294906616),
NumberSequenceKeypoint.new(0.75, 0.7842668294906616),
NumberSequenceKeypoint.new(1, 1)
},
Lifetime = NumberRange.new(0.800000011920929, 0.800000011920929),
LightEmission = 0.05000000074505806,
LightInfluence = 0.8999999761581421,
Orientation = Enum.ParticleOrientation.FacingCameraWorldUp,
Size = NumberSequence.new{
NumberSequenceKeypoint.new(0, 10),
NumberSequenceKeypoint.new(1, 10)
}
},
["snow"] = {
Transparency = NumberSequence.new{
NumberSequenceKeypoint.new(0, 0.7374999523162842),
NumberSequenceKeypoint.new(0.973, 0.768750011920929),
NumberSequenceKeypoint.new(1, 1)
},
Texture = "http://www.roblox.com/asset/?id=99851851",
SpreadAngle = Vector2.new(50, 50),
Speed = NumberRange.new(30, 30),
LightEmission = 0.5,
Rate = 1000,
EmissionDirection = Enum.NormalId.Bottom,
Size = NumberSequence.new{
NumberSequenceKeypoint.new(0, 0.33096909523010254),
NumberSequenceKeypoint.new(0.551, 0.40189146995544434),
NumberSequenceKeypoint.new(1, 0.33096909523010254)
}
},
["light rain"] = {
LockedToPart = true,
Rate = 500,
Squash = NumberSequence.new{
NumberSequenceKeypoint.new(0, 3),
NumberSequenceKeypoint.new(1, 3)
},
LightInfluence = 0.30000001192092896,
Transparency = NumberSequence.new{
NumberSequenceKeypoint.new(0, 0),
NumberSequenceKeypoint.new(0.435, 0),
NumberSequenceKeypoint.new(1, 0)
},
Texture = "rbxasset://textures/particles/sparkles_main.dds",
Speed = NumberRange.new(30, 50),
Lifetime = NumberRange.new(9, 9),
LightEmission = 0.5,
Brightness = 2,
EmissionDirection = Enum.NormalId.Bottom,
Orientation = Enum.ParticleOrientation.FacingCameraWorldUp,
Size = NumberSequence.new{
NumberSequenceKeypoint.new(0, 0.20000000298023224),
NumberSequenceKeypoint.new(1, 0.20000000298023224)
}
}
}
local weatherSounds = {
["Rain 1"] = "rbxassetid://1516791621",
["Rain 2"] = "rbxassetid://138911277964858",
["Light Rain"] = "rbxassetid://18862087062",
["Thunder"] = "rbxassetid://88290426489497",
["windy winter"] = "rbxassetid://6046340391",
["thunderstorm"] = "rbxassetid://4305545740",
["night"] = "rbxassetid://179507208",
["day"] = "rbxassetid://6189453706",
}
local weatherOffset = Vector3.new(0, 20, 0)
local function updateWeatherSound()
if weatherSound then
weatherSound:Destroy()
weatherSound = nil
end
if not WorldSettings.WeatherEnabled then return end
if not WorldSettings.WeatherSoundEnabled then return end
if not weatherPart then return end
local noise = (Options.WeatherNoise and Options.WeatherNoise.Value) or "Rain 1"
WorldSettings.WeatherSound = noise
local soundId = weatherSounds[noise]
if not soundId then return end
weatherSound = Instance.new("Sound")
weatherSound.Name = "WeatherAmbient"
weatherSound.SoundId = soundId
weatherSound.Looped = true
weatherSound.Volume = WorldSettings.WeatherVolume
weatherSound.Parent = weatherPart
weatherSound:Play()
end
VisualsWeather:AddToggle('WeatherEnabled',{Text = "Weather",
Default = false,
Callback = function(Value)
WorldSettings.WeatherEnabled = Value
if weatherPart then
weatherPart:Destroy()
weatherPart = nil
weatherParticle = nil
end
if weatherConnection then
weatherConnection:Disconnect()
weatherConnection = nil
end
if weatherSound then
weatherSound:Destroy()
weatherSound = nil
end
if WorldSettings.WeatherEnabled then
weatherPart = Instance.new("Part")
weatherPart.Size = Vector3.new(40, 40, 85)
weatherPart.CanCollide = false
weatherPart.Massless = true
weatherPart.CastShadow = false
weatherPart.Transparency = 1
weatherPart.Anchored = true
weatherPart.Name = "WeatherPart"
weatherPart.Parent = workspace
local weatherType = (Options.WeatherType and Options.WeatherType.Value) or "rain"
local data = weatherTypes[weatherType]
weatherParticle = Instance.new("ParticleEmitter")
for prop, val in pairs(data) do
weatherParticle[prop] = val
end
weatherParticle.Color = ColorSequence.new((Options.WeatherColor and Options.WeatherColor.Value) or Color3.fromRGB(255, 255, 255))
weatherParticle.Rate = ((Options.WeatherRate and Options.WeatherRate.Value) or 100) * 10
weatherParticle.Parent = weatherPart
weatherConnection = RunService.Heartbeat:Connect(function()
if weatherPart and Camera then
weatherPart.CFrame = CFrame.new(Camera.CFrame.Position) + weatherOffset
end
end)
updateWeatherSound()
end
end}):AddColorPicker('WeatherColor',{Title = "Weather Color",
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
WorldSettings.WeatherColor = Value or Color3.fromRGB(255, 255, 255)
if weatherParticle then
weatherParticle.Color = ColorSequence.new(WorldSettings.WeatherColor)
end
end})
VisualsWeather:AddDropdown('WeatherType',{Text = "Weather Type",
Values = {"light rain", "rain", "snow"},
Default = "rain",
Callback = function(Value)
if weatherParticle then
weatherParticle:Destroy()
weatherParticle = nil
local data = weatherTypes[Value]
weatherParticle = Instance.new("ParticleEmitter")
for prop, val in pairs(data) do
weatherParticle[prop] = val
end
weatherParticle.Color = ColorSequence.new((Options.WeatherColor and Options.WeatherColor.Value) or Color3.fromRGB(255, 255, 255))
weatherParticle.Rate = ((Options.WeatherRate and Options.WeatherRate.Value) or 100) * 10
weatherParticle.Parent = weatherPart
end
updateWeatherSound()
end})
VisualsWeather:AddSlider('WeatherRate',{Text = "Weather Rate",
Min = 1,
Max = 100,
Default = 100,
Rounding = 0,
Callback = function(Value)
if weatherParticle then
weatherParticle.Rate = Value * 10
end
end})
VisualsWeather:AddToggle('WeatherSoundsEnabled',{Text = "Background Noise",
Default = true,
Callback = function(Value)
WorldSettings.WeatherSoundEnabled = Value
updateWeatherSound()
end})
VisualsWeather:AddDropdown('WeatherNoise',{Text = "Noises",
Values = {"Rain 1", "Rain 2", "Light Rain", "Thunder", "windy winter", "thunderstorm", "night", "day"},
Default = "Rain 1",
Callback = function(Value)
WorldSettings.WeatherSound = Value
updateWeatherSound()
end})
VisualsWeather:AddSlider('WeatherVolume',{Text = "Sound Volume",
Min = 0,
Max = 1,
Default = 0.5,
Rounding = 2,
Callback = function(Value)
WorldSettings.WeatherVolume = Value
if weatherSound then
weatherSound.Volume = Value
end
end})
RunService.Heartbeat:Connect(function()
if WorldSettings.FogEnabled then
Lighting.FogColor = WorldSettings.FogColor
Lighting.FogStart = WorldSettings.FogStart
Lighting.FogEnd = WorldSettings.FogEnd
end
if WorldSettings.AmbientEnabled then
Lighting.Ambient = WorldSettings.Ambient
end
if WorldSettings.TimeEnabled then
Lighting.ClockTime = WorldSettings.TimeValue
end
end)
end
do
local HitChamsSection = VisualsHitChams
HitChamsSection:AddToggle('HitChamsEnabled',{Text = "Hit Chams",
Default = false,
Callback = function(Value)
HitChamsSettings.Enabled = (Toggles.HitChamsEnabled and Toggles.HitChamsEnabled.Value)
end}):AddColorPicker('HitChamsColor',{Title = "Hit Chams Color",
Default = Color3.fromRGB(0, 255, 255),
Callback = function(Value)
HitChamsSettings.Color = (Value and Value) or Color3.fromRGB(0, 255, 255)
end})
HitChamsSection:AddSlider('HitChamsDuration',{Text = "Duration",
Min = 0.1,
Max = 10,
Default = 0.5,
Rounding = 1,
Suffix = "s",
Callback = function(Value)
HitChamsSettings.Duration = (Options.HitChamsDuration and Options.HitChamsDuration.Value) or 0.5
end})
HitChamsSection:AddSlider('HitChamsTransparency',{Text = "Transparency",
Min = 0.0,
Max = 1.0,
Default = 0.3,
Rounding = 1,
Callback = function(Value)
HitChamsSettings.Transparency = (Options.HitChamsTransparency and Options.HitChamsTransparency.Value) or 0.3
end})
HitChamsSection:AddToggle('HitChamsFadeOut', {
Text = "Fade Out",
Default = false,
Callback = function(Value)
HitChamsSettings.FadeOut = (Toggles.HitChamsFadeOut and Toggles.HitChamsFadeOut.Value)
end
})
HitChamsSection:AddDropdown('HitChamsMaterial', {
Text = "Material",
Values = {"Neon", "ForceField", "Glass", "SmoothPlastic", "Metal"},
Default = "Neon",
Callback = function(Value)
HitChamsSettings.Material = Enum.Material[(Options.HitChamsMaterial and Options.HitChamsMaterial.Value) or "Neon"]
end
})
local D3HitmarkerSection = Visuals3DHitmarker
D3HitmarkerSection:AddToggle('D3HitmarkerEnabled',{Text = "3D Hitmarker",
Default = false,
Callback = function(Value)
D3HitmarkerSettings.Enabled = (Toggles.D3HitmarkerEnabled and Toggles.D3HitmarkerEnabled.Value)
end}):AddColorPicker('D3HitmarkerColor',{Title = "Color",
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
D3HitmarkerSettings.Color = Value or Color3.fromRGB(255, 255, 255)
end}):AddColorPicker('D3HitmarkerOutlineColor',{Title = "Outline",
Default = Color3.fromRGB(0, 0, 0),
Callback = function(Value)
D3HitmarkerSettings.OutlineColor = Value or Color3.fromRGB(0, 0, 0)
end})
D3HitmarkerSection:AddLabel('Lethal Color'):AddColorPicker('D3HitmarkerLethalColor',{
Title = "Lethal Color",
Default = Color3.fromRGB(255, 0, 0),
Callback = function(Value)
D3HitmarkerSettings.LethalColor = Value or Color3.fromRGB(255, 0, 0)
end})
D3HitmarkerSection:AddSlider('D3HitmarkerThickness',{Text = "Thickness",
Min = 1,
Max = 10,
Default = 1,
Rounding = 0,
Callback = function(Value)
D3HitmarkerSettings.Thickness = (Options.D3HitmarkerThickness and Options.D3HitmarkerThickness.Value) or 1
end})
D3HitmarkerSection:AddSlider('D3HitmarkerOutlineThickness',{Text = "Outline Thickness",
Min = 1,
Max = 15,
Default = 3,
Rounding = 0,
Callback = function(Value)
D3HitmarkerSettings.OutlineThickness = (Options.D3HitmarkerOutlineThickness and Options.D3HitmarkerOutlineThickness.Value) or 3
end})
D3HitmarkerSection:AddSlider('D3HitmarkerSize',{Text = "Size",
Min = 4,
Max = 40,
Default = 10,
Rounding = 0,
Callback = function(Value)
D3HitmarkerSettings.Size = (Options.D3HitmarkerSize and Options.D3HitmarkerSize.Value) or 10
end})
D3HitmarkerSection:AddSlider('D3HitmarkerLifetime',{Text = "Lifetime",
Min = 0.1,
Max = 3,
Default = 0.5,
Rounding = 1,
Suffix = "s",
Callback = function(Value)
D3HitmarkerSettings.Lifetime = (Options.D3HitmarkerLifetime and Options.D3HitmarkerLifetime.Value) or 0.5
end})
local HitEffectsSection = VisualsHitEffects
HitEffectsSection:AddToggle('HitEffectsEnabled',{Text = "Hit Effects",
Default = false,
Callback = function(Value)
HitEffectsSettings.Enabled = (Toggles.HitEffectsEnabled and Toggles.HitEffectsEnabled.Value)
end}):AddColorPicker('HitEffectsColor',{Title = "Hit Effect Color",
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
HitEffectsSettings.Color = Value or Color3.fromRGB(255, 255, 255)
HitEffectModule.Settings.HitEffect.Color = HitEffectsSettings.Color
end})
HitEffectsSection:AddSlider('HitEffectDuration', {
Text = "Effect Duration",
Min = 0.1,
Max = 3,
Default = 0.1,
Rounding = 1,
Suffix = "s",
Callback = function(Value)
HitEffectsSettings.Duration = (Options.HitEffectDuration and Options.HitEffectDuration.Value) or 0.1
end
})
HitEffectsSection:AddDropdown('HitEffectType',{Text = "Hit Effect Type",
Values = {"Nova", "Crescent Slash", "Coom", "Cosmic Explosion", "Slash", "Atomic Slash", "Particles"},
Default = "Nova",
Callback = function(Value)
HitEffectsSettings.Type = (Options.HitEffectType and Options.HitEffectType.Value) or "Nova"
end})
HitEffectsSection:AddToggle('HitEffectsFadeOut', {
Text = "Fade Out",
Default = true,
Callback = function(Value)
HitEffectsSettings.FadeOut = (Toggles.HitEffectsFadeOut and Toggles.HitEffectsFadeOut.Value)
end
})
local HitIndicatorsSection = VisualsHitIndicators
HitIndicatorsSection:AddToggle('DamageNumbersEnabled',{Text = "Damage Numbers",
Default = false,
Callback = function(Value)
DamageNumberSettings.Enabled = (Toggles.DamageNumbersEnabled and Toggles.DamageNumbersEnabled.Value)
end}):AddColorPicker('DamageNumbersColor',{Title = "Damage Number Color",
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value)
DamageNumberSettings.Color = Value or Color3.fromRGB(255, 255, 255)
end})
HitIndicatorsSection:AddDropdown('DamageNumbersPreset',{Text = "Preset",
Values = {"Default", "Hoodcustoms"},
Default = "Default",
Callback = function(Value)
ApplyDamageNumberPreset((Options.DamageNumbersPreset and Options.DamageNumbersPreset.Value) or "Default")
end})
HitIndicatorsSection:AddToggle('DamageNumbersUseTemplate',{Text = "Use Native Template",
Default = true,
Callback = function(Value)
DamageNumberSettings.UseTemplate = (Toggles.DamageNumbersUseTemplate and Toggles.DamageNumbersUseTemplate.Value)
end})
HitIndicatorsSection:AddToggle('DamageNumbersFadeOut',{Text = "Fade Out",
Default = true,
Callback = function(Value)
DamageNumberSettings.FadeOut = (Toggles.DamageNumbersFadeOut and Toggles.DamageNumbersFadeOut.Value)
end})
HitIndicatorsSection:AddToggle('DamageNumbersFlyOut',{Text = "Fly Out",
Default = true,
Callback = function(Value)
DamageNumberSettings.FlyOut = (Toggles.DamageNumbersFlyOut and Toggles.DamageNumbersFlyOut.Value)
end})
HitIndicatorsSection:AddToggle('DamageNumbersOutline',{Text = "Outline",
Default = true,
Callback = function(Value)
DamageNumberSettings.Outline = (Toggles.DamageNumbersOutline and Toggles.DamageNumbersOutline.Value)
end})
HitIndicatorsSection:AddSlider('DamageNumbersLifetime',{Text = "Lifetime",
Min = 0.2,
Max = 3,
Default = 1.1,
Rounding = 1,
Suffix = "s",
Callback = function(Value)
DamageNumberSettings.Lifetime = (Options.DamageNumbersLifetime and Options.DamageNumbersLifetime.Value) or 1.1
end})
local Visuals = VisualsCrosshair
Visuals:AddToggle('CrosshairToggle',{Text = "Crosshair",
Default = false,
Callback = onCrosshairToggleChanged}):AddColorPicker('CrosshairColor',{Title = "Crosshair Color",
Default = Color3.fromRGB(255, 255, 255),
Callback = function(Value) end})
Visuals:AddToggle('FollowTarget',{Text = "Follow Target",
Default = false,
Callback = function(Value)
Crosshair.FollowTarget = (Toggles.FollowTarget and Toggles.FollowTarget.Value)
end})
Visuals:AddToggle('RemoveDefaultCrosshair',{Text = "Remove Default Crosshair",
Default = false,
Callback = onRemoveDefaultCrosshair})
Visuals:AddSlider('CrosshairSize',{Text = "Crosshair Size",
Min = 5,
Max = 30,
Default = 10,
Rounding = 0,
Callback = function(Value) end})
Visuals:AddSlider('CrosshairGap',{Text = "Crosshair Gap",
Min = 0,
Max = 20,
Default = 5,
Rounding = 0,
Callback = function(Value) end})
Visuals:AddSlider('CrosshairThickness',{Text = "Crosshair Thickness",
Min = 1,
Max = 8,
Default = 2,
Rounding = 0,
Callback = function(Value) end})
Visuals:AddSlider('CrosshairOutlineThickness',{Text = "Outline Thickness",
Min = 1,
Max = 12,
Default = 4,
Rounding = 0,
Callback = function(Value) end})
Visuals:AddToggle('CrosshairRotation',{Text = "Rotation Animation",
Default = false,
Callback = function(Value)
Crosshair.RotationEnabled = (Toggles.CrosshairRotation and Toggles.CrosshairRotation.Value)
end})
Visuals:AddSlider('CrosshairRotationSpeed',{Text = "Rotation Speed",
Min = 0.1,
Max = 5,
Default = 1,
Rounding = 1,
Callback = function(Value)
Crosshair.RotationSpeed = (Options.CrosshairRotationSpeed and Options.CrosshairRotationSpeed.Value) or 1
end})
end
local function RemoveHeadAndAccessories(clonedCharacter)
local headParts = {
"Head", "HeadAccessory", "Face", "Hair", "Hat", "Glasses",
"Ears", "Antenna", "Headphones", "Mask", "Helmet", "Crown",
"HeadPart", "HeadAttachment", "HeadMesh", "HeadEffect"
}
local toRemove = {}
for _, child in pairs(clonedCharacter:GetChildren()) do
if child:IsA("BasePart") or child:IsA("Model") or child:IsA("Accessory") then
local nameLower = string.lower(child.Name)
for _, headName in ipairs(headParts) do
if child.Name == headName or nameLower:find("head") or nameLower:find("hair") or
nameLower:find("hat") or nameLower:find("face") or nameLower:find("mask") or
nameLower:find("helmet") or nameLower:find("accessory") then
table.insert(toRemove, child)
break
end
end
end
end
for _, item in ipairs(toRemove) do
pcall(function() item:Destroy() end)
end
local humanoid = clonedCharacter:FindFirstChild("Humanoid")
if humanoid then
for _, accessory in pairs(humanoid:GetAccessories()) do
pcall(function() accessory:Destroy() end)
end
pcall(function()
humanoid:SetBodyPartScaleVisible("Head", false)
end)
end
local head = clonedCharacter:FindFirstChild("Head")
if head then
head:Destroy()
end
end
local function Show3DHitmarker(worldPos, isLethal)
if not D3HitmarkerSettings.Enabled then return end
if not worldPos then return end
local currentTime = tick()
if lastD3HitmarkerTime[1] and (currentTime - lastD3HitmarkerTime[1]) < 0.05 then
return
end
lastD3HitmarkerTime[1] = currentTime
local cam = Camera
local size = D3HitmarkerSettings.Size or 10
local thickness = D3HitmarkerSettings.Thickness or 1
local outlineThickness = D3HitmarkerSettings.OutlineThickness or (thickness + 2)
local color = isLethal and D3HitmarkerSettings.LethalColor or D3HitmarkerSettings.Color
local outlineColor = D3HitmarkerSettings.OutlineColor
local lifetime = D3HitmarkerSettings.Lifetime or 0.5
local lines = {}
local outlines = {}
for i = 1, 4 do
lines[i] = Drawing.new("Line")
lines[i].Thickness = thickness
lines[i].Color = color
lines[i].Transparency = 1
lines[i].Visible = true
outlines[i] = Drawing.new("Line")
outlines[i].Thickness = outlineThickness
outlines[i].Color = outlineColor
outlines[i].Transparency = 1
outlines[i].Visible = true
end
local elapsed = 0
local conn
conn = RunService.RenderStepped:Connect(function(dt)
elapsed = elapsed + dt
local pos, onScreen = cam:WorldToViewportPoint(worldPos)
if onScreen then
local px, py = pos.X, pos.Y
for i = 1, 4 do
lines[i].Visible = true
outlines[i].Visible = true
end
local s = size
lines[1].From = Vector2.new(px - s, py - s)
lines[1].To = Vector2.new(px - s/2, py - s/2)
lines[2].From = Vector2.new(px + s, py - s)
lines[2].To = Vector2.new(px + s/2, py - s/2)
lines[3].From = Vector2.new(px - s, py + s)
lines[3].To = Vector2.new(px - s/2, py + s/2)
lines[4].From = Vector2.new(px + s, py + s)
lines[4].To = Vector2.new(px + s/2, py + s/2)
for i = 1, 4 do
local dir = lines[i].To - lines[i].From
if dir.Magnitude > 0 then
local offset = dir.Unit
outlines[i].From = lines[i].From - offset
outlines[i].To = lines[i].To + offset
else
outlines[i].From = lines[i].From
outlines[i].To = lines[i].To
end
end
if elapsed > lifetime then
local fade = math.clamp((elapsed - lifetime) / 0.3, 0, 1)
for i = 1, 4 do
lines[i].Transparency = 1 - fade
outlines[i].Transparency = 1 - fade
end
if fade >= 1 then
conn:Disconnect()
for i = 1, 4 do
lines[i]:Destroy()
outlines[i]:Destroy()
end
end
end
else
for i = 1, 4 do
lines[i].Visible = false
outlines[i].Visible = false
end
end
end)
end
local function HitChams(Player)
if not HitChamsSettings.Enabled then return end
local currentTime = tick()
if lastHitChamsTime[Player] and (currentTime - lastHitChamsTime[Player]) < 0.05 then
return
end
lastHitChamsTime[Player] = currentTime
if not (Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")) then return end
Player.Character.Archivable = true
local Cloned = Player.Character:Clone()
Cloned.Name = "HitChams_Clone_" .. Player.Name
local humanoid = Cloned:FindFirstChildOfClass("Humanoid")
if humanoid then humanoid:Destroy() end
local hrp = Cloned:FindFirstChild("HumanoidRootPart")
if hrp then hrp:Destroy() end
for _, tool in ipairs(Cloned:GetDescendants()) do
if tool:IsA("Tool") or tool:IsA("HopperBin") then
tool:Destroy()
end
end
for _, desc in ipairs(Cloned:GetDescendants()) do
if desc:IsA("Script") or desc:IsA("LocalScript") or desc:IsA("ModuleScript") then
desc:Destroy()
elseif desc:IsA("Motor6D") or desc:IsA("Weld") or desc:IsA("WeldConstraint") or desc:IsA("JointInstance") then
desc:Destroy()
elseif desc:IsA("BasePart") then
desc.CanCollide = false
desc.Anchored = true
desc.Transparency = HitChamsSettings.Transparency
desc.Material = HitChamsSettings.Material
desc.Color = HitChamsSettings.Color
desc.TopSurface = Enum.SurfaceType.Smooth
desc.BottomSurface = Enum.SurfaceType.Smooth
if desc:IsA("MeshPart") then
desc.TextureID = ""
end
for _, meshChild in ipairs(desc:GetChildren()) do
if meshChild:IsA("SpecialMesh") or meshChild:IsA("FileMesh") then
meshChild.TextureId = ""
end
end
elseif desc:IsA("Decal") or desc:IsA("Texture") or desc:IsA("SurfaceAppearance") then
desc:Destroy()
elseif desc:IsA("Shirt") or desc:IsA("Pants") or desc:IsA("CharacterMesh") then
desc:Destroy()
end
end
for _, item in ipairs(Cloned:GetChildren()) do
if not (item:IsA("BasePart") or item:IsA("Accessory")) then
item:Destroy()
end
end
for _, part in ipairs(Cloned:GetDescendants()) do
if part:IsA("BasePart") then
local parent = part.Parent
if parent ~= Cloned and not (parent and parent:IsA("Accessory")) then
part:Destroy()
end
end
end
Cloned.Parent = HitChamsFolder
if Toggles.D3HitmarkerEnabled and Toggles.D3HitmarkerEnabled.Value then
local hHead = Cloned:FindFirstChild("Head")
if hHead and hHead:IsA("BasePart") then
Show3DHitmarker(hHead.Position, false)
end
end
local chest = Cloned:FindFirstChild("UpperTorso") or Cloned:FindFirstChild("Torso") or Cloned:FindFirstChild("HumanoidRootPart")
if chest and getgenv().FH_CreateBeamToHitChams then
getgenv().FH_CreateBeamToHitChams(Player, chest)
end
task.delay(HitChamsSettings.Duration, function()
if Cloned and Cloned.Parent then
if HitChamsSettings.FadeOut then
for _, part in ipairs(Cloned:GetDescendants()) do
if part:IsA("BasePart") then
TweenService:Create(part, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
Transparency = 1
}):Play()
end
end
task.delay(0.3, function()
if Cloned and Cloned.Parent then
Cloned:Destroy()
end
end)
else
Cloned:Destroy()
end
end
end)
end
local function HitEffects(Player)
if not HitEffectsSettings.Enabled then return end
local currentTime = tick()
if lastHitEffectsTime[Player] and (currentTime - lastHitEffectsTime[Player]) < 0.05 then return end
lastHitEffectsTime[Player] = currentTime
if not (Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")) then return end
if HitEffectsSettings.Type == "Particles" then
local TS = game:GetService("TweenService")
local DOT_COUNT = 20
local folder = Instance.new("Folder", workspace)
folder.Name = "HitDotsTemp"
local head = Player.Character:FindFirstChild("Head")
local spawnPos = (head and head.Position or Player.Character.HumanoidRootPart.Position + Vector3.new(0, 1.5, 0))
for i = 1, DOT_COUNT do
task.delay((i - 1) * 0.05, function()
local p = Instance.new("Part")
p.Shape = Enum.PartType.Ball
local sz = math.random(5, 12) * 0.01
p.Size = Vector3.new(sz, sz, sz)
p.Material = Enum.Material.Neon
p.Color = HitEffectsSettings.Color
p.CastShadow = false
p.CanCollide = false
p.Anchored = true
p.Parent = folder
local spread = 2.2
p.Position = spawnPos + Vector3.new(
(math.random() - 0.5) * 2 * spread,
0.8 + math.random(0, 8) * 0.1,
(math.random() - 0.5) * 2 * spread
)
local targetPos = p.Position + Vector3.new(
(math.random() - 0.5) * 2,
math.random(5, 12),
(math.random() - 0.5) * 2
)
local riseDuration = math.random(25, 45) * 0.1
TS:Create(p, TweenInfo.new(riseDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = targetPos
}):Play()
task.delay(riseDuration * 0.4, function()
if not p or not p.Parent then return end
local fade = TS:Create(p, TweenInfo.new(riseDuration * 0.6, Enum.EasingStyle.Linear), {
Transparency = 1
})
fade:Play()
fade.Completed:Connect(function()
if p and p.Parent then p:Destroy() end
end)
end)
end)
end
task.delay(HitEffectsSettings.Duration, function()
if folder and folder.Parent then folder:Destroy() end
end)
return
end
local effectTemplate = HitEffectModule.Locals.Type[HitEffectsSettings.Type]
if not effectTemplate then return end
local hrp = Player.Character.HumanoidRootPart
local effectAttachment = effectTemplate:Clone()
effectAttachment.Parent = hrp
local maxLifetime = 0
for _, emitter in pairs(effectAttachment:GetDescendants()) do
if emitter:IsA("ParticleEmitter") then
emitter.Color = ColorSequence.new(HitEffectsSettings.Color)
emitter:Emit(50)
local life = emitter.Lifetime.Max or 2
if life > maxLifetime then maxLifetime = life end
end
end
task.delay(HitEffectsSettings.Duration, function()
if effectAttachment and effectAttachment.Parent then
if HitEffectsSettings.FadeOut then
for _, emitter in pairs(effectAttachment:GetDescendants()) do
if emitter:IsA("ParticleEmitter") then
emitter.Enabled = false
end
end
task.delay(0.5, function()
if effectAttachment and effectAttachment.Parent then
effectAttachment:Destroy()
end
end)
else
effectAttachment:Destroy()
end
end
end)
end
local lastShotTime = 0
local damageWindow = 1.0
function onPlayerShoot()
lastShotTime = tick()
end
local function setupShootDetection()
local function handleCharacterTools(character)
character.ChildAdded:Connect(function(child)
if child:IsA("Tool") then
child.Activated:Connect(onPlayerShoot)
end
end)
for _, child in pairs(character:GetChildren()) do
if child:IsA("Tool") then
child.Activated:Connect(onPlayerShoot)
end
end
end
if LocalPlayer.Character then
handleCharacterTools(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(handleCharacterTools)
end
local function HitLogs(Player, damage)
if not HitLogsSettings.Enabled then return end
local currentTime = tick()
if lastHitLogTime[Player] and (currentTime - lastHitLogTime[Player]) < 0.05 then
return
end
local timeSinceShot = currentTime - lastShotTime
if timeSinceShot > damageWindow or timeSinceShot < 0 then
return
end
local hasWeapon = false
if LocalPlayer.Character then
local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
hasWeapon = tool ~= nil
end
if not hasWeapon then
return
end
lastHitLogTime[Player] = currentTime
if Player then
local targetName = Player.DisplayName or Player.Name
Notify("Notification", "Hit " .. targetName .. " for " .. math.floor(damage) .. " damage", HitLogsSettings.NotificationTime)
end
end
local function GetIndicatorGui()
local pg = LocalPlayer:FindFirstChild("PlayerGui")
if not pg then return nil end
local gui = pg:FindFirstChild("SubmissiveFartEater_Indicators")
if not gui then
gui = Instance.new("ScreenGui")
gui.Name = "SubmissiveFartEater_Indicators"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg
end
return gui
end
local function BuildCustomDamageIndicator()
local ind = Instance.new("Frame")
ind.Size = UDim2.new(0.04, 0, 0.035, 0)
ind.BackgroundTransparency = 1
local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1.1428571428571428
aspect.Parent = ind
local function makeLabel(name, position)
local lbl = Instance.new("TextLabel")
lbl.Name = name
lbl.Size = UDim2.new(0.5, 0, 1, 0)
lbl.Position = position
lbl.BackgroundTransparency = 1
lbl.TextScaled = true
lbl.Text = ""
lbl.TextColor3 = DamageNumberSettings.Color
lbl.FontFace = DamageNumberSettings.FontFace
lbl.TextXAlignment = Enum.TextXAlignment.Center
lbl.TextYAlignment = Enum.TextYAlignment.Center
lbl.TextStrokeTransparency = 1
if DamageNumberSettings.Outline then
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.6
stroke.Transparency = 0.5
stroke.Color = DamageNumberSettings.OutlineColor
stroke.Parent = lbl
end
lbl.Parent = ind
return lbl
end
makeLabel("Left", UDim2.new(0.125, 0, 0, 0))
makeLabel("Right", UDim2.new(0.375, 0, 0, 0))
return ind
end
local function ShowDamageNumber(player, damage, worldPos)
if not DamageNumberSettings.Enabled then return end
if not player or not worldPos then return end
local currentTime = tick()
if lastDamageNumberTime[player] and (currentTime - lastDamageNumberTime[player]) < 0.05 then
return
end
lastDamageNumberTime[player] = currentTime
local gui = GetIndicatorGui()
if not gui then return end
local template = ReplicatedStorage:FindFirstChild("DamageIndicator")
local indicator
if template and DamageNumberSettings.UseTemplate then
indicator = template:Clone()
local left = indicator:FindFirstChild("Left")
local right = indicator:FindFirstChild("Right")
if left then
left.TextColor3 = DamageNumberSettings.Color
left.FontFace = DamageNumberSettings.FontFace
if left:FindFirstChild("UIStroke") then
left.UIStroke.Color = DamageNumberSettings.OutlineColor
left.UIStroke.Transparency = DamageNumberSettings.Outline and 0.5 or 1
end
end
if right then
right.TextColor3 = DamageNumberSettings.Color
right.FontFace = DamageNumberSettings.FontFace
if right:FindFirstChild("UIStroke") then
right.UIStroke.Color = DamageNumberSettings.OutlineColor
right.UIStroke.Transparency = DamageNumberSettings.Outline and 0.5 or 1
end
end
else
indicator = BuildCustomDamageIndicator()
end
game.Debris:AddItem(indicator, DamageNumberSettings.Lifetime + 0.5)
local text = tostring(math.floor(damage + 0.5))
local digits = {}
for i = 1, #text do
table.insert(digits, text:sub(i, i))
end
local leftLabel = indicator:FindFirstChild("Left")
local rightLabel = indicator:FindFirstChild("Right")
if #text > 2 then
if leftLabel then leftLabel.Text = ""; leftLabel.Visible = false end
if rightLabel then rightLabel.Text = text; rightLabel.Size = UDim2.new(1, 0, 1, 0); rightLabel.Position = UDim2.new(0, 0, 0, 0); rightLabel.Visible = true end
elseif DamageNumberSettings.SplitDigits then
if leftLabel then leftLabel.Text = digits[1] or ""; leftLabel.Visible = true end
if rightLabel then rightLabel.Text = digits[2] or ""; rightLabel.Size = UDim2.new(0.5, 0, 1, 0); rightLabel.Position = UDim2.new(0.375, 0, 0, 0); rightLabel.Visible = true end
else
if leftLabel then leftLabel.Text = ""; leftLabel.Visible = false end
if rightLabel then rightLabel.Text = text; rightLabel.Size = UDim2.new(1, 0, 1, 0); rightLabel.Position = UDim2.new(0, 0, 0, 0); rightLabel.Visible = true end
end
indicator.Parent = gui
task.spawn(function()
indicator.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(indicator, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
Size = UDim2.new(0.035, 0, 0.035, 0)
}):Play()
task.wait(0.175)
TweenService:Create(indicator, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
Size = UDim2.new(0.03, 0, 0.025, 0)
}):Play()
if DamageNumberSettings.FadeOut then
task.delay(math.max(0.05, DamageNumberSettings.Lifetime - 0.2), function()
if not indicator:IsDescendantOf(gui) then return end
local tw = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
if leftLabel then
TweenService:Create(leftLabel, tw, {TextTransparency = 1}):Play()
if leftLabel:FindFirstChild("UIStroke") then
TweenService:Create(leftLabel.UIStroke, tw, {Transparency = 1}):Play()
end
end
if rightLabel then
TweenService:Create(rightLabel, tw, {TextTransparency = 1}):Play()
if rightLabel:FindFirstChild("UIStroke") then
TweenService:Create(rightLabel.UIStroke, tw, {Transparency = 1}):Play()
end
end
end)
end
if DamageNumberSettings.FlyOut and leftLabel and rightLabel then
local lStart = UDim2.new(0.125, 0, 0, 0)
local lControl = UDim2.new(-0.425, 0, 0.2, 0)
local lEnd = UDim2.new(-0.475, 0, 4, 0)
local rStart = UDim2.new(0.375, 0, 0, 0)
local rControl = UDim2.new(0.925, 0, 0.2, 0)
local rEnd = UDim2.new(0.975, 0, 4, 0)
local function quadBezier(t, p0, p1, p2)
local a = p0:Lerp(p1, t)
local b = p1:Lerp(p2, t)
return a:Lerp(b, t)
end
for i = 0, 1, 0.035 do
if not indicator:IsDescendantOf(gui) then break end
local val = TweenService:GetValue(i, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
leftLabel.Position = quadBezier(val, lStart, lControl, lEnd)
rightLabel.Position = quadBezier(val, rStart, rControl, rEnd)
if val < 0.25 then
leftLabel.Rotation = val * -1
rightLabel.Rotation = val
else
leftLabel.Rotation = leftLabel.Rotation - 10
rightLabel.Rotation = rightLabel.Rotation + 10
end
task.wait(1 / 60)
end
end
end)
indicator.AnchorPoint = Vector2.new(0.5, 0.5)
task.spawn(function()
while indicator and indicator:IsDescendantOf(gui) do
local pos, onScreen = Camera:WorldToViewportPoint(worldPos)
local x, y = pos.X, pos.Y
if not onScreen then
local abs = indicator.AbsoluteSize
local vs = Camera.ViewportSize
x = math.clamp(x, abs.X / 2, vs.X - abs.X / 2)
y = math.clamp(y, abs.Y / 2, vs.Y - abs.Y / 2)
end
indicator.Position = UDim2.new(0, x, 0, y)
RunService.RenderStepped:Wait()
end
end)
end
local function ShowHitmarker(worldPos)
if not HitmarkerSettings.Enabled then return end
if not worldPos then return end
local currentTime = tick()
if lastHitmarkerTime[1] and (currentTime - lastHitmarkerTime[1]) < 0.05 then
return
end
lastHitmarkerTime[1] = currentTime
local gui = GetIndicatorGui()
if not gui then return end
local template = ReplicatedStorage:FindFirstChild("DMGIndicator")
local indicator
if template then
indicator = template:Clone()
indicator.ImageColor3 = HitmarkerSettings.Color
else
indicator = Instance.new("ImageLabel")
indicator.Image = "rbxassetid://14101461906"
indicator.ImageColor3 = HitmarkerSettings.Color
indicator.BackgroundTransparency = 1
Instance.new("UIAspectRatioConstraint", indicator)
end
local size = HitmarkerSettings.Size
indicator.Size = UDim2.new(0, size, 0, size)
indicator.Position = UDim2.new(0.5, -size / 2, 0.5, -size / 2)
indicator.ImageTransparency = 0
indicator.Parent = gui
game.Debris:AddItem(indicator, HitmarkerSettings.Lifetime + 0.1)
local camCF = Camera.CFrame
local dir = (worldPos - camCF.Position)
local angle = math.deg(math.atan2(dir.Z, dir.X) - math.atan2(camCF.LookVector.Z, camCF.LookVector.X))
indicator.Rotation = angle + 90
TweenService:Create(indicator, TweenInfo.new(HitmarkerSettings.Lifetime, Enum.EasingStyle.Linear), {
ImageTransparency = 1
}):Play()
end
local function ShowKillMarker(worldPos)
if not KillMarkerSettings.Enabled then return end
if not worldPos then return end
local currentTime = tick()
if lastKillMarkerTime[1] and (currentTime - lastKillMarkerTime[1]) < 0.2 then
return
end
lastKillMarkerTime[1] = currentTime
local gui = GetIndicatorGui()
if not gui then return end
local template = ReplicatedStorage:FindFirstChild("KillIndicator")
local indicator
if template then
indicator = template:Clone()
else
indicator = Instance.new("Frame")
indicator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
indicator.BackgroundTransparency = 0.5
Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
local img = Instance.new("ImageLabel")
img.Name = "ImageLabel"
img.Size = UDim2.new(0, 0, 0, 0)
img.Position = UDim2.new(0.5, 0, 0.5, 0)
img.AnchorPoint = Vector2.new(0.5, 0.5)
img.BackgroundTransparency = 1
img.Image = "rbxassetid://14385347210"
img.Parent = indicator
Instance.new("UIAspectRatioConstraint", indicator)
end
indicator.Size = UDim2.new(0, 0, 0, 0)
indicator.Parent = gui
game.Debris:AddItem(indicator, KillMarkerSettings.Lifetime + 0.5)
TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
Size = UDim2.new(0.017, 0, 0.031, 0)
}):Play()
local img = indicator:FindFirstChild("ImageLabel")
if img then
TweenService:Create(img, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
Size = UDim2.new(0.667, 0, 0.673, 0)
}):Play()
task.delay(KillMarkerSettings.Lifetime - 0.5, function()
if not indicator:IsDescendantOf(gui) then return end
TweenService:Create(img, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
ImageTransparency = 1
}):Play()
end)
end
task.delay(KillMarkerSettings.Lifetime - 0.5, function()
if not indicator:IsDescendantOf(gui) then return end
TweenService:Create(indicator, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
BackgroundTransparency = 1
}):Play()
end)
task.spawn(function()
while indicator and indicator:IsDescendantOf(gui) do
local pos, onScreen = Camera:WorldToViewportPoint(worldPos)
local abs = indicator.AbsoluteSize
local x = pos.X - (abs.X / 2)
local y = pos.Y - (abs.Y / 2)
if not onScreen then
local vs = Camera.ViewportSize
x = math.clamp(x, 0, vs.X - abs.X)
y = math.clamp(y, 0, vs.Y - abs.Y)
end
indicator.Position = UDim2.new(0, x, 0, y)
RunService.RenderStepped:Wait()
end
end)
end
local PlayerHealths = {}
do
setupShootDetection()
local function trackTargetHealth(target, isAutoKill)
if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
local humanoid = target.Character.Humanoid
PlayerHealths[target] = humanoid.Health
local connection
connection = humanoid.HealthChanged:Connect(function(newHealth)
local oldHealth = PlayerHealths[target] or newHealth
local isCurrentTarget = false
if isAutoKill then
isCurrentTarget = (target == AutoKill.Target and AutoKill.Enabled)
else
isCurrentTarget = (target == Targeting.Target and Targeting.LockedOn)
end
if newHealth < oldHealth and isCurrentTarget then
local damage = oldHealth - newHealth
PlayHitsound()
if getgenv().FlashHitVignette then
getgenv().FlashHitVignette()
end
HitChams(target)
HitEffects(target)
HitLogs(target, damage)
local function horizontalRight(part)
local look = part.CFrame.LookVector
local flat = Vector3.new(look.X, 0, look.Z)
if flat.Magnitude < 0.001 then
flat = Vector3.new(0, 0, 1)
else
flat = flat.Unit
end
return CFrame.lookAt(part.Position, part.Position + flat).RightVector
end
local hitPos = nil
if target.Character then
local head = target.Character:FindFirstChild("Head")
local torso = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("Torso") or target.Character:FindFirstChild("HumanoidRootPart")
local part = head and head:IsA("BasePart") and head or torso
if part then
local center = part.Position
if part == torso then
center = center + Vector3.new(0, part.Size.Y * 0.4, 0)
end
local right = horizontalRight(part)
local w = math.max(part.Size.X, part.Size.Z) * 0.5
local h = part.Size.Y * 0.35
local spots = {
center,
center + right * w,
center - right * w,
center + Vector3.new(0, h, 0)
}
local jitter = Vector3.new(math.random() * 0.5 - 0.25, math.random() * 0.5 - 0.25, math.random() * 0.5 - 0.25)
hitPos = spots[math.random(1, #spots)] + jitter
end
end
if hitPos then
ShowDamageNumber(target, damage, hitPos)
ShowHitmarker(hitPos)
local headPos = target.Character and target.Character:FindFirstChild("Head")
Show3DHitmarker(headPos and headPos:IsA("BasePart") and headPos.Position or hitPos, newHealth <= 0)
end
if newHealth <= 0 and hitPos then
ShowKillMarker(hitPos)
end
end
PlayerHealths[target] = newHealth
local shouldDisconnect = false
if isAutoKill then
shouldDisconnect = (target ~= AutoKill.Target or newHealth <= 0)
else
shouldDisconnect = (target ~= Targeting.Target or newHealth <= 0)
end
if shouldDisconnect then
connection:Disconnect()
PlayerHealths[target] = nil
end
end)
end
end
local lastTarget = nil
local lastAutoKillTarget = nil
RunService.Heartbeat:Connect(function()
if Targeting.Target ~= lastTarget then
if lastTarget then
PlayerHealths[lastTarget] = nil
end
if Targeting.Target and Targeting.LockedOn then
trackTargetHealth(Targeting.Target, false)
end
lastTarget = Targeting.Target
end
if AutoKill.Target ~= lastAutoKillTarget then
if lastAutoKillTarget then
PlayerHealths[lastAutoKillTarget] = nil
end
if AutoKill.Target and AutoKill.Enabled then
trackTargetHealth(AutoKill.Target, true)
end
lastAutoKillTarget = AutoKill.Target
end
end)
Players.PlayerRemoving:Connect(function(player)
PlayerHealths[player] = nil
lastHitChamsTime[player] = nil
lastHitEffectsTime[player] = nil
lastHitLogTime[player] = nil
end)
end
local MiscMovementSection = MiscMovement
local MiscCombatSection = MiscCombat
do
getgenv().cframeSpeedEnabled = false
getgenv().cframeSpeedKeybindActive = false
getgenv().cframeSpeed = 10
MiscMovementSection:AddToggle('CFrameSpeedToggle',{Text = "CframeSpeed",
Default = false,
Callback = function(Value)
getgenv().cframeSpeedEnabled = (Toggles.CFrameSpeedToggle and Toggles.CFrameSpeedToggle.Value)
if not getgenv().cframeSpeedEnabled then
getgenv().cframeSpeedKeybindActive = false
end
end}):AddKeyPicker('CFrameSpeedKeybind',{Text = "CframeSpeed",
Default = 'None',
Callback = function(Value)
if game:GetService("UserInputService"):GetFocusedTextBox() then return end
if getgenv().cframeSpeedEnabled then
getgenv().cframeSpeedKeybindActive = not getgenv().cframeSpeedKeybindActive
end
end,
Mode = 'Toggle'})
MiscMovementSection:AddSlider('CFrameSpeedSlider',{Text = "Speed",
Min = 1,
Max = 200,
Default = 10,
Rounding = 0,
Callback = function(Value)
getgenv().cframeSpeed = (Options.CFrameSpeedSlider and Options.CFrameSpeedSlider.Value)
end})
task.spawn(function()
while task.wait(0) do
local player = Players.LocalPlayer
local character = player.Character
local humanoid = character and character:FindFirstChild("Humanoid")
if getgenv().cframeSpeedEnabled and getgenv().cframeSpeedKeybindActive and character and humanoid and humanoid.MoveDirection.Magnitude > 0 then
local char = player.Character
local move_dir = humanoid.MoveDirection
char.HumanoidRootPart.CFrame += (move_dir * (getgenv().cframeSpeed / 20))
end
end
end)
end
do
getgenv().jumpPowerEnabled = false
getgenv().jumpPower = 50
MiscMovementSection:AddToggle('JumpPowerToggle',{Text = "JumpPower",
Default = false,
Callback = function(Value)
getgenv().jumpPowerEnabled = (Toggles.JumpPowerToggle and Toggles.JumpPowerToggle.Value)
end})
MiscMovementSection:AddSlider('JumpPower',{Text = "JumpPower",
Min = 50,
Max = 500,
Default = 50,
Rounding = 0,
Callback = function(Value)
getgenv().jumpPower = (Options.JumpPower and Options.JumpPower.Value)
end})
game:GetService('RunService').RenderStepped:Connect(function()
local player = Players.LocalPlayer
local humanoid = player.Character and player.Character:FindFirstChild('Humanoid')
if not humanoid then return end
humanoid.JumpPower = getgenv().jumpPowerEnabled and getgenv().jumpPower or 50
end)
end
do
getgenv().FlightEnabled = false
getgenv().Flying = false
getgenv().FlySpeed = 50
local function CreateCore()
if workspace:FindFirstChild("Core") then workspace.Core:Destroy() end
local Core = Instance.new("Part")
Core.Name = "Core"
Core.Size = Vector3.new(0.05, 0.05, 0.05)
Core.CanCollide = false
Core.Transparency = 1
Core.Parent = workspace
local Weld = Instance.new("Weld", Core)
Weld.Part0 = Core
Weld.Part1 = LocalPlayer.Character.HumanoidRootPart
Weld.C0 = CFrame.new(0, 0, 0)
return Core
end
local function StartFly()
if getgenv().Flying then return end
getgenv().Flying = true
LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
local Core = CreateCore()
local BV = Instance.new("BodyVelocity", Core)
BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
BV.Velocity = Vector3.zero
local BG = Instance.new("BodyGyro", Core)
BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
BG.P = 9e4
BG.CFrame = Core.CFrame
RunService.RenderStepped:Connect(function()
if not getgenv().Flying then return end
local camera = workspace.CurrentCamera
local moveDirection = Vector3.zero
if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
BV.Velocity = moveDirection * getgenv().FlySpeed
BG.CFrame = camera.CFrame
end)
end
local function StopFly()
if not getgenv().Flying then return end
getgenv().Flying = false
LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
if workspace:FindFirstChild("Core") then workspace.Core:Destroy() end
end
MiscMovementSection:AddToggle('FlightToggle',{Text = "Flight",
Default = false,
Callback = function(Value)
getgenv().FlightEnabled = (Toggles.FlightToggle and Toggles.FlightToggle.Value)
if not getgenv().FlightEnabled then StopFly() end
end}):AddKeyPicker('FlightKeybindPicker',{Text = "Flight Keybind",
Default = 'None',
Callback = function(Value)
if UserInputService:GetFocusedTextBox() then return end
if getgenv().FlightEnabled then
if getgenv().Flying then
StopFly()
else
StartFly()
end
end
end,
Mode = 'Toggle'})
MiscMovementSection:AddSlider('FlySpeedSlider',{Text = "Fly Speed",
Min = 10,
Max = 5000,
Default = 50,
Rounding = 0,
Callback = function(Value)
getgenv().FlySpeed = (Options.FlySpeedSlider and Options.FlySpeedSlider.Value)
end})
end
do
local player = Players.LocalPlayer
local GUN_NAMES = {
["[Revolver]"] = true, ["[DoubleBarrel]"] = true, ["[TacticalShotgun]"] = true,
["[SMG]"] = true, ["[Shotgun]"] = true, ["[Silencer]"] = true, ["[Flintlock]"] = true
}
local lastReload = 0
local autoReloadConnection = nil
local function isReloading(char)
local be = char and char:FindFirstChild("BodyEffects")
local r = be and (be:FindFirstChild("Reloading") or be:FindFirstChild("Reloading_CLIENT"))
return r and r.Value
end
local function getAmmo(tool)
local s = tool and tool:FindFirstChild("Script")
local a = s and s:FindFirstChild("Ammo")
if a and a:IsA("IntValue") then return a.Value end
return nil
end
local function startAutoReload()
if autoReloadConnection then autoReloadConnection:Disconnect() end
autoReloadConnection = RunService.RenderStepped:Connect(function()
local char = player.Character
if not char then return end
local tool = char:FindFirstChildOfClass("Tool")
if not tool or not GUN_NAMES[tool.Name] then return end
local ammo = getAmmo(tool)
if ammo and ammo <= 0 and not isReloading(char) and tick() - lastReload >= 1.1 then
lastReload = tick()
pcall(function()
local me = ReplicatedStorage:WaitForChild("MainEvent", 1)
if me then me:FireServer("Reload") end
end)
end
end)
end
local function stopAutoReload()
if autoReloadConnection then autoReloadConnection:Disconnect(); autoReloadConnection = nil end
end
MiscCombatSection:AddToggle('AutoReload',{Text = "Reload",
Default = false,
Callback = function(Value)
if Toggles.AutoReload and Toggles.AutoReload.Value then startAutoReload() else stopAutoReload() end
end})
end
do
local function forceResetCharacter()
local char = LocalPlayer.Character
if not char then return end
local humanoid = char:FindFirstChildOfClass("Humanoid")
if not humanoid then return end
pcall(function()
humanoid.PlatformStand = false
humanoid.Sit = false
humanoid.Health = 0
end)
end
local function isKnocked()
local char = LocalPlayer.Character
if not char then return false end
local be = char:FindFirstChild("BodyEffects")
if not be then return false end
local ko = be:FindFirstChild("K.O")
return ko and ko.Value == true
end
local forceResetConnection = nil
local function startForceResetLoop()
stopForceResetLoop()
forceResetConnection = RunService.Heartbeat:Connect(function()
if Toggles.ForceReset and Toggles.ForceReset.Value and isKnocked() then
forceResetCharacter()
end
end)
end
local function stopForceResetLoop()
if forceResetConnection then
forceResetConnection:Disconnect()
forceResetConnection = nil
end
end
MiscOther:AddToggle('ForceReset',{Text = "Force Reset",
Default = false,
Callback = function(Value)
local enabled = (Toggles.ForceReset and Toggles.ForceReset.Value)
if enabled then
forceResetCharacter()
startForceResetLoop()
else
stopForceResetLoop()
end
end})
end
local Gunmaterial = VisualsGunMaterial
do
local GunMaterial = {
Enabled = false,
Material = "Neon",
Color = Color3.fromRGB(255, 0, 0),
OriginalData = {}
}
do
local function StoreOriginalData(part)
if not GunMaterial.OriginalData[part] then
GunMaterial.OriginalData[part] = {
Material = part.Material,
Color = part.Color,
TextureID = "",
Texture = ""
}
local success, textureID = pcall(function() return part.TextureID end)
if success and textureID then
GunMaterial.OriginalData[part].TextureID = textureID
end
local texture = part:FindFirstChildOfClass("Texture")
if texture and texture.Texture then
GunMaterial.OriginalData[part].Texture = texture.Texture
end
end
end
local function ApplyGunMaterial(part)
if not part or not part:IsA("BasePart") then return end
StoreOriginalData(part)
if pcall(function() return part.TextureID end) then
part.TextureID = ""
end
local texture = part:FindFirstChildOfClass("Texture")
if texture then
texture.Texture = ""
end
part.Material = Enum.Material[GunMaterial.Material]
part.Color = GunMaterial.Color
end
local function RestoreOriginalMaterial(part)
if not part or not part:IsA("BasePart") then return end
local originalData = GunMaterial.OriginalData[part]
if originalData then
part.Material = originalData.Material
part.Color = originalData.Color
local success = pcall(function()
if originalData.TextureID and originalData.TextureID ~= "" then
part.TextureID = originalData.TextureID
else
part.TextureID = ""
end
end)
local texture = part:FindFirstChildOfClass("Texture")
if texture then
if originalData.Texture and originalData.Texture ~= "" then
texture.Texture = originalData.Texture
else
texture.Texture = ""
end
end
end
end
local function ProcessGunParts(tool)
if not tool or not tool:IsA("Tool") then return end
for _, child in pairs(tool:GetDescendants()) do
if child:IsA("BasePart") then
if GunMaterial.Enabled then
ApplyGunMaterial(child)
else
RestoreOriginalMaterial(child)
end
end
end
end
local function UpdateAllGuns()
if not LocalPlayer.Character then return end
for _, child in pairs(LocalPlayer.Character:GetChildren()) do
if child:IsA("Tool") then
ProcessGunParts(child)
end
end
if LocalPlayer.Backpack then
for _, child in pairs(LocalPlayer.Backpack:GetChildren()) do
if child:IsA("Tool") then
ProcessGunParts(child)
end
end
end
end
local function onGunMaterialToggle()
GunMaterial.Enabled = (Toggles.GunMaterialEnabled and Toggles.GunMaterialEnabled.Value)
UpdateAllGuns()
end
local function onGunMaterialChanged()
GunMaterial.Material = (Options.GunMaterialType and Options.GunMaterialType.Value) or "Neon"
if GunMaterial.Enabled then
UpdateAllGuns()
end
end
local function onGunColorChanged(Value)
GunMaterial.Color = Value or Color3.fromRGB(255, 0, 0)
if GunMaterial.Enabled then
UpdateAllGuns()
end
end
Gunmaterial:AddToggle('GunMaterialEnabled',{Text = "Gun Material",
Default = false,
Callback = onGunMaterialToggle}):AddColorPicker('GunMaterialColor',{Title = "Gun Color",
Default = Color3.fromRGB(255, 0, 0),
Callback = onGunColorChanged})
Gunmaterial:AddDropdown('GunMaterialType',{Text = "Material Type",
Values = {"Neon", "ForceField"},
Default = "Neon",
Callback = onGunMaterialChanged})
local function onToolAdded(tool)
if tool:IsA("Tool") then
task.wait(0.1)
ProcessGunParts(tool)
end
end
local function onToolRemoved(tool)
if tool:IsA("Tool") then
for _, child in pairs(tool:GetDescendants()) do
if child:IsA("BasePart") and GunMaterial.OriginalData[child] then
GunMaterial.OriginalData[child] = nil
end
end
end
end
local function onCharacterAdded(character)
character.ChildAdded:Connect(onToolAdded)
character.ChildRemoved:Connect(onToolRemoved)
task.wait(1)
UpdateAllGuns()
end
local function onCharacterRemoving()
GunMaterial.OriginalData = {}
end
if LocalPlayer.Character then
onCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)
if LocalPlayer.Backpack then
LocalPlayer.Backpack.ChildAdded:Connect(onToolAdded)
LocalPlayer.Backpack.ChildRemoved:Connect(onToolRemoved)
end
LocalPlayer.ChildAdded:Connect(function(child)
if child.Name == "Backpack" then
child.ChildAdded:Connect(onToolAdded)
child.ChildRemoved:Connect(onToolRemoved)
end
end)
RunService.Heartbeat:Connect(function()
if GunMaterial.Enabled then
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
if tool:IsA("Tool") then
for _, part in pairs(tool:GetDescendants()) do
if part:IsA("BasePart") and part.Material ~= Enum.Material[GunMaterial.Material] then
ProcessGunParts(tool)
break
end
end
end
end
end
end
end)
end
end
-- ============================================
-- CLIENT BODY MODIFIER SECTION
-- ============================================
do
local ClientBody = {
Enabled = false,
Material = "Neon",
Color = Color3.fromRGB(57, 255, 150),
Originals = {},
ClothingClones = {},
DecalClones = {},
CharConnections = {},
CurrentChar = nil
}
local CLOTHING_NAMES = {"Shirt", "Pants", "ShirtGraphic"}
local function disconnectCharConnections()
for _, c in ipairs(ClientBody.CharConnections) do
pcall(function() c:Disconnect() end)
end
table.clear(ClientBody.CharConnections)
end
local function saveOriginalData(part)
if ClientBody.Originals[part] then return end
local data = {
Material = part.Material,
Color = part.Color,
}
local ok1, texID = pcall(function() return part.TextureID end)
if ok1 and texID then
data.TextureID = texID
end
local tex = part:FindFirstChildOfClass("Texture")
if tex and tex.Texture then
data.Texture = tex.Texture
end
for _, child in ipairs(part:GetChildren()) do
if child:IsA("SpecialMesh") then
local ok2, meshTex = pcall(function() return child.TextureId end)
if ok2 and meshTex then
data.SpecialMeshTexture = meshTex
end
break
end
end
ClientBody.Originals[part] = data
end
local function applyPart(part)
if not (part:IsA("BasePart") or part:IsA("MeshPart")) then return end
saveOriginalData(part)
pcall(function() part.TextureID = "" end)
for _, child in ipairs(part:GetChildren()) do
if child:IsA("SpecialMesh") then
pcall(function() child.TextureId = "" end)
end
end
part.Material = Enum.Material[ClientBody.Material]
part.Color = ClientBody.Color
end
local function forceHead(head)
if not (head:IsA("BasePart") or head:IsA("MeshPart")) then return end
for _, name in ipairs({"FaceControls", "HeadWrapTarget"}) do
local fc = head:FindFirstChild(name)
if fc then fc:Destroy() end
end
for _, child in ipairs(head:GetChildren()) do
if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") then
local clone = child:Clone()
if clone then
ClientBody.DecalClones[child] = {Clone = clone, Parent = head}
end
child:Destroy()
end
end
pcall(function() head.TextureID = "" end)
for _, child in ipairs(head:GetChildren()) do
if child:IsA("SpecialMesh") then
pcall(function() child.TextureId = "" end)
end
end
head.Material = Enum.Material[ClientBody.Material]
head.Color = ClientBody.Color
end
local function restoreCharacter(char)
if not char then return end
disconnectCharConnections()
for name, clone in pairs(ClientBody.ClothingClones) do
if clone and not clone.Parent then
pcall(function() clone.Parent = char end)
end
end
table.clear(ClientBody.ClothingClones)
for _, info in pairs(ClientBody.DecalClones) do
local clone = info.Clone
if clone and not clone.Parent then
pcall(function() clone.Parent = info.Parent end)
end
end
table.clear(ClientBody.DecalClones)
for part, data in pairs(ClientBody.Originals) do
if part and part.Parent then
pcall(function()
part.Material = data.Material
part.Color = data.Color
if data.TextureID then
part.TextureID = data.TextureID
else
part.TextureID = ""
end
end)
if data.Texture then
local tex = part:FindFirstChildOfClass("Texture")
if tex then
pcall(function() tex.Texture = data.Texture end)
end
end
if data.SpecialMeshTexture then
for _, child in ipairs(part:GetChildren()) do
if child:IsA("SpecialMesh") then
pcall(function() child.TextureId = data.SpecialMeshTexture end)
break
end
end
end
end
end
table.clear(ClientBody.Originals)
if ClientBody.CurrentChar == char then
ClientBody.CurrentChar = nil
end
end
local function cleanAndApply(char)
if not char then return end
disconnectCharConnections()
restoreCharacter(ClientBody.CurrentChar)
ClientBody.CurrentChar = char
for _, name in ipairs(CLOTHING_NAMES) do
local item = char:FindFirstChild(name)
if item then
local clone = item:Clone()
if clone then
ClientBody.ClothingClones[name] = clone
end
item:Destroy()
end
end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") or part:IsA("MeshPart") then
saveOriginalData(part)
for _, child in ipairs(part:GetChildren()) do
if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") then
local clone = child:Clone()
if clone then
ClientBody.DecalClones[child] = {Clone = clone, Parent = part}
end
child:Destroy()
end
end
end
end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("MeshPart") then
pcall(function() part.TextureID = "" end)
elseif part:IsA("SpecialMesh") then
pcall(function() part.TextureId = "" end)
end
end
for _, part in ipairs(char:GetDescendants()) do
if part.Name == "Head" then
forceHead(part)
end
end
for _, part in ipairs(char:GetDescendants()) do
applyPart(part)
end
table.insert(ClientBody.CharConnections, char.DescendantAdded:Connect(function(desc)
if desc:IsA("Decal") or desc:IsA("Texture") or desc:IsA("SurfaceAppearance") then
local clone = desc:Clone()
if clone then
ClientBody.DecalClones[desc] = {Clone = clone, Parent = desc.Parent}
end
desc:Destroy()
return
end
if desc:IsA("Shirt") or desc:IsA("Pants") or desc:IsA("ShirtGraphic") then
local clone = desc:Clone()
if clone then
ClientBody.ClothingClones[desc.Name] = clone
end
desc:Destroy()
return
end
if desc.Name == "Head" then
forceHead(desc)
end
applyPart(desc)
end))
table.insert(ClientBody.CharConnections, RunService.RenderStepped:Connect(function()
if not ClientBody.Enabled then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") or part:IsA("MeshPart") then
if part.Name == "Head" then
forceHead(part)
else
part.Material = Enum.Material[ClientBody.Material]
part.Color = ClientBody.Color
end
end
end
end))
end
local function updateBodyMaterial()
if not ClientBody.Enabled or not ClientBody.CurrentChar then return end
local char = ClientBody.CurrentChar
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") or part:IsA("MeshPart") then
if part.Name == "Head" then
forceHead(part)
else
part.Material = Enum.Material[ClientBody.Material]
part.Color = ClientBody.Color
end
end
end
end
VisualsClient:AddToggle('ModifyBody', {
Text = "Modify Body",
Default = false,
Callback = function(Value)
ClientBody.Enabled = Value
if Value then
if LocalPlayer.Character then
cleanAndApply(LocalPlayer.Character)
end
else
restoreCharacter(ClientBody.CurrentChar)
end
end
}):AddColorPicker('ModifyBodyColor', {
Title = "Body Color",
Default = Color3.fromRGB(57, 255, 150),
Callback = function(Value)
ClientBody.Color = Value or Color3.fromRGB(57, 255, 150)
updateBodyMaterial()
end
})
VisualsClient:AddDropdown('ModifyBodyMaterial', {
Text = "Material",
Values = {"Neon", "ForceField"},
Default = "Neon",
Callback = function(Value)
ClientBody.Material = Value or "Neon"
updateBodyMaterial()
end
})
LocalPlayer.CharacterAdded:Connect(function(char)
if ClientBody.Enabled then
task.wait(0.3)
cleanAndApply(char)
end
end)
LocalPlayer.CharacterRemoving:Connect(function(char)
if char == ClientBody.CurrentChar then
restoreCharacter(char)
end
end)
if ClientBody.Enabled and LocalPlayer.Character then
cleanAndApply(LocalPlayer.Character)
end
local oldUnload = Library.Unload
Library.Unload = function()
restoreCharacter(ClientBody.CurrentChar)
if oldUnload then
oldUnload()
end
end
end
-- ============================================
-- CLIENT KORBLOX SECTION
-- ============================================
do
local KorbloxVisual = {
Enabled = false,
Mesh = "https://assetdelivery.roblox.com/v1/asset/?id=9598310133",
Texture = "https://www.roblox.com/asset/?id=902843398",
Originals = {},
CharConnection = nil
}
local function restoreKorblox(char)
if not char then return end
if KorbloxVisual.CharConnection then
pcall(function() KorbloxVisual.CharConnection:Disconnect() end)
KorbloxVisual.CharConnection = nil
end
local rightFoot = char:FindFirstChild("RightFoot")
local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
if rightFoot and KorbloxVisual.Originals[rightFoot] then
rightFoot.Transparency = KorbloxVisual.Originals[rightFoot]
end
if rightLowerLeg and KorbloxVisual.Originals[rightLowerLeg] then
rightLowerLeg.Transparency = KorbloxVisual.Originals[rightLowerLeg].Transparency
rightLowerLeg.MeshId = KorbloxVisual.Originals[rightLowerLeg].MeshId
rightLowerLeg.TextureID = KorbloxVisual.Originals[rightLowerLeg].TextureID
end
if rightUpperLeg and KorbloxVisual.Originals[rightUpperLeg] then
rightUpperLeg.Transparency = KorbloxVisual.Originals[rightUpperLeg].Transparency
rightUpperLeg.MeshId = KorbloxVisual.Originals[rightUpperLeg].MeshId
rightUpperLeg.TextureID = KorbloxVisual.Originals[rightUpperLeg].TextureID
end
table.clear(KorbloxVisual.Originals)
end
local function applyKorblox(char)
if not char then return end
restoreKorblox(char)
local rightFoot = char:FindFirstChild("RightFoot")
local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
if rightFoot then
KorbloxVisual.Originals[rightFoot] = rightFoot.Transparency
rightFoot.Transparency = 1
end
if rightLowerLeg then
KorbloxVisual.Originals[rightLowerLeg] = {
Transparency = rightLowerLeg.Transparency,
MeshId = rightLowerLeg.MeshId,
TextureID = rightLowerLeg.TextureID
}
rightLowerLeg.Transparency = 1
end
if rightUpperLeg then
KorbloxVisual.Originals[rightUpperLeg] = {
Transparency = rightUpperLeg.Transparency,
MeshId = rightUpperLeg.MeshId,
TextureID = rightUpperLeg.TextureID
}
rightUpperLeg.Transparency = 0
rightUpperLeg.MeshId = KorbloxVisual.Mesh
rightUpperLeg.TextureID = KorbloxVisual.Texture
end
if KorbloxVisual.CharConnection then
pcall(function() KorbloxVisual.CharConnection:Disconnect() end)
end
KorbloxVisual.CharConnection = char.ChildAdded:Connect(function(child)
if not KorbloxVisual.Enabled then return end
if child.Name == "RightFoot" or child.Name == "RightLowerLeg" or child.Name == "RightUpperLeg" then
task.wait(0.1)
applyKorblox(char)
end
end)
end
VisualsClient:AddToggle('KorbloxVisual', {
Text = "Korblox",
Default = false,
Callback = function(Value)
KorbloxVisual.Enabled = Value
if Value then
if LocalPlayer.Character then
applyKorblox(LocalPlayer.Character)
end
else
restoreKorblox(LocalPlayer.Character)
end
end
})
LocalPlayer.CharacterAdded:Connect(function(char)
if KorbloxVisual.Enabled then
task.wait(0.3)
applyKorblox(char)
end
end)
if KorbloxVisual.Enabled and LocalPlayer.Character then
applyKorblox(LocalPlayer.Character)
end
local oldUnload = Library.Unload
Library.Unload = function()
restoreKorblox(LocalPlayer.Character)
if oldUnload then
oldUnload()
end
end
end
-- ============================================
-- CLIENT HEADLESS SECTION
-- ============================================
do
local HeadlessVisual = {
Enabled = false,
OriginalTransparency = nil,
CharConnection = nil
}
local function restoreHeadless(char)
if not char then return end
if HeadlessVisual.CharConnection then
pcall(function() HeadlessVisual.CharConnection:Disconnect() end)
HeadlessVisual.CharConnection = nil
end
local head = char:FindFirstChild("Head")
if head and HeadlessVisual.OriginalTransparency ~= nil then
head.Transparency = HeadlessVisual.OriginalTransparency
end
HeadlessVisual.OriginalTransparency = nil
end
local function applyHeadless(char)
if not char then return end
restoreHeadless(char)
local head = char:FindFirstChild("Head")
if head then
HeadlessVisual.OriginalTransparency = head.Transparency
head.Transparency = 1
for _, child in ipairs(head:GetChildren()) do
if child:IsA("Decal") or child:IsA("Texture") then
child.Transparency = 1
end
end
end
if HeadlessVisual.CharConnection then
pcall(function() HeadlessVisual.CharConnection:Disconnect() end)
end
HeadlessVisual.CharConnection = char.ChildAdded:Connect(function(child)
if not HeadlessVisual.Enabled then return end
if child.Name == "Head" then
task.wait(0.1)
applyHeadless(char)
end
end)
end
VisualsClient:AddToggle('HeadlessVisual', {
Text = "Headless",
Default = false,
Callback = function(Value)
HeadlessVisual.Enabled = Value
if Value then
if LocalPlayer.Character then
applyHeadless(LocalPlayer.Character)
end
else
restoreHeadless(LocalPlayer.Character)
end
end
})
LocalPlayer.CharacterAdded:Connect(function(char)
if HeadlessVisual.Enabled then
task.wait(0.3)
applyHeadless(char)
end
end)
if HeadlessVisual.Enabled and LocalPlayer.Character then
applyHeadless(LocalPlayer.Character)
end
local oldUnload = Library.Unload
Library.Unload = function()
restoreHeadless(LocalPlayer.Character)
if oldUnload then
oldUnload()
end
end
end
-- ============================================
-- CLIENT PARTICLE AURA SECTION
-- ============================================
do
local ParticleAura = {
Enabled = false,
Selected = "angel",
Color = Color3.fromRGB(133, 220, 255),
ActiveParticles = {}
}
local particleIds = {
["starlight"] = "rbxassetid://134645216613107",
["heavenly"]  = "rbxassetid://139300897520961",
["ribbon"]    = "rbxassetid://132069507632161",
["sakura"]    = "rbxassetid://81755778619404",
["angel"]     = "rbxassetid://97658130917593",
["wind"]      = "rbxassetid://80694081850877",
["flow"]      = "rbxassetid://119913533725648",
["star"]      = "rbxassetid://73754563740680",
}
local function clearParticles()
for i = #ParticleAura.ActiveParticles, 1, -1 do
local p = ParticleAura.ActiveParticles[i]
if p and p.Parent then
p:Destroy()
end
table.remove(ParticleAura.ActiveParticles, i)
end
end
local function colorParticles(root)
local colorSeq = ColorSequence.new(ParticleAura.Color)
for _, desc in ipairs(root:GetDescendants()) do
if desc:IsA("PointLight") then
desc.Color = ParticleAura.Color
elseif desc:IsA("ParticleEmitter") or desc:IsA("Beam") or desc:IsA("Trail") then
desc.Color = colorSeq
end
end
end
local function applyParticleAura(char)
if not char then return end
clearParticles()
local auraId = particleIds[ParticleAura.Selected]
if not auraId then return end
local success, objects = pcall(function()
return game:GetObjects(auraId)
end)
if not success or not objects or not objects[1] then return end
local auraModel = objects[1]
colorParticles(auraModel)
for _, auraPart in ipairs(auraModel:GetChildren()) do
if auraPart:IsA("BasePart") then
local target = char:FindFirstChild(auraPart.Name)
if target then
for _, child in ipairs(auraPart:GetChildren()) do
local clone = child:Clone()
if clone then
clone.Name = "VisualAuraParticle"
clone.Parent = target
table.insert(ParticleAura.ActiveParticles, clone)
end
end
end
end
end
auraModel:Destroy()
end
local function restoreParticleAura(char)
clearParticles()
end
VisualsClient:AddToggle('ParticleAuraEnabled', {
Text = "Particle Aura",
Default = false,
Callback = function(Value)
ParticleAura.Enabled = Value
if Value then
if LocalPlayer.Character then
applyParticleAura(LocalPlayer.Character)
end
else
restoreParticleAura(LocalPlayer.Character)
end
end
}):AddColorPicker('ParticleAuraColor', {
Title = "Aura Color",
Default = Color3.fromRGB(133, 220, 255),
Callback = function(Value)
ParticleAura.Color = Value or Color3.fromRGB(133, 220, 255)
for _, p in ipairs(ParticleAura.ActiveParticles) do
if p and p.Parent then
if p:IsA("PointLight") then
p.Color = ParticleAura.Color
elseif p:IsA("ParticleEmitter") or p:IsA("Beam") or p:IsA("Trail") then
p.Color = ColorSequence.new(ParticleAura.Color)
end
end
end
end
})
VisualsClient:AddDropdown('ParticleAuraType', {
Text = "Aura Type",
Values = {"starlight", "heavenly", "ribbon", "sakura", "angel", "wind", "flow", "star"},
Default = "angel",
Callback = function(Value)
ParticleAura.Selected = Value
if ParticleAura.Enabled and LocalPlayer.Character then
applyParticleAura(LocalPlayer.Character)
end
end
})
LocalPlayer.CharacterAdded:Connect(function(char)
if ParticleAura.Enabled then
task.wait(0.5)
applyParticleAura(char)
end
end)
if ParticleAura.Enabled and LocalPlayer.Character then
applyParticleAura(LocalPlayer.Character)
end
-- Avatar Morph
local AvatarMorph = {
Enabled = false,
UserId = 5042596195,
Originals = nil,
}
local function clearLocalAccessories(character)
for _, item in ipairs(character:GetChildren()) do
if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("BodyColors") or item:IsA("ShirtGraphic") then
item:Destroy()
end
end
end
local function getAllAccessories(model)
local list = {}
for _, desc in ipairs(model:GetDescendants()) do
if desc:IsA("Accessory") then
table.insert(list, desc)
end
end
return list
end
local function cleanAccessory(accessory)
for _, desc in ipairs(accessory:GetDescendants()) do
if desc:IsA("Weld") or desc:IsA("ManualWeld") or desc:IsA("Motor6D") then
desc:Destroy()
end
end
end
local function attachAccessory(character, accessory)
local handle = accessory:FindFirstChild("Handle")
if not handle or not handle:IsA("BasePart") then
warn("[AvatarMorph] No Handle for", accessory.Name)
return
end
handle.Anchored = false
handle.CanCollide = false
handle.Massless = true
cleanAccessory(accessory)
local attachment = handle:FindFirstChildOfClass("Attachment")
if not attachment then
accessory.Parent = character
return
end
local targetAttachment = character:FindFirstChild(attachment.Name, true)
if not targetAttachment or not targetAttachment:IsA("Attachment") then
accessory.Parent = character
return
end
local targetPart = targetAttachment.Parent
if not targetPart or not targetPart:IsA("BasePart") then
accessory.Parent = character
return
end
local weld = Instance.new("Weld")
weld.Name = "AccessoryWeld"
weld.Part0 = handle
weld.Part1 = targetPart
weld.C0 = attachment.CFrame
weld.C1 = targetAttachment.CFrame
weld.Parent = handle
handle.CFrame = targetPart.CFrame * targetAttachment.CFrame * attachment.CFrame:Inverse()
accessory.Parent = character
end
local function saveOriginalAvatar(character)
if not character then return end
local data = {
accessories = {},
clothes = {},
sizes = {},
}
for _, item in ipairs(character:GetChildren()) do
if item:IsA("Accessory") then
table.insert(data.accessories, item:Clone())
elseif item:IsA("Shirt") or item:IsA("Pants") or item:IsA("BodyColors") or item:IsA("ShirtGraphic") then
table.insert(data.clothes, item:Clone())
end
end
for _, part in ipairs(character:GetDescendants()) do
if part:IsA("MeshPart") then
data.sizes[part.Name] = part.Size
end
end
AvatarMorph.Originals = data
end
local function restoreOriginalAvatar(character)
if not character or not AvatarMorph.Originals then return end
clearLocalAccessories(character)
for _, acc in ipairs(AvatarMorph.Originals.accessories) do
local clone = acc:Clone()
if clone then
attachAccessory(character, clone)
end
end
for _, item in ipairs(AvatarMorph.Originals.clothes) do
local clone = item:Clone()
if clone then
clone.Parent = character
end
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
pcall(function()
humanoid:BuildRigFromAttachments()
end)
end
for name, size in pairs(AvatarMorph.Originals.sizes) do
local part = character:FindFirstChild(name)
if part and part:IsA("MeshPart") then
part.Size = size
end
end
end
local function applyAvatarMorph(userId)
local character = LocalPlayer.Character
if not character then return end
local success, model = pcall(function()
return Players:CreateHumanoidModelFromUserId(userId)
end)
if not success or not model then
warn("[AvatarMorph] Failed to load avatar.")
return
end
clearLocalAccessories(character)
for _, accessory in ipairs(getAllAccessories(model)) do
local clone = accessory:Clone()
if clone then
attachAccessory(character, clone)
end
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
pcall(function()
humanoid:BuildRigFromAttachments()
end)
end
for _, item in ipairs(model:GetChildren()) do
if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("BodyColors") or item:IsA("ShirtGraphic") then
local clone = item:Clone()
clone.Parent = character
elseif item:IsA("MeshPart") and character:FindFirstChild(item.Name) then
character[item.Name].Size = item.Size
end
end
model:Destroy()
end
VisualsClient:AddToggle('AvatarMorphEnabled', {
Text = "Avatar Morph",
Default = false,
Callback = function(Value)
AvatarMorph.Enabled = Value
local character = LocalPlayer.Character
if Value then
if character and not AvatarMorph.Originals then
saveOriginalAvatar(character)
end
applyAvatarMorph(AvatarMorph.UserId)
else
restoreOriginalAvatar(character)
end
end
})
local function resolveUserId(input)
local num = tonumber(input)
if num then
return num
end
local ok, userId = pcall(function()
return Players:GetUserIdFromNameAsync(input)
end)
if ok and userId then
return userId
end
warn("[AvatarMorph] Invalid user ID or username:", input)
return nil
end
VisualsClient:AddInput('AvatarMorphUserId', {
Text = "ID / Username",
Default = "5042596195",
Numeric = false,
Callback = function(Value)
local userId = resolveUserId(Value)
if userId then
AvatarMorph.UserId = userId
if AvatarMorph.Enabled then
applyAvatarMorph(userId)
end
end
end
})
local AvatarMorphAddEnabled = false
local addAccessoryDebounce = 0
local function refreshAccessoryDropdown(character)
if not character then return end
local list = {}
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Accessory") and child.Name ~= "Accessory" then
table.insert(list, child.Name)
end
end
if #list == 0 then
list = {" "}
end
if Options.AvatarMorphAccessories then
Options.AvatarMorphAccessories:SetValues(list)
if list[1] == " " then
pcall(function()
Options.AvatarMorphAccessories:SetValue(" ")
end)
else
pcall(function()
Options.AvatarMorphAccessories:SetValue(nil)
end)
end
end
end
local function addAccessoryById(assetId)
local idNum = tonumber(assetId)
if not idNum then return end
local success, objects = pcall(function()
return game:GetObjects("rbxassetid://" .. idNum)
end)
if not success or not objects or #objects == 0 then
warn("[AvatarMorph] Failed to load accessory asset:", assetId)
return
end
local model = objects[1]
local accessory = nil
if model:IsA("Accessory") then
accessory = model
else
for _, desc in ipairs(model:GetDescendants()) do
if desc:IsA("Accessory") then
accessory = desc
break
end
end
end
if not accessory then
warn("[AvatarMorph] No accessory found in asset:", assetId)
return
end
local character = LocalPlayer.Character
if not character then return end
local clone = accessory:Clone()
attachAccessory(character, clone)
refreshAccessoryDropdown(character)
end
VisualsClient:AddToggle('AvatarMorphAddAccessory', {
Text = "Add Accessories",
Default = false,
Callback = function(Value)
AvatarMorphAddEnabled = Value
end
})
VisualsClient:AddInput('AvatarMorphAccessoryId', {
Text = "Accessory ID",
Default = "",
Numeric = true,
Callback = function(Value)
if not AvatarMorphAddEnabled then return end
local num = tonumber(Value)
if not num then return end
addAccessoryDebounce += 1
local current = addAccessoryDebounce
task.delay(0.5, function()
if current == addAccessoryDebounce then
addAccessoryById(num)
end
end)
end
})
VisualsClient:AddDropdown('AvatarMorphAccessories', {
Text = "Current Accessories",
Values = {" "},
Default = " ",
AllowNull = true,
Callback = function(Value)
if Value == " " then return end
local character = LocalPlayer.Character
if not character then return end
local accessory = character:FindFirstChild(Value)
if accessory and accessory:IsA("Accessory") then
accessory:Destroy()
refreshAccessoryDropdown(character)
end
end
})
local function connectAccessoryWatcher(char)
char.ChildAdded:Connect(function(child)
if child:IsA("Accessory") then
refreshAccessoryDropdown(char)
end
end)
char.ChildRemoved:Connect(function(child)
if child:IsA("Accessory") then
refreshAccessoryDropdown(char)
end
end)
refreshAccessoryDropdown(char)
end
if LocalPlayer.Character then
connectAccessoryWatcher(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(function(char)
if AvatarMorph.Enabled then
task.wait(0.5)
AvatarMorph.Originals = nil
saveOriginalAvatar(char)
applyAvatarMorph(AvatarMorph.UserId)
end
connectAccessoryWatcher(char)
end)
local oldUnload = Library.Unload
Library.Unload = function()
restoreParticleAura(LocalPlayer.Character)
if oldUnload then
oldUnload()
end
end
end
-- ============================================
-- ASPECT RATIO SECTION - WITH YOUR MAX VALUES (FIXED)
-- ============================================
-- Aspect Ratio Variables
local AspectRatio = {
Enabled = false,
ScaleX = 1.0,
ScaleY = 1.0,
ScaleZ = 1.0,
Hook = nil
}
-- Toggle for Aspect Ratio
VisualsAspectRatio:AddToggle('AspectRatioToggle', {
Text = "Modify",
Default = false,
Callback = function(Value)
AspectRatio.Enabled = Value
-- DON'T reset sliders here! Just toggle the effect
end
})
-- X Axis Slider (Max: 1.22)
VisualsAspectRatio:AddSlider('AspectRatioX', {
Text = "X Axis",
Min = 0.1,
Max = 1.22,
Default = 1.0,
Rounding = 2,
Callback = function(Value)
AspectRatio.ScaleX = Value
end
})
-- Y Axis Slider (Max: 1.3)
VisualsAspectRatio:AddSlider('AspectRatioY', {
Text = "Y Axis",
Min = 0.1,
Max = 1.3,
Default = 1.0,
Rounding = 2,
Callback = function(Value)
AspectRatio.ScaleY = Value
end
})
-- Z Axis Slider (Max: 1.34)
VisualsAspectRatio:AddSlider('AspectRatioZ', {
Text = "Z Axis",
Min = 0.1,
Max = 1.34,
Default = 1.0,
Rounding = 2,
Callback = function(Value)
AspectRatio.ScaleZ = Value
end
})
-- Hook metamethod
local camera = Workspace.CurrentCamera
local oldNewindex
oldNewindex = hookmetamethod(game, "__newindex", function(object, propertyName, propertyValue)
if object == camera and propertyName == "CFrame" then
if AspectRatio.Enabled then
propertyValue = propertyValue * CFrame.new(
0, 0, 0,
AspectRatio.ScaleX, 0, 0,
0, AspectRatio.ScaleY, 0,
0, 0, AspectRatio.ScaleZ
)
end
end
return oldNewindex(object, propertyName, propertyValue)
end)
AspectRatio.Hook = oldNewindex
-- Cleanup function
local function CleanupAspectRatio()
if AspectRatio.Hook then
hookmetamethod(game, "__newindex", AspectRatio.Hook)
AspectRatio.Hook = nil
end
end
-- Add cleanup to unload function
local originalUnload = Library.Unload
Library.Unload = function()
CleanupAspectRatio()
if originalUnload then
originalUnload()
end
end
do
local HitVignetteSettings = {
Enabled = false,
Color = Color3.fromRGB(180, 0, 0),
Strength = 0.35,
Lifetime = 0.12,
}
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("RedVignetteGui")
if old then old:Destroy() end
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RedVignetteGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui
local vignette = Instance.new("Frame")
vignette.Size = UDim2.new(1, 0, 1, 0)
vignette.BackgroundTransparency = 1
vignette.BorderSizePixel = 0
vignette.ZIndex = 10
vignette.Parent = screenGui
local function makeEdge(size, pos, gradRotation, flip)
local frame = Instance.new("Frame")
frame.Size = size
frame.Position = pos
frame.BackgroundColor3 = HitVignetteSettings.Color
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.ZIndex = 10
frame.Parent = vignette
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new(HitVignetteSettings.Color, HitVignetteSettings.Color)
if flip then
grad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(1, 0.3),
})
else
grad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.3),
NumberSequenceKeypoint.new(1, 1),
})
end
grad.Rotation = gradRotation
grad.Parent = frame
return frame, grad
end
local top,    topGrad    = makeEdge(UDim2.new(1, 0, 0.28, 0), UDim2.new(0,0,0,0),    90, false)
local bottom, bottomGrad = makeEdge(UDim2.new(1, 0, 0.28, 0), UDim2.new(0,0,0.72,0), 90, true)
local left,   leftGrad   = makeEdge(UDim2.new(0.21, 0, 1, 0), UDim2.new(0,0,0,0),    0,  false)
local right,  rightGrad  = makeEdge(UDim2.new(0.21, 0, 1, 0), UDim2.new(0.79,0,0,0), 0,  true)
local edges = {top, bottom, left, right}
local grads = {topGrad, bottomGrad, leftGrad, rightGrad}
local function updateVignetteColor()
local c = HitVignetteSettings.Color
for _, frame in ipairs(edges) do
frame.BackgroundColor3 = c
end
for _, grad in ipairs(grads) do
grad.Color = ColorSequence.new(c, c)
end
end
local function flashVignette()
if not HitVignetteSettings.Enabled then return end
local strength = math.clamp(HitVignetteSettings.Strength or 0.35, 0.05, 1)
local lifetime = math.clamp(HitVignetteSettings.Lifetime or 0.12, 0.05, 2)
for _, f in ipairs(edges) do
TweenService:Create(f, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1 - strength}):Play()
end
task.delay(lifetime, function()
for _, f in ipairs(edges) do
TweenService:Create(f, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
end
end)
end
getgenv().FlashHitVignette = flashVignette
local VignetteSection = VisualsHitVignette
VignetteSection:AddToggle('HitVignetteEnabled', {
Text = "Use",
Default = false,
Callback = function(Value)
HitVignetteSettings.Enabled = (Toggles.HitVignetteEnabled and Toggles.HitVignetteEnabled.Value)
end
}):AddColorPicker('HitVignetteColor', {
Title = "Vignette Color",
Default = Color3.fromRGB(180, 0, 0),
Callback = function(Value)
HitVignetteSettings.Color = Value or Color3.fromRGB(180, 0, 0)
updateVignetteColor()
end
})
VignetteSection:AddSlider('HitVignetteStrength', {
Text = "Strength",
Min = 0.1,
Max = 1,
Default = 0.35,
Rounding = 2,
Callback = function(Value)
HitVignetteSettings.Strength = (Options.HitVignetteStrength and Options.HitVignetteStrength.Value) or 0.35
end
})
VignetteSection:AddSlider('HitVignetteLifetime', {
Text = "Lifetime",
Min = 0.05,
Max = 2,
Default = 0.12,
Rounding = 2,
Suffix = "s",
Callback = function(Value)
HitVignetteSettings.Lifetime = (Options.HitVignetteLifetime and Options.HitVignetteLifetime.Value) or 0.12
end
})
end
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton({Text = 'Unload', Func = function() Library:Unload() end})
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {Default = 'End', NoUI = true, Text = 'Menu keybind'})
MenuGroup:AddToggle('ModernUI', {
Text = 'Modern UI',
Default = false,
Callback = function(Value)
if Library.SetModern then
Library:SetModern(Value)
end
task.delay(0.05, function()
if UpdateMenuGlow then
UpdateMenuGlow()
end
end)
end
})
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('LOMenu')
SaveManager:SetFolder('LOMenu/hoodcustoms-clean')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
-- Put theme controls and menu glow controls in the same groupbox
local ThemeGroup = Tabs['UI Settings']:AddLeftGroupbox('Themes')
ThemeManager:ApplyToGroupbox(ThemeGroup)
-- Menu glow defaults (Linoria default accent blue)
getgenv().MenuGlowColor = getgenv().MenuGlowColor or Color3.fromRGB(0, 85, 255)
getgenv().MenuGlowTransparency = getgenv().MenuGlowTransparency or 0.85
if getgenv().MenuGlowEnabled == nil then
getgenv().MenuGlowEnabled = true
end
local function UpdateMenuGlow()
if not Window.Holder then
if Library.UpdateMenuGlow then
Library:UpdateMenuGlow()
end
return
end
local oldGlow = Window.Holder:FindFirstChild("WindowGlow")
if oldGlow then
oldGlow:Destroy()
end
local glowColor = getgenv().MenuGlowColor or Color3.fromRGB(0, 85, 255)
local isModern = Library.Modern
if isModern then
local glowLayers = 8
local glowMaxInset = 12
local targetCombinedTransparency = 1 - (getgenv().MenuGlowTransparency or 0.85)
local perLayerTransparency = targetCombinedTransparency ^ (1 / glowLayers)
local baseRadius = Library.ModernCornerRadius or 8
local corner = Window.Holder:FindFirstChild("ModernUICorner")
if corner and corner:IsA("UICorner") then
baseRadius = corner.CornerRadius.Offset
end
local newGlow = Instance.new("Frame")
newGlow.Name = "WindowGlow"
newGlow.BackgroundTransparency = 1
newGlow.BorderSizePixel = 0
newGlow.Position = UDim2.new(0, 0, 0, 0)
newGlow.Size = UDim2.new(1, 0, 1, 0)
newGlow.ZIndex = 0
newGlow.Visible = getgenv().MenuGlowEnabled ~= false
newGlow.Parent = Window.Holder
for i = 1, glowLayers do
local t = i / glowLayers
local inset = glowMaxInset * t
local layer = Instance.new("Frame")
layer.Name = "GlowLayer" .. i
layer.BackgroundColor3 = glowColor
layer.BackgroundTransparency = perLayerTransparency
layer.BorderSizePixel = 0
layer.Position = UDim2.new(0, -inset, 0, -inset)
layer.Size = UDim2.new(1, inset * 2, 1, inset * 2)
layer.ZIndex = newGlow.ZIndex - (glowLayers - i)
layer.Parent = newGlow
local layerCorner = Instance.new("UICorner")
layerCorner.CornerRadius = UDim.new(0, baseRadius + inset)
layerCorner.Parent = layer
end
else
local newGlow = Instance.new("ImageLabel")
newGlow.Name = "WindowGlow"
newGlow.BackgroundTransparency = 1
newGlow.Image = "http://www.roblox.com/asset/?id=18245826428"
newGlow.ScaleType = Enum.ScaleType.Slice
newGlow.SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
newGlow.ImageColor3 = glowColor
newGlow.ImageTransparency = 1 - (getgenv().MenuGlowTransparency or 0.85)
newGlow.Position = UDim2.new(0, -20, 0, -20)
newGlow.Size = UDim2.new(1, 40, 1, 40)
newGlow.ZIndex = 0
newGlow.Visible = getgenv().MenuGlowEnabled ~= false
newGlow.Parent = Window.Holder
end
end
-- Apply the initial glow settings now
UpdateMenuGlow()
MenuGroup:AddToggle('MenuGlowEnabled', {
Text = "Enable Menu Glow",
Default = getgenv().MenuGlowEnabled,
Callback = function(Value)
getgenv().MenuGlowEnabled = Value
UpdateMenuGlow()
end
}):AddColorPicker('MenuGlowColor', {
Title = "Glow Color",
Default = getgenv().MenuGlowColor,
Callback = function(Value)
getgenv().MenuGlowColor = Value
UpdateMenuGlow()
end
})
MenuGroup:AddSlider('MenuGlowTransparency', {
Text = "Glow Transparency",
Min = 0,
Max = 100,
Default = 85,
Rounding = 0,
Callback = function(Value)
getgenv().MenuGlowTransparency = Value / 100
UpdateMenuGlow()
end
})
-- Hood Customs Addons integration for existing Linoria UI
-- Uses Library, Tabs, Options, Toggles, Window from the host script
local function HoodAddonsIntegration()
local ok, err = pcall(function()
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService('Workspace')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local Lighting = game:GetService('Lighting')
local CoreGui = game:GetService('CoreGui')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Camera = Workspace.CurrentCamera
if not getgenv().HoodAddons then
getgenv().HoodAddons = { Connections = {}, Drawings = {}, ChatGui = nil }
end
local A = getgenv().HoodAddons
local function addConn(c) table.insert(A.Connections, c) return c end
local function addDraw(d) table.insert(A.Drawings, d) return d end
-- cleanup old addon data if re-running
for _, c in ipairs(A.Connections) do pcall(function() c:Disconnect() end) end
A.Connections = {}
for _, d in ipairs(A.Drawings) do pcall(function() d:Remove() end) end
A.Drawings = {}
if A.ChatGui then pcall(function() A.ChatGui:Destroy() end) A.ChatGui = nil end
local function getRoot(char) return char and (char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso')) end
local function getHum(char) return char and char:FindFirstChildOfClass('Humanoid') end
local function getLocalChar() return LocalPlayer.Character end
local function getLocalRoot() return getRoot(getLocalChar()) end
-- ===== Visuals =====
local VisualBlur = Tabs.Visuals:AddRightGroupbox('Motion Blur')
VisualBlur:AddToggle('AddonMotionBlur', { Text = 'Motion Blur', Default = false })
VisualBlur:AddSlider('AddonBlurSize', { Text = 'Strength', Default = 12, Min = 0, Max = 64, Rounding = 0 })
VisualBlur:AddSlider('AddonBlurSpeed', { Text = 'Speed Threshold', Default = 30, Min = 0, Max = 200, Rounding = 0 })
-- ===== Misc =====
-- Add Spin Bot to the existing Movement groupbox
MiscMovement:AddToggle('AddonSpinBot', { Text = 'Spin Bot', Default = false })
MiscMovement:AddSlider('AddonSpinBotSpeed', { Text = 'Spin Speed', Default = 50, Min = 1, Max = 100, Rounding = 0 })
-- Add Infinite Jump to the existing Movement groupbox
MiscMovement:AddToggle('AddonInfiniteJump', { Text = 'Infinite Jump', Default = false })
MiscAutoFood:AddToggle('AddonAutoBuyFood', { Text = 'Auto Buy Food', Default = false })
MiscAutoFood:AddToggle('AddonAutoEat', { Text = 'Auto Eat', Default = false })
MiscAutoFood:AddSlider('AddonEatHealth', { Text = 'Eat Below %', Default = 50, Min = 1, Max = 100, Rounding = 0 })
MiscAutoFood:AddDropdown('AddonFoodItems', { Text = 'Food Items', Default = { ['[Burger]'] = true, ['[Taco]'] = true }, Multi = true, Values = { '[Burger]', '[Taco]', '[Pizza]', '[Chicken]', '[Candy Basket]' } })
-- ===== Animation Player =====
local AnimationPlayer = {
Enabled = false,
LoopEmote = false,
CurrentEmote = "Ice Spice",
EmoteSpeed = 1,
CustomId = "",
CurrentTrack = nil
}
local EmoteAnimations = {
"Ice Spice",
"Crip Walk",
"Slow-Mo BackFlip",
"Shuffle",
"Coffin",
"Cat",
"Happier Jump",
"Bouncy Twirl",
"V Pose",
"Moonwalk",
"Silly Dance",
"Shuffling",
"Hula Dance",
"Gangnam Style",
"Macarena",
}
local EmoteAnimationIds = {
["Ice Spice"] = "rbxassetid://99558490932154",
["Crip Walk"] = "rbxassetid://110204898807330",
["Slow-Mo BackFlip"] = "rbxassetid://83263981931146",
["Shuffle"] = "rbxassetid://118468821959324",
["Coffin"] = "rbxassetid://126771729094882",
["Cat"] = "rbxassetid://127118661424463",
["Happier Jump"] = "rbxassetid://15609995579",
["Bouncy Twirl"] = "rbxassetid://14352343065",
["V Pose"] = "rbxassetid://10214319518",
["Moonwalk"] = "rbxassetid://507766506",
["Silly Dance"] = "rbxassetid://507767413",
["Shuffling"] = "rbxassetid://507767263",
["Hula Dance"] = "rbxassetid://507766023",
["Gangnam Style"] = "rbxassetid://507765756",
["Macarena"] = "rbxassetid://507766248",
}
local function StopEmote()
if AnimationPlayer.CurrentTrack then
AnimationPlayer.CurrentTrack:Stop()
AnimationPlayer.CurrentTrack = nil
end
end
local function PlayEmote(animId, loop, speed)
local character = LocalPlayer.Character
if not character then return end
StopEmote()
if not animId or animId == "" then return end
-- Allow raw IDs without rbxassetid:// prefix
if tonumber(animId) then
animId = "rbxassetid://" .. animId
end
local anim = Instance.new("Animation")
anim.AnimationId = animId
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then return end
local animTrack = humanoid:LoadAnimation(anim)
AnimationPlayer.CurrentTrack = animTrack
animTrack:Play()
animTrack.Looped = loop
animTrack:AdjustSpeed(speed)
if not loop then
local connection
connection = animTrack.Stopped:Connect(function()
if AnimationPlayer.CurrentTrack == animTrack then
AnimationPlayer.CurrentTrack = nil
end
connection:Disconnect()
end)
end
return animTrack
end
local function GetCurrentAnimId()
if AnimationPlayer.CustomId ~= "" then
return AnimationPlayer.CustomId
end
return EmoteAnimationIds[AnimationPlayer.CurrentEmote]
end
local function UpdateEmote()
if not AnimationPlayer.Enabled then
StopEmote()
return
end
PlayEmote(GetCurrentAnimId(), AnimationPlayer.LoopEmote, AnimationPlayer.EmoteSpeed)
end
MiscAnimationPlayer:AddToggle('AnimationPlayerEnabled', {
Text = 'Play Emote',
Default = false,
Callback = function(Value)
AnimationPlayer.Enabled = Value
UpdateEmote()
end
})
MiscAnimationPlayer:AddToggle('AnimationPlayerLoop', {
Text = 'Loop',
Default = false,
Callback = function(Value)
AnimationPlayer.LoopEmote = Value
UpdateEmote()
end
})
MiscAnimationPlayer:AddDropdown('AnimationPlayerEmote', {
Text = 'Emote',
Default = 'Ice Spice',
Values = EmoteAnimations,
Callback = function(Value)
AnimationPlayer.CurrentEmote = Value
UpdateEmote()
end
})
MiscAnimationPlayer:AddSlider('AnimationPlayerSpeed', {
Text = 'Speed',
Default = 1,
Min = 0.1,
Max = 3,
Rounding = 1,
Callback = function(Value)
AnimationPlayer.EmoteSpeed = Value
if AnimationPlayer.CurrentTrack then
AnimationPlayer.CurrentTrack:AdjustSpeed(Value)
end
end
})
MiscAnimationPlayer:AddInput('AnimationPlayerCustomId', {
Text = 'Custom Animation ID',
Default = '',
Numeric = false,
Finished = true,
Placeholder = 'rbxassetid://... or just numbers',
Callback = function(Value)
AnimationPlayer.CustomId = Value
UpdateEmote()
end
})
MiscAnimationPlayer:AddButton('Stop Emote', function()
StopEmote()
end)
LocalPlayer.CharacterAdded:Connect(function()
task.wait(0.5)
if AnimationPlayer.Enabled then
PlayEmote(GetCurrentAnimId(), AnimationPlayer.LoopEmote, AnimationPlayer.EmoteSpeed)
end
end)
do
local AnimatedToolsTools = {}
local AnimatedToolsOriginalGrips = {}
local AnimatedToolsConnection = nil
local AnimatedToolsToolAddedConn = nil
local AnimatedToolsToolRemovedConn = nil
local AnimatedToolsCharAddedConn = nil
local function AddAnimatedTool(tool)
if not tool or not tool:IsA("Tool") then return end
local handle = tool:FindFirstChild("Handle")
if not handle then return end
if AnimatedToolsOriginalGrips[handle] then return end
AnimatedToolsOriginalGrips[handle] = tool.Grip
AnimatedToolsTools[handle] = tool
end
local function RestoreAllGrips()
for handle, grip in pairs(AnimatedToolsOriginalGrips) do
local tool = AnimatedToolsTools[handle]
if tool and tool.Parent then
pcall(function()
tool.Grip = grip
end)
end
end
AnimatedToolsOriginalGrips = {}
AnimatedToolsTools = {}
end
local function AddCurrentTool()
local char = LocalPlayer.Character
if not char then return end
for _, child in ipairs(char:GetChildren()) do
AddAnimatedTool(child)
end
end
local function ConnectToolEvents(char)
if AnimatedToolsToolAddedConn then
AnimatedToolsToolAddedConn:Disconnect()
AnimatedToolsToolAddedConn = nil
end
if AnimatedToolsToolRemovedConn then
AnimatedToolsToolRemovedConn:Disconnect()
AnimatedToolsToolRemovedConn = nil
end
AnimatedToolsToolAddedConn = char.ChildAdded:Connect(function(child)
AddAnimatedTool(child)
end)
AnimatedToolsToolRemovedConn = char.ChildRemoved:Connect(function(child)
if not child:IsA("Tool") then return end
local handle = child:FindFirstChild("Handle")
if not handle then return end
if AnimatedToolsOriginalGrips[handle] then
pcall(function()
child.Grip = AnimatedToolsOriginalGrips[handle]
end)
AnimatedToolsOriginalGrips[handle] = nil
AnimatedToolsTools[handle] = nil
end
end)
end
local function UpdateAnimatedTools()
if AnimatedToolsConnection then
AnimatedToolsConnection:Disconnect()
AnimatedToolsConnection = nil
end
if AnimatedToolsToolAddedConn then
AnimatedToolsToolAddedConn:Disconnect()
AnimatedToolsToolAddedConn = nil
end
if AnimatedToolsToolRemovedConn then
AnimatedToolsToolRemovedConn:Disconnect()
AnimatedToolsToolRemovedConn = nil
end
if AnimatedToolsCharAddedConn then
AnimatedToolsCharAddedConn:Disconnect()
AnimatedToolsCharAddedConn = nil
end
RestoreAllGrips()
if not Toggles.AnimatedToolsEnabled.Value then
return
end
local char = LocalPlayer.Character
if char then
for _, child in ipairs(char:GetChildren()) do
AddAnimatedTool(child)
end
ConnectToolEvents(char)
end
AnimatedToolsConnection = RunService.Heartbeat:Connect(function(dt)
local horizontalMode = Options.AnimatedToolsHorizontal.Value
local verticalMode = Options.AnimatedToolsVertical.Value
local hSpeed = Options.AnimatedToolsHorizontalSpeed.Value / 4
local vSpeed = Options.AnimatedToolsVerticalSpeed.Value / 4
local horizontal = 0
if horizontalMode == "sine spin" then
horizontal = math.sin(os.clock()) * 45
elseif horizontalMode == "random" then
horizontal = (math.random() * 2 - 1) * 180
elseif horizontalMode == "jitter" then
horizontal = math.random(-10, 10)
elseif horizontalMode == "spin" or horizontalMode == "character spin" then
horizontal = 45
end
local vertical = 0
if verticalMode == "sine spin" then
vertical = math.sin(os.clock()) * 45
elseif verticalMode == "random" then
vertical = (math.random() * 2 - 1) * 180
elseif verticalMode == "jitter" then
vertical = math.random(-10, 10)
elseif verticalMode == "spin" or verticalMode == "character spin" then
vertical = 45
end
for handle, tool in pairs(AnimatedToolsTools) do
if tool and tool.Parent then
tool.Grip = tool.Grip * CFrame.Angles(math.rad(vertical * dt * vSpeed), math.rad(horizontal * dt * hSpeed), 0)
end
end
end)
AnimatedToolsCharAddedConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
if not Toggles.AnimatedToolsEnabled.Value then return end
task.wait(0.1)
for _, child in ipairs(newChar:GetChildren()) do
AddAnimatedTool(child)
end
ConnectToolEvents(newChar)
end)
end
MiscAnimatedTools:AddToggle('AnimatedToolsEnabled', {
Text = 'Animated Tools',
Default = false,
Callback = function(Value)
UpdateAnimatedTools()
end
})
MiscAnimatedTools:AddDropdown('AnimatedToolsHorizontal', {
Text = 'Horizontal',
Default = 'sine spin',
Values = {'character spin', 'sine spin', 'random', 'jitter', 'spin'},
Callback = function(Value)
RestoreAllGrips()
AddCurrentTool()
end
})
MiscAnimatedTools:AddSlider('AnimatedToolsHorizontalSpeed', {
Text = 'Horizontal Speed',
Default = 10,
Min = 0,
Max = 100,
Rounding = 0,
Suffix = '%'
})
MiscAnimatedTools:AddDropdown('AnimatedToolsVertical', {
Text = 'Vertical',
Default = 'sine spin',
Values = {'character spin', 'sine spin', 'random', 'jitter', 'spin'},
Callback = function(Value)
RestoreAllGrips()
AddCurrentTool()
end
})
MiscAnimatedTools:AddSlider('AnimatedToolsVerticalSpeed', {
Text = 'Vertical Speed',
Default = 10,
Min = 0,
Max = 100,
Rounding = 0,
Suffix = '%'
})
end
-- ===== Combat =====
-- ==================== LOGIC ====================
-- Motion blur
local blurEffect = Instance.new('BlurEffect')
blurEffect.Size = 0
blurEffect.Enabled = false
blurEffect.Parent = Lighting
addConn(RunService.RenderStepped:Connect(function(dt)
local motionToggle = Toggles.AddonMotionBlur
local blurSizeOpt = Options.AddonBlurSize
local blurSpeedOpt = Options.AddonBlurSpeed
if motionToggle and motionToggle.Value and blurSizeOpt and blurSpeedOpt then
local camPos = Camera.CFrame.Position
local vel = (camPos - (A.LastCamPos or camPos)).Magnitude / math.max(dt, 0.001)
A.LastCamPos = camPos
local target = math.min(blurSizeOpt.Value, vel / math.max(blurSpeedOpt.Value, 1) * blurSizeOpt.Value)
blurEffect.Enabled = true
blurEffect.Size = blurEffect.Size + (target - blurEffect.Size) * 0.1
else
blurEffect.Enabled = false
blurEffect.Size = 0
end
end))
-- Infinite Jump - Press Space to jump infinitely
addConn(UserInputService.InputBegan:Connect(function(input, gpe)
if gpe then return end
local jumpToggle = Toggles.AddonInfiniteJump
if jumpToggle and jumpToggle.Value and input.KeyCode == Enum.KeyCode.Space then
local hum = getHum(getLocalChar())
if hum then
pcall(function()
hum:ChangeState(Enum.HumanoidStateType.Jumping)
end)
end
end
end))
-- Infinite Jump - Hold Space to keep jumping
addConn(RunService.Heartbeat:Connect(function()
local jumpToggle = Toggles.AddonInfiniteJump
if jumpToggle and jumpToggle.Value then
local hum = getHum(getLocalChar())
if hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
pcall(function()
hum:ChangeState(Enum.HumanoidStateType.Jumping)
end)
end
end
end))
-- Spin Bot
addConn(RunService.Heartbeat:Connect(function(dt)
local spinToggle = Toggles.AddonSpinBot
local spinSpeedOpt = Options.AddonSpinBotSpeed
if spinToggle and spinToggle.Value then
local root = getRoot(getLocalChar())
if root then
local speed = (spinSpeedOpt and spinSpeedOpt.Value) or 50
root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(speed * 360 * dt), 0)
end
end
end))
-- Auto Food
local lastBuy = 0
local buyCooldown = 0.5
local lastEat = 0
local eatCooldown = 0.5
local lastFoodIndex = 0
local cachedFoodItems = nil
local lastCacheUpdate = 0
local foodNames = { '[Burger]', '[Taco]', '[Pizza]', '[Chicken]', '[Candy Basket]' }
local function isFoodTool(name)
for _, n in ipairs(foodNames) do
if name == n then return true end
end
return false
end
local function getSelectedFoodList()
local selected = Options.AddonFoodItems and Options.AddonFoodItems.Value
local list = {}
if typeof(selected) == 'table' then
for name, val in pairs(selected) do
if val == true then table.insert(list, name) end
end
end
return list
end
local function updateFoodCache()
if tick() - lastCacheUpdate < 2 and cachedFoodItems then return cachedFoodItems end
local shop = Workspace:FindFirstChild('FFA_MAP') and Workspace.FFA_MAP:FindFirstChild('Shop')
cachedFoodItems = {}
if shop then
for _, obj in ipairs(shop:GetChildren()) do
if obj.Name:match('Grab') then
local head = obj:FindFirstChild('Head')
local cd = obj:FindFirstChild('ClickDetector')
if head and cd then
local cleanName = obj.Name:gsub('Grab %- ', '')
cachedFoodItems[cleanName] = cd
end
end
end
end
lastCacheUpdate = tick()
return cachedFoodItems
end
local function hasFood(name)
local char = getLocalChar()
if not char then return false end
for _, t in ipairs(char:GetChildren()) do
if t:IsA('Tool') and t.Name == name then return true end
end
for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
if t:IsA('Tool') and t.Name == name then return true end
end
return false
end
local function buyFood(name)
local items = updateFoodCache()
local cd = items[name]
if cd and cd.Parent then
pcall(function() fireclickdetector(cd) end)
return true
end
return false
end
local function tryEatTool(tool)
if not tool then return false end
local char = getLocalChar()
if not char then return false end
if tool.Parent == LocalPlayer.Backpack then
tool.Parent = char
end
pcall(function() tool:Activate() end)
return true
end
local function eatFood()
local char = getLocalChar()
if not char then return false end
for _, t in ipairs(char:GetChildren()) do
if t:IsA('Tool') and isFoodTool(t.Name) then
return tryEatTool(t)
end
end
for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
if t:IsA('Tool') and isFoodTool(t.Name) then
return tryEatTool(t)
end
end
return false
end
addConn(RunService.Heartbeat:Connect(function()
local char = getLocalChar()
local hum = getHum(char)
if not char or not hum then return end
local now = tick()
-- Auto Eat
local eatToggle = Toggles.AddonAutoEat
local eatHealthOpt = Options.AddonEatHealth
if eatToggle and eatToggle.Value and hum.Health > 0 and now - lastEat >= eatCooldown then
local maxHealth = hum.MaxHealth
local pct = maxHealth > 0 and (hum.Health / maxHealth * 100) or 100
local threshold = eatHealthOpt and eatHealthOpt.Value or 50
if pct <= threshold then
if eatFood() then
lastEat = now
end
end
end
-- Auto Buy Food (rotates through selected foods, skips ones already owned)
local buyFoodToggle = Toggles.AddonAutoBuyFood
if buyFoodToggle and buyFoodToggle.Value and now - lastBuy >= buyCooldown then
local selectedList = getSelectedFoodList()
if #selectedList > 0 then
local startIndex = lastFoodIndex
repeat
lastFoodIndex = (lastFoodIndex % #selectedList) + 1
local foodName = selectedList[lastFoodIndex]
if not hasFood(foodName) then
if buyFood(foodName) then
lastBuy = now
end
break
end
until lastFoodIndex == startIndex
end
end
end))
Library:Notify('Hood Customs Addons loaded', 3)
    end)
    -- silently ignore init errors
end
HoodAddonsIntegration()

do
    local chatSpyEnabled = false
    local chatSpyOriginalSize = nil
    local chatSpyLoop = nil

    local function getChatLayout()
        local expChat = CoreGui:FindFirstChild("ExperienceChat")
        return expChat and expChat:FindFirstChild("appLayout")
    end

    local function setChatWindow(enabled)
        local TextChatService = game:GetService("TextChatService")
        if enabled then
            TextChatService.ChatWindowConfiguration.Enabled = true
            task.spawn(function()
                local app = getChatLayout()
                local waited = 0
                while not app and waited < 5 do
                    task.wait(0.1)
                    waited += 0.1
                    app = getChatLayout()
                end
                if app and chatSpyEnabled then
                    if not chatSpyOriginalSize then
                        chatSpyOriginalSize = app.Size
                    end
                    app.Size = UDim2.new(app.Size.X.Scale, app.Size.X.Offset, 0.6, 0)
                    app.Visible = true
                end
            end)
            if chatSpyLoop then pcall(function() chatSpyLoop:Disconnect() end) end
            chatSpyLoop = RunService.Heartbeat:Connect(function()
                if not chatSpyEnabled then
                    pcall(function() chatSpyLoop:Disconnect() end)
                    chatSpyLoop = nil
                    return
                end
                local app = getChatLayout()
                if app then
                    app.Visible = true
                    local target = UDim2.new(app.Size.X.Scale, app.Size.X.Offset, 0.6, 0)
                    if app.Size ~= target then app.Size = target end
                end
            end)
        else
            if chatSpyLoop then
                pcall(function() chatSpyLoop:Disconnect() end)
                chatSpyLoop = nil
            end
            TextChatService.ChatWindowConfiguration.Enabled = false
            local app = getChatLayout()
            if app and chatSpyOriginalSize then
                app.Size = chatSpyOriginalSize
            end
        end
    end

    MiscOther:AddToggle('ChatSpyEnabled', {
        Text = "Chat Spy",
        Default = false,
        Callback = function(Value)
            chatSpyEnabled = Value
            setChatWindow(Value)
        end
    })
end
local SkinData = {
Guns = {
Revolver = {"None", "Candy Cane", "Gingerbread", "Snowflake", "Ghost"},
DoubleBarrel = {"None", "Candy Cane", "Gingerbread", "Snowflake"},
Shotgun = {"None", "Ascension", "Nightmare", "Ghost"},
TacticalShotgun = {"None", "Ascension", "Nightmare"},
SMG = {"None", "Candy Cane", "Gingerbread", "Snowflake"},
},
Knives = {"None", "Beta", "Bitcoin", "Fishbone", "Nightblade"}
}
local CONFIG = {
Enabled = false,
Revolver = "Candy Cane",
DoubleBarrel = "Candy Cane",
Shotgun = "Ascension",
TacticalShotgun = "Ascension",
SMG = "Candy Cane",
Knife = "Fishbone"
}
local function GetSkinModel(weapon, skin)
if not skin or skin == '' or skin == 'None' then return nil end
if weapon == 'Knife' then
local knives = ReplicatedStorage:FindFirstChild('Knives')
if knives then return knives:FindFirstChild(skin) end
return nil
end
local wraps = ReplicatedStorage:FindFirstChild('Wraps')
if not wraps then return nil end
local folder = wraps:FindFirstChild('[' .. weapon .. ']')
if not folder then return nil end
return folder:FindFirstChild(skin)
end
local function RestoreKnifeVisibility(tool)
for _, part in ipairs(tool:GetDescendants()) do
if part:IsA('BasePart') then
local original = part:GetAttribute('KnifeSkin_OriginalLTM')
if original ~= nil then
part.LocalTransparencyModifier = original
part:SetAttribute('KnifeSkin_OriginalLTM', nil)
end
end
end
end
local KnifeSkinData = {}
local function CleanupKnifeAnimations(tool)
local data = KnifeSkinData[tool]
if not data or not data.Tracks then return end
for _, track in ipairs(data.Tracks) do
pcall(function()
if typeof(track) == "Instance" and track:IsA("AnimationTrack") and track.Stop then
track:Stop()
end
end)
end
data.Tracks = nil
end
local function RemoveKnifeSkin(tool)
if not tool then return end
local data = KnifeSkinData[tool]
if data then
if data.Connections then
for _, c in ipairs(data.Connections) do
pcall(function() c:Disconnect() end)
end
end
CleanupKnifeAnimations(tool)
if data.Clone and data.Clone.Parent then
data.Clone:Destroy()
end
KnifeSkinData[tool] = nil
end
RestoreKnifeVisibility(tool)
end
local BAD_ADORNMENT_CLASSES = {
SelectionBox = true;
BoxHandleAdornment = true;
SphereHandleAdornment = true;
LineHandleAdornment = true;
ConeHandleAdornment = true;
CylinderHandleAdornment = true;
SurfaceSelection = true;
ArcHandles = true;
Handles = true;
}
local function HookKnifeSkinAnimations(tool, clone)
local data = KnifeSkinData[tool]
if not data then return end
if data.Connections then
for _, c in ipairs(data.Connections) do
pcall(function() c:Disconnect() end)
end
end
data.Connections = {}
local conns = data.Connections
-- If the skin model includes its own script, let that script handle animations.
for _, d in ipairs(clone:GetDescendants()) do
if d:IsA("LocalScript") or d:IsA("Script") or d:IsA("ModuleScript") then
return
end
end
local animFolder = Instance.new("Folder")
animFolder.Name = "KnifeSkinAnimations"
for _, d in ipairs(clone:GetDescendants()) do
if d:IsA("Animation") then
d:Clone().Parent = animFolder
end
end
if #animFolder:GetChildren() == 0 then
animFolder:Destroy()
return
end
animFolder.Parent = clone
local function getAnimator()
local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local animator = hum and hum:FindFirstChildOfClass("Animator")
if not animator and hum then
animator = Instance.new("Animator")
animator.Parent = hum
end
return animator
end
local function playAnim(preferredName)
local animator = getAnimator()
if not animator then return end
local anim = animFolder:FindFirstChild(preferredName)
if not anim then
for _, fallback in ipairs({"Slash", "Attack", "Stab", "Swing"}) do
anim = animFolder:FindFirstChild(fallback)
if anim then break end
end
end
if anim and anim:IsA("Animation") then
local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
if ok and track and typeof(track) == "Instance" and track:IsA("AnimationTrack") and track.Play then
track:Play()
data.Tracks = data.Tracks or {}
table.insert(data.Tracks, track)
end
end
end
table.insert(conns, tool.Equipped:Connect(function()
CleanupKnifeAnimations(tool)
local idle = animFolder:FindFirstChild("Idle") or animFolder:FindFirstChild("IdleLoop")
if idle then
local animator = getAnimator()
if animator then
local ok, track = pcall(function() return animator:LoadAnimation(idle) end)
if ok and track and typeof(track) == "Instance" and track:IsA("AnimationTrack") and track.Play then
track.Looped = true
track:Play()
data.Tracks = data.Tracks or {}
table.insert(data.Tracks, track)
end
end
end
end))
table.insert(conns, tool.Activated:Connect(function()
playAnim("Slash")
end))
table.insert(conns, tool.Unequipped:Connect(function()
CleanupKnifeAnimations(tool)
end))
table.insert(conns, tool.AncestryChanged:Connect(function()
if not tool:IsDescendantOf(LocalPlayer.Character) then
RemoveKnifeSkin(tool)
end
end))
end
local KnifeSkinWorkspaceFolder
local function ApplyKnifeSkin(tool, skinModel)
if not tool or not skinModel then return end
local char = tool.Parent
if not char or not char:IsA("Model") or char ~= LocalPlayer.Character then return end
local originalHandle = tool:FindFirstChild('Handle')
if not originalHandle or not originalHandle:IsA('BasePart') then return end
RemoveKnifeSkin(tool)
-- Hide every original BasePart locally using LocalTransparencyModifier so the server doesn't delete the knife.
for _, part in ipairs(tool:GetDescendants()) do
if part:IsA('BasePart') then
if part:GetAttribute('KnifeSkin_OriginalLTM') == nil then
part:SetAttribute('KnifeSkin_OriginalLTM', part.LocalTransparencyModifier)
end
part.LocalTransparencyModifier = 1
end
end
if not KnifeSkinWorkspaceFolder or not KnifeSkinWorkspaceFolder.Parent then
KnifeSkinWorkspaceFolder = Instance.new("Folder")
KnifeSkinWorkspaceFolder.Name = "KnifeSkinWorkspaceFolder"
KnifeSkinWorkspaceFolder.Parent = Workspace
end
local clone = skinModel:Clone()
clone.Name = 'AppliedKnifeSkin'
-- Parent the visual clone to workspace instead of the tool/character so the server doesn't delete the knife.
clone.Parent = KnifeSkinWorkspaceFolder
-- Strip builder adornments/selection boxes and prep parts.
for _, d in ipairs(clone:GetDescendants()) do
if BAD_ADORNMENT_CLASSES[d.ClassName] then
d:Destroy()
elseif d:IsA('BasePart') then
d.CanCollide = false
d.Anchored = true
d.Massless = true
end
end
local skinHandle = clone:FindFirstChild('Handle') or clone:FindFirstChildWhichIsA('BasePart')
if not skinHandle then
clone:Destroy()
RestoreKnifeVisibility(tool)
return
end
clone.PrimaryPart = skinHandle
skinHandle.Transparency = 0
local rootOffset = originalHandle.CFrame:Inverse() * skinHandle.CFrame
skinHandle.CFrame = originalHandle.CFrame * rootOffset
-- Only weld skin parts that aren't already held by an internal joint.
-- This keeps static skins together while letting animated skins use their own Motor6Ds.
local function hasInternalJoint(part)
for _, d in ipairs(clone:GetDescendants()) do
if d:IsA('Weld') or d:IsA('WeldConstraint') or d:IsA('Motor6D') then
local p0, p1 = d.Part0, d.Part1
if (p0 == part or p1 == part) and ((p0 and p0:IsDescendantOf(clone)) or (p1 and p1:IsDescendantOf(clone))) then
return true
end
end
end
return false
end
for _, part in ipairs(clone:GetDescendants()) do
if part:IsA('BasePart') and part ~= skinHandle and not hasInternalJoint(part) then
local weld = Instance.new('Weld')
weld.Part0 = skinHandle
weld.Part1 = part
weld.C0 = skinHandle.CFrame:Inverse() * part.CFrame
weld.Parent = part
end
end
KnifeSkinData[tool] = {Clone = clone, Connections = {}, Tracks = {}}
table.insert(KnifeSkinData[tool].Connections, RunService.RenderStepped:Connect(function()
local currentHandle = tool:FindFirstChild('Handle')
if not currentHandle or not currentHandle:IsA('BasePart') or not tool:IsDescendantOf(LocalPlayer.Character) then
RemoveKnifeSkin(tool)
return
end
skinHandle.CFrame = currentHandle.CFrame * rootOffset
end))
HookKnifeSkinAnimations(tool, clone)
end
local function ApplyGunSkin(holder, skinModel)
if not holder or not skinModel then return end
local handle = holder:FindFirstChild('Handle')
if not handle or not handle:IsA('BasePart') then return end
for _, child in ipairs(holder:GetChildren()) do
if child:IsA('Model') then
child:Destroy()
end
end
local clone = skinModel:Clone()
local pp = clone:FindFirstChildWhichIsA('BasePart')
if not pp then return end
clone:SetPrimaryPartCFrame(handle.CFrame)
clone.Parent = holder
handle.Transparency = 1
for _, part in ipairs(clone:GetDescendants()) do
if part:IsA('BasePart') then
part.CanCollide = false
part.Anchored = false
if part ~= pp then
local w = Instance.new('Weld')
w.Part0 = handle
w.Part1 = part
w.C0 = handle.CFrame:Inverse() * part.CFrame
w.Parent = part
end
end
end
local w = Instance.new('Weld')
w.Part0 = handle
w.Part1 = pp
w.C0 = handle.CFrame:Inverse() * pp.CFrame
w.Parent = pp
end
local function OnToolAdded(tool)
local char = LocalPlayer.Character
if not char or tool.Parent ~= char then return end
if tool.Name == '[Knife]' then
if CONFIG.Enabled and CONFIG.Knife and CONFIG.Knife ~= 'None' then
local skin = GetSkinModel('Knife', CONFIG.Knife)
if skin then ApplyKnifeSkin(tool, skin) end
else
RemoveKnifeSkin(tool)
end
return
end
if not CONFIG.Enabled then return end
local weapon = tool.Name:match('^%[(.+)%]$')
if weapon and CONFIG[weapon] and CONFIG[weapon] ~= 'None' then
local skin = GetSkinModel(weapon, CONFIG[weapon])
if skin then ApplyGunSkin(tool, skin) end
end
end
local HandleMap = { DB_HANDLE = 'DoubleBarrel', REV_HANDLE = 'Revolver' }
local function ApplyHandles(char)
for h, weapon in pairs(HandleMap) do
task.defer(function()
local skin = CONFIG[weapon]
local folder = char:FindFirstChild(h)
if folder and skin and skin ~= '' and skin ~= 'None' and CONFIG.Enabled then
local skinmodel = GetSkinModel(weapon, skin)
if skinmodel then ApplyGunSkin(folder, skinmodel) end
end
end)
end
end
local function ConnectCharacter(char)
char.ChildAdded:Connect(function(child)
if child:IsA('Tool') then
task.wait(0.1)
OnToolAdded(child)
elseif HandleMap[child.Name] then
ApplyHandles(char)
end
end)
char.ChildRemoved:Connect(function(child)
if child:IsA('Tool') and child.Name == '[Knife]' then
RemoveKnifeSkin(child)
end
end)
ApplyHandles(char)
for _, t in ipairs(char:GetChildren()) do
if t:IsA('Tool') then
task.wait(0.05)
OnToolAdded(t)
end
end
end
-- Create gun skin dropdowns
local AllGunSkinNames = {
"None", "Candy Cane", "Gingerbread", "Snowflake", "Ghost",
"Ascension", "Nightmare", "Kirumi", "Void Dragon", "Hell Hound",
"Lovestruck", "Adurite", "Hallows", "Heartbringer", "Arctic",
"Lightbringer", "Deathbringer", "Hell Dragon", "Kitty",
"Shiryus Breath", "Poseidon", "Amethyst", "Arsenic", "Volcanic Ashes",
"Floral", "Binary", "Voxel", "Hello Kitty", "Radiation", "Void",
"Hexagram", "Strawberry Shortcake", "Black Ice", "Crimson Fangs",
"Green Tint", "Ember", "Cupid", "Beta"
}
local KnifeSkinNames = {"None", "Beta", "Bitcoin", "Fishbone", "Nightblade"}
MiscSkins:AddToggle('SkinChangerEnabled', {
Text = "Use",
Default = false,
Callback = function(Value)
CONFIG.Enabled = Value
if Value then
Notify("Skin Changer", "Enabled!", 2)
-- Refresh skins on currently equipped tools only
if LocalPlayer.Character then
for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
if t:IsA('Tool') then OnToolAdded(t) end
end
end
else
Notify("Skin Changer", "Disabled!", 2)
-- Remove knife skins
local function cleanKnife(holder)
for _, t in ipairs(holder:GetChildren()) do
if t:IsA('Tool') and t.Name == '[Knife]' then
RemoveKnifeSkin(t)
end
end
end
if LocalPlayer.Character then cleanKnife(LocalPlayer.Character) end
cleanKnife(LocalPlayer.Backpack)
end
end
})
MiscSkins:AddDropdown('SelectedRevolverSkin', {
Text = "Revolver Skin",
Values = AllGunSkinNames,
Default = "Candy Cane",
Callback = function(Value)
CONFIG.Revolver = Value
if LocalPlayer.Character then
for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
if t:IsA('Tool') then OnToolAdded(t) end
end
end
end
})
MiscSkins:AddDropdown('SelectedDoubleBarrelSkin', {
Text = "Double Barrel Skin",
Values = AllGunSkinNames,
Default = "Candy Cane",
Callback = function(Value)
CONFIG.DoubleBarrel = Value
if LocalPlayer.Character then
for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
if t:IsA('Tool') then OnToolAdded(t) end
end
end
end
})
MiscSkins:AddDropdown('SelectedShotgunSkin', {
Text = "Shotgun Skin",
Values = AllGunSkinNames,
Default = "Ascension",
Callback = function(Value)
CONFIG.Shotgun = Value
if LocalPlayer.Character then
for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
if t:IsA('Tool') then OnToolAdded(t) end
end
end
end
})
MiscSkins:AddDropdown('SelectedTacticalShotgunSkin', {
Text = "Tactical Shotgun Skin",
Values = AllGunSkinNames,
Default = "Ascension",
Callback = function(Value)
CONFIG.TacticalShotgun = Value
if LocalPlayer.Character then
for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
if t:IsA('Tool') then OnToolAdded(t) end
end
end
end
})
MiscSkins:AddDropdown('SelectedSMGSkin', {
Text = "SMG Skin",
Values = AllGunSkinNames,
Default = "Candy Cane",
Callback = function(Value)
CONFIG.SMG = Value
if LocalPlayer.Character then
for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
if t:IsA('Tool') then OnToolAdded(t) end
end
end
end
})
-- KNIFE CHANGER - Visual clone parented to character to avoid server deletion
MiscSkins:AddDropdown('SelectedKnifeSkin', {
Text = "Knife Skin",
Values = KnifeSkinNames,
Default = "Fishbone",
Callback = function(Value)
CONFIG.Knife = Value
-- Apply to currently equipped knife only
if LocalPlayer.Character then
for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
if t:IsA('Tool') and t.Name == '[Knife]' then
OnToolAdded(t)
end
end
end
end
})
-- Connect character events
if LocalPlayer.Character then
ConnectCharacter(LocalPlayer.Character)
else
LocalPlayer.CharacterAdded:Once(ConnectCharacter)
end
LocalPlayer.CharacterAdded:Connect(function(char)
task.wait(0.5)
ConnectCharacter(char)
end)
local beamOptions = {"Red", "Blue", "Green", "Orange", "Lightning", "Beta", "Hallows", "Kitty", "Kirumi", "Rainbow"}
MiscSkins:AddDropdown('SelectedBeamSkin', {
Text = "Beam",
Values = beamOptions,
Default = "Green",
Callback = function(Value)
-- Update all weapons to use the selected beam color (ALWAYS WORKS, independent of skin changer toggle)
getgenv().BulletChanger.DoubleBarrel = Value
getgenv().BulletChanger.Revolver = Value
getgenv().BulletChanger.Shotgun = Value
getgenv().BulletChanger.SMG = Value
getgenv().BulletChanger.TacticalShotgun = Value
-- Update the bullet beams
local dataFolder = LocalPlayer:FindFirstChild("DataFolder")
if dataFolder then
local inventoryData = dataFolder:FindFirstChild("InventoryData")
if inventoryData then
local bulletBeams = inventoryData:FindFirstChild("BulletBeams")
local equippedBulletBeams = dataFolder:FindFirstChild("EquippedBulletBeams")
if bulletBeams and bulletBeams:IsA("StringValue") then
local bulletBeamData = {}
local weaponCodes = {
DoubleBarrel = "109d1326878cc594bc1bb42d126250810999782f",
Revolver = "539db315b53f77390c0aa74773158e25bedcdd6e",
Shotgun = "b415a7273aa86cbc2adc445fde5435eb5afababa",
SMG = "005af87725b42ac4ca8103d11af6bf0c7d55f7b3",
TacticalShotgun = "109d1326878cc594bc1bb42d126250810999782f"
}
for weapon, code in pairs(weaponCodes) do
bulletBeamData[code] = { Name = getgenv().BulletChanger[weapon] }
end
bulletBeams.Value = game:GetService("HttpService"):JSONEncode(bulletBeamData)
end
if equippedBulletBeams and equippedBulletBeams:IsA("StringValue") then
local equippedData = {}
equippedData["[DoubleBarrel]"] = "109d1326878cc594bc1bb42d126250810999782f"
equippedData["[Revolver]"] = "539db315b53f77390c0aa74773158e25bedcdd6e"
equippedData["[TacticalShotgun]"] = "109d1326878cc594bc1bb42d126250810999782f"
equippedData["[SMG]"] = "005af87725b42ac4ca8103d11af6bf0c7d55f7b3"
equippedData["[Shotgun]"] = "b415a7273aa86cbc2adc445fde5435eb5afababa"
equippedBulletBeams.Value = game:GetService("HttpService"):JSONEncode(equippedData)
end
end
end
Notify("Beam Changer", "Beam color set to " .. Value, 2)
end
})
-- Initialize BulletChanger if not already set
if not getgenv().BulletChanger then
getgenv().BulletChanger = {
DoubleBarrel = "Green",
Revolver = "Green",
Shotgun = "Green",
SMG = "Green",
TacticalShotgun = "Green"
}
end
-- Apply beam colors on game load / character spawn
local function ApplyBeamColors()
local dataFolder = LocalPlayer:FindFirstChild("DataFolder")
if dataFolder then
local inventoryData = dataFolder:FindFirstChild("InventoryData")
if inventoryData then
local bulletBeams = inventoryData:FindFirstChild("BulletBeams")
local equippedBulletBeams = dataFolder:FindFirstChild("EquippedBulletBeams")
if bulletBeams and bulletBeams:IsA("StringValue") then
local bulletBeamData = {}
local weaponCodes = {
DoubleBarrel = "109d1326878cc594bc1bb42d126250810999782f",
Revolver = "539db315b53f77390c0aa74773158e25bedcdd6e",
Shotgun = "b415a7273aa86cbc2adc445fde5435eb5afababa",
SMG = "005af87725b42ac4ca8103d11af6bf0c7d55f7b3",
TacticalShotgun = "109d1326878cc594bc1bb42d126250810999782f"
}
for weapon, code in pairs(weaponCodes) do
bulletBeamData[code] = { Name = getgenv().BulletChanger[weapon] }
end
bulletBeams.Value = game:GetService("HttpService"):JSONEncode(bulletBeamData)
end
if equippedBulletBeams and equippedBulletBeams:IsA("StringValue") then
local equippedData = {}
equippedData["[DoubleBarrel]"] = "109d1326878cc594bc1bb42d126250810999782f"
equippedData["[Revolver]"] = "539db315b53f77390c0aa74773158e25bedcdd6e"
equippedData["[TacticalShotgun]"] = "109d1326878cc594bc1bb42d126250810999782f"
equippedData["[SMG]"] = "005af87725b42ac4ca8103d11af6bf0c7d55f7b3"
equippedData["[Shotgun]"] = "b415a7273aa86cbc2adc445fde5435eb5afababa"
equippedBulletBeams.Value = game:GetService("HttpService"):JSONEncode(equippedData)
end
end
end
end
-- Apply on character spawn
LocalPlayer.CharacterAdded:Connect(function()
task.wait(1)
ApplyBeamColors()
end)
-- Apply immediately if character exists
task.wait(1)
ApplyBeamColors()
local HitLogsScript2 = {
Enabled = false,
CustomTextEnabled = false,
CustomText = '[evolution] Hit "{target}" for {damage} damage.',
WordColors = {
Color3.fromRGB(255, 74, 74),
Color3.fromRGB(77, 163, 255),
Color3.fromRGB(77, 255, 124),
Color3.fromRGB(255, 241, 77),
Color3.fromRGB(255, 119, 242),
Color3.fromRGB(157, 77, 255),
Color3.fromRGB(77, 242, 255),
}
}
VisualsHitLogs:AddToggle('HitLogsScript2Enabled', {
Text = "Use",
Default = false,
Callback = function(Value)
HitLogsScript2.Enabled = Value
end
})
VisualsHitLogs:AddToggle('HitLogsCustomTextEnabled', {
Text = "Custom Text",
Default = false,
Callback = function(Value)
HitLogsScript2.CustomTextEnabled = Value
end
})
VisualsHitLogs:AddInput('HitLogsCustomText', {
Text = "Text",
Default = '[evolution] Hit "{target}" for {damage} damage.',
Numeric = false,
Callback = function(Value)
HitLogsScript2.CustomText = Value
end
})
VisualsHitLogs:AddColorPicker('HitLogsWord1Color', {
Title = "Word 1",
Default = HitLogsScript2.WordColors[1],
Callback = function(Value)
HitLogsScript2.WordColors[1] = Value or HitLogsScript2.WordColors[1]
end
}):AddColorPicker('HitLogsWord2Color', {
Title = "Word 2",
Default = HitLogsScript2.WordColors[2],
Callback = function(Value)
HitLogsScript2.WordColors[2] = Value or HitLogsScript2.WordColors[2]
end
}):AddColorPicker('HitLogsWord3Color', {
Title = "Word 3",
Default = HitLogsScript2.WordColors[3],
Callback = function(Value)
HitLogsScript2.WordColors[3] = Value or HitLogsScript2.WordColors[3]
end
}):AddColorPicker('HitLogsWord4Color', {
Title = "Word 4",
Default = HitLogsScript2.WordColors[4],
Callback = function(Value)
HitLogsScript2.WordColors[4] = Value or HitLogsScript2.WordColors[4]
end
}):AddColorPicker('HitLogsWord5Color', {
Title = "Word 5",
Default = HitLogsScript2.WordColors[5],
Callback = function(Value)
HitLogsScript2.WordColors[5] = Value or HitLogsScript2.WordColors[5]
end
}):AddColorPicker('HitLogsWord6Color', {
Title = "Word 6",
Default = HitLogsScript2.WordColors[6],
Callback = function(Value)
HitLogsScript2.WordColors[6] = Value or HitLogsScript2.WordColors[6]
end
}):AddColorPicker('HitLogsWord7Color', {
Title = "Word 7",
Default = HitLogsScript2.WordColors[7],
Callback = function(Value)
HitLogsScript2.WordColors[7] = Value or HitLogsScript2.WordColors[7]
end
})
VisualsHitLogs:AddLabel('Placeholders: {target} | {damage}')
local notifications = {}
local BASE_Y = -120
local SPACING = 22
local function UpdatePositions()
for i, label in ipairs(notifications) do
local targetPos = UDim2.new(0.5, 0, 1, BASE_Y - ((i - 1) * SPACING))
TweenService:Create(
label,
TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
{Position = targetPos}
):Play()
end
end
local function CreateScript2HitMessage(targetName, damage)
if not HitLogsScript2.Enabled then return end
if not targetName or targetName == "" then targetName = "blank" end
local gui = nil
for _, g in pairs(CoreGui:GetChildren()) do
if g.Name == "EvolutionHitUI" then
gui = g
break
end
end
if not gui then
gui = Instance.new("ScreenGui")
gui.Name = "EvolutionHitUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui
end
local label = Instance.new("TextLabel")
label.AnchorPoint = Vector2.new(0.5, 1)
label.Position = UDim2.new(0.5, 0, 1, BASE_Y + 20)
label.Size = UDim2.new(0, 340, 0, 22)
label.BackgroundTransparency = 1
label.TextTransparency = 1
label.RichText = true
label.Font = Enum.Font.Code
label.TextSize = 16
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
local function colorToHex(c)
return string.format("#%02X%02X%02X", math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255))
end
local function colorWords(text)
local out = {}
local wordIndex = 0
for word, space in text:gmatch("(%S+)(%s*)") do
wordIndex = wordIndex + 1
local colorIndex = ((wordIndex - 1) % #HitLogsScript2.WordColors) + 1
local hex = colorToHex(HitLogsScript2.WordColors[colorIndex])
table.insert(out, string.format('<font color="%s">%s</font>', hex, word))
table.insert(out, space)
end
return table.concat(out)
end
local messageText
if HitLogsScript2.CustomTextEnabled then
local template = HitLogsScript2.CustomText or '[evolution] Hit "{target}" for {damage} damage.'
template = template:gsub("{target}", targetName):gsub("{damage}", tostring(math.floor(damage or 0)))
messageText = colorWords(template)
else
messageText = string.format(
'<font color="#EAEAEA">[evolution] Hit </font><font color="#FF4A4A">"%s"</font><font color="#4DA3FF"> for %d </font><font color="#EAEAEA">damage.</font>',
targetName,
math.floor(damage or 0)
)
end
label.Text = messageText
label.Parent = gui
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.new(0, 0, 0)
stroke.Thickness = 1
stroke.Transparency = 1
stroke.Parent = label
table.insert(notifications, 1, label)
UpdatePositions()
TweenService:Create(label, TweenInfo.new(0.18), {
TextTransparency = 0
}):Play()
TweenService:Create(stroke, TweenInfo.new(0.18), {
Transparency = 0
}):Play()
task.delay(1.5, function()
TweenService:Create(label, TweenInfo.new(0.25), {
TextTransparency = 1,
Position = label.Position - UDim2.fromOffset(0, 10)
}):Play()
TweenService:Create(stroke, TweenInfo.new(0.25), {
Transparency = 1
}):Play()
task.wait(0.25)
for i, v in ipairs(notifications) do
if v == label then
table.remove(notifications, i)
break
end
end
label:Destroy()
UpdatePositions()
end)
end
getgenv()._originalHitLogs = HitLogs
HitLogs = function(Player, damage)
    if getgenv()._originalHitLogs then
        getgenv()._originalHitLogs(Player, damage)
    end
    if HitLogsScript2.Enabled and Player then
        local targetName = Player.DisplayName or Player.Name or "blank"
        CreateScript2HitMessage(targetName, damage or 0)
    end
end
if getgenv().EspLibrary and getgenv().EspLibrary.Unload then
pcall(getgenv().EspLibrary.Unload, getgenv().EspLibrary)
end
local function InitializeESP()
local GetService = setmetatable({}, {
__index = function(_, Name)
return game:GetService(Name);
end;
})
local Workspace, Players, RunService, HttpService = GetService["Workspace"], GetService["Players"], GetService["RunService"], GetService["HttpService"];
local LocalPlayer, Camera = Players.LocalPlayer, Workspace.CurrentCamera;
local WorldToViewportPoint, FindFirstChildOfClass, FindFirstChild = Camera.WorldToViewportPoint, game.FindFirstChildOfClass, game.FindFirstChild;
local NewVector3, NewVector2, Dim, Dim2, DimOffset = Vector3.new, Vector2.new, UDim.new, UDim2.new, UDim2.fromOffset;
local NumSeq = NumberSequence.new;
local NumKey = NumberSequenceKeypoint.new;
local Format, Spawn, Clear, Floor, Clamp, Abs, Tan, Rad, Huge, Remove = string.format, task.spawn, table.clear, math.floor, math.clamp, math.abs, math.tan, math.rad, math.huge, table.remove;
local Frame, ZeroVector3, CameraPosition, CachedFocalLength, ViewPortY, Updates = 1 / 60, NewVector3(0,0,0), NewVector3(0,0,0), 0, 0, 0;
local function CameraCache()
ViewPortY = Camera.ViewportSize.Y;
CachedFocalLength = ViewPortY / (2 * Tan(Rad(Camera.FieldOfView) * 0.5));
end
CameraCache();
Camera:GetPropertyChangedSignal("FieldOfView"):Connect(CameraCache);
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(CameraCache);
getgenv().EspLibrary = {
['Directory'] = 'Esp',
['Cache'] = {},
['Holder'] = nil,
['Threads'] = {},
['Connections'] = {},
['Table'] = {
['Enabled'] = true,
['ShowLocalPlayer'] = false,
['Distance'] = 7520,
['RefreshRate'] = 60,
['Font'] = 'TahomaBold',
['FontSize'] = 12,
['FontType'] = 'none',
['Boxes'] = {
['Enabled'] = true,
['DynamicBoxes'] = true,
['Type'] = "2D",
['Rotation'] = 90,
['Bounding Box'] = {
['Enabled'] = true,
['IncludeAcsessories'] = false,
['BoxX'] = 0,
['BoxY'] = 0,
},
['Box Glow'] = {
['Enabled'] = true,
['Top'] = Color3.fromRGB(0, 255, 255),
['Bot'] = Color3.fromRGB(0, 255, 255),
['Transparency'] = {0.75, 0.75},
},
['Filled'] = {
['Enabled'] = true,
['Top'] = Color3.fromRGB(255, 255, 255),
['Bot'] = Color3.fromRGB(0, 255, 255),
['Transparency'] = {1, 0.65},
},
['Outline'] = {
['Enabled'] = false,
['Color'] = Color3.fromRGB(0, 0, 0),
},
['Gradients'] = {
['Top'] = Color3.fromRGB(0, 255, 255),
['Bot'] = Color3.fromRGB(0, 85, 255),
},
},
['Bars'] = {
['Health Bar'] = {
['Enabled'] = true,
['Position'] = 'Left',
['Top'] = Color3.fromRGB(0, 255, 0),
['Mid'] = Color3.fromRGB(255, 170, 0),
['Bot'] = Color3.fromRGB(255, 0, 0),
['Text'] = {
['Enabled'] = true,
['Color'] = Color3.fromRGB(255, 255, 255),
},
},
},
['Texts'] = {
['Name'] = {
['Enabled'] = true,
['Color'] = Color3.fromRGB(255, 255, 255),
},
['Distance'] = {
['Enabled'] = true,
['Color'] = Color3.fromRGB(255, 255, 255),
},
['Weapon'] = {
['Enabled'] = true,
['Color'] = Color3.fromRGB(255, 255, 255),
},
},
['Flags'] = {
['Walking'] = {
['Enabled'] = true,
['Color'] = Color3.fromRGB(255, 0, 0),
['Text'] = "Walking",
},
['Jumping'] = {
['Enabled'] = true,
['Color'] = Color3.fromRGB(144, 238, 144),
['Text'] = "Jumping",
},
['Swimming'] = {
['Enabled'] = true,
['Color'] = Color3.fromRGB(0, 255, 255),
['Text'] = "Swimming",
},
}
}
}
local EspLibrary = getgenv().EspLibrary;
local Table = EspLibrary['Table'];
local Fonts = {}; do
local function FontsRegister(Name, Weight, Style, Asset)
if not isfile(Asset.Id) then
writefile(Asset.Id, Asset.Font)
end
if isfile(Name .. ".font") then
delfile(Name .. ".font")
end
local Info = {
name = Name,
faces = {
{
name = "Normal",
weight = Weight,
style = Style,
assetId = getcustomasset(Asset.Id),
},
},
}
writefile(Name .. ".font", HttpService:JSONEncode(Info))
return getcustomasset(Name .. ".font")
end;
Fonts.Tahoma = FontsRegister("Tahoma", 400, "Normal", {
Id = "Tahoma.ttf",
Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"),
})
Fonts.XPTahoma = FontsRegister("XPTahoma", 400, "Normal", {
Id = "Tahoma8PTBOLD.ttf",
Font = game:HttpGet("https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/TAHOMA-8PT-BOLD-WINDOWS-XP.TTF"),
})
Fonts.SmallestPixel = FontsRegister("SmallestPixel", 400, "Normal", {
Id = "smallest_pixel-7.ttf",
Font = game:HttpGet("https://raw.githubusercontent.com/sametexe001/luas/main/smallest_pixel-7.ttf")
})
Fonts.ProggyTiny = FontsRegister("ProggyTiny", 400, "Normal", {
Id = "ProggyTinyyyy.ttf",
Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyTiny.ttf")
})
Fonts.ProggyClean = FontsRegister("ProggyClean", 400, "Normal", {
Id = "ProggyClean.ttf",
Font = game:HttpGet("https://github.com/i77lhm/storage/raw/main/fonts/ProggyClean.ttf"),
})
EspLibrary.ProggyTiny = Font.new(Fonts.ProggyClean, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
EspLibrary.TahomaBold = Font.new(Fonts.XPTahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
EspLibrary.ProggyClean = Font.new(Fonts.ProggyClean, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
EspLibrary.Tahoma = Font.new(Fonts.Tahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
EspLibrary.SmallestPixel = Font.new(Fonts.SmallestPixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
end
EspLibrary.__index = EspLibrary;
function EspLibrary:CreateObjects(Name, Prop)
local New = Instance.new(Name);
for Property, Value in Prop or {} do
New[Property] = Value;
end;
return New;
end
function EspLibrary:CreateThreads(Name, Signal, Callback)
local Connection = Signal:Connect(Callback);
self.Threads[Name] = Connection;
return Connection;
end
EspLibrary.Holder = EspLibrary:CreateObjects("ScreenGui", {
Name = "\n",
Parent = gethui(),
ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
ZIndexBehavior = Enum.ZIndexBehavior.Global,
ResetOnSpawn = false,
DisplayOrder = -1,
IgnoreGuiInset = true,
})
function EspLibrary:InitEsp(Data)
local Objects = Data.Objects
do
Objects["TargetHolder"] = self:CreateObjects("Frame", {
Parent = self.Holder,
Visible = false,
BackgroundTransparency = 1,
Position = Dim2(0, 0, 0, 0),
Size = Dim2(0, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["TopHolder"] = self:CreateObjects("Frame", {
Parent = Objects["TargetHolder"],
AutomaticSize = Enum.AutomaticSize.Y,
Visible = true,
BackgroundTransparency = 1,
AnchorPoint = NewVector2(0, 1),
Position = Dim2(0, -2, 0, -5),
Size = Dim2(1, 4, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["BottomHolder"] = self:CreateObjects("Frame", {
Parent = Objects["TargetHolder"],
AutomaticSize = Enum.AutomaticSize.Y,
Visible = true,
BackgroundTransparency = 1,
Position = Dim2(0, -2, 1, 3),
Size = Dim2(1, 4, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["LeftHolder"] = self:CreateObjects("Frame", {
Parent = Objects["TargetHolder"],
AutomaticSize = Enum.AutomaticSize.X,
Visible = true,
BackgroundTransparency = 1,
AnchorPoint = NewVector2(1, 0),
Position = Dim2(0, -5, 0, -2),
Size = Dim2(0, 0, 1, 4),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["RightHolder"] = self:CreateObjects("Frame", {
Parent = Objects["TargetHolder"],
AutomaticSize = Enum.AutomaticSize.X,
Visible = true,
BackgroundTransparency = 1,
Position = Dim2(1, 5, 0, -2),
Size = Dim2(0, 0, 1, 4),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
end
do
Objects["TopTextHolder"] = self:CreateObjects("Frame", {
Parent = Objects["TopHolder"],
AutomaticSize = Enum.AutomaticSize.Y,
Visible = true,
BackgroundTransparency = 1,
Position = Dim2(0, 0, 0, 0),
Size = Dim2(1, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["BottomTextHolder"] = self:CreateObjects("Frame", {
Parent = Objects["BottomHolder"],
LayoutOrder = 2,
AutomaticSize = Enum.AutomaticSize.Y,
Visible = true,
BackgroundTransparency = 1,
Position = Dim2(0, 0, 0, 0),
Size = Dim2(1, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["LeftTextHolder"] = self:CreateObjects("Frame", {
Parent = Objects["LeftHolder"],
AutomaticSize = Enum.AutomaticSize.XY,
Visible = true,
BackgroundTransparency = 1,
Position = Dim2(0, 0, 0, 0),
Size = Dim2(1, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["RightTextHolder"] = self:CreateObjects("Frame", {
Parent = Objects["RightHolder"],
LayoutOrder = 2,
AutomaticSize = Enum.AutomaticSize.XY,
Visible = true,
BackgroundTransparency = 1,
Position = Dim2(0, 0, 0, 0),
Size = Dim2(0, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
end
do
self:CreateObjects("UIListLayout", {
Parent = Objects["TopTextHolder"],
VerticalAlignment = Enum.VerticalAlignment.Bottom,
HorizontalAlignment = Enum.HorizontalAlignment.Center,
Padding = Dim(0, 1),
SortOrder = Enum.SortOrder.LayoutOrder,
})
self:CreateObjects("UIListLayout", {
Parent = Objects["BottomTextHolder"],
HorizontalAlignment = Enum.HorizontalAlignment.Center,
Padding = Dim(0, -1),
SortOrder = Enum.SortOrder.LayoutOrder,
})
self:CreateObjects("UIListLayout", {
Parent = Objects["LeftTextHolder"],
HorizontalAlignment = Enum.HorizontalAlignment.Right,
Padding = Dim(0, 0),
SortOrder = Enum.SortOrder.LayoutOrder,
})
self:CreateObjects("UIListLayout", {
Parent = Objects["RightTextHolder"],
HorizontalAlignment = Enum.HorizontalAlignment.Left,
Padding = Dim(0, 0),
SortOrder = Enum.SortOrder.LayoutOrder,
})
self:CreateObjects("UIListLayout", {
Parent = Objects["TopHolder"],
VerticalAlignment = Enum.VerticalAlignment.Bottom,
Padding = Dim(0, 1),
SortOrder = Enum.SortOrder.LayoutOrder,
})
self:CreateObjects("UIListLayout", {
Parent = Objects["BottomHolder"],
Padding = Dim(0, 1),
SortOrder = Enum.SortOrder.LayoutOrder,
})
self:CreateObjects("UIListLayout", {
Parent = Objects["LeftHolder"],
FillDirection = Enum.FillDirection.Horizontal,
HorizontalAlignment = Enum.HorizontalAlignment.Left,
Padding = Dim(0, 1),
SortOrder = Enum.SortOrder.LayoutOrder,
})
self:CreateObjects("UIListLayout", {
Parent = Objects["RightHolder"],
FillDirection = Enum.FillDirection.Horizontal,
HorizontalAlignment = Enum.HorizontalAlignment.Left,
Padding = Dim(0, 1),
SortOrder = Enum.SortOrder.LayoutOrder,
})
end
do
self:CreateObjects("UIPadding", {
Parent = Objects["TopTextHolder"],
PaddingBottom = Dim(0, 0),
})
self:CreateObjects("UIPadding", {
Parent = Objects["BottomTextHolder"],
PaddingTop = Dim(0, -1)
})
self:CreateObjects("UIPadding", {
Parent = Objects["LeftTextHolder"],
PaddingTop = Dim(0, -3),
})
self:CreateObjects("UIPadding", {
Parent = Objects["RightTextHolder"],
PaddingTop = Dim(0, -3),
})
self:CreateObjects("UIPadding", {
Parent = Objects["LeftHolder"],
PaddingRight = Dim(0, 1),
})
end
do
Objects["BoxGlow"] = self:CreateObjects("ImageLabel", {
Parent = Objects["TargetHolder"],
Image = "rbxassetid://110204605000367",
ScaleType = Enum.ScaleType.Slice,
SliceCenter = Rect.new(NewVector2(21, 21), NewVector2(79, 79)),
AutomaticSize = Enum.AutomaticSize.XY,
ImageTransparency = 0.65,
ResampleMode = Enum.ResamplerMode.Pixelated,
Visible = true,
BackgroundTransparency = 1,
Position = Dim2(0, -21, 0, -21),
Size = Dim2(0, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["BoxGlowGradient"] = self:CreateObjects("UIGradient", {
Parent = Objects["BoxGlow"],
Rotation = 90,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
}),
Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
})
self:CreateObjects("UIPadding", {
Parent = Objects["BoxGlow"],
PaddingTop = Dim(0, 21),
PaddingBottom = Dim(0, 20),
PaddingLeft = Dim(0, 21),
PaddingRight = Dim(0, 20),
})
Objects["BoxOutlineHolder"] = self:CreateObjects("Frame", {
Parent = Objects["BoxGlow"],
Visible = false,
BackgroundTransparency = 1,
Position = Dim2(0, 0, 0, 0),
Size = Dim2(0, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["BoxOutline"] = self:CreateObjects("UIStroke", {
Parent = Objects["BoxOutlineHolder"],
Thickness = 3,
LineJoinMode = Enum.LineJoinMode.Miter,
})
Objects["BoxOutlineGradient"] = self:CreateObjects("UIGradient", {
Parent = Objects["BoxOutline"],
Rotation = 90,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
}),
Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
})
Objects["BoxInlineHolder"] = self:CreateObjects("Frame", {
Parent = Objects["BoxGlow"],
Visible = false,
BackgroundTransparency = 1,
Position = Dim2(0, -1, 0, -1),
Size = Dim2(0, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["BoxInline"] = self:CreateObjects("UIStroke", {
Parent = Objects["BoxInlineHolder"],
Color = Color3.fromRGB(255, 255, 255),
Thickness = 2,
LineJoinMode = Enum.LineJoinMode.Miter,
})
Objects["BoxInlineGradient"] = self:CreateObjects("UIGradient", {
Parent = Objects["BoxInline"],
Rotation = 90,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 85, 255)),
}),
Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
})
Objects["BoxFill"] = self:CreateObjects("Frame", {
Parent = Objects["BoxGlow"],
Visible = false,
BackgroundTransparency = 0,
Position = Dim2(0, 0, 0, 0),
Size = Dim2(0, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["BoxFillGradient"] = self:CreateObjects("UIGradient", {
Parent = Objects["BoxFill"],
Rotation = 90,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
}),
Transparency = NumSeq({NumKey(0, 1), NumKey(1, 1)}),
})
Objects["CornerHolder"] = self:CreateObjects("Frame", {
Parent = Objects["BoxGlow"],
Visible = false,
BackgroundTransparency = 1,
Position = Dim2(0, -1, 0, -1),
Size = Dim2(0, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
for i = 1, 8 do
Objects["Line_" .. i] = self:CreateObjects("Frame", {
Parent = Objects["CornerHolder"],
Visible = false,
BackgroundTransparency = 0,
Position = Dim2(0, 0, 0, 0),
Size = Dim2(0, 0, 0, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
self:CreateObjects("UIStroke", {
Parent = Objects["Line_" .. i],
Thickness = 1,
LineJoinMode = Enum.LineJoinMode.Miter,
})
end
end
do
Objects["HealthBarHolder"] = self:CreateObjects("Frame", {
Parent = Objects["TargetHolder"],
ZIndex = 5,
Visible = false,
BackgroundTransparency = 1,
Position = Dim2(0, -8, 0, -1),
Size = Dim2(0, 2, 1, 2),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
})
Objects["HealthBarOutline"] = self:CreateObjects("Frame", {
Parent = Objects["HealthBarHolder"],
ZIndex = 5,
Visible = false,
BackgroundTransparency = 0,
Position = Dim2(0, 0, 0, 0),
Size = Dim2(1, 0, 1, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(0, 0, 0),
ClipsDescendants = false,
})
self:CreateObjects("UIStroke", {
Parent = Objects["HealthBarOutline"],
Thickness = 1,
LineJoinMode = Enum.LineJoinMode.Miter,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
Color = Color3.fromRGB(0, 0, 0),
})
Objects["HealthBar"] = self:CreateObjects("Frame", {
Parent = Objects["HealthBarOutline"],
ZIndex = 6,
AnchorPoint = NewVector2(0, 1),
Position = Dim2(0, 0, 1, 0),
Size = Dim2(1, 0, 1, 0),
BorderSizePixel = 0,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
ClipsDescendants = true,
})
Objects["HealthBarGradient"] = self:CreateObjects("UIGradient", {
Parent = Objects["HealthBar"],
Rotation = 90,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Table['Bars']['Health Bar']['Top']),
ColorSequenceKeypoint.new(0.5, Table['Bars']['Health Bar']['Mid']),
ColorSequenceKeypoint.new(1, Table['Bars']['Health Bar']['Bot']),
}),
Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
})
Objects["HealthBarText"] = self:CreateObjects("TextLabel", {
Parent = Objects["HealthBarOutline"],
FontFace = EspLibrary.SmallestPixel,
TextSize = 9,
ZIndex = 10,
TextColor3 = Color3.fromRGB(255, 255, 255),
Text = "",
TextXAlignment = Enum.TextXAlignment.Center,
TextYAlignment = Enum.TextYAlignment.Center,
AnchorPoint = NewVector2(0.5, 0.5),
Position = Dim2(0.5, 0, 1, 0),
BorderSizePixel = 0,
Visible = false,
BackgroundTransparency = 1,
AutomaticSize = Enum.AutomaticSize.XY,
Size = Dim2(0, 0, 0, 0),
})
self:CreateObjects("UIStroke", {
Parent = Objects["HealthBarText"],
Color = Color3.fromRGB(0, 0, 0),
LineJoinMode = Enum.LineJoinMode.Miter,
})
end
do
Objects["TargetName"] = self:CreateObjects("TextLabel", {
Parent = Objects["TopTextHolder"],
FontFace = EspLibrary.TahomaBold,
TextSize = 12,
LayoutOrder = 2,
TextColor3 = Table['Texts']['Name']['Color'],
Text = "",
TextXAlignment = Enum.TextXAlignment.Center,
BorderSizePixel = 0,
Visible = false,
BackgroundTransparency = 1,
ZIndex = 5,
AutomaticSize = Enum.AutomaticSize.XY,
Size = Dim2(0, 0, 0, 0),
})
self:CreateObjects("UIStroke", {
Parent = Objects["TargetName"],
Color = Color3.fromRGB(0, 0, 0),
LineJoinMode = Enum.LineJoinMode.Miter,
})
Objects["Distance"] = self:CreateObjects("TextLabel", {
Parent = Objects["BottomTextHolder"],
FontFace = EspLibrary.SmallestPixel,
TextSize = 9,
LayoutOrder = 2,
TextColor3 = Table['Texts']['Distance']['Color'],
Text = "",
TextXAlignment = Enum.TextXAlignment.Center,
BorderSizePixel = 0,
Visible = false,
BackgroundTransparency = 1,
ZIndex = 5,
AutomaticSize = Enum.AutomaticSize.XY,
Size = Dim2(0, 0, 0, 0),
})
self:CreateObjects("UIStroke", {
Parent = Objects["Distance"],
Color = Color3.fromRGB(0, 0, 0),
LineJoinMode = Enum.LineJoinMode.Miter,
})
Objects["WalkFlag"] = self:CreateObjects("TextLabel", {
Parent = Objects["RightTextHolder"],
FontFace = EspLibrary.SmallestPixel,
TextSize = 9,
LayoutOrder = 1,
TextColor3 = Table['Flags']['Walking']['Color'],
Text = Table['Flags']['Walking']['Text'],
TextXAlignment = Enum.TextXAlignment.Left,
BorderSizePixel = 0,
Visible = false,
BackgroundTransparency = 1,
ZIndex = 5,
AutomaticSize = Enum.AutomaticSize.XY,
Size = Dim2(0, 0, 0, 0),
})
self:CreateObjects("UIStroke", {
Parent = Objects["WalkFlag"],
Color = Color3.fromRGB(0, 0, 0),
LineJoinMode = Enum.LineJoinMode.Miter,
})
Objects["JumpFlag"] = self:CreateObjects("TextLabel", {
Parent = Objects["RightTextHolder"],
FontFace = EspLibrary.SmallestPixel,
TextSize = 9,
LayoutOrder = 2,
TextColor3 = Table['Flags']['Jumping']['Color'],
Text = Table['Flags']['Jumping']['Text'],
TextXAlignment = Enum.TextXAlignment.Left,
BorderSizePixel = 0,
Visible = false,
BackgroundTransparency = 1,
ZIndex = 5,
AutomaticSize = Enum.AutomaticSize.XY,
Size = Dim2(0, 0, 0, 0),
})
self:CreateObjects("UIStroke", {
Parent = Objects["JumpFlag"],
Color = Color3.fromRGB(0, 0, 0),
LineJoinMode = Enum.LineJoinMode.Miter,
})
Objects["SwimmingFlag"] = self:CreateObjects("TextLabel", {
Parent = Objects["RightTextHolder"],
FontFace = EspLibrary.SmallestPixel,
TextSize = 9,
LayoutOrder = 4,
TextColor3 = Table['Flags']['Swimming']['Color'],
Text = Table['Flags']['Swimming']['Text'],
TextXAlignment = Enum.TextXAlignment.Left,
BorderSizePixel = 0,
Visible = false,
BackgroundTransparency = 1,
ZIndex = 5,
AutomaticSize = Enum.AutomaticSize.XY,
Size = Dim2(0, 0, 0, 0),
})
self:CreateObjects("UIStroke", {
Parent = Objects["SwimmingFlag"],
Color = Color3.fromRGB(0, 0, 0),
LineJoinMode = Enum.LineJoinMode.Miter,
})
Objects["Weapon"] = self:CreateObjects("TextLabel", {
Parent = Objects["BottomTextHolder"],
FontFace = EspLibrary.SmallestPixel,
TextSize = 9,
LayoutOrder = 3,
TextColor3 = Table['Texts']['Weapon']['Color'],
Text = "none",
TextXAlignment = Enum.TextXAlignment.Center,
BorderSizePixel = 0,
Visible = false,
BackgroundTransparency = 1,
ZIndex = 5,
AutomaticSize = Enum.AutomaticSize.XY,
Size = Dim2(0, 0, 0, 0),
})
self:CreateObjects("UIStroke", {
Parent = Objects["Weapon"],
Color = Color3.fromRGB(0, 0, 0),
LineJoinMode = Enum.LineJoinMode.Miter,
})
end
end
local CornerLayout = {
{Dim2(0, -1, 0, -1), Dim2(0.3, 0, 0, 1), NewVector2(0, 0), 0},
{Dim2(0, -1, 0, -1), Dim2(0, 1, 0.3, 0), NewVector2(0, 0), 180},
{Dim2(1, 1, 0, -1), Dim2(0.3, 0, 0, 1), NewVector2(1, 0), 0},
{Dim2(1, 1, 0, -1), Dim2(0, 1, 0.3, 0), NewVector2(1, 0), 180},
{Dim2(0, -1, 1, 1), Dim2(0.3, 0, 0, 1), NewVector2(0, 1), 0},
{Dim2(0, -1, 1, 1), Dim2(0, 1, 0.3, 0), NewVector2(0, 1), -180},
{Dim2(1, 1, 1, 1), Dim2(0.3, 0, 0, 1), NewVector2(1, 1), 0},
{Dim2(1, 1, 1, 1), Dim2(0, 1, 0.3, 0), NewVector2(1, 1), -180},
}
function EspLibrary:CalculateBox(Data)
local RootPart = Data['RootPart']
if not RootPart then
return nil, nil, nil, nil, false;
end;
local RootScreen, OnScreen = WorldToViewportPoint(Camera, RootPart.Position)
if not OnScreen then
return nil, nil, nil, nil, false;
end;
local BoundingBox = Table['Boxes']['Bounding Box'];
if Table['Boxes']['DynamicBoxes'] then
local Children = Data['Children'];
if not Children then
return nil, nil, nil, nil, false;
end;
local IncludeAccessories = Data['IncludeAccessories'];
local ScrMinX, ScrMinY = Huge, Huge;
local ScrMaxX, ScrMaxY = -Huge, -Huge;
local HasValidParts = false;
for _, Part in Children do
if Part:IsA('BasePart') and Part.Transparency ~= 1 and Part ~= RootPart then
local Parent = Part.Parent
if Parent == nil then
continue
end
if not IncludeAccessories and Parent:IsA('Accessory') then
continue;
end;
local PartScreen, PartOnScreen = WorldToViewportPoint(Camera, Part.Position);
if not PartOnScreen or PartScreen.Z <= 0 then
continue;
end;
HasValidParts = true;
local Cf = Part.CFrame;
local Sz = Part.Size;
local HX, HY, HZ = Sz.X * 0.5, Sz.Y * 0.5, Sz.Z * 0.5;
local RX, UY, LZ = Cf.RightVector, Cf.UpVector, Cf.LookVector;
local DepthScale = CachedFocalLength / PartScreen.Z;
local Ex = (Abs(RX.X * HX) + Abs(UY.X * HY) + Abs(LZ.X * HZ)) * DepthScale;
local Ey = (Abs(RX.Y * HX) + Abs(UY.Y * HY) + Abs(LZ.Y * HZ)) * DepthScale;
local PMinX, PMaxX = PartScreen.X - Ex, PartScreen.X + Ex;
local PMinY, PMaxY = PartScreen.Y - Ey, PartScreen.Y + Ey;
if PMinX < ScrMinX then ScrMinX = PMinX; end
if PMaxX > ScrMaxX then ScrMaxX = PMaxX; end
if PMinY < ScrMinY then ScrMinY = PMinY; end
if PMaxY > ScrMaxY then ScrMaxY = PMaxY; end
end;
end;
if not HasValidParts then
return nil, nil, nil, nil, false;
end;
local PadX = BoundingBox['BoxX'];
local PadY = BoundingBox['BoxY'];
local W = (ScrMaxX - ScrMinX) + PadX;
local H = (ScrMaxY - ScrMinY) + PadY;
return W, H, ScrMinX - (PadX * 0.5), ScrMinY - (PadY * 0.5), true;
else
local Scale = (RootPart.Size.Y * ViewPortY) / (RootScreen.Z * 2);
local W, H = 3 * Scale, 4.5 * Scale;
return W, H, RootScreen.X - (W * 0.5), RootScreen.Y - (H * 0.5), OnScreen;
end
end
function EspLibrary:AddTarget(Player)
if Player == LocalPlayer and not Table['ShowLocalPlayer'] then
return
end;
if self.Cache[Player] then
return
end;
local Data = {
['Player'] = Player,
['Objects'] = {},
['Conns'] = {},
['Character'] = nil,
['RootPart'] = nil,
['Humanoid'] = nil,
['Children'] = nil,
['Health'] = 0,
['MaxHealth'] = 100,
['CurrentTool'] = nil,
['Alive'] = false,
['LastW'] = nil,
['LastH'] = nil,
['LastX'] = nil,
['LastY'] = nil,
['WalkActive'] = false,
['JumpActive'] = false,
['FallingActive'] = false,
['SwimmingActive'] = false,
['IncludeAccessories'] = Table['Boxes']['Bounding Box']['IncludeAcsessories'],
['LastGlowTop'] = nil,
['LastGlowBot'] = nil,
['LastGlowT1'] = nil,
['LastGlowT2'] = nil,
['LastGradTop'] = nil,
['LastGradBot'] = nil,
['LastFillTop'] = nil,
['LastFillBot'] = nil,
['LastFillT1'] = nil,
['LastFillT2'] = nil,
['LastOutlineColor'] = nil,
['LastDist'] = nil,
['LastDistColor'] = nil,
['LastDisplayName'] = nil,
['LastNameColor'] = nil,
['LastHealthTop'] = nil,
['LastHealthMid'] = nil,
['LastHealthBot'] = nil,
['LastHealthFloor'] = nil,
['LastHealthPosition'] = nil,
['LastHealthTextColor'] = nil,
['LastRatio'] = nil,
['LastWeapon'] = nil,
['LastWeaponColor'] = nil,
}
self:InitEsp(Data);
self['Cache'][Player] = Data;
local HealthHandler = {}; do
function HealthHandler.BindHealth(Humanoid)
if Data['Conns']['Health'] then
Data['Conns']['Health']:Disconnect()
end
if Data['Conns']['Died'] then
Data['Conns']['Died']:Disconnect()
end
Data['Humanoid'] = Humanoid
Data['Health'] = Humanoid.Health
Data['MaxHealth'] = Humanoid.MaxHealth
Data['Alive'] = Humanoid.Health > 0
Data['Conns']['Health'] = Humanoid.HealthChanged:Connect(function(NewHealth)
Data['Alive'] = NewHealth > 0
Data['Health'] = NewHealth
end)
Data['Conns']['Died'] = Humanoid.Died:Connect(function()
Data['Alive'] = false
end)
end
Data['BindHealth'] = HealthHandler.BindHealth;
end
local ToolHandler = {}; do
function ToolHandler.BindTool(Character)
if Data['Conns']['ToolAdded'] then
Data['Conns']['ToolAdded']:Disconnect()
end
if Data['Conns']['ToolRemoved'] then
Data['Conns']['ToolRemoved']:Disconnect()
end
if Data['Children'] then
for _, Child in Data['Children'] do
if Child:IsA('Tool') then
Data['CurrentTool'] = Child.Name
break
end
end
end
Data['Conns']['ToolAdded'] = Character.ChildAdded:Connect(function(Child)
if Child:IsA('Tool') then
Data['CurrentTool'] = Child.Name
end
end)
Data['Conns']['ToolRemoved'] = Character.ChildRemoved:Connect(function(Child)
if Child:IsA('Tool') then
Data['CurrentTool'] = nil
end
end)
end
Data['BindTool'] = ToolHandler.BindTool
end
local ChildHandler = {}; do
function ChildHandler.BindChildren(Character)
if Data['Conns']['ChildAdded'] then
Data['Conns']['ChildAdded']:Disconnect();
end;
if Data['Conns']['ChildRemoved'] then
Data['Conns']['ChildRemoved']:Disconnect();
end;
local Children = Character:GetChildren();
Data['Children'] = Children;
Data['Conns']['ChildAdded'] = Character.ChildAdded:Connect(function(Child)
Children[#Children + 1] = Child;
end)
Data['Conns']['ChildRemoved'] = Character.ChildRemoved:Connect(function(Child)
for I = #Children, 1, -1 do
if Children[I] == Child then
Remove(Children, I);
break;
end;
end
end)
Data['BindTool'](Character);
end
Data['BindChildren'] = ChildHandler.BindChildren;
end
local FlagsHandler = {}; do
function FlagsHandler.BindFlags(Humanoid)
if Data['Conns']['MoveDir'] then
Data['Conns']['MoveDir']:Disconnect();
end;
if Data['Conns']['StateChange'] then
Data['Conns']['StateChange']:Disconnect();
end;
local Objects = Data['Objects']
Data['JumpActive'] = false;
Data['WalkActive'] = false;
Data['FallingActive'] = false;
Data['SwimmingActive'] = false;
Objects['WalkFlag'].Visible = false;
Objects['JumpFlag'].Visible = false;
Objects['SwimmingFlag'].Visible = false;
Data['Conns']['MoveDir'] = Humanoid:GetPropertyChangedSignal('MoveDirection'):Connect(function()
local Walking = Humanoid.MoveDirection ~= ZeroVector3;
if Walking and not Data['WalkActive'] then
Data['WalkActive'] = true;
if Data['JumpActive'] then
Objects['WalkFlag'].LayoutOrder = 2;
else
Objects['WalkFlag'].LayoutOrder = 1;
Objects['JumpFlag'].LayoutOrder = 2;
end
Objects['WalkFlag'].Visible = Table['Flags']['Walking']['Enabled']
elseif not Walking and Data['WalkActive'] then
Data['WalkActive'] = false;
Objects['WalkFlag'].Visible = false;
if Data['JumpActive'] then
Objects['JumpFlag'].LayoutOrder = 1;
end
end
end)
Data['Conns']['StateChange'] = Humanoid.StateChanged:Connect(function(_, NewState)
if NewState == Enum.HumanoidStateType.Freefall and not Data['JumpActive'] then
Data['JumpActive'] = true;
if Data['WalkActive'] then
Objects['JumpFlag'].LayoutOrder = 2;
else
Objects['JumpFlag'].LayoutOrder = 1;
Objects['WalkFlag'].LayoutOrder = 2;
end
Objects['JumpFlag'].Visible = Table['Flags']['Jumping']['Enabled']
elseif NewState ~= Enum.HumanoidStateType.Jumping and Data['JumpActive'] then
Data['JumpActive'] = false;
Objects['JumpFlag'].Visible = false;
if Data['WalkActive'] then
Objects['WalkFlag'].LayoutOrder = 1;
end
end
if NewState == Enum.HumanoidStateType.Swimming and not Data['SwimmingActive'] then
Data['SwimmingActive'] = true;
Objects['SwimmingFlag'].Visible = Table['Flags']['Swimming']['Enabled']
elseif NewState ~= Enum.HumanoidStateType.Swimming and Data['SwimmingActive'] then
Data['SwimmingActive'] = false;
Objects['SwimmingFlag'].Visible = false;
end
end)
end
Data['BindFlags'] = FlagsHandler.BindFlags;
end
local CharacterHandler = {}; do
function CharacterHandler.OnCharacter(Character)
Data['Character'] = Character;
Data['RootPart'] = nil;
Data['Humanoid'] = nil;
Data['Children'] = nil;
Data['Alive'] = false;
Data['WalkActive'] = false;
Data['JumpActive'] = false;
Data['FallingActive'] = false;
Data['SwimmingActive'] = false;
if not Character or not Character.Parent then
return;
end;
local RootPart = FindFirstChild(Character, "HumanoidRootPart");
if not RootPart then
RootPart = Character:WaitForChild('HumanoidRootPart', 10);
end
local Humanoid = FindFirstChildOfClass(Character, 'Humanoid');
if not Humanoid then
Humanoid = Character:WaitForChild('Humanoid', 10);
end;
if not RootPart or not Humanoid then
return;
end;
if not Character.Parent then
return;
end;
Data['RootPart'] = RootPart;
Data['Humanoid'] = Humanoid;
Data['BindChildren'](Character);
Data['BindHealth'](Humanoid);
Data['BindFlags'](Humanoid);
end
Data['Conns']['CharAdded'] = Player.CharacterAdded:Connect(function(Character)
task.defer(CharacterHandler.OnCharacter, Character)
end)
if Player.Character and Player.Character.Parent then
task.defer(CharacterHandler.OnCharacter, Player.Character)
end
end
end
function EspLibrary:RemoveTarget(Player)
local Data = self['Cache'][Player];
if not Data then
return;
end;
for _, Connections in Data['Conns'] do
Connections:Disconnect()
end;
Clear(Data['Conns']);
if Data['Objects']['TargetHolder'] then
Data['Objects']['TargetHolder']:Destroy();
end;
Clear(Data['Objects']);
self['Cache'][Player] = nil;
end
function EspLibrary:Update(Player, Data)
local Objects = Data['Objects']
if not Data['RootPart'] then
if Objects['TargetHolder'].Visible then
Objects['TargetHolder'].Visible = false
end
return
end
if not Data['Alive'] then
if Objects['TargetHolder'].Visible then
Objects['TargetHolder'].Visible = false
end
return
end
local RootPos = Data['RootPart'].Position
local Distance = Floor((CameraPosition - RootPos).Magnitude)
if Distance > Table['Distance'] then
if Objects['TargetHolder'].Visible then
Objects['TargetHolder'].Visible = false
end
return
end
local W, H, X, Y, OnScreen = self:CalculateBox(Data)
if not OnScreen or not W then
if Objects['TargetHolder'].Visible then
Objects['TargetHolder'].Visible = false
end
return
end
W = Floor(W)
H = Floor(H)
X = Floor(X)
Y = Floor(Y)
if not Objects['TargetHolder'].Visible then
Objects['TargetHolder'].Visible = true
end
local DirtySizes = Data['LastW'] ~= W or Data['LastH'] ~= H
local DirtyPosition = Data['LastX'] ~= X or Data['LastY'] ~= Y
if DirtyPosition then
Objects['TargetHolder'].Position = DimOffset(X, Y)
Data['LastX'] = X
Data['LastY'] = Y
end
if DirtySizes then
Objects['TargetHolder'].Size = DimOffset(W, H)
Objects['BoxGlow'].Size = DimOffset(W, H)
Objects['BoxOutlineHolder'].Size = DimOffset(W, H)
Objects['BoxInlineHolder'].Size = DimOffset(W + 2, H + 2)
Objects['BoxFill'].Size = DimOffset(W, H)
Objects['CornerHolder'].Size = DimOffset(W + 2, H + 2)
Data['LastW'] = W
Data['LastH'] = H
-- Scale stroke thickness with box size so far-away boxes don't look overly thick.
local minDim = math.min(W, H)
Objects['BoxOutline'].Thickness = math.clamp(math.floor(minDim * 0.08 + 0.5), 1, 3)
Objects['BoxInline'].Thickness = math.clamp(math.floor(minDim * 0.05 + 0.5), 1, 2)
end
local BoxesCfg = Table['Boxes']
local TextsCfg = Table['Texts']
if BoxesCfg['Enabled'] then
if BoxesCfg['Box Glow']['Enabled'] then
if Objects['BoxGlow'].ImageTransparency ~= 0 then
Objects['BoxGlow'].ImageTransparency = 0
end
local GlowTop = BoxesCfg['Box Glow']['Top']
local GlowBot = BoxesCfg['Box Glow']['Bot']
if Data['LastGlowTop'] ~= GlowTop or Data['LastGlowBot'] ~= GlowBot then
Objects['BoxGlowGradient'].Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, GlowTop),
ColorSequenceKeypoint.new(1, GlowBot),
})
Data['LastGlowTop'] = GlowTop
Data['LastGlowBot'] = GlowBot
end
local T1 = BoxesCfg['Box Glow']['Transparency'][1]
local T2 = BoxesCfg['Box Glow']['Transparency'][2]
if Data['LastGlowT1'] ~= T1 or Data['LastGlowT2'] ~= T2 then
Objects['BoxGlowGradient'].Transparency = NumSeq({NumKey(0, T1), NumKey(1, T2)})
Data['LastGlowT1'] = T1
Data['LastGlowT2'] = T2
end
else
if Objects['BoxGlow'].ImageTransparency ~= 1 then
Objects['BoxGlow'].ImageTransparency = 1
end
end
local BoxType = BoxesCfg['Type']
if BoxType == "Corner" then
if Objects['BoxOutlineHolder'].Visible then
Objects['BoxOutlineHolder'].Visible = false
end
if Objects['BoxInlineHolder'].Visible then
Objects['BoxInlineHolder'].Visible = false
end
if Objects['BoxFill'].Visible then
Objects['BoxFill'].Visible = false
end
if not Objects['CornerHolder'].Visible then
Objects['CornerHolder'].Visible = true
end
local GradTop = BoxesCfg['Gradients']['Top']
local GradBot = BoxesCfg['Gradients']['Bot']
for i = 1, 8 do
local Line = Objects['Line_' .. i]
local Stroke = Line:FindFirstChildOfClass('UIStroke')
local LayoutEntry = CornerLayout[i]
local LPos, LSize, LAnchor, LRot = LayoutEntry[1], LayoutEntry[2], LayoutEntry[3], LayoutEntry[4]
Line.Position = LPos
Line.Size = LSize
Line.AnchorPoint = LAnchor
Line.Rotation = LRot
Line.BackgroundColor3 = GradTop
Line.BackgroundTransparency = 0
if Stroke then
Stroke.Color = GradTop
end
Line.Visible = true
end
else
if Objects['CornerHolder'].Visible then
Objects['CornerHolder'].Visible = false
end
for i = 1, 8 do
if Objects['Line_' .. i].Visible then
Objects['Line_' .. i].Visible = false
end
end
if BoxesCfg['Outline']['Enabled'] then
if not Objects['BoxOutlineHolder'].Visible then
Objects['BoxOutlineHolder'].Visible = true
end
local OutlineColor = BoxesCfg['Outline']['Color']
if Data['LastOutlineColor'] ~= OutlineColor then
Objects['BoxOutlineGradient'].Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, OutlineColor),
ColorSequenceKeypoint.new(1, OutlineColor),
})
Data['LastOutlineColor'] = OutlineColor
end
else
if Objects['BoxOutlineHolder'].Visible then
Objects['BoxOutlineHolder'].Visible = false
end
end
if not Objects['BoxInlineHolder'].Visible then
Objects['BoxInlineHolder'].Visible = true
end
local GradTop = BoxesCfg['Gradients']['Top']
local GradBot = BoxesCfg['Gradients']['Bot']
if Data['LastGradTop'] ~= GradTop or Data['LastGradBot'] ~= GradBot then
Objects['BoxInlineGradient'].Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, GradTop),
ColorSequenceKeypoint.new(1, GradBot),
})
Data['LastGradTop'] = GradTop
Data['LastGradBot'] = GradBot
end
if BoxesCfg['Filled']['Enabled'] then
if not Objects['BoxFill'].Visible then
Objects['BoxFill'].Visible = true
end
local FillTop = BoxesCfg['Filled']['Top']
local FillBot = BoxesCfg['Filled']['Bot']
local FillT1 = BoxesCfg['Filled']['Transparency'][1]
local FillT2 = BoxesCfg['Filled']['Transparency'][2]
if Data['LastFillTop'] ~= FillTop or Data['LastFillBot'] ~= FillBot then
Objects['BoxFillGradient'].Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, FillTop),
ColorSequenceKeypoint.new(1, FillBot),
})
Data['LastFillTop'] = FillTop
Data['LastFillBot'] = FillBot
end
if Data['LastFillT1'] ~= FillT1 or Data['LastFillT2'] ~= FillT2 then
Objects['BoxFillGradient'].Transparency = NumSeq({NumKey(0, FillT1), NumKey(1, FillT2)})
Data['LastFillT1'] = FillT1
Data['LastFillT2'] = FillT2
end
else
if Objects['BoxFill'].Visible then
Objects['BoxFill'].Visible = false
end
end
end
else
if Objects['BoxGlow'].ImageTransparency ~= 1 then
Objects['BoxGlow'].ImageTransparency = 1
end
if Objects['BoxOutlineHolder'].Visible then
Objects['BoxOutlineHolder'].Visible = false
end
if Objects['BoxInlineHolder'].Visible then
Objects['BoxInlineHolder'].Visible = false
end
if Objects['BoxFill'].Visible then
Objects['BoxFill'].Visible = false
end
if Objects['CornerHolder'].Visible then
Objects['CornerHolder'].Visible = false
end
for i = 1, 8 do
if Objects['Line_' .. i].Visible then
Objects['Line_' .. i].Visible = false
end
end
end
if TextsCfg['Name']['Enabled'] then
if not Objects['TargetName'].Visible then
Objects['TargetName'].Visible = true
end
local DisplayName = Player.DisplayName
if Data['LastDisplayName'] ~= DisplayName then
Objects['TargetName'].Text = DisplayName
Data['LastDisplayName'] = DisplayName
end
local NameColor = TextsCfg['Name']['Color']
if Data['LastNameColor'] ~= NameColor then
Objects['TargetName'].TextColor3 = NameColor
Data['LastNameColor'] = NameColor
end
else
if Objects['TargetName'].Visible then
Objects['TargetName'].Visible = false
end
end
if TextsCfg['Distance']['Enabled'] then
if not Objects['Distance'].Visible then
Objects['Distance'].Visible = true
end
if Data['LastDist'] ~= Distance then
Objects['Distance'].Text = Format('%dst', Distance)
Data['LastDist'] = Distance
end
local DistColor = TextsCfg['Distance']['Color']
if Data['LastDistColor'] ~= DistColor then
Objects['Distance'].TextColor3 = DistColor
Data['LastDistColor'] = DistColor
end
else
if Objects['Distance'].Visible then
Objects['Distance'].Visible = false
end
end
local HealthCfg = Table['Bars']['Health Bar']
if HealthCfg['Enabled'] then
local Health = Data['Health'] or 0
local MaxHealth = Data['MaxHealth'] or 100
local Ratio = Clamp(Health / MaxHealth, 0, 1)
local Position = HealthCfg['Position'] or 'Left'
if not Objects['HealthBarHolder'].Visible then
Objects['HealthBarHolder'].Visible = true
end
if not Objects['HealthBarOutline'].Visible then
Objects['HealthBarOutline'].Visible = true
end
if Data['LastHealthPosition'] ~= Position then
local Layouts = {
Left = {HolderPos = Dim2(0, -8, 0, -1), HolderSize = Dim2(0, 2, 1, 2), BarAnchor = NewVector2(0, 1), BarPos = Dim2(0, 0, 1, 0), Rotation = 90},
Right = {HolderPos = Dim2(1, 6, 0, -1), HolderSize = Dim2(0, 2, 1, 2), BarAnchor = NewVector2(0, 1), BarPos = Dim2(0, 0, 1, 0), Rotation = 90},
Bottom = {HolderPos = Dim2(0, -1, 1, 6), HolderSize = Dim2(1, 2, 0, 2), BarAnchor = NewVector2(0, 0), BarPos = Dim2(0, 0, 0, 0), Rotation = 0},
}
local L = Layouts[Position] or Layouts.Left
Objects['HealthBarHolder'].Position = L.HolderPos
Objects['HealthBarHolder'].Size = L.HolderSize
Objects['HealthBar'].AnchorPoint = L.BarAnchor
Objects['HealthBar'].Position = L.BarPos
Objects['HealthBarGradient'].Rotation = L.Rotation
if Position == 'Bottom' then
Objects['HealthBarText'].Position = Dim2(Ratio, 0, 1, 4)
elseif Position == 'Right' then
Objects['HealthBarText'].Position = Dim2(1, 4, 1 - Ratio, 0)
else
Objects['HealthBarText'].Position = Dim2(0, -4, 1 - Ratio, 0)
end
Data['LastHealthPosition'] = Position
end
if Data['LastRatio'] ~= Ratio then
local FillSize = Position == 'Bottom'
and Dim2(Ratio, 0, 1, 0)
or Dim2(1, 0, Ratio, 0)
Objects['HealthBar'].Size = FillSize
Data['LastRatio'] = Ratio
end
local GradTop = HealthCfg['Top']
local GradMid = HealthCfg['Mid']
local GradBot = HealthCfg['Bot']
if Data['LastHealthTop'] ~= GradTop or Data['LastHealthMid'] ~= GradMid or Data['LastHealthBot'] ~= GradBot then
Objects['HealthBarGradient'].Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, GradTop),
ColorSequenceKeypoint.new(0.5, GradMid),
ColorSequenceKeypoint.new(1, GradBot),
})
Data['LastHealthTop'] = GradTop
Data['LastHealthMid'] = GradMid
Data['LastHealthBot'] = GradBot
end
local TextCfg = HealthCfg['Text']
if TextCfg['Enabled'] then
if not Objects['HealthBarText'].Visible then
Objects['HealthBarText'].Visible = true
end
local TextColor = TextCfg['Color']
if Data['LastHealthTextColor'] ~= TextColor then
Objects['HealthBarText'].TextColor3 = TextColor
Data['LastHealthTextColor'] = TextColor
end
local FlooredHealth = Floor(Health)
if Data['LastHealthFloor'] ~= FlooredHealth then
Objects['HealthBarText'].Text = Format('%d', FlooredHealth)
if Position == 'Bottom' then
Objects['HealthBarText'].Position = Dim2(Ratio, 0, 1, 4)
elseif Position == 'Right' then
Objects['HealthBarText'].Position = Dim2(1, 4, 1 - Ratio, 0)
else
Objects['HealthBarText'].Position = Dim2(0, -4, 1 - Ratio, 0)
end
Data['LastHealthFloor'] = FlooredHealth
end
else
if Objects['HealthBarText'].Visible then
Objects['HealthBarText'].Visible = false
end
end
else
if Objects['HealthBarHolder'].Visible then
Objects['HealthBarHolder'].Visible = false
end
if Objects['HealthBarOutline'].Visible then
Objects['HealthBarOutline'].Visible = false
end
if Objects['HealthBarText'].Visible then
Objects['HealthBarText'].Visible = false
end
end
local WeaponCfg = TextsCfg['Weapon']
if WeaponCfg['Enabled'] then
if not Objects['Weapon'].Visible then
Objects['Weapon'].Visible = true
end
local CurrentTool = Data['CurrentTool'] or 'none'
if Data['LastWeapon'] ~= CurrentTool then
Objects['Weapon'].Text = CurrentTool
Data['LastWeapon'] = CurrentTool
end
local WeaponColor = WeaponCfg['Color']
if Data['LastWeaponColor'] ~= WeaponColor then
Objects['Weapon'].TextColor3 = WeaponColor
Data['LastWeaponColor'] = WeaponColor
end
else
if Objects['Weapon'].Visible then
Objects['Weapon'].Visible = false
end
end
end
do
EspLibrary:CreateThreads('Renderer', RunService.RenderStepped, function()
if not Table['Enabled'] then
for _, Data in EspLibrary['Cache'] do
if Data['Objects']['TargetHolder'].Visible then
Data['Objects']['TargetHolder'].Visible = false
end;
end;
return
end;
local Now = os.clock();
if Now - Updates < Frame then
return;
end;
Updates = Now;
CameraPosition = Camera.CFrame.Position;
for Player, Data in EspLibrary['Cache'] do
EspLibrary:Update(Player, Data)
end
end)
end
do
for _, Player in Players:GetPlayers() do
EspLibrary:AddTarget(Player)
end
EspLibrary:CreateThreads('PlayerAdded', Players.PlayerAdded, function(Player)
EspLibrary:AddTarget(Player)
end)
EspLibrary:CreateThreads('PlayerRemoving', Players.PlayerRemoving, function(Player)
EspLibrary:RemoveTarget(Player)
end)
end
do
function EspLibrary:Unload()
for Player in self['Cache'] do
self:RemoveTarget(Player);
end;
for _, Conn in self['Connections'] do
Conn:Disconnect();
end;
Clear(self['Connections']);
for _, Conn in self['Threads'] do
Conn:Disconnect();
end;
Clear(self['Threads']);
if self['Holder'] then
self['Holder']:Destroy();
self['Holder'] = nil;
end;
Clear(self['Cache']);
end
end
end
InitializeESP()
SaveManager:LoadAutoloadConfig()
-- Force the knife hitbox expander on by default so aura modes don't whiff.
if Toggles.KnifeHitboxToggle and not Toggles.KnifeHitboxToggle.Value then
Toggles.KnifeHitboxToggle:SetValue(true)
end
