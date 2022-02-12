-- world object definition

World = {}

function World:new( )
	ret = {}
	setmetatable( ret, self )
	self.__index = self
	
	ret.resource = nil
	return ret
end

function World:SetResource( res )
	self.resource = res
end

function World:SetInitFunc( func )
	self.Init = func
end

function World:SetShutdownFunc( func )
	self.Shutdown = func
end
