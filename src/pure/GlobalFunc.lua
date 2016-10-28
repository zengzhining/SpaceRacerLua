
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
	end)

	local restart = node:getChildByName("Restart")
	restart:onTouch(function ( event )
		if event.name == "began" then
			local scene = layer:getParent()
			if scene and scene.onRestart then 
				scene:onRestart()
			end		
		end
	end)

	local exit = node:getChildByName("Exit")
	exit:onTouch(function ( event )
		if event.name == "began" then
			local scene = layer:getParent()
			if scene and scene.onCutExit then 
				scene:onCutExit()
			end		
		end
	end)


	return layer
end