local GameScene = class("GameScene", cc.load("mvc").ViewBase)

local TAG_UI = 101
local TAG_CUT = 100
local TAG_GAME_LAYER = 102
local TAG_BG = 103

local armySet = {}

local ARMY_TIME = 0.6 --敌人生成时间
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

	local bg = __G__createBg( "Layer/BackGround.csb" )
	bg:setSpeed(self:getBgSpeed())
	self:add(bg, -2, TAG_BG)
end

function GameScene:initData()
	armySet = {}
end

function GameScene:step( dt )
	--遍历处理
	local roleRect = self.role_:getCollisionRect()
	local rolePosY = self.role_:getPositionY()
	for k, army in pairs(armySet) do
		local rect = army:getCollisionRect()
		local iscollision = cc.rectIntersectsRect(roleRect, rect) 
		if iscollision  then 
			self.role_:onCollision( army )
			army:onCollision( self.role_ )
		end

		local armyPosY = army:getPositionY()
		local isBeyound = ((armyPosY <= rolePosY - roleRect.height * 0.5 ) and true or false)
		if isBeyound then 
			--只进行一次回调
			if not army.hasBeyound_ then
				army.hasBeyound_ = true
				self:onBeyoundArmy(army)
			end
		end

		local isOutOfWindow = ( armyPosY <= (-display.cy * 0.5) and true or false )
		if isOutOfWindow then 
			army:removeSelf()
			table.remove(armySet, k)
			break
		end
	end

	--生成敌人
	tempTime = tempTime + dt
	local armtTime = self:getArmyTime()
	if tempTime >= armtTime then
		tempTime = 0 
		self:onCreateArmy()
	end

	self:updateScore()
	self:updateRank()
end

function GameScene:getArmyTime()
	local time = ARMY_TIME
	local rank = GameData:getInstance():getRank()
	local armySpeed = self:getArmySpeed()
	time = 0.01* math.abs(armySpeed)
	return time
end

--角色超越敌机瞬间的回调函数
function GameScene:onBeyoundArmy( army_ )
	GameData:getInstance():addScore( army_:getScore() ) 
end

--角色死亡回调函数
function GameScene:onPlayerDead(  )
	__G__ExplosionSound()
	self.cutBtn_:setTouchEnabled(false)
	self.gameLayer_:removeKeypad()
	self.gameLayer_:removeAccelerate()
	self:unUpdate()
	__G__MusicFadeOut(self, 1)
	__G__actDelay( self, function (  )
		self:getApp():enterScene("ResultScene")
	end, 1.0 )
	device.vibrate( 0.2 )
end

function GameScene:initUI( ui_ )
	local cutBtn = ui_:getChildByName("CutButton")
	cutBtn:onTouch(function ( event )
		if event.name == "ended" then 
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
	--如果两次的排行榜数据不同就更新显示
	local score = GameData:getInstance():getScore()
	local rank = 100 - math.floor(score /10) 
	GameData:getInstance():setRank(rank) 
	self.rankLb_:setString( GameData:getInstance():getRank() )
end

function GameScene:initObj()
	local gameLayer = display.newLayer()
	self:addChild(gameLayer, 1, TAG_GAME_LAYER)
	self.gameLayer_ = gameLayer
	local plane = PlaneFactory:getInstance():createPlane(1)
	local width = plane:getViewRect().width
	plane:pos(display.cx - width * 0.6, display.height /4 )
	gameLayer:addChild(plane)
	self.role_ = plane

	--事件处理
	gameLayer:onTouch(function (  event )
		if plane and plane.onTouch then
			plane:onTouch(event)
		end
	end, false, true)

	gameLayer:onAccelerate( function ( x,y,z,timeStap )
		if plane and plane.accelerateEvent then 
			plane:accelerateEvent(x,y,z,timeStap)
		end
	end )

	--按键事件
	local keyCallback = function ( event )
		if event.keycode == cc.KeyCode.KEY_BACK then
			self:onCut()
        end

        if (device.platform ~= android) and plane and plane.onKeyPad then 
        	plane:onKeyPad(event)
        end
    end
	gameLayer:onKeypad( keyCallback )

end

function GameScene:onCreateArmy(  )
	math.randomseed(os.time())
	local dir = math.random(1,2)
	if dir == 2 then
		dir = -1
	end

	local army = PlaneFactory:getInstance():createPlane(2)
	local armySpeed = self:getArmySpeed()
	army:setSpeed(cc.p(0, armySpeed))
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

	--调整一下游戏背景速度
	local bgSpeed = self:getBgSpeed()
	local bg = self:getChildByTag(TAG_BG)
	if bg and bg.setSpeed then 
		bg:setSpeed(bgSpeed)
	end
end

function GameScene:getBgSpeed()
	local rank = GameData:getInstance():getRank()
	local speed = (100-rank) * 0.2 + 2
	return (0-speed)
end

function GameScene:getArmySpeed()
	--根据排名来获得分数
	local rank = GameData:getInstance():getRank()
	local speed = (100-rank) * 0.2 + 10
	--最大到三十
	return (0-speed)
end


function GameScene:onCut(  )
	if not self:getChildByTag(TAG_CUT) then 
		__G__MenuClickSound()
		local layer = __G__createCutLayer( "Layer/ResumeLayer.csb" )
		self:addChild(layer, 100, TAG_CUT)
		display.pause()
	end
end

--暂停的回调方法-----
function GameScene:onResume()
	__G__MenuCancelSound()
	display.resume()
	self.gameLayer_:setTouchEnabled(true)
	self:removeChildByTag(TAG_CUT, true)
	self.cutBtn_:setTouchEnabled(true)
end

function GameScene:onRestart()
	__G__MenuCancelSound()
	display.resume()
	GameData:getInstance():reset()
	self:getApp():enterLoading("GameScene")
end


function GameScene:onCutExit()
	__G__MenuCancelSound()
	display.exit()
end

--------------------------------

function GameScene:onEnter()
	__G__MainMusic()	
	-- armySet = {}
	-- score = 0
	self:unUpdate()
	self:onUpdate(handler(self, self.step))
end

function GameScene:onExit()
	self.gameLayer_:removeKeypad()
	self.gameLayer_:removeAccelerate()
	self:unUpdate()
	for k, army in pairs(armySet) do
		if army then 
			army:removeSelf()
		end
	end



end

return GameScene