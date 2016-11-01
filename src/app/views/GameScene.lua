local GameScene = class("GameScene", cc.load("mvc").ViewBase)

local TAG_UI = 101
local TAG_CUT = 100
local TAG_GAME_LAYER = 102

local armySet = {}

local ARMY_TIME = 1 --敌人生成时间
local tempTime = 0

function GameScene:onCreate()
	self:initData()
	--addSpriteFrames
	display.loadSpriteFrames("Plane.plist", "Plane.png")
	-- body
	local fileName = "Layer/GameCut.csb"
	local uiLayer = display.newCSNode(fileName)	

	self:initUI(uiLayer)
	self:addChild(uiLayer, -1, TAG_UI )

	self:initObj()
end

function GameScene:initData()
	armySet = {}
end

function GameScene:step( dt )
	--遍历处理
	local roleRect = self.role_:getCollisionRect()
	for k, army in pairs(armySet) do
		local rect = army:getCollisionRect()
		local iscollision = cc.rectIntersectsRect(roleRect, rect) 
		if iscollision  then 
			self.role_:onCollision( army )
			army:onCollision( self.role_ )
		end

		local isOutOfWindow = (army:getPositionY() <= 0 and true or false )
		if isOutOfWindow then 
			GameData:getInstance():addScore( army:getScore() ) 
			army:removeSelf()
			table.remove(armySet, k)
			break
		end
	end

	--生成敌人
	tempTime = tempTime + dt
	if tempTime >= ARMY_TIME then
		tempTime = 0 
		self:onCreateArmy()
	end


	self:updateScore()
	self:updateRank()
end

--角色死亡回调函数
function GameScene:onPlayerDead(  )
	__G__actDelay( self, function (  )
		self:getApp():enterScene("ResultScene")
	end, 1.0 )
end

function GameScene:initUI( ui_ )
	local cutBtn = ui_:getChildByName("CutButton")
	cutBtn:onTouch(function ( event )
		if event.name == "began" then 
			self.gameLayer_:setTouchEnabled(false)
			self:onCut()
			cutBtn:setTouchEnabled(false)
			return false
		end
	end,  false, true)

	self.cutBtn_ = cutBtn
	local scoreLb = ui_:getChildByName("Score")
	self.scoreLb_ = scoreLb
	local rankLb = ui_:getChildByName("Rank")
	self.rankLb_ = rankLb
	self:updateScore()
end

function GameScene:updateScore(  )
	self.scoreLb_:setString(string.format("%04d", GameData:getInstance():getScore()))
end

function GameScene:updateRank()
	self.rankLb_:setString( GameData:getInstance():getRank() )
end
function GameScene:initObj()
	local gameLayer = display.newLayer()
	self:addChild(gameLayer, -2, TAG_GAME_LAYER)
	self.gameLayer_ = gameLayer
	local plane = PlaneFactory:getInstance():createPlane(1)
	local width = plane:getViewRect().width
	plane:pos(display.cx - width * 0.6, display.height /3 )
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

end

function GameScene:onCreateArmy(  )
	math.randomseed(os.time())
	local dir = math.random(1,2)
	if dir == 2 then
		dir = -1
	end

	local army = PlaneFactory:getInstance():createPlane(2)
	army:setSpeed(cc.p(0, -10))
	local lastArmy = armySet[#armySet] 

	local height = army:getViewRect().height
	local width = army:getViewRect().width
	local posy = display.height * 1.2
	if lastArmy then
		height = lastArmy:getViewRect().height
		width = lastArmy:getViewRect().width
		posy =  lastArmy:getPositionY()
	end
	army:pos(display.cx + width * 0.6 * dir, posy + height * 3 )
	self.gameLayer_ :addChild(army)
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
	self.gameLayer_:setTouchEnabled(true)
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
	-- armySet = {}
	-- score = 0
	self:onUpdate(handler(self, self.step))
end

function GameScene:onExit()
	self:unUpdate()
	for k, army in pairs(armySet) do
		if army then 
			army:removeSelf()
		end
	end

end

return GameScene