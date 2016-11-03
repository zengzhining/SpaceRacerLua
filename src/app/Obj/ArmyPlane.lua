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

function ArmyPlane:onCollisionBullet(other)
	self:playDeadAnimation("PlaneExplose%02d.png")
end

function ArmyPlane:playDeadAnimation(fileFormat_)
	local ani = display.getAnimationCache("PlaneDeadAnimation")
	if not ani then 
		local frames = display.newFrames( fileFormat_, 1, 4, false )
		ani = display.newAnimation(frames, 0.2)
		display.setAnimationCache( "PlaneDeadAnimation", ani )
	end

	local originVol = audio.getSoundsVolume()
	local act = cc.Sequence:create( cc.CallFunc:create( function ( target )
		--播放前调整一下音效声音大小
		audio.setSoundsVolume( originVol - 0.2)
		local view = self:getParent():getParent()
		if view and view.onArmyDead then 
			view:onArmyDead(target)
		end
	end ),cc.Animate:create( ani ), cc.CallFunc:create( function ( target )
		audio.setSoundsVolume(originVol)
	end ), cc.RemoveSelf:create(true))
	self:runAction(act)
end

return ArmyPlane