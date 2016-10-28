local BasePlane = require("app/Obj/BasePlane")

local HeroPlane = class("HeroPlane", BasePlane)

function HeroPlane:ctor(  )
	self.super.ctor(self)

	--是否在左右移动过程中
	self.isMoved_ = false
end

function HeroPlane:onTouch( event )
	if event.name == "began" then
		if event.x < display.cx then 
			self:onLeft( self:getRect().width * 0.6 )
		else
			self:onRight( self:getRect().width * 0.6 )
		end
	end
end

function HeroPlane:accelerateEvent( event )
	print("accelerateEvent~~~~~~~~")
end

--碰撞碰到敌人回调
function HeroPlane:onCollision(other )
	self:onHurt(1)
	if self:isDead() then 
		--默认在上上层
		local view = self:getParent():getParent()
		if view and view.onPlayerDead then 
			view:onPlayerDead()
		end
	end
end

function HeroPlane:onLeft( x )
	if self.isMoved_ then return end
	if self.dir_.x == -1 then return end
	__G__actDelay(self, function (  )
		self.isMoved_ = false
	end, 0.4)
	self:moveTo({ x = display.cx - x, time = 0.4 })
	self.dir_.x = -1
	self.isMoved_ = true
end

function HeroPlane:onRight(x)
	if self.isMoved_ then return end
	if self.dir_.x == 1 then return end
	self:moveTo({ x = display.cx + x, time = 0.4 })
	__G__actDelay(self, function (  )
		self.isMoved_ = false
	end, 0.4)
	self.dir_.x = 1
	self.isMoved_ = true
end

return HeroPlane