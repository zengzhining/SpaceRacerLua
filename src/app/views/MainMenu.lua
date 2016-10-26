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
		self:getApp():enterScene("GameScene", "FADE", 2,cc.c3b(255 , 255 , 255) )
	end, false, false)
	self:add(layer,1)
end

function MainMenu:onEnter()
	local root = self:getResourceNode()

	local hint = root:getChildByName("Hint")
	local act = cc.RepeatForever:create(cc.Sequence:create( cc.FadeOut:create(2), cc.FadeIn:create(2) ))

	hint:runAction(act)

	self:unUpdate()
	self:onUpdate( handler(self, self.update) )

	audio.playMusic("sfx/mainMenu.mp3")
end

function MainMenu:update( dt )
	local root = self:getResourceNode()
	local tbl ={ "Bg", "BgUp" }
	for c, key in pairs (tbl) do
		local bg = root:getChildByName(key)
		if bg:getPositionY() <= 0 then
			bg:posY(display.height * 2)
		end
		bg:posByY(-10)
	end
end

function MainMenu:onExit(  )
	self:unUpdate()
end

return MainMenu