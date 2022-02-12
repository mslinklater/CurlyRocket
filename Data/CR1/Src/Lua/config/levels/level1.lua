-- Level 1

local ballCreateThreadId = nil

local function BallCreateThread()

	for i = 1,3 do
		LevelManager.CreateBall( kRedBall, 0.1, 15 )
		FCWaitGame( 0.2 )
		LevelManager.CreateBall( kBlueBall, -0.1, 15 )
		FCWaitGame( 0.2 )
		LevelManager.CreateBall( kGreenBall, 0.1, 15 )
		FCWaitGame( 0.2 )
		LevelManager.CreateBall( kYellowBall, -0.1, 15 )
		FCWaitGame( 0.2 )
	end
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

local thisLevel = Level.New( 1, kWord_TutorialName )
thisLevel:SetWorld( world_wolf )
thisLevel:SetYear( kWord_TutorialYear )
thisLevel:SetDescription( kWord_TutorialDescription )
thisLevel:SetWikiLink( kWord_TutorialWiki )
thisLevel:SetType( kLevelTypeNormal )
thisLevel:SetRackSize( 3 )
thisLevel:SetInitFunc( InitFunc )
thisLevel:SetShutdownFunc( ShutdownFunc )
thisLevel:SetCreateBallFunc( CreateBallFunc )
thisLevel:SetUpdateFunc( UpdateFunc )
thisLevel:SetNumRacks( 10 )
thisLevel:SetTutorial( true )

LevelManager.AddLevel( thisLevel )

