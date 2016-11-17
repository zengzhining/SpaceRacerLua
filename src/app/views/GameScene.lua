local GameScene = class("GameScene", cc.load("mvc").ViewBase)

local TAG_UI = 101
local TAG_CUT = 100
local TAG_GAME_LAYER = 102
local TAG_BG = 103
local TAG_CONTINUE_LAYER = 104
local TAG_CONTROL_LAYER = 105

local armySet = {}
local bulletSet = {}

local ARMY_TIME = 0.6 --敌人生成时间
local tempTime = 0

local hitSameArmyNum = 0 --打击到相同敌人的数目
local lastHitArmyId = 1 --上次子弹打到的敌人的id
local commboTimes = 0

local ContinueTimes = 2  -- 只能有两次继续游戏机会

function GameScene:onCreate()
	self:initData()
	--addSpriteFrames
	-- body
	local fileName = "Layer/GameCut.csb"
	local uiLayer = display.newCSNode(fileName)	

	self:initUI(uiLayer)
	self:addChild(uiLayer, -1, TAG_UI )

	self:initControl()

	self:initObj()

	local bg = __G__createBg( "Layer/BackGround.csb" )
	bg:setSpeed(self:getBgSpeed())
	self:add(bg, -2, TAG_BG)
end

function GameScene:initData()

	--测试默认载入plist
	if DEBUG == 2 then 
		display.loadSpriteFrames("Plane.plist", "Plane.png")
	end

	armySet = {}
	bulletSet = {}

	hitSameArmyNum = 0
	commboTimes = 0
	ContinueTimes = 2
end

function GameScene:step( dt )
	--遍历处理
	local roleRect = self.role_:getCollisionRect()
	local rolePosY = self.role_:getPositionY()
	--遍历敌人
	for k, army in pairs(armySet) do
		local rect = army:getCollisionRect()
		local iscollision = cc.rectIntersectsRect(roleRect, rect) 
		local isRelive = self.role_:isRelive()
		--碰撞检测成功判断下角色是否处于复活状态
		if iscollision and (not isRelive) then 
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

	local armyInScreen = {}
	for k,army in pairs(armySet) do
		if army:getPositionY() >= 0 and army:getPositionY()<= display.height then
			army.key_ = k
			table.insert(armyInScreen, army)
		end
	end
	--遍历子弹处理子弹碰撞逻辑
	for i, bullet in pairs(bulletSet) do
		local bulletRect = bullet:getCollisionRect()
		for k, army in pairs(armyInScreen) do
			local armyRect = army:getCollisionRect()
			local iscollision = cc.rectIntersectsRect(armyRect, bulletRect) 
			if iscollision then
				army:onCollisionBullet(bullet)
				bullet:onCollision(army)
				self:onBulletHitArmy( bullet, army )
				--最后再处理去除逻辑
				table.remove(bulletSet, i)
				table.remove(armySet, army.key_)

				break
			end
		end

		--子弹超出边界就去除掉
		if bullet:getPositionY() >= display.height + bullet:getViewRect().height* 0.5 then 
			table.remove(bulletSet, i)
			bullet:removeSelf()
		end
	end

	--生成敌人
	tempTime = tempTime + dt
	local armtTime = self:getArmyTime()
	if tempTime >= armtTime then
		tempTime = 0 
		--只有全部敌人数量超过三十个才要创建
		if #armySet <= 0 then
			self:onCreateArmy()
		end
	end
end

--子弹击中敌人的回调，这里可以处理连击
function GameScene:onBulletHitArmy( bullet_, army_ )
	local id = army_:getId()
	--如果是和之前打到的是相同的id就增加
	if id == lastHitArmyId then 
		hitSameArmyNum = hitSameArmyNum + 1
	else
		commboTimes = 0
		hitSameArmyNum = 0
		lastHitArmyId = id 
		self:updateCommbo()
	end

	--一般保持在三个连击
	if hitSameArmyNum >= 3 then 
		commboTimes = commboTimes + 1
		hitSameArmyNum = 0
		self:updateCommbo()
	end
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

end

