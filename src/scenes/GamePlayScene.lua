---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yuyan.
--- DateTime: 2018/9/23 15:00
---
require "SystemConst"
local enemy = require("src.sprite.Enemy")
local Bullet = require("src.sprite.Bullet")
local Fighter = require("src.sprite.Fighter")

local size = cc.Director:getInstance():getWinSize()
local frameCache = cc.SpriteFrameCache:getInstance();
local textureCache = cc.Director:getInstance():getTextureCache()
local defaults = cc.UserDefault:getInstance()


--分数
local score = 0
--记录0~999分数
local scorePlaceholder = 0

local GamePlayScene = class("GamePlayScene", function()
    return cc.Scene:create()
end)

function GamePlayScene.create()
    cclog("hello create lua")
    local _GamePlayScene = GamePlayScene.new()
    return _GamePlayScene
end

function GamePlayScene:ctor()
    self:addChild(self:createInitBGLayer())
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

function GamePlayScene:createInitBGLayer()
    cclog("背景层初始化的")
    local bgLayer = cc.Layer:create()
    local bg = cc.TMXTiledMap:create("map/blue_bg.tmx")
    bgLayer:addChild(bg, 0, GameSceneNodeTag.BatchBackground)

    -- 设置发光粒子
    local ps = cc.ParticleSystemQuad:create("particle/light.plist")
    ps:setPosition(cc.p(size.width / 2, size.height / 2))
    bgLayer:addChild(ps, 0, GameSceneNodeTag.BatchBackground)

    --     设置背景精灵1
    local sprite1 = cc.Sprite:createWithSpriteFrameName("gameplay.bg.sprite-1.png")
    sprite1:setPosition(cc.p(-50, -50))
    bgLayer:addChild(sprite1)

    local ac1 = cc.MoveBy:create(20, cc.p(500, 600))
    local ac2 = ac1:reverse()
    local as1 = cc.Sequence:create(ac1, ac2)
    sprite1:runAction(cc.RepeatForever:create(cc.EaseSineInOut:create(as1)))

    local sprite2 = cc.Sprite:createWithSpriteFrameName("gameplay.bg.sprite-2.png")
    sprite2:setPosition(cc.p(size.width, 0))
    bgLayer:addChild(sprite2)

    local ac3 = cc.MoveBy:create(10, cc.p(-500, 600))
    local ac4 = ac3:reverse()
    local as2 = cc.Sequence:create(ac3, ac4)
    sprite2:runAction(cc.RepeatForever:create(cc.EaseExponentialInOut:create(as2)))

    return bgLayer
end

function GamePlayScene:onEnter()
    cclog("GamePlayScene onEnter")
    self:addChild(self:createLayer())
end

function GamePlayScene:onEnterTransitionFinish()
    cclog("GamePlayScene onEnterTransitionFinish")
    if defaults:getBoolForKey(MUSIC_KEY) then
        AudioEngine.playMusic(bg_music_2, true)
    end
end

function GamePlayScene:onExit()
    cclog("GamePlayScene onExit")
    -- 停止游戏调度
    if schedulerId ~= nil then
        schedule:unscheduleScriptEntry(schedulerId)
    end
    -- 注销事件监听器
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()

    if nil ~= touchFighterListener then
        eventDispatcher:removeEventListener(touchFighterListener)
    end

    if nil ~= contactListener then
        eventDispatcher:removeEventListener(contactListener)
    end

    mainLayer:removeAllChildren()
    mainLayer:removeFormParent()
    mainLayer = nil;
end

function GamePlayScene:onExitTransitionStart()
    cclog("GamePlayScene onExitTransitionStart")
end

function GamePlayScene:cleanup()
    cclog("GamePlayScene onCleanup")
end

function GamePlayScene:createLayer()
    mainLayer = cc.Layer:create();

    -- 添加陨石1
    local stone1 = enemy.create(EnemyTypes.Enemy_Stone)
    mainLayer:addChild(stone1, 10, GameSceneNodeTag.Enemy)
    --添加行星
    local planet = enemy.create(EnemyTypes.Enemy_Planet)
    mainLayer:addChild(planet, 10, GameSceneNodeTag.Enemy)
    -- 添加敌机1
    local enemyFighter1 = enemy.create(EnemyTypes.Enemy_1)
    mainLayer:addChild(enemyFighter1, 10, GameSceneNodeTag.Enemy)
    -- 添加敌机2
    local enemyFighter2 = enemy.create(EnemyTypes.Enemy_2)
    mainLayer:addChild(enemyFighter2, 10, GameSceneNodeTag.Enemy)
    -- 添加飞机
    fighter = Fighter.create("gameplay.fighter.png")
    fighter:setPosition(cc.p(size.width / 2, 70))
    mainLayer:addChild(fighter, 10, GameSceneNodeTag.Fighter)

    -- 接触事件检测
    local function touchBegan(touch, event)
        return true
    end

    local function touchMoved(touch, event)
        local node = event:getCurrentTarget()
        local currentPosX, currentPosY = node:getPosition()
        local diff = touch:getDelta()
        --    移动当前按钮精灵的坐标位置
        node:setPos(cc.p(currentPosX + diff.x, currentPosY + diff.y))
    end

    touchFighterListener = cc.EventListenerTouchOneByOne:create()
    touchFighterListener:setSwallowTouches(true)
    touchFighterListener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    touchFighterListener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)

    cc.Director
      :getInstance()
      :getEventDispatcher()
      :addEventListenerWithSceneGraphPriority(touchFighterListener, fighter)

    -- 分数
    score = 0
    --记录
    scorePlaceholder = 0
    -- 状态玩家生命值
    self:updateStatusBarFighter()
    -- 状态栏 得分
    self:updateStatusBarScore()

    return mainLayer;
end

return GamePlayScene

