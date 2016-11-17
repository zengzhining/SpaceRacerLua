local DesignScene = class("DesignScene", cc.load("mvc").ViewBase)


local TAG_ARMY_LAYER = 101

local planeSet = {}
local selectPlane = nil


--------------function----------------
local function convertCamera( point )
	local camera = display.getDefaultCamera()
	local p = camera:convertToWorldSpace(cc.p(point.x, point.y))
	p.x = p.x - display.cx
	p.y = p.y - display.cy
	return p
end







----------------------------


function DesignScene:initData(  )
	-- body
	planeSet = {}

	--点击中的机体
	selectPlane = nil
end

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

	-- local plane = PlaneFactory:getInstance():createPlane(1)
	-- plane:pos(display.cx, display.cy)
	-- plane:setCameraMask(cc.CameraFlag.DEFAULT)
	-- self:addChild(plane)

	self:initData()

	self:initControl()

	local title = display.newTTF(nil,nil,"pos:")
	title:setAnchorPoint(cc.p(0,1))
	title:pos(0,display.height)
	title:setCameraMask(cc.CameraFlag.USER1)
	self:addChild(title)

	title:onUpdate(function ( dt )
		local defaultCamera = display.getDefaultCamera()
		local posx, posy = defaultCamera:getPosition()
		local str = string.format("camera pos:%d,%d", posx, posy)
		title:setString(str)
	end)

	local camera = cc.Camera:createOrthographic(display.width, display.height,-11,1000)
	camera:setCameraFlag(cc.CameraFlag.USER1)
	-- local scene = display.getRunningScene()

	self:addChild(camera)

	local armyLayer = display.newLayer()
	self:addChild(armyLayer,1, TAG_ARMY_LAYER)
	
end

function DesignScene:initControl()
	local layer = display.newLayer()
	self:addChild(layer,10)

	layer:onTouch(function ( event )
		if event.name == "began" then 
			
			local p = convertCamera(cc.p(event.x, event.y))
			--这次点击是否点击到物体，如果之前点击了这次没点击到就不创建
			local isTouchPlane = false

			for c,plane in pairs(planeSet) do
				local rect = plane:getViewRect()
				local isContant = cc.rectContainsPoint(rect, p)
				if isContant then
					if selectPlane then 
						selectPlane:setColor(cc.c3b(255, 255, 255))
					end
					plane:setColor(cc.c3b(255, 255, 0))
					selectPlane = plane
					selectPlane.key_ = c
					isTouchPlane = true
					break
				end
			end

			if isTouchPlane == false then 
				if selectPlane then 
					selectPlane:setColor(cc.c3b(255, 255, 255))
					selectPlane = nil
					return true
				end
			end

			if selectPlane == nil then
				self:createPlane(p.x, p.y )
			else
				return true
			end
		elseif event.name == "moved" then 
			local p = convertCamera(cc.p(event.x, event.y))
			if selectPlane then 
				selectPlane:pos(p)
			end
		end
	end)

	layer:onKeypad(function ( event )
		-- body
		local keycode = event.keycode
		if keycode == cc.KeyCode.KEY_W then 
			self:cameraMove(1)
		elseif keycode == cc.KeyCode.KEY_S then 
			self:cameraMove(-1)
		elseif keycode == cc.KeyCode.KEY_Q then 
			self:save()
		elseif keycode == cc.KeyCode.KEY_SPACE then
			self:changePlaneId()
		elseif keycode == cc.KeyCode.KEY_DELETE then
			self:deleteSelectPlane()
		end
	end)
end

function DesignScene:deleteSelectPlane()
	if selectPlane then 
		table.remove(planeSet, selectPlane.key_)
		selectPlane:removeSelf()
		selectPlane = nil
	end
end

function DesignScene:changePlaneId()
	local idTbl = { "#RedPlane.png", "#GreyPlane.png" }
	if selectPlane then 
		local id = selectPlane:getId()
		if id == 1 then 
			id =  2
		elseif id == 2 then
			id = 1
		end 

		local res = idTbl[id]
		selectPlane:setSpriteFrame(display.newSpriteFrame(res))
		selectPlane:setId(id)
	end
end

function DesignScene:createPlane( x,y  )
	local layer = self:getChildByTag(TAG_ARMY_LAYER)
	local plane = PlaneFactory:getInstance():createPlane(1)
	plane:pos(x,y)
	layer:add(plane)
	table.insert(planeSet, plane)
end

function DesignScene:save()
	local tbl = {}
	for c,plane in pairs(planeSet) do
		local item = {}
		item.id = plane:getId()
		item.x,item.y = plane:getPosition()
		table.insert(tbl, item)
	end

	print("now save data:")
	dump(tbl)

	gameio.writeVectorPlistToFile(tbl, "./res/config/army.plist")

end

function DesignScene:cameraMove( speed )
	local camera = display.getDefaultCamera()
	-- camera:posByY(speed * display.cy)
	local act = cc.MoveBy:create(0.2, cc.p( 0, speed * display.cy ))
	camera:runAction(act)
end

function DesignScene:onEnter()
	
end

function DesignScene:onExit()

end

return DesignScene