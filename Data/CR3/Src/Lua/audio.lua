Audio = {}

local clickBuffer
local clickSource

local yayBuffer
local yaySource

local booBuffer
local booSource

local flagBuffer
local flagSource

local startBuffer
local startSource

local volume

-- move noise
-- music

function Audio.Initialize()
	clickBuffer = FCAudio.CreateBuffer( "Assets/Audio/click" )
	clickSource = FCAudio.PrepareSourceWithBuffer( clickBuffer, true )
	yayBuffer = FCAudio.CreateBuffer( "Assets/Audio/yay" )
	yaySource = FCAudio.PrepareSourceWithBuffer( yayBuffer, true )
	booBuffer = FCAudio.CreateBuffer( "Assets/Audio/boo" )
	booSource = FCAudio.PrepareSourceWithBuffer( booBuffer, true )
	flagBuffer = FCAudio.CreateBuffer( "Assets/Audio/flag" )
	flagSource = FCAudio.PrepareSourceWithBuffer( flagBuffer, true )
	startBuffer = FCAudio.CreateBuffer( "Assets/Audio/start" )
	startSource = FCAudio.PrepareSourceWithBuffer( startBuffer, true )

	volume = FCPersistentData.GetNumber( kSaveKey_Volume ) / 3
end

function Audio.Shutdown()
	FCAudio.SourceStop( clickSource )
	FCAudio.DeleteSource( clickSource )
	FCAudio.DeleteBuffer( clickBuffer )

	FCAudio.SourceStop( yaySource )
	FCAudio.DeleteSource( yaySource )
	FCAudio.DeleteBuffer( yayBuffer )

	FCAudio.SourceStop( booSource )
	FCAudio.DeleteSource( booSource )
	FCAudio.DeleteBuffer( booBuffer )

	FCAudio.SourceStop( flagSource )
	FCAudio.DeleteSource( flagSource )
	FCAudio.DeleteBuffer( flagBuffer )

	FCAudio.SourceStop( startSource )
	FCAudio.DeleteSource( startSource )
	FCAudio.DeleteBuffer( startBuffer )
end

function Audio.PlayClick( quiet )
	if quiet == true then
		FCAudio.SourceSetVolume( clickSource, 0.5 * volume )
		FCAudio.SourcePlay( clickSource )
	else
		FCAudio.SourceSetVolume( clickSource, 1.0 * volume )
		FCAudio.SourcePlay( clickSource )
	end
end

function Audio.PlayYay()
	FCAudio.SourceSetVolume( yaySource, volume )
	FCAudio.SourcePlay( yaySource )
end

function Audio.PlayBoo()
	FCAudio.SourceSetVolume( booSource, volume )
	FCAudio.SourcePlay( booSource )
end

function Audio.PlayStart()
	FCAudio.SourceSetVolume( startSource, volume )
	FCAudio.SourcePlay( startSource )
end

function Audio.PlayFlag()
	FCAudio.SourceSetVolume( flagSource, 0.5 * volume )
	FCAudio.SourcePlay( flagSource )
end

function Audio.SetVolumeIcon()
	local vol = FCPersistentData.GetNumber( kSaveKey_Volume )
	if vol == 0 then
		Views.Volume:SetImage("Assets/Images/Volume_0.png")
	elseif vol == 1 then
		Views.Volume:SetImage("Assets/Images/Volume_1.png")
	elseif vol == 2 then
		Views.Volume:SetImage("Assets/Images/Volume_2.png")
	elseif vol == 3 then
		Views.Volume:SetImage("Assets/Images/Volume_3.png")
	end
end

function Audio.AlterVolume()
	local vol = FCPersistentData.GetNumber( kSaveKey_Volume )
	FCLog("old vol" .. vol)
	vol = vol + 1
	if vol > 3 then
		vol = 0
	end
	if vol < 0 then
		vol = 0
	end
	FCLog("new vol" .. vol)
	volume = vol / 3
	FCPersistentData.SetNumber( kSaveKey_Volume, vol )

	Audio.SetVolumeIcon()
	Audio.PlayClick()
end
