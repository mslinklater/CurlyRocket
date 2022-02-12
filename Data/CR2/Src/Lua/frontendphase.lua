
function DisableAllStartButtons()
	classicButton:SetOnSelectLuaFunction( nil )
	sixButton:SetOnSelectLuaFunction( nil )
	shuffleButton:SetOnSelectLuaFunction( nil )
	multiButton:SetOnSelectLuaFunction(nil)
	madnessButton:SetOnSelectLuaFunction(nil)
end

function MakeButtonsDisappear()
	titleLabel:SetFrame( TitleHiddenPos(), 0.5 )
	classicButton:SetFrame( ClassicButtonHiddenPos(), 0.1 )
	sixButton:SetFrame( SixButtonHiddenPos(), 0.2 )
	shuffleButton:SetFrame( ShuffleButtonHiddenPos(), 0.3 )
	multiButton:SetFrame( MultiButtonHiddenPos(), 0.4 )
	madnessButton:SetFrame( MadnessButtonHiddenPos(), 0.5 )
end

-------------------------------------------------------

function StartGameThread()

	-- kill the button threads

	if titleLabelThread then
		FCKillThread( titleLabelThread )
		titleLabelThread= nil
	end

	if classicButtonThread then
		FCKillThread( classicButtonThread )
		classicButtonThread= nil
	end

	if sixButtonThread then
		FCKillThread( sixButtonThread )
		sixButtonThread= nil
	end

	if shuffleButtonThread then
		FCKillThread( shuffleButtonThread )
		shuffleButtonThread= nil
	end

	if multiButtonThread then
		FCKillThread( multiButtonThread )
		multiButtonThread= nil
	end

	if madnessButtonThread then
		FCKillThread( madnessButtonThread )
		madnessButtonThread= nil
	end
	
	PlayClickSFX()
	MakeButtonsDisappear()
	FCWait( 0.2 )
	FCPhaseManager.AddPhaseToQueue( "Game" )
	FCPhaseManager.DeactivatePhase( "FrontEnd" )
end

function StartClassicGame()
	FCLog("Starting classic game")
	DisableAllStartButtons()
	GameAppDelegate.SetGameType( kClassicGame )
	FCNewThread( StartGameThread, "start game" )
end

function StartSixGame()
	FCLog("Starting six game")
	DisableAllStartButtons()
	GameAppDelegate.SetGameType( kSixGame )
	FCNewThread( StartGameThread, "start game" )
end

function StartShuffleGame()
	FCLog("Starting shuffle game")
	DisableAllStartButtons()
	GameAppDelegate.SetGameType( kShuffleGame )
	FCNewThread( StartGameThread, "start game" )
end

function StartMultiGame()
	FCLog("Starting multi game")
	DisableAllStartButtons()
	GameAppDelegate.SetGameType( kMultiGame )
	FCNewThread( StartGameThread, "start game" )
end

function StartMadnessGame()
	FCLog("Starting madness game")
	DisableAllStartButtons()
	GameAppDelegate.SetGameType( kMadnessGame )
	FCNewThread( StartGameThread, "start game" )
end

-------------------------------------------------------

function TitleLabelThread()
	while true do
		titleLabel:SetText( kText_GameTitle )
		titleLabel:SetAlpha( 1, 0.2 )
		FCWait( 10 )
		
		titleLabel:SetAlpha( 0, 0.2 )
		FCWait( 0.2 )
		titleLabel:SetText( kText_CreatedBy )
		titleLabel:SetAlpha( 1, 0.2 )
		
		FCWait( 1 )
		
		titleLabel:SetAlpha( 0, 0.2 )
		FCWait( 0.2 )
		titleLabel:SetText( "@curlyrocketltd" )
		titleLabel:SetAlpha( 1, 0.2 )
		
		FCWait( 2 )
		titleLabel:SetAlpha( 0, 0.2 )
		FCWait( 0.2 )
	end
end

function ShuffleButton( button )
	FCWait( 1.4 )
	frame = button:GetFrame()
	frame[1] = frame[1] + 0.01
	button:SetFrame( frame, 0.2 )
	FCWait( 0.2 )
	frame[1] = frame[1] - 0.02
	button:SetFrame( frame, 0.2 )
	FCWait( 0.2 )
	frame[1] = frame[1] + 0.01
	button:SetFrame( frame, 0.2 )
	FCWait( 0.2 )
end

function ClassicButtonThread()
	local highScore = FCPersistentData.GetNumber( kGameHighScoreClassic )
	
	while true do
		if highScore > 0 then
			classicButton:SetText( kText_Score .. tostring(highScore) )
			FCWait( 2 )
		else
			classicButton:SetText( kText_TryMe )
			ShuffleButton( classicButton )
		end
		FCWait( 8 )
	end
end

function SixButtonThread()
	local highScore = FCPersistentData.GetNumber( kGameHighScoreSix )
	
	while true do
		FCWait( 2 )
		if highScore > 0 then
			sixButton:SetText( kText_Score .. tostring(highScore) )
			FCWait( 2 )
		else
			sixButton:SetText( kText_TryMe )
			ShuffleButton( sixButton )
		end
		FCWait( 6 )
	end
end

