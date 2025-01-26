local Module = {}

local Util = require("stuff/Util")
local Button = require("stuff/Button")
local AnimatedSpriteSheet = require("stuff/AnimatedSpriteSheet")

function Module.createTextBox(texts, x, y, width, height)
    local extraSize = {x=400, y=100}
    local box = {
        canvasObject = love.graphics.newCanvas(width+50+extraSize.x, height+75+extraSize.y),
        textObject = Util.createText(texts[1]),
        x = x,
        y = y,
        height = height,
        width = width,
        extraSize = extraSize,
        text = texts[1],
        texts = texts,
        curText = 1,
        nextButton = Button.createButton(275, height + 75, 350, 75,  nil),
        fadingIn = true,
        fadingOut = false,
        alpha = 0,
        fadeInEnd = function(box)
            --box.nextButton.canBeClicked = true
            box.tillCanPressAgain = 1
        end,
        fadeOutEnd = function()
            Module.removeBox(box)
        end,
        characterImage = AnimatedSpriteSheet.createAnimatedSpriteSheet("assets/Images/character.png",{{name="default", frames={{time=0.100, x=0, y=0, width=64, height=64}, {time=0.100, x=64, y=0, width=64, height=64}}}}, 95, 125)
    }
    AnimatedSpriteSheet.setAnimation(box.characterImage, "default")
    box.nextButton.canBeClicked = false
    Module.setText(box.texts[1], box)
    Module.nextBoxButtonStuff(box)
    return box
end

function Module.removeBox(box)
    --box.x = 500000
    --box.y = 500000
    box.dontDraw = true
    box.dontUpdate = true
end

function Module.nextBoxButtonStuff(box)
    Button.setCallback(box.nextButton, function()
        box.curText = box.curText + 1
        if box.curText > #(box.texts) then
            box.fadingOut = true
            box.nextButton.canBeClicked = false
            return
        end
        box.text = box.texts[box.curText]
        Module.setText(box.texts[box.curText], box)
        box.nextButton.canBeClicked = false
        box.tillCanPressAgain = 1
        --box.nextButton.canBeClicked = true
    end)
end

function Module.setText(text, textbox)
    textbox.text = text
    textbox.textObject:setf(text, textbox.width-25, "left")
end

function Module.updateTextbox(textbox, dt)
    if textbox.dontUpdate then return end
    Button.updateButton(textbox.nextButton, {x=20, y=35})
    if textbox.tillCanPressAgain then
        textbox.tillCanPressAgain = textbox.tillCanPressAgain - dt
        if textbox.tillCanPressAgain <= 0 then
            textbox.tillCanPressAgain = nil
            textbox.nextButton.canBeClicked = true
        end
    end
    AnimatedSpriteSheet.updateAnimatedSpriteSheet(dt, textbox.characterImage)
end

function Module.renderTextBox(textbox)
    if textbox.dontDraw then return end
    love.graphics.push()
    love.graphics.setCanvas(textbox.canvasObject)
    love.graphics.clear()
    if not textbox.alpha and textbox.fadingIn then
        textbox.alpha = 255 / 3
    end
    if GLOBALTIMEFORUPDATINGUI ~= textbox.lastTimeThinged then
        local btr, btx, bty = Util.rotatedObject()
        local btr2, btx2, bty2 = Util.rotatedObject()
        local btr3, btx3, bty3 = Util.rotatedObject()
        local ttr, ttx, tty = Util.rotatedObject()

        local ebgr, ebgx, ebgy = Util.rotatedObject()

        textbox.fullbgr = ebgr
        textbox.fullbgx = ebgx
        textbox.fullbgy = ebgy

        textbox.TextRenderedRotation = ttr
        textbox.BackgroundRenderedRotation = btr

        textbox.BackgroundRenderedRotation2 = btr2
        textbox.BackgroundRenderedRotation3 = btr3

        textbox.TextRenderedLocationX = ttx
        textbox.TextRenderedLocationY = tty

        textbox.BackgroundRenderedLocationX = btx
        textbox.BackgroundRenderedLocationY = bty

        textbox.BackgroundRenderedLocationX2 = btx2
        textbox.BackgroundRenderedLocationY2 = bty2

        textbox.BackgroundRenderedLocationX3 = btx3
        textbox.BackgroundRenderedLocationY3 = bty3
        if textbox.fadingIn then
            textbox.alpha = textbox.alpha + 255 / 3
            if textbox.alpha >= 255 then
                textbox.alpha = 255
                textbox.fadingIn = false
                textbox.fadeInEnd(textbox)
            end
        end

        if textbox.fadingOut then
            textbox.alpha = textbox.alpha - 255 / 3
            if textbox.alpha <= 0 then
                textbox.alpha = 0
                textbox.fadingOut = false
            end
        end
        
    end
    love.graphics.setColor(love.math.colorFromBytes(222, 238, 240))
    local halfTextboxAreaW = (textbox.width + textbox.extraSize.x)
    local halfTextboxAreaH = (textbox.height + textbox.extraSize.y)
    Util.renderRotatedRect(textbox.fullbgr, 75, 5, textbox.fullbgx, textbox.fullbgy, halfTextboxAreaW-250, halfTextboxAreaH+25)


    love.graphics.setColor(love.math.colorFromBytes(232, 248, 250))
    love.graphics.translate(textbox.extraSize.x/2, textbox.extraSize.y/2)

    Util.renderRotatedRect(textbox.BackgroundRenderedRotation3, -75, -25, textbox.BackgroundRenderedLocationX3, textbox.BackgroundRenderedLocationY3, 350, 50)
    Util.renderRotatedRect(textbox.BackgroundRenderedRotation2, -75, 15 - (textbox.BackgroundRenderedRotation3*100), textbox.BackgroundRenderedLocationX2, textbox.BackgroundRenderedLocationY2, 25, 25)
    Util.renderRotatedRect(textbox.BackgroundRenderedRotation, 0, 0, textbox.BackgroundRenderedLocationX, textbox.BackgroundRenderedLocationY, textbox.width, textbox.height)
    love.graphics.pop()
    --love.graphics.translate(-textbox.extraSize.x, -textbox.extraSize.y)
    if textbox.textObject then 
        love.graphics.setColor(love.math.colorFromBytes(148, 179, 183))
        love.graphics.push()
        love.graphics.translate(textbox.extraSize.x/2, textbox.extraSize.y/2)
        Util.renderRotatedText(textbox.TextRenderedRotation, 0, 0, textbox.width, textbox.height, textbox.TextRenderedLocationX, textbox.TextRenderedLocationY, textbox.textObject)
        love.graphics.pop()
    end
    textbox.lastTimeThinged = GLOBALTIMEFORUPDATINGUI
    Button.renderButton(textbox.nextButton)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, textbox.alpha))
    love.graphics.setCanvas()
    love.graphics.push()
    love.graphics.translate(-textbox.extraSize.x/2, -textbox.extraSize.y/2)
    love.graphics.draw(textbox.canvasObject, textbox.x, textbox.y)
    love.graphics.pop()

    AnimatedSpriteSheet.renderAnimatedSpriteSheet(textbox.characterImage)
end


return Module