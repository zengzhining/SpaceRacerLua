PlaneFactory = class("PlaneFactory")
local HeroPlane = require("app/Obj/HeroPlane")
local ArmyPlane = require("app/Obj/ArmyPlane")

function PlaneFactory:ctor(  )
	
end

function PlaneFactory:createPlane( id_ )
	if id_ == 1 then 	
		return HeroPlane.new("png/RolePlane.png")
	elseif id_ == 2 then
		return ArmyPlane.new("png/GreenPlane.png")
	end
end
--单例
local plane_factory_instance = nil
function PlaneFactory:getInstance()
	if not plane_factory_instance then 
		plane_factory_instance = PlaneFactory.new()
	end

	PlaneFactory.new = function (  )
		error("PlaneFactory Cannot use new operater,Please use geiInstance")
	end

	return plane_factory_instance
end
