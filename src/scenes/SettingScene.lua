---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yuyan.
--- DateTime: 2018/9/23 14:58
---
--require "SystemConst"

local size = cc.Director:getInstance():getWinSize();
local frameCache = cc.SpriteFrameCache:getInstance();
local textureCache = cc.Director:getInstance():getTextureCache()
local defaults = cc.UserDefault:getInstance()

local SettingScene = class("SettingScene", function()
    return cc.Scene:create()
end)

function SettingScene.create()
    --cclog("hello create lua")
    local _SettingScene = SettingScene.new()
    _SettingScene:addChild(_SettingScene:createLayer())
    return _SettingScene
end

function SettingScene:ctor()
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

function SettingScene:onEnter()
    cclog("SettingScene onEnter")

end

function SettingScene:onEnterTransitionFinish()
    cclog("SettingScene onEnterTransitionFinish")

end

function SettingScene:onExit()
    cclog("SettingScene onExit")
end

function SettingScene:onExitTransitionStart()
    cclog("SettingScene onExitTransitionStart")
end

function SettingScene:cleanup()
    cclog("SettingScene onCleanup")
end

function SettingScene:createLayer()
    local layer = cc.Layer:create();
    local bg = cc.TMXTiledMap:create("map/red_bg.tmx")
    layer:addChild(bg)
    --todo add layer content
    local top = cc.Sprite:createWithSpriteFrameName("setting.page.png")
    top:setPosition(cc.p(size.width / 2, size.height - top:getContentSize().height / 2))
    layer:addChild(top)

    -- callback
    local function menuSoundToggleCallback(sender)
        if defaults:getBoolForKey(SOUND_KEY, false) then
            defaults:setBoolForKey(SOUND_KEY, false)
        else
            defaults:setBoolForKey(SOUND_KEY, true)
            AudioEngine.playEffect(sound_1)
        end
    end
    --     音效
    local soundOnSprite = cc.Sprite:createWithSpriteFrameName("check-on.png")
    local soundOffSprite = cc.Sprite:createWithSpriteFrameName("check-off.png")
    local soundONMenuItem = cc.MenuItemSprite:create(soundOnSprite, soundOnSprite)
    local soundOffMenuItem = cc.MenuItemSprite:create(soundOffSprite, soundOffSprite)
    local soundToggleMenuItem = cc.MenuItemToggle:create(soundONMenuItem, soundOffMenuItem)
    soundToggleMenuItem:registerScriptTapHandler(menuSoundToggleCallback)
    -- music call back
    local function menuMusicCallBack(tag, sender)
        if defaults:getBoolForKey(MUSIC_KEY, false) then
            defaults:setBoolForKey(MUSIC_KEY, false)
            AudioEngine.stopMusic()
        else
            defaults:setBoolForKey(MUSIC_KEY, true)
            AudioEngine.playMusic(bg_music_2, true)
        end

        if defaults:getBoolForKey(SOUND_KEY) then
            AudioEngine.playEffect(sound_1)
        end
    end

    local musicOnSprite = cc.Sprite:createWithSpriteFrameName("check-on.png")
    local musicOffSprite = cc.Sprite:createWithSpriteFrameName("check-off.png")
    local musicOnMenuItem = cc.MenuItemSprite:create(musicOnSprite, musicOnSprite)
    local musicOffMenuItem = cc.MenuItemSprite:create(musicOffSprite, musicOffSprite)
    local musicToggleMenuItem = cc.MenuItemToggle:create(musicOnMenuItem, musicOffMenuItem)
    musicToggleMenuItem:registerScriptTapHandler(menuMusicCallBack)

    local menu = cc.Menu:create(soundToggleMenuItem, musicToggleMenuItem)
    menu:setPosition(cc.p(size.width / 2 + 70, size.height / 2 + 60))
    menu:alignItemsVerticallyWithPadding(12)
    layer:addChild(menu, 1)

    local function menuOkCallBack(sender)
        cc.Director:getInstance():popScene()
        if defaults:getBoolForKey(SOUND_KEY) then
            AudioEngine.playEffect(sound_1)
        end
    end

    local okNormal = cc.Sprite:createWithSpriteFrameName("button.ok.png")
    local okSelected = cc.Sprite:createWithSpriteFrameName("button.ok-on.png")

    local okMenuItem = cc.MenuItemSprite:create(okNormal, okSelected)
    okMenuItem:registerScriptTapHandler(menuOkCallBack)

    local okMenu = cc.Menu:create(okMenuItem)
    okMenu:setPosition(cc.p(190, 50))
    layer:addChild(okMenu)


    --    设置音效和音乐选中状态
    if defaults:getBoolForKey(MUSIC_KEY, false) then
        musicToggleMenuItem:setSelectedIndex(0)
    else
        musicToggleMenuItem:setSelectedIndex(1)
    end
    if defaults:getBoolForKey(SOUND_KEY, false) then
        soundToggleMenuItem:setSelectedIndex(0)
    else
        soundToggleMenuItem:setSelectedIndex(1)
    end

    return layer
end

return SettingScene

