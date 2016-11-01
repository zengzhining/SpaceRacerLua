
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- need SDK
CC_NEED_SDK = false

CC_DEBUG_RECT = true

SDK_BANNER_NAME = "admob"
SDK_FULLAD_NAME = "gameover"
SDK_VEDIO_NAME  = "restart"

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 640,
    height = 1136,
    autoscale = "FIXED_WIDTH",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_HEIGHT"}
        end
    end
}

DEFAULT_SCENE = "ResultScene"