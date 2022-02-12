-- main.lua

FCLoadScript( "globals" )

FCLoadScript( "Languages/en" )

-- Language word tables
locale = FCDevice.GetString("locale")
FCLog( "Found locale " .. locale )
FCLoadScriptOptional( "Languages/" .. locale )

FCLoadScript( "frontendphase" )
FCLoadScript( "gamephase" )

screenWidth = FCDevice.GetInteger( kFCDeviceDisplayLogicalXRes )
screenHeight = FCDevice.GetInteger( kFCDeviceDisplayLogicalYRes )

FCLoadScript( "layout_global" )

if ( screenWidth == 768 ) and ( screenHeight == 1024 ) then
	FCLog("Loading iPad layout")
	FCLoadScript( "layout_ipad" )
else
	FCLog("Loading iPhone layout")
	FCLoadScript( "layout_iphone" )	-- defaults to iPhone 
end

------------------------------------------------------------------------------------------

function PlayFailSFX()
	FCAudio.SourcePlay( failSource )
end
function PlayWinSFX()
	FCAudio.SourcePlay( winSource )
end
function PlayClickSFX()
	FCAudio.SourcePlay( clickSource )
end
function PlayYaySFX()
	FCAudio.SourcePlay( yaySource )
end

local function InitialiseAudio()
	tone1 = FCAudio.CreateBuffer("Assets/Audio/1")
	tone2 = FCAudio.CreateBuffer("Assets/Audio/2")
	tone3 = FCAudio.CreateBuffer("Assets/Audio/3")
	tone4 = FCAudio.CreateBuffer("Assets/Audio/4")
	tone5 = FCAudio.CreateBuffer("Assets/Audio/5")
	tone6 = FCAudio.CreateBuffer("Assets/Audio/6")
	failBuffer = FCAudio.CreateBuffer("Assets/Audio/fail")
	winBuffer = FCAudio.CreateBuffer("Assets/Audio/win")
	clickBuffer = FCAudio.CreateBuffer("Assets/Audio/click")
	yayBuffer = FCAudio.CreateBuffer("Assets/Audio/yay")
	
	source1 = FCAudio.PrepareSourceWithBuffer( tone1, true )
	source2 = FCAudio.PrepareSourceWithBuffer( tone2, true )
	source3 = FCAudio.PrepareSourceWithBuffer( tone3, true )
	source4 = FCAudio.PrepareSourceWithBuffer( tone4, true )
	source5 = FCAudio.PrepareSourceWithBuffer( tone5, true )
	source6 = FCAudio.PrepareSourceWithBuffer( tone6, true )

	failSource = FCAudio.PrepareSourceWithBuffer( failBuffer, true )
	winSource = FCAudio.PrepareSourceWithBuffer( winBuffer, true )
	clickSource = FCAudio.PrepareSourceWithBuffer( clickBuffer, true )
	yaySource = FCAudio.PrepareSourceWithBuffer( yayBuffer, true )
	
	FCAudio.SourceLooping( source1, true )
	FCAudio.SourceLooping( source2, true )
	FCAudio.SourceLooping( source3, true )
	FCAudio.SourceLooping( source4, true )
	FCAudio.SourceLooping( source5, true )
	FCAudio.SourceLooping( source6, true )
	
	FCAudio.SourceSetVolume( source1, 0 )	
	FCAudio.SourcePlay( source1 )

	FCAudio.SourceSetVolume( source2, 0 )	
	FCAudio.SourcePlay( source2 )

	FCAudio.SourceSetVolume( source3, 0 )	
	FCAudio.SourcePlay( source3 )

	FCAudio.SourceSetVolume( source4, 0 )	
	FCAudio.SourcePlay( source4 )

	FCAudio.SourceSetVolume( source5, 0 )	
	FCAudio.SourcePlay( source5 )

	FCAudio.SourceSetVolume( source6, 0 )	
	FCAudio.SourcePlay( source6 )
end

