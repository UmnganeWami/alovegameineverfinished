local Module = {}

local Util = require("stuff/Util")

function Module.createTextlabel(x, y, width, height, text)
    return {
        x = x,
        y = y,
        width = width,
        height = height,
        textObject = Util.createText(text)
    }

end

function Module.updateText(label, text)
    label.textObject:set(text)
end

function Module.renderTextLabel(label)
    if GLOBALTIMEFORUPDATINGUI ~= label.lastTimeThinged then
        local btr, btx, bty = Util.rotatedObject()
        local ttr, ttx, tty = Util.rotatedObject()
        label.TextRenderedRotation = ttr
        label.BackgroundRenderedRotation = btr

        label.TextRenderedLocationX = ttx
        label.TextRenderedLocationY = tty

        label.BackgroundRenderedLocationX = btx
        label.BackgroundRenderedLocationY = bty
    end
    love.graphics.setColor(love.math.colorFromBytes(232, 248, 250))
    Util.renderRotatedRect(label.BackgroundRenderedRotation, label.x, label.y, label.BackgroundRenderedLocationX, label.BackgroundRenderedLocationY, label.width, label.height)
    if label.textObject then 
        love.graphics.setColor(love.math.colorFromBytes(148, 179, 183))
        Util.renderRotatedText(label.TextRenderedRotation, label.x, label.y, label.width, label.height, label.TextRenderedLocationX, label.TextRenderedLocationY, label.textObject)
    end
    label.lastTimeThinged = GLOBALTIMEFORUPDATINGUI
end

return Module