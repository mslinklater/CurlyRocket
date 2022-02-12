
local currentGamePhase

sequence = nil
score = 0
scoreThread = nil

function SetPlayButtonsInteractive( val )
	redPlayButton:SetIntegerProperty( "interactive", val )
	greenPlayButton:SetIntegerProperty( "interactive", val )
	bluePlayButton:SetIntegerProperty( "interactive", val )
	magentaPlayButton:SetIntegerProperty( "interactive", val )
	cyanPlayButton:SetIntegerProperty( "interactive", val )
	yellowPlayButton:SetIntegerProperty( "interactive", val )
end

function TurnAllButtonsOff()
	redPlayButton:SetIntegerProperty( "pressed", 0 )
	bluePlayButton:SetIntegerProperty( "pressed", 0 )
	greenPlayButton:SetIntegerProperty( "pressed", 0 )
	yellowPlayButton:SetIntegerProperty( "pressed", 0 )
	cyanPlayButton:SetIntegerProperty( "pressed", 0 )
	magentaPlayButton:SetIntegerProperty( "pressed", 0 )
end

function Silence()
	FCAudio.SourceSetVolume( source1, 0 )
	FCAudio.SourceSetVolume( source2, 0 )
	FCAudio.SourceSetVolume( source3, 0 )
	FCAudio.SourceSetVolume( source4, 0 )
	FCAudio.SourceSetVolume( source5, 0 )
	FCAudio.SourceSetVolume( source6, 0 )
end

function SetScore( bank, roundScore )
	scoreLabel:SetIntegerProperty( "bank", bank )
	clockView:SetIntegerProperty( "roundScore", roundScore )
	clockView:SetIntegerProperty( "roundScoreMax", roundScoreMax )
	score = bank + roundScore
end

function Tone( which, vol )
	if which == kRedPlayButton then
		FCAudio.SourceSetVolume( source1, vol )
	end
	if which == kGreenPlayButton then
		FCAudio.SourceSetVolume( source2, vol )
	end
	if which == kYellowPlayButton then
		FCAudio.SourceSetVolume( source3, vol )
	end
	if which == kBluePlayButton then
		FCAudio.SourceSetVolume( source4, vol )
	end
	if which == kMagentaPlayButton then
		FCAudio.SourceSetVolume( source5, vol )
	end
	if which == kCyanPlayButton then
		FCAudio.SourceSetVolume( source6, vol )
	end
end

function CompTurnThread()

	local seqSize = #sequence

	FCWait( 1.0 )
	
	percentThrough = seqSize / kMaxRounds
	
	for iSeq = 1, seqSize do
		GameDisplaySequenceColorsAtIndex( iSeq, 1 )
		FCWait( GameLightsOnTime( percentThrough ) )
		GameDisplaySequenceColorsAtIndex( iSeq, 0 )
		FCWait( GameLightsOffTime( percentThrough ) )
	end
	compTurnThread = nil
	SetCurrentGamePhase( kGamePhaseUserTurn )
end

function FlashRedThread()
	FCWait( 0.05 )
	FCApp.SetBackgroundColor( { 1, 0, 0, 1.0 } )
	FCWait( 0.2 )
	FCApp.SetBackgroundColor( { 0, 0, 0, 1.0 } )
end

function FlashGreenThread()
	FCWait( 0.05 )
	FCApp.SetBackgroundColor( { 0, 1, 0, 1.0 } )
	FCWait( 0.2 )
	FCApp.SetBackgroundColor( { 0, 0, 0, 1.0 } )
end

function RetryThread()
	backButton:SetFrame( BackHiddenPos(), 0.2 )
	retryButton:SetFrame( RetryHiddenPos(), 0.2 )
	tweetButton:SetFrame( TweetHiddenPos(), 0.2 )
	clockView:SetFrame( ClockHiddenPos() )
	gameCenterButton:SetFrame( GameCenterHiddenPos(), 0.2 )
	scoreLabel:SetFrame( ScoreHiddenPos() )
	highScoreLabel:SetAlpha( 0 )
	FCWait( 0.5 )
	InitGame()
end

function TweetThread()
	FCTwitter.TweetWithText("I just scored " .. score .. " on Curly Square ! #curlysquare")
	FCTwitter.Send()
end

function RetryFunc()
	FCAnalytics.RegisterEvent( "Press Retry" )
	PlayClickSFX()
	FCNewThread( RetryThread )
end

