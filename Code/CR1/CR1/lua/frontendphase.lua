-- Front End Phase

kButtonHeight = 0.12

currentSelectedLevel = 1
creditsThread = nil

vm = FCViewManager

local firstBoot = true;

local kLevelSelectButtonPosLeft = {}
local kLevelSelectButtonPosCenter = {}
local kLevelSelectButtonPosRight = {}
local kDatePos = {}
local kLevelUpButtonPos = {}
local kLevelDownButtonPos = {}
local kWikipediaButtonPos = {}
local kPlayButtonLowPos = {  }
local kPlayButtonHighPos = {}
local kTitleLabelPos = {}
local kOptionsLowPos = {}
local kOptionsHighPos = {}
local kHighScoreLabelPos = {}
local kCreditsTitlePos = {}
local kCreditsLinePos = {}

-------------------------------------------------------

local function StartCredits()
	creditsThread = FCNewThread( CreditsThread )
end

local function StopCredits()
	if creditsThread ~= nil then
		FCKillThread( creditsThread )
		creditsThread = nil
		vm.SetAlpha( "creditsTitle, creditsLine", 0, 0.5 )
	end
end

-------------------------------------------------------

function LevelButtonPressedThread( name )
	--FCLog( "Got thread param '" .. name .. "'" )
end

function LevelButtonPressed( name )
	FCAudio.PlaySimpleSound( ClickSound )
	FCNewThread( LevelButtonPressedThread, name )
	
	for i = 1, LevelManager.NumLevels(), 1 do
		local buttonName = "levelButton" .. i
		vm.SetAlpha( buttonName, 0, 0.5 )
	end

	vm.SetAlpha( "playButton, levelUpButton, levelDownButton, dateLabel, wikipediaButton, feHighScoreLabel", 0, 0.5 )
	
	LevelManager.SelectLevel( name )
	firstBoot = false
end

-------------------------------------------------------

scoreDisplayThreadId = nil

function ScoreDisplayThread( score )
	vm.SetAlpha( "feHighScoreLabel", 0, 0.5 )
	
	FCWait( 0.5 )
	if score ~= nil then
		vm.SetText( "feHighScoreLabel", kWord_HighScore .. " " .. tostring( score ) )
		vm.SetAlpha( "feHighScoreLabel", 1, 0.5 )	
	end
	scoreDisplayThreadId = nil
end

-------------------------------------------------------

function PlayButtonPressedToTutorialThread()
	vm.SetAlpha( "playButton, optionsButton, titleLabel", 0, 0.5 )
	FCPhaseManager.AddPhaseToQueue( "Tutorial" )
	FCPhaseManager.DeactivatePhase( "FrontEnd" )
end

function PlayButtonBackPressedThread()
	vm.SetFrame( "titleLabel", kTitleLabelPos )
	vm.SetFrame( "optionsButton", kOptionsLowPos)

	for i = 1, LevelManager.NumLevels(), 1 do
		local buttonName = "levelButton" .. i
		vm.SetAlpha( buttonName, 0, 0.5 )
	end
	vm.SetOnSelectLuaFunction( "playButton", nil )
	vm.SetAlpha( "levelUpButton, levelDownButton, dateLabel, wikipediaButton, feHighScoreLabel", 0, 0.5 )
	vm.SetFrame( "playButton", kPlayButtonLowPos, 1 )
	FCWait( 0.5 )
	vm.SetText( "playButton", kWord_Play )
	FCWait( 0.5 )
	vm.SetAlpha( "optionsButton, titleLabel", 1, 0.5 )
	vm.SetOnSelectLuaFunction( "playButton", "PlayButtonPressed" )
end

