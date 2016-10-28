local GameScene = class("GameScene", cc.load("mvc").ViewBase)

local TAG_UI = 101
local TAG_CUT = 100

function GameScene:onCreate()
	-- body
	local fileName = "Layer/GameCut.csb"
	local uiLayer = display.newCSNode(fileName)	

	self:initUI(uiLayer)
	self:addChild(uiLayer, -1, TAG_UI )
end

function GameScene:initUI( ui_ )
	local cutBtn = ui_:getChildByName("CutButton")
	cutBtn:onTouch(function ( event )
		if event.name == "began" then 
			self:onCut()
			cutBtn:setTouchEnabled(false)
		end
	end)

	self.cutBtn_ = cutBtn

	local scoreLb = ui_:getChildByName("Score")
	
end

function GameScene:onCut(  )
	if not self:getChildByTag(TAG_CUT) then 
		local layer = __G__createCutLayer( "Layer/ResumeLayer.csb" )
		self:addChild(layer, 100, TAG_CUT)
		SDKManager:getInstance():showBanner()

		SDKManager:getInstance():setFULLADCallback(function()  
			print("FULLAD callback~~~~~~~~~~~")
			end)
		display.pause()
	end
end

--暂停的回调方法-----
function GameScene:onResume()
	display.resume()
	SDKManager:getInstance():hideBanner()

	self:removeChildByTag(TAG_CUT, true)
	self.cutBtn_:setTouchEnabled(true)
end

function GameScene:onRestart()
	SDKManager:getInstance():showReview()
end

function GameScene:onCutExit()
	SDKManager:getInstance():showFULLAD()
end

--------------------------------



function GameScene:onEnter()
	audio.stopMusic()
end

function GameScene:onExit()

end

return GameScene