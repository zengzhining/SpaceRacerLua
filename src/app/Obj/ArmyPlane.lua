local BasePlane = require "app/Obj/BasePlane"
local ArmyPlane = class("ArmyPlane", BasePlane)

--角色id
local GREY_PLANE = 1
local RED_PLABNE = 2

local MOVE_TIME = 0.2

function ArmyPlane:ctor(  )
	self.super.ctor(self)
	self:flipY(true)

	self.id_ = GREY_PLANE -- id默认1
	self.isHurtRole_ = false

	self.moveTime_ = MOVE_TIME

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

	local originVol = 1.0
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

function ArmyPlane:setGameAi( typeId_ )
	if not typeId_ then typeId = 1 end
	if typeId_ ==  1 then 
		self:leftRightForever()
	end
end

function ArmyPlane:onLeft(x)
	if self.dir_.x == -1 then return end
	__G__actDelay(self, function (  )
		self.isMoved_ = false
	end, self.moveTime_)
	self:moveTo({ x = display.cx - x, time = self.moveTime_ })
	self.dir_.x = -1
end

function ArmyPlane:onRight(x)
	if self.dir_.x == 1 then return end
	self:moveTo({ x = display.cx + x, time = self.moveTime_ })
	__G__actDelay(self, function (  )
		self.isMoved_ = false
	end, self.moveTime_)
	self.dir_.x = 1
end

function ArmyPlane:leftRightForever()
	local DELAY_TIME = math.random(1,3)
	local act = cc.RepeatForever:create(cc.Sequence:create( cc.DelayTime:create(DELAY_TIME), cc.CallFunc:create( function ( target )
		target:onLeft(self:getViewRect().width * 0.6)
	end ),
	cc.DelayTime:create(DELAY_TIME), cc.CallFunc:create( function ( target )
		target:onRight(self:getViewRect().width * 0.6)
	end )
	 ))
	self:runAction(act)
end

return ArmyPlane