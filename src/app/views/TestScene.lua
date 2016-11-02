local TestScene = class("TestScene", cc.load("mvc").ViewBase)

function TestScene:ctor()
	local layer = display.newLayer()
	layer:onAccelerate(function(x,y,z,timeStap)
		print("x,y,z,timeStap~~~~~~~~",x, y, z, timeStap)
	end)


	
	--竖屏
	-- x > 0.5 为向右旋转
	--  y> 0.5 为向前旋转

	local emitter1 = cc.ParticleSystemQuad:create("Particles/LavaFlow.plist")
	-- local emitter1 = particle.createParticle( "Particles/particle.plist" )
    layer:addChild(emitter1)

	self:add(layer)
end

return TestScene