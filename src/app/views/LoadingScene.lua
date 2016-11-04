local LoadingScene = class("LoadingScene", cc.load("mvc").ViewBase)

LoadingScene.RESOURCE_FILENAME = "Layer/Loading.csb"

local LOADING_DT = 1

function LoadingScene:onCreate(  )
	local root = self:getResourceNode()
	self.title_ = root:getChildByName("Loading") 

	self.time_ = 0
	self.needAds_ = false

	local bg = __G__createBg( "Layer/BackGround.csb" )
	bg:setSpeed(-5)
	self:add(bg, -1)
end

function LoadingScene:setNeedAds( needAds_ )
	self.needAds_ = needAds_
end

function LoadingScene:setNextScene( sceneName )
	self.sceneName_ = sceneName
end

function LoadingScene:onEnter()
	self:unUpdate()
	audio.stopMusic(false)
	self:onUpdate(handler(self, self.update))
end

function LoadingScene:update(dt)
	self.time_ = self.time_ + dt

	if self.time_ >=  3*LOADING_DT then 
		self.title_:setString("Loading...")
		self.time_ = 0
		self:unUpdate()
		local callback = function()
			__G__actDelay(self, function (  )
				self:getApp():enterScene(self.sceneName_)
			end, 1.0)
			SDKManager:getInstance():setFULLADCallback( nil)
		end

		if self.needAds_ and SDKManager:getInstance():isFULLADAvailable() then
			SDKManager:getInstance():setFULLADCallback( callback)
			SDKManager:getInstance():showFULLAD()
		else
			callback()
		end
	elseif self.time_ >= 2* LOADING_DT then 
		self.title_:setString("Loading..")
	elseif self.time_ >= LOADING_DT then
		self.title_:setString("Loading.")
	end
end

function LoadingScene:onExit()
	self:unUpdate()
end

return LoadingScene