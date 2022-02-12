-- Level 6

local ballCreateThreadId = nil

local function BallCreateThread()
	LevelManager.CreateBall( kBlueBall, -3, 15 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kBlueBall, -1, 15.3 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kBlueBall, 1, 15.4 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kRedBall, -3, 18.6 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kRedBall, -1, 18.4 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kRedBall, 1, 18.2 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kYellowBall, -3, 21 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kYellowBall, -1, 21.2 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kYellowBall, 1, 21.4 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kGreenBall, -3, 24.6 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kGreenBall, -1, 24.4 )
	FCWaitGame( 0.2 )
	LevelManager.CreateBall( kGreenBall, 1, 24.2 )
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

local thisLevel = Level.New( 6, kWord_Level6Name )
thisLevel:SetWorld( world_dog )
thisLevel:SetYear( kWord_TutorialYear )
thisLevel:SetDescription( kWord_TutorialDescription )
thisLevel:SetWikiLink( kWord_TutorialWiki )
thisLevel:SetType( kLevelTypeNormal )
thisLevel:SetRackSize( 3 )
thisLevel:SetInitFunc( InitFunc )
thisLevel:SetShutdownFunc( ShutdownFunc )
thisLevel:SetCreateBallFunc( CreateBallFunc )
thisLevel:SetUpdateFunc( UpdateFunc )
thisLevel:SetNumRacks( 20 )

LevelManager.AddLevel( thisLevel )

