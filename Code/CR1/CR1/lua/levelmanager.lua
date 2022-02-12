-- levelmanager

currentLevel = {}

LevelManager = {}
LevelManager.levels = {}

kLevelTypeTimed = 1
kLevelTypeNormal = 2
kLevelTypeBlitz = 3

function LevelManager.AddLevel( level )

	if DEBUG then
		assert( level:Year() )
		assert( level:Description() )
		assert( level:WikiLink() )
		assert( level:World() )
	end

	levelid = level:Id()
	LevelManager.levels[ levelid ] = level
end

function LevelManager.WorldResource()
	return Level:World().resource
end

function LevelManager.NumLevels()
	return #LevelManager.levels
end

function LevelManager.NameForId( id )
	return LevelManager.levels[ id ]:Name()
end

function LevelManager.TypeForId( id )
	return LevelManager.levels[ id ]:Type()
end

function LevelManager.DateForId( id )
	return LevelManager.levels[ id ]:Year()
end

function LevelManager.WikiForId( id )
	return LevelManager.levels[ id ]:WikiLink()
end

function LevelManager.HighScoreForId( id )
	levelName = LevelManager.NameForId( id )
	return FCPersistentData.GetNumber( levelName .. "highscore" )
end

function LevelManager.GetLevelWithId( levelid )
	return LevelManager.levels[ levelid ]
end

function LevelManager.SelectLevel( levelid )
	--FCLog("LevelManager.SelectLevel " .. levelid)
	
	-- find index of selected level (levelButtonx)

	local lbpos
	local lbend

	lbpos, lbend = string.find( levelid, "levelButton" )

	local levelnum = string.sub( levelid, lbend + 1 )
	
	currentLevel = LevelManager.levels[ tonumber(levelnum) ]
	
	--FCLog( "Level.worldResource = " .. Level.world.resource )

	-- Kick off game phase
	FCPhaseManager.AddPhaseToQueue( "Game" )
	FCPhaseManager.DeactivatePhase( "FrontEnd" )
	FCAnalytics.RegisterEvent( "Selected level: " .. currentLevel:Name() )
end

function LevelManager.UnlockLevel( levelid )
	LevelManager.levels[ levelid ]:SetLocked( false )
	FCPersistentData.SetBool( "Level" .. levelid .. "Locked", false )
	FCPersistentData.Save()
end

-- Balls

local activeBalls = {}	-- should be a set

function LevelManager.CreateBall( color, x, y )
	local hBall = Game.CreateBall( color, x, y )
	activeBalls[ hBall ] = color;
	return hBall
end

function LevelManager.DestroyBall( hBall )
	activeBalls[ hBall ] = nil
	Game.DestroyBall( hBall )
end

function LevelManager.DestroyBalls( )
	for h in pairs( activeBalls ) do
		--Game.DestroyBall( activeBalls[ h ] )
		Game.DestroyBall( h )
	end
	activeBalls = {}
end

function LevelManager.ColorOfBallWithHandle( hBall )
	return activeBalls[ hBall ]
end

-- Bombs

local activeBombs = {}	-- should be a set

function BombThread( h, time )
	FCWaitGame( time )
	-- blow up
	LevelManager.DetonateBomb( h )
end

function LevelManager.CreateBomb( time, x, y )
	local hBomb = Game.CreateBomb( time, x, y )
	local bombThread = FCNewThread( BombThread, hBomb, time )
	activeBombs[ hBomb] = bombThread
	return hBomb
end

function LevelManager.DestroyBombs( )
	for h, threadid in pairs( activeBombs ) do
		FCKillThread( threadid )
		Game.DestroyBomb( h )
	end
	activeBombs = {}
end

function LevelManager.DestroyBomb( h )
	activeBombs[ h ] = nil
	Game.DestroyBomb( h )
end

function LevelManager.DetonateBomb( h )
	-- do the detonation bit

	FCLog( "detonating" )
	
	bx, by = FCActorSystem.GetPosition( h )
	
	-- go through gems 
	
	if activeGems ~= nil then
		for g in pairs( activeGems ) do
			local gx, gy = FCActorSystem.GetPosition( g )
			
			diffX = bx - gx
			diffY = by - gy
			
			distance = math.sqrt( diffX * diffX + diffY * diffY )
			
			force = 10 - distance	-- tweaks here
			
			axisX = diffX / distance
			axisY = diffY / distance
			
			FCActorSystem.ApplyImpulse( g, axisX * -force, axisY * -force, 0 )
		end
	end
	
	-- go through balls

	if activeBalls ~= nil then
		for b in pairs( activeBalls ) do
			local ballx, bally = FCActorSystem.GetPosition( b )
			
			diffX = bx - ballx
			diffY = by - bally
			
			distance = math.sqrt( diffX * diffX + diffY * diffY )
			
			force = 10 - distance	-- tweaks here
			
			axisX = diffX / distance
			axisY = diffY / distance
			
			FCActorSystem.ApplyImpulse( b, axisX * -force, axisY * -force, 0 )
		end
	end
	
	LevelManager.DestroyBomb( h )
end

-- Gems

local activeGems = {}

function LevelManager.CreateGem( x, y )
	local hGem = Game.CreateGem( x, y )
	activeGems[ hGem ] = hGem
	return hGem
end

function LevelManager.DestroyGems( )
	for h in pairs( activeGems ) do
		Game.DestroyGem( h )
	end
	activeGems = {}
end

function LevelManager.DestroyGem( h )
	activeGems[ h ] = nil
	Game.DestroyGem( h )
end

function LevelManager.Update()
	-- check if balls have fallen off the world
	
	for h in pairs( activeBalls ) do
		local x, y = FCActorSystem.GetPosition( h )
		if y < -15 then
			FCActorSystem.SetPosition( h, 0, 15, 0 )
			FCActorSystem.SetLinearVelocity( h, 0, 0, 0 )
		end
	end

	-- check if gems have fallen off the world
	for h in pairs( activeGems ) do
		local x, y = FCActorSystem.GetPosition( h )
		if y < -15 then
			LevelManager.DestroyGem( h )
		end
	end

	-- check if bombs have fallen off the world
	for h in pairs( activeBombs ) do
		local x, y = FCActorSystem.GetPosition( h )
		if y < -15 then
			LevelManager.DestroyBomb( h )
		end
	end
end

function LevelManager.GetActiveGems()
	return activeGems
end

function LevelManager.UpdateGemColor()
	for h in pairs( activeGems ) do
		local gemAge = Game.GetGemAge( h )		
		local gemColor = GemColorForAge( gemAge )
		local r, g, b, a = GemRGBAForColor( gemColor )
		
		Game.SetGemRGBA( h, r, g, b, a)
	end
end

FCLoadScript( "config/levels" )