function PlayButtonPressedThread()
	
	vm.SetOnSelectLuaFunction( "playButton", nil )
	vm.SetAlpha( "playButton", 1, 0.5 )
	vm.SetAlpha( "optionsButton, titleLabel", 0, 0.5 )
	vm.SetFrame( "playButton", kPlayButtonHighPos, 1 )
	vm.SetFrame( "dateLabel", kDatePos )
	vm.SetAlpha( "dateLabel", 0 )
	vm.SetText( "playButton", kWord_Back )
	if firstBoot then
		FCWait( 0.5 )
	end
	vm.SetOnSelectLuaFunction( "playButton", "PlayButtonBackPressed" )
	vm.SetAlpha( "wikipediaButton" , 1, 0.5 )

	if currentSelectedLevel > 1 then
		vm.SetAlpha( "levelDownButton" , 1, 0.5 )
	end

	if currentSelectedLevel < LevelManager.NumLevels() then
		vm.SetAlpha( "levelUpButton" , 1, 0.5 )
	end
	
	for i = 1, LevelManager.NumLevels(), 1 do
		local buttonName = "levelButton" .. i
		vm.SetAlpha( buttonName, 0 )
		if i < currentSelectedLevel then
			vm.SetFrame( buttonName, kLevelSelectButtonPosLeft )	
			vm.SetAlpha( buttonName, 0, 0.5 )
		else 
			if i > currentSelectedLevel then
				vm.SetFrame( buttonName, kLevelSelectButtonPosRight )	
				vm.SetAlpha( buttonName, 0, 0.5 )
			else	-- this is current selected level
				vm.SetFrame( buttonName, kLevelSelectButtonPosCenter )	
				vm.SetAlpha( buttonName, 1, 0.5 )
				vm.SetText( "dateLabel", LevelManager.DateForId(i) )
			end
		end
	end
	vm.SetAlpha( "dateLabel", 1, 0.5 )
	
	if scoreDisplayThreadId ~= nil then
		FCKillThread( scoreDisplayThreadId )
		scoreDisplayThreadId = nil
	end
	
	scoreDisplayThreadId = FCNewThread( ScoreDisplayThread, LevelManager.HighScoreForId(currentSelectedLevel) )
end

function PlayButtonPressed()
	FCAudio.PlaySimpleSound( ClickSound )
	FCNewThread( PlayButtonPressedThread)
	if Globals.AddsActive() then
		GameAppDelegate.ShowAdBanner()
	end
	StopCredits()
end

function PlayButtonBackPressed()

	FCAudio.PlaySimpleSound( ClickSound )
	if scoreDisplayThreadId ~= nil then
		FCKillThread( scoreDisplayThreadId )
		scoreDisplayThreadId = nil
	end

	firstBoot = true
	GameAppDelegate.HideAdBanner()
	FCNewThread( PlayButtonBackPressedThread )
	StartCredits()
end

function LevelUpPressed()
	FCAudio.PlaySimpleSound( ClickSound )
	
	vm.SetAlpha( "levelDownButton", 1, 0.5 )
	if currentSelectedLevel < LevelManager.NumLevels() then
		currentSelectedLevel = currentSelectedLevel + 1
		vm.SetText( "dateLabel", LevelManager.DateForId(currentSelectedLevel) )
		FCPersistentData.SetNumber( "lastSelectedLevel", currentSelectedLevel )
		-- move level buttons
		local oldButtonName = "levelButton" .. currentSelectedLevel - 1
		local newButtonName = "levelButton" .. currentSelectedLevel
		vm.SetFrame( oldButtonName, kLevelSelectButtonPosLeft, 0.2 )
		vm.SetAlpha( oldButtonName, 0, 0.2 )
		vm.SetFrame( newButtonName, kLevelSelectButtonPosCenter, 0.2 )
		vm.SetAlpha( newButtonName, 1, 0.2 )
	end
	
	if currentSelectedLevel < ( LevelManager.NumLevels() ) then
		vm.SetAlpha( "levelUpButton", 1, 0.5 )
	else
		vm.SetAlpha( "levelUpButton", 0, 0.5 )
	end
	
	if scoreDisplayThreadId ~= nil then
		FCKillThread( scoreDisplayThreadId )
		scoreDisplayThreadId = nil
	end

	scoreDisplayThreadId = FCNewThread( ScoreDisplayThread, LevelManager.HighScoreForId(currentSelectedLevel) )
