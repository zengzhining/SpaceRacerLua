GameData = class("GameData")

local MAX_RANK = 100
local BG_SPEED = 10

local DEFAULT_ROLE = 1
function GameData:ctor()
	self:initData()
end

function GameData:initData()
	self.score_ = 0
	self.rank_ = MAX_RANK
	self.lastRank_ = MAX_RANK
	--游戏背景移动速度
	self.bgSpeed_ = MAX_RANK

	--游戏速度
	self.gameSpeed_ = 1.0
	--角色id
	self.roleId_ = DEFAULT_ROLE

	--排行榜数据
	self.rankInfo_ = nil

	self:load()
end
--读取和存储游戏数据
function GameData:load()
    local fileUtils = cc.FileUtils:getInstance()
	local data = fileUtils:getValueVectorFromFile("score.plist")
	self.rankInfo_ = data
end

--插入分数
function GameData:insertRank( pos,score )

end

--从排行榜中取得分数
function GameData:getRankFromScore( score )
	for i = 100 , 1 ,-1 do
		local hScore = self.rankInfo_[i]
		if score <= hScore then 
			return i
		end
	end
	return 1
end

function GameData:save()

end

function GameData:reset()
	self:initData()
end

function GameData:setRoleId( id_ )
	self.roleId_ = id_
end

function GameData:getRoleId()
	return self.roleId_
end

function GameData:setGameSpeed(speed_)
	self.gameSpeed_ = speed_
end

function GameData:getGameSpeed()
	return self.gameSpeed_
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
	return self.rank_
end

function GameData:getLastRank()
	return self.lastRank_ 
end

function GameData:setLastRank( rank )
	self.lastRank_ = rank
end

-----单例
local gamedata_instance = nil
function GameData:getInstance()
	if not gamedata_instance then 
		gamedata_instance = GameData.new()
	end

	GameData.new = function (  )
		error("GameData Cannot use new operater,Please use getInstance")
	end

	return gamedata_instance
end