--角色死亡回调函数
function GameScene:onPlayerDead( target )
	if target then 
		target:setLocalZOrder(100)
	end
	__G__ExplosionSound()
	self.cutBtn_:setTouchEnabled(false)
	-- self.gameLayer_:removeKeypad()
	-- self.gameLayer_:removeAccelerate()
	self.gameLayer_:pauseAllInput()
	self:unUpdate()
	__G__MusicFadeOut(self, 1)
	--根据排名来确定是否有续命选项
	local rank = GameData:getInstance():getRank()
	if rank <= 50 then 
		ContinueTimes = 1
	elseif rank <= 20 then 
		ContinueTimes = 0
	end

	__G__actDelay( self, function (  )
	if not self:getChildByTag(TAG_CONTINUE_LAYER) then
			if ContinueTimes > 0 then 
				local layer = __G__createContinueLayer("Layer/ContinueLayer.csb")
				self:addChild(layer, 100, TAG_CONTINUE_LAYER)
			else
				--直接进入结算关卡,相当于按下取消
				self:onContinueCancel()
			end
		end
	end, 1.5 )
	device.vibrate( 0.2 )
end

--玩家复活继续游戏
function GameScene:onContinue()
	local callback = function ()
		__G__actDelay(self, function()
			self.gameLayer_:resumeAllInput()	
			self.cutBtn_:setTouchEnabled(true)
			if self.role_ then 
				self.role_:setVisible(true)
				self.role_:relive()
				self:onUpdate(handler(self, self.step))
			end
			ContinueTimes = ContinueTimes - 1
		end, 0.2)
	end

	--判断能否播放广告，可以就播放,原型测试暂时关闭
	SDKManager:getInstance():showVideo( callback )
end

--玩家不复活继续游戏
function GameScene:onContinueCancel()
	--这里保存数据
	local rank = GameData:getInstance():getRank()
	local score = GameData:getInstance():getScore()
	GameData:getInstance():insertRank( rank, score )
	GameData:getInstance():save()

	__G__actDelay(self,function (  )
		self:getApp():enterScene("ResultScene")
	end, 1.0)
end

--从排行榜读取分数

--敌人死亡的回调函数
--只有敌人死亡时候才更新分数和排名
function GameScene:onArmyDead( target)
	__G__ExplosionSound()
	local scoreFactor = self:getScoreAddFactor()
	local score = target:getScore() * scoreFactor

	GameData:getInstance():addScore( score ) 
	--分数改变时候更新分数
	self:updateScore( score )
	--排名改变时候更新排名
	--如果两次的排行榜数据不同就更新显示
	local score = GameData:getInstance():getScore()
	local rank = GameData:getInstance():getRankFromScore(score) 
	local oldRank = GameData:getInstance():getRank()
	if rank < oldRank then
		GameData:getInstance():setRank(rank) 
		self:updateRank()
	end
	self:updateSpeed()
end

function GameScene:updateSpeed()	
	local rank = GameData:getInstance():getRank()
	local speed = (100-rank) * 0.01 + 1.01
	GameData:getInstance():setGameSpeed(speed)
end

function GameScene:getScoreAddFactor()
	local factor = math.pow(2, commboTimes)
	--限制最高为32
	if factor >= 32 then 
		factor = 32
	end
	return factor
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

	local commboLb = ui_:getChildByName("commboNum")
	commboLb:hide()
	self.commboLb_ = commboLb
	local commboTitle = ui_:getChildByName("comboTitle")
	commboTitle:hide()
	self.commboTitle_ = commboTitle
	local plusTitle = ui_:getChildByName("plusScore")
	plusTitle:hide()
	local x,y = plusTitle:getPosition()
	plusTitle.originPos_ = cc.p(x,y)
	self.plusTitle_ = plusTitle

	--直接更新
	self:flashScore()
	
end

function GameScene:flashScore()
	local score = GameData:getInstance():getScore()
	self.scoreLb_:setString(string.format("%04d", score))
end

--更新commbo,更新数字
function GameScene:updateScore( changeScore )
	__G__actDelay(self, function (  )
		self:flashScore()
	end, 0.4)

	if changeScore then 
		local str = string.format("+%d", changeScore)
		self.plusTitle_:setString(str)
		local act = cc.Sequence:create( cc.Show:create(), cc.FadeIn:create(0.1), cc.Spawn:create( cc.ScaleTo:create(0.5, 1.2), cc.MoveBy:create(0.5, cc.p(0, 10)),cc.FadeOut:create(0.5) ),cc.Hide:create() )
		self.plusTitle_:setScale(1)
		if self.plusTitle_.originPos_ then 
			local pos = self.plusTitle_.originPos_
			self.plusTitle_:setPosition(pos)
		end
		self.plusTitle_:runAction(act)
	end