end

function LevelDownPressed()
	FCAudio.PlaySimpleSound( ClickSound )
	vm.SetAlpha( "levelUpButton", 1, 0.5 )
	if currentSelectedLevel > 1 then
		currentSelectedLevel = currentSelectedLevel - 1
		vm.SetText( "dateLabel", LevelManager.DateForId(currentSelectedLevel) )
		FCPersistentData.SetNumber( "lastSelectedLevel", currentSelectedLevel )
		-- move level buttons
		local oldButtonName = "levelButton" .. currentSelectedLevel + 1
		local newButtonName = "levelButton" .. currentSelectedLevel
		vm.SetFrame( oldButtonName, kLevelSelectButtonPosRight, 0.2 )
		vm.SetAlpha( oldButtonName, 0, 0.2 )
		vm.SetFrame( newButtonName, kLevelSelectButtonPosCenter, 0.2 )
		vm.SetAlpha( newButtonName, 1, 0.2 )
	end
	
	if currentSelectedLevel > 1 then
		vm.SetAlpha( "levelDownButton", 1, 0.5 )
	else
		vm.SetAlpha( "levelDownButton", 0, 0.5 )		
	end
	
	if scoreDisplayThreadId ~= nil then
		FCKillThread( scoreDisplayThreadId )
		scoreDisplayThreadId = nil
	end

	scoreDisplayThreadId = FCNewThread( ScoreDisplayThread, LevelManager.HighScoreForId(currentSelectedLevel) )
end

-------------------------------------------------------

function GameCenterButtonPressed()
	FCAudio.PlaySimpleSound( ClickSound )
	FCApp.ShowGameCenterLeaderboards()
end

-------------------------------------------------------

duringAudioPageThreadId = nil

function DuringAudioPageThread()
	while true do
		local musicVol = FCPersistentData.GetNumber( "musicVolume" )
		FCAudio.SetMusicVolume( musicVol / 10 )
		local sfxVol = FCPersistentData.GetNumber( "sfxVolume" )
		FCAudio.SetSFXVolume( sfxVol / 10 )
		FCWait( 0.2 )
	end
end

-------------------------------------------------------

function AudioButtonBackPressedThread()
	vm.SetOnSelectLuaFunction( "audioButton", nil )
	vm.SetAlpha( "musicVolumeLabel, sfxVolumeLabel, musicSlider, sfxSlider", 0, 0.5 )
	--FCWait( 0.5 )
	vm.SetFrame( "audioButton", { 0.2, 0.45, -1, -1 }, 1 )
	FCWait( 0.5 )
	vm.SetText( "audioButton", kWord_Audio )
	FCWait( 0.5 )
	vm.SetAlpha( "optionsButton, gameCenterButton", 1, 0.5 )
	vm.SetOnSelectLuaFunction( "audioButton", "AudioButtonPressed" )	
end

function AudioButtonBackPressed()
	FCAudio.PlaySimpleSound( ClickSound )
	FCNewThread( AudioButtonBackPressedThread )
	FCKillThread( duringAudioPageThreadId )
	duringAudioPageThreadId = nil
end

-------------------------------------------------------

function AudioButtonPressedThread()
	vm.SetOnSelectLuaFunction( "audioButton", nil )
	vm.SetAlpha( "optionsButton, gameCenterButton", 0, 0.5 )
	--FCWait( 0.5 )
	vm.SetFrame( "audioButton", { 0.2, 0.1, -1, -1 }, 1 )
	FCWait( 0.5 )
	vm.SetText( "audioButton", kWord_Back )
	FCWait( 0.5 )
	vm.SetOnSelectLuaFunction( "audioButton", "AudioButtonBackPressed" )
	vm.SetAlpha( "musicVolumeLabel, sfxVolumeLabel, musicSlider, sfxSlider", 0 )
	vm.SetFrame( "musicVolumeLabel", {0.2, 0.3, 0.6, kButtonHeight} )
	vm.SetFrame( "musicSlider", {0.2, 0.45, 0.6, kButtonHeight} )
	vm.SetFrame( "sfxVolumeLabel", {0.2, 0.6, 0.6, kButtonHeight} )
	vm.SetFrame( "sfxSlider", {0.2, 0.75, 0.6, kButtonHeight} )
	vm.SetAlpha( "musicVolumeLabel, sfxVolumeLabel, musicSlider, sfxSlider", 1, 0.5 )
