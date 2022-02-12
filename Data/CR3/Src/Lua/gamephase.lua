GamePhase = {}

local lNumMoves = 0
local lSonarCol = 0
local lSonarRow = 0
local lTouchesEnabled = nil
local lLastCol = 0
local lLastRow = 0

local lBoostThread = nil

------------------------------------------------------------------------------------------

function GamePhase.ZoomIn()
	if lTouchesEnabled then
		Views.FullBoard:SetAlpha( 0, 0.2 )
		Views.ScrollingBoard:SetAlpha( 1, 0.2 )
		gZoomed = true
		Audio.PlayClick( true )
	end
end

function GamePhase.ZoomOut()
	if lTouchesEnabled then
		Views.FullBoard:SetAlpha( 1, 0.2 )
		Views.ScrollingBoard:SetAlpha( 0, 0.2 )
		gZoomed = false
		Audio.PlayClick( true )
	end
end

function GamePhase.ClearGameViews()
	Views.TopBar:SetFrame( FCRectZero() )
	Views.FullBoard:SetFrame( FCRectZero() )
	Views.ScrollingBoard:SetFrame( FCRectZero() )
	Views.GameOver:SetFrame( FCRectZero() )
	Views.Recover:SetFrame( FCRectZero() )
	Views.Quit:SetFrame( FCRectZero() )
	Views.Congratulations:SetFrame( FCRectZero() )
	Views.Continue:SetFrame( FCRectZero() )
	Views.MainMenu:SetFrame( FCRectZero() )
end

function GamePhase.SolvedThread()
	lTouchesEnabled = false
	FCWait( 1.0 )
	--GamePhase.ZoomOut()
	Views.ScrollingBoard:SetAlpha( 0, 1 )
	Views.FullBoard:SetAlpha( 0.25, 1 )

	Audio.PlayYay()

	Views.Congratulations:SetAlpha(1);
	Views.Congratulations:MoveToFront()
	
	if gCurrentMapNumber < 100 then
		Views.Continue:SetAlpha(1)
		Views.Continue:MoveToFront()
		Views.Continue:SetTapFunction( "GamePhase.ContinueSelected" )
	end
	Views.MainMenu:SetAlpha(1)
	Views.MainMenu:MoveToFront()
	Views.MainMenu:SetTapFunction( "GamePhase.QuitSelected" )
end

------------------------------------------------------------------------------------------

function GamePhase.MagSelected()
	if lTouchesEnabled then
		if gZoomed then
			GamePhase.ZoomOut()
		else
			GamePhase.ZoomIn()
		end
	end
end

------------------------------------------------------------------------------------------

function GamePhase.SaveGameState()
--	FCPersistentData.SetString( kSaveKey_BoardState, Board.Serialise() )
--	FCPersistentData.SetString( kSaveKey_MSState, MSManager.Serialise() );
end

function GamePhase.RestoreGameState()
end

------------------------------------------------------------------------------------------

function GamePhase.RecoverSelected()
	FCLog("Recover Selected")
	Audio.PlayClick()
	FCAnalytics.RegisterEvent( "Undo Pressed" )

	if GetNumCoins() > (kUndoCost - 1) then
	
		Views.FullBoard:SetAlpha( 1, 1 )
		Views.ScrollingBoard:SetAlpha( 0, 1 )

		SetNumCoins( GetNumCoins() - kUndoCost )
		GamePhase.UpdateCoinsView()
	
		lTouchesEnabled = true;
		
		MSManager.HideLocation( lLastCol, lLastRow )
	
		Views.TopBar.SpendCoin:SetTapFunction( "GamePhase.ReconPressed" )
		Views.TopBar.Magnify:SetTapFunction( "GamePhase.MagSelected" )
	
		Views.GameOver:SetAlpha( 0 )
		Views.Recover:SetAlpha( 0 )
		Views.Quit:SetAlpha( 0 )
	else
		gBuyCoinsSource = "recover"
		Store.LaunchBuyCoins("game")
	end

