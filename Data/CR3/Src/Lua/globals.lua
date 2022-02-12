-- Constants

kGameEasy = 1
kGameMedium = 2
kGameHard = 3
kGameExtreme = 4

kMapSizeSmall = 1
kMapSizeMedium = 2
kMapSizeLarge = 3
kMapSizeExtreme = 4

kTileHidden = 1
kTileFlagged = 2
kTileNumber1 = 3
kTileNumber2 = 4
kTileNumber3 = 5
kTileNumber4 = 6
kTileNumber5 = 7
kTileNumber6 = 8
kTileNumber7 = 9
kTileNumber8 = 10
kTileMine = 11
kTileEmpty = 12
kTileUnused = 13
kTileTreasure = 14

kReconCost = 1
kHintCost = 2
kUndoCost = 3
kTreasureNumCoins = 5

kGameFont = "Foo"

-- Achievements

kAchievement_UnlockMedium = "unlockmedium"
kAchievement_UnlockHard = "unlockhard"
kAchievement_UnlockExtreme = "unlockextreme"
kAchievement_Solved10Maps = "solved10maps"
kAchievement_Solved50Maps = "solved50maps"
kAchievement_Solved100Maps = "solved100maps"
kAchievement_Solved200Maps = "solved200maps"
kAchievement_AllEasyMaps = "alleasymaps"
kAchievement_AllMediumMaps = "allmediummaps"
kAchievement_AllHardMaps = "allhardmaps"
kAchievement_AllExtremeMaps = "allextrememaps"
kAchievement_CompletedGame = "completedgame"

function StringForTileType( tile )
	if tile == kTileHidden then
		return "hidden"
	elseif tile == kTileFlagged then
		return "flagged"
	elseif tile == kTileNumber1 then
		return "1"
	elseif tile == kTileNumber2 then
		return "2"
	elseif tile == kTileNumber3 then
		return "3"
	elseif tile == kTileNumber4 then
		return "4"
	elseif tile == kTileNumber5 then
		return "5"
	elseif tile == kTileNumber6 then
		return "6"
	elseif tile == kTileNumber7 then
		return "7"
	elseif tile == kTileNumber8 then
		return "8"
	elseif tile == kTileMine then
		return "mine"
	elseif tile == kTileEmpty then
		return "empty"
	elseif tile == kTileTreasure then
		return "treasure"
	elseif tile == kTileUnused then
		return "unused"
	else
		return "flagged"
	end
end

function GetNumCoins()
	return FCPersistentData.GetNumber( kSaveKey_NumCoins )
end
function SetNumCoins( numCoins )
	FCPersistentData.SetNumber( kSaveKey_NumCoins, numCoins )
	FCPersistentData.Save()
	
	Views.TopBar.GameCoins.Text:SetFrame( FCRectMake(0,0,1,1) )
	Views.TopBar.GameCoins.Text:SetFrame( FCRectMake(0.1,0.1,0.8,0.8), 0.2 )
	
	Views.NumCoins.Text:SetText("" .. numCoins )
	Views.TopBar.GameCoins.Text:SetText("" .. numCoins )
end

-- Objects

vm = FCViewManager

-- Globals

gMapSize = nil
gNumBombs = nil
gNumColumns = nil
gNumRows = nil
gCurrentMapNumber = nil
gDifficulty = nil

gZoomed = nil
gAds = nil
gNumTreasure = nil
gBuyCoinsSource = nil
gSaveKeyCompleted = nil


kViewModeBegin = 1
kViewModeOn = 2
kViewModeOff = 3

