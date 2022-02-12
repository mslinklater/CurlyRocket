Layout = {}

gAspect = FCDevice.GetFloat( kFCDeviceDisplayAspectRatio )

function Layout.SetAdOffset()
	if gAds then
		Layout.adOffset = 0.1
	else
		Layout.adOffset = 0.0
	end
end

function AspectSize( size )
	return size * gAspect
end

------------------------------------------------------------------------------------------
-- Font sizes
------------------------------------------------------------------------------------------

function Layout.TopLineFontSize()
	return 60
end

function Layout.HowToPlayFontSize()
	return 10
end

function Layout.CoinLabelHeight()
	return 20
end

------------------------------------------------------------------------------------------
-- In-game
------------------------------------------------------------------------------------------


-- Title

function TitleViewFrame()
	return FCRectMake( 0.05, 0.03, 0.9, AspectSize(0.32) )
end

-- Game mode buttons

function Layout.MainButtonFrame( button, phase )
	local lYPos

	local def = {
		kLayout3by2 = { width = 0.9, height = AspectSize( 0.15 ) },
		kLayout4by3 = { width = 0.8, height = AspectSize( 0.1 ) },
		kLayout16by9 = { width = 0.9, height = AspectSize( 0.15 ) }
	}

	local lWidth = def[Layout.active].width
	local lHeight = def[Layout.active].height
	
	if button == Views.Easy then
		lYPos = 0.3
	elseif button == Views.Medium then
		lYPos = 0.4
	elseif button == Views.Hard then
		lYPos = 0.5
	else
		lYPos = 0.6
	end

	if phase == kViewPhaseEnter then
		return FCRectMake( (1 - lWidth) * 0.5, lYPos, lWidth, lHeight )
	elseif phase == kViewPhaseOn then
		return FCRectMake( (1 - lWidth) * 0.5, lYPos, lWidth, lHeight )
	else
		return FCRectMake( (1 - lWidth) * 0.5, lYPos, lWidth, lHeight )
	end
end

-- Top Bar

function Layout.TopBarFrame()
	return FCRectMake( 0, Layout.adOffset, 1, AspectSize( 0.133) )
end

-- Number of Coins

function NumCoinsViewFrame()
	return FCRectMake( 0.7, 0.85, 0.2, AspectSize(0.2) )
end

-- Volume

function VolumeViewFrame()
	return FCRectMake( 0.45, 0.875, 0.1, AspectSize(0.1) )
end

-- Curly Rocket Button

function CurlyRocketViewFrame()
	return FCRectMake( 0.1, 0.85, 0.2, AspectSize(0.2) )
end

function CurlySquareFrame()
	return FCRectMake( 0.1, 0.1, 0.8, AspectSize(0.4) )
end

------------------------------------------------------------------------------------------
-- How To Play
------------------------------------------------------------------------------------------

function HowToPlayNextFrame()
	return FCRectMake( 0.8, 1 - AspectSize( 0.1 ), 0.2, AspectSize(0.1) )
end

function HowToPlayPrevFrame()
	return FCRectMake( 0.0, 1 - AspectSize( 0.1 ), 0.2, AspectSize(0.1) )
end

--

function HowToPlayFrameHeight()
	if Layout.active == kLayout3by2 then
		return AspectSize(0.4)
	elseif Layout.active == kLayout4by3 then
		return AspectSize(0.35)
	else
		return AspectSize(0.4)
	end
end

function HowToPlayTopFrame()
	return FCRectMake( 0.0, 0.05, 1, HowToPlayFrameHeight() )
end
function HowToPlayTopLeftFrame()
	return FCRectMake( -1.0, 0.05, 1, HowToPlayFrameHeight() )
end
function HowToPlayTopRightFrame()
	return FCRectMake( 1.0, 0.05, 1, HowToPlayFrameHeight() )
end

function HowToPlayMiddleFrame()
	return FCRectMake( 0, 0.35, 1, HowToPlayFrameHeight() )
end
function HowToPlayMiddleLeftFrame()
	return FCRectMake( -1, 0.35, 1, HowToPlayFrameHeight() )
end
function HowToPlayMiddleRightFrame()
	return FCRectMake( 1, 0.35, 1, HowToPlayFrameHeight() )
end

