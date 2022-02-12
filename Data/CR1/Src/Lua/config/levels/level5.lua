-- Level 5

local ballCreateThreadId = nil

local function BallCreateThread()
	LevelManager.CreateBall( kBlueBall, -4, 15 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kBlueBall, -2, 15 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kBlueBall, 0, 15.3 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kBlueBall, 2, 15.4 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kBlueBall, 4, 15.4 )
	FCWaitGame( 0.2 )
	
	LevelManager.CreateBall( kRedBall, -4, 18.6 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kRedBall, -2, 18.4 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kRedBall, 0, 18.2 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kRedBall, 2, 18.6 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kRedBall, 4, 18.6 )
	FCWaitGame( 0.2 )
	
	LevelManager.CreateBall( kYellowBall, -4, 21 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kYellowBall, -2, 21.2 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kYellowBall, 0, 21.4 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kYellowBall, 2, 21.4 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kYellowBall, 4, 21.4 )
	FCWaitGame( 0.2 )
	
	LevelManager.CreateBall( kGreenBall, -4, 24.6 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kGreenBall, -2, 24.4 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kGreenBall, 0, 24.2 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kGreenBall, 2, 24.2 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kGreenBall, 4, 24.2 )
	FCWaitGame( 0.2 )
	
	FCWaitGame( 3 )
	
	GamePhase.StartGame()
	
	GamePhase.FillRack()
		
	ballCreateThreadId = nil
end

-- Tutorial vars



local function InitFunc()
	ballCreateThreadId = FCNewThread( BallCreateThread )
end

local function ShutdownFunc()
	if ballCreateThreadId then
		FCKillThread( ballCreateThreadId )
		ballCreateThreadId = nil
	end
end

local function CreateBallFunc( self, i, num )
	x = (self:Random():Get() % 5) - 2
	y = 15 + i
	return x, y
end

local function UpdateFunc()
end

local thisLevel = Level.New( 5, kWord_Level5Name )
thisLevel:SetWorld( world_worm )
thisLevel:SetYear( kWord_TutorialYear )
thisLevel:SetDescription( kWord_TutorialDescription )
thisLevel:SetWikiLink( kWord_TutorialWiki )
thisLevel:SetType( kLevelTypeNormal )
thisLevel:SetRackSize( 5 )
thisLevel:SetInitFunc( InitFunc )
thisLevel:SetShutdownFunc( ShutdownFunc )
thisLevel:SetCreateBallFunc( CreateBallFunc )
thisLevel:SetUpdateFunc( UpdateFunc )
thisLevel:SetNumRacks( 30 )

LevelManager.AddLevel( thisLevel )

