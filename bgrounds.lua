--Chargement du fichier qui contient tous les fonds
dofile("data/bground.lua")

bgrounds = {}

bgrounds.id = 0
bgrounds.name = ""
bgrounds.layers = {}
bgrounds.isVisible = false

bgrounds.load = function()
    room.bground = table.deepcopy(bground[bgrounds.id])
    
    --Replace correctenent les images de fond
    for i, l in pairs(room.bground.layers) do
        l.x = l.x - (-room.x * l.distanceX / 100)
        l.y = l.y - (-room.y * l.distanceY / 100)
    end
end

bgrounds.moveX = function(moveSpeed)
    for i, l in pairs(room.bground.layers) do
        l.x = l.x + (moveSpeed * l.distanceX / 100)
    end
end

bgrounds.moveY = function(moveSpeed)
    for i, l in pairs(room.bground.layers) do
        l.y = l.y + (moveSpeed * l.distanceY / 100)
    end
end

bgrounds.draw = function(isOnFront)
    if room.bground.isVisible then
        for i, l in pairs(room.bground.layers) do
            if l.isVisible and l.isOnFront == isOnFront then
                lg.draw(src.img.bground[l.image], l.x + wdow.shake.x, l.y + wdow.shake.y, l.rotation, l.sx, l.sy, l.ox, l.oy, l.kx, l.ky)
            end
        end
    end
end