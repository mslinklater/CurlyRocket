
motorJoint = 0

local function Init()
	motorJoint = FCPhysics2D.CreateRevoluteJoint( "level_spinner", "level_root", 0, 1 )
	FCPhysics2D.SetRevoluteJointMotor( motorJoint, 5, 500 )
end

local function Shutdown()
end

world_frog = World:new()
world_frog:SetResource( "world_frog" )
world_frog:SetInitFunc( Init )
world_frog:SetShutdownFunc( Shutdown )