end

------------------------------------------------------------------------------------------

function GamePhase.PlayerSelectedBomb()
	Audio.PlayBoo()
	lTouchesEnabled = false
	Views.TopBar.SpendCoin:SetTapFunction( "" )
	Views.TopBar.Magnify:SetTapFunction( "" )
	
	Views.GameOver:MoveToFront()
	Views.Recover:MoveToFront()
	Views.Quit:MoveToFront()
	
	Views.GameOver:SetAlpha( 1, 1 )
	Views.Recover:SetAlpha( 1, 1 )
	Views.Quit:SetAlpha( 1, 1 )
	Views.ScrollingBoard:SetAlpha( 0.25, 1 )
	
	Views.Quit:SetTapFunction( "GamePhase.QuitSelected" )
	Views.Recover:SetTapFunction( "GamePhase.RecoverSelected" )
end

------------------------------------------------------------------------------------------

function GamePhase.SetCoinViewToHint()
	--spendCoinTextView:SetText( "Hint" )
	Views.TopBar.SpendCoin.Text:SetText( kText_Hint )
	Views.TopBar.SpendCoin:SetTapFunction( "GamePhase.HintPressed" )
	if lBoostThread ~= nil then
		FCKillThread( lBoostThread )
		lBoostThread = nil
		Views.TopBar.SpendCoin.Text:SetTextColor( kBlackColor )
		Views.TopBar.SpendCoin.Text:SetFontWithSize( kGameFont, Layout.TopLineFontSize() )
	end
end

function GamePhase.PlayerSelected( col, row )
	if lTouchesEnabled then
		lLastCol = col
		lLastRow = row
		FCLog( "Player selected tile at " .. col .. " " .. row )
		MSManager.TileSelected( col, row )
		
		lNumMoves = lNumMoves + 1
		
		if lNumMoves == 1 then
			GamePhase.SetCoinViewToHint()
		end
		
		Audio.PlayClick( true )

		GamePhase.SaveGameState()		
	end	
end

------------------------------------------------------------------------------------------

function GamePhase.FlashNumFlagsThread()
	for i = 1,5 do
		Views.TopBar.NumFlags.Text:SetTextColor( kRedColor )
		Views.TopBar.NumFlags.Text:SetFontWithSize( kGameFont, Layout.TopLineFontSize() * 1.5 )
		FCWait( 0.1 )
		Views.TopBar.NumFlags.Text:SetTextColor( kBlackColor )
		Views.TopBar.NumFlags.Text:SetFontWithSize( kGameFont, Layout.TopLineFontSize() )
		FCWait( 0.1 )
	end
end

function GamePhase.PlayerToggledFlag( col, row )
	if lTouchesEnabled then
		if Board.ContentsOfTile( col, row ) == kTileFlagged then
			MSManager.ToggleFlag( col, row )
			Board.SetNumFlagsLeft( Board.GetNumFlagsLeft() + 1 )
			Audio.PlayFlag()
		else
			if Board.GetNumFlagsLeft() > 0 then
				MSManager.ToggleFlag( col, row )
				Board.SetNumFlagsLeft( Board.GetNumFlagsLeft() - 1 )
				Audio.PlayFlag()
			else
				FCNewThread( GamePhase.FlashNumFlagsThread, "flashNumFlags" )
			end
		end
		GamePhase.UpdateNumFlags()
	end
end

------------------------------------------------------------------------------------------

function GamePhase.ReconPressed()

	if lTouchesEnabled then
		Audio.PlayClick()
		FCAnalytics.RegisterEvent( "Boost Pressed" )

		-- recon costs 1 coin
	
		if GetNumCoins() > (kReconCost - 1)then
		
			SetNumCoins( GetNumCoins() - kReconCost )
			GamePhase.UpdateCoinsView()
			
			MSManager.TileSelected( lSonarCol, lSonarRow )
			GamePhase.SetCoinViewToHint()
			
			local boostCount = FCPersistentData.GetNumber( kSaveKey_BoostCount )
			FCPersistentData.SetNumber( kSaveKey_BoostCount, boostCount + 1 )			
		else
			gBuyCoinsSource = "recon"
			Store.LaunchBuyCoins("game")
		end
	end
