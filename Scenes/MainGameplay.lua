local Module = {}

local ShotsStuff = require("stuff/ShotsStuff")
local Button = require("stuff/Button")
local Util = require("stuff/Util")
local TextLabel = require("stuff/TextLabel")
local TextBox = require("stuff/TextBox")
local AnimatedSpriteSheet = require("stuff/AnimatedSpriteSheet")

local shotsStuffObject = ShotsStuff.createShotsStuffObject()
local ShootAirButton = Button.createButton(20, WINDOWINFO.height-(20+50), 140, 50, nil, true, "Shoot Air")
local ShootPersonButton = Button.createButton(20+140+20, WINDOWINFO.height-(20+50), 170, 50, nil, true, "Shoot Person")

local AmmoCounter = TextLabel.createTextlabel(20, 20, 250, 50, "meow")
local ChamberCounter = TextLabel.createTextlabel(20, 50+20+20, 200, 50, "meow")
local OtherPersonHealthBar = TextLabel.createTextlabel(WINDOWINFO.width-(10+10+180), 20, 180, 50, "meow")
local hasPushedValuesIntoRound = false

local textBoxLol = TextBox.createTextBox({"meow", "meowmeowmeow", "meowmeowmeowmowe"}, 200+10+10, WINDOWINFO.height-(20+375), 425, 175)

local otherPersonHealth = 5
local otherPersonMaxHealth = 5

local MUSIC = love.audio.newSource("assets/Songs/idk what this feeling is, its just kinda there and im feeling it and its nice.ogg", "stream")
local MUSICASAREALLYSLOWEDDOWNTHINGY = love.audio.newSource("assets/Songs/idk what this feeling is, its just kinda there and im feeling it and its nice.ogg", "stream")
local animatedBG = nil


local disableButtonsTimer = nil
shouldReloadNextTimerEnd = nil

function Module.createAnimatedBG()
    local thng = AnimatedSpriteSheet.createAnimatedSpriteSheet("assets/Images/shootie.png", 
        {
            {
                name="lookat", 
                frames=
                {
                    {time=0.1, x=2880+75, y=100, width=720, height=480},{time=0.1, x=4320+75, y=100, width=720, height=480}
                }
            },
            {
                name="aimat", 
                frames=
                {
                    {time=0.1, x=75, y=100, width=720, height=480},{time=0.1, x=1440+75, y=100, width=720, height=480}
                }
            }
        }
    )
    AnimatedSpriteSheet.setAnimation(thng, "lookat")
    return thng
end

function Module.getOtherPlayerHealthText()
    return "HEALTH: " .. tostring(otherPersonHealth) .. "/" .. tostring(otherPersonMaxHealth)
end

function Module.init()
    animatedBG = Module.createAnimatedBG()
    MUSIC:setVolume(0)
    MUSIC:setPitch(0.85)

    MUSICASAREALLYSLOWEDDOWNTHINGY:setVolume(0.15)
    MUSICASAREALLYSLOWEDDOWNTHINGY:setPitch(0.45)

    MUSIC:play()
    MUSICASAREALLYSLOWEDDOWNTHINGY:play()

    shotsStuffObject.ammoPool = Util.tableclone(CURRENTSTUFFTHATNEEDSTOBEKEPT.ammopool)
    shotsStuffObject.fullAmmoPool = Util.tableclone(CURRENTSTUFFTHATNEEDSTOBEKEPT.ammopool)
    shotsStuffObject.reloadChamber(shotsStuffObject)
    Button.setCallback(ShootAirButton, function() Module.shootThing(false) end)
    Button.setCallback(ShootPersonButton, function() Module.shootThing(true) end)
    ShootPersonButton.onHoverCallback = function()
        AnimatedSpriteSheet.setAnimation(animatedBG, "aimat")
    end
    ShootPersonButton.onUnHoverCallback = function()
        AnimatedSpriteSheet.setAnimation(animatedBG, "lookat")
    end
end

function Module.shootThing(isPerson)
    local blt = shotsStuffObject.removeBulletFromChamberButReturnIt(shotsStuffObject, #(shotsStuffObject.chamberPool))
    
    if blt.isWrongBullet and isPerson then
        print("you shot them with a dud.")
    elseif not blt.isWrongBullet and not isPerson then
        print("shot the air with a bullet! what a waste...")
    elseif not blt.isWrongBullet and isPerson then
        print("you shot them with a bullet! good job!")
    elseif blt.isWrongBullet and not isPerson then
        print("you shot the air with a bad bullet! good job!")
    end
    
    if #(shotsStuffObject.chamberPool) <= 0 then
        shouldReloadNextTimerEnd = true
        disableButtonsTimer = 2
    else
        disableButtonsTimer = 1
    end
    ShootAirButton.canBeClicked = false
    ShootPersonButton.canBeClicked = false
    --end
end

function Module.update(dt)
    if not hasPushedValuesIntoRound then
        Module.init()
        hasPushedValuesIntoRound = true
        return
    end
    if not MUSICASAREALLYSLOWEDDOWNTHINGY:isPlaying() then
        MUSIC:play()
        MUSICASAREALLYSLOWEDDOWNTHINGY:play()
    end
    if not shotsStuffObject then return end
    Button.updateButton(ShootAirButton)
    Button.updateButton(ShootPersonButton)
    TextLabel.updateText(AmmoCounter, shotsStuffObject.showCurrentAmmoPoolAmount(shotsStuffObject))
    TextLabel.updateText(ChamberCounter, shotsStuffObject.showCurrentChamberPoolAmount(shotsStuffObject))
    TextLabel.updateText(OtherPersonHealthBar, Module.getOtherPlayerHealthText())
    TextBox.updateTextbox(textBoxLol, dt)
    if disableButtonsTimer then
        disableButtonsTimer = disableButtonsTimer - dt
        if disableButtonsTimer <= 0 then
            disableButtonsTimer = nil
            ShootAirButton.canBeClicked = true
            ShootPersonButton.canBeClicked = true
            if shouldReloadNextTimerEnd then
                shotsStuffObject.reloadChamber(shotsStuffObject)
            end
        end
    end
    love.graphics.setColor(255, 255, 255)
    AnimatedSpriteSheet.updateAnimatedSpriteSheet(dt, animatedBG)
end

function Module.draw()
    AnimatedSpriteSheet.renderAnimatedSpriteSheet(animatedBG)
    Button.renderButton(ShootAirButton)
    Button.renderButton(ShootPersonButton)
    TextLabel.renderTextLabel(AmmoCounter)
    TextLabel.renderTextLabel(ChamberCounter)
    TextLabel.renderTextLabel(OtherPersonHealthBar)
    TextBox.renderTextBox(textBoxLol)
end

return Module