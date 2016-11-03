local LoadingScene = class("LoadingScene", cc.load("mvc").ViewBase)

LoadingScene.RESOURCE_FILENAME = "Layer/Loading.csb"

local LOADING_DT = 1

function LoadingScene:onCreate(  )
	local root = self:getResourceNode()
	self.title_ = root:getChildByName("Loading") 

	self.time_ = 0
end

function LoadingScene:onEnter()
	self:unUpdate()
	self:onUpdate(handler(self, self.update))
end

function LoadingScene:update(dt)
	self.time_ = self.time_ + dt

	if self.time_ >=  3*LOADING_DT then 
		self.title_:setString("Loading...")
		self.time_ = 0
	elseif self.time_ >= 2* LOADING_DT then 
		self.title_:setString("Loading..")
	elseif self.time_ >= LOADING_DT then
		self.title_:setString("Loading.")
	end
end

function LoadingScene:onExit()

end

return LoadingScene