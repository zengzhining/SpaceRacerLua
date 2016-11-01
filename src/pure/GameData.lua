GameData = class("GameData")

function GameData:ctor()
	self.score_ = 0
	self.rank_ = 100

	--游戏背景移动速度
	self.bgSpeed_ = 10
end

--读取和存储游戏数据
function GameData:load()

end

function GameData:save()

end

function GameData:setBgSpeed( speed )
	self.bgSpeed_ = speed
end

function GameData:addBgSpeed( speed )
	self.bgSpeed_ = self.bgSpeed_ + speed
end

function GameData:getBgSpeed()
	return self.bgSpeed_
end


function GameData:setScore( score )
	self.score_ = score
end

function GameData:addScore( score )
	self.score_ = self.score_ + score
end

function GameData:getScore()
	return self.score_
end

function GameData:setRank( rank )
	self.rank_ = rank
end

function GameData:getRank()
	local rank = 100 - math.floor(self.score_ /50)  
	self.rank_ = rank
	return self.rank_
end

-----单例
local gamedata_instance = nil
function GameData:getInstance()
	if not gamedata_instance then 
		gamedata_instance = GameData.new()
	end

	GameData.new = function (  )
		error("GameData Cannot use new operater,Please use geiInstance")
	end

	return gamedata_instance
end