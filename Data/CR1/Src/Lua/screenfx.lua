
BackgroundPictures = {
	--"Imported/background1.jpg",
	--"Imported/background2.jpg",
	"Assets/Images/1.jpg",
	"Assets/Images/2.jpg",
	"Assets/Images/3.jpg",
	"Assets/Images/4.jpg",
	"Assets/Images/5.jpg",
	"Assets/Images/6.jpg",
	"Assets/Images/7.jpg",
	"Assets/Images/8.jpg",
	"Assets/Images/9.jpg",
	"Assets/Images/10.jpg",
	"Assets/Images/11.jpg",
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
