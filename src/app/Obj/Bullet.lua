local MovedObject = require("app/Obj/MovedObject")
local Bullet = class(Bullet, MovedObject)

function Bullet:ctor()
	self.super.ctor(self)
end

--发射时候的回调函数
function Bullet:onFire()
	if self.aniFormat_ then
		--发射子弹时候播放音效
		__G__FireBullet()
		self:playAnimation(self.aniFormat_)
	end
end

function Bullet:getCollisionRect()
	local rect = self:getBoundingBox()
	local finalWidth  = rect.width* 0.8
	local finalHeight = rect.height * 0.9
	local newRect = cc.rect( rect.x  , rect.y, finalWidth, finalHeight )
	return newRect
end

function Bullet:onCollision(army)
	__G__actDelay(self,function()
		self:removeSelf()
	end, 0.1)
end



return Bullet