end

function AudioButtonPressed()
	FCAudio.PlaySimpleSound( ClickSound )
	FCNewThread( AudioButtonPressedThread )
	duringAudioPageThreadId = FCNewThread( DuringAudioPageThread )
end

-------------------------------------------------------

function OptionsButtonPressedThread()
	vm.SetOnSelectLuaFunction( "optionsButton", nil )

	-- Play button and title fade away
	vm.SetAlpha( "playButton, titleLabel", 0, 0.5 )
	--FCWait( 0.5 )
	
	-- Options button moves and then enables
	vm.SetFrame( "optionsButton", kOptionsHighPos, 1)

	vm.SetAlpha( "gameCenterButton, audioButton", 0 )	
	vm.SetFrame( "gameCenterButton", {0.2, 0.3, 0.6, kButtonHeight})
	vm.SetFrame( "audioButton", {0.2, 0.45, 0.6, kButtonHeight})
	vm.SetOnSelectLuaFunction( "audioButton", "AudioButtonPressed" )
	
	FCWait( 0.5 )
	vm.SetText( "optionsButton", kWord_Back )
	FCWait( 0.5 )

	vm.SetOnSelectLuaFunction( "optionsButton", "OptionsButtonPressedBack" )
	
	-- Bring on options buttons
		
	vm.SetAlpha( "gameCenterButton, audioButton", 1, 0.5 )
	vm.SetOnSelectLuaFunction( "gameCenterButton", "GameCenterButtonPressed" )
end

function OptionsButtonPressed()
	if Globals.AddsActive() then
		GameAppDelegate.ShowAdBanner()
	end
	FCNewThread( OptionsButtonPressedThread )
	StopCredits()
	FCAudio.PlaySimpleSound( ClickSound )
end

-------------------------------------------------------

function OptionsButtonPressedBackThread()
	vm.SetOnSelectLuaFunction( "optionsButton", nil )
	vm.SetAlpha( "gameCenterButton, audioButton", 0, 0.5 )
	--FCWait( 0.5 )
	vm.SetFrame( "optionsButton", kOptionsLowPos, 1)
	FCWait( 0.5 )
	vm.SetText( "optionsButton", kWord_Options )
	FCWait( 0.5 )
	vm.SetAlpha( "playButton, titleLabel", 1, 0.5 )
	vm.SetOnSelectLuaFunction( "optionsButton", "OptionsButtonPressed" )
end

function OptionsButtonPressedBack()
	FCAudio.PlaySimpleSound( ClickSound )
	FCNewThread( OptionsButtonPressedBackThread )
	GameAppDelegate.HideAdBanner()
	StartCredits()
end

-------------------------------------------------------

function WikipediaReturnPressed()
	FCAudio.PlaySimpleSound( ClickSound )
	vm.SetAlpha( "webView", 0, 0.5 )
	vm.SetFrame( "webView", {0, 1, 1, 1}, 0.5 )

--	vm.SetOnSelectLuaFunction( "webView", "WikipediaReturnPressed" )
end

function WikipediaPressed()
	FCAudio.PlaySimpleSound( ClickSound )
	FCAnalytics.RegisterEvent( "Wiki pressed: " .. LevelManager.WikiForId(currentSelectedLevel) )
	vm.SetAlpha( "webView", 1, 0.5 )
	vm.SetFrame( "webView", {0, 0.1, 1, 0.9}, 0.5 )

	vm.SetURL( "webView", LevelManager.WikiForId(currentSelectedLevel) )
	vm.SetOnSelectLuaFunction( "webView", "WikipediaReturnPressed" )
	-- bring up webpage
	-- set the url