function TweetFunc()
	FCAnalytics.RegisterEvent( "Press Tweet" )
	PlayClickSFX()
	FCNewThread( TweetThread )
end

function GameCenterFunc()
	FCAnalytics.RegisterEvent( "Press Game Center" )
	PlayClickSFX()
	FCOnlineLeaderboard.Show()
end

function UpdateHighScore()
	highScore = FCPersistentData.GetNumber( GameGetHighScoreName() )
	if score > highScore then
		FCPersistentData.SetNumber( GameGetHighScoreName(), score )
		FCPersistentData.Save()
		highScoreLabel:SetAlpha( 0 )
		highScoreLabel:SetFrame( {0, 0.15, 1, 0.15} )
		highScoreLabel:SetAlpha( 1, 0.5 )
		FCOnlineLeaderboard.PostScore( GameOnlineLeaderboardName(), score )
	else
		FCOnlineLeaderboard.CheckForStoredScore( GameOnlineLeaderboardName() )
	end
end

function ShowEndGameButtons()
	backButton:SetBackgroundColor( kClearColor )
	retryButton:SetBackgroundColor( kClearColor )
	tweetButton:SetBackgroundColor( kClearColor )
	gameCenterButton:SetBackgroundColor( kClearColor )
	
	backButton:SetFrame( BackHiddenPos() )
	backButton:SetFrame( BackVisiblePos(), 0.2 )
	backButton:SetOnSelectLuaFunction( "QuitButtonPressed" )
	backButton:SetStringProperty( "BackgroundImage", "Assets/Images/BackBackground.png" )
	backButton:SetStringProperty( "TopImage", "Assets/Images/Back Button.png" )
	
	retryButton:SetFrame( RetryHiddenPos() )
	retryButton:SetFrame( RetryVisiblePos(), 0.25 )
	retryButton:SetStringProperty( "BackgroundImage", "Assets/Images/RetryBackground.png" )
	retryButton:SetStringProperty( "TopImage", "Assets/Images/Retry Button.png" )
	retryButton:SetOnSelectLuaFunction( "RetryFunc" )
	
	tweetButton:SetFrame( TweetHiddenPos() )
	tweetButton:SetFrame( TweetVisiblePos(), 0.23 )
	tweetButton:SetStringProperty( "BackgroundImage", "Assets/Images/ShareBackground.png" )
	tweetButton:SetStringProperty( "TopImage", "Assets/Images/Share Button.png" )
	tweetButton:SetOnSelectLuaFunction( "TweetFunc" )
	
	gameCenterButton:SetFrame( GameCenterHiddenPos() )
	gameCenterButton:SetFrame( GameCenterVisiblePos(), 0.27 )
	gameCenterButton:SetStringProperty( "BackgroundImage", "Assets/Images/Game Center.png" )
	gameCenterButton:SetOnSelectLuaFunction( "GameCenterFunc" )
end

function FailThread()
	FCLog("FailThread")
	scoreLabel:SetIntegerProperty( "showBar", 0 )
	SetPlayButtonsInteractive( 0 )
	Silence()
	PlayFailSFX()

	FCNewThread( FlashRedThread )
	-- play sound
	TurnAllButtonsOff()
	scoreLabel:SetFrame( ScoreCentralPos(), 0.5 )
	quitButton:SetFrame( QuitButtonHiddenPos(), 0.2 )
	clockView:SetFrame( ClockHiddenPos() )
	GameHideAllButtons()
	ShowEndGameButtons()
	UpdateHighScore()
end

function GameWinThread()
	FCAnalytics.RegisterEvent( "Game Win" )
	FCLog("GAME WIN!")
	scoreLabel:SetIntegerProperty( "showBar", 0 )
	SetPlayButtonsInteractive( 0 )
	FCAudio.SourceSetVolume( source1, 0 )
	FCAudio.SourceSetVolume( source2, 0 )
	FCAudio.SourceSetVolume( source3, 0 )
	FCAudio.SourceSetVolume( source4, 0 )
	FCAudio.SourceSetVolume( source5, 0 )
	FCAudio.SourceSetVolume( source6, 0 )
	PlayWinSFX()
	TurnAllButtonsOff()
	quitButton:SetFrame( QuitButtonHiddenPos(), 0.2 )
	clockView:SetFrame( ClockHiddenPos() )
	GameHideAllButtons()
	ShowEndGameButtons()
	UpdateHighScore()
	FCWait( 1 )
	scoreLabel:SetFrame( ScoreCentralPos(), 0.5 )
end

