local GameScene = class("GameScene", cc.load("mvc").ViewBase)

local TAG_UI = 101
local TAG_CUT = 100
local TAG_GAME_LAYER = 102

local armySet = {}

function GameScene:onCreate()
	-- body
	local fileName = "Layer/GameCut.csb"
	local uiLayer = display.newCSNode(fileName)	

	self:initUI(uiLayer)
	self:addChild(uiLayer, -1, TAG_UI )

	self:initObj()
	self:onUpdate(handler(self, self.step))
end

function GameScene:step( dt )
	--遍历处理
	local roleRect = self.role_:getRect()
	for k, army in pairs(armySet) do
		local rect = army:getRect()
		local iscollision = cc.rectIntersectsRect(roleRect, rect)
		if iscollision then 
			self.role_:onCollision( army )
			army:onCollision( self.role_ )
		end

		local isOutOfWindow = (army:getPositionY() <= -display.height and true or false )
		if isOutOfWindow then 
			army:removeSelf()
			table.remove(armySet, k)
			break
		end
	end
end

--角色死亡回调函数
function GameScene:onPlayerDead(  )
	
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

function GameScene:initObj()
	local gameLayer = display.newLayer()
	self:addChild(gameLayer, 1, TAG_GAME_LAYER)
	local plane = PlaneFactory:getInstance():createPlane(1)
	local width = plane:getRect().width
	plane:pos(display.cx - width * 0.6, display.cy )
	gameLayer:addChild(plane)
	self.role_ = plane

	--事件处理
	gameLayer:onTouch(function (  event )
		if plane and plane.onTouch then
			plane:onTouch(event)
		end
	end, false, true)

	gameLayer:onAccelerate( function ( event )
		if plane and plane.accelerateEvent then 
			plane:accelerateEvent(event)
		end
	end )

	local army = PlaneFactory:getInstance():createPlane(2)
	army:pos(display.cx + width * 0.6, display.cy + 500)
	army:setSpeed(cc.p(0, -1))
	gameLayer:addChild(army)
	table.insert(armySet, army)

end

function GameScene:onCut(  )
	if not self:getChildByTag(TAG_CUT) then 
		local layer = __G__createCutLayer( "Layer/ResumeLayer.csb" )
		self:addChild(layer, 100, TAG_CUT)
		SDKManager:getInstance():showBanner()

		SDKManager:getInstance():setFULLADCallback(function()  
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