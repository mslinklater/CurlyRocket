-------------------------------------------------------

kWindowAspect = 0

local vm = FCViewManager
local currentRound = 0
local holdingPen = {}
local currentScore = 0
local timerThread = nil
local levelHighScore = 0;
local tutorial = false
gemCreateXPos = 0

-------------------------------------------------------
-- View positions

local kQuitButtonPos = {0.2, 0.85, 0.6, 0.1}
local kRestartButtonPos = {0.2, 0.7, 0.6, 0.1}
local kShareButtonPos = {0.2, 0.55, 0.6, 0.1}
local kRackViewPos = { 0.25, 0, 0.5, 0.07 }
local kTimerViewOnPos = {0, 0.2, 0.05, 0.6}
local kTimerViewOffPos = {-0.1, 0.2, 0.05, 0.6}
local kPauseButtonPos = { 0.0, 0.0, 0.15, 0.1 }
local kRoundsViewPos = { 0.0, 0.1, 0.3, 0.06 }

-------------------------------------------------------

function SharePressed()
	FCLog("Share pressed")
	FCTwitter.TweetWithText( "I just scored " .. currentScore .. " on '" .. currentLevel:Name() .. "' #" .. Globals.AppName() )
	FCTwitter.Send()
end

-------------------------------------------------------

function QuitPressed()
	--FCLog("Quit Pressed")
	
	if timerThread then
		FCKillThread( timerThread )
		timerThread = nil
	end
	
	FCPhaseManager.AddPhaseToQueue( "FrontEnd" )
	FCPhaseManager.DeactivatePhase( "Game" )
end


function RestartThread()
	vm.SetAlpha( "quitButton, restartButton, gameView, shareButton", 0, 0.5 )
	vm.SetAlpha( "scoreView, highScoreView, scoreLabel, highScoreLabel, newHighScoreLabel", 0, 0.5 )
	FCWait( 0.5 )
	vm.SetViewPropertyInteger( "scoreView", "score", 0 )
	vm.SetFrame( "scoreView", { 0.25, (0.1 / kWindowAspect) + 0.01, 0.5, 0.08 / kWindowAspect } )
	vm.SetAlpha( "scoreView", 1, 0.5 )
	GamePhase.ShutdownLevel()
	GamePhase.InitialiseLevel()
	vm.SetAlpha( "gameView", 1, 0.5 )
	FCWait( 0.5 )
	FCApp.Pause( false )
	--ActivateThread()
	SetupGametypeStuff()

end

function RestartPressed()
	if timerThread then
		FCKillThread( timerThread )
		timerThread = nil
	end
	GameAppDelegate.HideAdBanner()
	FCNewThread( RestartThread )
end

-------------------------------------------------------

function PausePressedThread()
	FCApp.Pause( true )
	vm.SetAlpha( "quitButton", 0 )
	vm.SetAlpha( "restartButton", 0 )	
	vm.SetAlpha( "quitButton", 1, 0.5 )
	vm.SetAlpha( "restartButton", 1, 0.5 )
	vm.SetAlpha( "pauseButton", 1, 0.5 )
end

function PausePressed()
	FCNewThread( PausePressedThread )
end

function ResumePressedThread()
	--GLView.SetCurrent( "main" )

	vm.SetAlpha( "quitButton", 0, 0.5 )
	vm.SetAlpha( "restartButton", 0, 0.5 )
	vm.SetAlpha( "pauseButton", 0.5, 0.5 )
	FCWait( 0.5 )
	FCApp.Pause( false )
end

function ResumePressed()
	FCNewThread( ResumePressedThread )
end

local function RackViewAppear()
	vm.SetAlpha( "rackView", 0 )
	vm.SetFrame( "rackView", kRackViewPos )
	vm.SetAlpha( "rackView", 1, 0.5 )
end

local function RackViewDisappear()
	vm.SetAlpha( "rackView", 0, 0.5 )
end

