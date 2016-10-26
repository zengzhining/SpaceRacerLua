local GameScene = class("MainScene", cc.load("mvc").ViewBase)

function GameScene:onCreate()
	-- body
	
end

function GameScene:onEnter()
	audio.stopMusic()
end

function GameScene:onExit()

end

return GameScene