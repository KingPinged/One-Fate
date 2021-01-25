local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")

local rs = game:GetService("ReplicatedStorage")
local rf = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- create a screenGui
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Size = UDim2.new(1,0,1,0)
frame.Parent = screenGui

rf:RemoveDefaultLoadingScreen()

local TextLabel = Instance.new("TextLabel")
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(0.4, 0, 0.15, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
--TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--TextLabel.FontSize = Enum.FontSize.Size14
--TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.fromRGB(234, 234, 234)
--TextLabel.TextWrap = true
--TextLabel.Font = Enum.Font.SourceSans
--TextLabel.TextWrapped = true
TextLabel.TextScaled = true
TextLabel.Parent = screenGui
TextLabel.Text = "Now loading"
TextLabel.Name = "TextInfo"


local time = os.time()

-- create a table of assets to be loaded
local assets = {
	objects = workspace:GetDescendants(),
	builds = rs:WaitForChild("Storage"):WaitForChild("Builds"):GetDescendants(),
	models = rs:WaitForChild("Storage"):WaitForChild("Models"):GetDescendants(),
	scripts = rs:WaitForChild("Storage"):WaitForChild("Scripts"):GetDescendants(),
	guis =  rs:WaitForChild("Storage"):WaitForChild("Guis"):GetDescendants()
}

wait(3)

for i, v in pairs(assets) do
	for a = 1, #v do
	local asset = v[a]
	ContentProvider:PreloadAsync({asset}) -- 1 at a time, yields
	TextLabel.Text = "Now loading "..i.." ("..a.."/"..(#v)..")"
	end
end


while ContentProvider.RequestQueueSize > 0 and localPlayer.Character and  localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character:FindFirstChild("Humanoid") do
	TextLabel.Text="Loading remaining assets"
	wait(.5)
end


if not game:IsLoaded() then
	TextLabel.Text = "It seems things are taking a little longer than usual. Please hang tight."
	game.Loaded:Wait()
end


TextLabel.Text  = ("loading done! Took "..(os.time()-time).." seconds")
wait(3)


--Startup module

require(StarterPlayer.StarterPlayerScripts.knitStartUp)

screenGui:ClearAllChildren()

--script:Destroy()