function HowToPlayBottomFrame()
	return FCRectMake( 0, 0.65, 1, HowToPlayFrameHeight() )
end
function HowToPlayBottomLeftFrame()
	return FCRectMake( -1, 0.65, 1, HowToPlayFrameHeight() )
end
function HowToPlayBottomRightFrame()
	return FCRectMake( 1, 0.65, 1, HowToPlayFrameHeight() )
end

------------------------------------------------------------------------------------------
-- In-game
------------------------------------------------------------------------------------------

local ninth = 1 / 9

-- numflagsflag

function NumFlagsFrame()
	return FCRectMake( ninth * 4, Layout.adOffset + (ninth * 0.1), ninth, AspectSize( ninth * 0.8 ) )
end

-- boards

function FullBoardFrame()

	local availableHeight = 1 - (Layout.adOffset + AspectSize( 0.133 ) )
	local heightOfBoard = AspectSize( 0.9 )
	local offset = ( availableHeight - heightOfBoard ) / 2

	return FCRectMake( 0.05, Layout.adOffset + AspectSize( 0.133 ) + offset, 0.9, AspectSize(0.9) )
end

function ScrollingBoardFrame()
	return FCRectMake( 0.0, Layout.adOffset + AspectSize(0.133), 1.0, 1 - AspectSize(0.133) - Layout.adOffset )
end

-- end game menu

function GameOverFrame()
	return FCRectMake( 0.1, 0.25, 0.8, AspectSize( 0.2 ) )
end

function RecoverFrame()
	return FCRectMake( 0.1, 0.5, 0.8, AspectSize( 0.2 ) )
end

function QuitFrame()
	return FCRectMake( 0.1, 0.7, 0.8, AspectSize( 0.2 ) )
end

function CongratulationsFrame()
	return FCRectMake( 0.1, 0.4, 0.8, AspectSize( 0.2 ) )
end

function BackToMainMenuFrame()
	return FCRectMake( 0.1, 0.6, 0.8, AspectSize( 0.2) )
end

function ContinueFrame()
	return FCRectMake( 0.1, 0.8, 0.8, AspectSize( 0.2 ) )
end

function FoundTreasureFrame()
	return FCRectMake( 0, 0, 1, 1 )
end

function FoundTreasureFCRectZero()
	return FCRectMake( 0.5, 0.5, 0, 0 )
end

------------------------------------------------------------------------------------------
-- buy coins
------------------------------------------------------------------------------------------

function BuyCoinsBackgroundFrame()
	return FCRectMake( 0.0, 0.0, 1.0, 1.0 )
end

function BuyCoinsInfoFrame()
	return FCRectMake( 0.05, 0.6, 0.9, AspectSize(0.133) )
end

function QuitBuyCoinsFrame()
	return FCRectMake( 0, 0, 0.2, AspectSize(0.133) )
end

function LikeForCoinsFrame()
	return FCRectMake( 0.05, 0.2, 0.9, AspectSize(0.15) )
end

function BuyCoinsYOffset()
	if FCPersistentData.GetBool( kSaveKey_HasLiked ) == true then
		return -0.1
	else
		return 0.0
	end
end

function BuyCoins1Frame()
	return FCRectMake( 0.05, 0.4 + BuyCoinsYOffset(), 0.9, AspectSize(0.15) )
end

function BuyCoins1FrameHidden()
	return FCRectMake( 1.05, 0.4 + BuyCoinsYOffset(), 0.9, AspectSize(0.15) )
end

function BuyCoins2Frame()
	return FCRectMake( 0.05, 0.6 + BuyCoinsYOffset(), 0.9, AspectSize(0.15) )
end

function BuyCoins2FrameHidden()
	return FCRectMake( -0.95, 0.6 + BuyCoinsYOffset(), 0.9, AspectSize(0.15) )
end

function BuyCoins3Frame()
	return FCRectMake( 0.05, 0.8 + BuyCoinsYOffset(), 0.9, AspectSize(0.15) )
end

function BuyCoins3FrameHidden()
	return FCRectMake( 1.05, 0.8 + BuyCoinsYOffset(), 0.9, AspectSize(0.15) )
end

function PurchaseResponseFrame()
	return FCRectMake( 0.0, 0.5 - AspectSize( 0.1 ), 1.0, AspectSize(0.2) )
end

