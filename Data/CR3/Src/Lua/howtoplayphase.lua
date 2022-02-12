local lPageNum = 0

local kNext = 1
local kPrev = 2

local kLeft = 1
local kCenter = 2
local kRight = 3



function TopFrame( side )
	if side == kLeft then
		return HowToPlayTopLeftFrame()
	elseif side == kRight then
		return HowToPlayTopRightFrame()
	else
		return HowToPlayTopFrame()
	end
end

function MiddleFrame( side )
	if side == kLeft then
		return HowToPlayMiddleLeftFrame()
	elseif side == kRight then
		return HowToPlayMiddleRightFrame()
	else
		return HowToPlayMiddleFrame()
	end
end

function BottomFrame( side )
	if side == kLeft then
		return HowToPlayBottomLeftFrame()
	elseif side == kRight then
		return HowToPlayBottomRightFrame()
	else
		return HowToPlayBottomFrame()
	end
end

------------------------------------------------------------------------------------------

local views = {
	{ Views.HTP1Text1, Views.HTP1Image, Views.HTP1Text2 },
	{ Views.HTP2Image1, Views.HTP2Text, Views.HTP2Image2 },
	{ Views.HTP3Text, Views.HTP3Image1, Views.HTP3Image2 },
	{ Views.HTP4Image1, Views.HTP4Image2, Views.HTP4Text },
	{ Views.HTP5Text, Views.HTP5Image1, Views.HTP5Image2 },
	{ Views.HTP7Image1, Views.HTP7Text, Views.HTP7Image2 },
	{ Views.HTP8Text, Views.HTP8Image1, Views.HTP8Image2 },
	{ Views.HTP9Image1, Views.HTP9Text, Views.HTP9Image2 },
	{ Views.HTP10Image1, Views.HTP10Image2, Views.HTP10Text },
	{ Views.HTP11Text1, Views.HTP11Text2, Views.HTP11Image },
	{ Views.HTP12Image1, Views.HTP12Text, Views.HTP12Image2 }
}

function ShowPage( dir )

	local lShowSpeed1 = 0.2
	local lShowSpeed2 = 0.3
	local lShowSpeed3 = 0.4

	if dir == kNext then
		enter = kRight
	else
		enter = kLeft
	end


	views[lPageNum][1]:SetFrame( TopFrame( enter ) )
	views[lPageNum][1]:SetFrame( TopFrame( kCenter ), lShowSpeed1 )
	views[lPageNum][2]:SetFrame( MiddleFrame( enter ) )
	views[lPageNum][2]:SetFrame( MiddleFrame( kCenter ), lShowSpeed2 )
	views[lPageNum][3]:SetFrame( BottomFrame( enter ) )
	views[lPageNum][3]:SetFrame( BottomFrame( kCenter ), lShowSpeed3 )				

	for i = 1,3 do
		if views[lPageNum][i].viewType == kFCTextView then
			views[lPageNum][i]:ShrinkFontToFit()
		end
	end

	if lPageNum == 1 then
		Views.HTPPrev:SetFrame( FCRectZero() )
	end

	if lPageNum == 2 then
		Views.HTPPrev:SetFrame( HowToPlayPrevFrame() )
	end
	
end

------------------------------------------------------------------------------------------

function HidePage( dir )

	local lHideSpeed = 0.15

	if dir == kNext then
		exit = kLeft
	else
		exit = kRight
	end

	views[lPageNum][1]:SetFrame( TopFrame( exit ), lHideSpeed )
	views[lPageNum][2]:SetFrame( MiddleFrame( exit ), lHideSpeed )
	views[lPageNum][3]:SetFrame( BottomFrame( exit ), lHideSpeed )

end

------------------------------------------------------------------------------------------

function QuitThread()
	FCPhaseManager.AddPhaseToQueue( "FrontEnd" )
	FCPhaseManager.DeactivatePhase( "HowToPlay" )
end

function NextPressed()
	Audio.PlayClick()

	if lPageNum < 11 then
		HidePage( kNext )
		lPageNum = lPageNum + 1
		ShowPage( kNext )
	else
		FCNewThread( QuitThread )
	end
end

function PrevPressed()
	Audio.PlayClick()
	if lPageNum > 1 then
		HidePage( kPrev )
		lPageNum = lPageNum - 1
		ShowPage( kPrev )
	end
end

------------------------------------------------------------------------------------------

HowToPlayPhase = {}

function HowToPlayPhase.WillActivate()
	FCLog("HowToPlayPhase.WillActivate")
