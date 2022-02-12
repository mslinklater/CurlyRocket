-- Shuffle

kMaxRounds = 64

hidePositions = {}

--

function GameSetup()
	FCAnalytics.RegisterEvent( "Play shuffle" )
	
	greenPlayButton:SetFrame( GreenHiddenPos())
	greenPlayButton:SetFrame( GreenVisiblePos(), 0.2)
	hidePositions[ kGreenPlayButton ] = GreenHiddenPos()

	redPlayButton:SetFrame( RedHiddenPos() )
	redPlayButton:SetFrame( RedVisiblePos(), 0.2)
	hidePositions[ kRedPlayButton ] = RedHiddenPos()

	yellowPlayButton:SetFrame( YellowHiddenPos() )
	yellowPlayButton:SetFrame( YellowVisiblePos(), 0.3)
	hidePositions[ kYellowPlayButton ] = YellowHiddenPos()

	bluePlayButton:SetFrame( BlueHiddenPos() )
	bluePlayButton:SetFrame( BlueVisiblePos(), 0.3)
	hidePositions[ kBluePlayButton ] = BlueHiddenPos()

	randomGenerator = FCRandom.New()
end

function GameScoreWeight()
	return 200
end

function GameGetHighScoreName()
	return kGameHighScoreShuffle
end

function GameOnlineLeaderboardName()
	return "com.curlyrocket.CR2.shuffle"
end

function GameLightsOnTime( percentThrough )
	return 0.5 - (0.3 * percentThrough)
end

function GameLightsOffTime( percentThrough )
	return 0.1 - (0.05 * percentThrough)
end

frames = {}
frames[ kRedPlayButton ] = "redPlayButton"
frames[ kGreenPlayButton ] = "greenPlayButton"
frames[ kBluePlayButton ] = "bluePlayButton"
frames[ kYellowPlayButton ] = "yellowPlayButton"

function Shuffle()
	FCLog("Shuffling")

	buttonOne = (randomGenerator:Get() % 4) + 1
	buttonTwo = buttonOne

	while buttonOne == buttonTwo do
		buttonTwo = (randomGenerator:Get() % 4) + 1
	end

	temp = hidePositions[ buttonOne ]
	hidePositions[ buttonOne ] = hidePositions[ buttonTwo ]
	hidePositions[ buttonTwo ] = temp

	temp = FCViewManager.GetFrame( frames[ buttonOne ] )
	FCViewManager.SetFrame( frames[buttonOne], FCViewManager.GetFrame(frames[buttonTwo]), 0.5 )
	FCViewManager.SetFrame( frames[buttonTwo], temp, 0.5 )
end

function GameAddToSequence()
	number = randomGenerator:Get()
	which = number % 4
	sequence[#sequence + 1] = kRedPlayButton + which
end

function GameHideAllButtons()
	greenPlayButton:SetFrame( hidePositions[ kGreenPlayButton ], 0.2)
	redPlayButton:SetFrame( hidePositions[ kRedPlayButton ], 0.2)
	yellowPlayButton:SetFrame( hidePositions[ kYellowPlayButton ], 0.2)
	bluePlayButton:SetFrame( hidePositions[ kBluePlayButton ], 0.2)
end

function GameDisplaySequenceColorsAtIndex( index, state )
	color = sequence[ index ]
	if color == kRedPlayButton then
		redPlayButton:SetIntegerProperty( "pressed", state )
	end
	if color == kGreenPlayButton then
		greenPlayButton:SetIntegerProperty( "pressed", state )
	end
	if color == kBluePlayButton then
		bluePlayButton:SetIntegerProperty( "pressed", state )
	end
	if color == kYellowPlayButton then
		yellowPlayButton:SetIntegerProperty( "pressed", state )
	end
	
	Tone( color, state )
end

function GameButtonDown( pressedButton )
	if pressedButton == sequence[ currentSequenceIndex ] then
		return true
	else
		return false
	end
end

function GameButtonUp( pressedButton )
	if pressedButton == sequence[ currentSequenceIndex ] then
		return true
	else
		return false
	end
end

function GameCompTurn()
	FCLog("Shuffle GameCompTurn")
end

function GameUserTurn()
	FCLog("Shuffle GameUserTurn")
	Shuffle()
end

function GameNextTurn()
	FCLog("Shuffle GameNextTurn")
end

function GameShutdown()
	-- TODO - need to move the colors to where they are actually located
	
	greenPlayButton:SetFrame( hidePositions[ kGreenPlayButton ], 0.2)
	redPlayButton:SetFrame( hidePositions[ kRedPlayButton ], 0.2)
	bluePlayButton:SetFrame( hidePositions[ kBluePlayButton ], 0.3)
	yellowPlayButton:SetFrame( hidePositions[ kYellowPlayButton ], 0.3)
	
	FCLog("Shuffle GameShutdown")
end