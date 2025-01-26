local Module = {}

local Util = require("stuff/Util")

function Module.createAnimatedSpriteSheet(path, framesInfo, x, y)
    local img, animations = Module.loadImageToSheet(path, framesInfo)
    --print(Util.tableToString(animations))
    return {
        animations = animations,
        x=x,
        y=y,
        frameTime = 0,
        curFrame = 1,
        img = img,
        curAnimation = ""
    }
end

function Module.loadImageToSheet(path, animations)
    local img = love.graphics.newImage(path)
    img:setFilter("nearest", "nearest")
    local animationzz = {}
    for i=1, #animations do
        local anim = animations[i]
        local frames = {}
        for i=1, #anim.frames do
            local fInfo = anim.frames[i]
            local nFInfo = {}
            nFInfo.time = fInfo.time
            nFInfo.quad = love.graphics.newQuad(fInfo.x, fInfo.y, fInfo.width, fInfo.height, img:getDimensions())
            frames[#frames+1] = nFInfo
        end
        animationzz[anim.name] = frames
    end
    print(Util.tableToString(animationzz))
    return img, animationzz
end

function Module.setAnimation(animation, animName)
    animation.curAnimation = animName
    animation.curFrame = 1
end

function Module.renderAnimatedSpriteSheet(animation)
    if not animation.animations[animation.curAnimation] then return end
    if not animation then return end
    if not animation.curFrame then animation.curFrame = 1 end
    local anim = animation.animations[animation.curAnimation]
    if not anim[animation.curFrame] then return end
    local animFrame = anim[animation.curFrame]
    love.graphics.draw(animation.img, animFrame.quad, animation.x, animation.y, 0, 2, 2)
end

function Module.updateAnimatedSpriteSheet(dt, animation)
    if not animation.animations[animation.curAnimation] then return end
    local anim = animation.animations[animation.curAnimation]
    animation.frameTime = animation.frameTime + dt
    if not anim[animation.curFrame] then return end
    local cFrame = anim[animation.curFrame]
    if animation.frameTime > cFrame.time*5 then
        animation.frameTime = 0
        animation.curFrame = animation.curFrame + 1
    end
    if animation.curFrame > #(anim) then animation.curFrame = 1 end

end

return Module