end

------------------------------------------------------------------------------------------

local lBombLocations = {}

function BombLocation( col, row )
	lBombLocations[ #lBombLocations + 1 ] = { col, row, Board.ContentsOfTile( col, row ) }
end

function GamePhase.HintThread()
	FCLog( "Hint thread" )
	lTouchesEnabled = false
	lBombLocations = {}
	MSManager.BombLocations( "BombLocation" )
	
	for bomb = 1, #lBombLocations do
		info = lBombLocations[ bomb ]
		Board.TileChanged( info[1], info[2], kTileMine )
	end

	FCWait(2)

	for bomb = 1, #lBombLocations do
		info = lBombLocations[ bomb ]
		Board.TileChanged( info[1], info[2], info[3] )
	end
	lTouchesEnabled = true
end

function GamePhase.HintPressed()

	if lTouchesEnabled then

		Audio.PlayClick()
		FCAnalytics.RegisterEvent( "Hint Pressed" )
		if GetNumCoins() > (kHintCost - 1) then
	
			SetNumCoins( GetNumCoins() - kHintCost )
			GamePhase.UpdateCoinsView()
			
			FCNewThread( GamePhase.HintThread, "hint" )
		else
			gBuyCoinsSource = "hint"
			Store.LaunchBuyCoins("game")
		end
	end
end

------------------------------------------------------------------------------------------

function GamePhase.QuitThread()
	GamePhase.ClearGameViews()
	
	FCPhaseManager.AddPhaseToQueue( "FrontEnd" )
	FCPhaseManager.DeactivatePhase( "Game" )
end

function GamePhase.QuitSelected()
	FCLog("QuitSelected")
	Audio.PlayClick()
	FCNewThread( GamePhase.QuitThread, "quit" )
end

------------------------------------------------------------------------------------------

function GamePhase.CompletedGame()	-- completed the full game
end

------------------------------------------------------------------------------------------

function GamePhase.ContinueSelected()
	-- increment level and possibly difficulty
	Audio.PlayClick()

	if FCPersistentData.GetBool( gSaveKeyCompleted ) then
		gCurrentMapNumber = math.random( 1, 99 )
	else
		if gCurrentMapNumber == 100 then
			QuitSelected()
			return
		else
			gCurrentMapNumber = gCurrentMapNumber + 1
		end
	end
	
	GamePhase.WillActivate()
end

------------------------------------------------------------------------------------------

function GamePhase.UpdateNumFlags()
	Views.TopBar.NumFlags.Text:SetText( "" .. Board.GetNumFlagsLeft() )
end

function GamePhase.UpdateCoinsView()
	Views.TopBar.GameCoins.Text:SetText( "" .. GetNumCoins() )
end

------------------------------------------------------------------------------------------

function BuyCoinsFromCoinView()
	Audio.PlayClick()
	gBuyCoinsSource = "coinsView"
	Store.LaunchBuyCoins("game")
end

function GamePhase.FlashBoostThread()
	while true do
		Views.TopBar.SpendCoin.Text:SetTextColor( kGreenColor )
		FCWait( 0.5 )
		Views.TopBar.SpendCoin.Text:SetTextColor( kBlackColor )
		FCWait( 0.5 )
	end
end

function GamePhase.WillActivate()

	Audio.PlayStart()

	if lBoostThread ~= nil then
		FCKillThread( lBoostThread )
		lBoostThread = nil
	end

	if gCurrentMapNumber > 100 then
		gCurrentMapNumber = math.random( 1, 99 )
	end

	FCLog("GamePhase.WillActivate")
	FCLog( "CurrentMapNumber = " .. gCurrentMapNumber )
	if gDifficulty == kGameEasy then
		FCLog( "Difficulty: easy" )
	elseif gDifficulty == kGameMedium then
		FCLog( "Difficulty: medium" )
	elseif gDifficulty == kGameHard then
		FCLog( "Difficulty: hard" )
	else
		FCLog( "Difficulty: easy" )
	end

	if gDifficulty == kGameEasy then
		gNumTreasure = 2
	elseif gDifficulty == kGameMedium then
		gNumTreasure = 2
	elseif gDifficulty == kGameHard then
		gNumTreasure = 1
	else
		gNumTreasure = 0
	end

	AdsOn()

	Layout.SetAdOffset()

	-- Create the map
	LoadMaps()
	mapData = maps[ gCurrentMapNumber ]	
	gNumColumns = mapData["sizeX"]
	gNumRows = mapData["sizeY"]
	gNumBombs = mapData["numBombs"]
	lSonarCol = mapData[ "startCol" ]
	lSonarRow = mapData[ "startRow" ]
	Board.SetNumFlagsLeft( gNumBombs )

	Views.FullBoard.Number:SetText( "" .. gCurrentMapNumber )
	Views.FullBoard.Number:SetAlpha( 1 )
	Views.FullBoard.Number:SetAlpha( 0, 2 )

	if gDifficulty == kGameEasy then
		Views.FullBoard.Difficulty:SetText( kText_Easy )
	elseif gDifficulty == kGameMedium then
		Views.FullBoard.Difficulty:SetText( kText_Medium )
	elseif gDifficulty == kGameHard then
		Views.FullBoard.Difficulty:SetText( kText_Hard )
	else
		Views.FullBoard.Difficulty:SetText( kText_Extreme )
	end
	Views.FullBoard.Difficulty:SetAlpha( 1 )
	Views.FullBoard.Difficulty:SetAlpha( 0, 2 )

	MSManager.CreateGame( gNumColumns, gNumRows, gNumBombs, mapData["seed"], gNumTreasure, lSonarCol, lSonarRow )
	Board.Init( gNumColumns, gNumRows )

	--FCPersistentData.SetNumber( kSaveKey_CurrentDifficulty, gDifficulty )
	
	Views.TopBar:SetFrame( Layout.TopBarFrame() )
	
	Views.TopBar.QuitButton:SetTapFunction( "GamePhase.QuitSelected" )

	Views.TopBar.SpendCoin:SetTapFunction( "GamePhase.ReconPressed" )
	
	Views.TopBar.SpendCoin.Text:SetText( kText_Boost )

	Views.TopBar.Magnify:SetTapFunction( "GamePhase.MagSelected" )
	
	Views.GameOver:SetFrame( GameOverFrame() )
	Views.GameOver:SetAlpha( 0, 0 )

	Views.Recover:SetFrame( RecoverFrame() )
	Views.Recover:SetAlpha( 0, 0 )

	GamePhase.UpdateNumFlags()

	Views.Quit:SetFrame( QuitFrame() )
	Views.Quit:SetAlpha( 0, 0 )
	
	Views.Congratulations:SetFrame( CongratulationsFrame() )
	Views.Congratulations:SetAlpha( 0 )

	Views.Continue:SetFrame( ContinueFrame() )
	Views.Continue:SetAlpha( 0 )

	Views.MainMenu:SetFrame( BackToMainMenuFrame() )
	Views.MainMenu:SetAlpha( 0 )
	
	Views.TopBar.GameCoins.Text:SetText( "" .. GetNumCoins() )
	Views.TopBar.GameCoins:SetTapFunction( "BuyCoinsFromCoinView" )


	-- buy coins view group
	
	Store.InitViews()

	gZoomed = false

	Views.FullBoard:SetFrame( FullBoardFrame() )
	Views.FullBoard:SetTapFunction( "GamePhase.ZoomIn" )
	
	Views.ScrollingBoard:SetFrame( ScrollingBoardFrame() )
	Views.ScrollingBoard:SetTapFunction( "GamePhase.PlayerSelected" )
	Views.ScrollingBoard:SetStringProperty( "pressFunction", "GamePhase.PlayerToggledFlag" )

	Views.FullBoard:SetAlpha( 1 )
	Views.ScrollingBoard:SetAlpha( 0 )
	
	if gMapSize == kMapSizeSmall then
		Views.ScrollingBoard:SetStringProperty( "backgroundImage", "Assets/Images/Grid10x10.png" )
		Views.FullBoard:SetStringProperty( "backgroundImage", "Assets/Images/Grid10x10.png" )
	elseif gMapSize == kMapSizeMedium then	
		Views.ScrollingBoard:SetStringProperty( "backgroundImage", "Assets/Images/Grid15x15.png" )
		Views.FullBoard:SetStringProperty( "backgroundImage", "Assets/Images/Grid15x15.png" )
	elseif gMapSize == kMapSizeLarge then	
		Views.ScrollingBoard:SetStringProperty( "backgroundImage", "Assets/Images/Grid20x20.png" )
		Views.FullBoard:SetStringProperty( "backgroundImage", "Assets/Images/Grid20x20.png" )
	else
		Views.ScrollingBoard:SetStringProperty( "backgroundImage", "Assets/Images/Grid25x25.png" )
		Views.FullBoard:SetStringProperty( "backgroundImage", "Assets/Images/Grid25x25.png" )
	end
	
	-- Initialize the locals
	
	lNumMoves = 0
	lTouchesEnabled = true
	
	FCOnlineAchievement.ReportUnreported()
--	if FCPersistentData.GetNumber( kSaveKey_BoostCount ) < 5 then
	lBoostThread = FCNewThread( GamePhase.FlashBoostThread, "flashBoost")
--	end
end

function GamePhase.IsNowActive()
	FCLog("GamePhase.IsNowActive")
end

function GamePhase.WillDeactivate()
	FCLog("GamePhase.WillDeactivate")
	AdsOff()
end

function GamePhase.IsNowDeactive()
	FCLog("GamePhase.IsNowDeactive")
end

function GamePhase.Update()
end

function TileChanged( col, row, tileType )
	Board.TileChanged( col, row, tileType)
	if tileType == kTileMine then
		GamePhase.PlayerSelectedBomb()
	end
end

function Solved()
	FCLog("SOLVED! ")
	FCNewThread( GamePhase.SolvedThread , "solved" )
	
	local levelNum = 0

	if gDifficulty == kGameEasy then
		if FCPersistentData.GetBool( kSaveKey_CompletedEasy ) == false then
			levelNum = FCPersistentData.GetNumber( kSaveKey_EasyProgress )
			FCOnlineLeaderboard.PostScore( "easyprogress", levelNum + 1 )
			if levelNum == 0 then
				FCOnlineAchievement.SetProgress( kAchievement_UnlockMedium, 1 )
			end
			if levelNum == 99 then
				FCPersistentData.SetBool( kSaveKey_CompletedEasy, true )
			end
			FCOnlineAchievement.SetProgress( kAchievement_AllEasyMaps, (levelNum + 1) / 100 )
			FCPersistentData.SetNumber( kSaveKey_EasyProgress, levelNum + 1 )
		else
			FCOnlineLeaderboard.PostScore( "easyprogress", 100 )
		end
	elseif gDifficulty == kGameMedium then
		if FCPersistentData.GetBool( kSaveKey_CompletedMedium ) == false then
			levelNum = FCPersistentData.GetNumber( kSaveKey_MediumProgress )
			FCOnlineLeaderboard.PostScore( "mediumprogress", levelNum + 1 )
			if levelNum == 0 then
				FCOnlineAchievement.SetProgress( kAchievement_UnlockHard, 1 )
			end
			if levelNum == 99 then
				FCPersistentData.SetBool( kSaveKey_CompletedMedium, true )
			end
			FCOnlineAchievement.SetProgress( kAchievement_AllMediumMaps, (levelNum + 1) / 100 )
			FCPersistentData.SetNumber( kSaveKey_MediumProgress, levelNum + 1)
		else
			FCOnlineLeaderboard.PostScore( "mediumprogress", 100 )
		end
	elseif gDifficulty == kGameHard then
		if FCPersistentData.GetBool( kSaveKey_CompletedHard ) == false then
			levelNum = FCPersistentData.GetNumber( kSaveKey_HardProgress )
			FCOnlineLeaderboard.PostScore( "hardprogress", levelNum + 1 )
			if levelNum == 0 then
				FCOnlineAchievement.SetProgress( kAchievement_UnlockExtreme, 1 )
			end
			if levelNum == 99 then
				FCPersistentData.SetBool( kSaveKey_CompletedHard, true )
			end
			FCOnlineAchievement.SetProgress( kAchievement_AllHardMaps, (levelNum + 1) / 100 )
			FCPersistentData.SetNumber( kSaveKey_HardProgress, levelNum + 1 )
		else
			FCOnlineLeaderboard.PostScore( "hardprogress", 100 )
		end
	else
		if FCPersistentData.GetBool( kSaveKey_CompletedExtreme ) == false then
			levelNum = FCPersistentData.GetNumber( kSaveKey_ExtremeProgress )
			if levelNum == 99 then
				FCPersistentData.SetBool( kSaveKey_CompletedExtreme, true )
			end
			FCOnlineLeaderboard.PostScore( "extremeprogress", levelNum + 1 )
			FCOnlineAchievement.SetProgress( kAchievement_AllExtremeMaps, (levelNum + 1) / 100 )
			FCPersistentData.SetNumber( kSaveKey_ExtremeProgress, levelNum + 1)
		else
			FCOnlineLeaderboard.PostScore( "extremeprogress", 100 )
		end
	end

	-- do some achievements stuff
	
	local lNumSolved = FCPersistentData.GetNumber( kSaveKey_EasyProgress )
	lNumSolved = lNumSolved + FCPersistentData.GetNumber( kSaveKey_MediumProgress )
	lNumSolved = lNumSolved + FCPersistentData.GetNumber( kSaveKey_HardProgress )
	lNumSolved = lNumSolved + FCPersistentData.GetNumber( kSaveKey_ExtremeProgress )
		
	if lNumSolved < 10 then
		FCOnlineAchievement.SetProgress( kAchievement_Solved10Maps, (lNumSolved + 1) / 10 )
	end
	if lNumSolved < 50 then
		FCOnlineAchievement.SetProgress( kAchievement_Solved50Maps, (lNumSolved + 1) / 50 )
	end
	if lNumSolved < 100 then
		FCOnlineAchievement.SetProgress( kAchievement_Solved100Maps, (lNumSolved + 1) / 100 )
	end
	if lNumSolved < 200 then
		FCOnlineAchievement.SetProgress( kAchievement_Solved200Maps, (lNumSolved + 1) / 200 )
	end
	if lNumSolved < 400 then
		FCOnlineAchievement.SetProgress( kAchievement_CompletedGame, (lNumSolved + 1) / 400 )
	end

	FCPersistentData.Save() 
	
	-- process how many games the player has won and award appropriate achievement
end

function CloseFoundTreasure()
	Views.FoundTreasure:SetFrame( FoundTreasureFCRectZero(), 0.2 )
	SetNumCoins( GetNumCoins() + kTreasureNumCoins )
	GamePhase.UpdateCoinsView()
end

function FoundTreasure()
	-- FCLog("Found Treasure")
	-- FCAnalytics.RegisterEvent( "foundTreasure" )
	-- Views.FoundTreasure:SetBackgroundColor( FCColorMake( 0, 1, 0, 1 ) )
	-- Views.FoundTreasure:MoveToFront()
	-- Views.FoundTreasure:SetFrame( FoundTreasureFCRectZero() )
	-- Views.FoundTreasure:SetTapFunction( "CloseFoundTreasure" )

	-- Views.FoundTreasure:SetFrame( FoundTreasureFrame(), 0.2 )
end