end


function HowToPlayPhase.IsNowActive()

	local HTPTextViews = {
		{ v = Views.HTP1Text1, t = kText_HTP1a },
		{ v = Views.HTP1Text2, t = kText_HTP1b },
		{ v = Views.HTP2Text, t = kText_HTP2 },
		{ v = Views.HTP3Text, t = kText_HTP3 },
		{ v = Views.HTP4Text, t = kText_HTP4 },
		{ v = Views.HTP5Text, t = kText_HTP5 },
		{ v = Views.HTP7Text, t = kText_HTP7 },
		{ v = Views.HTP8Text, t = kText_HTP8 },
		{ v = Views.HTP9Text, t = kText_HTP9 },
		{ v = Views.HTP10Text, t = kText_HTP10 },
		{ v = Views.HTP11Text1, t = kText_HTP11a },
		{ v = Views.HTP11Text2, t = kText_HTP11b },
		{ v = Views.HTP12Text, t = kText_HTP12 }		
	}

	local HTPImageViews = {
		{ v = Views.HTP1Image, i = "Assets/Images/HTPBoard1.png" },
		{ v = Views.HTP2Image1, i = "Assets/Images/HTPBoard2a.png" },
		{ v = Views.HTP2Image2, i = "Assets/Images/HTPBoard2b.png" },
		{ v = Views.HTP3Image1, i = "Assets/Images/HTPBoard3a.png" },
		{ v = Views.HTP3Image2, i = "Assets/Images/HTPBoard3b.png" },
		{ v = Views.HTP4Image1, i = "Assets/Images/HTPBoard4a.png" },
		{ v = Views.HTP4Image2, i = "Assets/Images/HTPBoard4b.png" },
		{ v = Views.HTP5Image1, i = "Assets/Images/HTPBoard5a.png" },
		{ v = Views.HTP5Image2, i = "Assets/Images/HTPBoard5b.png" },
		{ v = Views.HTP7Image1, i = "Assets/Images/HTPBpard7a.png" },
		{ v = Views.HTP7Image2, i = "Assets/Images/HTPBoard7b.png" },
		{ v = Views.HTP8Image1, i = "Assets/Images/HTPBoard8a.png" },
		{ v = Views.HTP8Image2, i = "Assets/Images/HTPBoard8b.png" },
		{ v = Views.HTP9Image1, i = "Assets/Images/HTPBoard9a.png" },
		{ v = Views.HTP9Image2, i = "Assets/Images/HTPBoard9b.png" },
		{ v = Views.HTP10Image1, i = "Assets/Images/HTPBoard10a.png" },
		{ v = Views.HTP10Image2, i = "Assets/Images/HTPBoard10b.png" },
		{ v = Views.HTP11Image, i = "Assets/Images/HTPBoard11.png" },
		{ v = Views.HTP12Image1, i = "Assets/Images/HTPBoard12a.png" },
		{ v = Views.HTP12Image2, i = "Assets/Images/HTPBoard12b.png"}
	}

	FCLog("HowToPlayPhase.IsNowActive")
	
	Views.HTPNext:SetFrame( HowToPlayNextFrame() )
	Views.HTPNext:SetTapFunction( "NextPressed" )
	
	Views.HTPPrev:SetFrame( FCRectZero() )
	Views.HTPPrev:SetTapFunction( "PrevPressed" )
	
	lPageNum = 1

	for _, entry in ipairs( HTPTextViews ) do
		entry.v:SetText( entry.t )
		entry.v:SetFontWithSize( kGameFont, Layout.HowToPlayFontSize() )
		entry.v:SetTextAlignment( kFCViewTextAlignmentCenter )
	end

	for _, entry in ipairs( HTPImageViews ) do
		entry.v:SetImage( entry.i )
		entry.v:SetContentMode( kFCViewContentModeScaleAspectFit )
	end
	
	ShowPage( kNext )	
end

function HowToPlayPhase.WillDeactivate()
	FCLog("HowToPlayPhase.WillDeactivate")
	Views.HTPPrev:SetFrame( FCRectZero() )
	--htpPrevTextView:SetFrame( FCRectZero() )
	Views.HTPNext:SetFrame( FCRectZero() )
	--htpNextTextView:SetFrame( FCRectZero() )
	HidePage( kNext )
end

function HowToPlayPhase.IsNowDeactive()
	FCLog("HowToPlayPhase.IsNowDeactive")
end

function HowToPlayPhase.Update()
end
