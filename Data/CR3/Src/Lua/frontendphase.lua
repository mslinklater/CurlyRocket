function RemoveFEUI()
	Views.Title:SetFrame( FCRectZero() )
	Views.Easy:SetFrame( FCRectZero() )
	Views.Medium:SetFrame( FCRectZero() )
	Views.Hard:SetFrame( FCRectZero() )
	Views.Extreme:SetFrame( FCRectZero() )
	Views.CurlyRocket:SetFrame( FCRectZero() )
	Views.NumCoins:SetFrame( FCRectZero() )
	Views.HowToPlay:SetFrame( FCRectZero() )
	Views.Volume:SetFrame( FCRectZero() )
end

-------------------------------------------------------

-- How to play

function HowToPlayThread()
	RemoveFEUI()
	FCPhaseManager.AddPhaseToQueue( "HowToPlay" )
	FCPhaseManager.DeactivatePhase( "FrontEnd" )
end

function HowToPlaySelected()
	FCNewThread( HowToPlayThread, "how to play" )
	FCAnalytics.RegisterEvent( "howtoplay" )
	Audio.PlayClick()
end

-------------------------------------------------------
-- Begin game

function StartGameThread()
	-- remove UI elements

	RemoveFEUI()
	
	-- kick off game phase
	FCPhaseManager.AddPhaseToQueue( "Game" )
	FCPhaseManager.DeactivatePhase( "FrontEnd" )
end

function EasyGameSelected()
	FCLog("Easy selected")
	Audio.PlayClick()
	gDifficulty = kGameEasy
	gCurrentMapNumber = FCPersistentData.GetNumber( kSaveKey_EasyProgress ) + 1
	gSaveKeyCompleted = kSaveKey_CompletedEasy
	LoadMaps()
	FCNewThread( StartGameThread, "start game" )
	FCAnalytics.RegisterEvent( "easySelected" )
end

function MediumGameSelected()
	FCLog("Medium selected")
	Audio.PlayClick()
	gDifficulty = kGameMedium
	gCurrentMapNumber = FCPersistentData.GetNumber( kSaveKey_MediumProgress ) + 1
	gSaveKeyCompleted = kSaveKey_CompletedMedium
	LoadMaps()
	FCNewThread( StartGameThread, "start game" )
	FCAnalytics.RegisterEvent( "mediumSelected" )
end

function HardGameSelected()
	FCLog("Hard selected")
	Audio.PlayClick()
	gDifficulty = kGameHard
	gCurrentMapNumber = FCPersistentData.GetNumber( kSaveKey_HardProgress ) + 1
	gSaveKeyCompleted = kSaveKey_CompletedHard
	LoadMaps()
	FCNewThread( StartGameThread, "start game" )
	FCAnalytics.RegisterEvent( "hardSelected" )
end

function ExtremeGameSelected()
	FCLog("Extreme selected")
	Audio.PlayClick()
	gDifficulty = kGameExtreme
	gCurrentMapNumber = FCPersistentData.GetNumber( kSaveKey_ExtremeProgress ) + 1
	gSaveKeyCompleted = kSaveKey_CompletedExtreme
	LoadMaps()
	FCNewThread( StartGameThread, "start game" )
	FCAnalytics.RegisterEvent( "extremeSelected" )
end

-------------------------------------------------------

function CurlyRocketSelectedThread()
	--RemoveFEUI()

	FCApp.LaunchExternalURL("http://www.curlyrocket.com/inapppromo/curlyminesweeper.html")
	
	-- kick off game phase
--	FCPhaseManager.AddPhaseToQueue( "CurlyRocket" )
--	FCPhaseManager.DeactivatePhase( "FrontEnd" )
end

function CurlyRocketSelected()
	Audio.PlayClick()
	FCNewThread( CurlyRocketSelectedThread, "curly rocket" )
end

-------------------------------------------------------

FrontEndPhase = {}

function FrontEndPhase.BuyCoins()
	Audio.PlayClick()
	gBuyCoinsSource = "FE"
	Store.LaunchBuyCoins("FE")
end

function FrontEndPhase.RateYes()
	FCAnalytics.RegisterEvent( "Rate Yes" )
	FCPersistentData.SetNumber( kSaveKey_RateCount, 999999 )
	FCPersistentData.Save()
	Views.RateApp:SetFrame( FCRectZero() )
	FCApp.LaunchExternalURL("itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=572641059&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")
end

function FrontEndPhase.RateLater()
	FCAnalytics.RegisterEvent( "Rate Later" )
	FCPersistentData.SetNumber( kSaveKey_RateCount, numGamesPlayed + 10 )
	FCPersistentData.Save()
	Views.RateApp:SetFrame( FCRectZero() )
end

function FrontEndPhase.RateNo()
	FCAnalytics.RegisterEvent( "Rate No" )
	FCPersistentData.SetNumber( kSaveKey_RateCount, 999999 )
	FCPersistentData.Save()
	Views.RateApp:SetFrame( FCRectZero() )
