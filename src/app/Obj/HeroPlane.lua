local BasePlane = require("app/Obj/BasePlane")

local HeroPlane = class("HeroPlane", function( fileName )
		local obj = BasePlane.new(fileName)
		return obj
	end)

function HeroPlane:ctor(  )
	print("ctor~~~~")
end

function HeroPlane:onTouch( event )
	print("touchEvent~~~~~~")
end

function HeroPlane:accelerateEvent( event )
	print("accelerateEvent~~~~~~~~")
end

return HeroPlane