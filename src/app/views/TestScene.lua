local TestScene = class("TestScene", cc.load("mvc").ViewBase)

function TestScene:ctor()
	local layer = display.newLayer()
	layer:onAccelerate(function(x,y,z,timeStap)
		print("x,y,z,timeStap~~~~~~~~",x, y, z, timeStap)
	end)

	--test keycode
	layer:onKeypad(function( event )
		
	end)

    

	--testJson
    require('cocos.cocos2d.json')
    local tbl = {}
    for i = 1, 100 do
    	local score = (101 - i)* 50
    	table.insert( tbl, score )
    end

    local text = json.encode(tbl)
    print("text~~~~", text)
    local fileUtils = cc.FileUtils:getInstance()
    local writePath = fileUtils:getWritablePath()
    print("writePath~~~~~", writePath)
    local isSuccess = fileUtils:writeValueVectorToFile( tbl, writePath.."score.plist")
    print("isSuccess~~~~", isSuccess)

    if isSuccess then 
    	local data = fileUtils:getValueVectorFromFile(writePath.."score.plist")
    	dump(data)
    end

    local decodeTbl = json.decode(text)
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