end

function FrontEndPhase.DisplayRateApp()
	Views.RateApp:SetFrame( FCRectOne() )
	Views.RateApp:MoveToFront()
	Views.RateApp.Yes:SetTapFunction( "FrontEndPhase.RateYes" )
	Views.RateApp.Later:SetTapFunction( "FrontEndPhase.RateLater" )
	Views.RateApp.No:SetTapFunction( "FrontEndPhase.RateNo" )
end

function FrontEndPhase.CheckRateApp()
	numGamesPlayed = FCPersistentData.GetNumber( kSaveKey_EasyProgress )
	numGamesPlayed = numGamesPlayed + FCPersistentData.GetNumber( kSaveKey_MediumProgress )
	numGamesPlayed = numGamesPlayed + FCPersistentData.GetNumber( kSaveKey_HardProgress )
	numGamesPlayed = numGamesPlayed + FCPersistentData.GetNumber( kSaveKey_ExtremeProgress )
	
	checkCount = FCPersistentData.GetNumber( kSaveKey_RateCount )
	
	if checkCount <= numGamesPlayed then
		FrontEndPhase.DisplayRateApp()
	end
end

function FrontEndPhase.WillActivate()
	FCLog("FrontEndPhase.WillActivate")
	
	Views.Title:SetFrame( TitleViewFrame() )
	--Views.Title:SetText( kText_GameTitle )
	
	Views.Easy:SetFrame( Layout.MainButtonFrame( Views.Easy, kViewModeOn ) )
	Views.Easy.EasyText:SetText( kText_Easy .. " (" .. FCPersistentData.GetNumber( kSaveKey_EasyProgress ) .. "/100)" )
	Views.Easy:SetTapFunction( "EasyGameSelected" )
	
	Views.Medium:SetFrame( Layout.MainButtonFrame( Views.Medium, kViewModeOn ) )
	if FCPersistentData.GetNumber( kSaveKey_EasyProgress ) > 0 then
		Views.Medium.MediumText:SetText( kText_Medium .. " (" .. FCPersistentData.GetNumber( kSaveKey_MediumProgress ) .. "/100)" )
		Views.Medium:SetTapFunction( "MediumGameSelected" )
	else
		Views.Medium.MediumText:SetText( kText_Medium .. " (" .. kText_Locked .. ")" )
	end
	
	Views.Hard:SetFrame( Layout.MainButtonFrame( Views.Hard, kViewModeOn ) )
	if FCPersistentData.GetNumber( kSaveKey_MediumProgress ) > 0 then
		Views.Hard.HardText:SetText( kText_Hard .. " (" .. FCPersistentData.GetNumber( kSaveKey_HardProgress ) .. "/100)" )
		Views.Hard:SetTapFunction( "HardGameSelected" )
	else
		Views.Hard.HardText:SetText( kText_Hard .. " (" .. kText_Locked .. ")" )
	end
	
	Views.Extreme:SetFrame( Layout.MainButtonFrame( Views.Extreme, kViewModeOn ) )
	if FCPersistentData.GetNumber( kSaveKey_HardProgress ) > 0 then
		Views.Extreme.ExtremeText:SetText( kText_Extreme .. " (" .. FCPersistentData.GetNumber( kSaveKey_ExtremeProgress ) .. "/100)" )
		Views.Extreme:SetTapFunction( "ExtremeGameSelected" )
	else
		Views.Extreme.ExtremeText:SetText( kText_Extreme .. " (" .. kText_Locked .. ")" )
	end

	Views.HowToPlay:SetFrame( HowToPlayViewFrame() )
--	Views.HowToPlay.HowToPlayText:SetFrame( FCRectOne() )
	Views.HowToPlay:SetTapFunction( "HowToPlaySelected" )

	Views.NumCoins:SetFrame( NumCoinsViewFrame() )
	Views.NumCoins.Text:SetText( "" .. GetNumCoins() )
	Views.NumCoins:SetTapFunction( "FrontEndPhase.BuyCoins" )

	Views.CurlyRocket:SetFrame( CurlyRocketViewFrame() )
	Views.CurlyRocket:SetTapFunction( "CurlyRocketSelected" )

	Views.Volume:SetFrame( VolumeViewFrame() )
	Views.Volume:SetTapFunction("Audio.AlterVolume")

	Store.InitViews()
	
	Audio.SetVolumeIcon()
	FrontEndPhase.CheckRateApp()
end

function FrontEndPhase.IsNowActive()
	FCLog("FrontEndPhase.IsNowActive")
	
	if FCStore.Available() then
		FCLog( "Store is available" )
	else
		FCLog( "Store is not available" )
	end
end

function FrontEndPhase.WillDeactivate()
	FCLog("FrontEndPhase.WillDeactivate")
end

function FrontEndPhase.IsNowDeactive()
	FCLog("FrontEndPhase.IsNowDeactive")
end

function FrontEndPhase.Update()
end

