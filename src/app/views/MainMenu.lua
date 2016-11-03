local MainMenu = class("MainMenu", cc.load("mvc").ViewBase)

MainMenu.RESOURCE_FILENAME = "MainMenu.csb"
function MainMenu:onCreate()
	-- body
	local root = self:getResourceNode()

	self:enableNodeEvents()

	local layer = display.newLayer()

	layer:onTouch(function (event  )
		--记得去除掉触摸
		layer:removeTouch()
		-- self:getApp():enterScene("GameScene")
		self:getApp():enterLoading("GameScene")
	end, false, false)
	self:add(layer,1)

	local bg = __G__createBg( "Layer/BackGround.csb" )
	self:add(bg, -1)
end

function MainMenu:onEnter()
	local root = self:getResourceNode()

	local hint = root:getChildByName("Hint")
	local act = cc.RepeatForever:create(cc.Sequence:create( cc.FadeOut:create(2), cc.FadeIn:create(2) ))

	hint:runAction(act)

	-- self:unUpdate()
	-- self:onUpdate( handler(self, self.update) )

	audio.playMusic("sfx/mainMenu.mp3")
end

function MainMenu:update( dt )
	
end

function MainMenu:onExit(  )
	self:unUpdate()
end

return MainMenu