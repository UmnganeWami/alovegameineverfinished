local Module = {}

function Module.isThingInBounds(t1x1, t1y1, t2x1, t2y1, t2x2, t2y2)
    return  ((t1x1 > t2x1 and t1x1 < t2x2) and (t1y1 > t2y1 and t1y1 < t2y2))
end

function Module.tableclone(orig)
    local function _tableclone(orig)end
    _tableclone = function(orig)
        local orig_type = type(orig)
        local copy = {}
        if orig_type == 'table' then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                copy[_tableclone(orig_key)] = _tableclone(orig_value)
            end
            setmetatable(copy, _tableclone(getmetatable(orig)))
        else -- number, string, boolean, etc
            copy = orig
        end
        return copy
    end
    return _tableclone(orig)
end

function Module.tableshuffle(tbl)
    for i = #tbl, 2, -1 do
      local j = math.random(i)
      tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
  end

Module.defaultFont = love.graphics.newFont("assets/comicsans.ttf", 25)
Module.defaultFont:setFilter("nearest")

function Module.createText(text)
    text = text or "DEFAULT TEXT"
    local textObj = love.graphics.newText( Module.defaultFont, text)
    
    return textObj
end

function Module.randomFloat(min, max, precision)
	local range = max - min
	local offset = range * math.random()
	local unrounded = min + offset

	if not precision then
		return unrounded
	end

	local powerOfTen = 10 ^ precision
	return math.floor(unrounded * powerOfTen + 0.5) / powerOfTen
end

function Module.rotatedObject()
    --[[button.TextRenderedRotation = Util.randomFloat( -0.05, 0.05, 3 )
    button.ButtonRenderedRotation = Util.randomFloat( -0.05, 0.05, 3 )

    button.TextRenderedLocationX = Util.randomFloat(-0.5, 0.5, 3)
    button.TextRenderedLocationY = Util.randomFloat(-0.5, 0.5, 3)

    button.ButtonRenderedLocationX = Util.randomFloat(-0.5, 0.5, 3)
    button.ButtonRenderedLocationY = Util.randomFloat(-0.5, 0.5, 3)]]
    return Module.randomFloat(-0.05, 0.05, 3), Module.randomFloat(-0.05, 0.05, 3), Module.randomFloat(-0.05, 0.05, 3)
end

function Module.rotateAndPlace(rotation, x, y)
    x = math.floor(x)
    y = math.floor(y)
    love.graphics.translate(x, y)
    love.graphics.rotate(rotation)
end

function darkenABit(r, g, b)
    return r - 0.1, g - 0.1, b - 0.1
end

function Module.renderRotatedRect(rotation, x, y, px, py, width, height)
    x = math.floor(x)
    y = math.floor(y)
    love.graphics.push()
    local halfButtonBoxW = width / 2
    local halfButtonBoxH = height / 2
    Module.rotateAndPlace(rotation, (x+px)+halfButtonBoxW, (y+py)+halfButtonBoxH)
    if SHADOWSTUFF.doRender then
        r, g, b = love.graphics.getColor()
        local dr, dg, db = darkenABit(r, g, b)
        love.graphics.setColor(love.math.colorFromBytes(dr*255, dg*255, db*255))
        love.graphics.translate(SHADOWSTUFF.offet.x, SHADOWSTUFF.offet.y)
        love.graphics.rectangle("fill", -halfButtonBoxW, -halfButtonBoxH, width, height)
        love.graphics.translate(-SHADOWSTUFF.offet.x, -SHADOWSTUFF.offet.y)
        love.graphics.setColor(love.math.colorFromBytes(r*255, g*255, b*255))
    end
    love.graphics.rectangle("fill", -halfButtonBoxW, -halfButtonBoxH, width, height)
    love.graphics.pop()
    --Module.rotateAndPlace(-rotation, -((x+px)+halfButtonBoxW), -((y+py)+halfButtonBoxH))
end

function Module.tableToString(v, spaces, usesemicolon, depth)
	if type(v) ~= 'table' then
		return tostring(v)
	elseif not next(v) then
		return '{}'
	end

	spaces = spaces or 4
	depth = depth or 1

	local space = (" "):rep(depth * spaces)
	local sep = usesemicolon and ";" or ","
	local s = "{"

	for k, x in next, v do
		s = s..("\n%s[%s] = %s%s"):format(space,type(k)=='number'and tostring(k)or('"%s"'):format(tostring(k)), Module.tableToString(x, spaces, usesemicolon, depth+1), sep)
	end

	return ("%s\n%s}"):format(s:sub(1,-2), space:sub(1, -spaces-1))
end

function Module.renderRotatedText(rotation, x, y, bw, bh, px, py, textObject)
    love.graphics.push()
    local twidth, theight = textObject:getDimensions()
    local halfButtonBoxW = bw / 2
    local halfButtonBoxH = bh / 2
    local hTextHeight = theight / 2
    local hTextWidth = twidth / 2
    Module.rotateAndPlace(rotation, (x+px)+halfButtonBoxW, (y+py)+halfButtonBoxH)
    --love.graphics.rectangle("fill", 0, 0, 50, 50)
    --Module.rotateAndPlace(rotation, (x+px)+halfButtonBoxW+hTextWidth, (y+py)+halfButtonBoxH+hTextHeight)
    --Module.rotateAndPlace(rotation, x, y)
    --love.graphics.draw(textObject, -hTextWidth, -hTextHeight)
    love.graphics.draw(textObject, -hTextWidth, -hTextHeight)

    --Module.rotateAndPlace(rotation, -((x+px)+halfButtonBoxW), -((y+py)+halfButtonBoxH))
    love.graphics.pop()
end

return Module