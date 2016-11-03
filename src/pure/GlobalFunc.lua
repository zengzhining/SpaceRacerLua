
--全局函数

__G__createCutLayer = function ( fileName )
	local layer = display.newLayer(cc.c4b(255, 255, 255, 150))

	local node = display.newCSNode(fileName)
	layer:addChild(node)

	local resume = node:getChildByName("Resume")
	resume:onTouch(function ( event )
		if event.name == "began" then
			local scene = layer:getParent()
			if scene and scene.onResume then 
				scene:onResume()
			end		
		end
	end, false, true)

	local restart = node:getChildByName("Restart")
	restart:onTouch(function ( event )
		if event.name == "began" then
			local scene = layer:getParent()
			if scene and scene.onRestart then 
				scene:onRestart()
			end		
		end
	end,  false, true)

	local exit = node:getChildByName("Exit")
	exit:onTouch(function ( event )
		if event.name == "began" then
			local scene = layer:getParent()
			if scene and scene.onCutExit then 
				scene:onCutExit()
			end		
		end
	end,  false, true)


	return layer
end

__G__createOverLayer = function ( fileName )
	local layer = display.newLayer(cc.c4b(255, 255, 255, 100))

	local node = display.newCSNode(fileName)
	layer:addChild(node)

	local Retry = node:getChildByName("Retry")
	Retry:onTouch(function ( event )
		if event.name == "began" then
			local scene = layer:getParent()
			if scene and scene.onRetry then 
				scene:onRetry()
			end		
		end
	end, false, true)

	local exit = node:getChildByName("Exit")
	exit:onTouch(function ( event )
		if event.name == "began" then
			local scene = layer:getParent()
			if scene and scene.onGameExit then 
				scene:onGameExit()
			end		
		end
	end,  false, true)


	return layer
end

__G__createBg = function (fileName)
	local layer = display.newLayer()
	local node = display.newCSNode(fileName)
	layer.speed_ = -10

	layer:enableNodeEvents()
	
	layer:addChild(node)

	function layer:onEnter()
		layer:unUpdate()
		layer:onUpdate(handler(layer, layer.update))
	end

	function layer:setSpeed(speed)
		self.speed_ = speed
	end

	function layer:update(dt)
		local tbl ={ "Bg", "BgUp" }
		for c, key in pairs (tbl) do
			local bg = node:getChildByName(key)
			if bg:getPositionY() <= 0 then
				bg:posY(display.height * 2)
			end
			bg:posByY(self.speed_)
		end
	end

	return layer
end

--延时执行动作
__G__actDelay = function (target, callback, time)
	local act = cc.Sequence:create( cc.DelayTime:create(time), cc.CallFunc:create(function ( obj )
		callback()
	end)) 
	target:runAction(act)
end