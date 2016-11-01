local BasePlane = require("app/Obj/BasePlane")

local HeroPlane = class("HeroPlane", BasePlane)

local MOVE_TIME = 0.3
function HeroPlane:ctor(  )
	self.super.ctor(self)

	--是否在左右移动过程中
	self.isMoved_ = false
	--是否在受伤过程
	self.isOnHurt_ = false

	--死亡动画播放
	self.onDeadAni_ = false
end

function HeroPlane:onTouch( event )
	if event.name == "began" then
		if event.x < display.cx then 
			self:onLeft( self:getViewRect().width * 0.6 )
		else
			self:onRight( self:getViewRect().width * 0.6 )
		end
	end
end

function HeroPlane:accelerateEvent( event )
end

--碰撞碰到敌人回调
function HeroPlane:onCollision(other )
	self:onHurt(1)
	if self:isDead() then 
		--默认在上上层
		self:playDeadAnimation( "PlaneExplose%02d.png")
		local view = self:getParent():getParent()
		if view and view.onPlayerDead then 
			view:onPlayerDead()
		end
	end
end

function HeroPlane:playDeadAnimation( fileFormat_ )
	if self.onDeadAni_ then return end 
	self.onDeadAni_ = true
	local ani = display.getAnimationCache(heroDeadAnimation)
	if not ani then 
		local frames = display.newFrames( fileFormat_, 1, 4, false )
		ani = display.newAnimation(frames, 0.2)
		display.setAnimationCache( "heroDeadAnimation", ani )
	end

	local act = cc.Sequence:create( cc.Animate:create( ani ), cc.Hide:create(), cc.CallFunc:create( function ( target )
		target.onDeadAni_ = false
	end ) )
	self:runAction(act)
end

function HeroPlane:onHurt(hp_)
	--受伤过程不可再受伤
	if self.isOnHurt_ then return end
	self.super.onHurt(self,hp_)

	local sequence = cc.Sequence:create( cc.FadeOut:create(0.3), cc.FadeIn:create(0.2) )
	local act = cc.Repeat:create(sequence, 3)
	self:runAction(act)
	__G__actDelay(self, function (  )
		self.isOnHurt_ = false
	end, 1.5)
	self.isOnHurt_ = true
end

function HeroPlane:onLeft( x )
	if self.isMoved_ then return end
	if self.dir_.x == -1 then return end
	__G__actDelay(self, function (  )
		self.isMoved_ = false
	end, MOVE_TIME)
	self:moveTo({ x = display.cx - x, time = MOVE_TIME })
	self.dir_.x = -1
	self.isMoved_ = true
end

function HeroPlane:onRight(x)
	if self.isMoved_ then return end
	if self.dir_.x == 1 then return end
	self:moveTo({ x = display.cx + x, time = MOVE_TIME })
	__G__actDelay(self, function (  )
		self.isMoved_ = false
	end, MOVE_TIME)
	self.dir_.x = 1
	self.isMoved_ = true
end

return HeroPlane