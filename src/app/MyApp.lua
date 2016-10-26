
MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())

    sdkbox.PluginGoogleAnalytics:init()
end

_G["gameApp"] = MyApp