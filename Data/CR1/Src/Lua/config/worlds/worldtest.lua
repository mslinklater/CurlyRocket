motorJoint = nil
threadid = nil

local function Thread()
	while 1 do
		FCPhysics2D.SetRevoluteJointMotor( motorJoint, 5, 500 )
		FCWaitGame(5)
		FCPhysics2D.SetRevoluteJointMotor( motorJoint, -5, 500 )
		FCWaitGame(5)		
	end
end

local function Init()
	FCPhysics2D.CreateDistanceJoint( "pegr1", 0, 0, "root", "righttopanchor" )
	FCPhysics2D.CreateDistanceJoint( "pegr2", 0, 0, "pegr1", 0, 0 )
	FCPhysics2D.CreateDistanceJoint( "pegr3", 0, 0, "pegr2", 0, 0 )
	FCPhysics2D.CreateDistanceJoint( "pegr3", 0, 0, "pegr2", 0, 0 )
	FCPhysics2D.CreateDistanceJoint( "pegr3", 0, 0, "base", "rightbottomanchor" )
	FCPhysics2D.CreateDistanceJoint( "pegl1", 0, 0, "root", "lefttopanchor" )
	FCPhysics2D.CreateDistanceJoint( "pegl2", 0, 0, "pegl1", 0, 0 )
	FCPhysics2D.CreateDistanceJoint( "pegl3", 0, 0, "pegl2", 0, 0 )
	FCPhysics2D.CreateDistanceJoint( "pegl3", 0, 0, "pegl2", 0, 0 )
	FCPhysics2D.CreateDistanceJoint( "pegl3", 0, 0, "base", "leftbottomanchor" )

	FCPhysics2D.CreateRevoluteJoint( "swingend", "revtest", "swingend" )	
	motorJoint = FCPhysics2D.CreateRevoluteJoint( "revtest", "root", "revnull" )
	FCPhysics2D.SetRevoluteJointMotor( motorJoint, 5, 500 )

	FCPhysics2D.CreatePrismaticJoint( "swingend", "base", "axis" )
	--FCPhysics2D.SetPrismaticJointMotor( rev, -1, 500 )
	
	--FCPhysics2D.CreatePrismaticJoint( "slideblock", "base", "slideblockcons" )
	FCPhysics2D.CreatePulleyJoint( "pulley1", "pulley2", "pulleytop1", "pulleytop2", "pulleyobj1", "pulleyobj2", 1 )
	
	threadid = FCNewThread( Thread )
end

local function Shutdown()
	FCKillThread( threadid )
end

worldtest = World:new()
worldtest:SetResource( "worldtest" )
worldtest:SetInitFunc( Init )
worldtest:SetShutdownFunc( Shutdown )

--World4 = {
--	resource = "world5",
--	Init = World4Init,
--	Shutdown = World4Shutdown
--}