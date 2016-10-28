local BasePlane = require "app/Obj/BasePlane"
local ArmyPlane = class("ArmyPlane", BasePlane)

function ArmyPlane:ctor(  )
	self.super.ctor(self)
	self:flipY(true)
end

function ArmyPlane:onCollision( other )
end

return ArmyPlane