function ShuffleButtonThread()
	local highScore = FCPersistentData.GetNumber( kGameHighScoreShuffle )
	
	while true do
		FCWait( 4 )
		if highScore > 0 then
			shuffleButton:SetText( kText_Score .. tostring(highScore) )
			FCWait( 2 )
		else
			shuffleButton:SetText( kText_TryMe )
			ShuffleButton( shuffleButton )
		end
		FCWait( 4 )
	end
end

function MultiButtonThread()
	local highScore = FCPersistentData.GetNumber( kGameHighScoreMulti )
	
	while true do
		FCWait( 6 )
		if highScore > 0 then
			multiButton:SetText( kText_Score .. tostring(highScore) )
			FCWait( 2 )
		else
			multiButton:SetText( kText_TryMe )
			ShuffleButton( multiButton )
		end
		FCWait( 2 )
	end
end

function MadnessButtonThread()
	local highScore = FCPersistentData.GetNumber( kGameHighScoreMadness )
	
	while true do
		FCWait( 8 )
		if highScore > 0 then
			madnessButton:SetText( kText_Score .. tostring(highScore) )
			FCWait( 2 )
		else
			madnessButton:SetText( kText_TryMe )
			ShuffleButton( madnessButton )
		end
	end
end

-------------------------------------------------------

FrontEndPhase = {}

function FrontEndPhase.WillActivate()

	local kIntensity = 0.75

	FCLog("FrontEndPhase.WillActivate")
	
	titleLabel:SetFrame( TitleHiddenPos(), 0 )
	titleLabel:SetFrame( TitleVisiblePos(), 0.5)
	titleLabel:SetText( kText_GameTitle )	
	
	classicButton:SetFrame( ClassicButtonHiddenPos() )
	classicButton:SetFrame( ClassicButtonVisiblePos(), 0.1)
	classicButton:SetStringProperty( "topImageFilename", "Assets/Images/ClassicIcon.png" )
	classicButton:SetStringProperty( "backgroundImageFilename", "Assets/Images/MenuButtonRed.png" )
	classicButton:SetAlpha( 1.0 )
	classicButton:SetOnSelectLuaFunction( "StartClassicGame" )

	sixButton:SetFrame( SixButtonHiddenPos() )
	sixButton:SetFrame( SixButtonVisiblePos(), 0.2 )
	sixButton:SetAlpha( 1.0 )
	sixButton:SetStringProperty( "topImageFilename", "Assets/Images/SixIcon.png" )
	sixButton:SetStringProperty( "backgroundImageFilename", "Assets/Images/MenuButtonGreen.png" )
	sixButton:SetOnSelectLuaFunction( "StartSixGame" )

	shuffleButton:SetFrame( ShuffleButtonHiddenPos())
	shuffleButton:SetFrame( ShuffleButtonVisiblePos() , 0.3)
	shuffleButton:SetAlpha( 1.0 )
	shuffleButton:SetStringProperty( "topImageFilename", "Assets/Images/ShuffleIcon.png" )
	shuffleButton:SetStringProperty( "backgroundImageFilename", "Assets/Images/MenuButtonBlue.png" )
	shuffleButton:SetOnSelectLuaFunction( "StartShuffleGame" )

	multiButton:SetFrame( MultiButtonHiddenPos() )
	multiButton:SetFrame( MultiButtonVisiblePos(), 0.4)
	multiButton:SetAlpha( 1.0 )
	multiButton:SetStringProperty( "topImageFilename", "Assets/Images/MultiIcon.png" )
	multiButton:SetStringProperty( "backgroundImageFilename", "Assets/Images/MenuButtonYellow.png" )
	multiButton:SetOnSelectLuaFunction( "StartMultiGame" )

	madnessButton:SetFrame( MadnessButtonHiddenPos() )
	madnessButton:SetFrame( MadnessButtonVisiblePos(), 0.5)
	madnessButton:SetAlpha( 1.0 )
	madnessButton:SetStringProperty( "topImageFilename", "Assets/Images/MadnessIcon.png" )
	madnessButton:SetStringProperty( "backgroundImageFilename", "Assets/Images/MenuButtonMagenta.png" )
	madnessButton:SetOnSelectLuaFunction( "StartMadnessGame" )
	
	-- kick off animation threads
	
	classicButton:SetText( "" )
	sixButton:SetText( "" )
	shuffleButton:SetText( "" )
	multiButton:SetText( "" )
	madnessButton:SetText( "" )
	
	titleLabelThread = FCNewThread( TitleLabelThread )
	classicButtonThread = FCNewThread( ClassicButtonThread )
	sixButtonThread = FCNewThread( SixButtonThread )
	shuffleButtonThread = FCNewThread( ShuffleButtonThread )
	multiButtonThread = FCNewThread( MultiButtonThread )
	madnessButtonThread = FCNewThread( MadnessButtonThread )
	
end

function FrontEndPhase.IsNowActive()
	FCLog("FrontEndPhase.IsNowActive")
end

function FrontEndPhase.WillDeactivate()
	FCLog("FrontEndPhase.WillDeactivate")
end

function FrontEndPhase.IsNowDeactive()
	FCLog("FrontEndPhase.IsNowDeactive")
end

function FrontEndPhase.Update()
end

