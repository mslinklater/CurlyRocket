-- audio

function InitialiseAudio()

	FCAudio.AddCollisionTypeHandler( "BallActor", "BallActor", "BallCollisionAudioHandler" )
	FCAudio.AddCollisionTypeHandler( "WorldActor", "BallActor", "BallCollisionAudioHandler" )

	FCAudio.AddCollisionTypeHandler( "WorldActor", "GemActor", "GemCollisionAudioHandler" )
	FCAudio.AddCollisionTypeHandler( "BallActor", "GemActor", "GemCollisionAudioHandler" )
	FCAudio.AddCollisionTypeHandler( "GemActor", "GemActor", "GemCollisionAudioHandler" )

	kAudioBufferWood = FCAudio.CreateBuffer( "Imported/Audio/wood" )
	kAudioBufferClink = FCAudio.CreateBuffer( "Imported/Audio/clink" )
	kAudioBufferTurbine = FCAudio.CreateBuffer( "Imported/Audio/turbine" )
end

function ShutdownAudio()
	FCAudio.DeleteBuffer( kAudioBufferWood )
	
	FCAudio.RemoveCollisionTypeHandler( "BallActor", "BallActor" )
	FCAudio.RemoveCollisionTypeHandler( "WorldActor", "BallActor" )
end

-- handlers

function BallCollisionAudioHandler( h1, h2, x, y, z, vel )	
	if vel > -0.5 then
		return
	end
	
	local h = FCAudio.PrepareSourceWithBuffer( kAudioBufferWood, false )
	
	if h ~= 0 then
		local volume = vel / -20.0
		if volume > 0.5 then
			volume = 0.5
		end
			
		FCAudio.SourceSetVolume( h, volume )
		FCAudio.SourcePosition( h, x * 10, 0, 0 )
		FCAudio.SourcePitch( h, 0.95 + (volume * 0.2))
		FCAudio.SourcePlay( h )	
	end
end

function GemCollisionAudioHandler( h1, h2, x, y, z, vel )	
	if vel > -0.5 then
		return
	end

	local h = FCAudio.PrepareSourceWithBuffer( kAudioBufferClink, false )
	
	if h ~= 0 then
		local volume = vel / -20.0
		if volume > 0.75 then
			volume = 0.75
		end
	
			
		FCAudio.SourceSetVolume( h, volume )
		FCAudio.SourcePosition( h, x * 10, 0, 0 )
		FCAudio.SourcePitch( h, 0.95 + (volume * 0.2))
		FCAudio.SourcePlay( h )	
	end
	
end
