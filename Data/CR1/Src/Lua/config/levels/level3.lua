-- Level 3

local ballCreateThreadId = nil
local bombThreadId = nil

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

local function InitFunc()
	ballCreateThreadId = FCNewThread( BallCreateThread )
	
	turbineSFX = FCAudio.PrepareSourceWithBuffer( kAudioBufferTurbine, true )
	
	FCAudio.SourceSetVolume( turbineSFX, 0.5 )
	FCAudio.SourceLooping( turbineSFX, true )
	FCAudio.SourcePlay( turbineSFX )
end

local function ShutdownFunc()
	if ballCreateThreadId then
		FCKillThread( ballCreateThreadId )
		ballCreateThreadId = nil
	end
	if bombThreadId then
		FCKillThread( bombThreadId )
		bombThreadId = nil
	end
	
	FCAudio.SourceStop( turbineSFX )
end


local function StartGameFunc()
end

local function Update()
	rotSpeed = FCPhysics2D.GetAngularVelocity( "level_spinner" ) + 5
--	FCAudio.SourcePitch( turbineSFX, 1.0 - (rotSpeed / 10) )
end

local function EndGameFunc()
end

local function CreateBallFunc( self, i, num )
	x = (self:Random():Get() % 5) - 2
	y = 15 + i
	return x, y
end

local thisLevel = Level.New( 3, kWord_Level3Name )
thisLevel:SetWorld( world_frog )
thisLevel:SetYear( "1920" )
thisLevel:SetDescription( "The worlds first commercial radio station begins broadcasting." )
thisLevel:SetWikiLink( "http://en.wikipedia.org/wiki/Timeline_of_radio#Audio_broadcasting_.281915_to_1950s.29" )
thisLevel:SetType( kLevelTypeTimed )
thisLevel:SetRackSize( 3 )
thisLevel:SetInitFunc( InitFunc )
thisLevel:SetShutdownFunc( ShutdownFunc )
thisLevel:SetCreateBallFunc( CreateBallFunc )
thisLevel:SetStartGameFunc( StartGameFunc )
thisLevel:SetUpdateFunc( Update )
thisLevel:SetEndGameFunc( EndGameFunc )
thisLevel:SetTime( 120 )

LevelManager.AddLevel( thisLevel )

