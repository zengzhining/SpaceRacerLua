local gameio = {}

local fileUtils = cc.FileUtils:getInstance()

--plist写入
gameio.writeVectorPlistToFile = function ( tbl, path )
	fileUtils:writeValueVectorToFile(tbl, path)
end

--plist读取
gameio.getVectorPlistFromFile = function ( path )
	local data = fileUtils:getValueVectorFromFile(path)
	return data
end

return gameio

