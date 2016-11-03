local BasePlane = require "app/Obj/BasePlane"
local ArmyPlane = class("ArmyPlane", BasePlane)

function ArmyPlane:ctor(  )
	self.super.ctor(self)
	self:flipY(true)

	self.isHurtRole_ = false

	--是否被超越
	self.hasBeyound_ = false
end

function ArmyPlane:onCollision( other )
	self.isHurtRole_ = true
end

return ArmyPlane