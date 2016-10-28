local BasePlane = class("BasePlane", function ( fileName )
	local node = display.newSprite( fileName )
	return node 
end)

function BasePlane:ctor(  )
	self:initData()
	self:onUpdate(handler(self, self.step))
end

function BasePlane:initData()
	self.dir_ = ccp(0, 0)
	self.speed_ = cc.p(0, 1)
	self.hp_ = 1
end

function BasePlane:setSpeed(speed)
	-- body
	self.speed_ = speed
end

function BasePlane:step( dt )
	self:posBy(self.speed_.x , self.speed_.y)
end

--碰撞检测所用矩形
function BasePlane:getRect(  )
	local rect = self:getBoundingBox()
	return rect
end

--碰撞检测回调
function BasePlane:onCollision( other )
	self:hide()
end

--受伤回调
function BasePlane:onHurt( hp_ )
	self.hp_ = self.hp_ - hp_
end

function BasePlane:isDead(  )
	return self.hp_ == 0
end

--左右的控制
function BasePlane:onLeft( x )

end

function BasePlane:onRight( x )
	
end


return BasePlane