end

function PlayClick()
	FCAudio.PlaySimpleSound( ClickSound )
end

-------------------------------------------------------

local function CreateViews()
	vm.CreateView( "titleLabel", "LabelView" )
	vm.CreateView( "musicVolumeLabel", "LabelView" )
	vm.CreateView( "sfxVolumeLabel", "LabelView" )
	vm.CreateView( "creditsTitle", "LabelView" )
	vm.CreateView( "creditsLine", "LabelView" )
	vm.CreateView( "dateLabel", "LabelView" )
	vm.CreateView( "playButton", "ButtonView" )

	vm.CreateView( "optionsButton", "ButtonView" )
	vm.CreateView( "gameCenterButton", "ButtonView" )
	vm.CreateView( "audioButton", "ButtonView" )
	vm.CreateView( "wikipediaButton", "ButtonView" )
	vm.CreateView( "levelUpButton", "ButtonView" )
	vm.CreateView( "levelDownButton", "ButtonView" )
	vm.CreateView( "feHighScoreLabel", "LabelView" )

	vm.CreateView( "webView", "GameWebView" )

	vm.CreateView( "musicSlider", "SliderView" )
	vm.SetViewPropertyInteger( "musicSlider", "minLimit", 0 )
	vm.SetViewPropertyInteger( "musicSlider", "maxLimit", 10 )
	vm.SetViewPropertyString( "musicSlider", "persistentDataName", "musicVolume" )
	vm.SetViewPropertyString( "musicSlider", "incLuaCallback", "PlayClick" )
	vm.SetViewPropertyString( "musicSlider", "decLuaCallback", "PlayClick" )

	vm.CreateView( "sfxSlider", "SliderView" )
	vm.SetViewPropertyInteger( "sfxSlider", "minLimit", 0 )
	vm.SetViewPropertyInteger( "sfxSlider", "maxLimit", 10 )
	vm.SetViewPropertyString( "sfxSlider", "persistentDataName", "sfxVolume" )
	vm.SetViewPropertyString( "sfxSlider", "incLuaCallback", "PlayClick" )
	vm.SetViewPropertyString( "sfxSlider", "decLuaCallback", "PlayClick" )

	for i = 1, LevelManager.NumLevels() + 1 do
		local viewName = "levelButton" .. i
		vm.CreateView( viewName, "LevelSelectButton" )
		vm.SetViewPropertyString( viewName, "onLeftSwipeLuaFunction", "LevelUpPressed" )
		vm.SetViewPropertyString( viewName, "onRightSwipeLuaFunction", "LevelDownPressed" )
	end
end

local function DestroyViews()
	vm.DestroyView( "titleLabel" )
	vm.DestroyView( "musicVolumeLabel" )
	vm.DestroyView( "sfxVolumeLabel" )
	vm.DestroyView( "creditsTitle" )
	vm.DestroyView( "creditsLine" )
	vm.DestroyView( "dateLabel" )
	vm.DestroyView( "musicSlider" )
	vm.DestroyView( "sfxSlider" )
	vm.DestroyView( "playButton" )
	
	vm.DestroyView( "optionsButton" )
	vm.DestroyView( "gameCenterButton" )
	vm.DestroyView( "audioButton" )
	vm.DestroyView( "wikipediaButton" )
	vm.DestroyView( "levelUpButton" )
	vm.DestroyView( "levelDownButton" )
	vm.DestroyView( "webView" )
	vm.DestroyView( "feHighScoreLabel" )
	
	for i = 1, LevelManager.NumLevels() + 1 do
		local viewName = "levelButton" .. i
		vm.DestroyView( viewName )
	end
end

