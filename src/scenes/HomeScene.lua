require "SystemConst"

local size = cc.Director:getInstance():getWinSize()
local frameCache = cc.SpriteFrameCache:getInstance();
local textureCache = cc.Director:getInstance():getTextureCache()
local defaults = cc.UserDefault:getInstance()

local HomeScene = class("HomeScene", function()
    return cc.Scene:create()
end)

function HomeScene.create()
    cclog("hello create lua")
    local scene = HomeScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function HomeScene:ctor()
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

function HomeScene:createLayer()
    cclog("HomeSceneLayer init ")
    local layer = cc.Layer:create();

    local bg = cc.TMXTiledMap:create("map/red_bg.tmx")
    layer:addChild(bg)

    local top = cc.Sprite:createWithSpriteFrameName("home-top.png")
    top:setPosition(cc.p(size.width / 2, size.height - top:getContentSize().height / 2))
    layer:addChild(top)

    local buttom = cc.Sprite:createWithSpriteFrameName("home-end.png")
    buttom:setPosition(cc.p(size.width / 2, buttom:getContentSize().height / 2))
    layer:addChild(buttom)

    local menuItemCallBack = function(tag, sender)
        --    播放音乐
        if defaults:getBoolForKey(SOUND_KEY) then
            AudioEngine.playEffect(sound_1)
        end

        if tag == HomeMenuActionTypes.MenuItemStart then
            local gameScene = require("scenes.GamePlayScene")
            local scene = gameScene.create();
            local ts = cc.TransitionCrossFade:create(1, scene)
            cc.Director:getInstance():pushScene(ts)
        elseif tag == HomeMenuActionTypes.MenuItemSetting then
            local SettingScene = require("scenes.SettingScene")
            local scene = SettingScene.create()
            local ts = cc.TransitionCrossFade:create(1, scene)
            cc.Director:getInstance():pushScene(ts)
        elseif tag == HomeMenuActionTypes.MenuItemHelp then
            local HelpScene = require("scenes.HelpScene")
            local scene = HelpScene.create();
            local ts = cc.TransitionCrossFade:create(1, scene)
            cc.Director:getInstance():pushScene(ts)
        end
    end

    ----开始菜单
    --local startSpriteNormal = cc.Sprite:createWithSpriteFrameName("button.start.png")
    --local startSpriteSelected = cc.Sprite:createWithSpriteFrameName("button.start-on.png")
    --local startMenuItem = cc.MenuItemSprite:create(startSpriteNormal, startSpriteSelected)
    --startMenuItem:registerScriptHandler(menuItemCallBack)
    --startMenuItem:setTag(HomeMenuActionTypes.MenuItemStart)
    -- 菜单项 start
    local startSpriteNormal = cc.Sprite:createWithSpriteFrameName("button.start.png")
    local startSpriteSelected = cc.Sprite:createWithSpriteFrameName("button.start-on.png")
    local startMenuItem = cc.MenuItemSprite:create(startSpriteNormal, startSpriteSelected)
    startMenuItem:registerScriptTapHandler(menuItemCallBack)
    startMenuItem:setTag(HomeMenuActionTypes.MenuItemStart)
    -- 菜单项 settingMenuItem 
    local settingSpriteNormal = cc.Sprite:createWithSpriteFrameName("button.setting.png")
    local settingSpriteSelected = cc.Sprite:createWithSpriteFrameName("button.setting-on.png")
    local settingMenuItem = cc.MenuItemSprite:create(settingSpriteNormal, settingSpriteSelected)
    settingMenuItem:registerScriptTapHandler(menuItemCallBack)
    settingMenuItem:setTag(HomeMenuActionTypes.MenuItemSetting)
    -- 菜单项 helpMenuItem 
    local helpSpriteNormal = cc.Sprite:createWithSpriteFrameName("button.help.png")
    local helpSpriteSelected = cc.Sprite:createWithSpriteFrameName("button.help-on.png")
    local helpMenuItem = cc.MenuItemSprite:create(helpSpriteNormal, helpSpriteSelected)
    helpMenuItem:registerScriptTapHandler(menuItemCallBack)
    helpMenuItem:setTag(HomeMenuActionTypes.MenuItemHelp)

    local menu = cc.Menu:create(startMenuItem, settingMenuItem, helpMenuItem)
    menu:setPosition(size.width / 2, size.height / 2)
    menu:alignItemsVerticallyWithPadding(12)
    layer:addChild(menu)

    return layer
end

function HomeScene:onEnter()
    cclog("HomeScene onEnter")

end

function HomeScene:onEnterTransitionFinish()
    cclog("HomeScene onEnterTransitionFinish")
    if defaults:getBoolForKey(MUSIC_KEY) then
        AudioEngine.playMusic(bg_music_1, true)
    end
end

function HomeScene:onExit()
    cclog("HomeScene onExit")
end

function HomeScene:onExitTransitionStart()
    cclog("HomeScene onExitTransitionStart")
end

function HomeScene:cleanup()
    cclog("HomeScene onCleanup")
end

return HomeScene

