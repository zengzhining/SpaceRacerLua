local BasePlane = class("BasePlane", function ( fileName )
	local node = display.newSprite( fileName )

	return node 
end)

function BasePlane:ctor(  )
	
end

function BasePlane:onTouch(event)

end

function BasePlane:accelerateEvent( event)

end

return BasePlane