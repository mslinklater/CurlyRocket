Layout.active = kLayout3by2

function Layout.SetAdOffset()
	if gAds then
		Layout.adOffset = 0.1
	else
		Layout.adOffset = 0.0
	end
end
function Layout.HowToPlayFontSize()
	return 20
end

function Layout.MenuButtonFontHeight()
	return 25
end

function Layout.TopLineFontSize()
	return 20
end

local lMainButtonHeight = 0.15
local lMainButtonWidth = 0.9

function HowToPlayViewFrame()
	return FCRectMake( 0.2, 0.75, 0.6, AspectSize( 0.1 ) )
end
