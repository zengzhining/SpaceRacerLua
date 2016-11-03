
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
    SDKManager:getInstance()
end

function MyApp:enterLoading( nextSceneName )
	local view = self:enterScene("LoadingScene")
	view:setNextScene(nextSceneName)
end

return MyApp