local function ShutdownAudio()
	FCAudio.DeleteBuffer( tone1 )
	FCAudio.DeleteBuffer( tone2 )
	FCAudio.DeleteBuffer( tone3 )
	FCAudio.DeleteBuffer( tone4 )
	FCAudio.DeleteBuffer( tone5 )
	FCAudio.DeleteBuffer( tone6 )
	
	FCAudio.SourceStop( source1 )
	FCAudio.SourceStop( source2 )
	FCAudio.SourceStop( source3 )
	FCAudio.SourceStop( source4 )
	FCAudio.SourceStop( source5 )
	FCAudio.SourceStop( source6 )
end

local function RandomBackgroundImage()
	--backgroundView:SetStringProperty( "backgroundImage", "Assets/Images/Background" .. randomGenerator:Get() % 7 ..  ".png" )
	backgroundView:SetStringProperty( "backgroundImage", "Assets/Images/Background1.png" )
end

------------------------------------------------------------------------------------------

local function CreateViews()
	backgroundView = FCView:New( "backgroundView", "BackgroundView" )
	RandomBackgroundImage()
	backgroundView:SetFrame( {0,0,1,1} )

	titleLabel = FCView:New("titleLabel", "LabelView")
	classicButton = FCView:New("classicButton", "MainButtonView")
	sixButton = FCView:New( "sixButton", "MainButtonView" )
	shuffleButton = FCView:New( "shuffleButton", "MainButtonView" )
	multiButton = FCView:New( "multiButton", "MainButtonView" )
	madnessButton = FCView:New( "madnessButton", "MainButtonView" )
	
	quitButton = FCView:New( "quitButton", "ButtonView" )
	quitButton:SetBackgroundColor( kRedColor )

	scoreLabel = FCView:New("scoreLabel", "ScoreView")
	scoreLabel:SetStringProperty( "backgroundImage", "Assets/Images/ScoreBackground.png")

	redPlayButton = FCView:New("redPlayButton", "PlayView")
	redPlayButton:SetIntegerProperty( "color", kRedPlayButton )
	redPlayButton:SetStringProperty( "imageFilename", "Assets/Images/QuadRed.png" )
	redPlayButton:SetStringProperty( "imagePressedFilename", "Assets/Images/QuadRedPressed.png" )
	redPlayButton:SetAlpha( 1.0 )
	
	greenPlayButton = FCView:New( "greenPlayButton", "PlayView" )
	greenPlayButton:SetIntegerProperty( "color", kGreenPlayButton )
	greenPlayButton:SetStringProperty( "imageFilename", "Assets/Images/QuadGreen.png" )
	greenPlayButton:SetStringProperty( "imagePressedFilename", "Assets/Images/QuadGreenPressed.png" )
	greenPlayButton:SetAlpha( 1.0 )
	
	yellowPlayButton = FCView:New( "yellowPlayButton", "PlayView" )
	yellowPlayButton:SetIntegerProperty( "color", kYellowPlayButton )
	yellowPlayButton:SetStringProperty( "imageFilename", "Assets/Images/QuadYellow.png" )
	yellowPlayButton:SetStringProperty( "imagePressedFilename", "Assets/Images/QuadYellowPressed.png" )
	yellowPlayButton:SetAlpha( 1.0 )
	
	bluePlayButton = FCView:New( "bluePlayButton", "PlayView" )
	bluePlayButton:SetIntegerProperty( "color", kBluePlayButton )
	bluePlayButton:SetStringProperty( "imageFilename", "Assets/Images/QuadBlue.png" )
	bluePlayButton:SetStringProperty( "imagePressedFilename", "Assets/Images/QuadBluePressed.png" )
	bluePlayButton:SetAlpha( 1.0 )
	
	magentaPlayButton = FCView:New( "magentaPlayButton", "PlayView" )
	magentaPlayButton:SetIntegerProperty( "color", kMagentaPlayButton )
	magentaPlayButton:SetStringProperty( "imageFilename", "Assets/Images/QuadMagenta.png" )
	magentaPlayButton:SetStringProperty( "imagePressedFilename", "Assets/Images/QuadMagentaPressed.png" )
	magentaPlayButton:SetAlpha( 1.0 )
	
	cyanPlayButton = FCView:New( "cyanPlayButton", "PlayView" )
	cyanPlayButton:SetIntegerProperty( "color", kCyanPlayButton )
	cyanPlayButton:SetStringProperty( "imageFilename", "Assets/Images/QuadCyan.png" )
	cyanPlayButton:SetStringProperty( "imagePressedFilename", "Assets/Images/QuadCyanPressed.png" )
	cyanPlayButton:SetAlpha( 1.0 )
	
	backButton = FCView:New( "backButton", "ButtonView" )
	backButton:SetAlpha( 1.0 )
	
	retryButton = FCView:New( "retryButton", "ButtonView" )
	retryButton:SetAlpha( 1.0 )
	
	tweetButton = FCView:New( "tweetButton", "ButtonView" )
	tweetButton:SetAlpha( 1.0 )
	
	gameCenterButton = FCView:New( "gameCenterButton", "ButtonView" )
	gameCenterButton:SetAlpha( 1.0 )
	
	highScoreLabel = FCView:New( "highScoreLabel", "LabelView" )
	highScoreLabel:SetText( kText_HighScore )
	
	clockView = FCView:New( "clockView", "ClockView" )
	clockView:SetStringProperty( "backgroundImage", "Assets/Images/ClockRim.png" )
