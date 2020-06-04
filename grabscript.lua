--Written By Hexa

--Rewritten because the old script i made in like 2018 was bad lol

--Config
local ZoomStudsPerSecond = 30 --Controls the speed that the distance changes when pressing + or - when dragging a physics object
local IgnoreCharacter = false
local MaxParts = 20
local Disable_Collision = true
local Range = 4
--Script
local TargetBricks = {}
local TargetPos
local Distance = 0
local Transparencys = {}
local CanCollides = {}
local CurZoom = 0

local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")

function Lerp(PointA,PointB,Alpha)
	return PointA * (1-Alpha) + PointB * Alpha
end

function UpdateVelocity(FrameTime)
	for i,TargetBrick in pairs(TargetBricks) do
		if (not TargetBrick) or (TargetBrick and not TargetPos) then
			return
		end
		TargetBrick.Velocity = (TargetPos - TargetBrick.CFrame.Position)*workspace:GetRealPhysicsFPS()
	end
end

function UpdateTargetPos(FrameTime)
	CurZoom = math.clamp(CurZoom,-1,1)
	Distance = Distance + ((CurZoom*FrameTime)*ZoomStudsPerSecond)
	TargetPos = ((Mouse.Hit.Position - workspace.CurrentCamera.CFrame.Position).Unit*Distance) + workspace.CurrentCamera.CFrame.Position
end

function TakeNetworkOwnership(FrameTime)
	if (game:GetService("RunService"):IsStudio()) or (#TargetBricks==0) then
		return
	end
	game:GetService("Players").LocalPlayer.MaximumSimulationRadius=100000
	game:GetService("Players").LocalPlayer.SimulationRadius=100000
end

function UpdateVisual(FrameTime)
	for i,TargetBrick in pairs(TargetBricks) do
		if (not TargetBrick) or (TargetBrick and not TargetPos) then
			return
		end
		TargetBrick.Transparency = Lerp(Transparencys[TargetBrick],1,.5)
		if Disable_Collision then
			TargetBrick.CanCollide = false
		end
	end
end

function HandleBrick(TargetBrick)
	local roblox_is_fucking_retarded = false
	if TargetBrick == nil then
		roblox_is_fucking_retarded = true
	else
		if not TargetBrick:IsA("BasePart") then
			roblox_is_fucking_retarded = true
		end
		if roblox_is_fucking_retarded or TargetBrick:IsA("Terrain") then
			roblox_is_fucking_retarded = true
		end
		if roblox_is_fucking_retarded or TargetBrick.Anchored then
			roblox_is_fucking_retarded = true
		end
	end
	if not roblox_is_fucking_retarded then
		Transparencys[TargetBrick] = TargetBrick.Transparency
		CanCollides[TargetBrick] = TargetBrick.CanCollide
		Distance = (workspace.CurrentCamera.CFrame.Position-TargetBrick.Position).Magnitude
	else
		TargetBrick = nil
	end
	return TargetBrick
end

Mouse.Button1Down:Connect(function()
	if Mouse.Hit then
		local Region = Region3.new(
			Vector3.new(-Range,-Range,-Range)+Mouse.Hit.Position,
			Vector3.new(Range,Range,Range)+Mouse.Hit.Position
		)
		local Parts
		if IgnoreCharacter then
			Parts = workspace:FindPartsInRegion3WithIgnoreList(Region,{game:GetService("Players").LocalPlayer.Character},MaxParts)
		else
			Parts = workspace:FindPartsInRegion3(Region,nil,MaxParts)
		end
		for i,Part in pairs(Parts) do
			local Result = HandleBrick(Part)
			if Result then
				table.insert(TargetBricks,#TargetBricks+1,Result)
			end
		end
	end
end)

Mouse.Button1Up:Connect(function()
	for i,brick in pairs(TargetBricks) do
		if brick then
			brick.Transparency = Transparencys[brick]
			brick.CanCollide = CanCollides[brick]
		end
	end
	TargetBricks = {}
	Transparencys = {}
	Distance = 0
end)

UIS.InputBegan:Connect(function(InputObject)
	if InputObject.KeyCode == Enum.KeyCode.Equals then
		CurZoom = CurZoom + 1
	end
		if InputObject.KeyCode == Enum.KeyCode.Minus then
		CurZoom = CurZoom - 1
	end
end)

UIS.InputEnded:Connect(function(InputObject)
	if InputObject.KeyCode == Enum.KeyCode.Equals then
		CurZoom = CurZoom - 1
	end
		if InputObject.KeyCode == Enum.KeyCode.Minus then
		CurZoom = CurZoom + 1
	end
end)

function InitStep(FrameTime)
	UpdateTargetPos(FrameTime)
	TakeNetworkOwnership(FrameTime)
	UpdateVelocity(FrameTime)
end

function Step2(FrameTime)
	UpdateVisual(FrameTime)
end

game:GetService("RunService").RenderStepped:Connect(InitStep)
game:GetService("RunService").RenderStepped:Connect(Step2)
game:GetService("RunService").Heartbeat:Connect(Step2)
game:GetService("RunService").Stepped:Connect(Step2)
