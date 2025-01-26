local Module = {}

local Util = require("stuff/Util")

function Module.createShotsStuffObject()
    return {
        fullAmmoPool = {},

        getMaxChamberSize = function(obj)
            return DEFAULTCHAMBERSIZE
        end,
        getMaxReloads = function(obj)
            return 4
        end,
        ammoPool = {},
        chamberPool = {},
        reloadChamber = function(obj)
            for i = 1, obj.getMaxChamberSize() do
                --local randomBullet = obj.chamberPool[love.math.random(1, #obj.chamberPool)]
                local randomBulletIND = love.math.random(1, #obj.ammoPool)
                local randomBullet = obj.ammoPool[randomBulletIND]
                obj.chamberPool[#obj.chamberPool+1] = Util.tableclone(randomBullet)
                table.remove(obj.ammoPool, randomBulletIND)
            end
            obj.chamberPool = Util.tableshuffle(obj.chamberPool)
        end,
        showCurrentAmmoPoolAmount = function(obj)
            return "AMMO POOL: " .. tostring(#(obj.ammoPool)) .. "/" .. tostring(#(obj.fullAmmoPool))
        end,
        showCurrentChamberPoolAmount = function(obj)
            return "CHAMBER: " .. tostring((#(obj.chamberPool))) .. "/" .. tostring(obj.getMaxChamberSize())
        end,

        removeBulletFromChamberButReturnIt = function(obj, bulletInd)
            local blt = Util.tableclone(obj.chamberPool[bulletInd])
            table.remove(obj.chamberPool, bulletInd)
            return blt
        end

    }
end

return Module