function SetupGametypeStuff()
	if currentLevel:Type() == kLevelTypeTimed then
		Game.SetTimes( currentLevel:Time(), currentLevel:Time() )
	elseif currentLevel:Type() == kLevelTypeNormal then
		Game.SetRounds( 0, currentLevel:NumRacks() )
	end
	RackViewAppear()
end

local function PauseButtonAppear()
	--vm.SetAlpha( "pauseButton", 0 )
	vm.SetAlpha( "pauseButton", 0.25, 0.5 )
	vm.SetFrame( "pauseButton", kPauseButtonPos)
end

local function PauseButtonDisappear()
	vm.SetAlpha( "pauseButton", 0, 0.5 )
end


function ActivateThread()
	--FCLog("GamePhase.ActivateThread")

	levelHighScore = FCPersistentData.GetNumber( currentLevel:Name() .. "highscore" )
	if levelHighScore == nil then
		levelHighScore = 0
	end

	SetupGametypeStuff()

	--Game.SetCurrentScore( 0 )
	vm.SetViewPropertyInteger( "scoreView", "score", 0 )
	vm.SetAlpha( "gameView", 0 )
	
	-- pause button
	vm.SetAlpha( "gameView", 1, 0.5 )
	
	-- timer bar
	vm.SetFrame( "timerView", kTimerViewOffPos, 1)
	vm.SetAlpha( "timerView", 0 )
	
	-- rack

	-- score
	vm.SetAlpha( "scoreView", 0 )
	vm.SetFrame( "scoreView", { 0.25, (0.1 / kWindowAspect) + 0.01, 0.5, 0.08 / kWindowAspect }, 1 )
	vm.SetAlpha( "scoreView", 1, 0.5 )
	
	vm.SetAlpha( "roundsView", 0 )

	if currentLevel:Type() == kLevelTypeNormal then
		vm.SetAlpha( "roundsView", 1, 0.5 )
		vm.SetFrame( "roundsView", kRoundsViewPos )
	elseif currentLevel:Type() == kLevelTypeTimed then
		vm.SetFrame( "timerView", kTimerViewOnPos )
		vm.SetAlpha( "timerView", 1, 0.5 )
	elseif currentLevel.type == kLevelTypeBlitz then
		vm.SetFrame( "timerView", kTimerViewOnPos )
		vm.SetAlpha( "timerView", 1, 0.5 )
	else
		FCLog("WARNING - level type not set")
	end

end

-------------------------------------------------------

GamePhase = {}


function GamePhase.TimerThread( duration )
	
	local timeRemaining = duration
	
	while timeRemaining > 0 do
		Game.SetTimes( duration, timeRemaining )
		--FCLog("Duration " .. duration )
		FCWaitGame( 1 )
		timeRemaining = timeRemaining - 1
	end
	Game.ForceGameOver()
end

function GamePhase.StartGame()
	holdingPen = {}
	currentScore = 0
	vm.SetViewPropertyInteger( "scoreView", "score", currentScore )
	--Game.SetCurrentScore( currentScore )
	
	if currentLevel:Type() == kLevelTypeTimed then
		timerThread = FCNewThread( GamePhase.TimerThread, currentLevel:Time() )
	elseif currentLevel:Type() == kLevelTypeNormal then
		Game.SetRounds( 0, currentLevel:NumRacks() )
	end

	if currentLevel.StartGame then
		currentLevel:StartGame()
	end
end