function ScoreThread( active )
	while true do
		SetScore( math.floor( bank ), math.floor( roundScore ) )
		FCWait( 1 / 4 )
		roundScore = roundScore * 0.95
	end
end

function KillScoreThread()
	if scoreThread then
		FCKillThread( scoreThread )
		scoreThread = nil
	end
end

function BankScore()
	bank = bank + roundScore
	roundScore = 0
end

function SetCurrentGamePhase( phase )
	currentGamePhase = phase

	if currentGamePhase == kGamePhaseInit then
		SetPlayButtonsInteractive( 0 )
		sequence = nil
		bank = 0
		roundScore = 0
		roundScoreMax = 0
		score = 0
	elseif currentGamePhase == kGamePhaseCompTurn then		
		BankScore()
		SetScore( math.floor( bank ), 0 )
		KillScoreThread()
		SetPlayButtonsInteractive( 0 )
		if sequence == nil then
			sequence = {}
		end
		GameAddToSequence()
		compTurnThread = FCNewThread( CompTurnThread, "comp turn" )
	elseif currentGamePhase == kGamePhaseUserTurn then
		roundScore = GameScoreWeight() * #sequence
		roundScoreMax = roundScore
		scoreThread = FCNewThread( ScoreThread )
		SetPlayButtonsInteractive( 1 )
		currentSequenceIndex = 1
		GameUserTurn()
	elseif currentGamePhase == kGamePhaseNextRound then
		BankScore()
		KillScoreThread()
	elseif currentGamePhase == kGamePhaseFail then
		roundScore = 0
		KillScoreThread()
		SetScore( math.floor( bank ), 0 )
		FCNewThread( FailThread )
	elseif currentGamePhase == kGamePhaseSuccess then
		KillScoreThread()
		PlayYaySFX()
	end
end

function PrintSequence()
	FCLog("Sequence now...")
	for i = 0, #sequence do
		if sequence[i] == kRedPlayButton then FCLog("red") end
		if sequence[i] == kGreenPlayButton then FCLog("green") end
		if sequence[i] == kYellowPlayButton then FCLog("yellow") end
		if sequence[i] == kBluePlayButton then FCLog("blue") end
		if sequence[i] == kMagentaPlayButton then FCLog("magenta") end
		if sequence[i] == kCyanPlayButton then FCLog("cyan") end
	end
end

------------------------------------------------------------------------------------------

function QuitButtonPressed()
	FCAnalytics.RegisterEvent( "Pressed Quit" )
	Silence()
	PlayClickSFX()
	FCLog("Quit pressed")
	if compTurnThread ~= nil then
		FCKillThread( compTurnThread )
		compTurnThread = nil
	end
	scoreLabel:SetAlpha(0)
	highScoreLabel:SetAlpha( 0 )
	FCPhaseManager.AddPhaseToQueue( "FrontEnd" )
	FCPhaseManager.DeactivatePhase( "Game" )
end

function PlayButtonFromString( name )
	if name == "redPlayButton" then
		return kRedPlayButton
	elseif name == "bluePlayButton" then
		return kBluePlayButton
	elseif name == "greenPlayButton" then
		return kGreenPlayButton
	elseif name == "yellowPlayButton" then
		return kYellowPlayButton
	elseif name == "cyanPlayButton" then
		return kCyanPlayButton
	else
		return kMagentaPlayButton
	end
end

------------------------------------------------------------------------------------------

function PlayButtonDown( name )
	pressedButton = PlayButtonFromString( name )
	
	Tone( pressedButton, 1 )
	
	if GameButtonDown( pressedButton ) == false then
		FCLog("FAIL")
		SetCurrentGamePhase( kGamePhaseFail )
	end		
end

function PlayButtonUp( name )

	pressedButton = PlayButtonFromString( name )	

	Tone( pressedButton, 0 )
	
	if GameButtonUp( pressedButton ) then
		FCLog("SUCCESS")
		if currentSequenceIndex == #sequence then
			-- end of round
			PlayWinSFX()

			if #sequence == kMaxRounds then
				FCNewThread( GameWinThread )
				SetCurrentGamePhase( kGamePhaseSuccess )
			else
				FCNewThread( FlashGreenThread )
				SetCurrentGamePhase( kGamePhaseCompTurn )
			end
		else
			currentSequenceIndex = currentSequenceIndex + 1
		end
	end
end

------------------------------------------------------------------------------------------

GamePhase = {}

function GamePhase.WillActivate()
	FCLog("GamePhase.WillActivate")
