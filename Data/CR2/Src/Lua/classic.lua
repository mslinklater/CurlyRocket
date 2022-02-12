-- Classic 

kMaxRounds = 64

function GameSetup()
	FCAnalytics.RegisterEvent( "Play classic" )
	
	greenPlayButton:SetFrame( GreenHiddenPos())
	greenPlayButton:SetFrame( GreenVisiblePos(), 0.2)

	redPlayButton:SetFrame( RedHiddenPos() )
	redPlayButton:SetFrame( RedVisiblePos(), 0.2)

	yellowPlayButton:SetFrame( YellowHiddenPos() )
	yellowPlayButton:SetFrame( YellowVisiblePos(), 0.25)

	bluePlayButton:SetFrame( BlueHiddenPos() )
	bluePlayButton:SetFrame( BlueVisiblePos(), 0.25)
	
	randomGenerator = FCRandom.New()
end

function GameScoreWeight()
	return 100
end

function GameGetHighScoreName()
	return kGameHighScoreClassic
end

function GameOnlineLeaderboardName()
	return "com.curlyrocket.CR2.classic"
end

function GameLightsOnTime( percentThrough )
	return 0.5 - (0.3 * percentThrough)
end

function GameLightsOffTime( percentThrough )
	return 0.1 - (0.05 * percentThrough)
end

function GameHideAllButtons()
	greenPlayButton:SetFrame( GreenHiddenPos(), 0.2)
	redPlayButton:SetFrame( RedHiddenPos(), 0.2)
	yellowPlayButton:SetFrame( YellowHiddenPos(), 0.2)
	bluePlayButton:SetFrame( BlueHiddenPos(), 0.2)
end

function GameAddToSequence()
	number = randomGenerator:Get()
	which = number % 4
	sequence[#sequence + 1] = kRedPlayButton + which
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
	FCLog("Classic GameCompTurn")
end

function GameUserTurn()
	FCLog("Classic GameUserTurn")
end

function GameNextTurn()
	FCLog("Classic GameNextTurn")
end

function GameShutdown()
	greenPlayButton:SetFrame( GreenHiddenPos(), 0.2)
	redPlayButton:SetFrame( RedHiddenPos(), 0.2)
	bluePlayButton:SetFrame( BlueHiddenPos(), 0.25)
	yellowPlayButton:SetFrame( YellowHiddenPos(), 0.25)
	
	FCLog("Classic GameShutdown")
end