function GamePhase.EndGameUIThread()
	vm.SetAlpha( "gameView", 0, 4 )
	PauseButtonDisappear()
	vm.SetAlpha( "timerView, roundsView", 0, 0.5 )
	RackViewDisappear()
	FCWaitGame( 2 )
	FCApp.Pause( false )
	
	levelid = currentLevel:Id()
	
	-- unlock next level
	if levelid < LevelManager.NumLevels() then	-- guard against unlocked past end of levels
		LevelManager.UnlockLevel( levelid + 1 )
	end
	
	if currentLevel:Tutorial() == false then
		vm.SetFrame( "restartButton", kRestartButtonPos )
		vm.SetAlpha( "restartButton", 1, 0.5 )
	end
	
	vm.SetFrame( "quitButton", kQuitButtonPos )
	vm.SetAlpha( "quitButton", 1, 0.5 )
	
	if currentLevel:Tutorial() == true then
		levelHighScore = 99999
	end

	if currentScore > levelHighScore then	-- New high score !
		FCPersistentData.SetNumber( currentLevel:Name() .. "highscore", currentScore )
		FCPersistentData.Save()
		vm.SetAlpha( "newHighScoreLabel", 0 )
		vm.SetFrame( "newHighScoreLabel", {0.1, 0.2, 0.8, 0.15} )
		vm.SetAlpha( "newHighScoreLabel", 1, 0.5 )
		vm.SetFrame( "scoreView", {0.1, 0.35, 0.8, 0.15} )		
		vm.SetAlpha( "shareButton", 0 )
		vm.SetFrame( "shareButton", kShareButtonPos )
		vm.SetAlpha( "shareButton", 1, 0.5 )
	else
		vm.SetAlpha( "scoreLabel, highScoreLabel", 0 )
		vm.SetFrame( "scoreLabel", {0.2, 0.15, 0.6, 0.1} )
		vm.SetFrame( "scoreView", {0.1, 0.25, 0.8, 0.15} )
		
		if currentLevel:Tutorial() == false then
			vm.SetFrame( "highScoreLabel", {0.2, 0.4, 0.6, 0.1} )		
			vm.SetAlpha( "highScoreView", 0 )
			vm.SetViewPropertyInteger( "highScoreView", "score", levelHighScore )
			--vm.SetText( "highScoreView", tostring( levelHighScore ) )
			vm.SetFrame( "highScoreView", {0.1, 0.5, 0.8, 0.15} )
		end
		
		vm.SetAlpha( "scoreLabel, highScoreLabel, highScoreView", 1, 0.5 )
	end
	
	vm.SetAlpha( "scoreView", 0, 0.2 )
	vm.SetAlpha( "scoreView", 1, 0.5 )
end

function GamePhase.EndGameUI()
	if Globals.AddsActive() then
		GameAppDelegate.ShowAdBanner()
	end
	FCNewThread( GamePhase.EndGameUIThread )
end

function GamePhase.FillRack()
	local rackSize = currentLevel:RackSize()
	
	col1 = (currentLevel:Random():Get() % 4)
	col2 = (currentLevel:Random():Get() % 4)
	col3 = (currentLevel:Random():Get() % 4)
	col4 = (currentLevel:Random():Get() % 4)
	col5 = (currentLevel:Random():Get() % 4)
		
	if rackSize == 3 then
		Game.RackFillWithColors(col1, col2, col3 ) 
	elseif rackSize == 4 then
		Game.RackFillWithColors(col1, col2, col3, col4 ) 
	else
		Game.RackFillWithColors(col1, col2, col3, col4, col5 ) 
	end
end

function GamePhase.InitialiseLevel()
	FCLog("GamePhase.InitialiseLevel");
	
	-- physics
	FCPhysics.Reset()
	FCPhysics.Create2DSystem()
	AddPhysicsMaterials()
	
	FCAudio.SubscribeToPhysics2D()

	-- actors
	FCActorSystem.Reset()

	-- load world resource
	Game.LoadLevel( currentLevel:World().resource )
	
	if currentLevel:World().Init then
		currentLevel:World().Init()
	end

	
	-- level specific initialisation
	
	if currentLevel.Init then
		currentLevel:Init()
	end
	
	-- generic level reset
	
	currentLevel:Reset()
	Game.RackClear()
	
	currentRound = 0
	PauseButtonAppear()
end

