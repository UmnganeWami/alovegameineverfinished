local Module = {}

local Util = require("stuff/Util")

function Module.createButton(x, y, width, height, onPressedCallback, canBeClicked, buttonText, onHoverCallback, onUnHoverCallback)
    buttonText = buttonText or "needs text."
    onHoverCallback = onHoverCallback or function()end
    onUnHoverCallback = onHoverCallback or function()end
    onPressedCallback = onPressedCallback or function()end
    if canBeClicked == nil then
        canBeClicked = true
    end
    return {
        x=x,
        y=y,
        width=width,
        height=height,
        isBeingPressed=false,
        wasPressedThisFrame=false,
        onPressedCallback=onPressedCallback,
        canBeClicked=canBeClicked,
        textObject = Util.createText(buttonText),
        onHoverCallback = onHoverCallback,
        onUnHoverCallback = onUnHoverCallback
    }
end

function Module.setCallback(button, callback)
    button.onPressedCallback = callback
end

function Module.getUnclickableColor()
    return 232-25, 248-25, 250-25
end

function Module.getclickableColor()
    return 232, 248, 250
end

function Module.renderButton(button, alpha)
    if GLOBALTIMEFORUPDATINGUI ~= button.lastTimeThinged then
        local btr, btx, bty = Util.rotatedObject()
        local ttr, ttx, tty = Util.rotatedObject()
        button.TextRenderedRotation = ttr
        button.ButtonRenderedRotation = btr

        button.TextRenderedLocationX = ttx
        button.TextRenderedLocationY = tty

        button.ButtonRenderedLocationX = btx
        button.ButtonRenderedLocationY = bty
    end
    if not button.canBeClicked then
        love.graphics.setColor(love.math.colorFromBytes(Module.getUnclickableColor()))
    else
        love.graphics.setColor(love.math.colorFromBytes(Module.getclickableColor()))
    end
    Util.renderRotatedRect(button.ButtonRenderedRotation, button.x, button.y, button.ButtonRenderedLocationX, button.ButtonRenderedLocationY, button.width, button.height)
    if button.textObject then 
        love.graphics.setColor(love.math.colorFromBytes(148, 179, 183))
        Util.renderRotatedText(button.TextRenderedRotation, button.x, button.y, button.width, button.height, button.TextRenderedLocationX, button.TextRenderedLocationY, button.textObject)
    end
    button.lastTimeThinged = GLOBALTIMEFORUPDATINGUI
end

function Module.updateButton(button, offsetStuff)
    --love.graphics.clear()
    offsetStuff = offsetStuff or {x=0, y=0}
    local btnX = button.x + offsetStuff.x
    local btnY = button.y + offsetStuff.y
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill",  btnX, btnY, button.width, button.height)
    if not button.canBeClicked then return end
    if Util.isThingInBounds(MOUSESTUFF.xPosition, MOUSESTUFF.yPosition, btnX, btnY, btnX+button.width, btnY+button.height) then
        if not button.wasHoveredLastFrame then
            button.wasHoveredLastFrame = true
            button.onHoverCallback()
        end
        if MOUSESTUFF.leftButtonJustPressed then
            --print("clicked!")
            if button.onPressedCallback then
                button.onPressedCallback()
            end
        end
    elseif button.wasHoveredLastFrame then
        button.wasHoveredLastFrame = nil
        button.onUnHoverCallback()
    end
    --love.graphics.present()
end

return Module