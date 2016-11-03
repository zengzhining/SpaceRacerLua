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

	local rankLb = root:getChildByName("Rank")
	rankLb:setString(tostring(GameData:getInstance():getRank()))

	local scoreLb = root:getChildByName("Score")
	scoreLb:setString(tostring(GameData:getInstance():getScore()))

end

function ResultScene:onRetry(  )
	local callback = function ()
		__G__actDelay(self, function()
				self:getApp():enterScene("GameScene" )
			end, 0.2)
	end

	--重置游戏数据
	GameData:getInstance():reset()

	--判断能否播放广告，可以就播放
	if SDKManager:getInstance():isCanPlayVedio() then
		SDKManager:getInstance():showVideo( callback )
	elseif SDKManager:getInstance():isFULLADAvailable() then
		SDKManager:getInstance():showFULLAD()
		SDKManager:getInstance():setFULLADCallback(callback)
	else
		callback()
	end
end

function ResultScene:onGameExit()
	display.exit()
end

--进入结算界面先播放个全屏
function ResultScene:onEnter()
	
end

function ResultScene:onExit()

end



return ResultScene 