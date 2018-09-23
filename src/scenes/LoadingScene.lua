require "SystemConst"

local size = cc.Director:getInstance():getWinSize();
local frameCache = cc.SpriteFrameCache:getInstance();
local textureCache = cc.Director:getInstance():getTextureCache()

local LoadingScene = class("LoadingScene", function()
    return cc.Scene:create()
end)

function LoadingScene.create()
    cclog("hello create lua")
    local scene = LoadingScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function LoadingScene:ctor()
    cclog("hello ctor")
    local function onNodeEvent(event)
        if event == CC_LiftCycle.Enter then
            self:onEnter()
        elseif event == CC_LiftCycle.EnterTransitionFinish then
            self:onEnterTransitionFinish()
        elseif event == CC_LiftCycle.onExitTransitionStart then
            self:onExitTransitionStart()
        elseif event == CC_LiftCycle.Exit then
            self:onExit()
        elseif event == CC_LiftCycle.cleanup then
            self:cleanup()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function LoadingScene:createLayer()
    cclog("LoadingSceneLayer init")
    local layer = cc.Layer:create();

    frameCache:addSpriteFrames(loading_texture_plist)
    local bg = cc.TMXTiledMap:create("map/red_bg.tmx")
    layer:addChild(bg)

    local logo = cc.Sprite:createWithSpriteFrameName("logo.png")
    layer:addChild(logo)
    logo:setPosition(cc.p(size.width / 2, size.height / 2))

    local sprite = cc.Sprite:createWithSpriteFrameName("loding4.png")
    layer:addChild(sprite)
    local logoX, logoY = logo:getPosition()
    sprite:setPosition(cc.p(logoX, logoY - 130))

    --[[
    动画开始
    ]]

    local animation = cc.Animation:create();
    for i = 1, 4 do
        local frameName = string.format("loding%d.png", i)
        cclog("frameName = %s", frameName)
        local spriteFrame = frameCache:getSpriteFrameByName(frameName)
        animation:addSpriteFrame(spriteFrame)
    end

    animation:setDelayPerUnit(.5)
    animation:setRestoreOriginalFrame(true)

    local action = cc.Animate:create(animation)
    sprite:runAction(cc.RepeatForever:create(action))

    local function loadingTextureCallBack(texture)
        frameCache:addSpriteFrames(texture_plist)
        cclog("loading texture ok !")
        --    初始化音乐
        AudioEngine.preloadMusic(bg_music_1)
        AudioEngine.preloadMusic(bg_music_2)
        --    初始化音效
        AudioEngine.preloadEffect(sound_1)
        AudioEngine.preloadEffect(sound_2)
        --performWithDelay(texture,, 2)
        --cc.Sequence:create(2, cc.CallFunc:create(function()
        --end))
        local HomeScene = require("scenes.HomeScene")
        --local HomeScene = require("HomeScene")
        local _homeScene = HomeScene.create()
        cc.Director:getInstance():pushScene(_homeScene)

    end

    textureCache:addImageAsync(texture_res, loadingTextureCallBack)
    return layer;
end

function LoadingScene:onEnter()
    cclog("LoadingScene onEnter")

end

function LoadingScene:onEnterTransitionFinish()
    cclog("LoadingScene onEnterTransitionFinish")

end

function LoadingScene:onExit()
    cclog("LoadingScene onExit")
end

function LoadingScene:onExitTransitionStart()
    cclog("LoadingScene onExitTransitionStart")
end

function LoadingScene:cleanup()
    cclog("LoadingScene onCleanup")
end

return LoadingScene

