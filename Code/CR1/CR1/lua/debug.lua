-- debug function

function Debug_UnlockAll()
	local numLevels = LevelManager.NumLevels()
	for i = 1, numLevels + 1 do
		FCPersistentData.SetBool( "Level" .. i .. "Locked", false )
	end
	FCPersistentData.Save()
end