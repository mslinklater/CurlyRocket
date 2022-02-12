-- Multi

kMaxRounds = 64

--

function GameSetup()
	FCAnalytics.RegisterEvent( "Play multi" )
	
	greenPlayButton:SetFrame( GreenHiddenPos())
	greenPlayButton:SetFrame( GreenVisiblePos(), 0.2)

	redPlayButton:SetFrame( RedHiddenPos() )
	redPlayButton:SetFrame( RedVisiblePos(), 0.2)

	yellowPlayButton:SetFrame( YellowHiddenPos() )
	yellowPlayButton:SetFrame( YellowVisiblePos(), 0.25)

	bluePlayButton:SetFrame( BlueHiddenPos() )
	bluePlayButton:SetFrame( BlueVisiblePos(), 0.25)
	
	randomGenerator = FCRandom.New()
	numButtonsPressed = 0
end

function GameScoreWeight()
	return 200
end

function GameGetHighScoreName()
	return kGameHighScoreMulti
end

function GameOnlineLeaderboardName()
	return "com.curlyrocket.CR2.multi"
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
	first = kRedPlayButton + (randomGenerator:Get() % 4)
	second = first
	
	while first == second do
		second = kRedPlayButton + (randomGenerator:Get() % 4)
	end
	sequence[#sequence + 1] = {}
	sequence[#sequence][1] = first
	sequence[#sequence][2] = second
end

function GameDisplaySequenceColorsAtIndex( index, state )
	for which = 1,2 do
		color = sequence[ index ][which]
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
end

function GameButtonDown( pressedButton )
	first = sequence[ currentSequenceIndex ][ 1 ]
	second = sequence[ currentSequenceIndex ][ 2 ]
	
	if ( pressedButton == first ) or ( pressedButton == second ) then
		numButtonsPressed = numButtonsPressed + 1
		if numButtonsPressed == 2 then
			correct = true
		end
		return true
	else
		return false
	end
end

function GameButtonUp( pressedButton )
	numButtonsPressed = numButtonsPressed - 1
	
	if numButtonsPressed == 0 then
		return correct
	else
		return false
	end
end

function GameCompTurn()
	FCLog("Multi GameCompTurn")
end

function GameUserTurn()
	FCLog("Multi GameUserTurn")
	correct = false
end

function GameNextTurn()
	FCLog("Multi GameNextTurn")
end

function GameShutdown()
	greenPlayButton:SetFrame( GreenHiddenPos(), 0.2)
	redPlayButton:SetFrame( RedHiddenPos(), 0.2)
	bluePlayButton:SetFrame( BlueHiddenPos(), 0.25)
	yellowPlayButton:SetFrame( YellowHiddenPos(), 0.25)
	
	FCLog("Multi GameShutdown")
end
