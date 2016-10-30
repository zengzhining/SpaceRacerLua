local ResultScene = class("ResultScene", cc.load("mvc").ViewBase)

ResultScene.RESOURCE_FILENAME = "Layer/GameOver.csb"
function ResultScene:onCreate(  )
	-- body
	local root = self:getResourceNode()
	local Retry = root:getChildByName("Retry")
	Retry:onTouch(function ( event )
		if event.name == "began" then
			local scene = root:getParent()
			if scene and scene.onRetry then 
				scene:onRetry()
			end		
		end
	end, false, true)

	local exit = root:getChildByName("Exit")
	exit:onTouch(function ( event )
		if event.name == "began" then
			local scene = root:getParent()
			if scene and scene.onGameExit then 
				scene:onGameExit()
			end		
		end
	end,  false, true)
end

function ResultScene:onRetry(  )
	self:getApp():enterScene("GameScene", "FADE", 2,cc.c3b(255 , 255 , 255) )
end

function ResultScene:onGameExit()
	display.exit()
end

function ResultScene:onEnter()

end

function ResultScene:onExit()

end



return ResultScene 