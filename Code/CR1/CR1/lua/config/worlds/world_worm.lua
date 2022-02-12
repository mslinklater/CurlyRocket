
local function Init()
	FCPhysics2D.CreateRopeJoint( "level_root", "level_peg1", 6, -2, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg1", "level_peg2", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg2", "level_peg3", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg3", "level_peg4", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg4", "level_peg5", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg5", "level_peg6", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg6", "level_peg7", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg7", "level_peg8", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg8", "level_peg9", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg9", "level_peg10", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_peg10", "level_peg11", 0, 0, 0, 0 )
	FCPhysics2D.CreateRopeJoint( "level_root", "level_peg11", -6, -2, 0, 0 )
end

world_worm = World:new()
world_worm:SetResource( "world_worm" )
world_worm:SetInitFunc( Init )

