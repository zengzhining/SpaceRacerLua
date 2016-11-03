PlaneFactory = class("PlaneFactory")
local HeroPlane = require("app/Obj/HeroPlane")
local ArmyPlane = require("app/Obj/ArmyPlane")
local Bullet = require("app/Obj/Bullet")

function PlaneFactory:ctor(  )
	
end

function PlaneFactory:createPlane( id_ )
	if id_ == 1 then 	
		return HeroPlane.new("png/RolePlane.png")
	elseif id_ == 2 then
		local plane = ArmyPlane.new("png/GreenPlane.png")
		plane:setScore( 2 )
		return plane
	end
end

function PlaneFactory:createBullet( id_ )
	if not id_ then id_ = 1 end
	local bullet
	if id_ == 1 then
		bullet = Bullet.new("#BlueBullet03.png")
		bullet:setAnimationFormat("BlueBullet%02d.png")
	end
	return bullet

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
