local Module = {}

local Util = require("stuff/Util")

function Module.createBullet(type)
    local bulletInfo = {
        damage = 1
    }
    if type == "unobtainum" then
        bulletInfo.damage = 25
    elseif type == "dud" then
        bulletInfo.damage = 0
        bulletInfo.isWrongBullet = true
    else
        --must be a regular bullet.
    end
    bulletInfo.type = type
    return bulletInfo
end

function Module.createDefaultAmmoPool()
    local bulletsss = {}
    for i = 1, DEFAULTAMMOCOUNT do
        local bulletType = "dud"
        if i%2 == 1 then
            bulletType = "bullet"
        end
        local nBullet = Module.createBullet(bulletType)
        bulletsss[#bulletsss + 1] = nBullet
    end
    bulletsss = Util.tableshuffle(bulletsss)
    return bulletsss
end

return Module