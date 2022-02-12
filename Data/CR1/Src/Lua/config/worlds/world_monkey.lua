local function Init()
	local motorJoint = FCPhysics2D.CreateRevoluteJoint( "level_jiggler", "level_root", 0, -8.7 )
	FCPhysics2D.SetRevoluteJointMotor( motorJoint, 2, 500 )

	FCPhysics2D.CreatePrismaticJoint( "level_base", "level_root", "axis" )
end

local function Shutdown()
end

world_monkey = World:new()
world_monkey:SetResource( "world_monkey" )
world_monkey:SetInitFunc( Init )
world_monkey:SetShutdownFunc( Shutdown )