function CreditsThread()

	while true do
		vm.SetAlpha( "creditsTitle, creditsLine", 0 )
		vm.SetFrame( "creditsTitle", kCreditsTitlePos )
		vm.SetFrame( "creditsLine", kCreditsLinePos )
		
		FCWait( 2 )
		
		vm.SetText( "creditsTitle", kWord_CreatedBy )
		vm.SetText( "creditsLine", "@fizzychicken" )
		vm.SetAlpha( "creditsTitle, creditsLine", 1, 0.5 )
		FCWait( 2 )
		vm.SetAlpha( "creditsTitle, creditsLine", 0, 0.5 )
		FCWait( 0.5 )
		
		vm.SetText( "creditsTitle", kWord_Photographs )
		vm.SetText( "creditsLine", "plappy" )
		vm.SetAlpha( "creditsTitle, creditsLine", 1, 0.5 )
		FCWait( 1 )
		vm.SetAlpha( "creditsLine", 0, 0.5 )
		FCWait( 0.5 )

		vm.SetText( "creditsLine", "Bob Squash" )
		vm.SetAlpha( "creditsLine", 1, 0.5 )
		FCWait( 1 )
		vm.SetAlpha( "creditsLine, creditsTitle", 0, 0.5 )
		FCWait( 0.5 )
	end
end

function MusicFinishedFunc()
		FCAudio.PlayMusic("Imported/Audio/music")
end

-------------------------------------------------------

FrontEndPhase = {}

