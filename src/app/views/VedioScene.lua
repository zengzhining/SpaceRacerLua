local VedioScene = class("VedioScene", cc.load("mvc").ViewBase)

function VedioScene:onCreate()
    print("Sample Startup")

    local label = cc.Label:createWithSystemFont("QUIT", "sans", 32)
    local quit = cc.MenuItemLabel:create(label)
    quit:onClicked(function()
        os.exit(0)
    end)
    local size = label:getContentSize()
    local menu = cc.Menu:create(quit)
    menu:setPosition(display.right - size.width / 2 - 16, display.bottom + size.height / 2 + 16)
    self:addChild(menu)

    self:setupTestMenu()
end

function VedioScene:setupTestMenu()
    -- reward amount label
    local rewardAmount = 0
    local rewardLabel = cc.Label:createWithSystemFont("0", "sans", 32)
    rewardLabel:setPosition(display.cx, 60)
    self:addChild(rewardLabel)

    -- event label
    local eventLabel = cc.Label:createWithSystemFont("No event", "sans", 32)
    eventLabel:setAnchorPoint(cc.p(0,0))
    eventLabel:setPosition(5, 5)
    self:addChild(eventLabel)

    --
    sdkbox.PluginAdColony:init()
    sdkbox.PluginAdColony:setListener(function(args)
        dump(args)
        eventLabel:setString(args.name)

        if args.name == "onAdColonyReward" then
            rewardAmount = rewardAmount + args.amount
            rewardLabel:setString(tostring(rewardAmount))
        end

    end)

    local label1 = cc.Label:createWithSystemFont("show video", "sans", 28)
    local item1 = cc.MenuItemLabel:create(label1)
    item1:onClicked(function()
        print("show video")
        sdkbox.PluginAdColony:show("restart")
    end)

    local label2 = cc.Label:createWithSystemFont("show v4vc", "sans", 28)
    local item2 = cc.MenuItemLabel:create(label2)
    item2:onClicked(function()
        print("show v4vc")
        sdkbox.PluginAdColony:show("v4vc")
    end)

    local menu = cc.Menu:create(item1, item2)
    menu:alignItemsVerticallyWithPadding(24)
    self:addChild(menu)
end

return VedioScene