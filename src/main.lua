require "cocos.init"
--设计分辨率大小
local designResolutionSize = cc.size(320, 568)
local smallResolutionSize = cc.size(640, 960)
local largeResolutionSize = cc.size(750, 1334)

local breakSocketHandle, debugXpCall = require("LuaDebugjit")("localhost", 7003)
cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
    breakSocketHandle();
end, 0.3, false)

function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    debugXpCall();
end
cclog = function(...)
    print(string.format(...))
end

local function main()
    cc.FileUtils:getInstance():setPopupNotify(false)

    collectgarbage("collect")
    local director = cc.Director:getInstance()
    local glView = director:getOpenGLView();

    local sharedFileUtils = cc.FileUtils:getInstance();
    sharedFileUtils:addSearchPath("src")
    sharedFileUtils:addSearchPath("res")
    --package.path = package.path .. ".;src/"
    --package.path = package.path .. ".;res/"
    --package.cpath = package.cpath .. "."

    local searchPaths = sharedFileUtils:getSearchPaths()
    local resPrefix = "res/"

    --   屏幕大小
    local frameSize = glView:getFrameSize()
    --设计分辨率大小
    local designSize = cc.size(320, 480)
    --资源大小
    local resourceSize = cc.size(640, 960)

    if frameSize.height > smallResolutionSize.height then
        director:setContentScaleFactor(math.min(largeResolutionSize.height / designResolutionSize.height, largeResolutionSize.width / designResolutionSize.width))
        table.insert(searchPaths, 1, resPrefix .. "large")
    else
        director:setContentScaleFactor(math.min(smallResolutionSize.height / designResolutionSize.height, smallResolutionSize.width / designResolutionSize.width))
        table.insert(searchPaths, 1, resPrefix .. "small")
    end
    --    设置资源搜索路径
    sharedFileUtils:setSearchPaths(searchPaths)
    --    分辨率的设置
    glView:setDesignResolutionSize(designResolutionSize.width, designResolutionSize.height, cc.ResolutionPolicy.FIXED_HEIGHT)
    --    是否显示精灵和帧率
    director:setDisplayStats(true)
    --    设置帧率
    director:setAnimationInterval(1.0 / 60)
    --    创建场景
    local scene = require("scenes.LoadingScene")
    local loadingScene = scene.create()

    cclog("abc")
    if director:getRunningScene() then
        director:replaceScene(loadingScene)
    else
        director:runWithScene(loadingScene)
    end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end


