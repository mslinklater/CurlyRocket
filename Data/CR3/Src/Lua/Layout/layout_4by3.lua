Layout.active = kLayout4by3

-- iPad

function Layout.SetAdOffset()
	if gAds then
		Layout.adOffset = 50 / 768
	else
		Layout.adOffset = 0.0
	end
end

function Layout.HowToPlayFontSize()
	return 50
end

function Layout.MenuButtonFontHeight()
	return 60
end

function HowToPlayViewFrame()
	return FCRectMake( 0.2, 0.75, 0.6, AspectSize( 0.1 ) )
end
