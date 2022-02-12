-- Madness

kNumRepeats = 3
kMaxRounds = 64

function GameSetup()
	FCAnalytics.RegisterEvent( "Play madness" )

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
	return 300
end

function GameGetHighScoreName()
	return kGameHighScoreMadness
end

function GameOnlineLeaderboardName()
	return "com.curlyrocket.CR2.madness"
end

function GameLightsOnTime( percentThrough )
	return 0.2 - (0.05 * percentThrough)
end

function GameLightsOffTime( percentThrough )
	return 0.1 - (0.025 * percentThrough)
end

function GameAddToSequence()
	roundNum = #sequence / kNumRepeats
	
	lastColor = sequence[ #sequence ]
	newColor = lastColor
	
	while lastColor == newColor do
		newColor = kRedPlayButton + ( randomGenerator:Get() % 4 )
	end
	
	if roundNum == 0 then
		for i = 1, kNumRepeats do
			sequence[ #sequence + 1 ] = newColor
		end
	else
		local newSequence = {}
		for iRepeat = 1, kNumRepeats do
			for iColor = 1, (#sequence) / kNumRepeats do
				newSequence[ #newSequence + 1 ] = sequence[ iColor ]
			end
			newSequence[ #newSequence + 1 ] = newColor
		end
		sequence = newSequence
	end	
end

function GameHideAllButtons()
	greenPlayButton:SetFrame( GreenHiddenPos(), 0.2)
	redPlayButton:SetFrame( RedHiddenPos(), 0.2)
	yellowPlayButton:SetFrame( YellowHiddenPos(), 0.2)
	bluePlayButton:SetFrame( BlueHiddenPos(), 0.2)
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
	FCLog("Madness GameCompTurn")
end

function GameUserTurn()
	FCLog("Madness GameUserTurn")
end

function GameNextTurn()
	FCLog("Madness GameNextTurn")
end

function GameShutdown()
	greenPlayButton:SetFrame( GreenHiddenPos(), 0.2)
	redPlayButton:SetFrame( RedHiddenPos(), 0.2)
	bluePlayButton:SetFrame( BlueHiddenPos(), 0.25)
	yellowPlayButton:SetFrame( YellowHiddenPos(), 0.25)
end
