-- Level 2

local ballCreateThreadId = nil

local function BallCreateThread()
	LevelManager.CreateBall( kBlueBall, -0.5, 19 )
	LevelManager.CreateBall( kBlueBall, 0, 17 )
	LevelManager.CreateBall( kBlueBall, 0.5, 15 )
	FCWaitGame( 0.5 )
	LevelManager.CreateBall( kRedBall, -0.5, 19 )
	LevelManager.CreateBall( kRedBall, 0, 17 )
	LevelManager.CreateBall( kRedBall, 0.5, 15 )
	FCWaitGame( 0.5 )
	LevelManager.CreateBall( kYellowBall, -0.5, 19 )
	LevelManager.CreateBall( kYellowBall, 0, 17 )
	LevelManager.CreateBall( kYellowBall, 0.5, 15 )
	FCWaitGame( 0.5 )
	LevelManager.CreateBall( kGreenBall, -0.5, 19 )
	LevelManager.CreateBall( kGreenBall, 0, 17 )
	LevelManager.CreateBall( kGreenBall, 0.5, 15 )
	
	FCWaitGame( 3 )
	
	GamePhase.StartGame()
	
	GamePhase.FillRack()
		
	ballCreateThreadId = nil
end

local function InitFunc()
	ballCreateThreadId = FCNewThread( BallCreateThread )
end

local function ShutdownFunc()
	if ballCreateThreadId then
		FCKillThread( ballCreateThreadId )
		ballCreateThreadId = nil
	end
end

local thisLevel = Level.New( 2, kWord_GandhiName )
thisLevel:SetWorld( world_chicken )
thisLevel:SetYear( kWord_GandhiYear )
thisLevel:SetDescription( kWord_GandhiDescription )
thisLevel:SetWikiLink( kWord_GandhiWiki )
thisLevel:SetType( kLevelTypeNormal )
thisLevel:SetRackSize( 3 )
thisLevel:SetInitFunc( InitFunc )
thisLevel:SetShutdownFunc( ShutdownFunc )
--thisLevel:SetCreateBallFunc( CreateBallFunc )
thisLevel:SetNumRacks( 30 )

LevelManager.AddLevel( thisLevel )

