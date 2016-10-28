--负责管理SDK层
SDKManager = class("SDKManager")

function SDKManager:ctor(  )
	if not CC_NEED_SDK then return end
	self:initAllSDK()
	self:addEvent()
	self:cacheADS()
end

function SDKManager:initAllSDK()
	sdkbox.PluginGoogleAnalytics:init()
	--ads
	sdkbox.PluginAdMob:init()

	--review
	sdkbox.PluginReview:init()
end

function SDKManager:addEvent()
	--ads event
	sdkbox.PluginAdMob:setListener(function(args)
        local event = args.event
        dump(args, "admob listener info:")
        if event == "adViewDidReceiveAd" and args.name == SDK_BANNER_NAME then
           SDKManager:showBanner()
       end
    end)

    if AdMobTestDeviceId then
        print("the admob test device id is:", AdMobTestDeviceId)
        sdkbox.PluginAdMob:setTestDevices(AdMobTestDeviceId)
    end

    --review event
    sdkbox.PluginReview:setListener(function(args)
        local event = args.event
        if "onDisplayAlert" == event then
            print("onDisplayAlert")
        elseif "onDeclineToRate" == event then
            print("onDeclineToRate")
        elseif "onRate" == event then
            print("onRate")
        elseif "onRemindLater" == event then
            print("onRemindLater")
        end
    end)
end

--analytics log event
function SDKManager:logEvent( key, value )
	if not CC_NEED_SDK then return end
    sdkbox.PluginGoogleAnalytics:logEvent(key, value, "", 1)
    sdkbox.PluginGoogleAnalytics:dispatchHits()
end

function SDKManager:cacheADS()
	sdkbox.PluginAdMob:cache(SDK_BANNER_NAME)
	sdkbox.PluginAdMob:cache(SDK_FULLAD_NAME)
end

--show ads
function SDKManager:showAds( id_ )
	if not CC_NEED_SDK then return end
	--默认播放全屏
	local adsName = SDK_FULLAD_NAME
	if id_ == 1 then 
		adsName = SDK_BANNER_NAME
	end

	sdkbox.PluginAdMob:show(adsName)
end

function SDKManager:hideAds(id_)
	if not CC_NEED_SDK then return end
	--默认播放全屏
	local adsName = SDK_FULLAD_NAME
	if id_ == 1 then 
		adsName = SDK_BANNER_NAME
	end

	sdkbox.PluginAdMob:hide(adsName)
end

function SDKManager:isAdsAvailable( id_)
	--默认播放全屏
	local adsName = SDK_FULLAD_NAME
	if id_ == 1 then 
		adsName = SDK_BANNER_NAME
	end
	local yes = sdkbox.PluginAdMob:isAvailable(adsName)
	return yes
end

function SDKManager:isBannerAvailable()
	return self:isAdsAvailable(1)
end

function SDKManager:showBanner()
	self:showAds(1)
end

function SDKManager:hideBanner()
	self:hideAds(1)
end

function SDKManager:isFULLADAvailable()
	return self:isAdsAvailable(0)
end

function SDKManager:showFULLAD()
	if self:isFULLADAvailable() then
		self:showAds(0)
	else
		print("FULLAD is not available")
	end
end

function SDKManager:hideFULLAD()
	self:hideAds(0)
end

----------review
function SDKManager:showReview()
	if not CC_NEED_SDK then return end
	sdkbox.PluginReview:show(true --[[ force ]])
end

--单例
local sdk_manager_instance = nil
function SDKManager:getInstance()
	if not sdk_manager_instance then 
		sdk_manager_instance = SDKManager.new()
	end

	SDKManager.new = function (  )
		error("SDKManager Cannot use new operater,Please use geiInstance")
	end

	return sdk_manager_instance
end

