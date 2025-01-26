local Bullet = require("stuff/Bullet")
MOUSESTUFF = 
{
    leftButtonPressed = false,
    rightButtonPressed = false,
    leftButtonJustPressed = false,
    rightButtonJustPressed = false,
    xPosition = 0,
    yPosition = 0
}

WINDOWINFO = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

SCENESTUFFS = {
    curDraw = nil,
    curUpdate = nil
}

GLOBALTIMEFORUPDATINGUI = 0

CURRENTSTUFFTHATNEEDSTOBEKEPT = {
    ammopool = {}--,
    --chamberCount = 8
}

DEFAULTAMMOCOUNT = 32
DEFAULTCHAMBERSIZE = 8

SHADOWSTUFF = {
    doRender = true,
    offet = {
        x=5,
        y=5
    }
}
--[[FONTSATDIFFERENTSIZES = {

}

function createDifferentSizedFonts()

end]]

local TestScene = require("Scenes/Testing")
local MainGameplayScene = require("Scenes/MainGameplay")
local Util = require("stuff/Util")

function loadScene(scene)
    local nScene = Util.tableclone(scene)
    SCENESTUFFS.curDraw = nScene.draw
    SCENESTUFFS.curUpdate = nScene.update
end

function love.mousepressed(x, y, button, istouch, presses)
    --print("pressed mous")
    --print(button)
    if  button == 1 then
        MOUSESTUFF.leftButtonPressed = true
        MOUSESTUFF.leftButtonJustPressed = true
    end
    if  button == 2 then
        MOUSESTUFF.leftButtonPressed = true
        MOUSESTUFF.leftButtonJustPressed = true
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    --print("released mous")
    --print(button)
    if  button == 1 then
        MOUSESTUFF.leftButtonPressed = false
        MOUSESTUFF.leftButtonJustPressed = false
    end
    if  button == 2 then
        MOUSESTUFF.leftButtonPressed = false
        MOUSESTUFF.leftButtonJustPressed = false
    end
end

function initDefaultGameValues()
    CURRENTSTUFFTHATNEEDSTOBEKEPT.ammopool = Bullet.createDefaultAmmoPool()
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    initDefaultGameValues()
    loadScene(MainGameplayScene)
    assert(love.graphics.getSupported("canvas"), "Your graphics card does not support canvases, sorry!")
end


function love.draw()
    love.graphics.clear()
    if SCENESTUFFS.curUpdate then
        SCENESTUFFS.curDraw()
    end
end

local function preUpdate(dt)
    local nTime = os.clock()
    GLOBALTIMEFORUPDATINGUI = nTime - (nTime%0.75)
    local x, y = love.mouse.getPosition()
    MOUSESTUFF.xPosition = x
    MOUSESTUFF.yPosition = y
    if not WINDOWINFO.width or not WINDOWINFO.height then
        WINDOWINFO.width = love.graphics.getWidth()
        WINDOWINFO.height = love.graphics.getHeight()
    end
end

local function postUpdate(dt)
    if MOUSESTUFF.leftButtonJustPressed and MOUSESTUFF.leftButtonPressed then
        MOUSESTUFF.leftButtonJustPressed = false
    end
    if MOUSESTUFF.rightButtonJustPressed and MOUSESTUFF.rightButtonPressed then
        MOUSESTUFF.rightButtonJustPressed = false
    end
end

function love.update(dt)
    preUpdate(dt)
    if SCENESTUFFS.curUpdate then
        SCENESTUFFS.curUpdate(dt)
    end
    postUpdate(dt)
end