
-- Title

function TitleHiddenPos()
	return {1.0, 0.10, 1.0, 0.13}
end

function TitleVisiblePos()
	return {0, 0.10, 1.0, 0.13}
end

-- Quit button - in GameAppDelegate

function QuitButtonHiddenPos()
	return { -0.2, 0.1, 0.142, 0.1 }
end

function QuitButtonVisiblePos()
	return { 0.0, 0.1, 0.142, 0.1 }
end

-- Score

local scoreBoxWidth = 0.6
local scoreBoxHeight = 0.1

function ScoreHiddenPos()
	return {0.5 - (scoreBoxWidth / 2), -0.2, scoreBoxWidth, scoreBoxHeight}
--	return {1.1, 0.10, scoreBoxWidth, scoreBoxHeight}
end

function ScoreVisiblePos()
	return {0.5 - (scoreBoxWidth / 2), 0.10, scoreBoxWidth, scoreBoxHeight}
end

function ScoreCentralPos()
	return { 0.5 - (scoreBoxWidth / 2), 0.3, scoreBoxWidth, scoreBoxHeight }
end

function ClockHiddenPos()
	return { 1.1, 0.15, 0.15, scoreBoxHeight }
end

function ClockVisiblePos()
	return { 0.85, 0.1, 0.15, scoreBoxHeight }
end

-- Play buttons

local quadButtonWidth = 0.5
local quadButtonHeight = 0.35

local sixButtonWidth = 0.357
local sixButtonHeight = 0.25

function GreenHiddenPos()
	if GameAppDelegate.GameType() == kSixGame then
		return { -0.5, 0.25, sixButtonWidth, sixButtonHeight }
	else
		return { -0.5, 0.25, quadButtonWidth, quadButtonHeight }
	end
end

function GreenVisiblePos()
	if GameAppDelegate.GameType() == kSixGame then
		return { 0.5 - sixButtonWidth, 0.25, sixButtonWidth, sixButtonHeight }
	else
		return { 0, 0.25, quadButtonWidth, quadButtonHeight }
	end
end

function RedHiddenPos()
	if GameAppDelegate.GameType() == kSixGame then
		return { 1.0, 0.25, sixButtonWidth, sixButtonHeight }
	else
		return { 1.0, 0.25, quadButtonWidth, quadButtonHeight }
	end
end

function RedVisiblePos()
	if GameAppDelegate.GameType() == kSixGame then
		return { 0.5, 0.25, sixButtonWidth, sixButtonHeight }
	else
		return { 0.5, 0.25, quadButtonWidth, quadButtonHeight }
	end
end

function YellowHiddenPos()
	if GameAppDelegate.GameType() == kSixGame then
		return { -0.5, 0.75, sixButtonWidth, sixButtonHeight }
	else
		return { -0.5, 0.6, quadButtonWidth, quadButtonHeight }
	end
end

function YellowVisiblePos()
	if GameAppDelegate.GameType() == kSixGame then
		return { 0.5 - sixButtonWidth, 0.75, sixButtonWidth, sixButtonHeight }
	else
		return { 0, 0.6, quadButtonWidth, quadButtonHeight }
	end
end

function BlueHiddenPos()
	if GameAppDelegate.GameType() == kSixGame then
		return { 1.0, 0.75, sixButtonWidth, sixButtonHeight }
	else
		return { 1.0, 0.6, quadButtonWidth, quadButtonHeight }
	end
end

function BlueVisiblePos()
	if GameAppDelegate.GameType() == kSixGame then
		return { 0.50, 0.75, sixButtonWidth, sixButtonHeight }
	else
		return { 0.5, 0.6, quadButtonWidth, quadButtonHeight }
	end
end

function MagentaHiddenPos()
	return { 1.0, 0.5, sixButtonWidth, sixButtonHeight }
end

function MagentaVisiblePos()
	return { 0.5, 0.5, sixButtonWidth, sixButtonHeight }
end

function CyanHiddenPos()
	return { -0.5, 0.5, sixButtonWidth, sixButtonHeight }
end

function CyanVisiblePos()
	return { 0.5 - sixButtonWidth, 0.5, sixButtonWidth, sixButtonHeight }
end