function GamePhase.ShutdownLevel()
	--FCLog("GamePhase.ShutdownLevel");
	
	--GameAppDelegate.HideAdBanner()
	
	if currentLevel:World().Shutdown then
		currentLevel:World().Shutdown()
	end
	if currentLevel.Shutdown then
		currentLevel.Shutdown()
	end	
	LevelManager.DestroyBalls()
	LevelManager.DestroyBombs()
	LevelManager.DestroyGems()
	Game.DestroyLevel();

	FCActorSystem.Reset()
	FCAudio.UnsubscribeFromPhysics2D()
	FCPhysics.Reset()
end

local function CreateViews()
	vm.CreateView( "newHighScoreLabel", "LabelView" )
	vm.CreateView( "highScoreLabel", "LabelView" )
	vm.CreateView( "scoreLabel", "LabelView" )
	vm.CreateView( "quitButton", "ButtonView" )
	vm.CreateView( "restartButton", "ButtonView" )
	vm.CreateView( "shareButton", "ButtonView" )
	vm.CreateView( "pauseButton", "PauseButtonView" )
	vm.CreateView( "scoreView", "ScoreView" )
	vm.CreateView( "highScoreView", "ScoreView" )
	Game.CreateRackView()
	--vm.CreateView( "timerView", "TimerView" )
	Game.CreateTimerView()
	--vm.CreateView( "roundsView", "RoundsView" )
	Game.CreateRoundsView()
end

local function DestroyViews()
	vm.DestroyView( "newHighScoreLabel" )
	vm.DestroyView( "highScoreLabel" )
	vm.DestroyView( "scoreLabel" )
	vm.DestroyView( "quitButton" )
	vm.DestroyView( "restartButton" )
	vm.DestroyView( "shareButton" )
	vm.DestroyView( "pauseButton" )
	vm.DestroyView( "scoreView" )
	vm.DestroyView( "highScoreView" )
	Game.DestroyRackView()
	--vm.DestroyView( "timerView" )
	Game.DestroyTimerView()
	--vm.DestroyView( "roundsView" )
	Game.DestroyRoundsView()
end

function GamePhase.WillActivate()
	CreateViews()

	GameAppDelegate.HideAdBanner()

	vm.SetText( "newHighScoreLabel", kWord_NewHighScore )
	vm.SetText( "highScoreLabel", kWord_HighScore )
	vm.SetText( "scoreLabel", kWord_Score )

	FCApp.SetUpdateFrequency( 30 )

	gameFrame = vm.GetFrame( "gameView" )
	kWindowAspect = gameFrame.h / gameFrame.w
	
	GLView.SetCurrent( "gameView" )
	GLView.SetClearColor( {0, 0, 0, 0} )
	GLView.SetFOV( 0.4 )
	GLView.SetNearFarClip( 1, 100 )
	GLView.SetFrustumTranslation( 0, 0, -18 )
	
	vm.SetAlpha( "gameView", 0 )
	--vm.SetFrame( "pauseButton", { 0.0, -0.1, 0.1 * kWindowAspect, 0.1 })
	vm.SetFrame( "timerView", kTimerViewOffPos)
	vm.SetFrame( "rackView", kRackViewPos )
	vm.SetFrame( "scoreView", { 0.25, -0.2, 0.5, 0.08 / kWindowAspect })

	vm.SetAlpha( "quitButton, restartButton", 0 )
	
	vm.SetFrame( "quitButton", kQuitButtonPos )
	vm.SetText( "quitButton", kWord_Quit )
	vm.SetTextColor( "quitButton", Globals.kSepiaColor )
	vm.SetOnSelectLuaFunction( "quitButton", "QuitPressed" )

	vm.SetText( "shareButton", kWord_Share )
	vm.SetTextColor( "shareButton", Globals.kSepiaColor )
	vm.SetOnSelectLuaFunction( "shareButton", "SharePressed" )

	vm.SetFrame( "restartButton", kRestartButtonPos )
	vm.SetText( "restartButton", kWord_Restart )
	vm.SetTextColor( "restartButton", Globals.kSepiaColor )
	vm.SetOnSelectLuaFunction( "restartButton", "RestartPressed" )
	
	FCStats.Inc( "numGamesStarted" )
	GamePhase.InitialiseLevel()
	FCRenderer.SetCurrentRenderer( "gameRenderer" )
	FCApp.Pause( false )	