end

function GameScene:updateCommbo()
	-- commboTimes
	if commboTimes <= 0 then 
		--hide
		self.commboTitle_:hide()
		self.commboLb_:hide()
	else
		self.commboTitle_:show()
		self.commboLb_:show()
		self.commboLb_:setString(commboTimes)
	end
end

function GameScene:updateRank()
	self.rankLb_:setString( GameData:getInstance():getRank() )
end

function GameScene:initControl()
	local fileName = "Layer/ControlLayer.csb"
	local controlLayer = display.newCSNode(fileName)
	self:addChild(controlLayer, 2, TAG_CONTROL_LAYER)

	local left = controlLayer:getChildByName("Left")
	local right = controlLayer:getChildByName("Right")
	local fire = controlLayer:getChildByName("Fire")

	left:onTouch(function ( event )
		if event.name == "began" then 
			if self.role_ and self.role_.onLeft then 
				self.role_:onLeft( self.role_:getViewRect().width * 0.6 )
			end
		end
	end)

	right:onTouch(function ( event )
		if event.name == "began" then 
			if self.role_ and self.role_.onRight then 
				self.role_:onRight( self.role_:getViewRect().width * 0.6 )
			end
		end
	end)

	fire:onTouch(function ( event )
		if event.name == "began" then 
			if self.role_ and self.role_.fireBullet then 
				self.role_:fireBullet()
			end
		end
	end)


end

function GameScene:initObj()
	local gameLayer = display.newLayer()
	self:addChild(gameLayer, 1, TAG_GAME_LAYER)
	self.gameLayer_ = gameLayer
	local id = GameData:getInstance():getRoleId()
	local plane = PlaneFactory:getInstance():createRole(id)
	local width = plane:getViewRect().width
	plane:pos(display.cx - width * 0.6, display.height /4 )
	gameLayer:addChild(plane)
	self.role_ = plane

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

--主角发射炮弹的回调函数
function GameScene:onFireBullet( id_ )
	local role = self.role_
	if #bulletSet >= role:getBulletFireNum() then return end
	local bullet = PlaneFactory:getInstance():createBullet(id_)
	local gameLayer = self.gameLayer_
	local roleX,roleY = role:getPosition()
	bullet:pos(roleX, roleY + role:getViewRect().height *0.5 + bullet:getViewRect().height * 0.25)
	bullet:onFire()
	gameLayer:addChild(bullet)
	table.insert(bulletSet, bullet)
end

--获得army的数据，根据数据来创建敌机
function GameScene:getArmyData(  )
	local num = math.random(1, MAX_ARMY_ROUND)
	local armyData = GameData:getInstance():getArmyConfig(num)
	dump(armyData)
	return armyData
end

function GameScene:onCreateArmy(  )
	--读取plist数据创建敌人
	local armyData = self:getArmyData()
	for i, armyInfo in pairs(armyData) do
		local id = armyInfo.id
		local army = PlaneFactory:getInstance():createPlane(id)

		local width = army:getViewRect().width
		local dir = armyInfo.x > display.cx and 1 or -1
		local x = display.cx + width * 0.6 * dir
		local armyPos = cc.p(x, armyInfo.y)
		local armySpeed = self:getArmySpeed()
		army:setSpeed(cc.p(0, armySpeed))
		army:setDirX(dir)
		army:pos(armyPos)
		self.gameLayer_ :addChild(army)
		table.insert(armySet, army)
	end
	--调整一下游戏背景速度
	local bgSpeed = self:getBgSpeed()
	local bg = self:getChildByTag(TAG_BG)
	if bg and bg.setSpeed then 
		bg:setSpeed(bgSpeed)
	end
end

function GameScene:getBgSpeed()
	local rank = GameData:getInstance():getRank()
	local speed = (100-rank) * 0.08 + 2
	--最快到8
	return (0-speed)
end

function GameScene:getArmySpeed()
	--根据排名来获得分数
	local rank = GameData:getInstance():getRank()
	local speed = 10
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
	self:getApp():enterLoading("SelectScene")
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