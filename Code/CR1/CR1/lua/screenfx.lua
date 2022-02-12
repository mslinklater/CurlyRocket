
BackgroundPictures = {
	--"Imported/background1.jpg",
	--"Imported/background2.jpg",
	"Imported/1.jpg",
	"Imported/2.jpg",
	"Imported/3.jpg",
	"Imported/4.jpg",
	"Imported/5.jpg",
	"Imported/6.jpg",
	"Imported/7.jpg",
	"Imported/8.jpg",
	"Imported/9.jpg",
	"Imported/10.jpg",
	"Imported/11.jpg",
	--"Imported/background3.jpg",
	--"Imported/background4.jpg",
	--"Imported/background5.jpg",
	--"Imported/background6.jpg",
	--"Imported/background7.jpg",
	--"Imported/background8.jpg",
	--"Imported/background9.jpg"
}

function KenBurnsThread()
	local imageNum = 1
	ScreenFX.SetNextBackgroundImage( BackgroundPictures[1])
	ScreenFX.StartBackgroundPan(20)
	while true do
		FCWait(4)

		local newImageNum
		repeat
			newImageNum = math.random() * #BackgroundPictures
			newImageNum = newImageNum - (newImageNum % 1)
			newImageNum = newImageNum + 1
		until newImageNum ~= imageNum
		
		imageNum = newImageNum

		ScreenFX.SetNextBackgroundImage( BackgroundPictures[imageNum])
		FCWait(4)
		ScreenFX.StartBackgroundPan(20)
	end
end

function FilmNoiseThread()
	while true do
		FCWait(0)
	end
end

function SetupScreenFX()
	ScreenFX.AddPictureToBackground( BackgroundPictures[1], false )
	for iPic=2,#BackgroundPictures,1 do
		ScreenFX.AddPictureToBackground( BackgroundPictures[iPic], true )
	end
	
	FCNewThread( KenBurnsThread )
	FCNewThread( FilmNoiseThread )
end
