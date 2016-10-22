local GameScene = class("MainScene", cc.load("mvc").ViewBase)

function GameScene:onCreate()
	-- body
	local title = cc.Label:createWithSystemFont("QUIT", "sans", 32)
	title:pos(display.cx, display.cy)
	self:addChild( title )

	self:enableNodeEvents()

	title:moveBy({x = 100, y = 100, time = 10})
end

function GameScene:onEnter()

end

return GameScene