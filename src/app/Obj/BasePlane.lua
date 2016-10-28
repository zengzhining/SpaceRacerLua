local BasePlane = class("BasePlane", function ( fileName )
	local node = display.newSprite( fileName )
	return node 
end)

function BasePlane:ctor(  )
	self:initData()
	self:onUpdate(handler(self, self.step))

	if CC_DEBUG_RECT then 
		local draw = display.newDrawNode()
		self:addChild(draw, 999)
		--draw a rectangle
		local rect = self:getCollisionRect()
		local viewRect = self:getViewRect()
        draw:drawRect(cc.p( (viewRect.width - rect.width) * 0.5 , (viewRect.height - rect.height) * 0.5 ), cc.p(rect.width + (viewRect.width - rect.width) * 0.5,rect.height +  (viewRect.width - rect.width) * 0.5), cc.c4f(1,1,0,1))
	end
end

function BasePlane:initData()
	self.dir_ = cc.p(0, 0)
	self.speed_ = cc.p(0, 0)
	self.hp_ = 1
	self.score_ = 0
end

function BasePlane:setSpeed(speed)
	-- body
	self.speed_ = speed
end

function BasePlane:step( dt )
	self:posBy(self.speed_.x , self.speed_.y)
end

--碰撞检测所用矩形
function BasePlane:getCollisionRect(  )
	local rect = self:getBoundingBox()
	local finalWidth  = rect.width * 0.5
	local finalHeight = rect.height * 0.5 
	local newRect = cc.rect( rect.x, rect.y, finalWidth, finalWidth )
	return newRect
end

function BasePlane:getViewRect(  )
	return self:getBoundingBox()
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

--获得的分数
function BasePlane:getScore(  )
	return self.score_
end

function BasePlane:setScore( score )
	self.score_ = score
end


return BasePlane