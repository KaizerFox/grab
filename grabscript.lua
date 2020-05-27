game:GetService("Players").LocalPlayer.MaximumSimulationRadius=100000
game:GetService("Players").LocalPlayer.SimulationRadius=100000
local held = false
local m = game:GetService("Players").LocalPlayer:GetMouse()
local d=0
local part
local p = Instance.new("Part")
p.Parent = game
local a = Instance.new("Attachment")
a.Parent = p
local function cd(vec)
	local invSqrt = 1 / math.sqrt(vec.magnitude * vec.magnitude)
	return Vector3.new(vec.x * invSqrt, vec.y * invSqrt, vec.z * invSqrt)
end
local bp = Instance.new("BodyPosition")
bp.Parent = game
bp.D = 150
bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
local bg = Instance.new("BodyGyro")
bg.Parent = game
bg.D = 100
bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
local rot=Vector3.new(0,0,0)
m.Button1Down:connect(function()
	held = true
	part=m.Target
	local notcanhoverable=false
	if part then
		if m.Target.CanCollide == false then
			notcanhoverable = true
		end
	end
	if notcanhoverable then
		m.Target.CanCollide = true
	end
	d=(workspace.CurrentCamera.CFrame.Position-m.Target.Position).magnitude
	if notcanhoverable then
		m.Target.CanCollide = false
	end
	p.CFrame = workspace.CurrentCamera.CFrame
	a.Orientation = p.Orientation
	a.Position = (m.Target.Position)-p.Position
	a.Position = Vector3.new(0,0,d*-1)
	p.Orientation = part.Orientation
	bg.CFrame = p.CFrame
	p.CFrame = workspace.CurrentCamera.CFrame
	rot=part.Orientation
end)
m.Button1Up:connect(function()
	held = false
	bp.Parent = game
	bg.Parent = game
end)
local add=0
local addrot=Vector3.new(0,0,0)
game:GetService("RunService").RenderStepped:Connect(function(step)
	d=d+(add*(step*25))
	d=d+(add*(step*25))
	rot=rot+(addrot*(step*1000))
	if held then
			if part.Anchored == false then
				p.CFrame = CFrame.new(p.Position,  p.Position + cd(m.Hit.Position-workspace.CurrentCamera.CFrame.Position))
				p.Orientation = p.Orientation
				p.CFrame = p.CFrame - p.Position + workspace.CurrentCamera.CFrame.Position
				a.Orientation = p.Orientation
				a.Position = (part.Position)-p.Position
				a.Position = Vector3.new(0,0,d*-1)
				local b = part.CFrame
				part.CFrame = part.CFrame - part.CFrame.Position + a.WorldPosition
				bp.Position = part.Position
				part.CFrame = b
				bp.Parent = part
				bg.Parent = part
				p.Orientation = rot
				bg.CFrame = p.CFrame
			else
				part=m.Target
			end
		else
			part=m.Target

	end
end)
game:GetService("Players").LocalPlayer:GetMouse().KeyDown:connect(function(key)
	if key == "=" then
		add=add+1
	end
	if key == "-" then
		add=add-1
	end
	if key == "t" and false then
		addrot=addrot+Vector3.new(-1,0,0)
	end
	if key == "f" and false then
		addrot=addrot+Vector3.new(0,0,1)
	end
	if key == "g" and false then
		addrot=addrot+Vector3.new(1,0,0)
	end
	if key == "h" and false then
		addrot=addrot+Vector3.new(0,0,-1)
	end
	if key == "r" and false then
		addrot=addrot+Vector3.new(0,1,0)
	end
	if key == "y" and false then
		addrot=addrot+Vector3.new(0,-1,0)
	end
end)
game:GetService("Players").LocalPlayer:GetMouse().KeyUp:connect(function(key)
	if key == "=" then
		add=add-1
	end
	if key == "-" then
		add=add+1
	end
	if key == "t" and false then
		addrot=addrot-Vector3.new(-1,0,0)
	end
	if key == "f" and false then
		addrot=addrot-Vector3.new(0,0,1)
	end
	if key == "g" and false then
		addrot=addrot-Vector3.new(1,0,0)
	end
	if key == "h" and false then
		addrot=addrot-Vector3.new(0,0,-1)
	end
	if key == "r" and false then
		addrot=addrot-Vector3.new(0,1,0)
	end
	if key == "y" and false then
		addrot=addrot-Vector3.new(0,-1,0)
	end
end)
