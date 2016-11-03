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
		__G__MenuClickSound()
		__G__MusicFadeOut(self, 1)
		__G__actDelay(self, function (  )
			self:getApp():enterLoading("GameScene")
		end, 1)
	end, false, false)
	self:add(layer,1)

	local bg = __G__createBg( "Layer/BackGround.csb" )
	bg:setSpeed(-5)
	self:add(bg, -1)
end

function MainMenu:onEnter()
	local root = self:getResourceNode()

	local hint = root:getChildByName("Hint")
	local act = cc.RepeatForever:create(cc.Sequence:create( cc.FadeOut:create(2), cc.FadeIn:create(2) ))

	hint:runAction(act)
	
	__G__MainMusic()
end

function MainMenu:onExit(  )
	self:unUpdate()
end

return MainMenu