end

function GamePhase.WillDeactivate()
	PauseButtonDisappear()
	vm.SetFrame( "timerView", kTimerViewOffPos, 0.5)
	vm.SetFrame( "rackView", kRackViewPos, 0.5)
	vm.SetFrame( "scoreView", { 0.25, -0.2, 0.5, 0.05 / kWindowAspect }, 0.5)
	vm.SetAlpha( "quitButton, restartButton, gameView", 0, 0.5 )
end

local function MusicFinishedInGameFunc()
	FCAudio.PlayMusic("Assets/Audio/ingame")
end

function GamePhase.IsNowActive()
	ActivateThread()
	
	FCAudio.PlayMusic("Assets/Audio/ingame")
	
	local musicVolume = FCPersistentData.GetNumber( "musicVolume" )
	FCAudio.SetMusicVolume( musicVolume / 10 )
	
	local sfxVolume = FCPersistentData.GetNumber( "musicVolume" )
	FCAudio.SetMusicVolume( sfxVolume / 10 )
	
	FCAudio.SetMusicFinishedCallback( "MusicFinishedInGameFunc" )

end

function GamePhase.IsNowDeactive()
	DestroyViews()
	
	GamePhase.ShutdownLevel()
end

function GamePhase.Update()
	LevelManager.Update()
	if currentLevel ~= nil then
		currentLevel:UpdateFunc()
	end
end

function GamePhase.NormalGameEndOfRack()
	currentRound = currentRound + 1
	
	Game.SetRounds( currentRound, currentLevel:NumRacks() )
	
	return currentRound >= currentLevel:NumRacks()
end

function GamePhase.TimedGameEndOfRack()
	return false
end

function GamePhase.BlitzGameEndOfRack()
	return false
end

function GamePhase.BallTapped( ballHandle )
	desiredColor = Game.RackGetCurrentColor()
	tappedColor = LevelManager.ColorOfBallWithHandle( ballHandle )
	
	if desiredColor == tappedColor then
		-- correct color
		
		--gemCreateXPos = Game.GetBallPosition( ballHandle )
		gemCreateXPos, y, z = FCActorSystem.GetPosition( ballHandle )
		
		holdingPen[ #holdingPen + 1 ] = tappedColor
		LevelManager.DestroyBall( ballHandle )
		
		if( Game.RackRemoveCurrent() ) then		-- End of rack
		
			local gameOver = false
			if currentLevel:Type() == kLevelTypeNormal then
				gameOver = GamePhase.NormalGameEndOfRack()
			elseif currentLevel:Type() == kLevelTypeTimed then
				gameOver = GamePhase.TimedGameEndOfRack()
			else
				gameOver = GamePhase.BlitzGameEndOfRack()
			end

			if gameOver == true then
				GamePhase.EndGameUI()
			else
				local activeGems = LevelManager.GetActiveGems()

				for h in pairs( activeGems ) do
					local gemAge = Game.GetGemAge( h )
					gemAge = gemAge + 1
					currentScore = currentScore + gemAge
					Game.SetGemAge( h, gemAge )
				end
				
				vm.SetViewPropertyInteger( "scoreView", "score", currentScore )
				
				GamePhase.FillRack()
				LevelManager.CreateGem( currentLevel:CreateGemPos() )
				
				for i, h in ipairs( holdingPen ) do
					LevelManager.CreateBall( h, currentLevel:CreateBallPos( i, #holdingPen ) )
				end

				holdingPen = {}
				
				LevelManager.UpdateGemColor()
			end		
		end		
	else
		-- incorrect color
		-- deduct points ?
	end
end

