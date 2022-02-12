-- misc functions for CR1

function GemColorForAge( age )
	if age < 6 then
		return kLowGem
	elseif age < 11 then
		return kMediumGem
	elseif age < 16 then
		return kHighGem
	else
		return kSuperGem
	end
end

function GemRGBAForColor( gemColor )
	if gemColor == kLowGem then
		return .6, .6, .6, 1 
	elseif gemColor == kMediumGem then
		return .7, .7, .7, 1 
	elseif gemColor == kHighGem then
		return .8, .8, .8, 1 
	else
		return 1, 1, 1, 1 
	end
end

