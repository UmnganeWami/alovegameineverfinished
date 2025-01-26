local Module = {}

local Button = require("stuff/Button")
local function onButtonPressed()
    print('button was pressed! conga rats on pressing it!')
end
local tstButton = Button.createButton(0, 0, 150, 75, onButtonPressed)



function Module.update(dt)
    Button.updateButton(tstButton)
end

function Module.draw()
    Button.renderButton(tstButton)
end

return Module