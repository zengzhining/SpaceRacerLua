local TestScene = class("TestScene", cc.load("mvc").ViewBase)

function TestScene:ctor()
	local layer = display.newLayer()
	layer:onAccelerate(function(x,y,z,timeStap)
		print("x,y,z,timeStap~~~~~~~~",x, y, z, timeStap)
	end)

	--test keycode
	layer:onKeypad(function( event )
		print("keycode~~~~", event.keycode, event.target)
		print("cc.KeyCode.KEY_BACK~~~~~", cc.KeyCode.KEY_BACK)
	end)

	--remove
	-- layer:removeKeypad()
	

	--竖屏
	-- x > 0.5 为向右旋转
	--  y> 0.5 为向前旋转

	--test emitter
	local emitter1 = cc.ParticleSystemQuad:create("Particles/LavaFlow.plist")
	-- local emitter1 = particle.createParticle( "Particles/particle.plist" )
    layer:addChild(emitter1)

	self:add(layer)
end

return TestScene