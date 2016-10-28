
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
    print("CC_NEED_SDK~~~~", CC_NEED_SDK)
    SDKManager:getInstance()
end

return MyApp