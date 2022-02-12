-- globals

Globals = {}

gMusicVolume = 0
gSFXVolume = 0

function Globals.AppName()
--	if FCBuild.Debug() then
		return "CR1"
--	else
--		return "TopplePop"
--	end
end

function Globals.AddsActive()
	numGames = FCStats.Get("numGamesStarted")
	if numGames == nil then
		return false
	end
	return numGames > 2
end

Globals.kSepiaColor = { 0.94, 0.86, 0.51, 1 }

-- These need to be in sync with the enum in BallActor.h

kRedBall = 1
kBlueBall = 2
kGreenBall = 3
kYellowBall = 4

kLowGem = 1
kMediumGem = 2
kHighGem = 3
kSuperGem = 4

kLevelTypeNormal = 1
kLevelTypeTimed = 2
kLevelTypeBlitz = 3
