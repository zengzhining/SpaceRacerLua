local TestScene = class("TestScene", cc.load("mvc").ViewBase)

function TestScene:ctor()
	local layer = display.newLayer()
	layer:onAccelerate(function(x,y,z,timeStap)
		print("x,y,z,timeStap~~~~~~~~",x, y, z, timeStap)
	end)
	--竖屏
	-- x > 0.5 为向右旋转
	--  y> 0.5 为向前旋转
	self:add(layer)
end

return TestScene