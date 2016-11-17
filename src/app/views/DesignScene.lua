local DesignScene = class("DesignScene", cc.load("mvc").ViewBase)

function DesignScene:onCreate()
	-- body
	if DEBUG == 2 then 
		display.loadSpriteFrames("Plane.plist", "Plane.png")
	end
	--数据生成
	-- local tbl = { 
	-- 	{armyType = 1, posx = 1, posy = 100},
	-- 	{armyType = 1, posx = 1, posy = 100}
	--  }

	-- gameio.writeVectorPlistToFile(tbl, "./res/config/army.plist")
	-- local tbl = gameio.getVectorPlistFromFile("config/army.plist")
	-- dump(tbl)

	--镜头移动

	local plane = PlaneFactory:getInstance():createRole(1)
	plane:pos(display.cx, display.cy)
	self:addChild(plane)

	self:initControl()
end

function DesignScene:initControl()
	local layer = display.newLayer()
	self:addChild(layer,10)

	layer:onTouch(function ( event )
		if event.name == "began" then 

		end
	end)

	layer:onKeypad(function ( event )
		-- body
		local keycode = event.keycode
		if keycode == cc.KeyCode.KEY_W then 
			self:cameraMove(1)
		elseif keycode == cc.KeyCode.KEY_S then 
			self:cameraMove(-1)
		end
	end)
end

function DesignScene:cameraMove( speed )
	local camera = display.getDefaultCamera()
	camera:posByY(speed * display.cy)
end

function DesignScene:onEnter()

end

function DesignScene:onExit()

end

return DesignScene