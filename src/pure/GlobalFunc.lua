
--全局函数

__G__createCutLayer = function ( fileName )
	local layer = display.newLayer(cc.c4b(255, 255, 255, 150))

	local node = display.newCSNode(fileName)
	layer:addChild(node)

	local resume = node:getChildByName("Resume")
	resume:onTouch(function ( event )
		if event.name == "ended" then
			local scene = layer:getParent()
			if scene and scene.onResume then 
				scene:onResume()
			end		
		end
	end, false, true)

	local restart = node:getChildByName("Restart")
	restart:onTouch(function ( event )
		if event.name == "ended" then
			local scene = layer:getParent()
			if scene and scene.onRestart then 
				scene:onRestart()
			end		
		end
	end,  false, true)

	local exit = node:getChildByName("Exit")
	exit:onTouch(function ( event )
		if event.name == "ended" then
			local scene = layer:getParent()
			if scene and scene.onCutExit then 
				scene:onCutExit()
			end		
		end
	end,  false, true)


	return layer
end

__G__createOverLayer = function ( fileName )
	local layer = display.newLayer(cc.c4b(255, 255, 255, 100))

	local node = display.newCSNode(fileName)
	layer:addChild(node)

	local Retry = node:getChildByName("Retry")
	Retry:onTouch(function ( event )
		if event.name == "ended" then
			local scene = layer:getParent()
			if scene and scene.onRetry then 
				scene:onRetry()
			end		
		end
	end, false, true)

	local exit = node:getChildByName("Exit")
	exit:onTouch(function ( event )
		if event.name == "ended" then
			local scene = layer:getParent()
			if scene and scene.onGameExit then 
				scene:onGameExit()
			end		
		end
	end,  false, true)


	return layer
end

__G__createBg = function (fileName)
	local layer = display.newLayer()
	local node = display.newCSNode(fileName)
	layer.speed_ = -2

	layer:enableNodeEvents()
	
	layer:addChild(node)

	function layer:onEnter()
		layer:unUpdate()
		layer:onUpdate(handler(layer, layer.update))
	end

	function layer:setSpeed(speed)
		self.speed_ = speed
	end

	function layer:update(dt)
		local gameSpeed = GameData:getInstance():getGameSpeed()
		local tbl ={ "Bg", "BgUp" }
		for c, key in pairs (tbl) do
			local bg = node:getChildByName(key)
			if bg:getPositionY() <= 0 then
				bg:posY(display.height * 2)
			end
			bg:posByY(self.speed_ * gameSpeed)
		end
	end

	return layer
end

--延时执行动作
__G__actDelay = function (target, callback, time)
	local act = cc.Sequence:create( cc.DelayTime:create(time), cc.CallFunc:create(function ( obj )
		callback()
	end)) 
	target:runAction(act)
end

--背景音乐淡出
__G__MusicFadeOut = function(target, time)
	local time_ = 0
	local originVol = audio.getMusicVolume()
	local dVol = originVol / time
	target:onUpdate( function ( dt )
		time_ = time_ + dt
		audio.setMusicVolume(originVol-(dVol* time_))

		if time_ >= time then 
			audio.setMusicVolume(originVol)
			target:unUpdate()
		end
	end )
end

--菜单点击音效播放
__G__MenuClickSound = function (  )
	audio.playSound("sfx/sound/click.wav", false)
end

--菜单点击取消的音效
__G__MenuCancelSound = function (  )
	audio.playSound("sfx/sound/cancel.wav", false)
end

--爆炸音效
__G__ExplosionSound = function (  )
	audio.playSound("sfx/sound/explosion.wav", false)
end

--背景音乐播放，1为菜单，2为游戏场景，3为结算场景
__G__MainMusic = function( id )
	if not id then id = 1 end
	audio.stopMusic()
	audio.playMusic("sfx/mainMenu.mp3")
end
