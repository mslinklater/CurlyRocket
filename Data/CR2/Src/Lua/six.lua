-- Six

kMaxRounds = 64

--

function GameSetup()
	FCAnalytics.RegisterEvent( "Play six" )
	
	greenPlayButton:SetFrame( GreenHiddenPos())
	greenPlayButton:SetFrame( GreenVisiblePos(), 0.2)

	redPlayButton:SetFrame( RedHiddenPos() )
	redPlayButton:SetFrame( RedVisiblePos(), 0.2)

	cyanPlayButton:SetFrame( CyanHiddenPos() )
	cyanPlayButton:SetFrame( CyanVisiblePos(), 0.25)

	magentaPlayButton:SetFrame( MagentaHiddenPos() )
	magentaPlayButton:SetFrame( MagentaVisiblePos() , 0.25)
	
	yellowPlayButton:SetFrame( YellowHiddenPos() )
	yellowPlayButton:SetFrame( YellowVisiblePos(), 0.3)

	bluePlayButton:SetFrame( BlueHiddenPos() )
	bluePlayButton:SetFrame( BlueVisiblePos(), 0.3)
	
	randomGenerator = FCRandom.New()

end

function GameScoreWeight()
	return 100
end

function GameGetHighScoreName()
	return kGameHighScoreSix
end

function GameOnlineLeaderboardName()
	return "com.curlyrocket.CR2.six"
end

function GameLightsOnTime( percentThrough )
	return 0.5 - (0.3 * percentThrough)
end

function GameLightsOffTime( percentThrough )
	return 0.1 - (0.05 * percentThrough)
end

function GameAddToSequence()
	number = randomGenerator:Get()
	which = number % 6
	sequence[#sequence + 1] = kRedPlayButton + which
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

function GameHideAllButtons()
	greenPlayButton:SetFrame( GreenHiddenPos(), 0.2)
	redPlayButton:SetFrame( RedHiddenPos(), 0.2)
	yellowPlayButton:SetFrame( YellowHiddenPos(), 0.2)
	bluePlayButton:SetFrame( BlueHiddenPos(), 0.2)
	cyanPlayButton:SetFrame( CyanHiddenPos(), 0.2)
	magentaPlayButton:SetFrame( MagentaHiddenPos(), 0.2)
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
	if color == kCyanPlayButton then
		cyanPlayButton:SetIntegerProperty( "pressed", state )
	end
	if color == kMagentaPlayButton then
		magentaPlayButton:SetIntegerProperty( "pressed", state )
	end
	Tone( color, state )

end

function GameCompTurn()
	FCLog("Six GameCompTurn")
end

function GameUserTurn()
	FCLog("Six GameUserTurn")
end

function GameNextTurn()
	FCLog("Six GameNextTurn")
end

function GameShutdown()
	greenPlayButton:SetFrame( GreenHiddenPos(), 0.2)
	redPlayButton:SetFrame( RedHiddenPos(), 0.2)
	cyanPlayButton:SetFrame( CyanHiddenPos(), 0.25)
	magentaPlayButton:SetFrame( MagentaHiddenPos(), 0.25)
	bluePlayButton:SetFrame( BlueHiddenPos(), 0.3)
	yellowPlayButton:SetFrame( YellowHiddenPos(), 0.3)
	
	FCLog("Six GameShutdown")
end