function FrontEndPhase.WillActivate()

	CreateViews()

	if Globals.AddsActive() then
		kLevelSelectButtonPosLeft = {-1, 0.4, 0.8, 0.16}
		kLevelSelectButtonPosCenter = {0.1, 0.4, 0.8, 0.16}
		kLevelSelectButtonPosRight = {1.2, 0.4, 0.8, 0.16}
		kDatePos = { 0.2, 0.25, 0.6, 0.15 }
		kLevelUpButtonPos = {0.65, 0.85, 0.2, 0.1}
		kLevelDownButtonPos = {0.15, 0.85, 0.2, 0.1}
		kWikipediaButtonPos = {0.4, 0.85, 0.2, 0.10}
		kPlayButtonLowPos = { 0.2, 0.7, 0.6, kButtonHeight }
		kPlayButtonHighPos = { 0.2, 0.125, 0.6, kButtonHeight }
		kTitleLabelPos = { 0.2, 0.1, 0.6, 0.15 }
		kOptionsLowPos = { 0.2, 0.85, 0.6, kButtonHeight }
		kOptionsHighPos = { 0.2, 0.125, 0.6, kButtonHeight }
		kHighScoreLabelPos = { 0.2, 0.6, 0.6, 0.1 }
		kCreditsTitlePos = { 0.1, 0.4, 0.8, 0.12 }
		kCreditsLinePos = { 0.1, 0.525, 0.8, 0.1 }
	else
		kLevelSelectButtonPosLeft = {-1, 0.4, 0.8, 0.16}
		kLevelSelectButtonPosCenter = {0.1, 0.4, 0.8, 0.16}
		kLevelSelectButtonPosRight = {1.2, 0.4, 0.8, 0.16}
		kDatePos = { 0.2, 0.25, 0.6, 0.15 }
		kLevelUpButtonPos = {0.65, 0.85, 0.2, 0.1}
		kLevelDownButtonPos = {0.15, 0.85, 0.2, 0.1}
		kWikipediaButtonPos = {0.4, 0.85, 0.2, 0.10}
		kPlayButtonLowPos = { 0.2, 0.7, 0.6, kButtonHeight }
		kPlayButtonHighPos = { 0.2, 0.1, 0.6, kButtonHeight }
		kTitleLabelPos = { 0.2, 0.1, 0.6, 0.15 }
		kOptionsLowPos = { 0.2, 0.85, 0.6, kButtonHeight }
		kOptionsHighPos = { 0.2, 0.15, 0.6, kButtonHeight }
		kHighScoreLabelPos = { 0.2, 0.6, 0.6, 0.1 }
		kCreditsTitlePos = { 0.1, 0.4, 0.8, 0.12 }
		kCreditsLinePos = { 0.1, 0.525, 0.8, 0.1 }
	end

	-- setup

	vm.SetFrame( "feHighScoreLabel", kHighScoreLabelPos )
	vm.SetAlpha( "feHighScoreLabel", 1 )

	vm.SetText( "titleLabel", Globals.AppName() )

	vm.SetText( "playButton", kWord_Play )
	vm.SetOnSelectLuaFunction( "playButton", "PlayButtonPressed" )

	vm.SetTextColor( "playButton, optionsButton, gameCenterButton, audioButton", Globals.kSepiaColor )

	vm.SetText( "optionsButton", kWord_Options )
	vm.SetOnSelectLuaFunction( "optionsButton", "OptionsButtonPressed" )

	vm.SetText( "gameCenterButton", kWord_GameCenter )
	vm.SetText( "audioButton", kWord_Audio )

	vm.SetImage( "wikipediaButton", "Imported/Wikipedia.png" )
	vm.SetFrame( "wikipediaButton", kWikipediaButtonPos )
	vm.SetAlpha( "wikipediaButton", 0 )
	vm.SetOnSelectLuaFunction( "wikipediaButton", "WikipediaPressed" )

	vm.SetAlpha( "webView", 0 )
	vm.SetFrame( "webView", {0, 1, 1, 1} )
	
	vm.SetText( "musicVolumeLabel", "Music Volume" );
	vm.SetTextColor( "musicVolumeLabel, sfxVolumeLabel", kBlackColor )

	vm.SetText( "sfxVolumeLabel", "SFX Volume" );
	
	vm.SetOnSelectLuaFunction( "levelUpButton", "LevelUpPressed" )
	vm.SetOnSelectLuaFunction( "levelDownButton", "LevelDownPressed" )

	vm.SetTextColor( "creditsLine, creditsTitle", kBlackColor )
	
	vm.SetFrame( "levelUpButton", kLevelUpButtonPos )
	vm.SetFrame( "levelDownButton", kLevelDownButtonPos )
	vm.SetAlpha( "levelUpButton, levelDownButton", 0 )
	
	currentSelectedLevel = FCPersistentData.GetNumber( "lastSelectedLevel" )
	if currentSelectedLevel == nil then
		currentSelectedLevel = 1
	end
	
	for i = 1, LevelManager.NumLevels(), 1 do
		local buttonName = "levelButton" .. i
		if LevelManager.levels[i]:Locked() then
			vm.SetOnSelectLuaFunction( buttonName, nil )
		else
			vm.SetOnSelectLuaFunction( buttonName, "LevelButtonPressed" )
		end
			
		vm.SetText( buttonName, LevelManager.NameForId(i) )
		vm.SetTextColor( buttonName, Globals.kSepiaColor )
	end
	
	StartCredits()
	
end

function FrontEndPhase.IsNowActive()
	FCApp.SetUpdateFrequency( 5 )
	
	FCAudio.PlayMusic("Imported/Audio/music")
	local musicVol = FCPersistentData.GetNumber( "musicVolume" )
	FCAudio.SetMusicVolume( musicVol / 10 )
	FCAudio.SetMusicFinishedCallback( "MusicFinishedFunc" )

	local sfxVol = FCPersistentData.GetNumber( "sfxVolume" )
	FCAudio.SetSFXVolume( sfxVol / 10 )

	if firstBoot then
		vm.SetAlpha( "titleLabel, playButton, optionsButton", 0, 0 )
		vm.SetFrame( "titleLabel", kTitleLabelPos )
		vm.SetFrame( "playButton", kPlayButtonLowPos )
		vm.SetFrame( "optionsButton", kOptionsLowPos )
		vm.SetAlpha( "optionsButton, titleLabel, playButton", 1, 1 )
	else
		vm.SetFrame( "playButton", kPlayButtonHighPos )
		PlayButtonPressed()
	end
end

function FrontEndPhase.WillDeactivate()
end

function FrontEndPhase.IsNowDeactive()
	DestroyViews()
end

function FrontEndPhase.Update()
end

