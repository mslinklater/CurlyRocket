-- main.lua

FCLoadScript( "globals" )
FCLoadScript( "config/physics" )

-- Language word tables
locale = FCDevice.GetString("locale")
FCLoadScript( "languages/en" )

FCLoadScript( "frontendphase" )
FCLoadScript( "gamephase" )
FCLoadScript( "levelmanager" )
FCLoadScript( "screenfx" )
FCLoadScript( "misc" )
FCLoadScript( "debug" )
FCLoadScript( "audio" )

function FCApp.ColdBoot()
	FCApp.ShowStatusBar( false )
	FCStats.Inc( "numBoots" )
	FCPersistentData.Save()
	math.randomseed( os.time() )
	FCViewManager.SetScreenAspectRatio( 7, 10 )	-- portrait, mid way between iPad and iPhone
end

function FCApp.WarmBoot()
	InitialiseAudio()
	
	ClickSound = FCAudio.LoadSimpleSound( "Assets/Audio/click" )

	FCPhaseManager.AddPhaseToQueue("FrontEnd")
	SetupScreenFX()

	local numLevels = LevelManager.NumLevels()
	
	-- tutorial is ALWAYS unlocked
	
	local save = false
	
	LevelManager.levels[1]:SetLocked( false )
	
	for i = 2,numLevels do
		local key = "Level" .. i .. "Locked"
		state = FCPersistentData.GetBool( key )
		
		if state == nil then
			state = true
			save = true
			FCPersistentData.SetBool( key, true )
		end
		LevelManager.levels[i]:SetLocked( state )
	end

	if save then
		FCPersistentData.Save()
	end
	
end

function FCApp.WillResignActive()
end

function FCApp.DidBecomeActive()
	FCApp.SetBackgroundColor( Globals.kSepiaColor )
end

function FCApp.DidEnterBackground()
end

function FCApp.WillEnterForeground()
end

function FCApp.WillTerminate()
	ShutdownAudio()
end

function FCApp.SupportsPortrait()
	return true;
end

function FCApp.SupportsLandscape()
	return false;
end
