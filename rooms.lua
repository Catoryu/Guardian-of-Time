rooms = {}

rooms.update = function(dt)
    blocs.update(dt)
    entities.update(dt)
end

rooms.draw = function()
    --Affiche l'image de fond
    lg.setColor(255, 255, 255)
    lg.draw(src.img.bground.c1r1, room.x, room.y)
    
    --Affiche les blocs
    blocs.draw()
    
    --Affiche les entitées
    entities.draw()
end

rooms.moveCameraX = function(moveSpeed)--Bouge la caméra horizontalement
    local deltaX = 0

    --Marge d'erreur mouvement de la salle
    if room.x + moveSpeed > 0 then
        deltaX = room.x
        room.x = room.x - deltaX
        for i, e in pairs(room.entities) do
            e.x = e.x - deltaX
        end
        player.x = player.x - deltaX
        return
    elseif room.x + room.wth + moveSpeed < wdow.wth then
        deltaX = room.x + room.wth - wdow.wth
        room.x = room.x - deltaX
        for i, e in pairs(room.entities) do
            e.x = e.x - deltaX
        end
        player.x = player.x - deltaX
        return
    end

    --Bouge les entités
    for i, e in pairs(room.entities) do
        e.x = e.x + moveSpeed
    end

    --Bouge les blocs
    room.x = room.x + moveSpeed
end

rooms.moveCameraY = function(moveSpeed)--Bouge la caméra verticalement
    local deltaY = 0

    --Marge d'erreur mouvement de la salle
    if room.y + moveSpeed > 0 then
        deltaY = room.y
        room.y = room.y - deltaY
        for i, c in pairs(room.entities) do
            c.y = c.y - deltaY
        end
        player.y = player.y - deltaY
        return
    elseif room.y + room.hgt + moveSpeed < wdow.hgt then
        deltaY = room.y + room.hgt - wdow.hgt
        room.y = room.y - deltaY
        for i, c in pairs(room.entities) do
            c.y = c.y - deltaY
        end
        player.y = player.y - deltaY
        return
    end

    --Bouge les entités
    for i, e in pairs(room.entities) do
        e.y = e.y + moveSpeed
    end

    --Bouge les blocs
    room.y = room.y + moveSpeed
end