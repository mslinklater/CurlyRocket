-- Level object definition

Level = {}
--Level.__index = Level

local function CreateBallPos( self, i, num )
	x = (self:Random():Get() % 5) - 2
	y = 15 + i
	return x, y
end

local function CreateGemPos()
	return gemCreateXPos, 15
end

local function CreateBombPos()
	return 0, 19
end

local function InitFunc()
end

local function ShutdownFunc()
end

local function StartGameFunc()
end

local function EndGameFunc()
end

local function UpdateFunc()
end

function Level.New( id, name )

	if DEBUG then
		assert( id )
		assert( name )
	end

	ret = {}
	
	ret.Init = InitFunc
	ret.Shutdown = ShutdownFunc
	ret.CreateBallPos = CreateBallPos
	ret.CreateGemPos = CreateGemPos
	ret.CreateBombPos = CreateBombPos
	ret.StartGame = StartGameFunc
	ret.EndGame = EndGameFunc
	ret.UpdateFunc = UpdateFunc
	
	ret.m_id = id
	ret.m_name = name
	ret.m_type = {}	--kLevelTypeNormal
	ret.m_world = {}
	ret.m_rackSize = {}
	ret.m_year = {}
	ret.m_description = {}
	ret.m_wikiLink = {}
	ret.m_random = FCRandom.New( id )
	ret.m_numRacks = {}
	ret.m_time = {}
	ret.m_tutorial = false
	ret.m_locked = true
	ret.mt = {}
	ret.mt.__index = Level
	ret.mt.__newindex = function() error() end
	setmetatable( ret, ret.mt )
	
	return ret
end

function Level:Reset( )
	self.m_random = FCRandom.New( self.m_id )
end

function Level:SetLocked( status )
	self.m_locked = status
end

function Level:Locked()
	return self.m_locked
end

function Level:SetTutorial( tut )
	self.m_tutorial = tut
end

function Level:Tutorial()
	return self.m_tutorial
end

function Level:SetUpdateFunc( func )
	self.UpdateFunc = func
end

function Level:SetInitFunc( func )
	self.Init = func
end

function Level:SetShutdownFunc( func )
	self.Shutdown = func
end

function Level:SetStartGameFunc( func )
	self.StartGame = func
end

function Level:SetEndGameFunc( func )
	self.EndGame = func
end

--function Level:StartGameFunc( )
--	return self.StartGame
--end

function Level:SetCreateBallFunc( func )
	self.CreateBallPos = func
end

function Level:SetCreateGemFunc( func )
	self.CreateGemPos = func
end

function Level:SetCreateBombFunc( func )
	self.CreateBombPos = func
end

-- Id

function Level:Id()
	return self.m_id
end

-- Type

function Level:SetType( type )
	if DEBUG then
		assert( type )
	end

	self.m_type = type
end

function Level:Type()
	return self.m_type
end

-- Name

function Level:Name()
	if self.m_locked then
		return kWord_Locked
	end
	return self.m_name
end

-- World

function Level:SetWorld( world )
	self.m_world = world
end

function Level:World()
	return self.m_world
end

-- RackSize

function Level:SetRackSize( size )
	self.m_rackSize = size
end

function Level:RackSize()
	return self.m_rackSize
end

-- NumRacks

function Level:SetNumRacks( numRacks )
	self.m_numRacks = numRacks
end

function Level:NumRacks()
	return self.m_numRacks
end

-- Time

function Level:SetTime( time )
	self.m_time = time
end

function Level:Time()
	return self.m_time
end

-- Year

function Level:SetYear( year )
	self.m_year = year
end

function Level:Year()
	return self.m_year
end

-- Description

function Level:SetDescription( desc )
	self.m_description = desc
end

function Level:Description()
	return self.m_description
end

-- WikiLink

function Level:SetWikiLink( link )
	self.m_wikiLink = link
end

function Level:WikiLink()
	return self.m_wikiLink
end

-- Random

function Level:Random()
	return self.m_random
end
