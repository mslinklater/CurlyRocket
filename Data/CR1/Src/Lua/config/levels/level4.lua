-- Level 4

local ballCreateThreadId = nil

local function BallCreateThread()
	LevelManager.CreateBall( kBlueBall, -3, 15 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kBlueBall, -1, 15.3 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kBlueBall, 1, 15.4 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kBlueBall, 3, 15.6 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kRedBall, -3, 18.6 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kRedBall, -1, 18.4 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kRedBall, 1, 18.2 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kRedBall, 3, 18 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kYellowBall, -3, 21 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kYellowBall, -1, 21.2 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kYellowBall, 1, 21.4 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kYellowBall, 3, 21.6 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kGreenBall, -3, 24.6 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kGreenBall, -1, 24.4 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kGreenBall, 1, 24.2 )
	FCWait( 0.2 )
	LevelManager.CreateBall( kGreenBall, 3, 24 )
	FCWait( 0.2 )
	
	GamePhase.StartGame()
	
	GamePhase.FillRack()
		
	ballCreateThreadId = nil
end

local function InitFunc()
	ballCreateThreadId = FCNewThread( BallCreateThread )
end

local bombThreadId = nil

local function bombThread()
	while true do
		FCWait( 10 )
		LevelManager.CreateBomb( 5, 0, 8 )
	end
end


local function StartGameFunc()
	bombThreadId = FCNewThread( bombThread )
	
end

local function Update()
end

local function ShutdownFunc()
	if ballCreateThreadId then
		FCKillThread( ballCreateThreadId )
		ballCreateThreadId = nil
	end
	if bombThreadId ~= nil then
		FCKillThread( bombThreadId )
		bombThreadId = nil
	end
	
end

local thisLevel = Level.New( 4, kWord_Level4Name )
thisLevel:SetWorld( world_monkey )
thisLevel:SetYear( "1921" )
thisLevel:SetDescription( "The worlds first commercial radio station begins broadcasting." )
thisLevel:SetWikiLink( "http://en.wikipedia.org/wiki/Radio_broadcasting" )
thisLevel:SetType( kLevelTypeNormal )
thisLevel:SetRackSize( 3 )
thisLevel:SetInitFunc( InitFunc )
thisLevel:SetShutdownFunc( ShutdownFunc )
--thisLevel:SetCreateBallFunc( CreateBallFunc )
thisLevel:SetUpdateFunc( Update )
thisLevel:SetStartGameFunc( StartGameFunc )
thisLevel:SetNumRacks( 25 )

LevelManager.AddLevel( thisLevel )