end

function InitGame()
	FCLog("Init Game")

	TurnAllButtonsOff()

	quitButton:SetBackgroundColor( kClearColor )
	quitButton:SetAlpha( 1.0 )
	quitButton:SetFrame( QuitButtonHiddenPos() )
	quitButton:SetFrame( QuitButtonVisiblePos(), 0.2 )
	quitButton:SetOnSelectLuaFunction( "QuitButtonPressed" )
	quitButton:SetStringProperty( "BackgroundImage", "Assets/Images/BackBackground.png" )
	quitButton:SetStringProperty( "TopImage", "Assets/Images/Back Button.png" )

	scoreLabel:SetAlpha( 1.0 )
	scoreLabel:SetFrame( ScoreHiddenPos() )
	scoreLabel:SetFrame( ScoreVisiblePos(), 0.2 )
	
	scoreLabel:SetIntegerProperty( "showBar", 1 )
	
	clockView:SetFrame( ClockHiddenPos() )
	clockView:SetFrame( ClockVisiblePos(), 0.2 )
	
	gameType = GameAppDelegate.GameType()
	
	-- clear the game functions
	
	GameSetup = nil
	GameAddToSequence = nil
	GameDisplaySequenceColorsAtIndex = nil
	GameCompTurn = nil
	GameUserTurn = nil
	GameNextTurn = nil
	GameShutdown = nil
	GameHideAllButtons = nil
	
	if gameType == kClassicGame then
		FCLog("Classic game");
		FCLoadScript("classic")
	end
	if gameType == kSixGame then
		FCLog("Six game");
		FCLoadScript("six")
	end
	if gameType == kShuffleGame then
		FCLog("Shuffle game");
		FCLoadScript("shuffle")
	end
	if gameType == kMultiGame then
		FCLog("Multi game");
		FCLoadScript("multi")
	end
	if gameType == kMadnessGame then
		FCLog("Madness game");
		FCLoadScript("madness")
	end	

	redPlayButton:SetStringProperty( "onTouchBeganLuaFunction", "PlayButtonDown" )
	redPlayButton:SetStringProperty( "onTouchEndedLuaFunction", "PlayButtonUp" )

	bluePlayButton:SetStringProperty( "onTouchBeganLuaFunction", "PlayButtonDown" )
	bluePlayButton:SetStringProperty( "onTouchEndedLuaFunction", "PlayButtonUp" )

	greenPlayButton:SetStringProperty( "onTouchBeganLuaFunction", "PlayButtonDown" )
	greenPlayButton:SetStringProperty( "onTouchEndedLuaFunction", "PlayButtonUp" )

	yellowPlayButton:SetStringProperty( "onTouchBeganLuaFunction", "PlayButtonDown" )
	yellowPlayButton:SetStringProperty( "onTouchEndedLuaFunction", "PlayButtonUp" )

	cyanPlayButton:SetStringProperty( "onTouchBeganLuaFunction", "PlayButtonDown" )
	cyanPlayButton:SetStringProperty( "onTouchEndedLuaFunction", "PlayButtonUp" )

	magentaPlayButton:SetStringProperty( "onTouchBeganLuaFunction", "PlayButtonDown" )
	magentaPlayButton:SetStringProperty( "onTouchEndedLuaFunction", "PlayButtonUp" )

	GameSetup()
	
	SetCurrentGamePhase( kGamePhaseInit )
	SetCurrentGamePhase( kGamePhaseCompTurn )
	
	SetScore( 0, 0 )
end

function GamePhase.IsNowActive()
	FCLog("GamePhase.IsNowActive")

	InitGame();	
end

function GamePhase.WillDeactivate()
	FCLog("GamePhase.WillDeactivate")

	highScoreLabel:SetAlpha( 0 )

	quitButton:SetFrame( QuitButtonHiddenPos(), 0.2 )
	scoreLabel:SetFrame( ScoreHiddenPos(), 0.2 )
	
	backButton:SetFrame( BackHiddenPos(), 0.2 )
	retryButton:SetFrame( RetryHiddenPos(), 0.2 )
	tweetButton:SetFrame( TweetHiddenPos(), 0.2 )
	gameCenterButton:SetFrame( GameCenterHiddenPos(), 0.2 )
	clockView:SetFrame( ClockHiddenPos(), 0.2 )
	
	GameShutdown()
end

function GamePhase.IsNowDeactive()
	FCLog("GamePhase.IsNowDeactive")
end

function GamePhase.Update()
end