end

local function DestroyViews()
	titleLabel:Destroy( )
	classicButton:Destroy( )
	sixButton:Destroy( )
	shuffleButton:Destroy( )
	multiButton:Destroy( )
	madnessButtonDestroy( )
	quitButton:Destroy( )
	scoreLabel:Destroy( )
	redPlayButton:Destroy( )
	greenPlayButton:Destroy( )
	yellowPlayButton:Destroy( )
	bluePlayButton:Destroy( )
	magentaPlayButton:Destroy( )
	cyanPlayButton:Destroy( )
	backButton:Destroy( )
	retryButton:Destroy( )
	tweetButton:DestroyView( )
	clockView:Destroy( )
end

------------------------------------------------------------------------------------------

function FCApp.ColdBoot()
	FCApp.ShowStatusBar( false )
	FCStats.Inc( "numBoots" )
	FCPersistentData.Save()
	math.randomseed( os.time() )
	FCViewManager.SetScreenAspectRatio( 7, 10 )	-- portrait, mid way between iPad and iPhone
	randomGenerator = FCRandom.New()
end

function FCApp.WarmBoot()
	GameAppDelegate.ShowAdBanner()
	FCPhaseManager.AddPhaseToQueue("FrontEnd")	-- kick off game

	-- High scores

	FCPersistentData.Load()
	
	if FCPersistentData.GetNumber( kGameHighScoreClassic ) == nil then
		FCPersistentData.SetNumber( kGameHighScoreClassic, 0 )
	end

	if FCPersistentData.GetNumber( kGameHighScoreSix ) == nil then
		FCPersistentData.SetNumber( kGameHighScoreSix, 0 )
	end

	if FCPersistentData.GetNumber( kGameHighScoreShuffle ) == nil then
		FCPersistentData.SetNumber( kGameHighScoreShuffle, 0 )
	end

	if FCPersistentData.GetNumber( kGameHighScoreMulti ) == nil then
		FCPersistentData.SetNumber( kGameHighScoreMulti, 0 )
	end

	if FCPersistentData.GetNumber( kGameHighScoreMadness ) == nil then
		FCPersistentData.SetNumber( kGameHighScoreMadness, 0 )
	end
	
	FCPersistentData.Save()
	
	FCPersistentData.Print()
	
	FCApp.SetBackgroundColor( kBlackColor )
	CreateViews()
	InitialiseAudio()
	FCNewThread( BackgroundFXThread )
end

function BackgroundFXThread()
end

function FCApp.WillResignActive()
end

function FCApp.DidBecomeActive()
	if backgroundView then
		RandomBackgroundImage()
	end
end

function FCApp.DidEnterBackground()
end

function FCApp.WillEnterForeground()
end

function FCApp.WillTerminate()
	ShutdownAudio()
	DestroyViews()
end

function FCApp.SupportsPortrait()
	return true;
end

function FCApp.SupportsLandscape()
	return false;
end
