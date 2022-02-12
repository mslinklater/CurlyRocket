------------------------------------------------------------------------------------------

function QuitCRSelectedThread()
	FCPhaseManager.AddPhaseToQueue( "FrontEnd" )
	FCPhaseManager.DeactivatePhase( "CurlyRocket" )
end

function QuitCRSelected()
	FCLog("Quit")
	FCNewThread( QuitCRSelectedThread, "quitCR" )
end

------------------------------------------------------------------------------------------

CurlyRocketPhase = {}

function CurlyRocketPhase.WillActivate()
	FCLog("CurlyRocketPhase.WillActivate")	
end

function CurlyRocketPhase.IsNowActive()
	FCLog("CurlyRocketPhase.IsNowActive")
end

function CurlyRocketPhase.WillDeactivate()
	FCLog("CurlyRocketPhase.WillDeactivate")
end

function CurlyRocketPhase.IsNowDeactive()
	FCLog("CurlyRocketPhase.IsNowDeactive")
end

function CurlyRocketPhase.Update()
end

