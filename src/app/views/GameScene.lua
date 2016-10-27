local GameScene = class("GameScene", cc.load("mvc").ViewBase)

local TAG_UI = 101

function GameScene:onCreate()
	-- body
	local fileName = "Layer/GameCut.csb"
	local uiLayer = cc.CSLoader:createNode(fileName)	

	self:initUI(uiLayer)
	self:addChild(uiLayer, -1, TAG_UI )
end

function GameScene:initUI( ui_ )
	local cutBtn = ui_:getChildByName("CutButton")
	cutBtn:onTouch(function ( event )
		if event.name == "began" then 
			self:onCut()
		end
	end)

	local scoreLb = ui_:getChildByName("Score")
	
end

function GameScene:onCut(  )

end

function GameScene:onEnter()
	audio.stopMusic()
	SDKManager:getInstance():showReview()
end

function GameScene:onExit()

end

return GameScene